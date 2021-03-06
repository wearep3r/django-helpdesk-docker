#!/bin/bash
#set -e

# Wait for DB to come up
echo "Waiting for postgres..."
while !</dev/tcp/db/5432; do sleep 1; done;
echo "Postgres started"

if [ "$SKIP_MIGRATIONS" == "1" ];
then
  echo "Seems like I'm a CRON instance."
  echo "Waiting for main django-helpdesk application to become ready..."
  while !</dev/tcp/django-helpdesk/8000; do sleep 5; done;
  echo "django-helpdesk started"
fi

if [ ! -f "django_helpdesk/_settings.py" ]; then
  echo "Creating django_helpdesk"
  django-admin startproject django_helpdesk /app

  # Run Migrations
  python manage.py migrate

  mv /app/django_helpdesk/settings.py /app/django_helpdesk/_settings.py
  cp /app/settings.py /app/django_helpdesk/settings.py
  cp /app/urls.py /app/django_helpdesk/urls.py

  # Run Migrations
  python manage.py migrate helpdesk

  #chown www-data:www-data attachments/
  #chmod 700 attachments
else
  echo "django_helpdesk already exists"
fi

if [ "$SKIP_MIGRATIONS" != "1" ];
then
  # Collect static files
  echo "Collecting static files"
  python manage.py collectstatic --noinput

  # Run Migrations
  python manage.py makemigrations
  python manage.py migrate

  # if [ -n "$DJANGO_SUPERUSER_USERNAME" ] && [ -n "$DJANGO_SUPERUSER_PASSWORD" ] ; then
  #     (cd /app; python manage.py createsuperuser --username $DJANGO_SUPERUSER_USERNAME --no-input)
  # fi
fi

# Correct media permissions
echo "Correcting media permissions"
chmod 0777 /app/media

# Copy helpdesk module
#echo "Copying helpdesk"
#export PYTHONPATH="$PWD/django_helpdesk/helpdesk:$PYTHONPATH"
#cp -r helpdesk/helpdesk django_helpdesk/helpdesk

exec "$@"
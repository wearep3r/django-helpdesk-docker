ARG DOCKER_BASE_IMAGE
FROM ${DOCKER_BASE_IMAGE:-python:2-slim}

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    python2-dev \
    git \
    cron \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /app

#COPY cronjob /etc/cron.d/django-helpdesk

RUN touch /var/log/cron.log

WORKDIR /app

#RUN git clone -b 0.2.x https://github.com/django-helpdesk/django-helpdesk.git helpdesk

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

COPY . .

RUN git submodule init \
    && git submodule update

EXPOSE 8000

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "gunicorn", "--chdir", "/app", "--bind", ":8080", "helpdesk.wsgi:application" ]

LABEL maintainer="Fabian Peter <fabian@peter.saarland>"
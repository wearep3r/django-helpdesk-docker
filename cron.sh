while true; 
do 
  # Collecting mails every minute
  python /app/manage.py get_email; 

  # Correcting volume permissions
  # files are served by nginx in separate container
  # user nginx has id 101
  chown 101:101 /app/media -R

  # Setting escalations
  /app/manage.py escalate_tickets
  /app/manage.py create_escalation_exclusions --days saturday,sunday
  sleep 60; 
done
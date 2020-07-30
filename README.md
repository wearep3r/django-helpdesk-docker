# Django Helpdesk

## Prerequisites

- git
- make
- docker-compose
- Docker

## Get Started

```bash
git clone https://gitlab.com/peter.saarland/django-helpdesk/
make run
```

INFO: `make help` displays available commands

## URLs

- Helpdesk: [http://localhost:8000](http://localhost:8000)
- Admin Dashboard: [http://localhost:8000/admin](http://localhost:8000/admin)

## Build

`make build`

## Develop

`make dev`

## Create superuser

```bash
make dev
python manage.py createsuperuser
```

## Start (Background)

`make up`

## Stop

`make stop`

## Official Docker image

A pre-built Docker image of django-helpdesk can be pulled from [registry.gitlab.com/peter.saarland/django-helpdesk:latest](registry.gitlab.com/peter.saarland/django-helpdesk:latest).
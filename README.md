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

## Development

### Build

`make build`

### Develop

`make dev`

### Start (Foreground)

```bash
make build
make run
```

## Start (Background)

```bash
make build
make up
```

## Create superuser

To create a superuser, the stack needs to be running, so make sure to run `make run` or `make up` before.

```bash
make superuser
```

## Stop

```bash
make stop
```

## Official Docker image

A pre-built Docker image of django-helpdesk can be pulled from [registry.gitlab.com/peter.saarland/django-helpdesk:latest](registry.gitlab.com/peter.saarland/django-helpdesk:latest).

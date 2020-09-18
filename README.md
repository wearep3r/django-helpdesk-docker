# Django Helpdesk

## Prerequisites

- git
- make
- docker-compose
- Docker

## Get Started

```bash
git clone --recursive https://gitlab.com/p3r.one/django-helpdesk/
make build
make dev
```

INFO: `make help` displays available commands

## URLs

- Helpdesk: [http://localhost:8000](http://localhost:8000)
- Admin Dashboard: [http://localhost:8000/admin](http://localhost:8000/admin)

## Development

Make changes as required to the code or the `helpdesk` module located in `./helpdesk/helpdesk`. The helpdesk module can be updated from upstream like this:

```bash
git submodule update
```

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

A pre-built Docker image of django-helpdesk can be pulled from [registry.gitlab.com/p3r.one/django-helpdesk:latest](registry.gitlab.com/p3r.one/django-helpdesk:latest).

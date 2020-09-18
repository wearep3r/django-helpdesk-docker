# Django Helpdesk

[!["Maintained"](https://img.shields.io/maintenance/yes/2020?color=green)](https://github.com/wearep3r/django-helpdesk-docker)
[!["Version"](https://img.shields.io/github/v/tag/wearep3r/django-helpdesk-docker?label=version)](https://github.com/wearep3r/django-helpdesk-docker)
[!["License"](https://img.shields.io/github/license/wearep3r/django-helpdesk-docker)](https://github.com/wearep3r/django-helpdesk-docker)
[!["p3r. Slack"](https://img.shields.io/badge/slack-@wearep3r/general-purple.svg?logo=slack&label=Slack)](https://join.slack.com/t/wearep3r/shared_invite/zt-d9ao21f9-pb70o46~82P~gxDTNy_JWw)
[!["GitLab Stars"](https://img.shields.io/badge/dynamic/json?color=orange&label=GitLab%20stars&query=%24.star_count&url=https%3A%2F%2Fgitlab.com%2Fapi%2Fv4%2Fprojects%2F20243817)](https://gitlab.com/p3r.one/django-helpdesk)
[!["GitHub Stars"](https://img.shields.io/github/stars/wearep3r/django-helpdesk-docker?logo=github)](https://github.com/wearep3r/django-helpdesk-docker)

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

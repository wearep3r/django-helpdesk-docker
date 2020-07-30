SHELL := bash
.ONESHELL:
#.SILENT:
.SHELLFLAGS := -eu -o pipefail -c
#.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.DEFAULT_GOAL := help

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
APP_NAME ?= $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
.RECIPEPREFIX = >

DOCKER_SHELLFLAGS ?= run --rm -it --name django-helpdesk -e DEVELOPMENT=1 -v ${PWD}:/app django-helpdesk:latest

export DOCKER_BUILDKIT=1

.PHONY: help
help: ## Display help
>	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Development
.PHONY: build 
build: ## Build Helpdesk Docker image
> @docker build --pull -t django-helpdesk .

.PHONY: dev
#dev: .SHELLFLAGS = ${DOCKER_SHELLFLAGS}
#dev: SHELL := docker
dev: ## Run Helpdesk Docker image and enter bash
#> @docker-compose run django-helpdesk bash
> @docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

.PHONY: run
run:  ## Run Helpdesk Stack (Foreground)
> @docker-compose up --remove-orphans 

.PHONY: up
up:  ## Run Helpdesk Stack (Background)
> @docker-compose up --remove-orphans -d

.PHONY: superuser
superuser: ## Create Superuser
> @docker-compose run django-helpdesk python manage.py createsuperuser

.PHONY: stop
stop: ## Stop Helpdesk Stack
> @docker-compose stop

.PHONY: clean
clean: ## Remove Helpdesk Stack (volumes excluded, they stay untouched)
> @docker-compose down --remove-orphans --rmi local
> @rm -rf django_helpdesk manage.py


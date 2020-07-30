ARG DOCKER_BASE_IMAGE
FROM ${DOCKER_BASE_IMAGE:-python:3-slim}

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

USER root

RUN apt-get update && apt-get install -y  --no-install-recommends \
    python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /app

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

COPY . .

EXPOSE 8000

ENTRYPOINT ["/docker-entrypoint.sh"]

# CMD [ "gunicorn", "--chdir", "/app", "--bind", ":8080", "helpdesk.wsgi:application" ]

LABEL maintainer="Fabian Peter <fabian@peter.saarland>"
# Identidock

Updated version of `identidock` mentioned in "_Chapter 8 - Continuous Integration and Testing with Docker_" [Using Docker](https://www.amazon.com/Using-Docker-Developing-Deploying-Containers/dp/1491915765/ref=sr_1_1?ie=UTF8&qid=1520226136&sr=8-1&keywords=using-docker) by Adrian Mouat.

Changes from original:

- Use `HEALTHCHECK CMD` in Dockerfile to determine if app is healthy
- Build checks docker health status for `healthy`
- Rename `jenkins.yml` to `docker-compose.ci.yml` to comply with newer standards
- Update jenkins' docker engine from `docker-machine` to `docker-ce`


# Quick Start

Build and start services:

    docker-compose up --build -d

Check status:

    docker ps

Run unit tests only:

    docker-compose run --no-deps --rm -e ENV=UNIT identidock

# Identidock

Changes from original --Chapter 8. Continuous Integration and Testing with Docker--

- Use `HEALTHCHECK CMD` in Dockerfile to determine if app is healthy
- Check docker health status for `healthy`
- Rename `jenkins.yml` to `docker-compose.ci.yml` to comply with newer standards
- Update jenkins' docker engine from `docker-machine` to `docker-ce`
-
#!/usr/bin/env sh
set -x

docker -v
docker-compose -v
docker-compose build --no-cache
docker-compose up -d

# Unit Tests
docker-compose run --no-deps --rm -e ENV=UNIT identidock

# System Test
IS_HEALTHY=1

for i in `seq 1 12`; do
  STATUS=`docker inspect --format='{{index .State.Health.Status}}' ${COMPOSE_PROJECT_NAME}_identidock_1`
  case ${STATUS} in
    healthy)
      IS_HEALTHY=0
      break
      ;;
    unhealthy)
      break
      ;;
    *)
      sleep 10
      ;;
  esac
done

if [ ${IS_HEALTHY} -eq 0 ]; then
  echo "Healthcheck passed!"
else
  docker-compose logs redis
  docker-compose logs dnmonster
  docker-compose logs identidock
fi

exit ${IS_HEALTHY}

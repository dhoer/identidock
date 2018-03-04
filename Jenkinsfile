#!groovy
pipeline {
  agent any
  environment {
    COMPOSE_ARGS=" -f docker-compose.ci.yml -p jenkins "
  }
  options {
    ansiColor('xterm')
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }
  stages {
    stage('Init') {
      steps {
        sh """
          env | sort
          docker-compose -v
          sudo env | sort
          sudo docker-compose $COMPOSE_ARGS down
          ls -al
        """
      }
    }
    stage('Build') {
      steps {
        sh 'sudo docker-compose $COMPOSE_ARGS build --no-cache'
        sh 'sudo docker-compose $COMPOSE_ARGS up -d'
      }
    }
    stage('Unit Tests') {
      steps {
        sh 'ls -al'
        sh 'sudo docker-compose $COMPOSE_ARGS run --no-deps --rm -e ENV=UNIT identidock'
      }
    }
    stage('System Test') {
      steps {
        sh """
          sudo docker ps

          # validate web status healthy
          IS_HEALTHY=1

          for i in `seq 1 12`; do
            STATUS=`sudo docker inspect --format='{{index .State.Health.Status}}' jenkins_identidock_1`
            case \${STATUS} in
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

          if [ \${IS_HEALTHY} -eq 0 ]; then
            echo "Healthcheck passed!"
          else
            sudo docker-compose $COMPOSE_ARGS logs redis
            sudo docker-compose $COMPOSE_ARGS logs dnmonster
            sudo docker-compose $COMPOSE_ARGS logs identidock
          fi

          # pull down the system
          sudo docker-compose $COMPOSE_ARGS down

          exit \${IS_HEALTHY}
        """
      }
    }
  }
}

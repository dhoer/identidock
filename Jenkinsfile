#!groovy
pipeline {
  agent any
  environment {
    COMPOSE_FILE = "docker-compose.ci.yml"
    COMPOSE_PROJECT_NAME = "identidock${BRANCH_NAME}"
  }
  stages {
    stage('Init') {
      steps {
        sh """
          docker-compose -v
          docker-compose down
        """
      }
    }
    stage('Build') {
      steps {
        sh 'docker-compose build --no-cache'
      }
    }
    stage('Test') {
      steps {
        sh """
          docker-compose up -d

          # validate web status healthy
          IS_HEALTHY=1

          for i in `seq 1 12`; do
            STATUS=`docker inspect --format='{{index .State.Health.Status}}' \${COMPOSE_PROJECT_NAME}_app_1`
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
            docker-compose logs
          fi

          # pull down the system
          docker-compose down

          exit \${IS_HEALTHY}
        """
      }
    }
  }
}

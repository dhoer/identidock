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
          env | sort
          docker-compose -v
          sudo docker-compose down
        """
      }
    }
    stage('Build') {
      steps {
        sh 'sudo docker-compose build --no-cache'
      }
    }
    stage('Test') {
      steps {
        sh """
          sudo docker-compose up -d

          docker ps
          
          # validate web status healthy
          IS_HEALTHY=1

          for i in `seq 1 12`; do
            STATUS=`sudo docker inspect --format='{{index .State.Health.Status}}' \${COMPOSE_PROJECT_NAME}_app_1`
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
            sudo docker-compose logs
          fi

          # pull down the system
          sudo docker-compose down

          exit \${IS_HEALTHY}
        """
      }
    }
  }
}

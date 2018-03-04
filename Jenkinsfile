#!groovy
pipeline {
  agent any
  environment {
    COMPOSE_FILE = "docker-compose.ci.yml"
    COMPOSE_PROJECT_NAME = "jenkins"
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
          sudo docker-compose down
          echo $pwd
        """
      }
    }
    stage('Build') {
      steps {
        sh 'sudo docker-compose build --no-cache'
        sh 'sudo docker-compose up -d'
      }
    }
    stage('Unit Tests') {
      steps {
        sh 'echo $pwd'
        sh 'sudo docker-compose run --no-deps --rm -e ENV=UNIT identidock'
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
            sudo docker-compose logs redis
            sudo docker-compose logs dnmonster
            sudo docker-compose logs identidock
          fi

          # pull down the system
          sudo docker-compose down

          exit \${IS_HEALTHY}
        """
      }
    }
  }
}

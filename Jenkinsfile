#!groovy
pipeline {
  agent any
  environment {
    RELEASE = "1.0.${BUILD_ID}"
    IMAGE_NAME = 'dhoer/identidock'
    COMPOSE_FILE = 'docker-compose.ci.yml'
    COMPOSE_PROJECT_NAME = 'identidock{BRANCH_NAME}'
  }
  options {
    ansiColor('xterm')
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '20'))
  }
  stages {
    stage('Pre') {
      steps {
        sh 'docker -v'
        sh 'docker-compose -v'
        sh 'env | sort'
      }
    }
    stage('Build') {
      steps {
        sh 'sudo -E ./build.sh'
        sh 'sudo -E docker-compose ps'
      }
    }
    stage('Deploy') {
      when {
        branch 'never'
      }
      steps {
        withCredentials([[$class: 'FileBinding', credentialsId: 'DOCKER_HUB', variable: 'CREDS']]) {
          sh '''
            mkdir -p .docker
            cat ${CREDS} > .docker/config.json

            # tag image
            docker tag ${COMPOSE_PROJECT_NAME}_app ${IMAGE_NAME}:latest
            docker tag ${COMPOSE_PROJECT_NAME}_app ${IMAGE_NAME}:${RELEASE}

            # image push
            docker --config=.docker/ push ${IMAGE_NAME}:${RELEASE}
            docker --config=.docker/ push ${IMAGE_NAME}:latest
          '''
        }
      }
    }
  }
  post {
    always {
      sh 'sudo -E docker-compose down || true'
    }
  }

}

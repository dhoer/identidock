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
    stage('Build') {
      steps {
        sh 'sudo -E ./build.sh'
      }
    }
  }
}

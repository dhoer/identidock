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
    stage('Pre') {
      steps {
        sh 'sudo -E docker-compose down'
      }
    }
    stage('Build') {
      steps {
        sh 'sudo -E ./build.sh'
      }
    }
    stage('Post') {
      steps {
        sh 'sudo -E docker-compose down'
      }
    }
    stage('Deploy') {
      when {
        branch 'master'
      }
      steps {
        sh 'sudo -E ./build.sh'
      }
    }
  }
}

pipeline {
  agent {
    node {
      label 'ibmi7.2-debug'
    }

  }
  stages {
    stage('test') {
      steps {
          sh "echo run tests"
      }
    }
  }

  post {
    always {
      sh 'python3.6 cpython-to-junit.py'
      junit 'test-results.xml'
    }
  }
}

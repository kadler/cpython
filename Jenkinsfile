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
          sh "touch test-results.xml"
      }
    }
  }

  post {
    always {
      sh 'python3.6 cpython-to-junit.py'
      xunit (
        tools: [ Custom(pattern: 'test-results.xml') ]
      )
    }
  }
}

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
      xunit (
        tools: [ Custom(pattern: 'test-results.xml', customXSL: 'cpython-xml-to-xunit.xsl') ]
      )
    }
  }
}

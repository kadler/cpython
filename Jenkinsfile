pipeline {
  agent {
    node {
      label 'ibmi'
    }

  }
  stages {
    stage('configure') {
      steps {
        sh '''configure --with-gcc --with-threads --with-system-expat --with-system-ffi --with-ensurepip=no --with-tcltk-includes="$(pkg-config --cflags tk)" --with-tcltk-libs="$(pkg-config --libs tk)" 
  --without-computed-gotos 
  --enable-ipv6 
  --enable-loadable-sqlite-extensions 
  --enable-shared 
 '''
        sh 'perl -p -i -e "s|ld_so_aix \\$(CC)|ld_so_aix \\$(CC) -maix${OBJECT_MODE}|" Makefile'
      }
    }
    stage('build') {
      steps {
        sh 'make -j4'
      }
    }
    stage('test') {
      steps {
        sh 'make test'
      }
    }
  }
}
pipeline {
  agent {
    node {
      label 'ibmi7.2-debug'
    }

  }
  stages {
    stage('Approval') {
            agent none
            steps {
                script {
                    def deploymentDelay = input id: 'Deploy', message: 'Deploy to production?', submitter: 'rkivisto,admin', parameters: [choice(choices: ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'], description: 'Hours to delay deployment?', name: 'deploymentDelay')]
                }
            }
        }
    stage('configure') {
      environment {
        OBJECT_MODE = '64'
        CC = 'gcc'
        CXX = 'g++'
        CPPFLAGS = "-I/QOpenSys/pkgs/include -I/QOpenSys/pkgs/include/ncurses -D_ALL_SOURCE -D_XOPEN_SOURCE=700"
        LDFLAGS = '-L/QOpenSys/pkgs/lib'
        LDFLAGS_NODIST = '-lutil'
        ARFLAGS="-X64 rc"
        CCSHARED = '-fPIC'
        ac_cv_func_clock_settime = "no"
        ac_cv_func_posix_fadvise = "no"
        ac_cv_func_posix_fallocate = "no"
        ac_cv_func_sched_get_priority_max = "no"
        ac_cv_func_sched_rr_get_interval = "no"
        ac_cv_func_sched_setaffinity = "no"
        ac_cv_func_sched_setparam = "no"
        ac_cv_func_sched_setscheduler = "no"
        ac_cv_func_fexecve = "no"
        ac_cv_func_faccessat = "no"
        ac_cv_func_fchmodat = "no"
        ac_cv_func_fchownat = "no"
        ac_cv_func_fstatat = "no"
        ac_cv_func_futimesat = "no"
        ac_cv_func_linkat = "no"
        ac_cv_func_mkdirat = "no"
        ac_cv_func_mkfifoat = "no"
        ac_cv_func_mknodat = "no"
        ac_cv_func_openat = "no"
        ac_cv_func_readlinkat = "no"
        ac_cv_func_renameat = "no"
        ac_cv_func_symlinkat = "no"
        ac_cv_func_unlinkat = "no"
        ac_cv_func_utimensat = "no"
        ac_cv_func_shm_open = "no"
        ac_cv_func_shm_unlink = "no"
        ac_cv_func_setregid = "no"
        ac_cv_enable_visibility = "no"
      }
      steps {
        sh 'sleep 60'
        sh 'exit 1'

        sh 'cp /QOpenSys/jenkins/python.cache config.cache || :'
        sh 'autoreconf'
        sh '''./configure \
          --config-cache \
          --with-system-expat \
          --with-system-ffi \
          --with-ensurepip=no \
          --with-tcltk-includes="$(pkg-config --cflags tk)" \
          --with-tcltk-libs="$(pkg-config --libs tk)" \
          --with-computed-gotos \
          --enable-ipv6 \
          --enable-loadable-sqlite-extensions \
          --enable-shared \
          --build=powerpc64-ibm-aix6  \
          --host=powerpc64-ibm-aix6
        '''
        // sh 'perl -p -i -e "s|ld_so_aix \\$(CC)|ld_so_aix \\$(CC) -maix${OBJECT_MODE}|" Makefile'
      }
    }
    stage('build') {
      steps {
        sh 'make -j4 python'
        sh 'make' // no -jX so setup.py builds sequentially
      }
    }
    stage('test') {
      steps {
        timeout(90) {
          sh "make buildbottest 'TESTOPTS=-j2 --junit-xml test-results-raw.xml -j4 \${BUILDBOT_TESTOPTS}' TESTPYTHONOPTS="
        }
      }
    }
  }

  post {
    always {
      sh 'python3.6 cpython-to-junit.py test-results-raw.xml test-results.xml'
      junit 'test-results.xml'
    }
  }
}

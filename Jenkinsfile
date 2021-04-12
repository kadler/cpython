pipeline {
  agent {
    node {
      label 'ibmi7.2'
    }

  }
  stages {
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
        sh 'system "CHGAUT OBJ(\'\"$PWD\"\') SUBTREE(*ALL) DTAAUT(*RWX) OBJAUT(*ALL) USER(pybuild)"'
        sh 'cp /QOpenSys/jenkins/python.cache config.cache || :'
        sh '/QOpenSys/sudo -u pybuild autoreconf'
        sh '''/QOpenSys/sudo -u pybuild ./configure \
          --config-cache \
          --with-system-expat \
          --with-system-ffi \
          --with-ensurepip=no \
          --with-tcltk-includes="$(pkg-config --cflags tk)" \
          --with-tcltk-libs="$(pkg-config --libs tk)" \
          --with-computed-gotos \
          --enable-ipv6 \
          --enable-loadable-sqlite-extensions \
          --enable-shared
        '''
        // sh 'perl -p -i -e "s|ld_so_aix \\$(CC)|ld_so_aix \\$(CC) -maix${OBJECT_MODE}|" Makefile'
      }
    }
    stage('build') {
      steps {
        sh '''
        cat <<EOF > Modules/Setup.local
        *disabled*
        _gdbm
        EOF
        '''
        sh '/QOpenSys/sudo -u pybuild make -j4'
      }
    }
    stage('test') {
      steps {
        timeout(90) {
          sh "/QOpenSys/sudo -u pybuild make buildbottest 'TESTOPTS=-j2 --junit-xml test-results-raw.xml'"
        }
      }
    }
  }

  post {
    always {
      sh 'python3.6 cpython-to-junit.py test-results-raw.xml test-results.xml'
      junit 'test-results.xml'
      archiveArtifacts artifacts: 'test-results-raw.xml', 'test-results.xml'
    }
  }
}

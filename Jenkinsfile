pipeline {
  agent {
    node {
      label 'ibmi'
    }

  }
  stages {
    stage('configure') {
      environment {
        OBJECT_MODE = '64'
        CC = 'gcc'
        CXX = 'g++'
        CPPFLAGS = "-I/QOpenSys/pkgs/include/ncurses -D_ALL_SOURCE -D_XOPEN_SOURCE=700"
        ARFLAGS="-X64 rc"
        ac_cv_func_clock_settime = "no"
        ac_cv_func_posix_fadvise = "no"
        ac_cv_func_posix_fallocate = "no"
        ac_cv_func_sched_rr_get_interval = "no"
        ac_cv_func_sched_setparam = "no"
        ac_cv_func_sched_setscheduler = "no"
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
      }
      steps {
        sh 'cp /QOpenSys/jenkins/python.cache config.cache || :'
        sh 'autoreconf'
        sh '''./configure \
          --config-cache \
          --with-system-expat \
          --with-system-ffi \
          --with-ensurepip=no \
          --with-tcltk-includes="$(pkg-config --cflags tk)" \
          --with-tcltk-libs="$(pkg-config --libs tk)" \
          --without-computed-gotos \
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

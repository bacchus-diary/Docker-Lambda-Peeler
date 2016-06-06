FROM fathens/docker-lambda-opencv24

RUN set -x && mkdir -pv ~/tmp && cd ~/tmp \
  && curl -L http://www.netlib.org/lapack/lapack-3.6.0.tgz | tar -zxf - && cd lapack-* \
  && mkdir build && cd build \
  && cmake -D CMAKE_BUILD_TYPE=RELEASE -D BUILD_SHARED_LIBS=ON -D CMAKE_INSTALL_PREFIX=/var/task -D CMAKE_INSTALL_LIBDIR=lib ../ \
  && make install

RUN set -x && mkdir -pv ~/tmp && cd ~/tmp \
  && curl -L http://users.ics.forth.gr/~lourakis/levmar/levmar-2.6.tgz | tar -zxf - && cd levmar-* \
  && mkdir build && cd build \
  && cmake -D CMAKE_BUILD_TYPE=RELEASE -D BUILD_DEMO=NO -D CMAKE_C_FLAGS=-fPIC ../ \
  && make \
  && ld -L/var/task/lib -llapack -shared -o /var/task/lib/liblevmar.so --whole-archive liblevmar.a

RUN set -x && mkdir -pv ~/tmp && cd ~/tmp \
  && curl -L https://downloads.haskell.org/~platform/8.0.1/haskell-platform-8.0.1-unknown-posix--full-x86_64.tar.gz | tar -zxf - \
  && ./install-haskell-platform.sh

RUN rm -rf ~/tmp \
  && echo "Build Complete: Version 1.1.0"

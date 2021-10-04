FROM            ubuntu:20.04

MAINTAINER      Nelson Moller <nmoller.c@gmail.com>

ENV             MCROUTER_DIR            /usr/local/mcrouter
ENV             MCROUTER_REPO           https://github.com/facebook/mcrouter
ENV             DEBIAN_FRONTEND         noninteractive
ENV             TZ                      America/New_York
ENV				SUDO_FORCE_REMOVE		yes
ENV				MCROUTER_COMMIT			021d6f01c002100adf92cb9fbb379f3fea01afde
# Voir https://github.com/facebook/fbthrift/issues/428
ENV             FBTHRIFT_COMMIT         01231c1c83fa1077d497799db0bd858907c7e831
ENV 			FOLLY_COMMIT			2b4649b4749a51d234cdfcad2bd00772b4ab3423
ENV 			FIZZ_COMMIT				dc43a3d5b56ea7571b8db8044c7229dd34a5c635
ENV 			WANGLE_COMMIT			44f30561042fb54feea1f8556fcd629f08e89286

RUN             echo 'debconf debconf/frontend select Noninteractive' | \
	            debconf-set-selections && apt-get update && apt-get install -y git sudo &&\
	            mkdir -p $MCROUTER_DIR/repo && \
	            cd $MCROUTER_DIR/repo && git clone $MCROUTER_REPO && \
	            cd $MCROUTER_DIR/repo/mcrouter && git checkout "$MCROUTER_COMMIT" &&\
	            cd $MCROUTER_DIR/repo/mcrouter/mcrouter/scripts && \
	            echo $FBTHRIFT_COMMIT > $MCROUTER_DIR/repo/mcrouter/mcrouter/FBTHRIFT_COMMIT &&\
	            echo $FOLLY_COMMIT > $MCROUTER_DIR/repo/mcrouter/mcrouter/FOLLY_COMMIT &&\
	            echo $FIZZ_COMMIT > $MCROUTER_DIR/repo/mcrouter/mcrouter/FIZZ_COMMIT &&\
	            echo $WANGLE_COMMIT > $MCROUTER_DIR/repo/mcrouter/mcrouter/WANGLE_COMMIT &&\
	            ./install_ubuntu_20.04.sh $MCROUTER_DIR && \
	            rm -rf $MCROUTER_DIR/repo && \
	            rm -rf $MCROUTER_DIR/pkgs && \
	            rm -rf $MCROUTER_DIR/install/lib/*.a && \
	            rm -rf $MCROUTER_DIR/install/include && \
	            ln -s $MCROUTER_DIR/install/bin/mcrouter /usr/local/bin/mcrouter &&\
	            apt-get install -y libevent-2.1-7 \
				      libdouble-conversion3\
				      libboost-program-options1.71.0 libboost-filesystem1.71.0 \
					  libboost-system1.71.0 libboost-regex1.71.0 libboost-thread1.71.0 \
					  libboost-context1.71.0 libgoogle-glog0v5 libjemalloc2&&\
	            apt-get purge -y gcc g++ ragel autoconf \
				    git libtool python-dev libssl-dev libevent-dev \
				    binutils-dev make libdouble-conversion-dev libgflags-dev \
				    libgoogle-glog-dev libjemalloc-dev sudo &&\
				apt-get purge -y 'libboost.*-dev' && apt-get autoremove --purge -y &&\
				apt-get autoclean -y && apt-get clean -y

ENV             DEBIAN_FRONTEND newt
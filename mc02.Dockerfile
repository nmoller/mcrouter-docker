FROM            ubuntu:18.04


MAINTAINER      mcrouter <mcrouter@fb.com>

#ENV 			MCROUTER_REPO			https://github.com/amcrn/mcrouter
ENV 			MCROUTER_REPO			https://github.com/facebook/mcrouter
ENV             MCROUTER_DIR            /usr/local/mcrouter

# If we want 0.41.0
ENV 			MCROUTER_COMMIT			e89989ee5a4be8d21b8de9e9c2b886b7323c11e1
ENV             FBTHRIFT_COMMIT         6d6f6b8dd7d3333690e78e27b4c68ff7a55614df
ENV 			FOLLY_COMMIT			b35bea8f0784806e687e32f6914f4a504785ea06
ENV 			FIZZ_COMMIT				979b09dbcd0344890692582d4fb5cb97bc7ab21e
ENV 			WANGLE_COMMIT			5ad3fbcf378ab50ef52b0bc9cd12d3e9d6fa1e82
ENV 			RSOCKET_COMMIT          37bc9acb796c8cf4bc0ba5942280c09248904f0b
ENV             DEBIAN_FRONTEND         noninteractive


RUN             apt-get update && apt-get install -y git&& \
				mkdir -p $MCROUTER_DIR/repo && \
                cd $MCROUTER_DIR/repo && git clone $MCROUTER_REPO &&\
                cd $MCROUTER_DIR/repo/mcrouter && git checkout "$MCROUTER_COMMIT" &&\
	            echo $FBTHRIFT_COMMIT > $MCROUTER_DIR/repo/mcrouter/mcrouter/FBTHRIFT_COMMIT &&\
	            echo $FOLLY_COMMIT > $MCROUTER_DIR/repo/mcrouter/mcrouter/FOLLY_COMMIT &&\
	            echo $FIZZ_COMMIT > $MCROUTER_DIR/repo/mcrouter/mcrouter/FIZZ_COMMIT &&\
	            echo $WANGLE_COMMIT > $MCROUTER_DIR/repo/mcrouter/mcrouter/WANGLE_COMMIT &&\
	            echo $RSOCKET_COMMIT > $MCROUTER_DIR/repo/mcrouter/mcrouter/RSOCKET_COMMIT &&\
                cd $MCROUTER_DIR/repo/mcrouter/mcrouter/scripts && \
                sed -i -e 's/sudo //g' install_ubuntu_18.04.sh && \
                ./install_ubuntu_18.04.sh $MCROUTER_DIR && \
                #./clean_ubuntu_18.04.sh $MCROUTER_DIR && rm -rf $MCROUTER_DIR/repo && \
                ln -s $MCROUTER_DIR/install/bin/mcrouter /usr/local/bin/mcrouter && \
                #rm -rf /var/lib/apt/lists/*
                #https://github.com/amcrn/mcrouter/blob/master/mcrouter/scripts/clean_ubuntu_18.04.sh
                apt-get install -y libdouble-conversion1 libgflags2.2 \
				    libboost-program-options1.65.1 libboost-filesystem1.65.1 \
				    libboost-system1.65.1 libboost-regex1.65.1 libboost-thread1.65.1 \
				    libboost-context1.65.1 libgoogle-glog0v5 libevent-2.1-6 libjemalloc1 \
				    libicu-le-hb0 libharfbuzz0b libzstd1 &&\
				apt-get purge -y gcc g++ ragel autoconf \
				    git libtool python-dev libssl-dev libevent-dev \
				    binutils-dev make libdouble-conversion-dev libgflags-dev \
				    libgoogle-glog-dev libjemalloc-dev libicu-le-hb-dev &&\
				apt-get purge -y 'libboost.*-dev' &&\
				apt-get autoremove --purge -y &&\
				apt-get autoclean -y &&\
				apt-get clean -y &&\
				cp -v /usr/local/mcrouter/install/lib/*.so.* /usr/lib/x86_64-linux-gnu/ &&\
				strip "$MCROUTER_DIR"/install/bin/mcrouter &&\
			    rm -rf "$MCROUTER_DIR"/pkgs &&\
			    rm -rf "$MCROUTER_DIR"/install/lib/*.a &&\
			    rm -rf "$MCROUTER_DIR"/install/include &&\
				rm -rf /var/lib/apt/lists/*


ENV             DEBIAN_FRONTEND newt		
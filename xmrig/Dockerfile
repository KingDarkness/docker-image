FROM ubuntu:18.04

RUN apt update && \
    apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev

RUN git clone https://github.com/xmrig/xmrig.git /tmp/xmrig && \
    cd /tmp/xmrig && mkdir build && cd build && \
    cmake .. && \
    make && \
    mv /tmp/xmrig/build/* /usr/local/bin && \
    rm -rf /tmp/xmrig

ENTRYPOINT [ "/usr/local/bin/xmrig" ]
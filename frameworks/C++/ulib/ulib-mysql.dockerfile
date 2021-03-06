FROM techempower/ulib-base:0.1

# 1. Change ULib Server (userver_tcp) configuration
RUN sed -i "s|TCP_LINGER_SET .*|TCP_LINGER_SET -2|g" $IROOT/ULib/benchmark.cfg
RUN sed -i "s|LISTEN_BACKLOG .*|LISTEN_BACKLOG 256|g" $IROOT/ULib/benchmark.cfg
RUN sed -i "s|CLIENT_FOR_PARALLELIZATION .*|CLIENT_FOR_PARALLELIZATION 100|g"  $IROOT/ULib/benchmark.cfg

# 2. Start ULib Server (userver_tcp)
ENV ORM_DRIVER="mysql"
ENV UMEMPOOL="581,0,0,59,16409,-7,-20,-23,31"
ENV ORM_OPTION="host=tfb-database user=benchmarkdbuser password=benchmarkdbpass character-set=utf8 dbname=hello_world"

CMD sed -i "s|PREFORK_CHILD .*|PREFORK_CHILD $(nproc)|g"  $IROOT/ULib/benchmark.cfg && \
    setcap cap_sys_nice,cap_sys_resource,cap_net_bind_service,cap_net_raw+eip  $IROOT/ULib/bin/userver_tcp && \
    $IROOT/ULib/bin/userver_tcp -c $IROOT/ULib/benchmark.cfg

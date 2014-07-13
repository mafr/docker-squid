FROM ubuntu:14.04

MAINTAINER Matthias Friedrich <matt@mafr.de>

RUN apt-get update
RUN apt-get install -y squid

ADD conf/passwd /etc/squid3/
ADD conf/squid.conf /etc/squid3/

EXPOSE 3128

ENTRYPOINT ["/usr/sbin/squid3"]
CMD ["-N"]

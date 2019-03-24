FROM ubuntu:18.04

LABEL author="alexz <alexz@apache.org>" maintainer="alexz <alexz@apache.org>" version="0.0.1" \
  description="This is a base image for building ctakes/build"

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
  && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y sudo wget curl net-tools ca-certificates unzip

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y git-core git openjdk-8-jdk maven \
  && rm -rf /var/lib/apt/lists/*

ARG ctakes_umlsuser
ARG ctakes_umlspw

ENV MAVEN_OPTS="-Xmx4096m -Xms3072m -Xss128M -XX:+CMSClassUnloadingEnabled -XX:-UseGCOverheadLimit"
  
RUN git clone --depth 1 --single-branch --branch master https://github.com/azbarcea/ctakes-examples.git \
    && cd ctakes-examples/ctakes-web-client \
    && mvn clean install \
    && cd ../ctakes-temporal-demo \
    && mvn clean install \
    && cd ../..

EXPOSE 8080

ADD start-jetty.sh start-jetty.sh

CMD ["./start-jetty.sh"]


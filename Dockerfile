FROM openjdk:8u162-jdk

ARG SBT_VERSION
ENV SCALA_VERSION 2.12.5
ENV SBT_VERSION ${SBT_VERSION:-1.1.1}

RUN cat /etc/os-release && \
    curl -fL https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz | tar zxf - -C / && \
    echo >> /root/.bashrc && \
    echo "export PATH=/sbt/bin:$PATH" >> /root/.bashrc

RUN \
    mkdir /root/.sbt && cd /root/.sbt && \
    echo "[repositories]" >> repositories && \
    echo "local" >> repositories && \
    echo "ali-maven: http://maven.aliyun.com/nexus/content/groups/public" >> repositories && \
    echo "maven-central: http://central.maven.org/maven2/" >> repositories && \
    echo "repox-ivy:  http://repox.gtan.com:8078/, [organization]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)[revision]/[type]s/[artifact](-[classifier]).[ext]" >> repositories && \
    cat repositories && \
    mkdir tmp && cd tmp && \
    /sbt/bin/sbt compile && cd .. && rm tmp -rf


WORKDIR /root
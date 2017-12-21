FROM centos:7

RUN yum update -y && \
    yum install -y java-1.8.0-openjdk-headless && \
    yum clean all

# zookeeper host and port - should be overridden 
ENV ZK_HOSTS=localhost:2181

# kafka-manager varaibles - should be overridden
ENV KM_CLUSTERNAME="Default" \
    KM_KAFKAVERSION="0.10.1.1" \
    KM_JMX_ENABLED="true" \
    KM_AUTOCREATE_CLUSTER="true"

# use own secret - should be overridden
ENV APPLICATION_SECRET=dkjf{2QivJKM4d

ENV JAVA_HOME=/usr/java/default/ \
    KM_VERSION=1.3.3.15 \
    KM_REVISION=aa640ad130315e546fa1543b2ac39ddf1f130f4e \
    KM_BASEDIR=/kafka-manager-${KM_VERSION} \
    KM_CONFIGFILE="${KM_BASEDIR}/conf/application.conf"

# activate basic auth by default
ENV KAFKA_MANAGER_AUTH_ENABLED="true"  \
    KAFKA_MANAGER_USERNAME="manager"  \
    KAFKA_MANAGER_PASSWORD="notsecure"

ADD start-kafka-manager.sh /kafka-manager-${KM_VERSION}/start-kafka-manager.sh
ADD curlCreateCluster.sh /opt/curlCreateCluster.sh
ADD wait-for-it/wait-for-it.sh /opt/wait-for-it.sh

# ENV SBT_OPTS="-Xmx1536M -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=2G -Xss2M  -Duser.timezone=GMT"

RUN yum install -y java-1.8.0-openjdk-devel git wget unzip which && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    git checkout ${KM_REVISION} && \ 
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt -mem2000 clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    chmod +x ${KM_BASEDIR}/start-kafka-manager.sh && \
    chmod +x /opt/curlCreateCluster.sh && \
    chmod +x /opt/wait-for-it.sh && \
    yum autoremove -y java-1.8.0-openjdk-devel git wget unzip which && \
    yum clean all

WORKDIR ${KM_BASEDIR}

ENV KM_PORT=9000
EXPOSE 9000

ENTRYPOINT ["${KM_BASEDIR}/start-kafka-manager.sh"]

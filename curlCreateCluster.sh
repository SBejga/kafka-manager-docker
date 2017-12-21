#!/usr/bin/env bash

if [ -z ${ZK_HOSTS} ]; then
    echo "Error: no ZK_HOSTS env found!"
    exit 1
fi

if [ -z ${KM_PORT} ]; then
    echo "Error: no KM_PORT env found!"
    exit 1
fi

if [ -z ${KM_CLUSTERNAME} ]; then
    echo "Error: no KM_CLUSTERNAME env found!"
    exit 1
fi

if [ -z ${KM_KAFKAVERSION} ]; then
    echo "Error: no KM_KAFKAVERSION env found!"
    exit 1
fi

if [ -z ${KM_KAFKAVERSION} ]; then
    KM_JMX_ENABLED="false"
fi

KM_PROTOCOL="http"
KM_HOSTNAME="localhost"
TMP_DATASTRING="name=${KM_CLUSTERNAME}&zkHosts=${ZK_HOSTS}&kafkaVersion=$KM_KAFKAVERSION&jmxEnabled=$KM_JMX_ENABLED&jmxUser=&jmxPass=&pollConsumers=true&tuning.brokerViewUpdatePeriodSeconds=30&tuning.clusterManagerThreadPoolSize=2&tuning.clusterManagerThreadPoolQueueSize=100&tuning.kafkaCommandThreadPoolSize=2&tuning.kafkaCommandThreadPoolQueueSize=100&tuning.logkafkaCommandThreadPoolSize=2&tuning.logkafkaCommandThreadPoolQueueSize=100&tuning.logkafkaUpdatePeriodSeconds=30&tuning.partitionOffsetCacheTimeoutSecs=5&tuning.brokerViewThreadPoolSize=2&tuning.brokerViewThreadPoolQueueSize=1000&tuning.offsetCacheThreadPoolSize=2&tuning.offsetCacheThreadPoolQueueSize=1000&tuning.kafkaAdminClientThreadPoolSize=2&tuning.kafkaAdminClientThreadPoolQueueSize=1000&securityProtocol=SSL"
TMP_URI="${KM_PROTOCOL}://${KM_HOSTNAME}:${KM_PORT}"

echo "create kafka cluster with zookeeper '${ZK_HOSTS}' at ${TMP_URI}"

curl --write-out 'RESPONSE: %{http_code} \n' --output /dev/null \
    -u ${KAFKA_MANAGER_USERNAME}:${KAFKA_MANAGER_PASSWORD} \
    "${TMP_URI}/clusters" --data "${TMP_DATASTRING}"
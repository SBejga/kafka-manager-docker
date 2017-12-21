#!/bin/sh

echo "=============="
echo "Kafka Manager"
echo "--------------"
echo "ZK_HOSTS: ${ZK_HOSTS}"
echo ""
echo "KM Version: ${KM_VERSION}"
echo "KM Config: ${KM_CONFIGFILE}"
echo "KM Port: ${KM_PORT}"
echo "KM Auth enabled: ${KAFKA_MANAGER_AUTH_ENABLED}"
echo "KM Args: ${KM_ARGS}"
echo "=============="

if [ $KM_AUTOCREATE_CLUSTER = "true" ]; then
    echo "start in background: wait and fire curl to create cluster in kafka-manager"
    exec /opt/wait-for-it.sh --timeout=60 localhost:$KM_PORT -- /opt/createClusterKafkaManager.sh &
fi

echo "wait for zookeeper and start kafka-manager"
exec /opt/wait-for-it.sh --timeout=30 ${ZK_HOSTS} -- ${KM_BASEDIR}/bin/kafka-manager -Dconfig.file=${KM_CONFIGFILE} "${KM_ARGS}" "${@}"
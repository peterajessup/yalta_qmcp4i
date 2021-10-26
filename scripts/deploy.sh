#!/bin/bash
oc project yalta
set +e
# Remove the runnning queue manager instance (if any)

oc delete QueueManager yalta-queue-manager

# Delete the route object and secret for the QueueManager keystore (if any), and the mqsc configMap
oc delete route yaltaroute
oc delete secret yaltakey
oc delete configMap yalta-mqsc
oc delete persistentvolumeclaim data-yalta-queue-manager-ibm-mq-0
set -e
# Create the route and the keystore secret and mqsc configMap
oc apply -f yaltaRoute.yaml
oc create secret tls yaltakey --cert=./tls/tls.crt --key=./tls/tls.key
oc create -f mqsc/mqsc.yaml

set -e
oc apply -f mqDeploy.yaml

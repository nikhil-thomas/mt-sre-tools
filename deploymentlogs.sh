#!/usr/bin/env bash

function printUsage() {
  echo usage:
  echo ${0} '<deployment name> <namespace>'
}

function podLogs() {
  podName=$1
  namespace=$2
  containerNames=$(findContainerNames $podName $namespace)
  echo pod: $podName
  echo containers: $containerNames
  echo namespace: $namespace
  for name in $containerNames; do
    containerLog $podName $name $namespace
  done
}

function findContainerNames() {
  pName=$1
  ns=$2
  kubectl get pod $pName -n $ns -o json | jq ".spec.containers[].name" | tr -d '"'
}

function containerLog() {
  pName=$1
  cName=$2
  ns=$3
  echo LOGS from - Pod: $pName, Container: $cName, ns: $ns
  echo ------------------------------------------
  kubectl logs $pName -n $ns -c $cName
  echo ------------------------------------------
 
}

function deploymentLogs() {
  deploymentName=${1}
  namespace=${2}
  podNames=$(findPodNames ${deploymentName} ${namespace})
  for podName in ${podNames}; do
    podLogs ${podName} ${namespace}
  done
}

function findPodNames() {
  deploymentName=${1}
  namespace=${2}
  kubectl get pods -n ${namespace} | \
    grep ${deploymentName} | \
    awk '{print $1}'
}

if [[ $# -eq 0 ]]; then
  echo invalid input
  printUsage
  exit 1
fi

deploymentLogs $*

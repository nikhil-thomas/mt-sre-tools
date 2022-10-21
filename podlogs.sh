#!/usr/bin/env bash

function podlogs() {
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


podlogs $*

#!/bin/bash

# exit when any command fails
set -e
trap "exit 1" TERM
export TOP_PID=$$

# Fetch the arguments
POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
  --app-version)
    newAppVersion="$2"
    shift # past argument
    shift # past value
    ;;
  -* | --*)
    echo "Unknown option $1"
    exit 1
    ;;
  *)
    POSITIONAL_ARGS+=("$1") # save positional arg
    shift                   # past argument
    ;;
  esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters
# input validation
[ ! "$newAppVersion" ] && echo "Please provide a branch: --app-version" && exit 1


# get old slot from last release (or use green as default)
oldSlot=$((helm get values --all crud-app) | yq -r '.productionSlot // "green"')

# set new slot
newSlot=$([ "$oldSlot" == "blue" ] && echo "green" || echo "blue")

echo "##############################################################"
echo "Current production slot $oldSlot"
echo "Start to deploy on slot $newSlot with version: $newAppVersion"
echo "##############################################################"

# update values.yaml
yq -i .$newSlot.enabled=true values.yaml
yq -i .$newSlot.appVersion=$newAppVersion values.yaml
yq -i '.productionSlot="'"$oldSlot"'"' values.yaml

# commit and push changes
git add values.yaml && git commit -m "deploy version $newAppVersion on $newSlot" && git push

# deploy changes to k8s cluster
bash _deployChart.sh

echo "##############################################################"
echo "Deployed to slot $newSlot with version: $newAppVersion"
echo "Switching production slot from $oldSlot to $newSlot"
echo "##############################################################"


# update values.yaml
yq -i .$oldSlot.enabled=false values.yaml
yq -i '.productionSlot="'"$newSlot"'"' values.yaml

# commit and push changes
git add values.yaml && git commit -m "switch production slot to $newSlot" && git push

# deploy changes to k8s cluster
bash _deployChart.sh

#!/bin/bash
# exit when any command fails
set -e
trap "exit 1" TERM
export TOP_PID=$$

# Fetch the arguments
POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
  -u)
    ghcr_user="$2"
    shift # past argument
    shift # past value
    ;;
  -p)
    ghcr_pat="$2"
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

[ ! "$ghcr_user" ] && echo "Please provide a github username: -u [username]" && exit 1
[ ! "$ghcr_pat" ] && echo "Please provide a github personal access token (PAT): -p [PAT]" && exit 1

# create the secret to access the docker images in our github docker registry
echo
echo Update secret to access the docker images:
kubectl delete secret ghcr-secret \
  --ignore-not-found=true \
  -n joschne-dev
kubectl create secret docker-registry ghcr-secret \
  --docker-server=ghcr.io \
  --docker-username=$ghcr_user \
  --docker-password=$ghcr_pat \
  -n joschne-dev

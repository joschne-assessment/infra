# infra
This repo contains infrastructure as code in the form of helm charts


## release crud-app-chart

To install or upgrade the crud-app-chart, perform these steps:

**Set target K8s cluster**
Login to the target K8s cluster.
```bash
# e.g using the open shift cli
oc login
```

**Ensure, namespace exists**
Before running the script to install the helm chart, we have to make sure the namespace `joschne-dev` exists. 

(In open shift, a project is a namespace.)

**Run script**
```bash
bash crud-app-upgrade.sh 
```
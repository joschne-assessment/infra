# infra
This repo contains infrastructure as code in the form of helm charts.


## release crud-app-chart

To install or upgrade the crud-app-chart, do these steps:

**Set target K8s cluster**

Login to the target K8s cluster.
```bash
# e.g using the open shift cli
oc login
```

**Create namespace**

Before running the script to install the helm chart, we have to make sure the namespace `joschne-dev` exists. 
(In open shift, a project is a namespace.)

**Create image pull secret**

In order to pull images from our private ghcr.io registry, we need a secret. 
Create the secret:

```bash
bash _createImgPullSectet.sh
```

**Release**

The following command will install or upgrade a helm release for the crud-app.
```bash
cd crud-app-chart
bash _deployChart.sh 
```

**Release a new crud-app version with blue-green strategy**

The following command will update the chart with the crud-app version "foo" and perform the blue-green deployment.
The version has to correspond to the image tag.

```bash
cd crud-app-chart
bash _autoDeployBlueOrGreen.sh --app-version foo
```
#!/bin/bash

# Use this command to deploy this chart to k8s cluster
helm upgrade crud-app . --install --atomic --reset-values --wait --debug --timeout 2m00s -n joschne-dev
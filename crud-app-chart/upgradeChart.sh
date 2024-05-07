#!/bin/bash

# Use this command in case you modified values.yaml,
# for example to change the resource quota,
# and you want to apply this change to the production slot
helm upgrade crud-app . --install --atomic --wait --debug --timeout 1m00s -n joschne-dev
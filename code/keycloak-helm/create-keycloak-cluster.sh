#!/bin/bash

helm install --name keycloak --set keycloak.password=keycloak -f values.yml stable/keycloak
#helm install --name keycloak --set keycloak.password=keycloak -f values.yml /home/tom/dev/repos/gh/thomasdarimont/kubernetes-dev/charts/stable/keycloak

kubectl apply -f keycloak-ingress.yaml


#!/bin/bash

kubectl delete ingress demo-app-ingress
kubectl delete service demo-app-service 
kubectl delete deployment demo-app-deployment
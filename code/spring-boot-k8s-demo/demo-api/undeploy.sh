#!/bin/bash

kubectl delete ingress demo-api-ingress
kubectl delete service demo-api-service 
kubectl delete deployment demo-api-deployment
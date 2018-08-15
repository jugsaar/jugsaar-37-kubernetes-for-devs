#!/usr/bin/env bash

kubectl apply -f k8s/0-deployment.yaml
kubectl apply -f k8s/1-service.yaml
kubectl apply -f k8s/2-ingress.yaml

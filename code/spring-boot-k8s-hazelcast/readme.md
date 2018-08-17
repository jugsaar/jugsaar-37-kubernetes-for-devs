# Hazelcast Spring-Boot demo

## Session Replication

## Kubernetes

```bash
minikube start

eval $(minikube docker-env)

# Allow default service user in default namespace to describe pods
# see https://github.com/fabric8io/fabric8/issues/6840
kubectl apply -f src/main/fabric8/clusterRoleBinding.yaml

mvn clean package fabric8:build 

mvn fabric8:resource fabric8:deploy

minikube service demo-service

# Scale to 3 replicas
mvn fabric8:start  -Dfabric8.replicas=3

# Delete deployment
kubectl delete deployment spring-boot-hazelcast-demo

```
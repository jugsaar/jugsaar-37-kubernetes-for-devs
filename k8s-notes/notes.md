# Demo 1 - Vagrant Kubernetes Cluster

- Show repository 
https://github.com/thomasdarimont/vagrant-kubernetes-lab/blob/poc/kubernetes-next

- Scroll down to Quickstart

On the Machine
- Boot the cluster (takes ~60 seconds)
`vagrant up`

- Voice over: 1 Master, 3 Worker, (1 Docker-Registry in the background)
`kubectl get nodes` 

Cluster is ready

- Show dashboard
```
kubectl proxy &
xdg-open http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
```
- Show nodes






# Demo 2 - Cloud Native Spring Boot App

Explain demo apps 

APP ---> API

In demo-api project:

- show calc controller
- Start ApiApp locally

- Show /api/calc endpoint in console
```
curl -s http://localhost:8080/api/calc\?x\=10\&y\=9 | jq .
```

- stop ApiDemo app

## Create Docker image

- Show maven-docker-plugin config in pom.xml
Highlight: imagename, custom Dockerfile
	
- Show custom dockerfile
Highlight: openjdk-java10
Mention better support for Java 10 in containers, less JVM options required...

- Build the docker image and upload the image to the docker registry
```
./build.sh
```
--> Docker image is now in registry

## Deploy API to Kubernetes

- show deployment.yml, service.yml, ingress.yaml

- show no pods are running yet:
```
kubectl get pods
```

- show deploy.sh
```
cat deploy.sh
```

- deploy demo-api
```
./deploy.sh
```

- show pods are running

```
echo
echo Deployment && kubectl get deployment
echo
echo Pods && kubectl get pods
echo
echo Services && kubectl get svc
echo
echo Ingress && kubectl get ingress
echo
```

- curl ingress
```
watch "curl -s http://demo-api.demo.tdlabs.k8s/api/calc\?x\=10\&y\=9"
```

- show demo-app

- show AppController
Explain /calc uses the /api/calc endpoint from the API via Feign
- show CalcApi
Highlight: no URL configured! just k8s-service-name

- build the App
```
./build.sh
```

- deploy the app
```
./deploy.sh
```

- show pods are running
```
echo
echo Deployment && kubectl get deployment
echo
echo Pods && kubectl get pods
echo
echo Services && kubectl get svc
echo
echo Ingress && kubectl get ingress
echo
```

- curl ingress
```
watch "curl -s http://demo-app.demo.tdlabs.k8s/calc\?x\=10\&y\=9"
```

clearn up demos!








# Demo 3 - Rolling upgrades

- Show AppController
- Show index.html
- Build & Deploy
```
./build.sh
./deploy.sh
xdg-open http://rolling-app.demo.tdlabs.k8s
```
- show green

## New feature:
- change lime -> yellow in index.html
- change version in pom.xml and deployment.yml
- Build & Deploy
```
./build.sh
./deploy.sh
```

- show yellow...

## Rollback
```
kubectl set image deployment/rolling-app-deployment rolling-app=gitlab:5000/k8s-rolling-app:1.0.12-SNAPSHOT
```
- show green again...










# Demo 4 - HTTP Session Clustering with Hazelcast

- show DemoController
Highlight: HttpSession backed by Hazelcast

- show HazelcastConfig
Highlight: @EnableHazelcastHttpSession

- Show hazelcast.xml
Highlight: service-name

- show pom.xml -> hazelcast
Highlight: hazelcast + hazelcast-spring + hazelcast-kubernetes

- show pom.xml -> fabric8-maven-plugin
fabric8-maven-plugin: Generates k8s artifacts
Highlight: deployment customizations via properties

- Build & deploy ingress
```
./build.sh
kubectl apply -f k8s/hazelcast.demo.tdlabs.k8s
```

- Show hazelcast app
```
xdg-open http://hazelcast.demo.tdlabs.k8s
```

- Show weavescope
```
kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040 &
```

show hosts
show pods
filter hazelcast --> 1 node visible

- scale up cluster
```
mvn fabric8:start  -Dfabric8.replicas=3
```

- scale down cluster
```
mvn fabric8:start  -Dfabric8.replicas=2
```









# Demo 5 - Keycloak Cluster with Helm chart
```
./create-keycloak-cluster.sh

xdg-open http://keycloak.demo.tdlabs.k8s
```

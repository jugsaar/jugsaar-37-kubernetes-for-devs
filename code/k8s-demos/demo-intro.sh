docker search alpine
docker pull alpine
docker run -it --rm alpine
  docker ps
^D

docker run -it --rm -e MEINE_VARIABLE=MEIN_WERT alpine
env
exit

mkdir /tmp/demo
echo huhu > /tmp/demo/hallo.txt
docker run -it --rm -v /tmp/demo:/mnt alpine
ls /mnt
cat /mnt/hallo.txt
  echo Hallo Welt! > /tmp/demo/hallo.txt
cat /mnt/hallo.txt
^D

docker run -it --rm -p 8080:80 alpine
ip a
nc -l -p 80
  echo huhu | nc -c localhost 8080
wget https://www.infoserve.de
^D

docker run -d -p 5000:5000 --name registry registry:2
docker ps
docker pull alpine
docker image tag alpine localhost:5000/mein_alpine
docker images
docker push localhost:5000/mein_alpine
docker run -it --rm localhost:5000/mein_alpine
^D

kubectl get nodes -o wide
kubectl run -i -t busybox --image=busybox:1.28
kubectl get pods
kubectl attach busybox-7999f69f9d-68tv4 -c busybox -i -t
kubectl get pods

kubectl describe pod busybox-7999f69f9d-68tv4
kubectl describe ReplicaSet/busybox-7999f69f9d
kubectl describe Deployment/busybox

kubectl get all
kubectl delete deployment busybox
kubectl get all

vim echo.yaml
kubectl apply -f echo.yaml
kubectl get all
kubectl scale deployment echo --replicas 3
kubectl get all

vim echo-service.yaml
kubectl apply -f echo-service.yaml
kubectl get svc

kubectl run -i -t busybox --image=busybox:1.28
nslookup echo-service
watch -n 1 wget -qO - echo-service | grep served

vim traefik-ingress-controller.yaml
kubectl create -f traefik-ingress-controller.yaml
kubectl get all --namespace=kube-system -l k8s-app=traefik-ingress-lb

vim echo-ingress.yaml
kubectl create -f echo-ingress.yaml
curl kube02/echo
curl kube03/echo

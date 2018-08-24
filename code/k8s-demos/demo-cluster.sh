# Zuerst wird der Master installiert.

# Das Subnetz, das für Kubernetes verwendet wird, muss überschneidungsfrei sein mit der Umgebung,
# in der der Cluster läuft, deshalb hier und noch einmal weiter unter IPALLOC_RANGE setzen:
IPALLOC_RANGE=10.112.0.0/12 kubeadm init
# Zeile mit "kubeadm join" merken!

# Damit man Dienste auf Ports des Host verfügbar machen kann, muss das Weave CNI Plugin wie folgt
# konfiguriert werden: 
cat >/etc/cni/net.d/00-weave-portmap.conflist <<-EOF
{
    "cniVersion": "0.3.0",
    "name": "mynet",
      "plugins": [
        {
            "name": "weave",
            "type": "weave-net",
            "hairpinMode": true
        },
        {
            "type": "portmap",
            "capabilities": {"portMappings": true},
            "snat": true
        }
    ]
}
EOF

# Dann als normaler User weitermachen:
exit
mkdir -p $HOME/.kube ; sudo cat /etc/kubernetes/admin.conf > $HOME/.kube/config

# Weave CNI Plugin installieren:
wget -O /tmp/weave.yaml "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.CHECKPOINT_DISABLE=1&env.IPALLOC_RANGE=10.112.0.0/12"
kubectl apply -f /tmp/weave.yaml

# Anschließend auf allen Workern als root:
cat >/etc/cni/net.d/00-weave-portmap.conflist <<-EOF
{
    "cniVersion": "0.3.0",
    "name": "mynet",
      "plugins": [
        {
            "name": "weave",
            "type": "weave-net",
            "hairpinMode": true
        },
        {
            "type": "portmap",
            "capabilities": {"portMappings": true},
            "snat": true
        }
    ]
}
EOF
# ... und die vom Master gemerkte join-Zeile ausführen:
kubeadm join 10.32.16.101:6443 ...

# Wenn alle Worker installiert sind, auf dem Management-PC mit kubectl folgendes ausführen:
# (vorher $HOME/.kube/config vom Master mit scp kopieren, damit kubectl auch den gerade gebauten Cluster benutzt)

# Kubernetes-Dashboard installieren:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl create clusterrolebinding add-on-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:default
kubectl proxy &
# Unter http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/pod?namespace=default
# sollte jetzt das Dashboard erscheinen. Beim Login "Token" wählen und folgendes Token einfügen:
kubectl -n kube-system get secrets -o name | grep default | xargs kubectl -n kube-system describe

# WeaveNet-Dashboard installieren:
kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"
# Anschließend kann man auf Port 4040 darauf zugreifen, wenn man lokal bei sich ein Forwarding startet:
kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040

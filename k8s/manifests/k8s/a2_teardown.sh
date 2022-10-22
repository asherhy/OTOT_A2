echo Removing all A2 Stuffs
echo ==========================

echo Deleting Ingress!
kubectl delete ingress backend-ingress

echo Deleting Ingress Controller!
kubectl delete -n ingress-nginx deploy ingress-nginx-controller

echo Deleting Service!
kubectl delete service backend-service

echo Deleting Backend Deployment!
kubectl delete deploy backend

echo Deleting Cluster!
kind delete cluster --name a2-demo

echo Script Finished Running!
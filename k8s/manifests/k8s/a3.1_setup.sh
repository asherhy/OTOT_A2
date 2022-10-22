echo Demo A3.1...

echo Starting metrics server...
kubectl apply -f ./metric-server.yaml --context kind-kind-1
kubectl wait -nkube-system --for=condition=ready pod --selector=k8s-app=metrics-server --timeout=180s --context kind-kind-1
kubectl -nkube-system --selector=k8s-app=metrics-server get deploy --context kind-kind-1
kubectl get pods --all-namespaces | grep metric

echo Starting horizontal pod autoscaler...
kubectl apply -f ./nodejs-hpa.yaml --context kind-kind-1
kubectl describe hpa --context kind-kind-1
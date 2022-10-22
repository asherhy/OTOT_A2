echo Removing all A3 Stuffs

echo Deleting auto scaling hpa!
kubectl delete hpa/backend --context kind-kind-1

echo Deleting metrics server!
kubectl delete -f ./metric-server.yaml --context kind-kind-1

echo Script Finished Running!
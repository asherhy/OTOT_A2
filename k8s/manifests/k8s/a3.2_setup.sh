NC="\033[0m"
GR="\033[1;32m"
GR1="\033[0;32m"
YL="\033[1;33m"

cname="kind-1"

function pauseMsg() {
  echo "${1}"
  read -rsn 2
}

#########################################################################

echo "\nRunning A3.2 demo script\n"

echo "${GR}Creating clusters${NC}"
kind create cluster --name $cname --config ../../kind/cluster-config.yaml
echo ""

kubectl cluster-info --context kind-kind-1
kubectl get nodes --context kind-kind-1

# pauseMsg "\n${GR1}Press any key to create the deployment.${NC}"

echo "\n${GR}Creating deployment${NC}"
kubectl apply -f ./nodejs-deploy-bza.yaml

echo "\n${YL}Waiting for deployment to be ready...${NC}"
kubectl wait --for=condition=ready pod --selector=app=backend-zone-aware --timeout=45s
echo ""
kubectl get po -l app=backend 


# pauseMsg "\n${GR1}Press any key to create the service.${NC}"

echo "\n${GR}Creating service${NC}"

kubectl apply -f ./nodejs-service-bza.yaml 

echo "\n${YL}Printing service details...${NC}"
kubectl describe svc backend-svc-zone-aware 
echo ""
kubectl get svc -l app=backend-zone-aware 

# pauseMsg "\n${GR1}Press any key to create the NGINX ingress controller.${NC}"

echo "\n${GR}Creating NGINX ingress controller${NC}"
kubectl apply -f "https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml" 

echo "\n${YL}Waiting for NGINX ingress controller to be ready...${NC}"
ns="ingress-nginx"
sr="app.kubernetes.io/component=controller"
kubectl wait --namespace $ns --for=condition=ready pod --selector=$sr --timeout 45s 
kubectl --namespace $ns get po -l $sr
kubectl -n $ns get deploy

# pauseMsg "\n${GR1}Press any key to create the image's ingress object.${NC}"

echo "\n${GR}Creating ingress object of asherhy/nodejs-app${NC}"
kubectl apply -f nodejs-ingress-bza.yaml 

echo "\n${YL}Waiting for nodejs-ingress-obj to be ready...${NC}"
sleep 45
kubectl get ingress -l app=backend-zone-aware 

pauseMsg "\n${GR}A3 demo is now ready to be tested...${NC}"

# curl localhost -s | grep "Matric\|Name:"
echo "\n${GR1}Showing workers and their zones. ${NC}"
kubectl get nodes -L topology.kubernetes.io/zone

echo "\n${GR1}Showing their distribution. ${NC}"
kubectl get po -lapp=backend-zone-aware -owide --sort-by='.spec.nodeName'
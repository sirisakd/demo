RG="rg-demo-ate-dev-neu"
IP="pip-demo-ate-dev-neu-00"
NAMESPACE="msda00"
PIP=$(az network public-ip show -g ${RG} -n ${IP})
DNSLABEL=$(echo $PIP | jq .dnsSettings.domainNameLabel | tr -d '"')
PUBLICIP=$(echo $PIP | jq .ipAddress | tr -d '"')
echo "
RG      : ${RG}
DNSLABEL: ${DNSLABEL}
PUBLICIP: ${PUBLICIP}
"

echo "##### Install NGINX Ingress Controller via helm"

helm upgrade -i public-ingress ingress-nginx/ingress-nginx \
  --namespace $NAMESPACE \
  --set controller.replicaCount=1 \
  --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
  --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
  --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux \
  --set controller.service.externalTrafficPolicy=Local \
  --set controller.service.loadBalancerIP="${PUBLICIP}" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-resource-group"="${RG}" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="${DNSLABEL}"
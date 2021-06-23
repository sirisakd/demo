helm upgrade -i internal-ingress ingress-nginx/ingress-nginx \
  --namespace msda000 \
  -f 05-internal-ingress-lb.yml \
  --set controller.replicaCount=1 \
  --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
  --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
  --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux
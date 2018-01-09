
```bash
kubectl apply -f storageclass-env.yaml
kubectl apply -f bifrost-conf.yaml
kubectl apply -f bifrost-web-conf.yaml
kubectl apply -f postgres.yaml
kubectl apply -f ethereum-geth.yaml
kubectl apply -f bitcoin-core.yaml
kubectl apply -f bifrost.yaml
kubectl apply -f bifrost-web.yaml
```

# Ingress
I have provided setup files for [traefik](https://traefik.io) with [let's encrypt](https://letsencrypt.org).

  


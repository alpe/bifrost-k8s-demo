
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
## Secrets
```bash
kubectl create secret generic bifrost-credentials \
--from-literal=SIGNER_SECRET_KEY=SAURKR5JIQ2WOD7WAWTAP4662UKGKDUBGL74ADXYX4VMGSSD2DBAF3WR \
--from-literal=DB_USER=myuser \
--from-literal=DB_PASSWORD=mysecretpassword

```

# Ingress
The `ingress` folder contains setup files for [traefik](https://traefik.io) with [let's encrypt](https://letsencrypt.org).

  

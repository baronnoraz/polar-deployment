#!/bin/sh

echo "\nš¦ Initializing Kubernetes cluster...\n"

kind create cluster --config kind-config.yml

echo "\n-----------------------------------------------------\n"

echo "š Installing NGINX Ingress..."

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

sleep 5

echo "\nā Waiting for NGINX Ingress to be deployed..."

while [ $(kubectl get pod -n ingress-nginx -l app.kubernetes.io/component=controller | grep ingress-nginx | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\nā Waiting for NGINX Ingress to be ready..."

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

echo "\n-----------------------------------------------------\n"

echo "š¦ Deploying platform services..."

kubectl apply -f services

sleep 5

echo "\n-----------------------------------------------------\n"

echo "ā Waiting for PostgreSQL Catalog to be deployed..."

while [ $(kubectl get pod -l db=polar-postgres-catalog | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\nā Waiting for PostgreSQL Catalog to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=polar-postgres-catalog \
  --timeout=180s

echo "\n-----------------------------------------------------\n"

echo "ā Waiting for PostgreSQL Order to be deployed..."

while [ $(kubectl get pod -l db=polar-postgres-order | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\nā Waiting for PostgreSQL Order to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=polar-postgres-order \
  --timeout=180s

echo "\n-----------------------------------------------------\n"

echo "ā Waiting for Redis to be deployed..."

while [ $(kubectl get pod -l db=polar-redis | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\nā Waiting for Redis to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=polar-redis \
  --timeout=180s

echo "\n-----------------------------------------------------\n"

echo "ā Waiting for RabbitMQ to be deployed..."

while [ $(kubectl get pod -l db=polar-rabbitmq | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\nā Waiting for RabbitMQ to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=polar-rabbitmq \
  --timeout=180s

echo "\n-----------------------------------------------------\n"

echo "ā Waiting for Keycloak to be deployed..."

while [ $(kubectl get pod -l app=polar-keycloak | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\nā Waiting for Keycloak to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=app=polar-keycloak \
  --timeout=300s

echo "\nā Waiting for Keycloak configuration..."

echo "\nāµ Happy Sailing!\n"

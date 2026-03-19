# SWE645 Assignment 2 Documentation

## What I built

I built a portfolio + student survey web application (Homework 1 – Part 2). The application is a Bootstrap 5 single-page interface with:

- Home/About/Skills/Student Survey/Contact sections
- Cookie-based greeting for the Student Survey
- JavaScript validation for survey inputs
- Zipcode lookup powered by `zipcodes.json`
- Computed statistics (average and maximum) from 10 comma-separated numbers

The app is containerized with Docker and deployed to Kubernetes using `kubectl`.

## How it works (high-level)

1. You edit the web app files locally (e.g., `index.html`, `zipcodes.json`, `profile.jpg`).
2. You push code to GitHub.
3. Jenkins CI/CD:
   - checks out code
   - builds a Docker image
   - pushes the image to Docker Hub
   - redeploys Kubernetes using the updated image tag
4. Kubernetes runs 3 replicas for resiliency, and a Service exposes the app.

## Project files

- `index.html` - main app UI
- `zipcodes.json` - zipcode lookup data
- `profile.jpg` - image used on the About page
- `Dockerfile` - builds an Nginx image to serve the static site
- `k8s-deployment.yaml` - Kubernetes Deployment (3 replicas) + Service
- `Jenkinsfile` - Jenkins pipeline to build/push/deploy
- `deploy.sh`, `deploy-ec2.sh` - supporting scripts used earlier for S3/EC2 deployments
- `check-key.sh` - helper for EC2 key validation

## Docker containerization

The `Dockerfile` uses `nginx:alpine`:

- removes the default Nginx HTML content
- copies `index.html`, `zipcodes.json`, and `profile.jpg` into `/usr/share/nginx/html`
- serves the static site from Nginx on port 80

Local test:

```bash
docker build -t swe642-assignment1 .
docker run --rm -p 8080:80 swe642-assignment1
```

Then open: `http://localhost:8080`

## Docker Hub tagging strategy

The Jenkins pipeline pushes:

- `oliveret/swe642-assignment1:${BUILD_NUMBER}`
- `oliveret/swe642-assignment1:latest`

The Kubernetes Deployment uses the versioned tag so it’s easy to see what Jenkins deployed.

## Kubernetes deployment details

`k8s-deployment.yaml` contains:

- Deployment: `replicas: 3` for resiliency
- Container image: `oliveret/swe642-assignment1:latest` (updated by Jenkins to the build tag)
- Service: `type: LoadBalancer` on port 80

If `EXTERNAL-IP` stays `<pending>` (common in local clusters), the app can be accessed with:

```bash
kubectl port-forward svc/swe642-assignment1-service 8081:80
```

Then open: `http://127.0.0.1:8081`

## Rancher and EKS management

I imported my existing AWS EKS cluster into Rancher using the Rancher UI. Rancher is used to manage/monitor the
EKS cluster, while the Kubernetes Deployment and Service run the containerized application on EKS.

## CI/CD pipeline with Jenkins

The Jenkins pipeline performs:

1. Checkout from the GitHub repository
2. Build and push a multi-arch Docker image with Buildx:
   - platforms: `linux/amd64`, `linux/arm64`
3. Push images to Docker Hub using credentials `dockerhub-creds`
4. Deploy to Kubernetes:
   - `kubectl apply -f k8s-deployment.yaml`
   - `kubectl set image ...` to the versioned tag
   - `kubectl rollout status ...` to wait for rollout completion

## Resiliency testing

To prove resiliency:

1. Confirm 3 pods are running:
   ```bash
   kubectl get pods -l app=swe642-assignment1
   ```
2. Delete one pod:
   ```bash
   kubectl delete pod <one-pod-name>
   ```
3. Verify Kubernetes recreates it and restores the replica count.

## Video demonstration checklist

- Setup process
- Deployment on Kubernetes using `kubectl`
- CI/CD pipeline execution in Jenkins
- Running application on Kubernetes
- AWS/cloud URL used during recording

When `EXTERNAL-IP` is `<pending>`, document the port-forward endpoint used instead (e.g., `http://127.0.0.1:8081`).


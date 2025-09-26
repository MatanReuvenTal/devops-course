# Phase 2: Kubernetes Deployment for QuakeWatch

This document outlines the steps to deploy the containerized QuakeWatch application to a local Kubernetes cluster using Minikube. This deployment includes advanced features such as externalized configuration, health monitoring, scheduled tasks, and auto-scaling.

---

## Prerequisites

- **Kubernetes Cluster:** A running local cluster is required. This guide assumes you are using **Minikube**.
- **kubectl:** The Kubernetes command-line tool, configured to communicate with your cluster.
- **Docker Image:** The application's Docker image must be available on Docker Hub at `matanreuvental/quakewatch-web:latest`.

---

## 1. Deployment Steps

All Kubernetes manifest files are located in the `phase-2-kubernetes` directory. Apply them in the following order to ensure dependencies are met.

Navigate to the project's `phase-2-kubernetes` directory before running the commands.

### a. Apply Configuration and Secrets

First, create the `ConfigMap` and `Secret` resources. This separates configuration and sensitive data from the application image.

```bash
# Create the ConfigMap for non-sensitive configuration
kubectl apply -f quakewatch-configmap.yaml

# Create the Secret for sensitive data (e.g., API keys)
kubectl apply -f quakewatch-secret.yaml
````

### b. Deploy the Application

Next, create the `Deployment` and expose it with a `Service`. The Deployment is configured to use the ConfigMap and Secret, and includes health probes.

```bash
# Create the Deployment, which manages the application's Pods
kubectl apply -f quakewatch-deployment.yaml

# Expose the Deployment with a NodePort Service
kubectl apply -f quakewatch-service.yaml
```

### c. Deploy Supporting Resources

Finally, deploy the `CronJob` for periodic health checks and the `HorizontalPodAutoscaler` (HPA) for auto-scaling.

```bash
# Create a CronJob to run a health check every minute
kubectl apply -f quakewatch-cronjob.yaml

# Create the Horizontal Pod Autoscaler to manage replicas based on CPU load
kubectl apply -f quakewatch-hpa.yaml
```

-----

## 2\. Accessing the Application

Since this project uses Minikube, the most reliable way to access the application is by using the `minikube service` command. This command creates a stable network tunnel from your local machine to the service inside the cluster.

1.  **Run the following command:**
    ```bash
    minikube service quakewatch-web
    ```
2.  This command will automatically open the application in your default web browser. Keep the terminal window open to maintain the network tunnel.

-----

## 3\. Verifying Advanced Features

### ✅ ConfigMap and Secret Verification

  - **ConfigMap:** The main title on the application's home page should read "**Live Earthquake Data Dashboard**". This title is loaded dynamically from the `quakewatch-config` ConfigMap.
  - **Secret:** Below the main description, you should see the line "**API Key Status: Set**". This confirms that the application successfully loaded the `API_KEY` environment variable from the `quakewatch-secret` Secret.

### ✅ Liveness and Readiness Probes

You can inspect the running Pod to see that the health probes are configured and active.

1.  **Find the Pod name:**
    ```bash
    kubectl get pods
    ```
2.  **Describe the Pod:**
    ```bash
    kubectl describe pod <your-pod-name>
    ```
3.  In the output, you will see the `Liveness` and `Readiness` probe configurations, confirming they are active.

### ✅ CronJob Verification

The CronJob is scheduled to run every minute. You can watch it in action.

1.  **Watch the Jobs:**
    ```bash
    # See the jobs being created every minute
    kubectl get jobs
    ```
2.  **Check the logs of a completed Job's Pod:**
    ```bash
    # First, find a completed pod name
    kubectl get pods

    # Then, check its logs
    kubectl logs <cronjob-pod-name>
    ```
    A successful log will show a "Connecting to quakewatch-web..." message from `wget`.

### ✅ HPA (Auto-scaling) Verification

To test the HPA, you can generate artificial load and watch the application scale up.

1.  **Generate Load:**
    Run the following command in a new terminal. It will create a temporary Pod that bombards the service with requests.

    ```bash
    kubectl run -it --rm load-generator --image=busybox -- /bin/sh -c "while true; do wget -q -O- http://quakewatch-web; done"
    ```

2.  **Monitor the HPA:**
    In another terminal, watch the HPA status. You will see the `TARGETS` CPU percentage climb and the `REPLICAS` count increase from 1 up to 10.

    ```bash
    kubectl get hpa -w
    ```

3.  **Stop the load generator** by pressing `Ctrl+C` in its terminal. After a few minutes, you will see the number of replicas scale back down to 1.


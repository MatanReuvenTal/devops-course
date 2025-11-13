# Phase 3:
# Monitoring & Alerts

This phase contains monitoring configuration for QuakeWatch application using Prometheus, Grafana, and AlertManager.

## Files

- `quakewatch-prometheusrule.yaml` - Alert rules for Prometheus
- `quakewatch-servicemonitor.yaml` - ServiceMonitor for metrics collection (optional)

## Prerequisites

- Minikube cluster running
- Helm installed
- QuakeWatch application deployed (phase-2)

## Installation

### Install Prometheus Stack
```bash
# Add Helm repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus + Grafana + AlertManager
helm install prometheus-stack prometheus-community/kube-prometheus-stack
```

### Deploy Alerts
```bash
# Apply the PrometheusRule
kubectl apply -f quakewatch-prometheusrule.yaml

# (Optional) Apply the ServiceMonitor
kubectl apply -f quakewatch-servicemonitor.yaml
```

## Alerts

### QuakeWatchPodRestarting
- **Severity:** Warning
- **Condition:** Pod has restarted in the last 2 minutes
- **Duration:** 30 seconds
- **Action:** Investigate pod logs with `kubectl logs <pod-name> --previous`

### QuakeWatchPodNotReady
- **Severity:** Warning
- **Condition:** Pod is not in Ready state
- **Duration:** 1 minute
- **Action:** Check pod status with `kubectl describe pod <pod-name>`

### QuakeWatchNoPodsRunning
- **Severity:** Critical
- **Condition:** No QuakeWatch pods are running
- **Duration:** 2 minutes
- **Action:** Check deployment with `kubectl get deployment quakewatch-web`

## Access Monitoring

### Prometheus
```bash
kubectl port-forward svc/prometheus-stack-kube-prom-prometheus 9090:9090
```

Open: http://localhost:9090

**Useful queries:**
- `kube_pod_status_phase{pod=~"quakewatch-web.*"}`
- `kube_pod_container_status_restarts_total{pod=~"quakewatch-web.*"}`
- `container_memory_usage_bytes{pod=~"quakewatch-web.*"}`

### Grafana
```bash
kubectl port-forward svc/prometheus-stack-grafana 3000:80
```

Open: http://localhost:3000

**Login:**
- Username: `admin`
- Password: Get from secret:
```bash
  kubectl get secret prometheus-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode
```

**Dashboard:** QuakeWatch Monitoring (custom created)

### AlertManager
```bash
kubectl port-forward svc/prometheus-stack-kube-prom-alertmanager 9093:9093
```

Open: http://localhost:9093

## Testing Alerts

### Test Pod Restart Alert
```bash
# Delete a pod to trigger restart
kubectl delete pod $(kubectl get pods -l app=quakewatch -o jsonpath='{.items[0].metadata.name}')

# Check Prometheus alerts (wait 30-60 seconds)
# Go to Prometheus UI → Alerts
```

### Test Pod Down Alert
```bash
# Scale down to 0
kubectl scale deployment quakewatch-web --replicas=0

# Wait 2 minutes, check alerts

# Scale back up
kubectl scale deployment quakewatch-web --replicas=1
```

## Troubleshooting

### Alerts not showing up
```bash
# Check PrometheusRule was created
kubectl get prometheusrules

# Check Prometheus loaded the rules
# Go to Prometheus UI → Status → Rules → search for "quakewatch"
```

### Grafana dashboard not showing data

- Verify Prometheus is the data source
- Check time range (last 15 minutes)
- Verify pods are running: `kubectl get pods -l app=quakewatch`

## Cleanup
```bash
# Remove alerts
kubectl delete -f quakewatch-prometheusrule.yaml

# Uninstall Prometheus stack
helm uninstall prometheus-stack

# Delete namespace
kubectl delete namespace monitoring
```
# GitOps with ArgoCD

This phase implements GitOps practices using ArgoCD for continuous deployment.

## Installation
```bash
# Create namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for pods to be ready
kubectl get pods -n argocd -w
```

## Access ArgoCD UI
```bash
# Port forward
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Open: https://localhost:8080

**Login:**
- Username: `admin`
- Password:
```bash
  kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
```

## Create Application

### Via UI

1. Click "+ NEW APP"
2. Fill in details:
   - **Application Name:** `quakewatch-app`
   - **Project:** `default`
   - **Sync Policy:** `Automatic`
     - ✅ PRUNE RESOURCES
     - ✅ SELF HEAL
   - **Repository URL:** `https://github.com/MatanReuvenTal/devops-course`
   - **Revision:** `main`
   - **Path:** `final-project/phase-2-kubernetes`
   - **Cluster URL:** `https://kubernetes.default.svc`
   - **Namespace:** `default`
3. Click **CREATE**

### Via CLI (Alternative)
```bash
# Login to ArgoCD CLI
argocd login localhost:8080 --username admin --password  --insecure

# Create application
argocd app create quakewatch-app \
  --repo https://github.com/MatanReuvenTal/devops-course \
  --path final-project/phase-2-kubernetes \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --sync-policy automated \
  --self-heal \
  --auto-prune
```

## Testing GitOps

### Make a change
```bash
cd final-project/phase-2-kubernetes

# Edit ConfigMap
nano quakewatch-configmap.yaml

# Change APP_TITLE value
# Commit and push
git add quakewatch-configmap.yaml
git commit -m "Update app title via GitOps"
git push origin main
```

### Watch ArgoCD sync

- ArgoCD checks Git every 3 minutes
- Or click **REFRESH** in UI
- Watch sync status change to "Syncing" → "Synced"

### Restart pods to apply ConfigMap changes
```bash
kubectl rollout restart deployment quakewatch-web
```

## Application Health

ArgoCD monitors:
- ✅ Deployment status
- ✅ Pod health
- ✅ Service availability
- ✅ ConfigMap/Secret changes

## Rollback

### Via UI
1. Go to **HISTORY AND ROLLBACK**
2. Select previous revision
3. Click **ROLLBACK**

### Via CLI
```bash
argocd app rollback quakewatch-app
```

## Cleanup
```bash
# Delete application
argocd app delete quakewatch-app

# Uninstall ArgoCD
kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Delete namespace
kubectl delete namespace argocd
```
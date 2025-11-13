# Phase 3: Monitoring & Alerts

This phase contains monitoring configuration for QuakeWatch application.

## Files

- `quakewatch-prometheusrule.yaml` - Alert rules for Prometheus
- `quakewatch-servicemonitor.yaml` - ServiceMonitor for metrics collection

## Deployment
```bash
# Apply the PrometheusRule
kubectl apply -f quakewatch-prometheusrule.yaml

# Apply the ServiceMonitor (optional)
kubectl apply -f quakewatch-servicemonitor.yaml
```

## Alerts

### QuakeWatchPodRestarting
- **Severity:** Warning
- **Condition:** Pod restarts more than once in 5 minutes
- **Action:** Investigate pod logs

### QuakeWatchPodDown
- **Severity:** Critical
- **Condition:** Pod is not in Running state for 2 minutes
- **Action:** Check pod status and events

## Access Monitoring

### Prometheus
```bash
kubectl port-forward svc/prometheus-stack-kube-prom-prometheus 9090:9090
```
Open: http://localhost:9090

### Grafana
```bash
kubectl port-forward svc/prometheus-stack-grafana 3000:80
```
Open: http://localhost:3000
- Username: admin
- Password: Get from secret
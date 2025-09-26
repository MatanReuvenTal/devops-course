# Final Project: Building a Full-Scale DevOps Pipeline

This repository documents the final project for the DevOps Experts course. This is a rolling, multi-phase assignment designed to reinforce key DevOps skills. The goal is to progressively build a fully automated DevOps pipeline, from containerization to GitOps and monitoring.

---

## 💻 Tech Stack & Tools

This project utilizes a modern DevOps toolchain to build, deploy, and manage the application:

<p align="left">
  <a href="https://www.docker.com/" target="_blank" rel="noreferrer"><img src="https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white" alt="Docker"/></a>
  <a href="https://kubernetes.io" target="_blank" rel="noreferrer"><img src="https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white" alt="Kubernetes"/></a>
  <a href="https://helm.sh" target="_blank" rel="noreferrer"><img src="https://img.shields.io/badge/Helm-0F1689?style=for-the-badge&logo=Helm&logoColor=white" alt="Helm"/></a>
  <a href="https://github.com/features/actions" target="_blank" rel="noreferrer"><img src="https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white" alt="GitHub Actions"/></a>
  <a href="https://argoproj.github.io/cd/" target="_blank" rel="noreferrer"><img src="https://img.shields.io/badge/ArgoCD-F48332?style=for-the-badge&logo=argo&logoColor=white" alt="ArgoCD"/></a>
  <a href="https://prometheus.io/" target="_blank" rel="noreferrer"><img src="https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white" alt="Prometheus"/></a>
  <a href="https://grafana.com" target="_blank" rel="noreferrer"><img src="https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white" alt="Grafana"/></a>
  <a href="https://git-scm.com/" target="_blank" rel="noreferrer"><img src="https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white" alt="Git"/></a>
</p>

---

## 🚀 Project Phases

The project is divided into four main phases, each building upon the previous one.

* **Phase 1: Foundation - Docker**
    * **Objective:** Develop and containerize a Python Flask application, pushing the final image to Docker Hub.
    * **➡️ [View Phase 1 Documentation](./phase-1-flask-docker/README.md)**

* **Phase 2: Orchestration - Kubernetes**
    * **Objective:** Deploy the application on Kubernetes using ConfigMaps, Secrets, and auto-scaling mechanisms.
    * **➡️ [View Phase 2 Documentation](./phase-2-kubernetes/README.md)**

* **Phase 3: CI/CD & Package Management**
    * **Objective:** Implement version control with Git, set up CI/CD pipelines with GitHub Actions, and manage deployments with Helm.
    * *(Documentation coming soon)*

* **Phase 4: GitOps & Monitoring**
    * **Objective:** Apply GitOps principles with ArgoCD for automated deployments and implement monitoring with Prometheus and Grafana.
    * *(Documentation coming soon)*
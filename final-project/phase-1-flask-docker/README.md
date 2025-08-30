# Flask Docker Application

Simple Flask web application containerized with Docker using multi-stage builds.

---

## Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed and **running** 
- [Git](https://git-scm.com/downloads) installed  

---

## Quick Start

Clone the repository and run the containerized application:

```bash
git clone https://github.com/MatanReuvenTal/devops-course.git
cd devops-course/final-project/phase-1-flask-docker
docker-compose up -d
```
## Files Structure
```bash
├── Dockerfile          # Multi-stage build
├── docker-compose.yml  # Multi-service setup
├── app.py              # Flask application
├── requirements.txt    # Dependencies
└── README.md
```

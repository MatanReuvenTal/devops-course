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
## Access Application
Open: http://localhost:5000
## Run from Docker Hub
You can also pull and run the image directly from Docker Hub without building:
```bash
docker pull matanreuvental/quakewatch-web:latest
docker run -d -p 5000:5000 matanreuvental/quakewatch-web:latest
```
- [Link to repository](https://hub.docker.com/repository/docker/matanreuvental/quakewatch-web/general)
## Files Structure
```bash
├── Dockerfile          # Multi-stage build
├── docker-compose.yml  # Multi-service setup
├── app.py              # Flask application
├── requirements.txt    # Dependencies
└── README.md
```

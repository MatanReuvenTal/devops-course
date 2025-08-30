Flask Docker Application
Simple Flask web application containerized with Docker using multi-stage builds.
Prerequisites

Docker installed
Git installed

Quick Start
git clone https://github.com/MatanReuvenTal/devops-course.git
cd devops-course/final-project/phase-1-flask-docker
docker-compose up -d

Files Structure
├── Dockerfile          # Multi-stage build
├── docker-compose.yml  # multi-service setup
├── app.py              # Flask application
├── requirements.txt    # Dependencies
└── README.md

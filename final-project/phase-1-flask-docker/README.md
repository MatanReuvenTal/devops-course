# QuakeWatch: Dockerized Flask Application

This repository contains the source code for QuakeWatch, a Flask web application that displays real-time and historical earthquake data. The application is containerized using Docker with a multi-stage build for an optimized and lightweight final image.

This project serves as Phase 1 of the DevOps final project.

---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and **running**
- [Git](https://git-scm.com/downloads) installed

---

## Quick Start

Clone the repository and run the containerized application using Docker Compose:

```bash
git clone [https://github.com/MatanReuvenTal/devops-course.git](https://github.com/MatanReuvenTal/devops-course.git)
cd devops-course/final-project/phase-1-flask-docker/QuakeWatch
docker-compose up --build -d
```
Access Application
Once the container is running, open your browser and navigate to:
http://localhost:5000

Run from Docker Hub
You can also pull and run the pre-built image directly from Docker Hub without cloning the repository:

``` Bash

docker pull matanReuvenTal/quakewatch-web:latest
docker run -d -p 5000:5000 matanReuvenTal/quakewatch-web:latest

``` 
Link to Docker Hub Repository: [matanreuvental/quakewatch-web](https://hub.docker.com/repository/docker/matanreuvental/quakewatch-web/general)

Proving Persistence with Docker Volumes
This application uses a named Docker volume (quakewatch-logs) to persist log files, ensuring that log data is not lost when the container is removed or recreated.

Run the container with the volume:

```   Bash

docker-compose up -d
``` 
Generate some logs:
Access http://localhost:5000 a **few** times in your browser.

Check the logs inside the container:

``` Bash

docker-compose exec web tail -n 5 /app/logs/access.log
``` 
Remove the container completely:

``` Bash

docker-compose down
```
Start a new container instance:
 
```Bash

docker-compose up -d
``` 
Verify the old logs are still there:
The following command will display the same logs from before, proving the data persisted in the volume.

``` Bash

docker-compose exec web tail -n 5 /app/logs/access.log
``` 
Project Structure
The application is structured as follows:
``` bash
QuakeWatch/
├── Dockerfile              # Defines the multi-stage Docker build
├── docker-compose.yml      # Manages the web service and named volume
├── app.py                  # Main Flask application factory
├── dashboard.py            # Defines the application's routes and logic
├── utils.py                # Helper functions for data fetching
├── requirements.txt        # Python dependencies
├── static/
│   └── experts-logo.svg
└── templates/
    ├── base.html
    ├── main_page.html
    └── ... (other HTML files)
``` 
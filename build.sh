#!/bin/bash
echo "=== CI/CD Docker Build ==="
docker build -t my-ci-app:v1.0 .
echo "Образ собран: my-ci-app:v1.0"
echo "Для запуска: docker run -p 8080:80 my-ci-app:v1.0"

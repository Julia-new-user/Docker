'''bash
docker build -t my-ci-app:v1.0 .
docker run -d -p 8080:80 --name myapp my-ci-app:v1.0

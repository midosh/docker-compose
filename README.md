## Compose sample application
### NGINX proxy with GO backend

Project structure:
```
.
├── backend
│   ├── Dockerfile
│   └── main.go
├── docker-compose.yml
├── frontend
│   ├── Dockerfile
│   └── nginx.conf
└── README.md
```

[_docker-compose.yaml_](docker-compose.yaml)
```
version: "3.7"
services:
  frontend:
    build: frontend
    ports:
      - 80:80
    depends_on:
      - backend
  backend:
    build: backend
```
The compose file defines an application with two services `frontend` and `backend`.
When deploying the application, docker-compose maps port 80 of the frontend service container to the same port of the host as specified in the file.
Make sure port 80 on the host is not already in use.

## Deploy with docker-compose

```
$ docker-compose up -d
Building backend
[+] Building 424.3s (11/11) FINISHED
 => [internal] load build definition from Dockerfile                                                                                 
 => => transferring dockerfile: 299B                                                                                              
 => [internal] load .dockerignore                                                                                               
 => => transferring context:                                                                                                   
 => [internal] load metadata for docker.io/library/golang:alpine                                                                   
 => [auth] library/golang:pull token for registry-1.docker.io
...
WARNING: Image for service frontend was built because it did not already exist. To rebuild this image you must use `docker-compose build` or `docker-compose up --build`.
Creating docker-compose_backend_1 ... done
Creating docker-compose_frontend_1 ... done
```

## Expected result

Listing containers must show two containers running and the port mapping as below:
```
$ docker ps

06446d16bc1b   docker-compose_frontend   "/docker-entrypoint.…"   18 minutes ago       Up 18 minutes       0.0.0.0:80->80/tcp, :::80->80/tcp   docker-compose_frontend_1
029cc5d6a2eb   docker-compose_backend    "/usr/local/bin/back…"   18 minutes ago       Up 18 minutes                                           docker-compose_backend_1
```

After the application starts, navigate to `http://localhost:80` in your web browser or run:
```
$ curl localhost:80

                    .-"""-.
                   / .===. \
                   \/ 6 6 \/
                   ( \___/ )
      _________ooo__\_____/______________
     /                                   \
    |           Ahmed Ramadan             |
    |            FOLLOW ME :              |
    |    www.linkedin.com/in/arsharaf/    |
     \_______________________ooo_________/
                    |  |  |
                    |_ | _|
                    |  |  |
                    |__|__|
                    /-'Y'-\
                   (__/ \__)

```

Stop and remove the containers
```
$ docker-compose down
```

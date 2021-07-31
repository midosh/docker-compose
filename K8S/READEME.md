#  Deploy a Resilient Go Application to Kubernetes Cluster
### "build an example application written in Go and get it up and running locally on my development machine. Then I containerize the application with Docker, deploy it to a Kubernetes cluster, and create a Node Port Service that will serve as the public-facing entry point to your application."

## Objectives
- Create and run a sample golang backend microservice using a Deployment object.
- Use a Service object to send traffic to the backend microservice's multiple replicas.
- Create and run a nginx frontend microservice, also using a Deployment object.
- Configure the frontend microservice to send traffic to the backend microservice.
- Use a Service object of type=NodePort to expose the frontend microservice outside the cluster.
## Prerequisites
 Before you begin this tutorial, you will need the following:
- The docker command-line tool installed on your development machine.
- The kubectl command-line tool installed on your development machine. 
- A free account on Docker Hub to which you will push your Docker image.
- A Kubernetes cluster. 

## Creating the backend using a Deployment
The backend is a simple golang microservice. Here is the configuration file for the backend Deployment:


```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  selector:
    matchLabels:
      app: goapp-backend
      tier: backend
  replicas: 1
  template:
    metadata:
      labels:
        app: goapp-backend
        tier: backend
    spec:
      containers:
        - name: goapp-backend
          image: "arsharaf/backend:0.1"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: goapp-backend
    tier: backend
  ports:
  - protocol: TCP
    port: 80
    targetPort: http
```
 Create the backend Deployment:
```
 kubectl apply -f backend/backend-deployment.yaml
```
## Creating the frontend:

Now that you have your backend running, you can create a frontend that is accessible outside the cluster, and connects to the backend by proxying requests to it.

The frontend sends requests to the backend worker Pods by using the DNS name given to the backend Service. The DNS name is backend, which is the value of the name field of service in the backend-deployment.yaml configuration file.

The Pods in the frontend Deployment run a nginx image that is configured to proxy requests to the golang backend Service. Here is the nginx configuration file:
```
# The identifier Backend is internal to nginx, and used to name this specific upstream
upstream Backend {
    # hello is the internal DNS name used by the backend Service inside Kubernetes
    server hello;
}

server {
    listen 80;

    location / {
        # The following statement will proxy traffic to the upstream named Backend
        proxy_pass http://Backend;
    }
}
```
Similar to the backend, the frontend has a Deployment and a Service. An important difference to notice between the backend and frontend services, is that the configuration for the frontend Service has type: NodePort .
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  selector:
    matchLabels:
      app: goapp-frontend
      tier: frontend
  replicas: 1
  template:
    metadata:
      labels:
        app: goapp-frontend
        tier: frontend
    spec:
      containers:
        - name: nginx
          image: "arsharaf/frontend:0.1"
          imagePullPolicy: IfNotPresent
          lifecycle:
            preStop:
              exec:
                command: ["/usr/sbin/nginx","-s","quit"]

---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  selector:
    app: goapp-frontend
    tier: frontend
  ports:
  - protocol: "TCP"
    port: 80
    targetPort: 80
    nodePort: 30008
  type: NodePort
```
Create the frontend Deployment and Service:
```
kubectl apply -f frontend/forntend-deployment.yaml
```
## Interact with the frontend Service 
Once you've created a Service of type NodePort, you can use this command :
```
kubectl get svc frontend
```
This displays the configuration for the frontend Service .
```
NAME       TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE
frontend   NodePort   10.97.22.49   <none>        80:30008/TCP   51m
```
## Send traffic through the frontend
The frontend and backend are now connected. You can hit the endpoint by using the curl command on the  IP of your frontend Service.
```
curl http://localhost:30008
```
```

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
## Cleaning up 
To delete the Services, enter this command:
```
kubectl delete services frontend backend
```
To delete the Deployments, the ReplicaSets and the Pods that are running the backend and frontend applications, enter this command:
```
kubectl delete deployment frontend backend
```


🪄 Features

    Modular, reusable Python module: hailstone_py

    API endpoint (/hailstone) to compute a sequence

    Outputs:

        number of steps

        list of sequence steps

        textual summary

    Tested with pytest

    Docker-ready

    Cloud-ready: AWS Lambda (via Terraform), GCP, Azure

    Multi-environment ready: dev, test, pre-prod, prod

    istall dependencies:
    pip install -r requirements.txt


    To Run Locally:
        uvicorn api_py.api:app --reload
    
    To test:
        pytest
    
    
    Dockerbbuild:
        docker build -t hailstone-app:dev .
        docker run -p 8000:8000 hailstone-app:dev
    
    Multi-Environments

    This project supports dev, test, pre-prod, and prod environments.

    ✅ In Terraform, we can use a different S3 key or workspace per environment.
    ✅ In Docker, tag the image accordingly: dev, prod, 
    we can also use multi build stage for our prod dockerfile to improve performance and ensure security


    Kubernetes:
         we can also run this on kubernetes after provisioning the eks cluster and necessary nodes.

we can also use InferenceService if implemented with MLflow. 
    
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: hailstone-app
    spec:
      replicas: 2
      selector:
        matchLabels:
          app: hailstone
      template:
        metadata:
          labels:
            app: hailstone
        spec:
          containers:
          - name: hailstone
            image: cherrychristie1/hailstone-app:dev
            ports:
            - containerPort: 8000
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: hailstone-service
    spec:
      type: LoadBalancer
      selector:
        app: hailstone
      ports:
    - protocol: TCP
      port: 80
      targetPort: 8000

      For k8s prod or pre-prod, we can use network policies and use HPA, allocate resources to ensue sufficent resource. we can implement monitoring as well to ensure that the performance is as expected. 

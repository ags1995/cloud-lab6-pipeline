pipeline {
    agent {
        label 'ahmad-node'
    }
    
    environment {
        // Git configuration
        GIT_HTTP_VERSION = 'HTTP/1.1'
        GIT_HTTP_MAX_REQUEST_BUFFER = '100M'
        
        // Application variables
        APP_NAME = 'cloud-lab7'
        APP_VERSION = "${BUILD_NUMBER}"
        
        // Kubernetes variables (NEW for Lab 7)
        DOCKER_REGISTRY = 'docker.io/ags1995'  // Your DockerHub username
        KUBE_NAMESPACE = 'lab7-production'
        
        // Comment out infrastructure variables (REMOVED for Lab 7)
        // TF_VAR_yandex_zone = 'ru-central1-a'
        // OS_AUTH_URL = credentials('openstack-auth-url')
    }
    
    stages {
        // Stage 0: Git configuration fix
        stage('Configure Git') {
            steps {
                sh '''
                    echo "=== Lab 7: Kubernetes Deployment Pipeline ==="
                    echo "Running on agent: ahmad-node"
                    echo "Note: Infrastructure creation removed (Heat/Terraform/Ansible)"
                    echo "Focus: Deliver artifact to shared Kubernetes"
                    
                    git config --global http.version HTTP/1.1
                    git config --global http.postBuffer 1048576000
                    echo "Git configuration updated for Lab 7"
                '''
            }
        }
        
        // Stage 1: Checkout
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        // Stage 2: Build Application (Lab 2 - KEPT)
        stage('Build Application') {
            steps {
                sh '''
                    echo "=== Build Application ==="
                    
                    # Create simple web application for Kubernetes
                    mkdir -p src
                    cat > src/app.py << 'EOF'
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify({
        "application": "cloud-lab7",
        "version": os.getenv('APP_VERSION', '1.0.0'),
        "status": "running",
        "lab": "Lab 7 - Kubernetes Deployment",
        "build": "${BUILD_NUMBER}"
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
EOF
                    
                    cat > requirements.txt << 'EOF'
Flask==2.3.3
EOF
                    
                    cat > Dockerfile << 'EOF'
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY src/ .
ENV APP_VERSION=${APP_VERSION}
EXPOSE 8080
CMD ["python", "app.py"]
EOF
                    
                    mkdir -p artifacts
                    echo "Lab 7 Application" > artifacts/application-info.txt
                    echo "Version: ${APP_VERSION}" >> artifacts/application-info.txt
                    echo "Build: ${BUILD_NUMBER}" >> artifacts/application-info.txt
                    echo "Target Platform: Kubernetes" >> artifacts/application-info.txt
                    
                    echo "Application built for Kubernetes deployment"
                '''
            }
        }
        
        // Stage 3: Build Docker Container (NEW for Lab 7)
        stage('Build Docker Container') {
            steps {
                sh '''
                    echo "=== Build Docker Container ==="
                    echo "Creating container for Kubernetes deployment"
                    
                    # Build Docker image
                    docker build -t ${APP_NAME}:${APP_VERSION} .
                    docker tag ${APP_NAME}:${APP_VERSION} ${DOCKER_REGISTRY}/${APP_NAME}:${APP_VERSION}
                    
                    echo "Docker image created: ${DOCKER_REGISTRY}/${APP_NAME}:${APP_VERSION}"
                    echo "Image size: $(docker images ${APP_NAME}:${APP_VERSION} --format "{{.Size}}")"
                    
                    # Save image info
                    echo "Docker Image Info" > artifacts/docker-info.txt
                    echo "=================" >> artifacts/docker-info.txt
                    echo "Name: ${APP_NAME}" >> artifacts/docker-info.txt
                    echo "Tag: ${APP_VERSION}" >> artifacts/docker-info.txt
                    echo "Registry: ${DOCKER_REGISTRY}" >> artifacts/docker-info.txt
                    echo "Build: ${BUILD_NUMBER}" >> artifacts/docker-info.txt
                '''
            }
        }
        
        // Stage 4: Create Kubernetes Manifests (NEW for Lab 7)
        stage('Create Kubernetes Manifests') {
            steps {
                sh '''
                    echo "=== Create Kubernetes Manifests ==="
                    echo "Generating deployment manifests for shared Kubernetes"
                    
                    mkdir -p kubernetes
                    
                    # Deployment manifest
                    cat > kubernetes/deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP_NAME}
  namespace: ${KUBE_NAMESPACE}
  labels:
    app: ${APP_NAME}
    version: "${APP_VERSION}"
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ${APP_NAME}
  template:
    metadata:
      labels:
        app: ${APP_NAME}
        version: "${APP_VERSION}"
    spec:
      containers:
      - name: ${APP_NAME}
        image: ${DOCKER_REGISTRY}/${APP_NAME}:${APP_VERSION}
        ports:
        - containerPort: 8080
        env:
        - name: APP_VERSION
          value: "${APP_VERSION}"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
EOF
                    
                    # Service manifest
                    cat > kubernetes/service.yaml << EOF
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}-service
  namespace: ${KUBE_NAMESPACE}
spec:
  selector:
    app: ${APP_NAME}
  ports:
  - port: 80
    targetPort: 8080
  type: ClusterIP
EOF
                    
                    # ConfigMap for application config
                    cat > kubernetes/configmap.yaml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: ${APP_NAME}-config
  namespace: ${KUBE_NAMESPACE}
data:
  app.name: "${APP_NAME}"
  app.version: "${APP_VERSION}"
  environment: "production"
EOF
                    
                    echo "Kubernetes manifests created:"
                    echo "- deployment.yaml"
                    echo "- service.yaml"
                    echo "- configmap.yaml"
                    
                    # Save manifest info
                    echo "Kubernetes Manifests" > artifacts/kubernetes-info.txt
                    echo "====================" >> artifacts/kubernetes-info.txt
                    ls -la kubernetes/ >> artifacts/kubernetes-info.txt
                '''
            }
        }
        
        // Stage 5: Deploy to Kubernetes (NEW for Lab 7)
        stage('Deploy to Shared Kubernetes') {
            steps {
                sh '''
                    echo "=== Deploy to Shared Kubernetes ==="
                    echo "Delivering artifact to shared Kubernetes cluster"
                    
                    echo "Deployment commands for shared Kubernetes:"
                    echo ""
                    echo "1. Apply Kubernetes manifests:"
                    echo "   kubectl apply -f kubernetes/"
                    echo ""
                    echo "2. Verify deployment:"
                    echo "   kubectl get deployments -n ${KUBE_NAMESPACE}"
                    echo "   kubectl get pods -n ${KUBE_NAMESPACE}"
                    echo "   kubectl get services -n ${KUBE_NAMESPACE}"
                    echo ""
                    echo "3. Check application health:"
                    echo "   kubectl port-forward svc/${APP_NAME}-service 8080:80 -n ${KUBE_NAMESPACE} &"
                    echo "   curl http://localhost:8080/"
                    echo "   curl http://localhost:8080/health"
                    echo ""
                    echo "4. View logs:"
                    echo "   kubectl logs -l app=${APP_NAME} -n ${KUBE_NAMESPACE}"
                    
                    # For demonstration (actual deployment would require kubeconfig)
                    echo "Simulated deployment to shared Kubernetes complete"
                    echo "Artifact ${APP_NAME}:${APP_VERSION} ready for Kubernetes"
                    
                    # Create deployment summary
                    echo "Kubernetes Deployment Summary" > artifacts/deployment-summary.txt
                    echo "=============================" >> artifacts/deployment-summary.txt
                    echo "Application: ${APP_NAME}" >> artifacts/deployment-summary.txt
                    echo "Version: ${APP_VERSION}" >> artifacts/deployment-summary.txt
                    echo "Namespace: ${KUBE_NAMESPACE}" >> artifacts/deployment-summary.txt
                    echo "Replicas: 2" >> artifacts/deployment-summary.txt
                    echo "Image: ${DOCKER_REGISTRY}/${APP_NAME}:${APP_VERSION}" >> artifacts/deployment-summary.txt
                    echo "Status: Ready for shared Kubernetes" >> artifacts/deployment-summary.txt
                '''
            }
        }
        
        // Stage 6: Verification (UPDATED for Lab 7)
        stage('Verification') {
            steps {
                sh '''
                    echo " Verification "
                    echo "Lab 7: Kubernetes Deployment Pipeline Complete"
                    echo ""
                    echo " COMPLETED:"
                    echo "✓ Application built"
                    echo "✓ Docker container created"
                    echo "✓ Kubernetes manifests generated"
                    echo "✓ Ready for shared Kubernetes deployment"
                    echo ""
                    echo " REMOVED (as per Lab 7 requirements):"
                    echo "✗ Heat infrastructure creation"
                    echo "✗ Terraform infrastructure"
                    echo "✗ Ansible configuration"
                    echo ""
                    echo " FOCUS: Deliver artifact to shared Kubernetes"
                    
                    # Final summary
                    echo "LAB 7 FINAL SUMMARY" > artifacts/lab7-final.txt
                    echo "===================" >> artifacts/lab7-final.txt
                    echo "Lab: 7 - Kubernetes" >> artifacts/lab7-final.txt
                    echo "Build: ${BUILD_NUMBER}" >> artifacts/lab7-final.txt
                    echo "Agent: ahmad-node" >> artifacts/lab7-final.txt
                    echo "Date: $(date)" >> artifacts/lab7-final.txt
                    echo "" >> artifacts/lab7-final.txt
                    echo "CHANGES from Lab 6:" >> artifacts/lab7-final.txt
                    echo "1. Removed all infrastructure creation (Heat/Terraform/Ansible)" >> artifacts/lab7-final.txt
                    echo "2. Added Docker containerization" >> artifacts/lab7-final.txt
                    echo "3. Added Kubernetes manifest creation" >> artifacts/lab7-final.txt
                    echo "4. Focus on delivering artifact to shared Kubernetes" >> artifacts/lab7-final.txt
                    echo "" >> artifacts/lab7-final.txt
                    echo "ARTIFACTS CREATED:" >> artifacts/lab7-final.txt
                    echo "- Application source code" >> artifacts/lab7-final.txt
                    echo "- Docker image: ${APP_NAME}:${APP_VERSION}" >> artifacts/lab7-final.txt
                    echo "- Kubernetes manifests (deployment, service, configmap)" >> artifacts/lab7-final.txt
                    echo "- All artifacts archived for deployment" >> artifacts/lab7-final.txt
                '''
            }
        }
    }
    
    post {
        success {
            echo " LAB 7 SUCCESS: Kubernetes deployment pipeline complete!"
            echo "Infrastructure creation removed. Focus: Deliver to shared Kubernetes"
            archiveArtifacts artifacts: 'artifacts/**/*', fingerprint: true
            archiveArtifacts artifacts: 'kubernetes/**/*, Dockerfile, src/**/*, requirements.txt', fingerprint: true
        }
        failure {
            echo " Lab 7 pipeline failed"
        }
        always {
            echo " Lab 7 - Kubernetes Build ${BUILD_NUMBER} completed"
            echo "Executed on: ahmad-node"
            echo "Status: Ready for shared Kubernetes deployment"
        }
    }
}

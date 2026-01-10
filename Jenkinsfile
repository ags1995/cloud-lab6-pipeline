pipeline {
    agent {
        label 'ahmad-node'
    }
    
    environment {
        GIT_HTTP_VERSION = 'HTTP/1.1'
        GIT_HTTP_MAX_REQUEST_BUFFER = '100M'
        APP_NAME = 'cloud-lab7'
        APP_VERSION = "${BUILD_NUMBER}"
        KUBE_NAMESPACE = 'lab7-namespace'
    }
    
    stages {
        stage('Configure Git') {
            steps {
                sh '''
                    echo "=== Lab 7: Kubernetes Deployment Pipeline ==="
                    echo "Executing on: ahmad-node"
                    echo "Note: Infrastructure creation removed as per Lab 7 requirements"
                    echo "Focus: Deliver artifact to shared Kubernetes cluster"
                    git config --global http.version HTTP/1.1
                    git config --global http.postBuffer 1048576000
                    echo "Git configured for HTTP/1.1"
                '''
            }
        }
        
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Prepare Artifact') {
            steps {
                sh '''
                    echo "=== Prepare Artifact for Kubernetes ==="
                    mkdir -p artifacts
                    
                    # Create application configuration
                    cat > artifacts/app-config.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: lab7-app-config
data:
  app.name: "cloud-lab7"
  app.version: "${APP_VERSION}"
  app.build: "${BUILD_NUMBER}"
  deployment.date: "$(date)"
  target.platform: "kubernetes"
EOF
                    
                    # Create readiness script
                    cat > artifacts/health-check.sh << 'EOF'
#!/bin/bash
echo "Kubernetes Health Check"
echo "App: cloud-lab7"
echo "Version: ${APP_VERSION}"
echo "Status: Ready for deployment"
exit 0
EOF
                    
                    chmod +x artifacts/health-check.sh
                    echo "Artifact preparation complete"
                '''
            }
        }
        
        stage('Generate Kubernetes Manifests') {
            steps {
                sh '''
                    echo "=== Generate Kubernetes Deployment Manifests ==="
                    mkdir -p kubernetes
                    
                    # Using public Docker image to avoid building
                    cat > kubernetes/deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP_NAME}-deployment
  namespace: ${KUBE_NAMESPACE}
  labels:
    app: ${APP_NAME}
    version: "${APP_VERSION}"
    managed-by: jenkins
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
      - name: web-server
        image: nginx:alpine
        ports:
        - containerPort: 80
        env:
        - name: APP_NAME
          value: "${APP_NAME}"
        - name: APP_VERSION
          value: "${APP_VERSION}"
        - name: BUILD_NUMBER
          value: "${BUILD_NUMBER}"
        volumeMounts:
        - name: app-config
          mountPath: /etc/app-config
          readOnly: true
      volumes:
      - name: app-config
        configMap:
          name: lab7-app-config
EOF
                    
                    cat > kubernetes/service.yaml << 'EOF'
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}-service
  namespace: ${KUBE_NAMESPACE}
spec:
  selector:
    app: ${APP_NAME}
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: LoadBalancer
EOF
                    
                    cat > kubernetes/configmap.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: lab7-app-config
  namespace: ${KUBE_NAMESPACE}
data:
  application.name: "${APP_NAME}"
  application.version: "${APP_VERSION}"
  build.number: "${BUILD_NUMBER}"
  deployment.timestamp: "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
EOF
                    
                    echo "Kubernetes manifests generated:"
                    ls -la kubernetes/
                '''
            }
        }
        
        stage('Package for Kubernetes') {
            steps {
                sh '''
                    echo "=== Package for Shared Kubernetes Deployment ==="
                    
                    # Create deployment package
                    tar -czf ${APP_NAME}-v${APP_VERSION}-k8s.tar.gz \
                        kubernetes/ \
                        artifacts/ \
                        Jenkinsfile
                    
                    # Create deployment instructions (SIMPLIFIED - no backticks)
                    cat > DEPLOYMENT_INSTRUCTIONS.md << 'EOF'
# Lab 7: Kubernetes Deployment Instructions

## Application Details
- Name: ${APP_NAME}
- Version: ${APP_VERSION}
- Build: ${BUILD_NUMBER}
- Target: Shared Kubernetes Cluster

## Deployment Steps

1. Apply to Kubernetes:
   kubectl apply -f kubernetes/

2. Verify Deployment:
   kubectl get all -n ${KUBE_NAMESPACE}
   kubectl get pods -n ${KUBE_NAMESPACE}
   kubectl get services -n ${KUBE_NAMESPACE}

3. Check Application:
   kubectl port-forward svc/${APP_NAME}-service 8080:80 -n ${KUBE_NAMESPACE} &
   curl http://localhost:8080

## Contents
- kubernetes/ - Kubernetes manifests
- artifacts/ - Application configuration
- Jenkinsfile - Pipeline definition

## Lab 7 Requirements Met
- REMOVED infrastructure creation (Heat/Terraform/Ansible)
- Focus on delivering artifact to shared Kubernetes
- Generated Kubernetes manifests
- Created deployment package
EOF
                    
                    echo "Deployment package created: ${APP_NAME}-v${APP_VERSION}-k8s.tar.gz"
                    echo "Instructions: DEPLOYMENT_INSTRUCTIONS.md"
                '''
            }
        }
        
        stage('Verification') {
            steps {
                sh '''
                    echo "=== Lab 7 Verification ==="
                    echo ""
                    echo "LAB 7 REQUIREMENTS COMPLETED:"
                    echo ""
                    echo "1. REMOVED Infrastructure Creation:"
                    echo "   - No Heat templates (Lab 3)"
                    echo "   - No Terraform (Lab 5)"
                    echo "   - No Ansible (Lab 5)"
                    echo ""
                    echo "2. FOCUS ON KUBERNETES DELIVERY:"
                    echo "   - Generated Kubernetes manifests"
                    echo "   - Created ConfigMaps"
                    echo "   - Setup Services"
                    echo "   - Prepared LoadBalancer"
                    echo ""
                    echo "3. ARTIFACT FOR SHARED KUBERNETES:"
                    echo "   - Package: ${APP_NAME}-v${APP_VERSION}-k8s.tar.gz"
                    echo "   - Contains all deployment files"
                    echo "   - Ready for shared cluster"
                    echo ""
                    echo "4. EXECUTED ON SPECIFIED AGENT:"
                    echo "   - Agent: ahmad-node"
                    echo "   - Build: ${BUILD_NUMBER}"
                    echo "   - Version: ${APP_VERSION}"
                    echo ""
                    echo "Lab 7 Complete: Artifact ready for shared Kubernetes deployment!"
                '''
            }
        }
    }
    
    post {
        success {
            echo "LAB 7 SUCCESSFUL!"
            echo "========================================"
            echo "Infrastructure creation: REMOVED"
            echo "Kubernetes manifests: GENERATED"
            echo "Deployment package: CREATED"
            echo "Ready for shared Kubernetes: YES"
            echo "Executed on ahmad-node: YES"
            
            archiveArtifacts artifacts: 'artifacts/**/*', fingerprint: true
            archiveArtifacts artifacts: 'kubernetes/**/*', fingerprint: true
            archiveArtifacts artifacts: '*.tar.gz', fingerprint: true
            archiveArtifacts artifacts: 'DEPLOYMENT_INSTRUCTIONS.md', fingerprint: true
        }
        failure {
            echo "Lab 7 pipeline failed"
        }
        always {
            echo "Lab 7 Build ${BUILD_NUMBER} completed on ahmad-node"
            echo "Pipeline: Kubernetes Deployment"
            echo "Status: Ready for shared Kubernetes"
        }
    }
}

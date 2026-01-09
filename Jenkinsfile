pipeline {
    agent any
    
    environment {
        // Set environment variables for Git
        GIT_HTTP_VERSION = 'HTTP/1.1'
        GIT_HTTP_MAX_REQUEST_BUFFER = '100M'
    }
    
    stages {
        stage('Configure Git') {
            steps {
                script {
                    // Apply Git configuration fixes
                    sh '''
                        echo "Configuring Git for HTTP/1.1..."
                        git config --global http.version HTTP/1.1
                        git config --global http.postBuffer 1048576000
                        git config --global core.compression 0
                        echo "Git configuration updated"
                        
                        # Verify the settings
                        echo "Current Git HTTP settings:"
                        git config --global --get http.version
                        git config --global --get http.postBuffer
                    '''
                }
            }
        }
        
        stage('Checkout Code') {
            steps {
                retry(3) {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: '*/main']],
                        extensions: [],
                        userRemoteConfigs: [[
                            url: 'https://github.com/ags1995/cloud-lab6-pipeline.git'
                        ]]
                    ])
                }
            }
        }
        
        stage('Build') {
            steps {
                echo "Build stage - add your actual build steps here"
            }
        }
    }
}

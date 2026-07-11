@Library('Shared') _
pipeline {
    agent any

    environment {
        SONAR_HOME = tool name: 'Sonar'
    }

    parameters {
        string(name: 'FRONTEND_DOCKER_TAG', defaultValue: '', description: 'Enter the Docker tag for the frontend image')
        string(name: 'BACKEND_DOCKER_TAG', defaultValue: '', description: 'Enter the Docker tag for the backend image')
    }

    stages {
        stage("Validate Parameters") {
            steps{
                script {
                    if (params.FRONTEND_DOCKER_TAG == '' || params.BACKEND_DOCKER_TAG == '') {
                        error("Both FRONTEND_DOCKER_TAG and BACKEND_DOCKER_TAG parameters must be provided.")
                    }
                }
            }
        }

        stage("Workspace Cleanup") {
            steps {
                script {
                    cleanWs()
                }
            }
        }

        stage("Git: Code Checkout"){
            steps {
                script {
                    code_checkout("https://github.com/iamsnyg/devops-big-project-wonderlust.git", "main")
                }
            }
        }

        stage("Trivy: File System Scan"){
            steps {
                script {
                    trivy_scan();
                }
            }
        }

        stage("OWASP Dependency Check"){
            steps {
                script {
                    owasp_dependency()
                }
            }
        }

        stage("SonarQube: Code Quality Analysis"){
            steps {
                script {
                    sonarqube_analysis('Sonar', "wanderlust", "wanderlust")
                }
            }
        }

        stage("SonarQube: Code Quality Gate"){
            steps {
                script {
                    sonarqube_code_quality()
                }
            }
        }

        stage("Exporting Environment Variables"){
            parallel {
                stage("Backend Environment setup"){
                    steps {
                        script {
                            dir("Automations"){
                                sh "bash updatebackendnew.sh"
                            }
                        }
                    }
                }


                stage("Frontend Environment setup"){
                    steps {
                        script {
                            dir("Automations"){
                                sh "bash updatefrontendnew.sh"
                            }
                        }
                    }
                }
            }
        }

        stage("Docker: Build Images"){
            steps {
                script {
                    dir("backend"){
                        docker_build("wanderlust-backend-beta","${params.BACKEND_DOCKER_TAG}","iamsnyg")
                    }


                    dir("frontend"){
                        docker_build("wanderlust-frontend-beta","${params.FRONTEND_DOCKER_TAG}","iamsnyg")
                    }
                }
            }
        }

        stage("Docker: Push Images"){
            steps {
                docker_push("wanderlust-backend-beta","${params.BACKEND_DOCKER_TAG}","iamsnyg")
                docker_push("wanderlust-frontend-beta","${params.FRONTEND_DOCKER_TAG}","iamsnyg")
            }
        }

        post{
            success {
                archiveArtifacts artifacts: '*.xml', followSymlinks: false
                build job: 'Wanderlust-CD', parameters: [
                    string(name: 'FRONTEND_DOCKER_TAG', value: "${params.FRONTEND_DOCKER_TAG}"),
                    string(name: 'BACKEND_DOCKER_TAG', value: "${params.BACKEND_DOCKER_TAG}")
                ]
            }
        }
    }

}

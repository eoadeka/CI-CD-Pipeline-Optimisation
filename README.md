# CONTINUOUS INTEGRATION AND CONTINUOUS DEPLOYMENT (CI/CD) PIPELINE OPTIMISTION

This project focuses on automating the continuous integration and continuous deployment (CI/CD) of a web application using Jenkins and Docker. The goal is to streamline the development process, reduce manual intervention, and ensure efficient and reliable application delivery.

## DEVOPS LIFECYCLE


## ARCHITECTURAL DIAGRAM


## TECHNOLOGIES & TOOLS
- Planning (Jira)
- Code Writing (Visual Studio Code)
- Web Application Framework (Python (Flask))
- Version Control (Git)
- Build Automation (Jenkins)
- Artifact Storage (JFrog Artifactory)
- Containerisation (Docker)
- Infrastructure as Code (IaC) (Terraform)
- Integration Testing Framework (pytest)
- Cloud Service (Amazon Web Services (AWS))
- Release Manager (GitHub Actions)
- Monitoring & Logging (Prometheus and Grafana)

## TASKS
1. **Web Application Setup**:
    Create a simple web application using Flask web framework
2. **Version Control Setup**:
    Initialize a Git repository for the web application and set up a remote repository (on GitHub).
3. **Jenkins Setup**:
    Install and configure Jenkins on a server or cloud instance.
4. **Create Jenkins Jobs**:
    Create Jenkins jobs for the CI/CD pipeline, including build, test, and deployment stages.
5. **Automate Build Stage**:
    Write a Jenkinsfile (or use the declarative pipeline syntax) to automate the build process. This could include compiling code, installing dependencies, and creating a deployable artifact.
6. **Automated Testing**:
    Integrate automated testing (unit and integration tests) into the pipeline. Use the appropriate testing frameworks and ensure that tests are executed automatically.
7. **Dockerization**:
    Create a Dockerfile to containerize the web application. Build and push Docker images to a container registry.
8. **Automate Deployment**:
    Write deployment scripts to deploy the web application using Docker containers. Ensure that deployments can be triggered automatically from the CI/CD pipeline.
9. **Monitoring and Logging**:
    Implement monitoring and logging using Docker logs and monitoring tools (e.g., Prometheus and Grafana).
10. **Documentation and Reporting**:
    Create documentation that outlines the CI/CD pipeline's architecture and how to trigger builds, tests, and deployments. Generate reports on the pipeline's performance.
11. **CI/CD Pipeline Optimization**:
    Continuously monitor the CI/CD pipeline's performance, identify bottlenecks, and optimize the workflow for faster and more reliable delivery.
    
## STEPS
1. Set up the web application
2. Set up Version Control
3. Set up Jenkins
    a. Install Github Integration Plugin in Jenkins in order for Jenkins to work with our GitHub repo.
    b. Configure webhook
        -Navigate to project repository on Github > webhooks
        - Click "add webhook"
        - Configure the following:
            - Payload URL: https://f475-82-3-193-54.ngrok.io/ghprbhook/ 
                ngrok.exe http <port-number> (e.g. 80)
            - Content type: application/json
            - Secret: <leave empty>
            - Which events would you like to trigger this webhook?: 
                Choose "Let me select individual events"
                    Select "Pull Requests" and "Pushes"
            - Make sure "Active is checked/ticked
        - Add webhook
    c. Create Jenkins project
        - In Jenkins, click '**New Item**' to create a new project.
        - Enter item name as '***CICDPipelineOptimisation***' 
        - Chose '***Pipeline***' as project
        - Create Project
        - Configure Pipeline
            - Enter 'A CI/CD Pipeline' as the description
            - Tick '**Github Project**' and enter the project url
            - Configure Build Triggers
                - Tick '***GitHub hook trigger for GITScm polling***' to allow Jenkins work whenever a push is made to GitHub
            - COnfigure pipeline
                - Set '***Pipeline script from SCM***' as Definition
                - Choose Git as SCM
                - Enter the repositories details
                - Enter Jenkinsfile as Script Path
            - Save

4. Automate Build Stage
5. Store Artifact
6. Set up Development Environment
6. Set up Testing Environment

## SIMULATION

## RESULTS
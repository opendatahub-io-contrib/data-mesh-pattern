## 🐑️ Initialize Git Repositories, Login to JupyterHub
## Initialize a DAG repository for Airflow

We need to set up our Data Science JupyterHub environment so we can run the Airflow demo's. Let's do that now.

1. Login to Gitlab and under your group <TEAM_NAME> create a dag project repo called **daintree-dev-dags**

   ![1-dags-repo](./images/1-dags-repo.png)

2. In DevSpaces initialize the dags repo.

    ```bash
    cd /projects
    git clone https://<GIT_SERVER>/<TEAM_NAME>/daintree-dev-dags.git
    cd daintree-dev-dags
    echo "# rainforest/daintree-dev-dags" > README.md
    echo "# ignore the symlinked directory" > .airflowignore
    echo "daintree-dev-dags.git" >> .airflowignore
    git add README.md .airflowignore
    git commit -m "🦩 initial commit 🦩"
    git branch -M main
    git push -u origin main
    ```

## Clone code demo repo

3. Clone our demo code repo. The token will be provided by your instructor.

   ```bash
   export GITHUB_TOKEN=<token>
   ```

   ```bash
   cd /projects/
   git clone https://eformat:${GITHUB_TOKEN}@github.com/eformat/aiml-demos.git
   ```

4. Create an Internal project in Gitlab called **aiml-demos** and push the code.

   ![1-aiml-demo-repo](./images/1-aiml-demo-repo.png)

    ```bash
    cd /projects/aiml-demos
    git remote set-url origin https://${GITLAB_USER}:${GITLAB_PAT}@${GIT_SERVER}/${TEAM_NAME}/aiml-demos.git
    ```

   Use the `GITLAB_PAT` from above when you are prompted for the password (this will be cached)

    ```bash
    cd /projects/aiml-demos
    git add .
    git commit -am "🐙 ADD - aiml-demos 🐙"
    git push -u origin --all
    ```

## Login to JupyterHub

5. Login to daintree-dev project in OpenShift. Browse to the Jupyterhub route. Login as your **USER_NAME** using the **OpenShift v4** button and **FreeIPA** identity provider. You will be prompted to allow **OAuth permissions** the first time you login.

   ```bash
   echo -e https://$(oc get route jupyterhub --template='{{ .spec.host }}' -n ${PROJECT_NAME})
   ```

   ![1-jhub-landing-page](./images/1-jhub-landing-page.png)

6. Select the **Elyra Notebook Image - v0.1.5**. Select the **Default** container size. Add the following **Environment variables** which you can get from the DevSpaces terminal.

   ```bash
   echo $CLUSTER_DOMAIN
   echo $TEAM_NAME
   echo $PROJECT_NAME   
   echo $GITLAB_USER
   echo $GITLAB_PAT
   echo $GIT_SERVER
   ```
   
   ```bash
   AWS_ACCESS_KEY_ID=$(oc get secret s3-auth -n ${PROJECT_NAME} -o jsonpath='{.data.AWS_ACCESS_KEY_ID}' | base64 -d)
   echo $AWS_ACCESS_KEY_ID
   ```
   
   ```bash
   AWS_SECRET_ACCESS_KEY=$(oc get secret s3-auth -n ${PROJECT_NAME} -o jsonpath='{.data.AWS_SECRET_ACCESS_KEY}' | base64 -d)
   echo $AWS_SECRET_ACCESS_KEY
   ```

   ![1-jhub-env-vars](./images/1-jhub-env-vars.png)

7. Click **Start server** button.

   ![1-jhub-start-server](./images/1-jhub-start-server.png)

8. Once your notebook has opened, Click **Terminal** and clone the aiml-demos repo.

   ```bash
   git clone https://${GITLAB_USER}:${GITLAB_PAT}@${GIT_SERVER}/${TEAM_NAME}/aiml-demos.git
   ```

   ![jhub-aiml-demo-repo](./images/1-jhub-aiml-demo-repo.png)

## Setup Elyra Airflow

9. Add the **airflow-runner** container image from the terminal.

   ```json
   mkdir -p ~/.local/share/jupyter/metadata/runtime-images/
   cat << EOF > ~/.local/share/jupyter/metadata/runtime-images/airflow-runner.json
   {
     "display_name": "airflow-runner",
     "metadata": {
       "tags": [],
       "display_name": "airflow-runner",
       "image_name": "image-registry.openshift-image-registry.svc:5000/<TEAM_NAME>-ci-cd/airflow-runner:2.5.1",
       "pull_policy": "Always"
     },
     "schema_name": "runtime-image"
   }
   EOF
   ```
   
   Once added, Select the **Runtime Images** navigation on the left side panel to view the added image.

   ![jhub-runner-image](./images/1-jhub-runner-image.png)

10. Add the **ariflow** runtime configuration.

   ```json
   mkdir -p ~/.local/share/jupyter/metadata/runtimes
   cat << EOF >  ~/.local/share/jupyter/metadata/runtimes/airflow.json
   {
      "display_name": "airflow",
      "metadata": {
         "tags": [],
         "display_name": "airflow",
         "user_namespace": "daintree-dev",
         "git_type": "GITLAB",
         "github_api_endpoint": "https://${GIT_SERVER}",
         "api_endpoint": "https://airflow-daintree-dev.${CLUSTER_DOMAIN}",
         "github_repo": "rainforest/daintree-dev-dags",
         "github_branch": "main",
         "github_repo_token": "${GITLAB_PAT}",
         "cos_auth_type": "KUBERNETES_SECRET",
         "cos_endpoint": "http://minio.<TEAM_NAME>-ci-cd.svc.cluster.local:9000",
         "cos_bucket": "airflow-daintree-dev",
         "cos_secret": "s3-auth",
         "cos_username": "${AWS_ACCESS_KEY_ID}",
         "cos_password": "${AWS_SECRET_ACCESS_KEY}",
         "runtime_type": "APACHE_AIRFLOW"
      },
      "schema_name": "airflow"
   }
   EOF
   ```

   Once added, Select the **Runtimes** navigation on the left side panel to view the added runtime.
   
   ![jhub-runtime](./images/1-jhub-runtime.png)

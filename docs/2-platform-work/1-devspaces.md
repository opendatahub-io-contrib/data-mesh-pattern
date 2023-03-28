## 🌲 DevSpaces
## DevSpaces Workspace setup

We will use the DevSpaces web IDE as our code editor and toolbench for setting up the AIMLOPS Platform.

1. Login to your DevSpaces Editor as your data science user **USER_NAME** e.g. **user1** - be sure to select the **FreeIPA** identity provider when logging in.

   ![devspaces-link](./images/devspaces-link.png)

   The first time round, you will be taken through the OAuth workflow, click the **Allow selected permissions** button.

   ![devspaces-oauth](./images/devspaces-oauth.png)

2. We are using a private github repository for the **opendatahub-io-contrib/data-mesh-pattern** code at the moment. DevSpaces supports this, let's create a credential secret to be able to access the repo. The **GITHUB_TOKEN** will be provided by your instructor.

   ```bash
   export GITHUB_TOKEN=<token>
   ```

   ```bash
   oc -n ${USER_NAME}-devspaces apply -f - <<EOF
   kind: Secret
   apiVersion: v1
   metadata:
     name: devspaces-git-creds
     annotations:
       controller.devfile.io/mount-path: /tmp/.git-credentials/
     labels:
       controller.devfile.io/git-credential: "true"
       controller.devfile.io/watch-secret: "true"
       controller.devfile.io/mount-to-devworkspace: "true"
   stringData:
     credentials: https://foo:${GITHUB_TOKEN}@github.com
   EOF
   ```

3. Create your workspace. On DevSpaces Workspaces, **Create Workspace > Import from Git**

   <p class="warn">
   For OpenShift 4.11+ - Enter this URL to load the dev stack:</br>
   <span style="color:blue;"><a id=crw_dev_filelocation_4.11 href=""></a></span>
   </p>

   Select **Create & Open**

   ![devspaces-create](./images/devspaces-create.png)

   This will open a new tab, download the devspaces stack image, clone the Rainforest codebase and start your IDE.

   ![devspaces-create](./images/devspaces-start.png)

   You will be prompted to **Trust the Authors** for the git project, tick the checkbox and click the button.

   ![devspaces-git-trust](./images/devspaces-git-trust.png)

4. Login to Terminal in DevSpaces by selecting the hamburger menu in top left - **Terminal > New Terminal**.

   ![devspaces-terminal](./images/devspaces-terminal.png)

6. Export our environment variables and launch **zsh** shell. You can **paste** using **CTRL+SHIFT+V** in the terminal, accept any first time cut-n-paste browser/prompts.
 
   ```bash
   echo export TEAM_NAME="<TEAM_NAME>" | tee -a ~/.bashrc -a ~/.zshrc 
   echo export CLUSTER_DOMAIN="<CLUSTER_DOMAIN>" | tee -a ~/.bashrc -a ~/.zshrc
   echo export GIT_SERVER="<GIT_SERVER>" | tee -a ~/.bashrc -a ~/.zshrc
   ```
   
   ```bash
   zsh
   ```

   ![devspaces-zsh](./images/devspaces-zsh.png)

7. Check if you can connect to OpenShift. Run the command below.

   ```bash
   export USER_NAME=<USER NAME>
   export USER_PASSWORD=<USER PASSWORD>
   ```

   ```bash
   oc login --server=https://api.${CLUSTER_DOMAIN##apps.}:6443 -u ${USER_NAME} -p ${USER_PASSWORD}
   ```

🪄🪄 Now, let's carry on and configure our GitOps tooling ... !🪄🪄

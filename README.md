# Azure Keycloak Deployment with OAuth2-Proxy and NGINX
This project provisions a virtual machine (VM) in Azure and deploys a minimal container environment with:

- **[Keycloak](https://www.keycloak.org/)** used for managing access to the web page
- **[PostgreSQL](https://www.postgresql.org/)** as the Keycloak backing database
- **[OAuth2-Proxy](https://oauth2-proxy.github.io/oauth2-proxy/)** for secure authentication middleware
- **[NGINX](https://nginx.org/)** serving a static web page protected via Keycloak authentication
- **[Redis](https://redis.io/docs/latest/)** in-memory data store used in this project as a session backend for OAuth2 Proxy, ensuring fast and reliable session management

All infrastructure is managed via **Terraform**, configured with **Ansible**, and automated with **GitHub Actions**.

## Infrastructure Overview
Terraform creates all infrastructure in the terraform/ directory:

- Azure Resource Group
- Virtual Network and Subnet
- Network Interface and Public IP
- Virtual Machine (Ubuntu)

## Configuration Overview
All Azure VM setup and application configuration is handled by Ansible:

- Installation of Docker and Docker Compose 
- Docker Compose deployment of:
  - Postgres
  - Keycloak
  - OAuth2-Proxy
  - NGINX
  - Redis

Playbooks:

- `start-playbook.yaml`: Sets up and starts containers
- `stop-playbook.yaml`: Stops and removes containers

##  GitHub Actions Workflows
✅ `deploy.yaml`
- Provisions infrastructure (Terraform)
- Runs Ansible playbook to configure the VM

❌ `destroy.yaml`
- Destroys infrastructure (Terraform)

🔁 `configure.yaml`
- Stops and starts containers to apply updates

All workflows are stored in `.github/workflows/`.<br>
Secrets are defined securely using **GitHub Secrets**.

## Using GitHub Actions
### Step 1 - Fork the repository
Click the "Fork" button at the top of the repository page to create a copy under your GitHub account.

### Step 2 - Set up GitHub Secrets
Go to your forked repository → `Settings` → `Secrets and variables` → `Actions` → `New repository secret`, and add the following secrets:<br>

🧩 **Terraform-related secrets:**
| Name | Description |
| --- | --- |
| `AZURE_CLIENT_ID` |  Azure service principal client ID |
| `AZURE_CLIENT_SECRET` | Azure service principal client secret |
| `AZURE_SUBSCRIPTION_ID` | Azure subscription ID |
| `AZURE_TENANT_ID` | Azure tenant ID |

> [!NOTE]
> Terraform supports a number of different methods for authenticating to Azure. In this project, [Authenticating using a Service Principal with a Client Secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret) is used. 

🧩 **Ansible-related secrets:**
| Name | Description |
| --- | --- |
| `KC_DB_USERNAME` | Keycloak DB username |
| `KC_DB_PASSWORD` | Keycloak DB password |
| `KEYCLOAK_ADMIN_USER` | Keycloak user in master realm |
| `KEYCLOAK_ADMIN_PASS` | Keycloak user password in master realm |
| `POSTGRES_USER` | PostgreSQL user |
| `POSTGRES_PASSWORD` | PostgreSQL user password |
| `SSH_PRIVATE_KEY` | SSH private key used by Ansible |
| `SSH_PUBLIC_KEY` | 	SSH public key to access the VM |
| `VM_ADMIN_USERNAME` | Admin username for the VM |

### Step 3 - Creating the Terraform backend bucket
These resources need to be created if they already don't exist:
- Resource group
- Storage account
- Storage container
  
They need to be used in the `providers.tf` file in the `backend` block to allow saving the .tfstate file in a storage bucket. 

> [!IMPORTANT]
> Variables can't be used to configure Terraform backends, for more info see [this issue](https://github.com/hashicorp/terraform/issues/13022).<br>
> In this project, Storage account `keycloakdemotfstate` and Storage container `tf-state` have been created. Please update it accordingly to your resource names. 

### Step 4 - Run GitHub Workflows
Trigger the following workflows from the "Actions" tab:
- `deploy.yaml` – creates the infrastructure with Terraform and containers within with Ansible
- `configure.yaml` – applies any new changes by re-running the Ansible stop and start playbooks
- `destroy.yaml` – destroys all resources.

### Step 5 - Adding Audience mapper
When the `deploy.yaml` GitHub Workflow is done, to configure the OAuth2-Proxy, we need to create an Audience mapper type for the nginx-client.<br>
In the Keycloak console (http://<PUBLIC_IP>:8080), go to Clients → nginx-client → Client scopes → nginx-client-dedicated. Configure a new mapper Audience, set up a name, add nginx-client as Included Custom Audience and save the mapper.

### Step 6 - Verify Deployment
Once the infrastructure is deployed and containers are running, use the following URLs to verify everything is working correctly:
- Keycloak Admin Console
  - http://<PUBLIC_IP>:8080
  - _Login with the KEYCLOAK_ADMIN_USER and KEYCLOAK_ADMIN_PASS secrets._

- Static Web Page (Protected by OAuth2 Proxy)
  - http://<PUBLIC_IP>
  - _If you're redirected to Keycloak, the setup is working._

### Architecture review
![Architecture review](https://github.com/user-attachments/assets/ff013947-4fd5-4c64-8f82-6aaa23a05807)

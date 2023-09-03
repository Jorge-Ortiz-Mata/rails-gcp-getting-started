# Ruby on Rails - Getting Started.

This is a template you can use to develop a Ruby on Rails application and use the Google Cloud Platform services to host it.

Make sure to follow these steps to have a Rails application ready to use.

## Getting Started.

In order to use this web application, follow the next steps:

1. Clone the repository.
2. Make sure to have the ruby version installed 3.0.4 and the Rails version installed 7.0.7.2
3. Create the .env file and add your API Keys.
4. Run the rails server
5. Enjoy!

## Environment File.

This Ruby on Rails application uses environment variables to stablish a connection with a database and run the tests successfully.

**Development environment**

- POSTGRES_USERNAME_DEV=''
- POSTGRES_PASSWORD_DEV=''
- POSTGRES_DATABASE_URI_DEV=''

**Testing environment**

- POSTGRES_USERNAME_TEST=''
- POSTGRES_PASSWORD_TEST=''
- POSTGRES_DATABASE_URI_TEST=''

## GitHub Actions.

This template creates two environments on GCP: staging and production; and each environment is created depending on the action.

The staging environment is created on each merge to the main branch, and the production environment is created on release.

Follow the next configuration to release your application:

1. Create a new repository.

2. Add your API Keys on the repo configuration. You can use the same names declared in the workflow file or chose another ones (you have to rename the variables in the workflow flie).

- POSTGRES_USERNAME_TEST
- POSTGRES_PASSWORD_TEST
- POSTGRES_DATABASE_URI_TEST

3. Add an initial commit and push your code to GitHub.

4. Wait until the actions finsihed.

## Google Cloud Platform.

The previous section talks about of how to run your application under the GitHub services without GCP.

Make sure to have the gcloud installed on your local machine and you will need to add a payment method to use the Google Cloud Services.

Follow the next configuration to create your environments on GCP.

1. Create a new project on Google Cloud Platform.

2. Add a payment method

3. Enable the Artifact Registry service.

4. Enable the Secret Manager service.

5. Create a new role (Container Deployer) to use the Cloud Run services:

- iam.serviceAccounts.actAs
- run.services.create
- run.services.delete
- run.services.get
- run.services.getIamPolicy
- run.services.setIamPolicy
- run.services.update

6. Create a new role (Docker image publisher) to store the Docker image on the Artifact Registry service:

- artifactregistry.repositories.downloadArtifacts
- artifactregistry.repositories.uploadArtifacts

7. Create a new role (Secret accessor) to get access to the Secret Manager service:

- secretmanager.versions.access

8. Create a service account and assing the three roles we created in the previous steps.

- Name: gh-actions-runner

9. In the IAM section, we need to add permissions to our service account created. We select the service account and we add the three roles created before.

10. Go to Workload Identity Pools and create a new workload identity pool

- Name: ruby-on-rails-gcp-pool
- Provider: OpenID Connect (OIDC)
- Provider name: GitHub
- Issuer (URL): https://token.actions.githubusercontent.com
- Configure attributes:
```
  google.subject - assertion.sub
  attribute.repository - assertion.repository
  attribute.actor - assertion.actor
  attribute.aud - assertion.aud
  attribute.repository_owner - assertion.repository_owner
```

11. Login with gcloud from the terminal: `gcloud auth login`.

12. Select the project: `gcloud config set project x-alcove-397919`

13. Copy this command in your terminal and change the configuration with your workload pool created and the service account

```
gcloud iam service-accounts add-iam-policy-binding "my-service-account@${PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/1234567890/locations/global/workloadIdentityPools/my-pool/attribute.repository/my-org/my-repo"
```

- Example:

```bash
gcloud iam service-accounts add-iam-policy-binding "gh-actions-runner@x-alcove-397919.iam.gserviceaccount.com" \
  --project="x-alcove-397919" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/31953380355/locations/global/workloadIdentityPools/ruby-on-rails-gcp-pool/attribute.repository/Jorge-Ortiz-Mata/rails-gcp-getting-started"
```


## GH Actions with Google Cloud Platform

In order to use GH Actions to upload the project to the Google Cloud Platform services, follow the next configuration:

1. Update the project name on each part of the root (Dockerfile, entrypoint).

2. Update the staging workfload with all the project information (ID, service account, workload_identity_pool)

3. Update the folder name for the Artifact Registry

4. Update the Cloud Run step with the information of your project

5. Create the secrets keys in the Secret Manager service.

  - Rails Master Key.
  - Database connections (Staging)

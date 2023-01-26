PROJECT_ID=<your_input> # e.g., "psyops-proj"
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
echo "project_id = \"${PROJECT_ID}\""
echo "project_number = \"${PROJECT_NUMBER}\""

echo "Setting current project to ${PROJECT_ID}"
gcloud config set project ${PROJECT_ID}
echo "Creating bucket for terraform state"
gsutil mb <your_input> # e.g., gs://psyops-tfstate
echo "Enabling versioning on bucket"
gsutil versioning set on <your_input> # e.g., gs://psyops-tfstate

echo "Enabling iam policy binding for cloud build service account to composer environment admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
 --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
 --role=roles/composer.admin

echo "Enabling iam policy binding for cloud build service account to service account actor"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
 --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
 --role=roles/iam.serviceAccountActor

echo "Enableing iam policy binding for cloud build service account to storage admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
 --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
 --role=roles/storage.admin

echo "Enabling iam policy binding for cloud build service account to create service account"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
 --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
 --role=roles/iam.serviceAccountAdmin

echo "Enabling iam policy binding for cloud build service account to create project Iam Admin"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
 --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
 --role=roles/iam.projectIamAdmin

echo "Enabling iam policy binding for cloud build service account to access gke cluster"
gcloud projects add-iam-policy-binding ${PROJECT_ID} \
 --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
 --role=roles/container.admin
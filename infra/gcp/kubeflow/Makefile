
enable-apis:
	gcloud services enable \
  serviceusage.googleapis.com \
  compute.googleapis.com \
  container.googleapis.com \
  iam.googleapis.com \
  servicemanagement.googleapis.com \
  cloudresourcemanager.googleapis.com \
  ml.googleapis.com \
  iap.googleapis.com \
  sqladmin.googleapis.com \
  meshconfig.googleapis.com \
  krmapihosting.googleapis.com \
  servicecontrol.googleapis.com \
  endpoints.googleapis.com \
  cloudbuild.googleapis.com

init-gconfig-management:
	gcloud config set project ${MGMT_PROJECT}

install-tools-management:
	gcloud components install kubectl kustomize kpt anthoscli beta
	gcloud components update
	# If the output said the Cloud SDK component manager is disabled for installation, copy the command from output and run it.
	#sudo apt-get install kubectl google-cloud-sdk-kpt google-cloud-sdk google-cloud-sd
	#sudo apt-get update && sudo apt-get --only-upgrade install google-cloud-sdk-app-engine-python-extras google-cloud-sdk-pubsub-emulator google-cloud-sdk-app-engine-grpc google-cloud-sdk-spanner-emulator google-cloud-sdk-harbourbridge google-cloud-sdk-local-extract google-cloud-sdk-package-go-module google-cloud-sdk-skaffold google-cloud-sdk-gke-gcloud-auth-plugin google-cloud-sdk-app-engine-go google-cloud-sdk-anthos-auth google-cloud-sdk-app-engine-python google-cloud-sdk-cloud-run-proxy google-cloud-sdk-app-engine-java google-cloud-sdk-terraform-tools google-cloud-sdk-kubectl-oidc google-cloud-sdk google-cloud-sdk-cbt google-cloud-sdk-minikube google-cloud-sdk-nomos google-cloud-sdk-cloud-build-local google-cloud-sdk-firestore-emulator google-cloud-sdk-log-streaming google-cloud-sdk-datastore-emulator kubectl google-cloud-sdk-kpt google-cloud-sdk-config-connector google-cloud-sdk-bigtable-emulator

checkout-kubeflow-distirbution-git:
	# Check out Kubeflow v1.6.1
	git clone https://github.com/googlecloudplatform/kubeflow-distribution.git; \
	cd kubeflow-distribution; \
	git checkout tags/v1.6.1 -b v1.6.1

checkout-kubeflow-distirbution-kpt: # 현재 작동 안함.
	# Check out Kubeflow v1.6.1 blueprints
	kpt pkg get https://github.com/googlecloudplatform/kubeflow-distribution.git@v1.6.0 kubeflow-distribution

set-kpt-setter-values-management:
	cd kubeflow-distribution/management; \
	bash kpt-set.sh

check-kpt-setter-values-management:
	cd kubeflow-distribution/management; \
	kpt fn eval -i list-setters:v0.1 ./manifests

create-cluster-management:
	cd kubeflow-distribution/management; \
	make create-cluster

create-context-management:
	cd kubeflow-distribution/management; \
	make create-context

grant-owner-permission-management:
	cd kubeflow-distribution/management; \
	make grant-owner-permission

delete-managed-ns-management:
	kubectl config use-context "${MGMTCTXT}"
	kubectl delete namespace --wait "${KF_PROJECT}"

#revoke IAM permission that let the management cluster manage the project
revoke-iam-permission-management:
	gcloud projects remove-iam-policy-binding "${KF_PROJECT}" \
    "--member=serviceAccount:${MGMT_NAME}-cnrm-system@${MGMT_PROJECT}.iam.gserviceaccount.com" \
    --role=roles/owner

delete-cluster-management:
	cd kubeflow-distribution/management; \
	make delete-cluster

######### kubeflow cluster #########

init-gconfig-kubeflow:
	gcloud config set project ${KF_PROJECT}
	gcloud config set compute/zone ${KF_ZONE}

install-tools-kubeflow:
	gcloud components install kubectl kustomize kpt anthoscli beta
	gcloud components update
	# If the output said the Cloud SDK component manager is disabled for installation, copy the command from output and run it.
	
pull-upstream-manifests-kubeflow:
	cd kubeflow-distribution/kubeflow; \
	bash ./pull-upstream.sh

set-kpt-setter-config-kubeflow:
	cd kubeflow-distribution/kubeflow; \
	bash ./kpt-set.sh

check-kpt-setter-values-kubeflow-apps:
	cd kubeflow-distribution/kubeflow; \
	kpt fn eval -i list-setters:v0.1 ./apps

check-kpt-setter-values-kubeflow-common:
	cd kubeflow-distribution/kubeflow; \
	kpt fn eval -i list-setters:v0.1 ./common

apply-config-connector-context-kubeflow:
	cd kubeflow-distribution/kubeflow; \
	make apply-kcc

deploy-kubeflow:
	cd kubeflow-distribution/kubeflow; \
	make apply

get-credentials-kubeflow:
	gcloud container clusters get-credentials "${KF_NAME}" --zone "${ZONE}" --project "${KF_PROJECT}"

check-deployment-kubeflow: get-credentials-kubeflow
	kubectl -n kubeflow get all

delete-ns-kubeflow:
	kubectl delete namespace kubeflow

delete-cluster-kubeflow:
	cd kubeflow-distribution/kubeflow; \
	make delete

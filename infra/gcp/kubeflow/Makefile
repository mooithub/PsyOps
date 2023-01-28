
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
	gcloud config set compute/zone ${MGMT_ZONE}

install-tools-management:
	gcloud components install kubectl kustomize kpt anthoscli beta
	gcloud components update
	# If the output said the Cloud SDK component manager is disabled for installation, copy the command from output and run it.
	
checkout-kubeflow-distirbution:
	# Check out Kubeflow v1.6.1
	git clone https://github.com/googlecloudplatform/kubeflow-distribution.git; \
	cd kubeflow-distribution; \
	git checkout tags/v1.6.1 -b v1.6.1

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
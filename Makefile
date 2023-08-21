export BUILD_IMG_LOG_DIR="gs://warehouse/cloudbuild_log/composer"
export SNAPSHOT_PATH="gs://warehouse/composer/snapshot"
export COMPOSER_NAME="psyops-composer"

set_env:
	@echo "BUILD_IMG_LOG_DIR = $$BUILD_IMG_LOG_DIR"
	@echo "SNAPSHOT_PATH = $$SNAPSHOT_PATH"
	@echo "COMPOSER_NAME = $$COMPOSER_NAME"

composer_create:
	gcloud builds submit --gcs-source-staging-dir=$$BUILD_IMG_LOG_DIR --config=infra/gcp/cloud_composer/cloudbuild-create.yaml --async --substitutions=_SNAPSHOT_PATH_=$$SNAPSHOT_PATH,_COMPOSER_NAME_=$$COMPOSER_NAME

composer_destroy:
	gcloud builds submit --gcs-source-staging-dir=$$BUILD_IMG_LOG_DIR --config=infra/gcp/cloud_composer/cloudbuild-destroy.yaml --async --substitutions=_SNAPSHOT_PATH_=$$SNAPSHOT_PATH,_COMPOSER_NAME_=$$COMPOSER_NAME
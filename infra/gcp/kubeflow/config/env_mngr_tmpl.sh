# env_common.sh 가 먼저 실행되었다는 전제하에.
# 그리고 managment cluster가 먼저 생성되고, 이후 kf cluster가 생성되므로 이 스크립트의 환경변수들이 먼저 반영되어야 함. 

export MGMT_PROJECT=${KUBEFLOW_PROJECT_ID_STEM}${MGMT_PROJECT_TAG}
export MGMT_ZONE=${KUBEFLOW_ZONE}
export MGMT_NAME=${KUBEFLOW_NAME}${MGMT_PROJECT_TAG}
export MGMTCTXT="${MGMT_NAME}"
export LOCATION=#e.g., "us-central1" # 나중에 env_kf.sh가 실행되는 환경이 같으면, 이 환경변수는 kf용으로 오버라이팅됨.
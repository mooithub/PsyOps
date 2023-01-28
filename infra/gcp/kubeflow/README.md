
# Setting up GCP Project
* https://googlecloudplatform.github.io/kubeflow-gke-docs/docs/deploy/project-setup/

## Setting up a project & Setting up OAuth client

------------
# 0. 최초 셋팅

0. 클라이언트 아이디와 인증 얻기 (이건 kubeflow cluster 프로젝트에서 하면 됨. 한번 만)
```shell
export CLIENT_ID
export CLIENT_SECRET
```
위의 환경변수 값들은 다음의 단계를 거쳐서 수동으로 만들어서 구성해놔야 한다.
* 다음의 [공식문서](https://www.kubeflow.org/docs/gke/deploy/oauth-setup/)
* 그 결과 값은 현재 여기서 확인 가능
    * OAuth 2.0 클라이언트 ID - 
    * OAuth 동의화면 - 

1.먼저 관련 변수들을 최초 한번, 다음과 같이 export 함
```shell
$ # CUR_DIR
$ source ./config/env.sh
```

2.gcloud 관련 변수 초기 셋팅 및 권한 활성화

2-1) Management Cluster

* 프로젝트 정보 셋팅 및 권한, API 활성화
```shell
```shell
$ gcloud config set project ${MGMT_PROJECT}
$ gcloud auth login
$ make enable-apis
```

* Initialize your management project to prepare it for Anthos Service Mesh installation
```shell
$ curl --request POST \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --data '' \
  https://meshconfig.googleapis.com/v1alpha1/projects/${MGMT_PROJECT}:initialize
```

* If you encounter a Workload Identity Pool does not exist error, refer to the following issue:
    - [kubeflow/website #2121](https://github.com/kubeflow/website/issues/2121) describes that creating and then removing a temporary Kubernetes cluster may be needed for projects that haven’t had a cluster set up beforehand.
```shell
$ # If you encounter a Workload Identity Pool does not exist error
$ gcloud beta container clusters create tmp-cluster \
  --release-channel regular \
  --workload-pool=${MGMT_PROJECT}.svc.id.goog \
  --zone=${MGMT_ZONE}
$ curl --request POST \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --data '' \
  https://meshconfig.googleapis.com/v1alpha1/projects/${MGMT_PROJECT}:initialize
$ gcloud beta container clusters delete tmp-cluster --zone=${MGMT_ZONE}
```

2-2) Kubeflow Clusters 
* 2-1과 비슷하게 시행
```shell
$ gcloud config set project ${KF_PROJECT}
$ gcloud auth login
$ make enable-apis
```

* Initialize your management project to prepare it for Anthos Service Mesh installation
```shell
$ curl --request POST \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --data '' \
  https://meshconfig.googleapis.com/v1alpha1/projects/${KF_PROJECT}:initialize
```

* If you encounter a Workload Identity Pool does not exist error, refer to the following issue:
    - [kubeflow/website #2121](https://github.com/kubeflow/website/issues/2121) describes that creating and then removing a temporary Kubernetes cluster may be needed for projects that haven’t had a cluster set up beforehand.
```shell
$ # If you encounter a Workload Identity Pool does not exist error
$ gcloud beta container clusters create tmp-cluster \
  --release-channel regular \
  --workload-pool=${KF_PROJECT}.svc.id.goog \
  --zone=${KF_ZONE}
$ curl --request POST \
  --header "Authorization: Bearer $(gcloud auth print-access-token)" \
  --data '' \
  https://meshconfig.googleapis.com/v1alpha1/projects/${KF_PROJECT}:initialize
$ gcloud beta container clusters delete tmp-cluster --zone=${KF_ZONE}
```
-------------- 

# 1. Deploying Management cluster

1. gcloud 관련 변수 초기 셋팅
```shell
$ make init-gconfig-management
```

2. 매니저 설치 관련 도구들 설치
```shell
$ make install-tools-management
```

3. checkout source code
```shell
$ make checkout-kubeflow-distirbution
```

4. Configure kpt setter values 
```shell
$ make set-kpt-setter-values-management
$ # check
$ make check-kpt-setter-values-management
```

5. Deploy Management Cluster
```shell
$ make create-cluster-management
$ make create-context-management
$ make grant-owner-permission-management
```

# 2. Deploying Kubeflow cluster

* kubeflow management cluster가 설치되었다는 가정하에.(위의 1번 섹션 참조)
* ASM 설치는 리눅스나 클라우드 쉘에서만 가능함. 맥/윈도우 사용자의 경우 kubeflow cluster가 셋팅 될 GCP 프로젝트에서 진행할 것.
    - 이 경우 만약 mangement cluster 설치를 다른 곳에서 했다면 config/env.sh 파일을 처음에 다시 활성화해서 환경 변수들을 셋팅해줘야 함.
    - 그냥 처음부터 kubeflow cluster 설치될 GCP 프로젝트에서 1과 2 섹션을 같이 진행하는게 속편함.

1. kubeflow cluster gcloud 관련 변수 초기 셋팅
```shell
$ cd CUR_DIR
$ make init-gconfig-kubeflow
```

2. kubeflow 설치 관련 도구들 설치
```shell
$ make install-tools-kubeflow
```

3. install required tools for ASM 
```shell
$ make install-asm-kubeflow
```

4. pull upstream manifests
```shell
$ make pull-upstream-manifests-kubeflow
```

5. kpt setter config 
```shell
$ make set-kpt-setter-config-kubeflow
$ # check
$ make check-kpt-setter-values-kubeflow-apps
$ make check-kpt-setter-values-kubeflow-common
```

6. Authorize Cloud Config Connector for each Kubeflow project
```shell
$ # Apply ConfigConnectorContext for ${KF_PROJECT} in management cluster:
$ make apply-config-connector-context-kubeflow
```

8. Deploy Kubeflow
```shell    
$ make deploy-kubeflow
```



# 1. Deploying Management cluster

1.gcloud 관련 변수 초기 셋팅 및 권한 활성화

* 공통 변수들을 다음과 같이 export 함
```shell
$ # CUR_DIR
$ source ./config/env_common.sh
```

* 관련 변수들을 다음과 같이 export 함
```shell
$ # CUR_DIR
$ source ./config/env_mngr.sh
```

* 프로젝트 정보 셋팅 및 권한, API 활성화
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


2. 매니저 설치 관련 도구들 설치
```shell
$ make install-tools-management
```

3. checkout source code
```shell
$ make checkout-kubeflow-distirbution-git
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

------------------

# 2. Deploying Kubeflow cluster

* ASM 설치는 리눅스나 클라우드 쉘에서만 가능함. 맥/윈도우 사용자의 경우 kubeflow cluster가 셋팅 될 GCP 프로젝트에서 진행할 것.
    - 그냥 처음부터 kubeflow cluster 설치될 GCP 프로젝트에서 1과 2 섹션을 같이 진행하는게 속편함.

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


1.gcloud 관련 변수 초기 셋팅 및 권한 활성화

* 공통 변수들을 다음과 같이 export 함
```shell
$ # CUR_DIR
$ source ./config/env_common.sh
```

* 관련 변수들을 다음과 같이 export 함
```shell
$ # CUR_DIR
$ source ./config/env_kf.sh
```

* 프로젝트 정보 셋팅 및 권한, API 활성화
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


2. (Option) kubeflow 설치 관련 도구들 설치
* mangement cluster와 kubeflow cluster 설치를 위한 리눅스 혹은 클라우드 쉘 환경이 다를 경우.
```shell
$ make install-tools-kubeflow
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

7. Deploy Kubeflow
* 6번의 결과로 kcc-<kf-project-name>@<management-project-name>.iam.gserviceaccount.com 서비스 계정이 
* managment cluster GCP project의 service accounts로 생성됨.
* 이 서비스 계정을 kubeflow clouster GCP project의 IAM에 owner로 등록해야 함.
    - 참고 : For each Kubeflow Google Cloud project, you will have service account with pattern kcc-<kf-project-name>@<management-project-name>.iam.gserviceaccount.com in config-control namespace, and it needs to have owner permission to ${KF_PROJECT}, you will perform this step during Deploy Kubeflow cluster.
```shell    
$ make deploy-kubeflow
```

8. Check your deployment
```shell    
$ make check-deployment-kubeflow
```

9. kubeflow UI

* 9-1) Use the following command to grant yourself the IAP-secured Web App User role: 
```shell
$ gcloud projects add-iam-policy-binding "${KF_PROJECT}" --member=user:<EMAIL> --role=roles/iap.httpsResourceAccessor
```

* 9-2) Enter the following URI into your browser address bar. 
    - It can take 20 minutes for the URI to become available: https://${KF_NAME}.endpoints.${KF_PROJECT}.cloud.goog/
* You can run the following command to get the URI for your deployment:
```shell
$ kubectl -n istio-system get ingress
```    

------------------
# 3. Deleting Kubeflow

```shell    
$ make delete-ns-kubeflow
``` 

```shell    
$ make delete-cluster-kubeflow
```

```shell    
$ make delete-managed-ns-management
```

```shell    
$ make revoke-iam-permission-management
```

```shell    
$ make delete-cluster-management
``` 
    
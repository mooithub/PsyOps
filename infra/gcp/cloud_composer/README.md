# Airflow on GCP Composer
GCP의 관리형 Airflow인 Cloud Composer 관련 인프라를 구성.

# google cloud builds 관련 정보
매일 x시에 cloud composer를 생성하고, y시에 cloud composer를 삭제.
* cloud composer 생성
  1. Cloud Scheduler : create-composer
    - 매일 x시에 create-composer topic을 publish
  2. Google Cloud PUB/SUB : create-composer Topic
    - 이 토픽의 subscription으로 cloud build trigger : create-composer가 구독.
  3. Google Cloud Build : create-composer trigger
    - create-composer topic을 구독하고, cloudbuild.yaml을 실행
* cloud composer 삭제
  1. Cloud Scheduler : destroy-composer
    - 매일 y시에 destroy-composer topic을 publish
  2. Google Cloud PUB/SUB : destroy-composer Topic
    - 이 토픽의 subscription으로 cloud build trigger : destroy-composer가 구독
  3. Google Cloud Build : destroy-composer trigger
    - destroy-composer topic을 구독하고, cloudbuild-destroy.yaml을 실행
  

# local 환경에서의 테스트
0. Makefile 에서 환경변수 적절히 업데이트, sync_dags 스크립트 파일에 DAG gcs path 설정


1. 최초 실행시 
```bash
$ sh bootstrap.sh
```

2. gcloud build와 terraform을 이용한 cloud composer 생성
```bash
$ gcloud builds submit --region=<your region : eg. us-central1> --config cloudbuild.yaml
# 혹은
$ make composer_create
```

3. gcloud build와 terraform을 이용한 cloud composer 삭제
```bash
$ gcloud builds submit --region=<your region : eg. us-central1> --config cloudbuild-destroy.yaml
# 혹은
$ make composer_destroy
```
# Define the Google Cloud Composer environment
resource "google_composer_environment" "psyops_composer_environment" {
  project = var.project_id
  name = var.namespace
  region = var.region

  config {
    software_config {
      image_version = "composer-2.1.5-airflow-2.2.5" # composer2 버전 사용으로 컴퓨터자원 효율화
      # airflow 디폴트 설정 추가
      airflow_config_overrides = {
        core-dags_are_paused_at_creation = "True"  # dag 이 최초 추가될 때 paused 상태로 둘 것인지 여부
        scheduler-catchup_by_default = "False"  # catchup 을 디폴트로 False 로 설정
      }
      # 미리 설치해야할 패키지가 있는 경우 정의
      # pypi_packages = {
      #   pymysql = ""
      #   boto3 = ">=1.9.86"
      # }
    }

    # 리소스 정의
    workloads_config {
      scheduler {
        cpu = 2
        memory_gb = 7.5
        storage_gb = 5
        count = 2
      }
      web_server {
        cpu = 2
        memory_gb = 7.5
        storage_gb = 5
      }
      worker {
        cpu = 2
        memory_gb = 7.5
        storage_gb = 5
        min_count = 1
        max_count = 8  # 작업자 최대 수 지정
      }
    }
    # 환경 크기 small 기준 총 dag 수 50개 이하, 최대 동시 실행 dag 15개 이하인 경우 적합
    environment_size = "ENVIRONMENT_SIZE_SMALL"
  }
}


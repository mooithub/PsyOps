import os, json

root_dir = "/workspace"

SRC_DAGS_PATH_ARR = [
    #os.path.join(root_dir, <your_dags_dir_path>),"),
    # 실제 DAG 을 두는 gcs path 설정
    # "gs://warehouse/composer/dagfiles"
]

def cp_dags(src_dags_path, dag_gcs_prefix):
#     cmd = "gsutil -m cp -r {} {}".format(src_dags_path, dag_gcs_prefix)
    cmd = "gsutil -m rsync -d -r {} {}".format(src_dags_path, dag_gcs_prefix)
    print(cmd)
    os.system(cmd)

def run(src_parsing_results_fn):
    with open(src_parsing_results_fn) as f:
        parsing_results = json.load(f)
    
    dag_gcs_prefix = parsing_results["dag_gcs_prefix"]
    print(dag_gcs_prefix)
    for src_dags_path in SRC_DAGS_PATH_ARR:
        cp_dags(src_dags_path, dag_gcs_prefix)
import json

def parse_output(output):
    parsing_results = {}
    for key, val in output.items():
        if key == "gke_cluster":
            cluster_str = val["value"]
            print(cluster_str)
            # 맨 끝에
            cluster_name = cluster_str.split("/")[-1]
            parsing_results["gke_cluster_name"] = cluster_name
            # 끝에서 세 번째에
            cluster_zone = cluster_str.split("/")[-3]
            parsing_results["gke_cluster_zone"] = cluster_zone
        elif key == "dag_gcs_prefix":
            dag_gcs_prefix = val["value"]
            parsing_results["dag_gcs_prefix"] = dag_gcs_prefix
            gcs_root_uri = dag_gcs_prefix.split("/dags")[0]
            parsing_results["gcs_root_uri"] = gcs_root_uri
        else:
            parsing_results[key] = val["value"]

    return parsing_results

    
def run(src_filename, dst_filename):
    with open(src_filename) as f:
        output = json.load(f)
    print(output)
    parsing_results = parse_output(output)
    print(parsing_results)
    # dst_filename으로 json 파일로 저장
    with open(dst_filename, "w") as f:
        json.dump(parsing_results, f, indent=4)
import os, json

def rm_gcs_bucket(gcs_root_uri):
    cmd = "gsutil rm -r {}".format(gcs_root_uri)
    print(cmd)
    os.system(cmd)

def run(src_parsing_results_fn):
    with open(src_parsing_results_fn) as f:
        parsing_results = json.load(f)
    
    gcs_root_uri = parsing_results["gcs_root_uri"]
    print(gcs_root_uri)
    rm_gcs_bucket(gcs_root_uri)
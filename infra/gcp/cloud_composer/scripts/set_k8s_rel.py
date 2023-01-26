import os, json
import subprocess

def connect_gke_cluster(gke_cluser_name, gke_zone, project_id):
    cmd = "gcloud container clusters get-credentials {} --zone {} --project {}".format(gke_cluser_name, gke_zone, project_id)
    print(cmd)
    os.system(cmd)     

def get_composer_default_accnt_name():
    output = subprocess.run(['kubectl', 'get', 'ns'], stdout=subprocess.PIPE).stdout.decode('utf-8')
    output = output.strip()
    
    words = output.split()
    composer_words = [word for word in words if word.startswith('composer')]
    print(composer_words)

    svc_accnt_name = composer_words[0]

    return svc_accnt_name

def create_clusterrolebinding(svc_accnt_name):
    cmd = "kubectl create clusterrolebinding default-admin --clusterrole cluster-admin --serviceaccount={}:default --namespace default".format(svc_accnt_name)
    print(cmd)
    os.system(cmd)

def run(src_parsing_results_fn):
    with open(src_parsing_results_fn) as f:
        parsing_results = json.load(f)
    
    gke_cluser_name = parsing_results["gke_cluster_name"]
    gke_zone = parsing_results["gke_cluster_zone"]
    project_id = parsing_results["project"]

    connect_gke_cluster(gke_cluser_name, gke_zone, project_id)
    svc_accnt_name = get_composer_default_accnt_name()
    create_clusterrolebinding(svc_accnt_name)
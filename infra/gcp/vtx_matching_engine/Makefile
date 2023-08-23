init:
	terraform init

plan_static:
	terraform plan -out=apply_static_plan.out -target=module.static_resources

apply_static:
	terraform apply apply_static_plan.out

plan_apply_dynamic:
	terraform plan -out=apply_dynamic_plan.out -target=module.dynamic_resources

apply_dynamic:
	terraform apply apply_dynamic_plan.out

plan_destroy_dynamic:
	terraform plan -destroy -out=destroy_dynamic_plan.out -target=module.dynamic_resources

destroy_dynamic:
	terraform apply destroy_dynamic_plan.out
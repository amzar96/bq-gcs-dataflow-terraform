setup:
	uv sync

tf-init:
	cd terraform && terraform init

tf-plan:
	cd terraform && terraform plan

tf-apply:
	cd terraform && terraform apply

tf-destroy:
	cd terraform && terraform destroy

py-run: setup
	uv run dataflow_etl.py

clean:
	rm -rf .venv
	cd terraform && rm -rf .terraform .terraform.lock.hcl terraform.tfstate*
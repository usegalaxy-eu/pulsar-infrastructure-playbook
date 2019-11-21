REMOTE_JMC_FILE=https://github.com/usegalaxy-eu/infrastructure-playbook/blob/master/files/galaxy/config/job_metrics_conf.xml

help:
	@echo "Please use \`make <target>\` where <target> is one of"
	@echo "  check                    don't make any changes; try to predict some of the changes that may occur"
	@echo "  apply                    configure remote Pulsar servers"

check: install_roles
	ansible-playbook -C -i inventory main.yml

apply:
	ansible-playbook -i inventory main.yml

get_job_metrics:
	wget -O files/job_metrics_conf.xml ${REMOTE_JMC_FILE}

pulsar: install_roles
	ansible-playbook -i inventory pulsar.yml

install_roles:
	ansible-galaxy install -p roles -r requirements.yml

clean:
	rm -rf roles
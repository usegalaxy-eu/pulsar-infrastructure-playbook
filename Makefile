REMOTE_JMC_FILE=https://raw.githubusercontent.com/AndreasSko/Galaxy-Benchmarker/master/galaxy_files/job_metrics_conf.xml

help:
	@echo "Please use \`make <target>\` where <target> is one of"
	@echo "  check                    don't make any changes; try to predict some of the changes that may occur"
	@echo "  apply                    configure remote Pulsar servers"

check:
	ansible-playbook -C -i inventory main.yml

apply:
	ansible-playbook -i inventory main.yml

get_job_metrics:
	wget -O files/job_metrics_conf.xml ${REMOTE_JMC_FILE}

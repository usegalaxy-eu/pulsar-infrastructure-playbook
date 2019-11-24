REMOTE_JMC_FILE=https://raw.githubusercontent.com/usegalaxy-eu/infrastructure-playbook/master/files/galaxy/config/job_metrics_conf.xml

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $2, ($2))))

help:
	@echo "Please use \`make <target>\` where <target> is one of"
	@echo "  preparation FQDN=value   add directories and file for a new Pulsar endpoint with FQDN=value"
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

check_fqdn:
	$(call check_defined, FQDN, add FQDN=value)

preparation: check_fqdn
	echo $(FQDN) ansible_connection=ssh ansible_user=centos >> inventory
	mkdir -p files/$(FQDN)
	cp files/job_metrics_conf.xml files/$(FQDN)
	touch host_vars/$(FQDN)
	echo "message_queue_url : <rabbit_mq_usegalaxy.eu_url>" > host_vars/$(FQDN)
	mkdir -p templates/$(FQDN)
	cp templates/app.yml.j2 templates/$(FQDN)

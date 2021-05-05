VENV_HOME := $(HOME)/.pyenv/versions/adv-servicmess
VENV_ACTIVATE := $(VENV_HOME)/bin/activate

.DEFAULT_GOAL = bookinfo-servicemess

.PHONY:
check:
	@echo Check if the openshift python module is available
	@( \
		source $(VENV_ACTIVATE); \
		python -c 'import openshift'; \
	)

.PHONY:
venv: check
	python -m venv $(VENV_HOME)
	( \
		source $(VENV_ACTIVATE); \
		pip install -r requirements.txt; \
	)
.PHONY:
dependencies: check
	( \
		source $(VENV_ACTIVATE); \
		ansible-galaxy collection install -r roles/requirements.yml; \
	)
.PHONY:
bookinfo: dependencies
	@echo Install the bookinfo application
	( \
		source $(VENV_ACTIVATE); \
		ansible-playbook playbooks/01-setup-bookinfo.yml; \
	)

.PHONY:
servicemess: bookinfo
	@echo Setup servicemess
	( \
		source $(VENV_ACTIVATE); \
		ansible-playbook playbooks/02-setup-servicemess.yml; \
	)
.PHONY:
bookinfo-servicemess: servicemess
	@echo Enable servicemess for the bookinfo project
	( \
		source $(VENV_ACTIVATE); \
		ansible-playbook playbooks/03-setup-bookinfo-servicemess.yml; \
	)

.PHONY:
configure-servicemess:
	@echo Enable servicemess for the bookinfo project
	( \
		source $(VENV_ACTIVATE); \
		ansible-playbook playbooks/04-configure-servicemess.yml; \
	)

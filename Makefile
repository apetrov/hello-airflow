AIRFLOW_HOME := ~/airflow
AIRFLOW_VERSION = 2.0.1
PYTHON_VERSION = $(shell python --version | cut -d " " -f 2 | cut -d "." -f 1-2)
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-$(AIRFLOW_VERSION)/constraints-$(PYTHON_VERSION).txt"
VARIABLES = variables.json

# Create Python venv
venv:
	if [ ! -d $(AIRFLOW_HOME) ]; then python3 -m venv $(AIRFLOW_HOME); fi

# activate venv
activate:
	echo "RUN:"
	echo source  ~/airflow/bin/activate

install:
	pip install "apache-airflow==$(AIRFLOW_VERSION)" --constraint "$(CONSTRAINT_URL)"

init:
	echo "~/.local/bin expected to be in PATH"
	airflow db init
	airflow users create --username admin --firstname admin --lastname admin --role Admin --email apetrov@hey-me.com

export:
	airflow variables export $(VARIABLES)

import:
	airflow variables import $(VARIABLES)

link:
	ln -s $(PWD)/dags $(AIRFLOW_HOME)/dags

server:
	airflow webserver --port 8080

scheduler:
	airflow scheduler

env:
	echo $(AIRFLOW_HOME) $(AIRFLOW_VERSION) $(PYTHON_VERSION)



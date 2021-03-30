export AIRFLOW_HOME=~/airflow

AIRFLOW_VERSION=2.0.1
PYTHON_VERSION="$(python3.8 --version | cut -d " " -f 2 | cut -d "." -f 1-2)"

CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

pip3 install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"
pip3 install gunicorn

export AIRFLOW=$HOME/.local/bin/airflow 

$AIRFLOW db init

$AIRFLOW users create --username admin --firstname admin --lastname admin --role Admin --email apetrov@hey-me.com

$AIRFLOW webserver --port 8080


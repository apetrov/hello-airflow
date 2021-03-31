import datetime

from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator


with DAG(
    dag_id="postgres_operator_dag",
    start_date=datetime.datetime(2020, 2, 2),
    schedule_interval="@once",
    catchup=False,
) as dag:
    create_pet_table = PostgresOperator(
        task_id="create_pet_table",
        postgres_conn_id="postgres_default",
        sql="""
            CREATE TABLE IF NOT EXISTS pet (
            pet_id SERIAL PRIMARY KEY,
            name VARCHAR NOT NULL,
            pet_type VARCHAR NOT NULL,
            birth_date DATE NOT NULL,
            OWNER VARCHAR NOT NULL);
          """,
    )

    populate_pet_table = PostgresOperator(
          task_id="populate_pet_table",
          postgres_conn_id="postgres_default",
          sql="""
            INSERT INTO pet VALUES ( 'Max', 'Dog', '2018-07-05', 'Jane');
            INSERT INTO pet VALUES ( 'Susie', 'Cat', '2019-05-01', 'Phil');
            INSERT INTO pet VALUES ( 'Lester', 'Hamster', '2020-06-23', 'Lily');
            INSERT INTO pet VALUES ( 'Quincy', 'Parrot', '2013-08-11', 'Anne');
            """
          )


    get_all_pets = PostgresOperator(
                    task_id="get_all_pets", postgres_conn_id="postgres_default", sql="SELECT * FROM pet;"
                        )

    create_pet_table >>  populate_pet_table >> get_all_pets


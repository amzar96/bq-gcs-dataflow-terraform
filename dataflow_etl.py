# https://github.com/apache/beam/blob/master/sdks/python/apache_beam/examples/kafkataxi/kafka_taxi.py
# https://github.com/lucdk26/dataflow-python-examples-1/blob/master/dataflow_python_examples/data_ingestion.py#L27

import csv
import io

import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
from apache_beam.io import ReadFromText, WriteToText
from apache_beam.io.gcp.bigquery import WriteToBigQuery


class ParseCSV(beam.DoFn):
    def process(self, element):
        reader = csv.reader(io.StringIO(element))
        for row in reader:
            yield {
                "id": int(row[0]),
                "name": row[1],
                "email": row[2],
                "created_date": row[3],
            }


class TransformData(beam.DoFn):
    def process(self, element):
        element["name"] = element["name"].upper()
        element["email"] = element["email"].lower()
        yield element


def read_csv_file(readable_file):
    with beam.io.filesystems.FileSystems.open(readable_file) as gcs_file:
        for row in csv.reader(gcs_file):
            yield row


def run_pipeline(argv=None):
    pipeline_options = PipelineOptions(argv, save_main_session=True)

    parse_csv = ParseCSV()

    with beam.Pipeline(options=pipeline_options) as pipeline:
        raw_data = (
            pipeline
            | beam.io.ReadFromText(
                "gs://cdp-raw-data-prod/input/*.csv", skip_header_lines=1
            )
            | beam.Map(lambda s: parse_csv.process(s))
            | WriteToText("gs://cdp-staging-data-prod/processed")
        )

        (
            raw_data
            | beam.ParDo(TransformData())
            | WriteToBigQuery(
                table="cdp-project-prod:raw_customer_data.customers",
                schema="id:INTEGER,name:STRING,email:STRING,created_date:STRING",
                write_disposition="WRITE_APPEND",
                batch_size=1000,
            )
            # BigQuerySink is deprecated https://stackoverflow.com/questions/58226848/beam-python-dataflow-runner-uses-deprecated-bigquerysink-instead-of-writetobigqu
        )


if __name__ == "__main__":
    run_pipeline()

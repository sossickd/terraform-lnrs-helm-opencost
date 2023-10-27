resource "aws_glue_catalog_database" "awscur_database" {
  name = "${var.cluster_name}-awscur_database"

  catalog_id = var.aws.account_id
}

resource "aws_glue_crawler" "awscur_crawler" {
  name          = "AWSCURCrawler-${var.cluster_name}-cur-report"
  description   = "A recurring crawler that keeps your CUR table in Athena up-to-date."
  role          = aws_iam_role.awscur_crawler_component_function.arn
  database_name = aws_glue_catalog_database.awscur_database.arn

  s3_target {
    path       = "s3://${var.cluster_name}-us-east-1-cur-athena/opencost-prefix/${var.cluster_name}-opencost-report/${var.cluster_name}-cur-report/${var.cluster_name}-cur-report"
    exclusions = ["**.json", "**.yml", "**.sql", "**.csv", "**.gz", "**.zip"]
  }
  schema_change_policy {
    update_behavior = "UPDATE_IN_DATABASE"
    delete_behavior = "DELETE_FROM_DATABASE"
  }
}

resource "aws_glue_catalog_table" "catalog_table" {
  catalog_id    = var.aws.account_id
  database_name = aws_glue_catalog_database.awscur_database.name
  name          = "${var.cluster_name}_cost_and_usage_data_status"
  storage_descriptor {
    columns {
      name = "status"
      type = "string"
    }

    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    location      = "s3://${var.cluster_name}-us-east-1-cur-athena/opencost-prefix/${var.cluster_name}-opencost-report/${var.cluster_name}-cur-report/cost_and_usage_data_status/"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
    ser_de_info {
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
    }

  }

  table_type = "EXTERNAL_TABLE"
}
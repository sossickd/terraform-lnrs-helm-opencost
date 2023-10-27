#resource "aws_ce_cost_category" "aws_start_cur_crawler" {
#  name = "${cluster_name}-aws-start-cur-crawler"
#  rule_version = "CostCategoryExpression.v1"
#  # CF Property(ServiceToken) = aws_lambda_function.awscur_initializer.arn
#}
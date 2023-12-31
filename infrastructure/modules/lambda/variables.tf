variable "key" {
  type        = string
  description = "A distinct key associated with a Lambda function"
}

variable "aws_iam_policy_arn" {
  type        = string
  description = "The ARN of the IAM policy associated with the Lambda function"
}

variable "aws_iam_policy_arn_dynamo" {
  type        = string
  description = "The ARN of the IAM policy associated with the Lambda function that allows access to dynamodb's operations."
}

variable "function_name" {
  type        = string
  description = "The name of the Lambda function"
}

variable "lambda_payload_filename" {
  type        = string
  description = "The name of the file containing the Lambda function payload"
}

variable "handler" {
  type        = string
  description = "The name of the Lambda function handler"
}

variable "aws_apigatewayv2_api_id" {
  type        = string
  description = "The id of the API Gateway"
}

variable "aws_apigatewayv2_api_execution_arn" {
  type        = string
  description = "The execution arn of the API Gateway"
}

variable "route_key" {
  type        = string
  description = "The route key used to define a Route of the API Gateway"
}

variable "memory_size" {
  type        = number
  description = "The amount of memory in MB allocated to the Lambda function"
}

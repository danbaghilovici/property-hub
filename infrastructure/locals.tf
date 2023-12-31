locals {
  lambdas = {
    "test" = {
      route_key     = "GET /api/v1/test"
      function_name = "test"
      handler       = "../lambdas/lambda1.js"
    },
  }
}

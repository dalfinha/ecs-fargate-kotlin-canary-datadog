resource "aws_codedeploy_deployment_group" "this" {

  app_name               = aws_codedeploy_app.this.name
  deployment_config_name = var.deployment_config_canary
  deployment_group_name  = aws_codedeploy_app.this.name
  service_role_arn       = var.role_codedeploy

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }

  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [ var.arn_listener ]
      }

      target_group {
        name = var.listeners_name.["green"].name
      }

      target_group {
        name = var.listeners_name.["blue"].name
      }
    }
  }

}
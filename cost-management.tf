resource "time_static" "current" {}

resource "azurerm_subscription_cost_management_export" "cost_report" {
  name                         = "${var.cluster_name}-cost-report"
  subscription_id              = data.azurerm_subscription.current.id
  recurrence_type              = "Daily"
  recurrence_period_start_date = local.current_time
  recurrence_period_end_date   = local.cost_report_end_date

  export_data_storage_location {
    container_id     = azurerm_storage_container.cost_report.resource_manager_id
    root_folder_path = "/root/${var.cluster_name}-cost-report"
  }

  export_data_options {
    type       = "AmortizedCost"
    time_frame = "MonthToDate"
  }
}
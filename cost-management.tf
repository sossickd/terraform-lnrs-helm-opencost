
resource "azurerm_subscription_cost_management_export" "cost_report" {
  name                         = "${var.cluster_name}-cost-report"
  subscription_id              = var.azure.subscription_id
  recurrence_type              = "Daily"
  recurrence_period_start_date = timestamp()
  recurrence_period_end_date   = timeadd(formatdate("YYYY-MM-DD'T'00:00:00Z", timestamp()), "43800h")

  export_data_storage_location {
    container_id     = azurerm_storage_container.cost_report.resource_manager_id
    root_folder_path = "/${var.cluster_name}-cost-report"
  }

  export_data_options {
    type       = "AmortizedCost"
    time_frame = "MonthToDate"
  }
}
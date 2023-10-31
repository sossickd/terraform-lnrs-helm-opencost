#resource "azurerm_role_definition" "opencost_ratecard_reader" {
#  count = var.cloud == "azure" ? 1 : 0
#
#  name        = "${var.cluster_name}-opencost"
#  scope       = "/subscriptions/${var.azure.subscription_id}"
#  description = "Custom role for opencost to read the rate card"
#
#  assignable_scopes = ["/subscriptions/${var.azure.subscription_id}"]
#
#  permissions {
#    actions = [
#      "Microsoft.Compute/virtualMachines/vmSizes/read",
#      "Microsoft.Resources/subscriptions/locations/read",
#      "Microsoft.Resources/providers/read",
#      "Microsoft.ContainerService/containerServices/read",
#      "Microsoft.Commerce/RateCard/read"
#    ]
#    data_actions     = []
#    not_actions      = []
#    not_data_actions = []
#  }
#}

module "identity" {
  count = var.cloud == "azure" ? 1 : 0

  source = "./modules/identity"

  location            = var.azure.location
  resource_group_name = var.azure.resource_group_name

  workload_identity = local.use_aad_workload_identity
  oidc_issuer_url   = var.cluster_oidc_issuer_url

  name      = "${var.cluster_name}-opencost"
  subjects  = ["system:serviceaccount:${var.namespace}:${local.service_account_name}"]
  namespace = var.namespace
  labels    = var.labels

  roles = [{
    id = "DNS Zone Contributor"
   # id    = azurerm_role_definition.opencost_ratecard_reader[0].role_definition_resource_id
    scope = "/subscriptions/${var.azure.subscription_id}"
  }]

  tags = var.tags
}
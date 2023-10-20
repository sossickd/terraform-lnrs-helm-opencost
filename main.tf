resource "kubernetes_namespace" "default" {
  metadata {
    name = var.namespace

    labels = {
      name = var.namespace
    }
  }
}

resource "kubectl_manifest" "resource_files" {
  for_each = local.resource_files

  yaml_body = file(each.value)

  server_side_apply = true
  wait              = true

  depends_on = [
    helm_release.default,
    kubernetes_namespace.default
  ]
}

resource "kubernetes_config_map_v1_data" "terraform_modules" {
  metadata {
    name      = "terraform-modules"
    namespace = "default"
  }

  data = {
    (local.module_name) = local.module_version
  }

  field_manager = local.module_name

  depends_on = [
    helm_release.default
  ]
}

resource "kubernetes_config_map" "opencost" {
  count = var.cloud == "aws" ? 1 : 0

  metadata {
    name      = "opencost-aws"
    namespace = var.namespace
  }

  data = {
    "aws.json" = local.opencost_configmap_data
  }

  depends_on = [
    kubernetes_namespace.default
  ]
}

resource "helm_release" "default" {
  name      = var.release_name
  namespace = var.namespace

  repository = "https://opencost.github.io/opencost-helm-chart"
  chart      = "opencost"
  version    = local.chart_version
  skip_crds  = true

  force_update = false

  values = [
    yamlencode(local.chart_values)
  ]

  depends_on = [
    kubernetes_namespace.default,
    kubernetes_config_map.opencost,
    module.iam_role
  ]
}

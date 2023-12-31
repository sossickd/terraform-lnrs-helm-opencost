locals {
  module_name    = "terraform-lnrs-helm-opencost"
  module_version = "1.0.0-rc.1"

  chart_version = "1.15.3"

  chart_values = {

    nameOverride = "opencost"

    serviceAccount = {
      create = true

      annotations = var.cloud == "aws" ? { "eks.amazonaws.com/role-arn" = module.iam_role.arn } : {}

      automountServiceAccountToken = true

    }

    podLabels = {
      "lnrs.io/k8s-platform" = "true"
    }

    opencost = {
      exporter = {
        defaultClusterId = var.cluster_name

        replicas = 2

        resources = {
          requests = {
            cpu    = "10m"
            memory = "55Mi"
          }

          limits = {
            cpu    = "1000m"
            memory = "1Gi"
          }
        }

        extraEnv = var.cloud == "aws" ? {
          AWS_PRICING_URL = "https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonEC2/current/eu-west-1/index.json"
          CONFIG_PATH     = "/tmp/custom-config"
        } : {}

        extraVolumeMounts = var.cloud == "aws" ? [{
          mountPath = "/tmp/custom-config"
          name      = "custom-configs"
          }] : var.cloud == "azure" ? [{
          mountPath = "/var/secrets"
          name      = "service-key-secret"
        }] : []
      }

      customPricing = {
        enabled = false

        configmapName = "custom-pricing-model"

        configPath = "/tmp/custom-config"

        createConfigmap = true
      }

      metrics = {
        serviceMonitor = {
          enabled = true

          additionalLabels = {
            "lnrs.io/monitoring-platform" = true
          }
        }
      }

      prometheus = {
        internal = {
          enabled = var.thanos_enabled == true ? false : true

          serviceName = "kube-prometheus-stack-prometheus"

          namespaceName = "monitoring"

          port = 9090
        }
        thanos = {
          enabled = var.thanos_enabled == true ? true : false
          internal = {
            enabled = var.thanos_enabled == true ? true : false

            serviceName = "thanos-query-frontend"

            namespaceName = "monitoring"

            port = 10902
          }
        }
      }

      ui = {
        enabled = var.enable_ui

        resources = {
          requests = {
            cpu    = "10m"
            memory = "55Mi"
          }

          limits = {
            cpu    = "1000m"
            memory = "1Gi"
          }
        }

        ingress = {
          enabled = var.enable_ui

          ingressClassName = var.cloud == "aws" ? "alb-core-internal" : var.cloud == "azure" ? "core-internal" : ""

          annotations = merge(
            var.ingress_annotations,
            var.cloud == "aws" ? {
              "alb.ingress.kubernetes.io/healthcheck-path" = "/-/ready"
              "alb.ingress.kubernetes.io/inbound-cidrs"    = "10.0.0.0/8,145.43.180.0/22"
              "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
              "alb.ingress.kubernetes.io/target-type"      = "ip"
              "lnrs.io/zone-type"                          = "private"
              } : var.cloud == "azure" ? {
              "lnrs.io/zone-type" = "private"
          } : {}, )

          hosts = [{
            host = var.ingress_hostname
          }]
        }


      }

    }

    nodeSelector = {
      "kubernetes.io/os" = "linux"
      "lnrs.io/tier"     = "system"
    }

    tolerations = concat([{
      key      = "system"
      operator = "Exists"
      }], var.cloud == "azure" ? [{
      key      = "CriticalAddonsOnly"
      operator = "Exists"
    }] : [])

    extraVolumes = var.cloud == "aws" ? [{
      name = "custom-configs"
      configMap = {
        name = "opencost-aws"
      }
      }] : var.cloud == "azure" ? [{
      name = "service-key-secret"
      secret = {
        secretName = "azure-service-key"
    } }] : [{}]

  }

  service_account_name = "opencost"

  resource_files = { for x in fileset(path.module, "resources/*.yaml") : basename(x) => "${path.module}/${x}" }
}

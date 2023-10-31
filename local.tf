locals {
  module_name    = "terraform-lnrs-helm-opencost"
  module_version = "1.0.0-rc.1"

  chart_version = "1.20.1"

  use_aad_workload_identity = true

  chart_values = {

    nameOverride = "opencost"

    serviceAccount = {
      create = true

      annotations = var.cloud == "azure" && local.use_aad_workload_identity == true ? { "azure.workload.identity/client-id" = module.identity.client_id[0] } : {}

      automountServiceAccountToken = true

    }

    podLabels = merge(var.labels,
      var.cloud == "azure" && local.use_aad_workload_identity == true ? { "azure.workload.identity/use" = "true" } :
      var.cloud == "azure" && local.use_aad_workload_identity == false ? { aadpodidbinding = module.identity[0].name } :
    var.cloud == "aws" ? {} : {})

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
            "lnrs.io/monitoring-platform" = "true"
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
              "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
              "alb.ingress.kubernetes.io/inbound-cidrs"    = "10.0.0.0/8,145.43.180.0/22"
              "alb.ingress.kubernetes.io/ssl-redirect"     = "443"
              "alb.ingress.kubernetes.io/target-type"      = "ip"
              "lnrs.io/zone-type"                          = "private"
              } : var.cloud == "azure" ? {
              "lnrs.io/zone-type" = "private"
          } : {}, )

          hosts = [{
            host  = var.ingress_hostname
            paths = ["/"]
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
    }] : []

  }

#  opencost_configmap_data = <<-EOT
#    {
#        "provider": "${var.cloud}",
#        "description": "AWS Provider Configuration. Provides default values used if instance type or spot information is not found.",
#        "CPU": "0.031611",
#        "spotCPU": "0.006655",
#        "RAM": "0.004237",
#        "GPU": "0.95",
#        "spotRAM": "0.000892",
#        "storage": "0.000138888889",
#        "zoneNetworkEgress": "0.01",
#        "regionNetworkEgress": "0.01",
#        "internetNetworkEgress": "0.143",
#        "spotLabel": "kops.k8s.io/instancegroup",
#        "spotLabelValue": "spotinstance-nodes",
#        "awsSpotDataRegion": "${module.aws_integration[0].spotfeed-bucket-region}",
#        "awsSpotDataBucket": "${module.aws_integration[0].spotfeed-bucket}",
#        "awsSpotDataPrefix": "${var.aws.spot_data_prefix}",
#        "athenaBucketName": "s3://${var.athena_bucket_name}",
#        "athenaRegion": "${var.athena_region}",
#        "athenaDatabase": "${var.athena_database}",
#        "athenaTable": "${var.athena_table}",
#        "athenaProjectID": "${var.aws.account_id}",
#        "projectID": "${var.aws.account_id}"
#    }
#  EOT

  service_account_name = "opencost"

  resource_files = { for x in fileset(path.module, "resources/*.yaml") : basename(x) => "${path.module}/${x}" }
}

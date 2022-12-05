resource "local_file" "kube_config" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  content    = azurerm_kubernetes_cluster.aks.kube_config_raw
  filename   = ".kube/config"
}


resource "null_resource" "set-kube-config" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "az aks get-credentials -n ${azurerm_kubernetes_cluster.aks.name} -g ${azurerm_resource_group.aks-rg.name} --file ~/.kube/config --admin --overwrite-existing"
  }
  depends_on = [local_file.kube_config]
}



resource "null_resource" "istio" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "istioctl install --set profile=default -y --kubeconfig ~/.kube/config"
  }
  depends_on = [
    null_resource.set-kube-config
  ]
}

resource "null_resource" "addons" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.15/samples/addons/kiali.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/prometheus.yaml"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/grafana.yaml"
  }
  depends_on = [
    null_resource.istio
  ]
}








/*resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

data "azurerm_subscription" "current" {
}


resource "kubernetes_namespace" "istio_system" {
  depends_on = [
    null_resource.set-kube-config
  ]

  metadata {
    annotations = {
      name = "example-annotation"
    }

    labels = {
      mylabel = "label-value"
    }

    name = "istio-system"
  }

}

resource "kubernetes_secret" "grafana" {
  provider = kubernetes
  metadata {
    name      = "grafana"
    namespace = "istio-system"
    labels = {
      app = "grafana"
    }
  }
  data = {
    username   = "admin"
    passphrase = random_password.password.result
  }
  type       = "Opaque"
  depends_on = [kubernetes_namespace.istio_system]
}

resource "kubernetes_secret" "kiali" {
  provider = kubernetes
  metadata {
    name      = "kiali"
    namespace = "istio-system"
    labels = {
      app = "kiali"
    }
  }
  data = {
    username   = "admin"
    passphrase = random_password.password.result
  }
  type       = "Opaque"
  depends_on = [kubernetes_namespace.istio_system]
}

resource "local_file" "istio-config" {
  content = templatefile("${path.module}/istio-aks.tmpl", {
    enableGrafana = true
    enableKiali   = true
    enableTracing = true
  })
  filename = ".istio/istio-aks.yaml"
}

resource "null_resource" "istio" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "istioctl install --set profile=default -y --kubeconfig ~/.kube/config"
    //command = "istioctl manifest apply -f \".istio/istio-aks.yaml\" --kubeconfig ~/.kube/config"
  }
  depends_on = [kubernetes_secret.grafana, kubernetes_secret.kiali, local_file.istio-config]
}

resource "null_resource" "kiali" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.15/samples/addons/kiali.yaml"
    //command = "istioctl manifest apply -f \".istio/istio-aks.yaml\" --kubeconfig ~/.kube/config"
  }
  depends_on = [kubernetes_secret.grafana, kubernetes_secret.kiali, local_file.istio-config]
}*/
resource "null_resource" "kube_config" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.eks-cluster.name} --kubeconfig .kube/config"
  }

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.region} --name ${aws_eks_cluster.eks-cluster.name}"
  }

  depends_on = [
    aws_eks_cluster.eks-cluster,
    aws_eks_node_group.eks-cluster-node-groups,
  ]
}

resource "null_resource" "istio" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "istioctl install --set profile=default -y --kubeconfig .kube/config"
  }

   provisioner "local-exec" {
    command = "kubectl label namespace default istio-injection=enabled"
  }

  depends_on = [
    null_resource.kube_config
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


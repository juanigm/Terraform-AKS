resource "null_resource" "clean-k8s-resources" {
 triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws ec2 describe-security-groups | Out-File -FilePath .sg"
    interpreter = ["PowerShell", "-Command"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "Get-Content -Path .sg | ConvertFrom-Json | Select-Object -ExpandProperty SecurityGroups | Where-Object -FilterScript {$_.Description -match 'Security group for Kubernetes ELB'} | Group-Object -Property 'GroupId'| Select-Object -Property Name | Out-File -FilePath .SGId"
    interpreter = ["PowerShell", "-Command"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws elb describe-load-balancers | Out-File -FilePath .elb"
    interpreter = ["PowerShell", "-Command"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "Get-Content -Path .elb | ConvertFrom-Json | Select-Object -ExpandProperty LoadBalancerDescriptions | Where-Object -FilterScript {$_.SecurityGroups -match ((Get-Content -Path .SGId -TotalCount 4)[-1])} | Group-Object -Property 'LoadBalancerName' | Select-Object -Property Name | Out-File -FilePath .ELBName"
    interpreter = ["PowerShell", "-Command"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws elb delete-load-balancer --load-balancer-name ((Get-Content -Path .ELBName -TotalCount 4)[-1])"
    interpreter = ["PowerShell", "-Command"]
  }

}

resource "null_resource" "clean-sg" {

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws ec2 delete-security-group --group-id ((Get-Content -Path .SGId -TotalCount 4)[-1])"
    interpreter = ["PowerShell", "-Command"]
  }
}
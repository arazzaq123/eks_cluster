output "opid_url" {
    value = aws_iam_openid_connect_provider.eks.url
}

output "opid_arn" {
    value = aws_iam_openid_connect_provider.eks.arn
}
output "certificate_authority" {
    value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_endpoint"{
    value = aws_eks_cluster.cluster.endpoint
}

output "cluster_id"{
    value = aws_eks_cluster.cluster.id
}
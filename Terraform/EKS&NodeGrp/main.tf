data "aws_iam_policy_document" "assume-role" {
  statement {
    effect = var.effect

    principals {
      type        = var.type
      identifiers = [var.identifiers]
    }

    actions = [var.actions]
  }
}

resource "aws_iam_role" "my-role" {
  name               = var.eks_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

resource "aws_iam_role_policy_attachment" "my-AmazonEKSClusterPolicy" {
  policy_arn = var.my-AmazonEKSClusterPolicy
  role       = aws_iam_role.my-role.name
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default-subnets" {
  /* filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  } */
  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  }
}

data "aws_security_group" "my-sg" {
  id = var.my_sg
}

resource "aws_eks_cluster" "my-cluster" {
  name     = var.my-cluster
  role_arn = aws_iam_role.my-role.arn

  vpc_config {
    subnet_ids         = data.aws_subnets.default-subnets.ids
    security_group_ids = [data.aws_security_group.my-sg.id]
  }
  upgrade_policy {
    support_type = "STANDARD"
  }

  depends_on = [
    aws_iam_role_policy_attachment.my-AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "my-role-1" {
  name = var.eks_node_group_role_name

  assume_role_policy = jsonencode({
    Statement = [{
      Action = var.actions
      Effect = var.effect
      Principal = {
        Service = var.eks_node_group_role_name_service
      }
    }]
    Version = var.eks_version
  })
}

resource "aws_iam_role_policy_attachment" "my-AmazonEKSWorkerNodePolicy" {
  policy_arn = var.my-AmazonEKSWorkerNodePolicy
  role       = aws_iam_role.my-role-1.name
}

resource "aws_iam_role_policy_attachment" "my-AmazonEKS_CNI_Policy" {
  policy_arn = var.my-AmazonEKS_CNI_Policy
  role       = aws_iam_role.my-role-1.name
}

resource "aws_iam_role_policy_attachment" "my-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = var.my-AmazonEC2ContainerRegistryReadOnly
  role       = aws_iam_role.my-role-1.name
}

resource "aws_eks_node_group" "my-node-grp" {
  cluster_name    = aws_eks_cluster.my-cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.my-role-1.arn
  subnet_ids      = data.aws_subnets.default-subnets.ids

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }
  instance_types = [var.instance_types]

  depends_on = [
    aws_iam_role_policy_attachment.my-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.my-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.my-AmazonEC2ContainerRegistryReadOnly,
  ]
}

output "eks_cluster_node_grp" {
  value = aws_eks_node_group.my-node-grp.node_group_name
} 
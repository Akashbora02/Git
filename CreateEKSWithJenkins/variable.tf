variable "effect" {
  default = "Allow"
}

variable "type" {
  default = "Service"
}

variable "identifiers" {
  default = "eks.amazonaws.com"
}

variable "actions" {
  default = "sts:AssumeRole"
}

variable "eks_iam_role_name" {
  default = "my-role"
}

variable "my-AmazonEKSClusterPolicy" {
  default = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

variable "my-cluster" {
  default = "EKS"
}

variable "eks_node_group_role_name" {
  default = "eks-node-grp-role"
}

variable "eks_node_group_role_name_service" {
  default = "ec2.amazonaws.com"
}

variable "eks_version" {
  default = "2012-10-17"
}

variable "my-AmazonEKSWorkerNodePolicy" {
  default = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

variable "my-AmazonEKS_CNI_Policy" {
  default = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

variable "my-AmazonEC2ContainerRegistryReadOnly" {
  default = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

variable "eks_node_group_name" {
  default = "my-node"
}

variable "instance_types" {
  default = "c7i-flex.large"
}

variable "my_sg" {
  default = "sg-013ac9044ebaee90e"
}
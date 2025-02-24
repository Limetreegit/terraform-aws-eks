run kubectl on command line 
1. role adminAccessRole can run kubectl command because it has eks-auth:* and eks:* permissions
2. but the role is not in aws-auth file. Why it still can run kubectl 

======
christina@Tree-MacBook-Pro build-eks-module % aws sts get-caller-identity
{
    "UserId": "AROAYF34FUIEZ76DSSICW:botocore-session-1739647954",
    "Account": "562364260873",
    "Arn": "arn:aws:sts::562364260873:assumed-role/adminAccessRole/botocore-session-1739647954"
}

==== 
inline policy the role adminAccessRole has: 
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Sid": "VisualEditor0",
			"Effect": "Allow",
			"Action": [
				"eks-auth:*",
				"eks:*"    # even after deleting this, adminAccessRole still can kubectl delete pod
			],
			"Resource": "*"
		}
	]
}


======
======
Grant user sre the EKS console view

== error when access eks 
Your current IAM principal doesn't have access to Kubernetes objects on this cluster.
This may be due to the current user or role not having Kubernetes RBAC permissions to describe cluster resources or not having an entry in the cluster’s auth config map.

Solution:
need to configure both
1. add eks iam policy to user iam sre 
2. RBAC setting 
add user sre to configmap aws-auth, and add it the group system:masters

== iam policy "eksConsoleAccess" which is assigned to a group of SRE since user SRE reached 10 something policy cap
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:ListClusters",
                "eks:DescribeCluster",
                "eks:ListNodegroups",
                "eks:DescribeNodegroup"
            ],
            "Resource": "*"
        }
    ]
}

==== cm config for step 2
christina@Tree-MacBook-Pro build-eks-module % k describe cm aws-auth -n  kube-system
Name:         aws-auth
Namespace:    kube-system
Labels:       <none>
Annotations:  <none>

Data
====
mapRoles:
----
- groups:
  - system:bootstrappers
  - system:nodes
  rolearn: arn:aws:iam::562364260873:role/eksNodeRole
  username: system:node:{{EC2PrivateDNSName}}

mapUsers:   #### <=====
----
- userarn: arn:aws:iam::562364260873:user/system/sre
  # username: sre
  groups:
    - system:masters




# Jenkins Pipeline for Python based application using Docker, SonarQube, Argo CD, Helm and Kubernetes

Prerequisites:

   -  Python application code hosted on a Git repository
   -  Jenkins server
   -  Kubernetes cluster
   -  Helm package manager
   -  Argo CD

Run this project on local environment then go ahed for CICD.


### Create cluster
``` shell
eksctl create cluster \
--name streamlit-cluster \
--region us-west-2 \
--node-type t2.medium \
--nodes-min 2 \
--nodes-max 2
```

### Update kubeconfig to point kubectl
``` shell
aws eks update-kubeconfig \
--region us-west-2 \
--name streamlit-cluster
kubectl get nodes
```

``` shell
kubectl create ns streamlit-app
```

### Create IAM policy
``` shell
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json
aws iam create-policy \
--policy-name AWSLoadBalancerControllerIAMPolicy \
--policy-document file://iam_policy.json
```

### Open-ID connect provider
``` shell
eksctl utils associate-iam-oidc-provider \
--region=us-west-2 \
--cluster=streamlit-cluster \
--approve
```

### Create service account
``` shell
eksctl create iamserviceaccount \
--cluster=streamlit-cluster \
--namespace=kube-system \
--name=aws-load-balancer-controller \
--role-name AmazonEKSLoadBalancerControllerRole \
--attach-policy-arn=arn:aws:iam::<aws_account_id>:policy/AWSLoadBalancerControllerIAMPolicy \
--approve \
--region=us-west-2
```

### Deploy AWS load balancer controller
``` shell
sudo snap install helm --classic

helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
-n kube-system \
--set clusterName=streamlit-cluster \
--set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create ns monitoring
helm install monitoring prometheus-community/kube-prometheus-stack -n monitoring

helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
kubectl create namespace argocd
helm install argocd argo/argo-cd --namespace argocd
```
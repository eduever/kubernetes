############ Docker commands #################

docker run --rm -ti -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e AWS_SECURITY_TOKEN amazon/aws-cli s3 ls

########## AWS CLI CMDS #################
aws-iam-authenticator help
aws sts get-caller-identity
aws eks get-token
aws eks get-token --cluster-name terraform-eks-demo
kubectl get svc
aws eks update-kubeconfig --name kubernetes --region us-west-2

export AWS_PROFILE="admin"

echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config-devel' >>~/.bash_profile

######### kubernetes native cmds ###########

## official cheatsheet link:  https://kubernetes.io/docs/reference/kubectl/cheatsheet/

kubectl describe configmap -n kube-system aws-auth
kubectl edit -n kube-system configmap/aws-auth
kubectl -n kube-system get cm
kubectl -n kube-system get config aws-auth -o yaml >aws-auth-configmap.yaml
kubectl apply -f aws-auth-configmap.yaml -n kube-system
kubectl -n kube-system get cm aws-auth
kubectl -n kube-system describe cm aws-auth
kubectl describe pods redis-master-7d97765bbb-tj9pz

kubectl describe pod -l app=frontend

kubectl get ingress -n banana

kubectl create namespace <insert-some-namespace-name>
kubectl delete namespaces <insert-some-namespace-name1> <insert-some-namespace-name2>

### https://stackoverflow.com/questions/47128586/how-to-delete-all-resources-from-kubernetes-one-time
kubectl delete all --all


kubectl delete pod,svc,deployment,ing,job --all -n ingress-nigx

kubectl -n <namespace> logs -f deployment/<app-name> --all-containers=true --since=10m

kubectl get events --sort-by='.metadata.creationTimestamp'


#####    EKSCTL ####
eksctl create cluster -f ./cluster.yaml
eksctl get nodegroup --cluster=managed-cluster
eksctl delete nodegroup --cluster=managed-cluster --name=managed-ng-1 --approve
eksctl create nodegroup --config-file=dev-cluster.yaml
eksctl scale nodegroup --cluster=managed-cluster --nodes=3 --name=managed-ng-2

######### HELM 3 CMDS ###########################
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo list
helm repo add 
helm repo remove

helm search [hub|repo] keyword
helm inspect [all|readme|chart|values] chart_name

helm show values
helm fetch chart_name # download the chart with no dependecies
helm dependency update chart_name ## download the chart with  dependecies

helm repo update

helm search repo chatmuseum/

helm ls --all
helm install rutwik-nginx-ingress ingress-nginx/ingress-nginx
helm uninstall rutwik-nginx-ingress

### here <name-of-release>=demorel

helm install <name-of-release> <chart-name>
helm list --short

helm get manifest <name-of-release> | less
helm upgrade <name-of-release> <chart-name>
helm status <name-of-release>

helm rollback <name-of-release> <revision-no-youwanted-not-current>

example: helm rollback demorel 1

helm history <name-of-release>

helm uninstall <name-of-release>

#Testing

helm template <chart-name> | less
helm install <name-of-release> <chart-name> --dry-run --debug

helm install dev guestbook --set frontend.config.guestbook_name=DEV

helm repo index .
helm package --sign
helm verify chart.tgz
helm install --verify

helm dependency update <umbrella-chart-name>
    e.g: helm dependency update guestbook

helm dependency list guestbook

helm dependency build guestbook

helm get manifest <release-name>








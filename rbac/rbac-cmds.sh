## below tutorial we will create a user John and add him to finance group,
## -- create respective Role & Rolebindings and attach group to the RoleBinding.

cd /home/cloud_user/lab/rbac

## we need Certificate Authority private key & certificate to sign the user John CSR ( Certificate Signing Request).
sudo cp /etc/kubernetes/pki/ca.{crt,key} .

#create a new privacete key for John
openssl genrsa -out john.key 2048

# Create a CSR for the john with the previous private key, CN=User, O=group
openssl req -new -key john.key -out john.csr -subj "/CN=john/O=finance"

## using the CA Authority private key & certificate, SIGN the John CSR, and output the John certificate (john.crt)
sudo openssl x509 -req -in john.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out john.crt -days 3650

## to view current kubeConfig file, to get cluster details
kubectl config view

## create kubeConfig file for john in current dir.
kubectl --kubeconfig john.kubeconfig config set-cluster kubernetes --server https://172.31.34.157:6443 --certificate-authority=ca.crt
vi john.kubeconfig

# set credentials for the Johns kubeConfig file.
kubectl --kubeconfig john.kubeconfig config set-credentials john --client-certificate /home/cloud_user/lab/rbac/john.crt --client-key /home/cloud_user/lab/rbac/john.key

# set context for the Johns kubeConfig file.
kubectl --kubeconfig john.kubeconfig config set-context john-kubernetes --cluster kubernetes --namespace finance --user john
sudo vi john.kubeconfig

## At this point you will not have any access.
kubectl get pods
kubectl get pods --kubeconfig john.kubeconfig

## create a role to access the custer
kubectl create role --help | grep kubectl
kubectl create role finance-role --verb=get,list --resource=pods --namespace finance
kubectl get role finance-role -n finance -o yaml
kubectl edit role finance-role -n finance

## At this point you will not have any access, as roleBinding is missing.
kubectl get pods --kubeconfig john.kubeconfig

## create a roleBinding to access the Role, either direct user or group
# To the user John
kubectl create rolebinding finance-rolebinding --role=finance-role --user=john --namespace finance
# To the Grouo finance
kubectl create rolebinding finance-rolebinding --role=finance-role --group=finance --namespace finance
kubectl get rolebinding finance-role-rolebinding -n finance -o yaml
kubectl edit rolebinding finance-rolebinding --namespace finance

## test
kubectl --kubeconfig john.kubeconfig create deploy nginx --image nginx
kubectl get all --kubeconfig john.kubeconfig

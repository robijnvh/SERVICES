# !bin/zsh

# STOP AND DELETE RUNNING PROCESSES #
# minikube stop
# minikube delete

# LINK TO GOINFRE #
# rm -rf ~/.minikube/machines
# mkdir -p ~/goinfre/machines
# ln -s ~/goinfre/machines ~/.minikube/machines

# START #
echo -e "STARTING MINIKUBE"
minikube start --vm-driver=virtualbox

# ACTIVATE ADDONS #
minikube addons enable metallb
minikube addons enable dashboard
# minikube addons enable metrics-server

# CREATE METALLB #
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f srcs/service-metallb/metallb.yaml

# SETUP LOCAL IMAGE #
eval $(minikube docker-env)

# SET METALLB SERVICE ACCOUNT #
kubectl apply -f srcs/service-metallb/serviceaccount.yaml

# NGINX #
echo -e "CREATE NGINX IMAGE AND DEPLOYMENT"
docker build -t container-nginx srcs/nginx/
kubectl apply -f srcs/nginx/nginx.yaml
# A reverse proxy server is a type of proxy server that 
# typically sits behind the firewall in a private network and 
# directs client requests to the appropriate backend server.

# 307 redirect: indicating that the requested resource has been temporarily moved

# FTPS #
echo -e "CREATE FTPS IMAGE AND DEPLOYMENT"
docker build -t container-ftps srcs/ftps/
kubectl apply -f srcs/ftps/ftps.yaml

# MYSQL #
echo -e "CREATE MYSQL IMAGE AND DEPLOYMENT"
docker build -t container-mysql srcs/mysql/
kubectl apply -f srcs/mysql/mysql.yaml

# PHPMYADMIN #
echo -e "CREATE PHPMYADMIN IMAGE AND DEPLOYMENT"
docker build -t container-phpmyadmin srcs/phpmyadmin/
kubectl apply -f srcs/phpmyadmin/phpmyadmin.yaml

# WORDPRESS #
echo -e "CREATE WORDPRESS IMAGE AND DEPLOYMENT"
docker build -t container-wp srcs/wordpress/
kubectl apply -f srcs/wordpress/wordpress.yaml

# GRAFANA #
echo -e "CREATE GRAFANA IMAGE AND DEPLOYMENT"
docker build -t container-grafana srcs/grafana/
kubectl apply -f srcs/grafana/grafana.yaml

# INFLUXDB #
echo -e "CREATE INFLUXDB IMAGE AND DEPLOYMENT"
docker build -t container-influxdb srcs/influxdb/
kubectl apply -f srcs/influxdb/influxdb.yaml

# TELEGRAF #
echo -e "CREATE TELEGRAF IMAGE AND DEPLOYMENT"
docker build -t container-telegraf srcs/telegraf/
kubectl apply -f srcs/telegraf/telegraf.yaml

echo -e "IMAGE CREATION COMPLETED"
echo -e "DEPLOYMENT CREATION COMPLETED"

# GET IP #
IP=$(kubectl get node -o=custom-columns='DATA:status.addresses[0].address' | sed -n 2p)
echo -e IP:${IP}

# DASHBOARD #
echo -e "LAUNCH KUBERNETES DASHBOARD..."
minikube dashboard

# Log ins:
# wordpress		rvan-hou:ft_services
# phpmyadmin	mysql:ft_services
# FTPS			rvan-hou:ft_services
# grafana 		admin:admin


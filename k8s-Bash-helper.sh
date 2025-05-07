#!/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Main menu
main_menu() {
    clear
    echo -e "${GREEN}\nKubernetes Cheat Sheet Helper${NC}"
    echo -e "${BLUE}=============================================${NC}"
    echo -e "1.  Cluster & Node Management"
    echo -e "2.  Pod Management"
    echo -e "3.  Deployment Management"
    echo -e "4.  Services & Networking"
    echo -e "5.  Ingress & Load Balancer"
    echo -e "6.  ConfigMaps & Secrets"
    echo -e "7.  Namespace Management"
    echo -e "8.  Persistent Storage"
    echo -e "9.  StatefulSets & DaemonSets"
    echo -e "10. Events & Debugging"
    echo -e "11. RBAC & Security"
    echo -e "12. Resource Management"
    echo -e "13. Helm"
    echo -e "14. Jobs & CronJobs"
    echo -e "15. Miscellaneous"
    echo -e "0.  Exit"
    echo -e "${BLUE}=============================================${NC}"
    read -p "Choose a category (0-15): " choice

    case $choice in
        1) cluster_node_menu;;
        2) pod_menu;;
        3) deployment_menu;;
        4) service_menu;;
        5) ingress_menu;;
        6) config_secret_menu;;
        7) namespace_menu;;
        8) storage_menu;;
        9) stateful_daemon_menu;;
        10) events_menu;;
        11) rbac_menu;;
        12) resource_menu;;
        13) helm_menu;;
        14) jobs_menu;;
        15) misc_menu;;
        0) exit 0;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; main_menu;;
    esac
}

# Cluster & Node Management
cluster_node_menu() {
    clear
    echo -e "${GREEN}\nCluster & Node Management${NC}"
    echo -e "${BLUE}==========================${NC}"
    echo -e "1.  Get cluster info"
    echo -e "2.  List all nodes"
    echo -e "3.  Describe node"
    echo -e "4.  Cordon node"
    echo -e "5.  Uncordon node"
    echo -e "6.  Drain node"
    echo -e "7.  Taint node"
    echo -e "8.  Label node"
    echo -e "9.  Show node labels"
    echo -e "10. Delete node"
    echo -e "11. Show node resource usage"
    echo -e "12. Show node conditions"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}==========================${NC}"
    
    read -p "Choose option (0-12): " choice
    case $choice in
        1) kubectl cluster-info;;
        2) kubectl get nodes -o wide;;
        3) read -p "Enter node name: " node; kubectl describe node $node;;
        4) read -p "Enter node name: " node; kubectl cordon $node;;
        5) read -p "Enter node name: " node; kubectl uncordon $node;;
        6) read -p "Enter node name: " node; kubectl drain $node --ignore-daemonsets --delete-emptydir-data;;
        7) read -p "Enter node name: " node; read -p "Enter taint (key=value:NoSchedule): " taint; kubectl taint nodes $node $taint;;
        8) read -p "Enter node name: " node; read -p "Enter label (key=value): " label; kubectl label nodes $node $label;;
        9) kubectl get nodes --show-labels;;
        10) read -p "Enter node name: " node; kubectl delete node $node;;
        11) kubectl top nodes;;
        12) kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.conditions[?(@.type=="Ready")].status}{"\n"}{end}';;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; cluster_node_menu;;
    esac
    read -p "Press Enter to continue..."
    cluster_node_menu
}

# Pod Management
pod_menu() {
    clear
    echo -e "${GREEN}\nPod Management${NC}"
    echo -e "${BLUE}===============${NC}"
    echo -e "1.  List pods (current namespace)"
    echo -e "2.  List all pods (all namespaces)"
    echo -e "3.  List pods with node details"
    echo -e "4.  Describe pod"
    echo -e "5.  View pod logs"
    echo -e "6.  View container logs"
    echo -e "7.  Access pod shell"
    echo -e "8.  Delete pod"
    echo -e "9.  Force delete pod"
    echo -e "10. Get pod YAML"
    echo -e "11. Port-forward to pod"
    echo -e "12. Show pod resource usage"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}===============${NC}"
    
    read -p "Choose option (0-12): " choice
    case $choice in
        1) kubectl get pods -o wide;;
        2) kubectl get pods -A -o wide;;
        3) kubectl get pods -o wide --sort-by='.spec.nodeName';;
        4) read -p "Enter pod name: " pod; kubectl describe pod $pod;;
        5) read -p "Enter pod name: " pod; kubectl logs $pod;;
        6) read -p "Enter pod name: " pod; read -p "Enter container name: " container; kubectl logs $pod -c $container;;
        7) read -p "Enter pod name: " pod; kubectl exec -it $pod -- sh;;
        8) read -p "Enter pod name: " pod; kubectl delete pod $pod;;
        9) read -p "Enter pod name: " pod; kubectl delete pod $pod --grace-period=0 --force;;
        10) read -p "Enter pod name: " pod; kubectl get pod $pod -o yaml;;
        11) read -p "Enter pod name: " pod; read -p "Enter port: " port; kubectl port-forward $pod $port;;
        12) kubectl top pods;;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; pod_menu;;
    esac
    read -p "Press Enter to continue..."
    pod_menu
}

# Deployment Management
deployment_menu() {
    clear
    echo -e "${GREEN}\nDeployment Management${NC}"
    echo -e "${BLUE}=====================${NC}"
    echo -e "1.  List deployments"
    echo -e "2.  Describe deployment"
    echo -e "3.  Apply YAML file"
    echo -e "4.  Create deployment"
    echo -e "5.  Delete deployment"
    echo -e "6.  Check rollout status"
    echo -e "7.  View rollout history"
    echo -e "8.  Rollback deployment"
    echo -e "9.  List ReplicaSets"
    echo -e "10. Scale deployment"
    echo -e "11. Pause deployment"
    echo -e "12. Resume deployment"
    echo -e "13. Restart deployment"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}=====================${NC}"
    
    read -p "Choose option (0-13): " choice
    case $choice in
        1) kubectl get deployments;;
        2) read -p "Enter deployment name: " deploy; kubectl describe deployment $deploy;;
        3) read -p "Enter YAML file path: " file; kubectl apply -f $file;;
        4) read -p "Enter name: " name; read -p "Enter image: " image; kubectl create deployment $name --image=$image;;
        5) read -p "Enter deployment name: " deploy; kubectl delete deployment $deploy;;
        6) read -p "Enter deployment name: " deploy; kubectl rollout status deployment $deploy;;
        7) read -p "Enter deployment name: " deploy; kubectl rollout history deployment $deploy;;
        8) read -p "Enter deployment name: " deploy; read -p "Enter revision number (or leave empty for previous): " rev; 
           if [ -z "$rev" ]; then
               kubectl rollout undo deployment $deploy;
           else
               kubectl rollout undo deployment $deploy --to-revision=$rev;
           fi;;
        9) kubectl get rs;;
        10) read -p "Enter deployment name: " deploy; read -p "Enter replica count: " count; kubectl scale deployment $deploy --replicas=$count;;
        11) read -p "Enter deployment name: " deploy; kubectl rollout pause deployment $deploy;;
        12) read -p "Enter deployment name: " deploy; kubectl rollout resume deployment $deploy;;
        13) read -p "Enter deployment name: " deploy; kubectl rollout restart deployment $deploy;;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; deployment_menu;;
    esac
    read -p "Press Enter to continue..."
    deployment_menu
}

# Services & Networking
service_menu() {
    clear
    echo -e "${GREEN}\nServices & Networking${NC}"
    echo -e "${BLUE}=======================${NC}"
    echo -e "1.  List services"
    echo -e "2.  Describe service"
    echo -e "3.  Create ClusterIP service"
    echo -e "4.  Create NodePort service"
    echo -e "5.  Create LoadBalancer service"
    echo -e "6.  Delete service"
    echo -e "7.  Get service YAML"
    echo -e "8.  List endpoints"
    echo -e "9.  Port-forward service"
    echo -e "10. Expose deployment as service"
    echo -e "11. Patch service"
    echo -e "12. List network policies"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}=======================${NC}"
    
    read -p "Choose option (0-12): " choice
    case $choice in
        1) kubectl get svc;;
        2) read -p "Enter service name: " svc; kubectl describe svc $svc;;
        3) read -p "Enter service name: " svc; read -p "Enter port: " port; kubectl create service clusterip $svc --tcp=$port;;
        4) read -p "Enter service name: " svc; read -p "Enter port: " port; kubectl create service nodeport $svc --tcp=$port;;
        5) read -p "Enter service name: " svc; read -p "Enter port: " port; kubectl create service loadbalancer $svc --tcp=$port;;
        6) read -p "Enter service name: " svc; kubectl delete svc $svc;;
        7) read -p "Enter service name: " svc; kubectl get svc $svc -o yaml;;
        8) kubectl get endpoints;;
        9) read -p "Enter service name: " svc; read -p "Enter port: " port; kubectl port-forward svc/$svc $port;;
        10) read -p "Enter deployment name: " deploy; read -p "Enter port: " port; kubectl expose deployment $deploy --port=$port;;
        11) read -p "Enter service name: " svc; read -p "Enter patch (json): " patch; kubectl patch svc $svc -p "$patch";;
        12) kubectl get networkpolicies;;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; service_menu;;
    esac
    read -p "Press Enter to continue..."
    service_menu
}

# Ingress & Load Balancer
ingress_menu() {
    clear
    echo -e "${GREEN}\nIngress & Load Balancer${NC}"
    echo -e "${BLUE}=======================${NC}"
    echo -e "1.  List ingress resources"
    echo -e "2.  Describe ingress"
    echo -e "3.  Create ingress from YAML"
    echo -e "4.  Delete ingress"
    echo -e "5.  Get ingress YAML"
    echo -e "6.  View ingress classes"
    echo -e "7.  Create basic ingress"
    echo -e "8.  Create TLS ingress"
    echo -e "9.  Check ingress status"
    echo -e "10. Patch ingress"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}=======================${NC}"
    
    read -p "Choose option (0-10): " choice
    case $choice in
        1) kubectl get ingress;;
        2) read -p "Enter ingress name: " ingress; kubectl describe ingress $ingress;;
        3) read -p "Enter YAML file path: " file; kubectl apply -f $file;;
        4) read -p "Enter ingress name: " ingress; kubectl delete ingress $ingress;;
        5) read -p "Enter ingress name: " ingress; kubectl get ingress $ingress -o yaml;;
        6) kubectl get ingressclasses;;
        7) read -p "Enter ingress name: " name; 
           read -p "Enter host (e.g., example.com): " host; 
           read -p "Enter service name: " service; 
           read -p "Enter service port: " port;
           kubectl create ingress $name --rule="$host/*=$service:$port";;
        8) read -p "Enter ingress name: " name; 
           read -p "Enter host (e.g., example.com): " host; 
           read -p "Enter service name: " service; 
           read -p "Enter service port: " port;
           read -p "Enter secret name (TLS): " secret;
           kubectl create ingress $name --rule="$host/*=$service:$port" --class=nginx --tls=$host --tls-secret=$secret;;
        9) kubectl get ingress -o wide;;
        10) read -p "Enter ingress name: " ingress; read -p "Enter patch (json): " patch; kubectl patch ingress $ingress -p "$patch";;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; ingress_menu;;
    esac
    read -p "Press Enter to continue..."
    ingress_menu
}

# ConfigMaps & Secrets
config_secret_menu() {
    clear
    echo -e "${GREEN}\nConfigMaps & Secrets${NC}"
    echo -e "${BLUE}======================${NC}"
    echo -e "1.  List ConfigMaps"
    echo -e "2.  Create ConfigMap"
    echo -e "3.  Describe ConfigMap"
    echo -e "4.  Delete ConfigMap"
    echo -e "5.  List Secrets"
    echo -e "6.  Create Secret"
    echo -e "7.  Describe Secret"
    echo -e "8.  Delete Secret"
    echo -e "9.  Update ConfigMap"
    echo -e "10. Update Secret"
    echo -e "11. Create from file"
    echo -e "12. Decode Secret"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}======================${NC}"
    
    read -p "Choose option (0-12): " choice
    case $choice in
        1) kubectl get configmaps;;
        2) read -p "Enter ConfigMap name: " cm; read -p "Enter key=value pairs: " data; kubectl create configmap $cm --from-literal=$data;;
        3) read -p "Enter ConfigMap name: " cm; kubectl describe configmap $cm;;
        4) read -p "Enter ConfigMap name: " cm; kubectl delete configmap $cm;;
        5) kubectl get secrets;;
        6) read -p "Enter Secret name: " secret; read -p "Enter key=value pairs: " data; kubectl create secret generic $secret --from-literal=$data;;
        7) read -p "Enter Secret name: " secret; kubectl describe secret $secret;;
        8) read -p "Enter Secret name: " secret; kubectl delete secret $secret;;
        9) read -p "Enter ConfigMap name: " cm; read -p "Enter updated key=value: " data; kubectl create configmap $cm --from-literal=$data --dry-run=client -o yaml | kubectl apply -f -;;
        10) read -p "Enter Secret name: " secret; read -p "Enter updated key=value: " data; kubectl create secret generic $secret --from-literal=$data --dry-run=client -o yaml | kubectl apply -f -;;
        11) read -p "Create ConfigMap (1) or Secret (2): " type;
            if [ "$type" == "1" ]; then
                read -p "Enter ConfigMap name: " name;
                read -p "Enter file path: " file;
                kubectl create configmap $name --from-file=$file;
            elif [ "$type" == "2" ]; then
                read -p "Enter Secret name: " name;
                read -p "Enter file path: " file;
                kubectl create secret generic $name --from-file=$file;
            fi;;
        12) read -p "Enter Secret name: " secret; read -p "Enter key name: " key; 
            kubectl get secret $secret -o jsonpath="{.data.$key}" | base64 --decode; echo;;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; config_secret_menu;;
    esac
    read -p "Press Enter to continue..."
    config_secret_menu
}

# Namespace Management
namespace_menu() {
    clear
    echo -e "${GREEN}\nNamespace Management${NC}"
    echo -e "${BLUE}====================${NC}"
    echo -e "1.  List namespaces"
    echo -e "2.  Create namespace"
    echo -e "3.  Delete namespace"
    echo -e "4.  Set default namespace"
    echo -e "5.  Show current namespace"
    echo -e "6.  List resources in namespace"
    echo -e "7.  Switch context namespace"
    echo -e "8.  Get namespace quota"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}====================${NC}"
    
    read -p "Choose option (0-8): " choice
    case $choice in
        1) kubectl get namespaces;;
        2) read -p "Enter namespace name: " ns; kubectl create namespace $ns;;
        3) read -p "Enter namespace name: " ns; kubectl delete namespace $ns;;
        4) read -p "Enter namespace name: " ns; kubectl config set-context --current --namespace=$ns;;
        5) kubectl config view --minify | grep namespace;;
        6) read -p "Enter namespace name: " ns; kubectl get all -n $ns;;
        7) read -p "Enter namespace name: " ns; kubectl config set-context --current --namespace=$ns;;
        8) read -p "Enter namespace name: " ns; kubectl get resourcequotas -n $ns;;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; namespace_menu;;
    esac
    read -p "Press Enter to continue..."
    namespace_menu
}

# Persistent Storage
storage_menu() {
    clear
    echo -e "${GREEN}\nPersistent Storage${NC}"
    echo -e "${BLUE}==================${NC}"
    echo -e "1.  List PersistentVolumes"
    echo -e "2.  List PersistentVolumeClaims"
    echo -e "3.  Describe PersistentVolume"
    echo -e "4.  Create StorageClass"
    echo -e "5.  List StorageClasses"
    echo -e "6.  Delete PersistentVolume"
    echo -e "7.  Delete PersistentVolumeClaim"
    echo -e "8.  Create PVC from YAML"
    echo -e "9.  Bind PVC to Pod"
    echo -e "10. Expand PVC"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}==================${NC}"
    
    read -p "Choose option (0-10): " choice
    case $choice in
        1) kubectl get pv;;
        2) kubectl get pvc -A;;
        3) read -p "Enter PV name: " pv; kubectl describe pv $pv;;
        4) read -p "Enter YAML file path: " file; kubectl apply -f $file;;
        5) kubectl get storageclasses;;
        6) read -p "Enter PV name: " pv; kubectl delete pv $pv;;
        7) read -p "Enter PVC name: " pvc; kubectl delete pvc $pvc;;
        8) read -p "Enter YAML file path: " file; kubectl apply -f $file;;
        9) read -p "Enter Pod name: " pod; read -p "Enter PVC name: " pvc; kubectl edit pod $pod;;
        10) read -p "Enter PVC name: " pvc; kubectl patch pvc $pvc -p '{"spec": {"resources": {"requests": {"storage": "10Gi"}}}}';;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; storage_menu;;
    esac
    read -p "Press Enter to continue..."
    storage_menu
}

# StatefulSets & DaemonSets
stateful_daemon_menu() {
    clear
    echo -e "${GREEN}\nStatefulSets & DaemonSets${NC}"
    echo -e "${BLUE}==========================${NC}"
    echo -e "1.  List StatefulSets"
    echo -e "2.  List DaemonSets"
    echo -e "3.  Describe StatefulSet"
    echo -e "4.  Describe DaemonSet"
    echo -e "5.  Delete StatefulSet"
    echo -e "6.  Delete DaemonSet"
    echo -e "7.  Scale StatefulSet"
    echo -e "8.  Update DaemonSet"
    echo -e "9.  Rolling restart StatefulSet"
    echo -e "10. Get StatefulSet YAML"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}==========================${NC}"
    
    read -p "Choose option (0-10): " choice
    case $choice in
        1) kubectl get statefulsets;;
        2) kubectl get daemonsets;;
        3) read -p "Enter StatefulSet name: " ss; kubectl describe statefulset $ss;;
        4) read -p "Enter DaemonSet name: " ds; kubectl describe daemonset $ds;;
        5) read -p "Enter StatefulSet name: " ss; kubectl delete statefulset $ss;;
        6) read -p "Enter DaemonSet name: " ds; kubectl delete daemonset $ds;;
        7) read -p "Enter StatefulSet name: " ss; read -p "Enter replica count: " count; kubectl scale statefulset $ss --replicas=$count;;
        8) read -p "Enter YAML file path: " file; kubectl apply -f $file;;
        9) read -p "Enter StatefulSet name: " ss; kubectl rollout restart statefulset $ss;;
        10) read -p "Enter StatefulSet name: " ss; kubectl get statefulset $ss -o yaml;;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; stateful_daemon_menu;;
    esac
    read -p "Press Enter to continue..."
    stateful_daemon_menu
}

# Events & Debugging
events_menu() {
    clear
    echo -e "${GREEN}\nEvents & Debugging${NC}"
    echo -e "${BLUE}====================${NC}"
    echo -e "1.  View cluster events"
    echo -e "2.  View pod events"
    echo -e "3.  Check component status"
    echo -e "4.  Top nodes"
    echo -e "5.  Top pods"
    echo -e "6.  Check API versions"
    echo -e "7.  Run busybox debug pod"
    echo -e "8.  Check pod status"
    echo -e "9.  Check pod errors"
    echo -e "10. Network diagnostics"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}====================${NC}"
    
    read -p "Choose option (0-10): " choice
    case $choice in
        1) kubectl get events --sort-by='.metadata.creationTimestamp';;
        2) read -p "Enter pod name: " pod; kubectl describe pod $pod | grep -A 10 Events;;
        3) kubectl get componentstatuses;;
        4) kubectl top nodes;;
        5) kubectl top pods;;
        6) kubectl api-versions;;
        7) kubectl run debug-pod --image=busybox --restart=Never --rm -it -- sh;;
        8) kubectl get pods --field-selector=status.phase!=Running -A;;
        9) kubectl get pods -A | grep -Ev 'Running|Completed';;
        10) kubectl run network-check --image=nicolaka/netshoot --rm -it --restart=Never -- bash;;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; events_menu;;
    esac
    read -p "Press Enter to continue..."
    events_menu
}

# RBAC & Security
rbac_menu() {
    clear
    echo -e "${GREEN}\nRBAC & Security${NC}"
    echo -e "${BLUE}================${NC}"
    echo -e "1.  List ServiceAccounts"
    echo -e "2.  List Roles"
    echo -e "3.  List RoleBindings"
    echo -e "4.  List ClusterRoles"
    echo -e "5.  List ClusterRoleBindings"
    echo -e "6.  Create ServiceAccount"
    echo -e "7.  Create Role"
    echo -e "8.  Create RoleBinding"
    echo -e "9.  Check permissions"
    echo -e "10. Get RBAC details"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}================${NC}"
    
    read -p "Choose option (0-10): " choice
    case $choice in
        1) kubectl get serviceaccounts;;
        2) kubectl get roles;;
        3) kubectl get rolebindings;;
        4) kubectl get clusterroles;;
        5) kubectl get clusterrolebindings;;
        6) read -p "Enter ServiceAccount name: " sa; kubectl create serviceaccount $sa;;
        7) read -p "Enter YAML file path: " file; kubectl apply -f $file;;
        8) read -p "Enter YAML file path: " file; kubectl apply -f $file;;
        9) read -p "Enter ServiceAccount name: " sa; kubectl auth can-i --as=system:serviceaccount:$(kubectl get serviceaccount $sa -o jsonpath='{.metadata.namespace}'):$sa --list;;
        10) kubectl get roles,rolebindings,clusterroles,clusterrolebindings;;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; rbac_menu;;
    esac
    read -p "Press Enter to continue..."
    rbac_menu
}

# Resource Management
resource_menu() {
    clear
    echo -e "${GREEN}\nResource Management${NC}"
    echo -e "${BLUE}==================${NC}"
    echo -e "1.  View resource quotas"
    echo -e "2.  View limit ranges"
    echo -e "3.  Set resource limits (pod)"
    echo -e "4.  Set resource requests (pod)"
    echo -e "5.  View node resource usage"
    echo -e "6.  View pod resource usage"
    echo -e "7.  Set pod QoS class"
    echo -e "8.  Check resource allocation"
    echo -e "9.  Set namespace quota"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}==================${NC}"
    
    read -p "Choose option (0-9): " choice
    case $choice in
        1) kubectl get resourcequotas;;
        2) kubectl get limitranges;;
        3) read -p "Enter pod name: " pod; read -p "Enter limits (cpu=500m,memory=1Gi): " limits; kubectl set resources pod $pod --limits=$limits;;
        4) read -p "Enter pod name: " pod; read -p "Enter requests (cpu=200m,memory=512Mi): " req; kubectl set resources pod $pod --requests=$req;;
        5) kubectl top nodes;;
        6) kubectl top pods;;
        7) read -p "Enter pod name: " pod; read -p "Enter QoS class (Guaranteed/Burstable): " qos; 
           if [ "$qos" == "Guaranteed" ]; then
               kubectl set resources pod $pod --limits=cpu=500m,memory=1Gi --requests=cpu=500m,memory=1Gi;
           elif [ "$qos" == "Burstable" ]; then
               kubectl set resources pod $pod --limits=cpu=1,memory=2Gi --requests=cpu=500m,memory=1Gi;
           fi;;
        8) kubectl describe nodes | grep -A 5 "Allocated resources";;
        9) read -p "Enter namespace: " ns; read -p "Enter quota name: " quota; kubectl create quota $quota --hard=cpu=2,memory=4Gi,pods=10 -n $ns;;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; resource_menu;;
    esac
    read -p "Press Enter to continue..."
    resource_menu
}

# Helm
helm_menu() {
    clear
    echo -e "${GREEN}\nHelm Package Manager${NC}"
    echo -e "${BLUE}====================${NC}"
    echo -e "1.  List releases"
    echo -e "2.  Install chart"
    echo -e "3.  Upgrade release"
    echo -e "4.  Rollback release"
    echo -e "5.  Uninstall release"
    echo -e "6.  List repositories"
    echo -e "7.  Add repository"
    echo -e "8.  Update repositories"
    echo -e "9.  Search charts"
    echo -e "10. Show release values"
    echo -e "11. Show release history"
    echo -e "12. Show release status"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}====================${NC}"
    
    read -p "Choose option (0-12): " choice
    case $choice in
        1) helm list -A;;
        2) read -p "Enter release name: " release; read -p "Enter chart name: " chart; helm install $release $chart;;
        3) read -p "Enter release name: " release; helm upgrade $release;;
        4) read -p "Enter release name: " release; helm rollback $release;;
        5) read -p "Enter release name: " release; helm uninstall $release;;
        6) helm repo list;;
        7) read -p "Enter repo name: " repo; read -p "Enter repo URL: " url; helm repo add $repo $url;;
        8) helm repo update;;
        9) read -p "Enter search term: " term; helm search hub $term;;
        10) read -p "Enter release name: " release; helm get values $release;;
        11) read -p "Enter release name: " release; helm history $release;;
        12) read -p "Enter release name: " release; helm status $release;;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; helm_menu;;
    esac
    read -p "Press Enter to continue..."
    helm_menu
}

# Jobs & CronJobs
jobs_menu() {
    clear
    echo -e "${GREEN}\nJobs & CronJobs${NC}"
    echo -e "${BLUE}================${NC}"
    echo -e "1.  List jobs"
    echo -e "2.  List cronjobs"
    echo -e "3.  Describe job"
    echo -e "4.  Describe cronjob"
    echo -e "5.  Delete job"
    echo -e "6.  Delete cronjob"
    echo -e "7.  Create job from YAML"
    echo -e "8.  Create cronjob from YAML"
    echo -e "9.  Suspend cronjob"
    echo -e "10. Resume cronjob"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}================${NC}"
    
    read -p "Choose option (0-10): " choice
    case $choice in
        1) kubectl get jobs -A;;
        2) kubectl get cronjobs -A;;
        3) read -p "Enter job name: " job; kubectl describe job $job;;
        4) read -p "Enter cronjob name: " cj; kubectl describe cronjob $cj;;
        5) read -p "Enter job name: " job; kubectl delete job $job;;
        6) read -p "Enter cronjob name: " cj; kubectl delete cronjob $cj;;
        7) read -p "Enter YAML file path: " file; kubectl apply -f $file;;
        8) read -p "Enter YAML file path: " file; kubectl apply -f $file;;
        9) read -p "Enter cronjob name: " cj; kubectl patch cronjob $cj -p '{"spec" : {"suspend" : true}}';;
        10) read -p "Enter cronjob name: " cj; kubectl patch cronjob $cj -p '{"spec" : {"suspend" : false}}';;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; jobs_menu;;
    esac
    read -p "Press Enter to continue..."
    jobs_menu
}

# Miscellaneous
misc_menu() {
    clear
    echo -e "${GREEN}\nMiscellaneous${NC}"
    echo -e "${BLUE}==============${NC}"
    echo -e "1.  Check Kubernetes version"
    echo -e "2.  Check kubectl version"
    echo -e "3.  View API resources"
    echo -e "4.  Explain resource"
    echo -e "5.  View kubeconfig"
    echo -e "6.  View cluster info"
    echo -e "7.  Get kubeconfig"
    echo -e "8.  Check current context"
    echo -e "9.  List contexts"
    echo -e "10. Switch context"
    echo -e "11. Check API health"
    echo -e "12. Check etcd health"
    echo -e "13. Check scheduler health"
    echo -e "14. Check controller health"
    echo -e "0.  Back to Main Menu"
    echo -e "${BLUE}==============${NC}"
    
    read -p "Choose option (0-14): " choice
    case $choice in
        1) kubectl version --short;;
        2) kubectl version --client --short;;
        3) kubectl api-resources;;
        4) read -p "Enter resource type: " res; kubectl explain $res;;
        5) kubectl config view;;
        6) kubectl cluster-info;;
        7) kubectl config view --minify --raw;;
        8) kubectl config current-context;;
        9) kubectl config get-contexts;;
        10) read -p "Enter context name: " ctx; kubectl config use-context $ctx;;
        11) kubectl get --raw='/readyz?verbose';;
        12) kubectl get --raw='/healthz/etcd';;
        13) kubectl get --raw='/healthz/scheduler';;
        14) kubectl get --raw='/healthz/controller-manager';;
        0) main_menu;;
        *) echo -e "${RED}Invalid option!${NC}"; sleep 1; misc_menu;;
    esac
    read -p "Press Enter to continue..."
    misc_menu
}

# Start the main menu
main_menu

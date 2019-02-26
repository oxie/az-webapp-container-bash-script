
#!/bin/bash

app_Name=
resource_Group=
appName_Plan=
container_Image=
subscription_Plan="S1"
app_Location="WEST EUROPE" # BY DEFAULT OPTION
certificate_File=
certificate_Password=
domain_Name=
domain_Area=

while getopts "n:l:s:c:d:f:p:-" opt; do
  case $opt in
    n) # APP NAME
                if [[ -z $OPTARG || $OPTARG == -*  ]];
                then
                  echo 'App name is Undefined! Please provide an application name.'
                  exit 1
                fi
                app_Name=${OPTARG}
                resource_Group=$app_Name-rg
                appName_Plan=$app_Name-plan
                ;;
    l) # LOCATION
                if [[ -z $OPTARG || $OPTARG == -*  ]];
                then
                  echo 'Location is Undefined! Using Default location $app_Location'
                  
                fi
                app_Location=${OPTARG}
                ;;
    s) # Subscription Plan
                if [[ -z $OPTARG || $OPTARG == -*  ]];
                then
                  echo 'Subscription Type is Undefined! Using Default subscription $subscription_Plan'
                fi
                subscription_Plan="${OPTARG}"
                ;;
    c) # Container Image
                if [[ -z $OPTARG || $OPTARG == -*  ]];
                then
                  echo 'Container Image is Undefined! Please Define Container-Image'
                fi
                container_Image="${OPTARG}"
                ;;
    d) # Domain Name / Hostname / FQDN
                if [[ -z $OPTARG || $OPTARG == -*  ]];
                then
                  echo 'Domain Name is Undefined! Please Define Domain Name / FQDN - something.domain.com or domain.com'
                fi
                domain_Name="${OPTARG}"
                ;;
    f) # SSL CERTIFICATE  FILE
                if [[ -z $OPTARG || $OPTARG == -*  ]];
                then
                  echo 'Certficate File is Not Found! Please point to Certificate file location.'
                fi              
                certificate_File=$OPTARG
                ;;
    p) # SSL CERTIFICATE PASSWORD
                if [[ -z $OPTARG || $OPTARG == -*  ]];
                then
                  echo 'Certficate Password is Not Found! Please provide Certificate Password.'
                fi              
                certificate_Password=$OPTARG
                ;;
    \?)
      echo "Option Provisioned is not Recognized !"
      exit 1
    ;;
  esac
done
shift "$((OPTIND - 1))"

if [ -z $app_Name ]; 
then
        echo 'One or more variables are Undefined! You must pass Application Name and Container Image as a Minimum '
        exit 1
else
        az group create --name $resource_Group --location "$app_Location"
        echo $'\n'

            if [[ -z $appName_Plan || -z $resource_Group || -z $subscription_Plan ]]; 
            then
                echo 'One or more variables are Undefined! Required $AppName_Plan , $resource_Group , $subscription_Plan'
                exit 1
            else
            az appservice plan create --name $appName_Plan --resource-group $resource_Group --sku $subscription_Plan --is-linux
            echo $'\n'
            fi

            if [[ -z $appName_Plan || -z $resource_Group || -z $app_Name || -z $container_Image ]]; 
            then
                echo 'You must pass Container Image. Example: -c dockerhub/imagefile:tag'
                exit 1
            else
            az webapp create --resource-group $resource_Group --plan $appName_Plan --name $app_Name --deployment-container-image-name $container_Image
            echo $'\n'
            fi

            if [ -z $domain_Name ]; 
            then
                  echo $'\n'
                  echo "Hostname Option Not Found! If you want to setup domain name, provide FQDN to service. Example -d test.website.com or -d website.com"
                  echo $'\n'
                  echo "You can browse your app now at https://'${app_Name}'.azurewebsites.net"
                  exit 1            
            else
                  domain_Options=$(echo $domain_Name | sed -e "s/[^/]*\/\/\([^@]*@\)\?\([^:/]*\).*/\2/" | awk -F. '{print $(NF-1) "." $NF}' )
                  source  cloud.vars;
                  
                  case "$domain_Options" in
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                      your-websitedomain.com ) domain_Area=${token-variable-for-your-websitedomain.com} ;;
                  esac

                  curl -X POST "https://api.cloudflare.com/client/v4/zones/${domain_Area}/dns_records" \
                  -H "X-Auth-Email: $cloudflare_User" \
                  -H "X-Auth-Key: $cloudflare_Auth" \
                  -H "Content-Type: application/json" \
                  --data '{"type":"CNAME","name":"'${domain_Name}'","content":"'${app_Name}'.azurewebsites.net","ttl":120}'

                  az webapp config hostname add --webapp-name $app_Name --resource-group $resource_Group --hostname $domain_Name
                  echo $'\n'
            fi

            if [[ -n $certificate_File || -n $certificate_Password ]]; 
            then
                  if [ -e $certificate_File ]
                  then  
                        if hash az 2>/dev/null;
                        then
                              thumbprint=$(az webapp config ssl upload --name $app_Name --resource-group $resource_Group --certificate-file $certificate_File --certificate-password $certificate_Password --query thumbprint --output tsv)
                              echo "$thumbprint"
                              echo $'\n'
                              az webapp config ssl bind --name $app_Name --resource-group $resource_Group --certificate-thumbprint $thumbprint --ssl-type SNI
                        else
                              echo $'\n'
                              echo "WARNING"
                              echo "Azure cli-v2 was Not Found! Please install Azure CLI v2 Before trying again."
                              echo "Check this link - https://gig-gaming.atlassian.net/wiki/spaces/SO/pages/128778241/How+to+get+dynamic+inventory+working"
                              echo $'\n'
                        fi
                  else
                        echo $'\n'
                        echo "Certificate File was Not Found. Please try again. Check this link - https://gig-gaming.atlassian.net/wiki/spaces/SO/pages/134938625?atlOrigin=eyJpIjoiMzU3ODNjNDEwOWFiNGI2MTgyNDY2ZTBiNTFiYjZjNDIiLCJwIjoiYyJ9" 
                        exit 1
                  fi
            fi
fi

echo $'\n'
echo "If you want to delete this application you can write '\n' az group delete --name $resource_Group"
 




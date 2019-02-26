# Azure Web App for Containers Automation Script

#
#
#
#### Included Files
  - az-web-app-container.sh  ## automation script
  - .cloud.vars  ## variables for cloudflare domain management # used with domain options only

### Minimal Example - Create an app without specifing domain or ssl
`bash az-web-app-container.sh -n <you-app-name> -c <image/name:tag>`

##### This command will execute the following az commands:

- `az group create --name <your-app-name>-rg --location "$app_Location"`  ## Default location = "West Europe"
######
- `az appservice plan create --name <your-app-name>_Plan --resource-group <your-app-name>-rg --sku <subscription-plan> --is-linux` ## Default subscription plan is S1
######
- `az webapp create --resource-group <your-app-name>-rg --plan <your-app-name>_Plan --name <your-app-name> --deployment-container-image-name <image/name:tag>` 
#
#
#

### Advanced Example - Create an app with specifing SKU, Location
`bash az-web-app-container.sh -n <you-app-name> -c <image/name:tag> -l "East India" -s S2 `

##### This command will execute the following az commands:

- `az group create --name <your-app-name>-rg --location "East India"`
######
- `az appservice plan create --name <your-app-name>_Plan --resource-group <your-app-name>-rg --sku S2 --is-linux`
######
- `az webapp create --resource-group <your-app-name>-rg --plan <your-app-name>_Plan --name <your-app-name> --deployment-container-image-name <image/name:tag>` 
#
#
#

### Complete Example - Create an app with specifing:
- ##### SKU
- ##### Location
- ##### domain-name
- ##### certificate-file
- ##### certificate-password
#
#
`bash az-web-app-container.sh -n <your-app-name> -c <image/name:tag> -l "<location>" -s <SKU> -d <fqdn> -f <certificate-file.location-path> -p <password for certificate>`

##### This command will execute the following az commands:
#
- `az group create --name <your-app-name>-rg --location "<location>"`
######
- `az appservice plan create --name <your-app-name>_Plan --resource-group <your-app-name>-rg --sku <SKU> --is-linux`
######
- `az webapp create --resource-group <your-app-name>-rg --plan <your-app-name>_Plan --name <your-app-name> --deployment-container-image-name <image/name:tag>` 
######
- `az webapp config hostname add --webapp-name <your-app-name> --resource-group <your-app-name>-rg --hostname <fqdn>`
######
- `az webapp config ssl bind --name <your-app-name> --resource-group <your-app-name>-rg --certificate-thumbprint <az-var-cmd-to-upload-ssl-file> --ssl-type SNI`
#
#
#
### Example - Working App.
#
`bash az-web-app-container.sh -n test-app-rolla -c oxgroth/dcos-prometheus -d test-app.rolla.com -f ./rolla.pfx -p quickshare9 -l "West Europe" -s S1 `






#
#
#

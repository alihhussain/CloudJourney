# Troubleshooting

Step 1 Figure out if backend is working

## AppService Backend
Go to the URL of the App Service

```https://licenserenewal2443.azurewebsites.net/```



## Virtual Machine Backend Troubleshooting
Go to the URL of the VMs

```http://vehicleapp30640.westus.cloudapp.azure.com/```

1. Download the ```~/.ssh/id_rsa``` file from cloudshell
2. Deploy bastion to log into ```webServer1```
3. Log into ```webServer1```
4. Confirm if the web application is running by running this command
    ```
    sudo apt install net-tools
    sudo netstat -plnt
    ```

5. Confirm nothing is running on port 80
6. Create an NSG and allow port 80 on the VM and attach it to 

This means the website was never configured on this VM.
We need to configure the VM and setup the webserver

# Setup Flask Application

1. While logged into ```webServer1``` run the following commands:
    ```
    #Log into sudo and install python
    sudo su -
    apt update
    apt install python3-pip
    pip3 install Flask
    
    # Get the website file
    wget https://raw.githubusercontent.com/alihhussain/CloudJourney/main/CloudJourneyLabs/AppGWLab/webserver.py
    
    #Run the command to start the website
    nohup python3 webserver.py & 

    # Check to see if the website is running fine
    ps -aux
    netstat -plnt 
    ```
    
## Lets see if the website works from the Application Gateway
Navigate to the main website using your application gateway public IP address

```http://vehicleapp30640.westus.cloudapp.azure.com/```

Next go to the LicenseRenewal page ``` http://vehicleapp30640.westus.cloudapp.azure.com/LicenseRenewal/```


## Review lab again

https://learn.microsoft.com/en-us/training/modules/load-balance-web-traffic-with-application-gateway/6-exercise-test-application-gateway



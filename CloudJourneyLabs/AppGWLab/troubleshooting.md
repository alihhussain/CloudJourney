# Troubleshooting

Step 1 Figure out if backend is working

## AppService Backend
Go to the URL of the App Service

```https://licenserenewal2443.azurewebsites.net/```

## Backend Troubleshooting

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
    sudo su -
    apt update
    apt install python3-pip
    pip3 install Flask
    vim webserver.py
    ``` 
    Once the VIM application opens type in ```:set paste```
    Copy paste the following file in

    ```
    from flask import Flask, render_template
    import socket

    app = Flask(__name__)

    @app.route('/')
    def index():
        # Get the hostname
        hostname = socket.gethostname()
        
        # Get the private IP address
        private_ip = socket.gethostbyname(hostname)
        
        return f'''
        <html>
            <head>
                <title>VM Information</title>
            </head>
            <body>
                <h1>VM Information</h1>
                <p><strong>Hostname:</strong> {hostname}</p>
                <p><strong>Private IP Address:</strong> {private_ip}</p>
            </body>
        </html>
        '''

    if __name__ == '__main__':
        app.run(host='0.0.0.0', port=80)
    
    ```

    Next run the following commands:
    ```
    nohup python3 webserver.py & 
    ```

    Confirm the application is running
    ```
    ps -aux
    netstat -plnt
    ```

    You can see it is working now!
    ```
    root@webServer2:~# netstat -plnt
    Active Internet connections (only servers)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
    tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      491/systemd-resolve 
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1541/sshd: /usr/sbi 
    tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      102179/python3      
    tcp6       0      0 :::22                   :::*                    LISTEN      1541/sshd: /usr/sbi 
    ```

## Lets see if the website works from the Application Gateway
Navigate to the main website using your application gateway public IP address

```http://vehicleapp30640.westus.cloudapp.azure.com/```

Next go to the LicenseRenewal page ``` http://vehicleapp30640.westus.cloudapp.azure.com/LicenseRenewal/```


## Review lab again

https://learn.microsoft.com/en-us/training/modules/load-balance-web-traffic-with-application-gateway/6-exercise-test-application-gateway



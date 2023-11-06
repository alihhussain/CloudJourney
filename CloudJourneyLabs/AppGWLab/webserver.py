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

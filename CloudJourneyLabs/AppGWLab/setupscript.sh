apt update
apt install python3-pip
pip3 install Flask
apt install net-tools

# Get the website file
wget https://raw.githubusercontent.com/alihhussain/CloudJourney/main/CloudJourneyLabs/AppGWLab/webserver.py    
wget https://raw.githubusercontent.com/alihhussain/CloudJourney/main/CloudJourneyLabs/AppGWLab/setupscript.sh

#Start the webserver
nohup python3 webserver.py & 
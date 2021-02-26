WebsiteName="name" # used only for the website folder name in /var/www and as the name of the apache config file (doesn't affect functionality)
DomainName="mysite.example.com" # Fully Qualified Domain Name
HostName="mysite" # name of the server
PublicIP="3.3.3.3"

LimitRequestBody=512000 # max request size in bytes
Processes=2
Threads=5

# AppFactoryScript is the script that contains the create_app() method that returns Flask App object
PathToApp="/home/user/src/" # the directory that contains the AppFactoryScript
AppFactoryScriptName="init.py" # Name of the AppFactoryScript file

# without trailing slash !!!
# write it like this /home/user/static not like /home/user/static/
StaticDirPath="some path"

RobotsFilePath=""
FaviconPath=""


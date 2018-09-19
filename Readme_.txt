sudo apt-get install --yes build-essential
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get update
sudo apt-get install -y mongodb
sudo apt-get update
sudo apt-get install -y git
sudo apt-get update
sudo apt-get install -y nginx
sudo apt-get update
sudo npm install -g @angular/cli
sudo apt-get update
sudo npm install -g express

ssh-keyscan github.com >> ~/.ssh/known_hosts

//git personal access token: d2f98e0a9e9f513b751ccf955d5791c992236b2b
//https://stackoverflow.com/questions/10054318/how-to-provide-username-and-password-when-run-git-clone-gitremote-git

git clone https://d2f98e0a9e9f513b751ccf955d5791c992236b2b@github.com/emcconsulting/AzureStackDemo.git AzureStackDemo

curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft.list
apt-get update
apt-get install -y powershell

After installation, you can run the powershell, by just issuing this command “pwsh” in the prompt:

# notes
https://www.udemy.com/the-complete-nodejs-developer-course-2/learn/v4/t/lecture/5525312?start=0
or
https://app.pluralsight.com/player?course=node-js-express-rest-web-services&author=jonathan-mills&name=node-js-express-rest-web-services-m1&clip=4
https://app.pluralsight.com/player?course=implementing-virtual-machines-azure-infrastructure-70-533&author=tim-warner&name=implementing-virtual-machines-azure-infrastructure-70-533-m3&clip=6&mode=live
https://app.pluralsight.com/library/courses/practical-desired-state-configuration/table-of-contents

sample-mean-app-rg 
sample-mean-app-vm

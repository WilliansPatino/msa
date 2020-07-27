sudo apt update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt update

echo "apt-cache madison docker-ce"

echo "sudo apt-get install docker-ce=<VERSION_STRING> docker-ce-cli=<VERSION_STRING> containerd.io"

# # sudo apt-get install docker-ce docker-ce-cli containerd.io

# echo "sudo usermod -aG docker wp"

# sudo systemctl status docker

# # docker info
# # docker run hello-world
# # docker images

sudo apt install -y \
		git \
    nano \
		curl \
		wget \
    xclip \
		zsh \
		fonts-powerline \
		vlc \
		clementine \
		gdebi \
		youtube-dl \
		snapd

git config --global user.email "dushyant.khosla@yahoo.com"
git config --global user.name "Dushyant Khosla"


# https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh
# generate SSH keys
ssh-keygen -t rsa -b 4096 -C "dushyant.khosla@yahoo.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa

# paste on github.com settings
cat ~/.ssh/id_rsa.pub | xclip

# verify 
ssh -T git@github.com

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
p10k configure

nano .zshrc
# plugins=(
#     git
#     zsh-syntax-highlighting
#     zsh-autosuggestions
#     zsh-completions
# )
source .zshrc

sudo snap install \
	snap-store \
	adguard-home \
	postman \
	foliate
sudo snap install atom --classic

curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/Downloads/miniconda3.sh
bash ~/Downloads/miniconda3.sh
rm Miniconda3-latest-Linux-x86_64.sh

conda install -y -c conda-forge nodejs
npm install -g tldr

alias xclip="xclip -selection c"

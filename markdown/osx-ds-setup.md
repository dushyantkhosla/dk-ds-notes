# Setting Up a Macbook for Data Science

---

## 

```bash
# XCode
xcode-select --install

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://goo.gl/uP5ePv)"

# Cask
brew install cask

# iTerm2
brew cask install --appdir="~/Applications" iterm2

# Fish
brew install fish
sudo echo '/usr/local/bin/fish' > /etc/shells
chsh -s /usr/local/bin/fish

# omf
curl -L https://goo.gl/NaADWG | fish
omf install sublime osx bobthefish ssh-config.d

# 'Hack' font for non-ASCII text
brew tap caskroom/fonts
brew cask install font-hack 
# Manually set this in Preferences

# Runtimes, Server etc.
brew cask install --appdir="~/Applications" java xquartz remote-desktop-manager gpgtools

# Dev Tools
brew cask install --appdir="/Applications" sublime-text slack intellij-idea-ce pycharm-ce Docker

# R
brew tap homebrew/science
brew install r
brew cask install --appdir="/Applications" rstudio

# Scala
brew install scala
brew install sbt
echo '-J-XX:+CMSClassUnloadingEnabled' >> /usr/local/etc/sbtopts
echo '-J-Xmx2G' >> /usr/local/etc/sbtopts

# Python via Miniconda
curl -O http://bit.ly/2wWZ1Xu
bash Miniconda2-latest-MacOSX-x86_64.sh
set -U fish_user_paths /Users/$USER/miniconda2/bin/ $fish_user_paths
rm Miniconda2-latest-MacOSX-x86_64.sh

# Coreutils
brew install coreutils

# Git Configuration
git config --global user.name "your-name"
git config --global user.email "your-email"

# SSH Keys
ssh-keygen -t rsa -b 4096 -C "your-email"
chmod 600 ~/.ssh/id_rsa*

# Cookiecutter
pip install cookiecutter

# Spark
brew install dtrx
curl -O https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
dtrx spark-2.2.0-bin-hadoop2.7.tgz
mv spark-2.2.0-bin-hadoop2.7 /Users/$USER/spark
rm spark-2.2.0-bin-hadoop2.7.tgz

# Add executables to PATH
set -U fish_user_paths /Users/$USER/spark $fish_user_paths

# Add these lines to ~/.config/fish/config.fish
set -x SPARK_HOME /Users/$USER/spark
set -x PATH $PATH $SPARK_HOME/bin/
set -x PYSPARK_DRIVER_PYTHON jupyter
set -x PYSPARK_DRIVER_PYTHON_OPTS 'notebook --ip=0.0.0.0 --port=8888 --no-browser'

# Run `pyspark`, it will open in a Jupyter notebook
pyspark

```



## `fish` and `conda`

```Bash
conda create -n my-env pandas scikit-learn jupyter
source activate my-env

# If `source activate my-env` doesn't work,
# add this line
source (conda info --root)/etc/fish/conf.d/conda.fish
# to 
~/.config/fish/config.fish
# Then, run
conda activate root
conda activate my-env
```


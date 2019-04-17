#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/.dotfiles                    # dotfiles directory
olddir=~/.dotfiles_old             # old dotfiles backup directory
#files="bashrc vimrc vim zshrc oh-my-zsh config tmux.conf vimrc"    # list of files/folders to symlink in homedir
files="bashrc zshrc Xdefaults vim vimrc config tmux.conf"    # list of files/folders to symlink in homedir


##########

echo -n "Installing required packages ..."
sudo apt-get -y install curl zsh vim git i3 feh tmux rxvt-unicode-256color compton preload
#sudo apt-get install redshift-gtk xbacklight volumeicon-alsa
#echo -n "Installing oh-my-zsh"
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# clone
#git clone https://github.com/powerline/fonts.git --depth=1
# install
#cd fonts
#./install.sh
# clean-up a bit
#cd ..
#rm -rf fonts

## Install VS Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install apt-transport-https
sudo apt-get update
sudo apt-get install code

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir/
    echo "Creating symlink to $file in home directory."
    ln -s -n $dir/$file ~/.$file
done

install_zsh () {
if [[ ! -d ~/.oh-my-zsh/ ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
    chsh -s $(which zsh)
fi
}

install_zsh_old () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone http://github.com/robbyrussell/oh-my-zsh.git
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        if [[ -f /etc/redhat-release ]]; then
            sudo yum install zsh
            install_zsh
        fi
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get install zsh
            install_zsh
        fi
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_repo () {
if [[ ! -d /home/$USER/.bin/ ]]; then
    echo "Creating /home/$USER/.bin folder"
    mkdir -p /home/$USER/.bin
fi

if [[ ! -f /home/$USER/.bin/repo ]]; then
    echo "Installing repo"
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
    chmod a+x ~/.bin/repo
fi
}

copy_configs () {
    cp -ri ~/.dotfiles/configurations/Code -t ~/.config
    cp -ri ~/.dotfiles/configurations/i3 -t ~/.config
}


#install_zsh
#install_repo
#copy_configs

#sudo apt-get -y upgrade
#sudo apt-get -y dist-upgrade
#sudo apt-get -y clean
#sudo apt-get -y autoclean
#sudo apt-get -y autoremove

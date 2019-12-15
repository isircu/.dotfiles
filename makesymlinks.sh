#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/.dotfiles                    # dotfiles directory
olddir=~/.dotfiles_old             # old dotfiles backup directory
#files="bashrc vimrc vim zshrc oh-my-zsh config tmux.conf vimrc"    # list of files/folders to symlink in homedir
files="bashrc zshrc Xdefaults oh-my-zsh vim vimrc config tmux.conf"    # list of files/folders to symlink in homedir

_now=$(date +"%d_%m_%Y")
_logfile="$_now.log"
# mysqldump -u admin -p'myPasswordHere' myDbNameHere > "$_file"
##########

install_repo () {
if [[ ! -d /home/$USER/.bin/ ]]; then
    echo "Creating /home/$USER/.bin folder" >> $_logfile
    mkdir -p /home/$USER/.bin
fi

if [[ ! -f /home/$USER/.bin/repo ]]; then
    echo "Installing repo" >> $_logfile
    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/.bin/repo
    chmod a+x ~/.bin/repo
fi
}

copy_configs () {
    cp -ri ~/.dotfiles/configurations/Code -t ~/.config
    cp -ri ~/.dotfiles/configurations/i3 -t ~/.config
}

install_zsh() {
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
            sudo apt-get -y install zsh
            install_zsh
        fi
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "E: Please install zsh, then re-run this script!" >> $_logfile
        exit
    fi
fi
}

install_vscode() {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/code -o -f /usr/bin/code ]; then
    echo "Code installed" >> $_logfile
else
    echo "Installing VS Code" >> $_logfile
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get -y install apt-transport-https
    sudo apt-get update
    sudo apt-get -y install code
fi
}

install_fonts() {
# Test to see if zshell is installed.  If it is:
if [ -f $HOME/.local/share/fonts/Hack-Regular.ttf ]; then
    echo "Fonts installed" >> $_logfile
else
    echo "Installing fonts" >> $_logfile
    # clone
    git clone https://github.com/powerline/fonts.git --depth=1
    # install
    cd fonts
    ./install.sh
    # clean-up a bit
    cd ..
    rm -rf fonts
fi
}

install_arduino() {
# Test to see if zshell is installed.  If it is:
if [ -f /usr/local/bin/arduino ]; then
    echo "Arduino installed" >> $_logfile
else

    if [ -f ./arduino-*linux64.tar.xz ]; then
        echo "Installing Arduino" >> $_logfile
        sudo apt-get -y install gcc gcc-avr avrdude avr-libc default-jre libjna-java librxtx-java
        tar -xf arduino-*linux64.tar.xz
        rm -rf arduino-*linux64.tar.xz
        sudo mv arduino-*/ /opt/
        pushd /opt/arduino*/
        sudo ./install.sh

        sudo usermod -a -G dialout $USER

        #sudo chmod a+rw /dev/ttyUSB0

        popd

        echo "Installing teensy" >> $_logfile
        wget https://www.pjrc.com/teensy/49-teensy.rules
        sudo mv 49-teensy.rules /etc/udev/rules.d/

        wget https://www.pjrc.com/teensy/td_150/TeensyduinoInstall.linux64
        chmod +x TeensyduinoInstall.linux64
        sudo ./TeensyduinoInstall.linux64


        echo "Cleaning up Arduino install" >> $_logfile
        #rm -rf TeensyduinoInstall.linux64

    else
        echo "E: Download Arcuino IDE and re-run this script!" >> $_logfile
    fi
fi
}

install_ros() {
if [ -d /opt/ros ]; then
    echo "ROS installed" >> $_logfile
else
    echo "Installing ROS" >> $_logfile
    sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
    #sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
    curl -sSL 'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' | sudo apt-key add -

    sudo apt update
    sudo apt -y install ros-melodic-desktop-full

    sudo rosdep init
    rosdep update

    sudo apt -y install python-rosinstall python-rosinstall-generator python-wstool build-essential

    mkdir -p ~/catkin_ws/src
    pushd ~/catkin_ws/
    catkin_make
    popd

fi
}


echo -n "Installing required packages ..." >> $_logfile
sudo apt-get -y install curl vim git i3 feh tmux rxvt-unicode-256color preload


#install_vscode
install_fonts
#install_ros
install_zsh
install_arduino


# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..." >> $_logfile
mkdir -p $olddir
echo "done" >> $_logfile

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..." >> $_logfile
cd $dir
echo "done" >> $_logfile

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir" >> $_logfile
    mv ~/.$file $olddir/
    echo "Creating symlink to $file in home directory." >> $_logfile
    ln -s -n $dir/$file ~/.$file
done

sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y clean
sudo apt-get -y autoclean
sudo apt-get -y autoremove

echo "Setup finished..."
#cat $_logfile

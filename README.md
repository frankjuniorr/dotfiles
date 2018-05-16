# dotfiles

![dependence](https://img.shields.io/badge/linux-ubuntu_18.04-212121.svg?style=true)

My config files.
The script `install_dotfiles.sh` create symbolic links in the `$HOME` with the files.
After that run the script, reload yout `~/.bashrc` with `source ~/.bashrc`

## Git prompt

* When have `untracked files` in git, the branch color is purple
* When have somethins to commit in git, the branch color is yellow-bold
* When location is not git, the branch name is hide
* When command is failed, the prompt color is red
* When command is success, the prompt color is green

### Demo

<img alt="Icon" src="screenshots/prompt_example.gif?raw=true" align="center" hspace="1" vspace="1">

# Uso
```shell
git clone git@github.com:frankjuniorr/dotfiles.git
cd dotfiles
./install_dotfiles.sh
source ~/.bashrc
```

# dotfiles

git clone https://github.com/llynch/dotfiles.git
cd dotfiles
git submodule foreach git pull origin master
pip install --user dotfiles
dotfiles --config=.dotfilesrc --sync --dry-run
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
ln -sf ~/.vim/.vimrc ~/.vimrc
vim -c PluginInstall -c qa

dotfiles will be installed in ~/.local/bin using 'pip install --user dotfiles'

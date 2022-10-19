# Homedir distro
export PATH=$PATH:$HOME/.local/bin
# Utilities
export PATH=$PATH:/usr/local/x64/mingw/bin:/d/bin:/d/Neovim/bin
# SML implementations
export PATH=$PATH:$HOME/sml/bin:$HOME/sml/smlnj/bin
# Ndless
export PATH=$PATH:$HOME/builds/Ndless/ndless-sdk/toolchain/install/bin:$HOME/builds/Ndless/ndless-sdk/bin
# NGSpice
export PATH=$PATH:/d/linux/builds/ngspice-32-build/bin
# Rust
export PATH=$PATH:/c/Users/Me/.cargo/bin
# GPG, Virtualbox
export PATH=/d/Program\ Files/GnuPG/bin:/c/Program\ Files/Oracle/VirtualBox:$PATH
# NodeJS
export PATH=$PATH:/d/Program\ Files/nodejs
# LaTeX
export PATH=/d/texlive/2020/bin/win32:$PATH

# Ansible
ANSIBLE=/opt/ansible
export PATH=$PATH:$ANSIBLE/bin
#export PYTHONPATH=$ANSIBLE/lib
export ANSIBLE_LIBRARY=$ANSIBLE/library
export ANSIBLE_VAULT_PASSWORD_FILE=~/vault.py

# Custom compilers
export CC=/mingw64/bin/x86_64-w64-mingw32-gcc
export CXX=/mingw64/bin/x86_64-w64-mingw32-g++
#export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

# VcXsrv
export DISPLAY="localhost:0.0"
alias startx="/d/Program\ Files/VcXsrv/vcxsrv.exe -multiwindow -wgl -winkill -unixkill &"

# Tesseract OCR
export TESSDATA_PREFIX="/mingw64/share/tessdata"

# Extra Aliases
alias polyi="rlwrap -i -f ~/.poly_history -H ~/.poly_history -s 3000 poly -i"
alias smlnj="rlwrap -i -f ~/.smlnj_history -H ~/.smlnj_history -s 3000 sml"

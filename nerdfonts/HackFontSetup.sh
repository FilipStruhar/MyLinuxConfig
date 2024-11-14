
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip -o ~/Downloads/Hack.zip

unzip ~/Downloads/Hack.zip -d ~/Downloads/hack_font

cp ~/Downloads/hack_font/*.ttf ~/.local/share/fonts/

fc-cache -fv

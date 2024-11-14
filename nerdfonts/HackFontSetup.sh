
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Hack.zip -o ~/Downloads/Hack.zip

unzip ~/Hack.zip -d ~/hack_font

cp ~/Downloads/hack_font/*.ttf ~/.local/share/fonts/

fc-cache -fv

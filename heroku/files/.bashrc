if [ -f "$HOME/.miscrc" ]; then
    . "$HOME/.miscrc"
fi

if [ -f "$HOME/.pythonrc" ]; then
    . "$HOME/.pythonrc"
fi

if [ -f "$HOME/.amazonrc" ]; then
    . "$HOME/.amazonrc"
fi

PATH=$PATH:/usr/local/share/npm/bin:$HOME/.rvm/bin # testing this out

# Following comamnd will generate this file under `C:\Users\$CURRENT_USER\Documents\WindowsPowerShell`
# ~~~
#   New-item –type file –force $profile
# ~~~

# Bash like tab key
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Emacs like key binding
Set-PSReadLineOption -EditMode Emacs

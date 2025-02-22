# Following comamnd will generate this file under `C:\Users\$CURRENT_USER\Documents\WindowsPowerShell`
# ~~~
#   New-item –type file –force $profile
# ~~~
#
# Run following command in Administrator mode to enable script in powershell if ti's been disabled:
# ~~~
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
# ~~~

# Bash like tab key
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Emacs like key binding
Set-PSReadLineOption -EditMode Emacs

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Set alias
Set-Alias -Name g -Value git

# Use utf8
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = [Text.UTF8Encoding]::UTF8

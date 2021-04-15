# Following comamnd will generate this file under `C:\Users\$CURRENT_USER\Documents\WindowsPowerShell`
# ~~~
#   New-item –type file –force $profile
# ~~~
#
# Sometimes PowerShell is not allowed to run the startup script, run following command:
# ~~~
# set-executionpolicy remotesigned
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

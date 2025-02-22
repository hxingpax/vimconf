alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ,,='fzf'
alias t='tree -L'
alias g='git'
alias r='rake'
alias ga='grep -rnHPI'
alias f='find'
alias glog='git log --graph --color'
alias myns='netstat -tulpn'
alias v='vim'

ulimit -c unlimited

set -o ignoreeof

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

# export ANDROID_HOME=~/Android
# export ANDROID_SDK_ROOT=$ANDROID_HOME/Sdk
# export ANDROID_NDK_ROOT=$ANDROID_HOME/android-ndk-r20
# export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

if [ -f ~/.fzf.bash ]; then
  export FZF_DEFAULT_COMMAND='rg --files'
  # export FZF_DEFAULT_OPTS='-m --height 50% --border --layout=reverse'
  export FZF_DEFAULT_OPTS='-m --height 50%'
fi

[ -f ~/.dircolors ] && eval "`dircolors -b ~/.dircolors`"

# echo '/tmp/core_%e.%p' | sudo tee /proc/sys/kernel/core_pattern

# export GRADLE_OPTS='-DsocksProxyHost=127.0.0.1 -DsocksProxyPort=1080' # Fuck Gradle

export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"

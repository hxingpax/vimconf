alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ,,='fzf'
alias t='tree -L'
alias g='git'
alias ga='grep -rnHPI'
alias f='find'
alias glog='git log --graph --color'
alias v='vim'

set -o ignoreeof

OS=$(uname -s)
case "$OS" in
  Darwin)
    alias myns='netstat -tuln'
    alias r='noglob rake'
    PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %F{yellow}%# %f'
    export PATH="$(gem environment gemdir)/bin:$PATH"
    ;;

  Linux)
    alias r='rake'
    alias myns='netstat -tulpn'
    ulimit -c unlimited

    # colored GCC warnings and errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
    export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

    export GTK_IM_MODULE=ibus
    export XMODIFIERS=@im=ibus
    export QT_IM_MODULE=ibus

    export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"
    
    [ -f ~/.dircolors ] && eval "`dircolors -b ~/.dircolors`"

    # echo '/tmp/core_%e.%p' | sudo tee /proc/sys/kernel/core_pattern

    # For Android dev
    # export ANDROID_HOME=~/Android
    # export ANDROID_SDK_ROOT=$ANDROID_HOME/Sdk
    # export ANDROID_NDK_ROOT=$ANDROID_HOME/android-ndk-r20
    # export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
    # export GRADLE_OPTS='-DsocksProxyHost=127.0.0.1 -DsocksProxyPort=1080' # Fuck Gradle
    ;;

  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

if [ -f ~/.fzf.bash ] || [ -f ~/.fzf.zsh ]; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50%'
  # export FZF_DEFAULT_OPTS='-m --height 50% --border --layout=reverse'
fi


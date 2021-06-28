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

set -o ignoreeof

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig

export ANDROID_HOME=~/Android
export ANDROID_SDK_ROOT=$ANDROID_HOME/Sdk
export ANDROID_NDK_ROOT=$ANDROID_HOME/android-ndk-r20
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

#export GRADLE_OPTS='-DsocksProxyHost=127.0.0.1 -DsocksProxyPort=1080' # Fuck Gradle

#export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$"

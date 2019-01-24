# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

alias ll='ls -al'

function xdebug() {
  xdb_usage() { echo "usage xdebug: on|off" 1>&2; }

  case "$1" in
    on)
        sudo sed -i 's/^;*\(.*xdebug\.so\)/\1/' /usr/local/etc/php/php.ini
        sudo service apache2 reload > /dev/null
        echo "xdebug on";
        ;;
    off)

        sudo sed -i 's/^\(.*xdebug\.so\)/;\1/' /usr/local/etc/php/php.ini
        sudo service apache2 reload > /dev/null
        echo "xdebug off";
        ;;
    *)
        xdb_usage
  esac
}

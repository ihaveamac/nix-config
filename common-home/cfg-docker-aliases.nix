{ config, pkgs, ... }:

{
  programs.zsh.initContent = ''
    ######################################################################
    # begin common-home/cfg-docker-aliases.nix

    # https://github.com/docker/compose/issues/8544#issuecomment-974639028
    dockerssh () {
      export RANDVAL=$RANDOM
      export SOCK_FILE="/tmp/docker-$RANDVAL.sock"
      export DOCKER_HOST="unix://$SOCK_FILE"
      export SSH_CTL_PATH="/tmp/docker-ctrl-socket-$RANDVAL"
      cleanup() {
        echo 'Cleaning up'
        ssh -q -S $SSH_CTL_PATH -O exit personal-root
        rm -f $SOCK_FILE
        unset RANDVAL
        unset SOCK_FILE
        unset DOCKER_HOST
      }
      #trap "cleanup" EXIT
      echo "SSHing ($SSH_CTL_PATH) ($SOCK_FILE)"
      ssh -M -S $SSH_CTL_PATH -fnNT -L "$SOCK_FILE:/var/run/docker.sock" $SSH_TARGET
      eval "$*"
      cleanup
    }
    dcwprod() {
      export SSH_TARGET=wiki-root
      dockerssh docker compose -f prod-docker-compose.yml "$@";
    }
    dclprod() {
      docker compose -f prod-docker-compose.yml "$@";
    }

    # end common-home/cfg-docker-aliases.nix
  '';
}

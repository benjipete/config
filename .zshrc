export DISPLAY=:0
# Generate J Aliases
if [[ -f ~/generate_j_aliases.sh ]]; then
    . ~/generate_j_aliases.sh
fi

eval "$(brew shellenv)"  # you may need to add this for $HOMEBREW_PREFIX to be defined
export PATH=$HOME/.local/bin:$PATH:$HOME/local/bin:${HOME}/.local/share/solana/install/active_release/bin
setopt interactivecomments 
export RIPGREP_CONFIG_PATH=/Users/bstorey/.ripgreprc
alias wron='ark wron'
alias wtfi='ark wtfi'
alias rr='tmux rename-window roadrunner && ssh -t devenv-bstorey "cd data/roadrunner ; bash --login"'
alias trad='tmux rename-window trading && ssh -t devenv-bstorey "cd data/trading ; bash --login"'
alias fpga='tmux rename-window fpga && ssh -t devenv-bstorey "cd data/fpga ; bash --login"'
alias vi='nvim'
export PATH="$PATH:/opt/homebrew/opt/mysql@5.7/bin"
alias jamsind="jira issue create -pAMSIND -tTask -l apac_india_execution_dev -l india -bTODO "
alias jd="jira issue create -pDART -tImprovement"
alias dnsflush='sudo killall -HUP mDNSResponder'

# fish users


function whereismycommit()
{
    if [ "$#" -ne 1 ]; then
        echo "${0} gitshah"
        return
    fi
    wget https://imcusers/whereismycommit\?sha\=$1 -nv -O - | jq
}


upload_server ()
{
  echo "curl -X POST http://${HOSTNAME}:8000/upload -F 'files=@multiple-example-1.txt' -F 'files=@multiple-example-2.txt'";
  echo "install upload server: python3 -m pip install --user uploadserver";
  python3 -m uploadserver
}

export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulufx-21.0.1-aarch64.jdk/Contents/Home
alias lunch='curl ""https://socialhub/lunchmenu.png"" -s | tesseract stdin stdout  -l eng'


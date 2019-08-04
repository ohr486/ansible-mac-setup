#!/bin/bash

# for alias by ansible-mac-setup

# for git
alias g='cd $(ghq root)/$(ghq list | peco)'
alias gl='open https://$(ghq list | peco | sed -e "s/:10022//g")'
alias gc='git checkout $(git branch | peco | sed -e "s/\*//g")'
alias git-private-setup='git config user.name "ohr486" && git config user.email "ohr486@gmail.com"'

# for ruby
alias be='bundle exec'

# for k8s
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kc='kubectl config'
alias ke='kubectl exec'
alias kl='kubectl logs'
alias kpf='kubectl port-forward'
source <(kubectl completion zsh)

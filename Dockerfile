FROM ubuntu:latest    

WORKDIR /home/robert
ENV TERM=xterm-256color

RUN apt update && \
    apt -y install gnupg2 curl apt-transport-https vim emacs wget zsh git golang sudo && \
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ && \
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    apt update && \
    apt -y install code && \
    rm packages.microsoft.gpg && \
    export uid=1001 gid=1001 && \
    mkdir -p /home/robert && \
    echo "robert:x:${uid}:${gid}:robert,,,:/home/robert:/usr/bin/zsh" >> /etc/passwd && \
    echo "robert:x:${uid}:" >> /etc/group && \
    echo "robert ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/robert && \
    chmod 0440 /etc/sudoers.d/robert && \
    chown ${uid}:${gid} -R /home/robert

# user is created, switch to that user for user specific work
USER robert
ENV HOME /home/robert

RUN whoami && \
    cd ~ && \
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  && \
    nvm install --lts && \
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true && \
    rm ~/.zshrc && \
    ln -s Documents/dot_zshrc_docker_zsh .zshrc && \
    ln -s Documents/dot_vimrc_docker_zsh .vimrc && \
    sudo chsh -s /usr/bin/zsh robert

# EXPOSE 22/tcp

# ENTRYPOINT ["top"]
# CMD /usr/bin/firefox
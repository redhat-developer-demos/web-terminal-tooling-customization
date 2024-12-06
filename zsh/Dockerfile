FROM quay.io/wto/web-terminal-tooling:next
# TODO: Ideally, you want to build this off of wto tooling w/kubedock
# FROM quay.io/<user>/wto-tooling:kubedock-only

USER 0

# Install Oh My ZSH
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install ZSH plugins
## Install zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Needed because automount configmap setting $SHELL will break your CDE's if the tooling image doesn't have ZSH
ENV SHELL="zsh"

USER 1001

ENTRYPOINT [ "/entrypoint.sh" ]

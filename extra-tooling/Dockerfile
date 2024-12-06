FROM quay.io/wto/web-terminal-tooling:next
USER 0

## TODO: Use env var for all tooling versions

# k9s
WORKDIR /tmp/
RUN curl -LO https://github.com/derailed/k9s/releases/download/v0.32.7/k9s_linux_amd64.rpm && \
     rpm -ivh  k9s_linux_amd64.rpm

# bat
RUN curl -L https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz | tar -xzvf - -C . --no-same-owner \
    && cp ./bat-v0.24.0-x86_64-unknown-linux-musl/bat /usr/local/bin/bat \
    && chmod +x /usr/local/bin/bat

# ripgrep
RUN curl -L https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz| tar -xzvf - -C . --no-same-owner \
    && cp ./ripgrep-14.1.1-x86_64-unknown-linux-musl/rg /usr/local/bin/rg \
    && chmod +x /usr/local/bin/rg

# lf
RUN curl -L https://github.com/gokcehan/lf/releases/download/r33/lf-linux-amd64.tar.gz| tar -xzvf - -C . --no-same-owner \
   && cp ./lf /usr/local/bin/lf \
   && chmod +x /usr/local/bin/lf


WORKDIR /home/user/

USER 1001


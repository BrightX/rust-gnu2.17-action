FROM centos:7.9.2009

COPY yum-repos/CentOS-*.repo /etc/yum.repos.d/
COPY rpm-gpg/RPM-GPG-KEY-* /etc/pki/rpm-gpg/

# Install dependencies
RUN set -eux; \
    yum makecache && \
    yum -y update && \
    yum -y install \
    curl \
    devtoolset-11-gcc \
    devtoolset-11-gcc-c++ \
    glibc-devel \
    make \
    git \
    libarchive-devel \
    xz-devel \
    pkgconf \
    rpm-build \
    ca-certificates && \
    yum clean all

RUN ln -s /opt/rh/devtoolset-11/enable /etc/profile.d/devtoolset-enable.sh

#ARG TOOLCHAIN

ENV RUSTUP_HOME=/opt/rust/rustup \
    CARGO_HOME=/opt/rust/cargo \
    PATH=/opt/rust/cargo/bin:$PATH

RUN printf 'export RUSTUP_HOME=/opt/rust/rustup\nexport CARGO_HOME=/opt/rust/cargo\nexport PATH=/opt/rust/cargo/bin:$PATH\n' > /etc/profile.d/rust-setup.sh

# see https://rust-lang.github.io/rustup/installation/other.html#manual-installation
# https://static.rust-lang.org/rustup/rustup-init.sh
# https://sh.rustup.rs
# https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init
# https://static.rust-lang.org/rustup/archive/1.28.2/x86_64-unknown-linux-gnu/rustup-init

# Install Rust
RUN curl https://static.rust-lang.org/rustup/archive/1.28.2/x86_64-unknown-linux-gnu/rustup-init -o rustup-init; \
    echo '20a06e644b0d9bd2fbdbfd52d42540bdde820ea7df86e92e533c073da0cdd43c *rustup-init' | sha256sum -c - && \
    chmod +x rustup-init && \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain stable && \
    rm rustup-init && \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME

RUN printf '[net] \ngit-fetch-with-cli = true\n' >> /opt/rust/cargo/config.toml

# Install cargo-deb
RUN source /opt/rh/devtoolset-11/enable && \
    cargo install -f cargo-deb && \
    rm -rf /opt/rust/cargo/registry/

# Setup user and workspace
RUN mkdir -p /github && \
    useradd -m -d /github/home -u 1001 github

ADD entrypoint.sh cleanup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh /usr/local/bin/cleanup.sh

USER github
WORKDIR /github/home

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

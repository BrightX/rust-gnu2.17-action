#!/bin/bash

set -e

if [ "x$3" != "x" ]; then
    echo $3 > .git_credentials
    git config --global credential.helper "store --file $PWD/.git_credentials"
    git config --global "url.https://github.com/.insteadOf" "ssh://git@github.com/"
    git config --global --add "url.https://github.com/.insteadOf" "git@github.com:"
fi

echo "Setting up local Cargo env"
mkdir -p .cargo
ln -sf $CARGO_HOME/bin .cargo/

if [ -f .cargo/config.toml ]; then
    mv .cargo/config.toml .cargo/config.original
    cp $CARGO_HOME/config.toml .cargo/config.toml
    echo >> .cargo/config.toml
    cat .cargo/config.original >> .cargo/config.toml
else
    cp $CARGO_HOME/config.toml .cargo/config.toml
fi

export CARGO_HOME=$PWD/.cargo

source /opt/rh/devtoolset-11/enable

if [ "x$2" != "x" ]; then
    (cd $2 && $CARGO_HOME/bin/cargo $1)
else
    $CARGO_HOME/bin/cargo $1
fi

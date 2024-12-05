curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
cargo install --locked bat
cargo install fd-find
mkdir -p $HOME/data
cd $HOME/data/
git clone https://github.com/grailbio/bazel-compilation-database.git


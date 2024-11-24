@echo off
git submodule update --init --recursive
pushd raylib
git checkout 5.5
popd

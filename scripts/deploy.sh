#!/bin/bash
#
# Simple deploy script for running the `sdep` command. As we specify all
# configuration values as environment variables in our `.travis.yml` file, we
# just need to run the command.

if ! which sdep >/dev/null; then
  sudo pip install sdep
fi

hugo

sdep update

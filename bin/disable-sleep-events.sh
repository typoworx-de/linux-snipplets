#!/bin/sh

sudo systemctl mask \
  sleep.target \
  suspend.target \
  hibernate.target \
  hybrid-sleep.target
  \
  nvidia-suspend \
  nvidia-resume \
  nvidia-hibernate

sudo systemctl disable \
  sleep.target \
  suspend.target \
  hibernate.target \
  hybrid-sleep.target \
  \
  nvidia-suspend \
  nvidia-resume \
  nvidia-hibernate


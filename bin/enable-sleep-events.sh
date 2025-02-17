#!/bin/sh

sudo systemctl unmask \
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

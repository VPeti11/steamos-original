#!/bin/bash
systemctl enable sddm
groupadd -r nopasswdlogin
gpasswd -a deck nopasswdlogin
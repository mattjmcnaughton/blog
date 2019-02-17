+++
title = "Mutt"
date = "2019-02-16"
categories = ["Projects"]
thumbnail = ""
+++

- Fastmail hosted

- Setup MX via Route53 to mattjmcnaughton.com

Install
- mutt
- offlineimap
- notmuch
- msmtp

Create password file `~/.msmtp-fastmail.gpg`
gpg --encrypt password.txt -o ~/.msmtp-fastmail.gpg -r KEY_ID

Dotfiles
.msmtprc
.muttrc
.notmuch-config
.offlineimap.py
.offlineimaprc

GPG

Setup
- Mutt uses gpg2
- https://gitlab.com/muttmua/mutt/wikis/MuttGuide/UseGPG
- Should work fairly out of the box.
  - Test

Extensions
- Access other gpg keys using gpg --search. Can trust.
- Multiple identities for gpg key (two emails)
- Host key on website, keybase, github
- Using gpg with github to verify commits
- Use gpg encryption by default when replying to gpg encrypted emails

Open Questions
- Long term relationship between gpg and gpg2. Do I want both on my system?


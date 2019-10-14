---
layout: post
title: Installing Catalina clibs/headers
tags: [catalina, brew, nokogiri]
subtitle: Catalina upgrade issues
---

Upgrading to Catalina was an overall painless process. The main issue I ran into after upgrading was with compiling packages.
I've previously had issues with installing certain packages via [homebrew](https://brew.sh/), and installing certain gems
such as Nokogiri(`gem install nokogiri`).

### Previous Solution
Previously in order to get things to compile I would install OSX header files via running

```bash
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
```

However, with Xcode 11, and Catalina, that file no longer exists.

### Current solution
After upgrading to Catalina I needed to

1. Open Xcode and let it install "Additional Components"
2. Rerun `xcode-select --install` from the terminal
3. Add `export CPATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include"` to my `~/.bash_profile`

once that was done, `brew` packages, and gem installs(`gem install nokogiri` is always a good test) compiled and installed correctly!

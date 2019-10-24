---
layout: post
title: Installing Catalina clibs/header files
tags: [catalina, brew, nokogiri]
subtitle: Catalina upgrade issues
---

Upgrading to Catalina was an overall painless process. The main issue I ran into after upgrading was with compiling packages.
I've previously had issues with installing specific packages via [homebrew](https://brew.sh/), as well as certain gems(such as llvm, or nokogiri).

### Previous Solution
Previously to get things to compile I would install OSX header files via running

```bash
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
```

However, with Xcode 11, and Catalina, that file no longer exists.

### Current solution
**updated 10-24-2019**
After upgrading to Catalina, I needed to


1. Open Xcode and let it install "Additional Components"
2. Rerun `xcode-select --install` from the terminal
3. Ensure only one version of `llvm` is installed via `brew`
4. Add `export SDKROOT="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"` to `~/.bash_profile`

Previously I also had added `export CPATH="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include"` but that doesn't seem to be required anymore.


once that was done, `brew` packages, and gem installs(`gem install nokogiri` is always a good test) compiled and installed correctly!

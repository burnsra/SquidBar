# SquidBar [![Build Status](https://travis-ci.org/burnsra/SquidBar.svg?branch=master)](https://travis-ci.org/burnsra/SquidBar)

## Overview

**SquidBar** is a menu bar application for controlling your local installation of squid proxy. With this utility you will also be able to do the following:

- Define the squid executable
- Define the squid configuration file
- Option to start this application on login
- Option to start squid on application launch
- Option to watch for network changes, restarting squid appropriately

## Screenshots

Status Menu

<img style="max-width:100%;" src="https://github.com/burnsra/SquidBar/blob/master/assets/status_menu.png" />

Preferences Window

<img style="max-width:75%;" src="https://github.com/burnsra/SquidBar/blob/master/assets/preferences_window.png" />

## Requirements

- OS X 10.10
- [Squid](http://www.squid-cache.org/)

## Configuration

1. Go to Preferences
2. Choose your squid executable and squid configuration files (both default to homebrew installation locations)
3. Optionally choose to add it to your login items, auto-start the application on launch, or to watch for network changes / auto-restart

### Homebrew users

After installing Squid with **[Homebrew](http://brew.sh/)**

- The squid executable is located at `/usr/local/opt/squid/sbin/squid`
- The squid configuration file is located at `/usr/local/etc/squid.conf`

## Contributions

Do you want to improve the app or add any useful features? Please go ahead and create pull requests. I'm thankful for any help.

## Acknowledgements

- [FileSystemEvents](https://github.com/Eonil/FileSystemEvents) framework by [Hoon H.](drawtree@gmail.com)

## License

[MIT](https://github.com/burnsra/SquidBar/blob/master/LICENSE) © Robert Burns

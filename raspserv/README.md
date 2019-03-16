# Install and configure mopidy with some modules
The configuration file provided works with all the modules installed
Included modules:
- soundcloud
- tunein
- internetarchive
- podcast
- podcast-itunes
- mopidy-local-sqlite
- mopidy-alsamixer

## Frontend
- Mopidy-Iris
- Mopidy-Scrobbler

Iris will be reachable at http://YuorServer:6680/iris

# Prerequisites
* Tested with Puppet 4.8.2

# Create a local_env file with the secret you want to pass

    export FACTER_soundcloudtoken=XXXXXXXXXXXXXXXXXXXXXXXXX
    export FACTER_scrobbler_user=YOUR_LASTFM_USER
    export FACTER_scrobbler_pw='YOUR_LASTFM_PW'

# Load the env and run puppet to install mopidy
    . local_env
    puppet apply --modulepath ./modules/ manifests/site.pp

# Note
It was successfully tested on a raspberrypi with Raspbian

# Resources
https://docs.mopidy.com/en/latest/

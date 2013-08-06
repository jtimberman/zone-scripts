# Description

This is a collection of scripts I'm using to manage zones in my
exploration of OmniOS/IllumOS.

# Requirements

You'll need an IllumOS (or Solaris) system ready to be the host. I'm
using [OmniOS](http://omnios.omniti.com)

# Scripts

## mkchefbase.sh

This creates a zone with Chef installed, named `chefbase`. This zone
can be cloned as other zones with the `zone-launcher.sh` script.

## zone-launcher.sh

This clones the `chefbase` zone with the given zone name, e.g.:

    ./zone-launcher.sh myzone

It will install Chef, copy the validation.pem for a Chef Server and
write out the `/etc/chef/client.rb` for the Hosted Chef organization
specified by the environment variable `$ORGNAME`.

## zone-cleaner.sh

This removes the zone's node and client from the Hosted Chef
organization, and cleans up the zone from the host system.

# License and Author

- Author:: Joshua Timberman <opensource@housepub.org>
- Copyright:: Copyright (c) 2013, Joshua Timberman
- License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

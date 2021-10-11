# OpenVPN3 Easy Connect
A shell script for easily connecting and disconnecting sessions with OpenVPN3

### Usage is simple:
* Provide your `client.ovpn` file's location on line 4 of this script.
* Optionally, provide your temp file location. By default, this is `/tmp`.
    * This is used to capture, store and use the current openvpn3 session's ID when `./ovpn.sh connect` is passed.
    * None of these files are retained.
* `chmod +x ./ovpn.sh`. Optionally, you can `mv ovpn.sh ovpn`.
* Place the script somewhere in your PATH. `$HOME/.local/bin/` works nicely.

### This script accepts three arguments:
* `./ovpn.sh connect` will take you through connecting to your OpenVPN connection. See the script for comments on functionality.
* `./ovpn.sh disconnect` will iterate through active openvpn3 sessions, and disconnect them all in succession.
* `./ovpn.sh list` will list the current openvpn3 sessions.
* If you forget the above, running `ovpn.sh` without any parameters passed to it will advise you on what the available options are.

Have fun!
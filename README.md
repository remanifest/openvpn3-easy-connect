# OpenVPN3 Easy Connect
A shell script for easily connecting and disconnecting sessions with OpenVPN3

Usage is simple:
* Provide your client.ovpn file's location on line 3 of this script.
* chmod +x ./ovpn.sh. Optionally, you can mv ovpn.sh ovpn.
* Place the script somewhere in your PATH. $HOME/.local/bin/ works nicely.
* Call the script with "ovpn.sh connect" or "ovpn.sh disconnect".
* If you forget the above, running "ovpn.sh" without any parameters passed will advise you on what the available options are.

Have fun!
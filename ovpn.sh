#!/bin/sh
# Enter your OpenVPN config file's location below. Replace myconfig.ovpn with your actual OpenVPN config file's location.
# If you'd like to use a location other than /tmp for this script's temp files (used to store the current session ID), you may change tempLocation as well.
ovpnConfig=$HOME/myconfig.ovpn
tempLocation=/tmp

# If "connect" was passed as an argument...
if [ "$1" == "connect" ]; then
    # Initiate the OpenVPN connection using the config specified above. Will prompt for username, password, and TOTP if enabled.
    # Write the stdout to ovpn3-session.log so we can use it to disconnect the session later.
    openvpn3 session-start --config $ovpnConfig &> >(tee >(tee "$tempLocation/ovpn3-session.log" | logger -t $tempLocation/ovpn3-session))

    # grep the stdout log for the session's path, and output that result to the ovpn3-sessionId file.
    # Remove the session's stdout log.
    # Use sed to strip unneded information from ovpn3-sessionId, and store the session's location to the vpnSession variable.
    vpnSession=$(grep "Session path: " $tempLocation/ovpn3-session.log>$tempLocation/ovpn3-sessionId && rm $tempLocation/ovpn3-session.log && sed -e "s/Session path: //g" $tempLocation/ovpn3-sessionId)

    # Remove the ovpn3-sessionId file, which is no longer needed (all temp files removed at this point)
    rm $tempLocation/ovpn3-sessionId

    # Wait for user input; give the user instructions as to how to disconnect.
    echo -en "Enter \033[38;0;33m\"d\"\033[0m when you want to disconnect: "
    
    # Store the user's input into the toDisconnect variable.
    read toDisconnect
    
    # If the user has chosen to disconnect, disconnect using the previously stored vpnSession.
    if [ "$toDisconnect" == "d" ]; then
        echo -e "Shutting down \033[38;0;33m$vpnSession\033[0m.\n"
        openvpn3 session-manage --session-path $vpnSession --disconnect

    # Otherwise, kindly dismiss the user and let them know how to disconnect later.
    else
        echo -e "\nExiting. Run this script with the \033[38;0;31mdisconnect\033[0m argument when you want to disconnect.\n"
    fi

# If "disconnect" was passed as an argument...
elif [ "$1" == "disconnect" ]; then
    
    # List the openvpn3 sessions
    sessionOutput=$(openvpn3 sessions-list)
    
    # If there are no sessions, let the user know that.
    if [ "$sessionOutput" == "No sessions available" ]; then
        echo -e "\nThere are no openvpn3 sessions for me to close!\n"
    
    # If one or more sessions are returned, disconnect them in succession.
    else
        for vpnSession in $(openvpn3 sessions-list | grep "Path: " | sed "s/Path: //g" | sed -e "s/[[:space:]]\+//g")
        do
            echo -e "Shutting down \033[38;0;33m$vpnSession\033[0m.\n"
            openvpn3 session-manage --session-path $vpnSession --disconnect
        done
        echo -e "All active sessions have been disconnected."
    fi

# If no arguments are passed, tell the user how to interact with this script.
else
    echo -e "\nAvailable options are as follows:

    \033[38;0;32mconnect\033[0m:\tPrompts you for username, password, and TOTP to initiate the connection.
    \033[38;0;31mdisconnect\033[0m:\tGets the existing session ID and disconnects.

Please try again after passing one of the above arguments.\n"
fi
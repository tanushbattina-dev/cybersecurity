#!/bin/sh
# Detect interactive accounts that have never logged in.
# Designed for Ubuntu systems using lastlog2.

while IFS=: read -r user _ uid _ _ home shell; do
    case "$shell" in
        */nologin|/bin/false) continue ;;
    esac

    [ "$uid" -ge 1000 ] 2>/dev/null || continue

    if lastlog2 --user "$user" 2>/dev/null |
        grep -q 'Never logged in'; then
        echo "WARNING: $user has never logged in; review whether the account is needed."
    fi
done < /etc/passwd
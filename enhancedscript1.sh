# Test: CUST-9005
# Detect interactive accounts that have never logged in

Register --test-no CUST-9005 --weight M --network NO \
    --category security \
    --description "Detect interactive accounts that have never logged in"

if [ "${SKIPTEST}" -eq 0 ]; then
    FOUND=0

    Display --indent 2 \
        --text "Checking for interactive accounts that have never logged in"

    while IFS=: read -r USER_NAME _ UID _ _ HOME_DIR SHELL_PATH; do
        if [ "$UID" -ge 1000 ] 2>/dev/null &&
           [ "$SHELL_PATH" != "/usr/sbin/nologin" ] &&
           [ "$SHELL_PATH" != "/bin/false" ]; then

            if lastlog2 --user "$USER_NAME" 2>/dev/null |
                grep -q "Never logged in"; then
                FOUND=1
                ReportWarning "CUST-9005" \
                    "Interactive account $USER_NAME has never logged in; review whether it is needed"
            fi
        fi
    done < /etc/passwd

    if [ "$FOUND" -eq 0 ]; then
        Display --indent 4 \
            --text "No never-logged-in interactive accounts found" \
            --result "${STATUS_OK}" --color GREEN
    fi
fi

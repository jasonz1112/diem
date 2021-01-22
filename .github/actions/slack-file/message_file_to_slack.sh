#!/bin/bash
# Since actions can't embed actions, and we need to send slack messages from the build-setup.sh action....
#

       if [ -e "${PAYLOAD_FILE}" ]; then
          jq -n \
            --arg msg "$(cat ${PAYLOAD_FILE})" \
            --arg url "$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID" \
            '{
              attachments: [
                {
                  text: $msg,
                  actions: [
                    {
                      "type": "button",
                      "text": "Visit Job",
                      "url": $url
                    }
                  ],
                }
              ]
            }' > /tmp/payload
          cat /tmp/payload
          if [ ${WEBHOOK} ]; then
            curl -X POST -H 'Content-type: application/json' -d @/tmp/payload \
            ${WEBHOOK}
          else
            echo "Not sending messages as no webhook url is set."
            echo "Chances are you are not building on master, or gha is misconfigured."
            echo "webhook is empty"
            exit 0
          fi
        fi
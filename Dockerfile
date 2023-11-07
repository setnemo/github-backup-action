FROM drinternet/rsync:v1.4.3

# Add git for pushing backups
RUN apk add --no-cache git

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

#!/bin/sh

if [ -z "$(echo "$INPUT_REMOTE_PATH" | awk '{$1=$1};1')" ]; then
    echo "The remote_path can not be empty"
    exit 1
fi

# Start the SSH agent and load key.
source agent-start "$GITHUB_ACTION"
echo "$INPUT_REMOTE_KEY" | SSH_PASS="$INPUT_REMOTE_KEY_PASS" agent-add

# Add strict errors.
set -eu

# Variables.
RSH="ssh -o StrictHostKeyChecking=no -p $INPUT_REMOTE_PORT"
LOCAL_PATH="$GITHUB_WORKSPACE/$INPUT_PATH"
DSN="$INPUT_REMOTE_USER@$INPUT_REMOTE_HOST"

# Backup.
sh -c "rsync -chavzP -e '$RSH' $DSN:$INPUT_REMOTE_PATH $LOCAL_PATH"

# Configure git.
sh -c "git config --global user.name backup-action-bot && git config --global user.email bot@setnemo.online"

# Commit.
CTXT=$(date +%m-%d-%Y\ %T)
sh -c "git add . && git commit -am '$CTXT' && git push --force"

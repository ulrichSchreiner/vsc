#!/bin/sh

${CODE_ENTRY} \
    --install-extension mutantdino.resourcemonitor \
    --install-extension ms-vscode-remote.vscode-remote-extensionpack \
    --install-extension MS-vsliveshare.vsliveshare \
    --install-extension MS-vsliveshare.vsliveshare-pack

${CODE_ENTRY} $DISABLE_GPU --verbose "$@"

import subprocess

# tool list from here:
# https://github.com/microsoft/vscode-go/blob/master/src/goTools.ts
#

tools = {
    'gopkgs': 'github.com/uudashr/gopkgs/cmd/gopkgs',
    'go-outline': 'github.com/ramya-rao-a/go-outline',
    'go-symbols': 'github.com/acroca/go-symbols',
    'guru': 'golang.org/x/tools/cmd/guru',
    'gorename': 'golang.org/x/tools/cmd/gorename',
    'gotests': 'github.com/cweill/gotests/...',
    'gomodifytags': 'github.com/fatih/gomodifytags',
    'impl': 'github.com/josharian/impl',
    'fillstruct': 'github.com/davidrjenni/reftools/cmd/fillstruct',
    'goplay': 'github.com/haya14busa/goplay/cmd/goplay',
    'godoctor': 'github.com/godoctor/godoctor',
    'godef': 'github.com/rogpeppe/godef',
    'gotype-live': 'github.com/tylerb/gotype-live',
    'godoc': 'golang.org/x/tools/cmd/godoc',
    'gogetdoc': 'github.com/zmb3/gogetdoc',
    'goimports': 'golang.org/x/tools/cmd/goimports',
    'goreturns': 'github.com/sqs/goreturns',
    'goformat': 'winterdrache.de/goformat/goformat',
    'golint': 'golang.org/x/lint/golint',
    'staticcheck': 'honnef.co/go/tools/...',
    'golangci-lint': 'github.com/golangci/golangci-lint/cmd/golangci-lint',
    'revive': 'github.com/mgechev/revive',
    'dlv': 'github.com/derekparker/delve/cmd/dlv',
    'godoctor': 'github.com/godoctor/godoctor',
    'gopls': 'golang.org/x/tools/cmd/gopls'
}

for tool, url in tools.items():
    print ("install ", tool)
    if tool.endswith("-gomod"):
        rc = subprocess.call(["go","get","-d",url])
        rc2 = subprocess.call(["go", "build","-i", "-o", "/go/bin/"+tool], cwd="/go/src/"+url)
        if rc != 0 or rc2 != 0:
            print("FAILED: ", tool)
    else:
        rc = subprocess.call(["go","get",url])
        if rc != 0:
            print ("FAILED: ", tool)

import subprocess

# tool list from here:
# https://github.com/Microsoft/vscode-go/blob/master/src/goInstallTools.ts
#

tools = {
    'gocode': 'github.com/mdempsky/gocode',
    'gocode-gomod': 'github.com/stamblerre/gocode',
    'gopkgs': 'github.com/uudashr/gopkgs/cmd/gopkgs',
    'go-outline': 'github.com/ramya-rao-a/go-outline',
    'go-symbols': 'github.com/acroca/go-symbols',
    'guru': 'golang.org/x/tools/cmd/guru',
    'gorename': 'golang.org/x/tools/cmd/gorename',
    'gomodifytags': 'github.com/fatih/gomodifytags',
    'goplay': 'github.com/haya14busa/goplay/cmd/goplay',
    'impl': 'github.com/josharian/impl',
    'gotype-live': 'github.com/tylerb/gotype-live',
    'godef': 'github.com/rogpeppe/godef',
    'godef-gomod': 'github.com/ianthehat/godef',
    'godoc': 'golang.org/x/tools/cmd/godoc',
    'gogetdoc': 'github.com/zmb3/gogetdoc',
    'goimports': 'golang.org/x/tools/cmd/goimports',
    'goreturns': 'github.com/sqs/goreturns',
    'goformat': 'winterdrache.de/goformat/goformat',
    'golint': 'golang.org/x/lint/golint',
    'gotests': 'github.com/cweill/gotests/...',
    'gometalinter': 'github.com/alecthomas/gometalinter',
    'megacheck': 'honnef.co/go/tools/...',
    'golangci-lint': 'github.com/golangci/golangci-lint/cmd/golangci-lint',
    'revive': 'github.com/mgechev/revive',
    'go-langserver': 'github.com/sourcegraph/go-langserver',
    'dlv': 'github.com/derekparker/delve/cmd/dlv',
    'fillstruct': 'github.com/davidrjenni/reftools/cmd/fillstruct'        
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

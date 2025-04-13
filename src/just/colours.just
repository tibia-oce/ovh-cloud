_echo-black message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Black"
    else
        echo "\033[30m{{message}}\033[0m"
    fi

_echo-red message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Red"
    else
        echo "\033[31m{{message}}\033[0m"
    fi

_echo-green message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Green"
    else
        echo "\033[32m{{message}}\033[0m"
    fi

_echo-yellow message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Yellow"
    else
        echo "\033[33m{{message}}\033[0m"
    fi

_echo-blue message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Blue"
    else
        echo "\033[34m{{message}}\033[0m"
    fi

_echo-magenta message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Magenta"
    else
        echo "\033[35m{{message}}\033[0m"
    fi

_echo-cyan message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Cyan"
    else
        echo "\033[36m{{message}}\033[0m"
    fi

_echo-white message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor White"
    else
        echo "\033[37m{{message}}\033[0m"
    fi

_echo-success message:
    @just _echo-green "✅ {{message}}"

_echo-error message:
    @just _echo-red "❌ {{message}}"

_echo-warning message:
    @just _echo-yellow "⚠️ {{message}}"

_echo-info message:
    @just _echo-cyan "ℹ️ {{message}}"

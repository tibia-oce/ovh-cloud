# ========== COLOR HELPER FUNCTIONS ==========

# Helper recipe for cross-platform black text
_echo-black message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Black"
    else
        echo "\033[30m{{message}}\033[0m"
    fi

# Helper recipe for cross-platform red text
_echo-red message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Red"
    else
        echo "\033[31m{{message}}\033[0m"
    fi

# Helper recipe for cross-platform green text
_echo-green message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Green"
    else
        echo "\033[32m{{message}}\033[0m"
    fi

# Helper recipe for cross-platform yellow text
_echo-yellow message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Yellow"
    else
        echo "\033[33m{{message}}\033[0m"
    fi

# Helper recipe for cross-platform blue text
_echo-blue message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Blue"
    else
        echo "\033[34m{{message}}\033[0m"
    fi

# Helper recipe for cross-platform magenta text
_echo-magenta message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ]; then
        powershell -Command "Write-Host '{{message}}' -ForegroundColor Magenta"
    else
        echo "\033[35m{{message}}\033[0m"
    fi

# Helper recipe for cross-platform cyan text
_echo-cyan message:
    #!/usr/bin/env sh
    if [ -n "$COMSPEC" ] || [ -n "$POWERSHELL_VERSION" ];

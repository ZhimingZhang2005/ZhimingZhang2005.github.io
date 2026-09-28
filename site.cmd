@echo off
setlocal
"%SystemRoot%\System32\wsl.exe" --distribution Ubuntu --cd "%~dp0." --exec bash .scripts/jekyll.sh %*
exit /b %ERRORLEVEL%

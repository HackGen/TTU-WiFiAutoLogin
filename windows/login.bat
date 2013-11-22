@echo off

call config.cmd

call curl -k -d "user=%user%&password=%password%&cmd=authenticate&Login=Log+In" %url% 2> NUL

echo Complete!
echo.
echo.
pause

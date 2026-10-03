@echo off
cd /d "%~dp0"
javac -encoding UTF-8 -d out -sourcepath src tests/AllTests.java || exit /b 1
java -cp out AllTests

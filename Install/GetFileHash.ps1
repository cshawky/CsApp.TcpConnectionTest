"Preparing File Hash for the application..."
Get-FileHash .\CsApp.TcpConnectionTest\*.EXE | Format-List > "Current File Hash.txt"
Get-FileHash .\CsApp.TcpConnectionTest\*.DLL | Format-List >> "Current File Hash.txt"
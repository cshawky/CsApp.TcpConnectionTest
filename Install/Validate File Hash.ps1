"Creating Current File Hash.txt for the application..."
Get-FileHash .\CsApp.TcpConnectionTest\*.EXE | Format-List > "Current File Hash.txt"
Get-FileHash .\CsApp.TcpConnectionTest\*.DLL | Format-List >> "Current File Hash.txt"

"Comparing against the Expected File Hash.txt file..."
$result=Compare-Object (Get-Content "Expected File Hash.txt") (Get-Content "Current File Hash.txt")
if ( $result.Length -ne 0 ) {
    "ERROR: There is a mismatch in File Hashes. Please investigate manually."
} else {
    "INFO: The hash comparison was successful."
}
# TODO: Remove the folder names in the text report so that comparison will work.
# Currently this test will always fail unless the files are in the exact same folder.

"Creating Current File Hash.txt for the application..."
Get-FileHash .\CsApp.TcpConnectionTest\*.EXE | Format-List > "Current File Hash.txt"
Get-FileHash .\CsApp.TcpConnectionTest\*.DLL | Format-List >> "Current File Hash.txt"

"Comparing against the Expected File Hash.txt file..."
$result=Compare-Object (Get-Content "Expected File Hash.txt") (Get-Content "Current File Hash.txt")
if ( $result.Length -ne 0 ) {
    "ERROR: There is a mismatch in File Hashes. Please investigate manually."
    "INFO: This error is most likely due to the full path differences. Ignore the path and check hash manually."
} else {
    "INFO: The hash comparison was successful."
}
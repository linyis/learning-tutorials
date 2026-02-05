' delete_watch.vbs - Stop the hidden watch process
Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set colProcesses = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name='powershell.exe'")

For Each objProcess in colProcesses
    If InStr(objProcess.CommandLine, "watch.ps1") > 0 Then
        objProcess.Terminate()
        WScript.Echo "Watch stopped"
    End If
Next

If WScript.Arguments.Count = 0 Then
    WScript.Echo "No watch process found (or already stopped)"
End If

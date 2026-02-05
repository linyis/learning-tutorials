' Start Watch (Hidden) - with duplicate check
Set fso = CreateObject("Scripting.FileSystemObject")
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)

Set objWMIService = GetObject("winmgmts:\\.\root\CIMV2")
Set colProcesses = objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name='powershell.exe'")

duplicateFound = False
For Each objProcess in colProcesses
    If InStr(objProcess.CommandLine, "watch.ps1") > 0 Then
        duplicateFound = True
        Exit For
    End If
Next

If duplicateFound Then
    WScript.Echo "Watch 已經在運行中！"
    WScript.Quit 0
End If

Set WshShell = CreateObject("WScript.Shell")
psCommand = "powershell -ExecutionPolicy Bypass -File """ & scriptDir & "\watch.ps1"""
WshShell.Run psCommand, 0, False
WScript.Echo "Watch 已啟動"

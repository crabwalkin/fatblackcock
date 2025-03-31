cd %~dp0
AMIDEWINx64.EXE /SU %random%%random%
AMIDEWINx64.EXE /SS %random%%random%
AMIDEWINx64.EXE /SV "1.0"
AMIDEWINx64.EXE /CSK %random%%random%
AMIDEWINx64.EXE /CM  %random%%random%
AMIDEWINx64.EXE /SP "MS-7D22"
AMIDEWINx64.EXE /SM "."
AMIDEWINx64.EXE /SK %random%%random%
AMIDEWINx64.EXE /SF %random%%random%
AMIDEWINx64.EXE /BM "X470-gaming-plus"
AMIDEWINx64.EXE /BP "H510M-A PRO (MS-7D22)"
AMIDEWINx64.EXE /BV "1.0"
AMIDEWINx64.EXE /BT %random%%random%
AMIDEWINx64.EXE /BLC %random%%random%
AMIDEWINx64.EXE /PSN %random%%random%
AMIDEWINx64.EXE /PAT %random%%random%
AMIDEWINx64.EXE /PPN %random%%random%
AMIDEWINx64.EXE /CSK "Default string"
AMIDEWINx64.EXE /CS "Default string"
AMIDEWINx64.EXE /CV "1.0"
AMIDEWINx64.EXE /CM "X470-gaming-plus"
AMIDEWINx64.EXE /CA %random%%random%
AMIDEWINx64.EXE /CO "0000 0000h"
AMIDEWINx64.EXE /CT "03h"
AMIDEWINx64.EXE /IV "3.80"
AMIDEWINx64.EXE /IVN "American Megatrends International, LLC."
AMIDEWINx64.EXE /BS "%random%%random%"
cls
net stop winmgmt /y
net start winmgmt /y
sc stop winmgmt
timeout 1
sc start winmgmt
timeout 1
exit
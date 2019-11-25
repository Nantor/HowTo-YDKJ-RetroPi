# How to install and configure "You don't know Jack" on RetropPi (Linux-Distribution). (WIP)

This is a guid, that explain...

+ install dosBox
+ move all files of the Windows 3.1 / 3.11 instalation in a seperat folder
+ create seperate c drive folder
+ run dosbox: dosbox -c "mount c /.../c" -c "mount d /.../windows"
+ install windows on c: name retropi (install minimal)
+ exit dosbox 
+ save c drive folder in zip for backup (also a fresh windows 3.1 / 3.11 installation for other usage)
+ dosbox c/AUTOEXEC.BAT -c "mount c /home/pinki/windows/c" -c "c:" -c "cd WINDOWS" -c "WIN.COM" -c "exit"
+ dosbox -c "mount c /home/pi/dosbox/c" -c "mount d /home/pi/dosbox/install/games/YDKJ/" -c "c:" -c "cd WINDOWS" -c "WIN.COM" -c "exit"

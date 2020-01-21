# How to install and configure "You don't know Jack" on RetropPi (Linux-Distribution). (WIP)

This is a guid, that explain...

+ install dosBox
+ goto "~/RetroPie/roms/pc/"
+ create a folder for the game like "ydkj" and go into it
+ copy from "~/.dosbox" the ".conf"-file to here 
+ create seperate "c" drive folder (e.g. "c")
+ move all files of the Windows 3.1 / 3.11 instalation in a seperat folder in the "c" folder (e.g "win31")
+ move installation files for YDKJ in seperat folder (e.g. "ydkj") next to the "c" folder
+ download sound/video driver: https://www.classicdosgames.com/drivers.html
+ move all audio driver files in a seperat folder in the "c" folder (e.g "sb16")
+ move all video driver files in a seperat folder in the "c" folder (e.g "s3")
+ run dosbox: dosbox -c "mount c /path/to/c-folder" -c "mount d /path/to/win31-folder"
+ install windows on c: name retropi (install minimal)
+ exit dosbox 
+ save c drive folder in zip for backup (also a fresh windows 3.1 / 3.11 installation for other usage)
+ dosbox c/AUTOEXEC.BAT -c "mount c /home/pi/windows/c" -c "c:" -c "cd WINDOWS" -c "WIN.COM" -c "exit"
+ dosbox -c "mount c /home/pi/dosbox/c" -c "mount d /home/pi/dosbox/install/games/YDKJ/" -c "c:" -c "cd WINDOWS" -c "WIN.COM" -c "exit"
+ install guide: https://www.howtogeek.com/230359/how-to-install-windows-3.1-in-dosbox-set-up-drivers-and-play-16-bit-games/
+ 
+ winexit: http://www.calmira.net/tips/index.htm

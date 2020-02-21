# How to install and configure "You don't know Jack" on RetropPi (Raspberry Pi). (WIP)

This is a guid, that explain how to install the game _You don't know Jack_ on RetroPi (Raspberry Pi).
This also include to configure the special intros and setup the use of the buzzers from the game _Buzz_.

To install YDKJ on the RetroPi, an X Server is needed. The easiest way is to start a the terminal directly without SSH.

If there no way to do it on the RetroPi it self, then SHH Session needed to prepared.

This are the basic steps to do it:

>X11 forwarding needs to be enabled on both the client side and the server side.
>
>On the __client side__, the `-X` (capital X) option to ssh enables X11 forwarding, and you can make this the default (for all connections or for a specific conection) with `ForwardX11 yes` in [`~/.ssh/config`](http://man.openbsd.org/OpenBSD-current/man5/ssh_config.5#ForwardX11).
>
>On the __server side__, `X11Forwarding yes` must specified in [`/etc/ssh/sshd_config`](http://man.openbsd.org/OpenBSD-current/man5/sshd_config.5#X11Forwarding). Note that the default is no forwarding (some distributions turn it on in their default `/etc/ssh/sshd_config`), and that the user cannot override this setting.
>
>The `xauth` program must be installed on the server side. If there are any X11 programs there, it's very likely that `xauth` will be there. In the unlikely case `xauth` was installed in a nonstandard location, it can be called through [`~/.ssh/rc`](http://man.openbsd.org/OpenBSD-current/man8/sshd.8#SSHRC) (on the server!).
>
>Note that you do not need to set any environment variables on the server. `DISPLAY` and `XAUTHORITY` will automatically be set to their proper values. If you run ssh and `DISPLAY` is not set, it means ssh is not forwarding the X11 connection.
>
>To confirm that ssh is forwarding X11, check for a line containing `Requesting X11 forwarding` in the `ssh -v -X` output. Note that __the server won't__ reply either way, a security precaution of hiding details from potential attackers.
>
>[stackexchange](https://unix.stackexchange.com/a/12772)

## Preparation

Before starting the installation process, a valid installation files for _Windows 3.1/3.11_ and _You don't know Jack_ are needed. This will shipt with this guide.

## Semiautomatically installation

1. Clone this Repo to a location of your choice, for example the home folder.

   ```bash
    clone https://github.com/Nantor/HowTo-YDKJ-RetroPi.git YDKJ
    cd YDKJ
    ```

2. Set the execution flag for the `setup.sh`.

    ```bash
    chmod +x setup.sh
    ```

3. Create a `win31` folder for _Windows 3.1/3.11_ installation files in the `install` folder and copy the installation files from all the disks into that folder.

    ```bash
    mkdir install/win31
    ```

4. create a `YDKJ` folder for the _You don't know Jack_ installation files in the `install` folder and copy the installation files into that folder.

    ```bash
    mkdir install/YDKJ
    ```

5. The installation script can now executed, there different options that can be set:

    ```text
    Usage of ./setup.sh:
        -h|--help         Display this help message.
        -w|--win          Run with Windows 3.1/3.11 installation.
        -s|--script       Run with Windows 3.1/3.11 automated installation.
        -a|--audio        Run with audio driver installation.
        -v|--video        Run with video driver installation.
        -b|--buzz [lang]  Setup Buzz Controller for Players.
        -u|--update       Add Script to run special intros.
        -c|--clear        Clear (previous) installation before start. No installation will happen.
    ```

### Note

On each Installation step a zip-Backup will be made from the c folder. So its possible to rollback if something went wrong later.

For the game are at least 256 colors need. Some times the installation will stuck on the video driver cause of missing installation drive, but it seams that can be ignored. Just abort the installation at this point and select the driver on the next try from the drivers from list of installed drivers. It should be there now.

<!-- 
+ install dosBox
+ goto "~/RetroPie/roms/pc/"
+ create a folder for the game like "ydkj" and go into it
+ copy from "~/.dosbox" the ".conf"-file to here 
+ create seperate "c" drive folder (e.g. "c")
+ move all files of the Windows 3.1 / 3.11 instalation in a seperat folder in the "c" folder (e.g "win31")
+ move installation files for YDKJ in seperat folder (e.g. "ydkj") next to the "c" folder
+ download sound/video driver: <https://www.classicdosgames.com/drivers.html>
+ move all audio driver files in a seperat folder in the "c" folder (e.g "sb16")
+ move all video driver files in a seperat folder in the "c" folder (e.g "s3")
+ run dosbox: dosbox -c "mount c /path/to/c-folder" -c "mount d /path/to/win31-folder"
+ install windows on c: name retropi (install minimal)
+ exit dosbox 
+ save c drive folder in zip for backup (also a fresh windows 3.1 / 3.11 installation for other usage)
+ dosbox c/AUTOEXEC.BAT -c "mount c /home/pi/windows/c" -c "c:" -c "cd WINDOWS" -c "WIN.COM" -c "exit"
+ dosbox -c "mount c /home/pi/dosbox/c" -c "mount d /home/pi/dosbox/install/games/YDKJ/" -c "c:" -c "cd WINDOWS" -c "WIN.COM" -c "exit"
+ install guide: <https://www.howtogeek.com/230359/how-to-install-windows-3.1-in-dosbox-set-up-drivers-and-play-16-bit-games/>
+
+ winexit: <http://www.calmira.net/tips/index.htm> -->

#!/bin/bash
# saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo 'I’m sorry, `getopt --test` failed in this environment.'
    exit 1
fi

PROGNAME=$0

# DOSBOX variable
DOSBOX=/opt/retropie/emulators/dosbox/bin/dosbox

# install paths
CURRENT=$PWD
C=$CURRENT/c
INSTALL=$CURRENT/install
INSTALL_WIN=$INSTALL/win31
INSTALL_YDKJ=$INSTALL/YDKJ
INSTALL_AUDIO=$INSTALL/driver/audio
INSTALL_VIDEO=$INSTALL/driver/video

RETRO_PI_RUN_FOLDER=~/RetroPie/roms/pc
RUN_SCRIPT=$RETRO_PI_RUN_FOLDER/You\ don\'t\ know\ Jack.sh

# Install switches 
WIN=false
SCRIPT=false
AUDIO=false
VIDEO=false
BUZZ=""
UPDATE=false
CLEAR=false

OPTIONS=wsavb:uch
LONGOPTS=win,script,audio,video,buzz:,update,clear,help
# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via -- "$@" to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$PROGNAME" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    # e.g. return value is 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

while true; do
    case $1 in
        (-w|--win)
            WIN=true;
            shift;;
        (-s|--script)
            WIN=true;
            SCRIPT=true;
            shift;;
        (-a|--audio)
            AUDIO=true;
            shift;;
        (-v|--video)
            VIDEO=true;
            shift;;
        (-b|--buzz)
            BUZZ="$2";
            shift 2;;
        (-u|--update)
            UPDATE=true;
            shift;;
        (-c|--clear)
            CLEAR=true;
            shift;;
        (-h|--help)
            echo "Usage of $PROGNAME:"
            echo "    -h|--help         Display this help message."
            echo "    -w|--win          Run with Windows 3.1/3.11 installation."
            echo "    -s|--script       Run with Windows 3.1/3.11 automated installation."
            echo "    -a|--audio        Run with audio driver installation."
            echo "    -v|--video        Run with video driver installation."
            echo "    -b|--buzz [lang]  Setup Buzz Controller for Players."
            echo "    -u|--update       Add Script to run special intros."
            echo "    -c|--clear        Clear (previous) installation before start. No installation will happen."
            exit 0;;
        (--)
            shift;
            break;;
        (*)
            echo "Wrong parrameter: $1"
            echo "Usage of $PROGNAME:"
            echo "    -h|--help         Display this help message."
            echo "    -w|--win          Run with Windows 3.1/3.11 installation."
            echo "    -s|--script       Run with Windows 3.1/3.11 automated installation."
            echo "    -a|--audio        Run with audio driver installation."
            echo "    -v|--video        Run with video driver installation."
            echo "    -b|--buzz [lang]  Setup Buzz Controller for Players."
            echo "    -u|--update       Add Script to run special intros."
            echo "    -c|--clear        Clear (previous) installation before start. No installation will happen."
            exit 1;;           # error
    esac
done

if $CLEAR; then
    echo "remove WINDOWS and YDKJ files and configuration files."
    rm -Rf $C/WINDOWS $C/YDKJ $C/SB16 $C/AUTOEXEC.* $C/CONFIG.* $CURRENT/YDKJ.conf $RUN_SCRIPT
    exit
fi

if [ ! -f $INSTALL_YDKJ/SETUP.EXE ]; then
    echo "Copy all YDKJ installation files into the folder '$INSTALL_YDKJ/'."
    exit 1
fi

# create a custom dosbox configuration file based on the default
cp -f ~/.dosbox/dosbox*.conf YDKJ.conf

if $WIN; then
    # check for installation files
    if [ ! -f $INSTALL_WIN/DISK1 -o ! -f $INSTALL_WIN/DISK2 -o ! -f $INSTALL_WIN/DISK3 -o ! -f $INSTALL_WIN/DISK4 -o ! -f $INSTALL_WIN/DISK5 -o ! -f $INSTALL_WIN/DISK6 ]; then
        echo "Copy all Windows 3.1/3.11 installation files from all DISKs into the folder 'install/win31/'."
        exit 1
    fi

    # trigger the automated or the manual installation for windows 3.1/3.11
    if $SCRIPT; then
        echo "automatically installing windows, check if effery thing is ok before going on."
        patch -u --binary $INSTALL_WIN/SETUP.SHH -i $INSTALL/SETUP.SHH.patch
        $DOSBOX -conf YDKJ.conf -c "mount c c" -c "mount d $INSTALL_WIN" -c "D:" -c "SETUP.EXE /H SETUP.SHH"-c "exit"
    else
        echo "manually installing windows"
        $DOSBOX -conf YDKJ.conf -c "mount c c" -c "mount d $INSTALL_WIN" -c "D:" -c "SETUP.EXE"-c "exit"
    fi

    # make a backup
    echo "Backup system after Windows installation ..."
    rm -f "WIN installation Backup.zip"
    zip -9rq "WIN installation Backup.zip" c
    echo "done"
    echo
else
    if [ ! -f $C/WINDOWS/WIN.COM ]; then
        echo "No Windows 3.1/3.11 installation found under '$C/WINDOWS'."
        exit 1
    fi
fi

if $AUDIO; then
    echo "Install audio driver (manually) ..."
    $DOSBOX -conf YDKJ.conf -c "mount c c" -c "mount d $INSTALL_AUDIO" -c "D:" -c "INSTALL.EXE"-c "exit"
    echo "done"
    echo

    echo "Backup system after audio driver installation ..."
    rm -f "AUDIO installation Backup.zip"
    zip -9rq "AUDIO installation Backup.zip" c
    echo "done"
    echo
fi

if $VIDEO; then
    echo "Install video driver (manually) ..."
    $DOSBOX -conf YDKJ.conf -c "mount c c" -c "mount d $INSTALL_WIN" -c "mount e $INSTALL_VIDEO" -c "C:" -c "cd WINDOWS" -c "SETUP"-c "exit"
    echo "done"
    echo

    echo "Backup system after video driver installation ..."
    rm -f "VIDEO installation Backup.zip"
    zip -9rq "VIDEO installation Backup.zip" c
    echo "done"
    echo
fi

if [ -n $BUZZ ]; then
    echo "Clone the Buzz controller Repo ..."
    git clone https://github.com/Nantor/BUZZ-to-YDKJ.git buzz
    chmod +x buzz/setup.sh
    cd buzz
    echo "done"
    echo

    echo "Setup Buzz controller ..."
    setup.sh
    if [ $? -ne 0]; then
        echo "setting up the 'Buzzer' controller, was not successful."
        exit 1
    fi
    cd ..
    echo "done"
    echo
fi

if $UPDATE; then
    echo "add script to set correct intro"
    git clone https://github.com/Nantor/setup-dosbox-YDKJ.git update
echo "done"
echo
fi

echo "Install YDKJ (manually) ..."
$DOSBOX -conf YDKJ.conf -c "mount c c" -c "mount d $INSTALL_YDKJ" -c "C:" -c "call C:\\AUTOEXEC.BAT" -c "call C:\\WINDOWS\\WIN.com /3 D:\\SETUP.EXE"-c "exit"
echo "done"
echo

echo "Backup system after YDKJ installation ..."
rm -f "YDKJ installation Backup.zip"
zip -9rq "YDKJ installation Backup.zip" c
echo "done"
echo

echo "Setup automatically startup ..."
patch -u --binary $C/WINDOWS/WIN.INI -i $INSTALL/WIN.INI.patch
mkdir -p $CURRENT/logs
echo "done"
echo

echo "Modify dosbox script ..."
cat >> YDKJ.conf << EOF
mount c $C
mount d $CURRENT/install/YDKJ
C:
call C:\\AUTOEXEC.BAT
call C:\\WINDOWS\\WIN.com /3 :
exit
EOF
echo "done"
echo

echo "Build run script ..."
rm -f "$RUN_SCRIPT"
cat > "$RUN_SCRIPT" << EOF
#!/bin/bash

find "$CURRENT/logs/" -name "*.log" -mtime +10 type f -delete

LOG=$CURRENT/logs/\$(date -Idate).log
echo >> "\$LOG"
date >> "\$LOG"
echo >> "\$LOG"

EOF

if [ -n $BUZZ ]; then
    cat >> "$RUN_SCRIPT" << EOF
# start python script to run Buzz controller mapper in background
sudo python3 "$CURRENT/buzz/buzz.py" >> "\$LOG" 2>&1 &

EOF
fi

if $UPDATE; then
    cat >> "$RUN_SCRIPT" << EOF
# set the corresponding intro for the current day
python3 "$CURRENT/update/YDKJ-setup.py" $UPDATE --today "$C/YDKJ" >> "\$LOG" 2>&1

EOF
fi

cat >> "$RUN_SCRIPT" << EOF
# start the game
$DOSBOX -conf "$CURRENT/YDKJ.conf"-c "exit" >> "\$LOG" 2>&1

EOF

if [ -n $BUZZ ]; then
    cat >> "$RUN_SCRIPT" << EOF
# stop the Buzz controller mapper
rm -f "$CURRENT/buzz/buzz.pid" >> "\$LOG" 2>&1

EOF
fi
echo "done"
echo

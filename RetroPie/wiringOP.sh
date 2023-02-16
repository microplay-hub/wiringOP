#!/usr/bin/env bash

# This file is part of the microplay-hub
# Designs by Liontek1985
# for RetroPie and offshoot
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="wiringOP"
rp_module_desc="GPIO driver for OrangePi SBC-Boards"
rp_module_repo="git https://github.com/microplay-hub/wiringOP.git master"
rp_module_section="driver"
rp_module_flags="noinstclean !rpi !g1"

function sources_wiringOP() {
    gitPullOrClone
}

function depends_wiringOP() {
    local depends=(cmake)
     getDepends "${depends[@]}"
}

function sources_wiringOP() {
    if [[ -d "$md_inst" ]]; then
        git -C "$md_inst" reset --hard  # ensure that no local changes exist
    fi
    gitPullOrClone "$md_inst"
}

function install_wiringOP() {
    cd "$md_inst"
	./build clean
	./build
	rm -r "RetroPie/wiringOP.sh"
}

function remove_wiringOP() {
    cd "$md_inst"
    ./build uninstall
	rm -rf "$md_inst"
	rm -r "/etc/systemd/system/pushbuttons.service"
	rm -r "/usr/local/bin/pushbuttons.c"
	rm -r "/usr/local/bin/pushbuttons"
	cd "/usr/local/bin/"
	find . -name "*short.sh" -delete
	find . -name "*long.sh" -delete
}

function showgpio_wiringOP() {
    gpio readall
	sleep 10
}

function h616-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi Zero2 - Allwinner H616"
	cp -r "pushbuttons/pushbuttons_h616.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run8short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run9short.sh"
	chmod 755 "/usr/local/bin/run8short.sh"
	chmod 755 "/usr/local/bin/run9short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 8 in
	gpio mode 9 in
	gpio write 8 1
	gpio write 9 1
}

function h3-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi One/Lite/Pc/Plus/PcPlus/Plus2e - Allwinner H3"
	cp -r "pushbuttons/pushbuttons_h3.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run29short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run33short.sh"
	chmod 755 "/usr/local/bin/run29short.sh"
	chmod 755 "/usr/local/bin/run33short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 29 in
	gpio mode 33 in
	gpio write 29 1
	gpio write 33 1
}


function h5-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi Pc 2 / PI Prime - Allwinner H5"
	cp -r "pushbuttons/pushbuttons_h5.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run29short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run33short.sh"
	chmod 755 "/usr/local/bin/run29short.sh"
	chmod 755 "/usr/local/bin/run33short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 29 in
	gpio mode 33 in
	gpio write 29 1
	gpio write 33 1
}

function h6p3-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi 3/3 LTS - Allwinner H6"
	cp -r "pushbuttons/pushbuttons_h6p3.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run8short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run10short.sh"
	chmod 755 "/usr/local/bin/run8short.sh"
	chmod 755 "/usr/local/bin/run10short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 8 in
	gpio mode 10 in
	gpio write 8 1
	gpio write 10 1
}

function h6olite-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi Lite2/OnePlus - Allwinner H6"
	cp -r "pushbuttons/pushbuttons_h6olite.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run8short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run10short.sh"
	chmod 755 "/usr/local/bin/run8short.sh"
	chmod 755 "/usr/local/bin/run10short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 8 in
	gpio mode 10 in
	gpio write 8 1
	gpio write 10 1
}

function rk3399pi4-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi 4/4B/4 LTS - Rockchip RK3399"
	cp -r "pushbuttons/pushbuttons_rk3399pi4.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run16short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run18short.sh"
	chmod 755 "/usr/local/bin/run16short.sh"
	chmod 755 "/usr/local/bin/run18short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 16 in
	gpio mode 18 in
	gpio write 16 1
	gpio write 18 1
}

function rk3399-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi 4/4B/4 LTS - Rockchip RK3399"
	cp -r "pushbuttons/pushbuttons_rk3399.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run16short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run18short.sh"
	chmod 755 "/usr/local/bin/run16short.sh"
	chmod 755 "/usr/local/bin/run18short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 16 in
	gpio mode 18 in
	gpio write 16 1
	gpio write 18 1
}

function h5-zerop-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi Zero Plus - Allwinner H5"
	cp -r "pushbuttons/pushbuttons_h5_zp.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run12short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run26short.sh"
	chmod 755 "/usr/local/bin/run12short.sh"
	chmod 755 "/usr/local/bin/run26short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 12 in
	gpio mode 26 in
	gpio write 12 1
	gpio write 26 1
}

function h5-zerop2-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi Zero Plus - Allwinner H5"
	cp -r "pushbuttons/pushbuttons_h5_zp2.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run12short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run26short.sh"
	chmod 755 "/usr/local/bin/run12short.sh"
	chmod 755 "/usr/local/bin/run26short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 12 in
	gpio mode 26 in
	gpio write 12 1
	gpio write 26 1
}

function h3-zerop2-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi Zero Plus2 - Allwinner H3"
	cp -r "pushbuttons/pushbuttons_h3_zp2.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run12short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run26short.sh"
	chmod 755 "/usr/local/bin/run12short.sh"
	chmod 755 "/usr/local/bin/run26short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 12 in
	gpio mode 26 in
	gpio write 12 1
	gpio write 26 1
}

function a64-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board Orange Pi Zero Plus2 - Allwinner H3"
	cp -r "pushbuttons/pushbuttons_a64.c"  "/usr/local/bin/pushbuttons.c"
	echo "copy short Button Scripts"
	cp -r "pushbuttons/power.sh"  "/usr/local/bin/run29short.sh"
	cp -r "pushbuttons/reset.sh"  "/usr/local/bin/run33short.sh"
	chmod 755 "/usr/local/bin/run29short.sh"
	chmod 755 "/usr/local/bin/run33short.sh"
	echo "set GPIO Buttonmod"
	gpio mode 29 in
	gpio mode 33 in
	gpio write 29 1
	gpio write 33 1
}

function compile-scinst_wiringOP() {
	echo "compile Button Script"
	cd /usr/local/bin/
	gcc -o pushbuttons pushbuttons.c -lwiringPi -lwiringPiDev -lpthread
	chmod 755 "/usr/local/bin/pushbuttons"
}

function testsc_wiringOP() {
	echo "start the time (60 seconds) please push the Button to test the function"
	cd /usr/local/bin/
	sudo ./pushbuttons
	sleep 60
}

function autostart-on_wiringOP() {
	sudo systemctl enable pushbuttons
}

function autostart-off_wiringOP() {
	sudo systemctl disable pushbuttons
}

function press-mod_wiringOP() {
	find . -name "*long.sh" | sed -e "p;s/long.sh/short.sh/" | xargs -n2 mv
}

function hold-mod_wiringOP() {
	find . -name "*short.sh" | sed -e "p;s/short.sh/long.sh/" | xargs -n2 mv
} 

function short-del_wiringOP() {
	cd "/usr/local/bin/"
	find . -name "*short.sh" -delete
}

function long-del_wiringOP() {
	cd "/usr/local/bin/"
	find . -name "*long.sh" -delete
}

function power-del_wiringOP() {
	cd "/usr/local/bin/"
	find . -name "run8*" -delete
	find . -name "run12*" -delete
	find . -name "run16*" -delete
	find . -name "run29*" -delete
}

function reset-del_wiringOP() {
	cd "/usr/local/bin/"
	find . -name "run9*" -delete
	find . -name "run10*" -delete
	find . -name "run18*" -delete
	find . -name "run26*" -delete
	find . -name "run33*" -delete
}

function cleaning-sc_wiringOP() {
	sudo systemctl disable pushbuttons
	rm -r "/etc/systemd/system/pushbuttons.service"
	rm -r "/usr/local/bin/pushbuttons.c"
	rm -r "/usr/local/bin/pushbuttons"
}

function button-scinst_wiringOP() {
	echo "install Service Script"
	cp -r "pushbuttons/pushbuttons.service"  "/etc/systemd/system/pushbuttons.service"
				
	echo "set chmod"
	chmod 755 "/usr/local/bin/pushbuttons.c"
	chmod 755 "/etc/systemd/system/pushbuttons.service"		

}

function gui_wiringOP() {
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local options=(
        1 "Show my GPIO Pins (10sec)"
        10 "Install Safebuttons (H616 Zero2)"
        11 "Install Safebuttons (H3 PC/One/Lite)"
        12 "Install Safebuttons (H5 PC2/Prime)"
        13 "Install Safebuttons (H6 Pi3)"
        14 "Install Safebuttons (RK3399 Pi4)"
        15 "Install Safebuttons (RK3399)"
        16 "Install Safebuttons (H5 Zero+)"
        17 "Install Safebuttons (H5 Zero+2)"
        18 "Install Safebuttons (H3 Zero+2)"
        19 "Install Safebuttons (A64 Win/WinP)"
        30 "Starting Buttontest (60sec)"
        31 "Activate Autostart Service (Buttons)"
        32 "Deactivate Autostart Service (Buttons)"
        40 "Set-SafeButtons on Press-Mod (Short)"
        41 "Set-SafeButtons on Hold-Mod (Long)"
        42 "Deactivate Power SafeButton"
        43 "Deactivate Reset SafeButton"
        44 "Activate all SafeButtons"
        98 "Uninstall SafeButtons and Services"
        99 "Reboot System"
    )
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        case "$choice" in
            1)
				showgpio_wiringOP
                printMsgs "dialog" "Show my GPIO Pins \n\nto see it longer open the command line and type\n\ngpio readall"
                ;;
            10)
				h616-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "H616 Orange Pi Zero2 Buttonscript installed \n\Powerbutton PIN15 named PC8 \n\Resetbutton PIN16 named PC9 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            11)
				h3-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "H3 Orange Pi One/Lite/Pc/Plus/PcPlus/Plus2e Buttonscript installed \n\Powerbutton PIN29 named PA07 \n\Resetbutton PIN33 named PA09 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            12)
				h5-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "H5 Orange Pi PC2, Prime Buttonscript installed \n\Powerbutton PIN29 named PA07 \n\Resetbutton PIN33 named PA09 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            13)
				h6p3-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "H6 Orange Pi 3, 3LTS Buttonscript installed \n\Powerbutton PIN8 named PL02 \n\Resetbutton PIN10 named PL03 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            14)
				h6olite-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "H6 Orange Pi One/Lite2 Buttonscript installed \n\Powerbutton PIN8 named PD21 \n\Resetbutton PIN10 named PD22 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            14)
				rk3399pi4-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "rk3399 Orange Pi4 Buttonscript installed \n\Powerbutton PIN16 named GPIO1_C6 \n\Resetbutton PIN18 named GPIO1_C7 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            15)
				rk3399-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "rk3399 Buttonscript installed \n\Powerbutton PIN16 named GPIO23 \n\Resetbutton PIN18 named GPIO24 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            16)
				h5-zerop-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "H5 Orange Pi Zero Plus Buttonscript installed \n\Powerbutton PIN12 named PA07 \n\Resetbutton PIN26 named PA10 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            17)
				h5-zerop2-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "H5 Orange Pi Zero Plus 2 Buttonscript installed \n\Powerbutton PIN12 named PD11 \n\Resetbutton PIN26 named PD14 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            18)
				h3-zerop2-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "H3 Orange Pi Zero Plus2 Buttonscript installed \n\Powerbutton PIN12 named PD11 \n\Resetbutton PIN26 named PD14 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            19)
				a64-scinst_wiringOP
				button-scinst_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "A64 Orange Pi Win/Winplus Buttonscript installed \n\Powerbutton PIN29 named PB04 \n\Resetbutton PIN33 named PB06 \n\ use the Buttontest to check the function \n\ use the Autostartfunction to add the script as service to autostart"
                ;;
            30)
				testsc_wiringOP
                printMsgs "dialog" "Testtime is over, try again if you want"
                ;;
            31)
				autostart-on_wiringOP
                printMsgs "dialog" "Autostart activated"
                ;;
            32)
				autostart-off_wiringOP
                printMsgs "dialog" "Autostart deactivated"
                ;;
            40)
				press-mod_wiringOP
                printMsgs "dialog" "Set Press SafeButtons (Short klick)"
                ;;
            41)
				hold-mod_wiringOP
                printMsgs "dialog" "Set Hold SafeButtons (Long hold)"
                ;;
            42)
				power-del_wiringOP
                printMsgs "dialog" "Deactivate Power SafeButton"
                ;;
            43)
				reset-del_wiringOP
                printMsgs "dialog" "Deactivate Reset SafeButton"
                ;;
            44)
                printMsgs "dialog" "Choose your Board and Install the SafeButtons new \n\with Options 10-29"
                ;;
            98)
				cleaning-sc_wiringOP
				short-del_wiringOP
				long-del_wiringOP
                printMsgs "dialog" "SafeButtons deactivated and uninstalled"
                ;;
            99)
			#Reboot System
				echo "...Rebooting System"
				/usr/bin/sudo /sbin/reboot
				;;
				
        esac
    fi
}
#!/usr/bin/env bash

# This file is part of the microplay-hub
#
# RetroPie WiringOP Button Config Script by Liontek1985
# for RetroPie and offshoot
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#
# v2.11 - 2023-02-19

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
	
    if [[ ! -f "$configdir/all/$md_id.cfg" ]]; then
        iniConfig "=" '"' "$configdir/all/$md_id.cfg"
        iniSet "AUTOSTART" "not-active"		
        iniSet "BOARD" "N/A"
        iniSet "BOARDNAME" "choose-me"
        iniSet "WOPPINS" "N/A"
        iniSet "ACTION1" "N/A"
        iniSet "ACTION2" "N/A"		
        iniSet "BUTTON1" "N/A"
        iniSet "BUTTON2" "N/A"
        iniSet "LONGSHORT1" "N/A"
        iniSet "LONGSHORT2" "N/A"
    fi
    chown $user:$user "$configdir/all/$md_id.cfg"
	chmod 755 "$configdir/all/$md_id.cfg"
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
    rm-r "$configdir/all/$md_id.cfg"
}

function showgpio_wiringOP() {
    gpio readall
	sleep 10
}

function set-scinst_wiringOP() {
	cd "$md_inst"
	echo "Set Board $boardname"
	
	cp -r "pushbuttons/pushbuttons_$board.c"  "/usr/local/bin/pushbuttons.c"
	
	echo "install Service Script"
	cp -r "pushbuttons/pushbuttons.service"  "/etc/systemd/system/pushbuttons.service"			
	echo "set chmod"
	chmod 755 "/usr/local/bin/pushbuttons.c"
	chmod 755 "/etc/systemd/system/pushbuttons.service"		
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

function configbuttons_wiringOP() {
	chown $user:$user "$configdir/all/$md_id.cfg"	
    iniConfig "=" '"' "$configdir/all/$md_id.cfg"	
}

function rebuild-b1_wiringOP() {
	cd "$md_inst"
	cp -r "pushbuttons/$action1.sh"  "/usr/local/bin/run$button1$longshort1.sh"
	chmod 755 "/usr/local/bin/run$button1$longshort1.sh"
	gpio mode $button1 in
	gpio write $button1 1
	
	sed -i "11s~.*~unsigned int WpiPinsSelection[] = {$button1,$button2};~" /usr/local/bin/pushbuttons.c

}

function rebuild-b2_wiringOP() {
	cd "$md_inst"
	cp -r "pushbuttons/$action2.sh"  "/usr/local/bin/run$button2$longshort2.sh"
	chmod 755 "/usr/local/bin/run$button2$longshort2.sh"
	gpio mode $button2 in
	gpio write $button2 1
	
	sed -i "11s~.*~unsigned int WpiPinsSelection[] = {$button1,$button2};~" /usr/local/bin/pushbuttons.c

} 

function changemod-b1_wiringOP() {
    options=(
        S "Button1 short-mod"
        L "Button1 long-mod"
		X "[current setting: $longshort1]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S)
            iniSet "LONGSHORT1" "short"
            ;;
        L)
            iniSet "LONGSHORT1" "long"
            ;;
    esac
}

function changemod-b2_wiringOP() {
    options=(
        S "Button2 short-mod"
        L "Button2 long-mod"
		X "[current setting: $longshort2]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S)
            iniSet "LONGSHORT2" "short"
            ;;
        L)
            iniSet "LONGSHORT2" "long"
            ;;
    esac
}

function changeaction-b1_wiringOP() {
    options=(
        S1 "Button1 Action Power(Safeshutdown)"
        L1 "Button1 Action Reset (Safereset)"
		Z1 "Button1 Action Custom (own script)"
		XX "(current setting: $action1)"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S1)
            iniSet "ACTION1" "power"
            ;;
        L1)
            iniSet "ACTION1" "reset"
            ;;
        Z1)
            iniSet "ACTION1" "custom"
            ;;
    esac
}

function changeaction-b2_wiringOP() {
    options=(	
        S2 "Button2 Action Power (Safeshutdown)"
        L2 "Button2 Action Reset (Safereset)"
		Z1 "Button2 Action Custom (own script)"
		XX "[current setting: $action2]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S2)
            iniSet "ACTION2" "power"
            ;;
        L2)
            iniSet "ACTION2" "reset"
            ;;
        Z1)
            iniSet "ACTION2" "custom"
            ;;
    esac
}

function changeautostart_wiringOP() {
    options=(	
        A1 "Activate Autostart-Service"
        A2 "Deactivate Autostart-Service"
		XX "[current setting: $autostart]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        A1)
            iniSet "AUTOSTART" "active"
			sudo systemctl enable pushbuttons
            printMsgs "dialog" "Autostart-Service Activated"
            ;;
        A2)
            iniSet "AUTOSTART" "not-active"
			sudo systemctl disable pushbuttons
            printMsgs "dialog" "Autostart-Service Deactivated"
            ;;
    esac
}

function changeboard_wiringOP() {
    options=(
        0 "[current setting: $boardname]"	
        A "Orange Pi Zero2 (H616)"
        B "Orange Pi PC/One/Lite (H3)"
        C "Orange Pi PC2/Prime (H5)"
        D "Orange Pi 3/3 LTS (H6)"
        E "Orange Pi Lite2/OnePlus (H6)"
        F "Orange Pi 4/B/LTS (RK3399)"
        G "Orange Pi RK3399 (RK3399)"
        H "Orange Pi Zero Plus (H5)"
        I "Orange Pi Zero Plus (H5)"
        J "Orange Pi Zero Plus2 (H3)"
        K "Orange Pi Win/Win+ (A64)"
		
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        A)
		iniSet "BOARD" "h616"
		iniSet "BOARDNAME" "Orange Pi Zero2 (H616)"
		iniSet "WOPPINS" "20"
		iniSet "BUTTON1" "8"
		iniSet "BUTTON2" "9"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1	

		echo "Set Board $boardname"
            ;;
        B)
		iniSet "BOARD" "h3"
		iniSet "BOARDNAME" "Orange Pi PC/One/Lite (H3)"
		iniSet "WOPPINS" "27"
		iniSet "BUTTON1" "19"
		iniSet "BUTTON2" "22"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1

		echo "Set Board $boardname"
            ;;
        C)

		iniSet "BOARD" "h5"
		iniSet "BOARDNAME" "Orange Pi PC2/Prime (H5)"
		iniSet "WOPPINS" "27"
		iniSet "BUTTON1" "19"
		iniSet "BUTTON2" "22"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1

		echo "Set Board $boardname"
            ;;
        D)
		iniSet "BOARD" "h6p3"
		iniSet "BOARDNAME" "Orange Pi 3/3 LTS (H6)"
		iniSet "WOPPINS" "16"
		iniSet "BUTTON1" "3"
		iniSet "BUTTON2" "4"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1

		echo "Set Board $boardname"
            ;;
        E)
		iniSet "BOARD" "h6olite"
		iniSet "BOARDNAME" "Orange Pi Lite2/OnePlus (H6)"
		iniSet "WOPPINS" "16"
		iniSet "BUTTON1" "3"
		iniSet "BUTTON2" "4"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1

		echo "Set Board $boardname"
            ;;
        F)
		iniSet "BOARD" "rk3399pi4"
		iniSet "BOARDNAME" "Orange Pi 4/B/LTS (RK3399)"
		iniSet "WOPPINS" "18"
		iniSet "BUTTON1" "9"
		iniSet "BUTTON2" "10"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1

		echo "Set Board $boardname"
            ;;
        G)
		iniSet "BOARD" "rk3399"
		iniSet "BOARDNAME" "Orange Pi RK3399 (RK3399)"
		iniSet "WOPPINS" "27"
		iniSet "BUTTON1" "9"
		iniSet "BUTTON2" "10"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1

		echo "Set Board $boardname"
            ;;
        H)
		iniSet "BOARD" "h5_zp"
		iniSet "BOARDNAME" "Orange Pi Zero Plus (H5)"
		iniSet "WOPPINS" "16"
		iniSet "BUTTON1" "6"
		iniSet "BUTTON2" "16"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1

		echo "Set Board $boardname"
            ;;
        I)
		iniSet "BOARD" "h5_zp2"
		iniSet "BOARDNAME" "Orange Pi Zero Plus (H5)"
		iniSet "WOPPINS" "16"
		iniSet "BUTTON1" "6"
		iniSet "BUTTON2" "16"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1

		echo "Set Board $boardname"
            ;;
        J)
		iniSet "BOARD" "h3_zp2"
		iniSet "BOARDNAME" "Orange Pi Zero Plus2 (H3)"
		iniSet "WOPPINS" "27"
		iniSet "BUTTON1" "6"
		iniSet "BUTTON2" "16"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1

		echo "Set Board $boardname"
            ;;
        K)
		iniSet "BOARD" "a64"
		iniSet "BOARDNAME" "Orange Pi Win/Win+ (A64)"
		iniSet "WOPPINS" "27"
		iniSet "BUTTON1" "19"
		iniSet "BUTTON2" "22"
		iniSet "ACTION1" "power"
		iniSet "ACTION2" "reset"
		iniSet "LONGSHORT1" "short"
		iniSet "LONGSHORT2" "short"
	
		gpio mode $button1 in
		gpio mode $button2 in
		gpio write $button1 1
		gpio write $button2 1

		echo "Set Board $boardname"
            ;;
			
    esac
}

function cleaning-sc_wiringOP() {
	sudo systemctl disable pushbuttons
	rm -r "/etc/systemd/system/pushbuttons.service"
	rm -r "/usr/local/bin/pushbuttons.c"
	rm -r "/usr/local/bin/pushbuttons"
}


function gui_wiringOP() {
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)

        iniConfig "=" '"' "$configdir/all/$md_id.cfg"
		
        iniGet "BOARD"
        local board=${ini_value}
        iniGet "BOARDNAME"
        local boardname=${ini_value}
        iniGet "WOPPINS"
        local woppins=${ini_value}		
        iniGet "BUTTON1"
        local button1=${ini_value}
        iniGet "BUTTON2"
        local button2=${ini_value}
        iniGet "ACTION1"
        local action1=${ini_value}
        iniGet "ACTION2"
        local action2=${ini_value}
        iniGet "LONGSHORT1"
        local longshort1=${ini_value}
        iniGet "LONGSHORT2"
        local longshort2=${ini_value}
        iniGet "AUTOSTART"
        local autostart=${ini_value}

    local options=(
        0 "Show my GPIO Pins (10sec)"
    )
        options+=(
			XX "[[ Set my Board - now: $boardname ]]"
            A "// Button1 on PIN:$button1 [$action1-$longshort1-mod]"
            AE "***edit Button1 [Script]"
            AF "**change [Action:$action1]"
            AP "**change [WOP-PIN:$button1]"
            AM "**change [MOD:$longshort1]"
            AX "*reconfig new Button1"
            B "// Button2 on PIN:$button2 [$action2-$longshort2-mod]"
            BE "***edit Button2 [Script]"
            BF "**change [Action:$action2]"			
            BP "**change [WOP-PIN:$button2]"
            BM "**change [MOD:$longshort2]"
            BX "*reconfig new Button2"			
            )
        options+=(	
			C "Buttontest (60sec)"
			D "Change Autostart Service [$autostart]"
			ZA "Uninstall SafeButtons and Services"
			ZZ "Reboot System"
    )
	

		

	
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	
        iniConfig "=" '"' "$configdir/all/$md_id.cfg"
		
        iniGet "BOARD"
        local board=${ini_value}
        iniGet "BOARDNAME"
        local boardname=${ini_value}
        iniGet "WOPPINS"
        local woppins=${ini_value}		
        iniGet "BUTTON1"
        local button1=${ini_value}
        iniGet "BUTTON2"
        local button2=${ini_value}
        iniGet "ACTION1"
        local action1=${ini_value}
        iniGet "ACTION2"
        local action2=${ini_value}
        iniGet "LONGSHORT1"
        local longshort1=${ini_value}
        iniGet "LONGSHORT2"
        local longshort2=${ini_value}
        iniGet "AUTOSTART"
        local autostart=${ini_value}
	
    if [[ -n "$choice" ]]; then
        case "$choice" in
            0)
				showgpio_wiringOP
                printMsgs "dialog" "Show my GPIO Pins \n\nto see it longer open the command line and type\n\ngpio readall"
                ;;
            XX)
				configbuttons_wiringOP
				changeboard_wiringOP
				configbuttons_wiringOP
				set-scinst_wiringOP
				configbuttons_wiringOP
				rebuild-b1_wiringOP
				configbuttons_wiringOP
				rebuild-b2_wiringOP
				configbuttons_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "Set Board to $boardname ($board) with follow defaultconfig \nWOP-PINS:$woppins\nBUTTON1: WOP-PIN-$button1 Action-$action1 Mod-$longshort1\nBUTTON2: WOP-PIN-$button2 Action-$action2 Mod-$longshort2\nAutostart-Service: $autostart\nTest with Option C the Buttons\nTest successful\n than Set Autostart with Option D to Active"
                ;;
            A)
				editFile "/usr/local/bin/run$button1$longshort1.sh"
                ;;
            AE)
				editFile "/usr/local/bin/run$button1$longshort1.sh"
                ;;
            AF)
				configbuttons_wiringOP
				changeaction-b1_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option AX / BX \n reconfig activate the new Settings"
                ;;
			AP)				
				button1=$(dialog --title "Change PIN for Button1" --clear --rangebox "Configure your PIN for Button1" 0 60 5 $woppins $button1 2>&1 >/dev/tty)
                    if [[ -n "$button1" ]]; then
                        iniSet "BUTTON1" "${button1//[^[:digit:]]/}"
                    fi
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option AX / BX \n reconfig activate the new Settings"
                ;;	
			AM)
				configbuttons_wiringOP
				changemod-b1_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option AX / BX \n reconfig activate the new Settings"
                ;;
			AX)	
				configbuttons_wiringOP
				rebuild-b1_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "New Button1-Settings [PIN:$button1-$action1-$longshort1-mod] activated"
                ;;
            B)
				editFile "/usr/local/bin/run$button2$longshort2.sh"
                ;;
            BE)
				editFile "/usr/local/bin/run$button2$longshort2.sh"
                ;;
            BF)
				configbuttons_wiringOP
				changeaction-b2_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option AX / BX \n reconfig activate the new Settings"
                ;;
			BP)				
				button2=$(dialog --title "Change PIN for Button2" --clear --rangebox "Configure your PIN for Button2" 0 60 5 $woppins $button2 2>&1 >/dev/tty)
                    if [[ -n "$button2" ]]; then
                        iniSet "BUTTON2" "${button2//[^[:digit:]]/}"
                    fi
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option AX / BX \n reconfig activate the new Settings"
                ;;
			BM)	
				configbuttons_wiringOP
				changemod-b2_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option AX / BX \n reconfig activate the new Settings"
                ;;
			BX)	
				configbuttons_wiringOP
				rebuild-b2_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "New Button2-Settings [PIN:$button2-$action2-$longshort2-mod]  activated"
                ;;
            C)
				testsc_wiringOP
                printMsgs "dialog" "Testtime is over, try again if you want"
                ;;
            D)
				configbuttons_wiringOP
				changeautostart_wiringOP
                ;;
            ZA)
				cleaning-sc_wiringOP
                printMsgs "dialog" "SafeButtons deactivated and uninstalled"
                ;;
            ZZ)
			#Reboot System
				echo "...Rebooting System"
				/usr/bin/sudo /sbin/reboot
				;;
				
        esac
    fi
}
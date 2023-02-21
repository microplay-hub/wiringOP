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
# v2.2 - 2023-02-19
# up to 8 Buttons

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
        iniSet "BUTTONNUM" "0"
        iniSet "WOPPINS" "x"
        iniSet "ACTION1" "x"
        iniSet "ACTION2" "x"
        iniSet "ACTION3" "x"
        iniSet "ACTION4" "x"
        iniSet "ACTION5" "x"
        iniSet "ACTION6" "x"	
        iniSet "ACTION7" "x"
        iniSet "ACTION8" "x"	
        iniSet "BUTTON1" "x"
        iniSet "BUTTON2" "x"
        iniSet "BUTTON3" "x"
        iniSet "BUTTON4" "x"
        iniSet "BUTTON5" "x"
        iniSet "BUTTON6" "x"
        iniSet "BUTTON7" "x"
        iniSet "BUTTON8" "x"
        iniSet "LONGSHORT1" "x"
        iniSet "LONGSHORT2" "x"
        iniSet "LONGSHORT3" "x"
        iniSet "LONGSHORT4" "x"
        iniSet "LONGSHORT5" "x"
        iniSet "LONGSHORT6" "x"
        iniSet "LONGSHORT7" "x"
        iniSet "LONGSHORT8" "x"
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

function rebuild-1b_wiringOP() {
	cd "$md_inst"
	cp -r "pushbuttons/$action1.sh"  "/usr/local/bin/run$button1$longshort1.sh"
	chmod 755 "/usr/local/bin/run$button1$longshort1.sh"
	gpio mode $button1 in
	gpio write $button1 1

	sed -i "10s~.*~unsigned int nums = $buttonnum;~" /usr/local/bin/pushbuttons.c	
	sed -i "11s~.*~unsigned int WpiPinsSelection[] = {$button1,$button2,$button3};~" /usr/local/bin/pushbuttons.c

}

function rebuild-2b_wiringOP() {
	cd "$md_inst"
	cp -r "pushbuttons/$action1.sh"  "/usr/local/bin/run$button1$longshort1.sh"
	cp -r "pushbuttons/$action2.sh"  "/usr/local/bin/run$button2$longshort2.sh"
	chmod 755 "/usr/local/bin/run$button1$longshort1.sh"
	chmod 755 "/usr/local/bin/run$button2$longshort2.sh"
	gpio mode $button1 in
	gpio write $button1 1
	gpio mode $button2 in
	gpio write $button2 1

	sed -i "10s~.*~unsigned int nums = $buttonnum;~" /usr/local/bin/pushbuttons.c	
	sed -i "11s~.*~unsigned int WpiPinsSelection[] = {$button1,$button2,$button3};~" /usr/local/bin/pushbuttons.c

} 

function rebuild-3b_wiringOP() {
	cd "$md_inst"
	cp -r "pushbuttons/$action1.sh"  "/usr/local/bin/run$button1$longshort1.sh"
	cp -r "pushbuttons/$action2.sh"  "/usr/local/bin/run$button2$longshort2.sh"
	cp -r "pushbuttons/$action3.sh"  "/usr/local/bin/run$button3$longshort3.sh"
	chmod 755 "/usr/local/bin/run$button1$longshort1.sh"
	chmod 755 "/usr/local/bin/run$button2$longshort2.sh"
	chmod 755 "/usr/local/bin/run$button3$longshort3.sh"
	gpio mode $button1 in
	gpio write $button1 1
	gpio mode $button2 in
	gpio write $button2 1
	gpio mode $button3 in
	gpio write $button3 1

	sed -i "10s~.*~unsigned int nums = $buttonnum;~" /usr/local/bin/pushbuttons.c	
	sed -i "11s~.*~unsigned int WpiPinsSelection[] = {$button1,$button2,$button3};~" /usr/local/bin/pushbuttons.c

}

function rebuild-4b_wiringOP() {
	cd "$md_inst"
	cp -r "pushbuttons/$action1.sh"  "/usr/local/bin/run$button1$longshort1.sh"
	cp -r "pushbuttons/$action2.sh"  "/usr/local/bin/run$button2$longshort2.sh"
	cp -r "pushbuttons/$action3.sh"  "/usr/local/bin/run$button3$longshort3.sh"
	cp -r "pushbuttons/$action4.sh"  "/usr/local/bin/run$button4$longshort4.sh"
	chmod 755 "/usr/local/bin/run$button1$longshort1.sh"
	chmod 755 "/usr/local/bin/run$button2$longshort2.sh"
	chmod 755 "/usr/local/bin/run$button3$longshort3.sh"
	chmod 755 "/usr/local/bin/run$button4$longshort4.sh"
	gpio mode $button1 in
	gpio write $button1 1
	gpio mode $button2 in
	gpio write $button2 1
	gpio mode $button3 in
	gpio write $button3 1
	gpio mode $button4 in
	gpio write $button4 1

	sed -i "10s~.*~unsigned int nums = $buttonnum;~" /usr/local/bin/pushbuttons.c	
	sed -i "11s~.*~unsigned int WpiPinsSelection[] = {$button1,$button2,$button3,$button4};~" /usr/local/bin/pushbuttons.c

} 

function rebuild-5b_wiringOP() {
	cd "$md_inst"
	cp -r "pushbuttons/$action1.sh"  "/usr/local/bin/run$button1$longshort1.sh"
	cp -r "pushbuttons/$action2.sh"  "/usr/local/bin/run$button2$longshort2.sh"
	cp -r "pushbuttons/$action3.sh"  "/usr/local/bin/run$button3$longshort3.sh"
	cp -r "pushbuttons/$action4.sh"  "/usr/local/bin/run$button4$longshort4.sh"
	cp -r "pushbuttons/$action5.sh"  "/usr/local/bin/run$button5$longshort5.sh"
	
	chmod 755 "/usr/local/bin/run$button1$longshort1.sh"
	chmod 755 "/usr/local/bin/run$button2$longshort2.sh"
	chmod 755 "/usr/local/bin/run$button3$longshort3.sh"
	chmod 755 "/usr/local/bin/run$button4$longshort4.sh"
	chmod 755 "/usr/local/bin/run$button5$longshort5.sh"	
	
	gpio mode $button1 in
	gpio write $button1 1
	gpio mode $button2 in
	gpio write $button2 1
	gpio mode $button3 in
	gpio write $button3 1
	gpio mode $button4 in
	gpio write $button4 1
	gpio mode $button5 in
	gpio write $button5 1

	sed -i "10s~.*~unsigned int nums = $buttonnum;~" /usr/local/bin/pushbuttons.c	
	sed -i "11s~.*~unsigned int WpiPinsSelection[] = {$button1,$button2,$button3,$button4,$button5};~" /usr/local/bin/pushbuttons.c

}

function rebuild-6b_wiringOP() {
	cd "$md_inst"
	cp -r "pushbuttons/$action1.sh"  "/usr/local/bin/run$button1$longshort1.sh"
	cp -r "pushbuttons/$action2.sh"  "/usr/local/bin/run$button2$longshort2.sh"
	cp -r "pushbuttons/$action3.sh"  "/usr/local/bin/run$button3$longshort3.sh"
	cp -r "pushbuttons/$action4.sh"  "/usr/local/bin/run$button4$longshort4.sh"
	cp -r "pushbuttons/$action5.sh"  "/usr/local/bin/run$button5$longshort5.sh"
	cp -r "pushbuttons/$action6.sh"  "/usr/local/bin/run$button6$longshort6.sh"
	
	chmod 755 "/usr/local/bin/run$button1$longshort1.sh"
	chmod 755 "/usr/local/bin/run$button2$longshort2.sh"
	chmod 755 "/usr/local/bin/run$button3$longshort3.sh"
	chmod 755 "/usr/local/bin/run$button4$longshort4.sh"
	chmod 755 "/usr/local/bin/run$button5$longshort5.sh"	
	chmod 755 "/usr/local/bin/run$button6$longshort6.sh"
	
	gpio mode $button1 in
	gpio write $button1 1
	gpio mode $button2 in
	gpio write $button2 1
	gpio mode $button3 in
	gpio write $button3 1
	gpio mode $button4 in
	gpio write $button4 1
	gpio mode $button5 in
	gpio write $button5 1
	gpio mode $button6 in
	gpio write $button6 1

	sed -i "10s~.*~unsigned int nums = $buttonnum;~" /usr/local/bin/pushbuttons.c	
	sed -i "11s~.*~unsigned int WpiPinsSelection[] = {$button1,$button2,$button3,$button4,$button5,$button6};~" /usr/local/bin/pushbuttons.c

} 

function rebuild-7b_wiringOP() {
	cd "$md_inst"
	cp -r "pushbuttons/$action1.sh"  "/usr/local/bin/run$button1$longshort1.sh"
	cp -r "pushbuttons/$action2.sh"  "/usr/local/bin/run$button2$longshort2.sh"
	cp -r "pushbuttons/$action3.sh"  "/usr/local/bin/run$button3$longshort3.sh"
	cp -r "pushbuttons/$action4.sh"  "/usr/local/bin/run$button4$longshort4.sh"
	cp -r "pushbuttons/$action5.sh"  "/usr/local/bin/run$button5$longshort5.sh"
	cp -r "pushbuttons/$action6.sh"  "/usr/local/bin/run$button6$longshort6.sh"
	cp -r "pushbuttons/$action7.sh"  "/usr/local/bin/run$button7$longshort7.sh"
	
	chmod 755 "/usr/local/bin/run$button1$longshort1.sh"
	chmod 755 "/usr/local/bin/run$button2$longshort2.sh"
	chmod 755 "/usr/local/bin/run$button3$longshort3.sh"
	chmod 755 "/usr/local/bin/run$button4$longshort4.sh"
	chmod 755 "/usr/local/bin/run$button5$longshort5.sh"	
	chmod 755 "/usr/local/bin/run$button6$longshort6.sh"
	chmod 755 "/usr/local/bin/run$button7$longshort7.sh"
	
	gpio mode $button1 in
	gpio write $button1 1
	gpio mode $button2 in
	gpio write $button2 1
	gpio mode $button3 in
	gpio write $button3 1
	gpio mode $button4 in
	gpio write $button4 1
	gpio mode $button5 in
	gpio write $button5 1
	gpio mode $button6 in
	gpio write $button6 1
	gpio mode $button7 in
	gpio write $button7 1

	sed -i "10s~.*~unsigned int nums = $buttonnum;~" /usr/local/bin/pushbuttons.c	
	sed -i "11s~.*~unsigned int WpiPinsSelection[] = {$button1,$button2,$button3,$button4,$button5,$button6,$button7};~" /usr/local/bin/pushbuttons.c

} 

function rebuild-8b_wiringOP() {
	cd "$md_inst"
	cp -r "pushbuttons/$action1.sh"  "/usr/local/bin/run$button1$longshort1.sh"
	cp -r "pushbuttons/$action2.sh"  "/usr/local/bin/run$button2$longshort2.sh"
	cp -r "pushbuttons/$action3.sh"  "/usr/local/bin/run$button3$longshort3.sh"
	cp -r "pushbuttons/$action4.sh"  "/usr/local/bin/run$button4$longshort4.sh"
	cp -r "pushbuttons/$action5.sh"  "/usr/local/bin/run$button5$longshort5.sh"
	cp -r "pushbuttons/$action6.sh"  "/usr/local/bin/run$button6$longshort6.sh"
	cp -r "pushbuttons/$action7.sh"  "/usr/local/bin/run$button7$longshort7.sh"
	cp -r "pushbuttons/$action8.sh"  "/usr/local/bin/run$button8$longshort8.sh"
	
	chmod 755 "/usr/local/bin/run$button1$longshort1.sh"
	chmod 755 "/usr/local/bin/run$button2$longshort2.sh"
	chmod 755 "/usr/local/bin/run$button3$longshort3.sh"
	chmod 755 "/usr/local/bin/run$button4$longshort4.sh"
	chmod 755 "/usr/local/bin/run$button5$longshort5.sh"	
	chmod 755 "/usr/local/bin/run$button6$longshort6.sh"
	chmod 755 "/usr/local/bin/run$button7$longshort7.sh"
	chmod 755 "/usr/local/bin/run$button8$longshort8.sh"
	
	gpio mode $button1 in
	gpio write $button1 1
	gpio mode $button2 in
	gpio write $button2 1
	gpio mode $button3 in
	gpio write $button3 1
	gpio mode $button4 in
	gpio write $button4 1
	gpio mode $button5 in
	gpio write $button5 1
	gpio mode $button6 in
	gpio write $button6 1
	gpio mode $button7 in
	gpio write $button7 1
	gpio mode $button8 in
	gpio write $button8 1

	sed -i "10s~.*~unsigned int nums = $buttonnum;~" /usr/local/bin/pushbuttons.c	
	sed -i "11s~.*~unsigned int WpiPinsSelection[] = {$button1,$button2,$button3,$button4,$button5,$button6,$button7,$button8};~" /usr/local/bin/pushbuttons.c

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

function changemod-b3_wiringOP() {
    options=(
        S "Button3 short-mod"
        L "Button3 long-mod"
		X "[current setting: $longshort3]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S)
            iniSet "LONGSHORT3" "short"
            ;;
        L)
            iniSet "LONGSHORT3" "long"
            ;;
    esac
}

function changemod-b4_wiringOP() {
    options=(
        S "Button4 short-mod"
        L "Button4 long-mod"
		X "[current setting: $longshort4]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S)
            iniSet "LONGSHORT4" "short"
            ;;
        L)
            iniSet "LONGSHORT4" "long"
            ;;
    esac
}

function changemod-b5_wiringOP() {
    options=(
        S "Button5 short-mod"
        L "Button5 long-mod"
		X "[current setting: $longshort5]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S)
            iniSet "LONGSHORT5" "short"
            ;;
        L)
            iniSet "LONGSHORT5" "long"
            ;;
    esac
}

function changemod-b6_wiringOP() {
    options=(
        S "Button6 short-mod"
        L "Button6 long-mod"
		X "[current setting: $longshort6]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S)
            iniSet "LONGSHORT6" "short"
            ;;
        L)
            iniSet "LONGSHORT6" "long"
            ;;
    esac
}

function changemod-b7_wiringOP() {
    options=(
        S "Button7 short-mod"
        L "Button7 long-mod"
		X "[current setting: $longshort7]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S)
            iniSet "LONGSHORT7" "short"
            ;;
        L)
            iniSet "LONGSHORT7" "long"
            ;;
    esac
}

function changemod-b8_wiringOP() {
    options=(
        S "Button8 short-mod"
        L "Button8 long-mod"
		X "[current setting: $longshort8]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S)
            iniSet "LONGSHORT8" "short"
            ;;
        L)
            iniSet "LONGSHORT8" "long"
            ;;
    esac
}

function changebuttonnum_wiringOP() {
    options=(
		B1 "1 Active-Button"
		B2 "2 Active-Buttons"
		B3 "3 Active-Buttons"
		B4 "4 Active-Buttons"
		B5 "5 Active-Buttons"
		B6 "6 Active-Buttons"
		B7 "7 Active-Buttons"
		B8 "8 Active-Buttons"
		X "[current active: $buttonnum Button(s)]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        B1)
            iniSet "BUTTONNUM" "1"
            ;;
        B2)
            iniSet "BUTTONNUM" "2"
            ;;
        B3)
            iniSet "BUTTONNUM" "3"
            ;;
        B4)
            iniSet "BUTTONNUM" "4"
            ;;
        B5)
            iniSet "BUTTONNUM" "5"
            ;;
        B6)
            iniSet "BUTTONNUM" "6"
            ;;
        B7)
            iniSet "BUTTONNUM" "7"
            ;;
        B8)
            iniSet "BUTTONNUM" "8"
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
		Z2 "Button2 Action Custom (own script)"
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
        Z2)
            iniSet "ACTION2" "custom"
            ;;
    esac
}

function changeaction-b3_wiringOP() {
    options=(	
        S3 "Button3 Action Power (Safeshutdown)"
        L3 "Button3 Action Reset (Safereset)"
		Z3 "Button3 Action Custom (own script)"
		XX "[current setting: $action3]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S3)
            iniSet "ACTION3" "power"
            ;;
        L3)
            iniSet "ACTION3" "reset"
            ;;
        Z3)
            iniSet "ACTION3" "custom"
            ;;
    esac
}

function changeaction-b4_wiringOP() {
    options=(	
        S4 "Button4 Action Power (Safeshutdown)"
        L4 "Button4 Action Reset (Safereset)"
		Z4 "Button4 Action Custom (own script)"
		XX "[current setting: $action4]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S4)
            iniSet "ACTION4" "power"
            ;;
        L4)
            iniSet "ACTION4" "reset"
            ;;
        Z4)
            iniSet "ACTION4" "custom"
            ;;
    esac
}


function changeaction-b5_wiringOP() {
    options=(	
        S5 "Button5 Action Power (Safeshutdown)"
        L5 "Button5 Action Reset (Safereset)"
		Z5 "Button5 Action Custom (own script)"
		XX "[current setting: $action5]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S5)
            iniSet "ACTION5" "power"
            ;;
        L5)
            iniSet "ACTION5" "reset"
            ;;
        Z5)
            iniSet "ACTION5" "custom"
            ;;
    esac
}

function changeaction-b6_wiringOP() {
    options=(	
        S6 "Button6 Action Power (Safeshutdown)"
        L6 "Button6 Action Reset (Safereset)"
		Z6 "Button6 Action Custom (own script)"
		XX "[current setting: $action6]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S6)
            iniSet "ACTION6" "power"
            ;;
        L6)
            iniSet "ACTION6" "reset"
            ;;
        Z6)
            iniSet "ACTION6" "custom"
            ;;
    esac
}

function changeaction-b7_wiringOP() {
    options=(	
        S7 "Button7 Action Power (Safeshutdown)"
        L7 "Button7 Action Reset (Safereset)"
		Z7 "Button7 Action Custom (own script)"
		XX "[current setting: $action7]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S7)
            iniSet "ACTION7" "power"
            ;;
        L7)
            iniSet "ACTION7" "reset"
            ;;
        Z7)
            iniSet "ACTION7" "custom"
            ;;
    esac
}

function changeaction-b8_wiringOP() {
    options=(	
        S8 "Button8 Action Power (Safeshutdown)"
        L8 "Button8 Action Reset (Safereset)"
		Z8 "Button8 Action Custom (own script)"
		XX "[current setting: $action8]"
    )
    local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option." 22 86 16)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        S8)
            iniSet "ACTION8" "power"
            ;;
        L8)
            iniSet "ACTION8" "reset"
            ;;
        Z8)
            iniSet "ACTION8" "custom"
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
			sudo systemctl daemon-reload
            printMsgs "dialog" "Autostart-Service Activated"
            ;;
        A2)
            iniSet "AUTOSTART" "not-active"
			sudo systemctl disable pushbuttons
			sudo systemctl daemon-reload
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
        iniSet "BUTTONNUM" "2"
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
        iniSet "BUTTONNUM" "2"
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
        iniSet "BUTTONNUM" "2"
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
        iniSet "BUTTONNUM" "2"
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
        iniSet "BUTTONNUM" "2"
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
        iniSet "BUTTONNUM" "2"
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
        iniSet "BUTTONNUM" "2"
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
        iniSet "BUTTONNUM" "2"
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
        iniSet "BUTTONNUM" "2"
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
        iniSet "BUTTONNUM" "2"
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
        iniSet "BUTTONNUM" "2"
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
        iniGet "BUTTONNUM"
        local buttonnum=${ini_value}	
        iniGet "WOPPINS"
        local woppins=${ini_value}		
        iniGet "BUTTON1"
        local button1=${ini_value}
        iniGet "BUTTON2"
        local button2=${ini_value}
        iniGet "BUTTON3"
        local button3=${ini_value}		
        iniGet "BUTTON4"
        local button4=${ini_value}		
        iniGet "BUTTON5"
        local button5=${ini_value}
        iniGet "BUTTON6"
        local button6=${ini_value}
        iniGet "BUTTON7"
        local button7=${ini_value}		
        iniGet "BUTTON8"
        local button8=${ini_value}		
        iniGet "ACTION1"
        local action1=${ini_value}
        iniGet "ACTION2"
        local action2=${ini_value}
        iniGet "ACTION3"
        local action3=${ini_value}		
        iniGet "ACTION4"
        local action4=${ini_value}		
        iniGet "ACTION5"
        local action5=${ini_value}
        iniGet "ACTION6"
        local action6=${ini_value}
        iniGet "ACTION7"
        local action7=${ini_value}		
        iniGet "ACTION8"
        local action8=${ini_value}		
        iniGet "LONGSHORT1"
        local longshort1=${ini_value}
        iniGet "LONGSHORT2"
        local longshort2=${ini_value}
        iniGet "LONGSHORT3"
        local longshort3=${ini_value}
        iniGet "LONGSHORT4"
        local longshort4=${ini_value}
        iniGet "LONGSHORT5"
        local longshort5=${ini_value}
        iniGet "LONGSHORT6"
        local longshort6=${ini_value}
        iniGet "LONGSHORT7"
        local longshort7=${ini_value}
        iniGet "LONGSHORT8"
        local longshort8=${ini_value}		
        iniGet "AUTOSTART"
        local autostart=${ini_value}

    local options=(
        0 "Show my GPIO Pins (10sec)"
    )
        options+=(
			XX "[[ Set my Board - now: $boardname ]]"
			XN "[ $buttonnum Active Buttons (change me)]"
			XR "[ reconfig all Active Buttons]"
            )

        if [[ "$buttonnum" >0 ]]; then
        options+=(			
            A "// Button1 on PIN:$button1 [$action1-$longshort1-mod]"
            AE "***edit Button1 [Script]"
            AF "**change [Action:$action1]"
            AP "**change [WOP-PIN:$button1]"
            AM "**change [MOD:$longshort1]"
            )
        fi

        if [[ "$buttonnum" >1 ]]; then
        options+=(
            B "// Button2 on PIN:$button2 [$action2-$longshort2-mod]"
            BE "***edit Button2 [Script]"
            BF "**change [Action:$action2]"			
            BP "**change [WOP-PIN:$button2]"
            BM "**change [MOD:$longshort2]"
            )
        fi

        if [[ "$buttonnum" >2 ]]; then
        options+=(
            C "// Button3 on PIN:$button3 [$action3-$longshort3-mod]"
            CE "***edit Button3 [Script]"
            CF "**change [Action:$action3]"			
            CP "**change [WOP-PIN:$button3]"
            CM "**change [MOD:$longshort3]"
            )
        fi

        if [[ "$buttonnum" >3 ]]; then
        options+=(
            D "// Button4 on PIN:$button4 [$action4-$longshort4-mod]"
            DE "***edit Button4 [Script]"
            DF "**change [Action:$action4]"			
            DP "**change [WOP-PIN:$button4]"
            DM "**change [MOD:$longshort4]"	
            )
        fi

        if [[ "$buttonnum" >4 ]]; then
        options+=(
            E "// Button5 on PIN:$button5 [$action5-$longshort5-mod]"
            EE "***edit Button5 [Script]"
            EF "**change [Action:$action5]"			
            EP "**change [WOP-PIN:$button5]"
            EM "**change [MOD:$longshort5]"
            )
        fi	

        if [[ "$buttonnum" >5 ]]; then
        options+=(
            F "// Button6 on PIN:$button6 [$action6-$longshort6-mod]"
            FE "***edit Button6 [Script]"
            FF "**change [Action:$action6]"			
            FP "**change [WOP-PIN:$button6]"
            FM "**change [MOD:$longshort6]"
            )	
        fi

        if [[ "$buttonnum" >6 ]]; then
        options+=(
            G "// Button7 on PIN:$button7 [$action7-$longshort7-mod]"
            GE "***edit Button7 [Script]"
            GF "**change [Action:$action7]"			
            GP "**change [WOP-PIN:$button7]"
            GM "**change [MOD:$longshort7]"
            )	
        fi

        if [[ "$buttonnum" >7 ]]; then
        options+=(
            H "// Button8 on PIN:$button8 [$action8-$longshort8-mod]"
            HE "***edit Button8 [Script]"
            HF "**change [Action:$action8]"			
            HP "**change [WOP-PIN:$button8]"
            HM "**change [MOD:$longshort8]"				
            )
        fi
			
        options+=(	
			X "Buttontest (60sec)"
			Y "Change Autostart Service [$autostart]"
			ZA "Uninstall SafeButtons and Services"
			ZZ "Reboot System"
            TEK "### Script by Liontek1985 ###"
    )
	

		

	
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	
        iniConfig "=" '"' "$configdir/all/$md_id.cfg"
		
        iniGet "BOARD"
        local board=${ini_value}
        iniGet "BOARDNAME"
        local boardname=${ini_value}
        iniGet "BUTTONNUM"
        local buttonnum=${ini_value}
        iniGet "WOPPINS"
        local woppins=${ini_value}		
        iniGet "BUTTON1"
        local button1=${ini_value}
        iniGet "BUTTON2"
        local button2=${ini_value}
        iniGet "BUTTON3"
        local button3=${ini_value}		
        iniGet "BUTTON4"
        local button4=${ini_value}		
        iniGet "BUTTON5"
        local button5=${ini_value}
        iniGet "BUTTON6"
        local button6=${ini_value}
        iniGet "BUTTON7"
        local button7=${ini_value}		
        iniGet "BUTTON8"
        local button8=${ini_value}		
        iniGet "ACTION1"
        local action1=${ini_value}
        iniGet "ACTION2"
        local action2=${ini_value}
        iniGet "ACTION3"
        local action3=${ini_value}		
        iniGet "ACTION4"
        local action4=${ini_value}		
        iniGet "ACTION5"
        local action5=${ini_value}
        iniGet "ACTION6"
        local action6=${ini_value}
        iniGet "ACTION7"
        local action7=${ini_value}		
        iniGet "ACTION8"
        local action8=${ini_value}		
        iniGet "LONGSHORT1"
        local longshort1=${ini_value}
        iniGet "LONGSHORT2"
        local longshort2=${ini_value}
        iniGet "LONGSHORT3"
        local longshort3=${ini_value}
        iniGet "LONGSHORT4"
        local longshort4=${ini_value}
        iniGet "LONGSHORT5"
        local longshort5=${ini_value}
        iniGet "LONGSHORT6"
        local longshort6=${ini_value}
        iniGet "LONGSHORT7"
        local longshort7=${ini_value}
        iniGet "LONGSHORT8"
        local longshort8=${ini_value}		
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
				rebuild-"$buttonnum"b_wiringOP
				configbuttons_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "Set Board to $boardname ($board) with follow defaultconfig \nWOP-PINS:$woppins\nBUTTON1: WOP-PIN-$button1 Action-$action1 Mod-$longshort1\nBUTTON2: WOP-PIN-$button2 Action-$action2 Mod-$longshort2\nAutostart-Service: $autostart\nTest with Option X the Buttons\nTest successful\n than Set Autostart with Option Y to Active"
                ;;
            XN)
				configbuttons_wiringOP
				changebuttonnum_wiringOP
                printMsgs "dialog" "Active-Buttons successful changed to [$buttonnum Buttons]"
                ;;
            XR)
				configbuttons_wiringOP
				rebuild-"$buttonnum"b_wiringOP
				configbuttons_wiringOP
				compile-scinst_wiringOP
                printMsgs "dialog" "Button reconfig successful $buttonnum Buttons active"
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
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			AP)				
				button1=$(dialog --title "Change PIN for Button1" --clear --rangebox "Configure your PIN for Button1" 0 60 5 $woppins $button1 2>&1 >/dev/tty)
                    if [[ -n "$button1" ]]; then
                        iniSet "BUTTON1" "${button1//[^[:digit:]]/}"
                    fi
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;	
			AM)
				configbuttons_wiringOP
				changemod-b1_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
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
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			BP)				
				button2=$(dialog --title "Change PIN for Button2" --clear --rangebox "Configure your PIN for Button2" 0 60 5 $woppins $button2 2>&1 >/dev/tty)
                    if [[ -n "$button2" ]]; then
                        iniSet "BUTTON2" "${button2//[^[:digit:]]/}"
                    fi
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			BM)	
				configbuttons_wiringOP
				changemod-b2_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
            C)
				editFile "/usr/local/bin/run$button3$longshort3.sh"
                ;;
            CE)
				editFile "/usr/local/bin/run$button3$longshort3.sh"
                ;;
            CF)
				configbuttons_wiringOP
				changeaction-b3_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			CP)				
				button3=$(dialog --title "Change PIN for Button3" --clear --rangebox "Configure your PIN for Button3" 0 60 5 $woppins $button3 2>&1 >/dev/tty)
                    if [[ -n "$button3" ]]; then
                        iniSet "BUTTON3" "${button3//[^[:digit:]]/}"
                    fi
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			CM)	
				configbuttons_wiringOP
				changemod-b3_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;			
            D)
				editFile "/usr/local/bin/run$button4$longshort4.sh"
                ;;
            DE)
				editFile "/usr/local/bin/run$button4$longshort4.sh"
                ;;
            DF)
				configbuttons_wiringOP
				changeaction-b4_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			DP)				
				button4=$(dialog --title "Change PIN for Button4" --clear --rangebox "Configure your PIN for Button4" 0 60 5 $woppins $button4 2>&1 >/dev/tty)
                    if [[ -n "$button4" ]]; then
                        iniSet "BUTTON4" "${button4//[^[:digit:]]/}"
                    fi
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			DM)	
				configbuttons_wiringOP
				changemod-b4_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;	
            E)
				editFile "/usr/local/bin/run$button5$longshort5.sh"
                ;;
            EE)
				editFile "/usr/local/bin/run$button5$longshort5.sh"
                ;;
            EF)
				configbuttons_wiringOP
				changeaction-b5_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			EP)				
				button5=$(dialog --title "Change PIN for Button5" --clear --rangebox "Configure your PIN for Button5" 0 60 5 $woppins $button5 2>&1 >/dev/tty)
                    if [[ -n "$button5" ]]; then
                        iniSet "BUTTON5" "${button5//[^[:digit:]]/}"
                    fi
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			EM)	
				configbuttons_wiringOP
				changemod-b5_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
            F)
				editFile "/usr/local/bin/run$button6$longshort6.sh"
                ;;
            FE)
				editFile "/usr/local/bin/run$button6$longshort6.sh"
                ;;
            FF)
				configbuttons_wiringOP
				changeaction-b6_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			FP)				
				button6=$(dialog --title "Change PIN for Button6" --clear --rangebox "Configure your PIN for Button6" 0 60 5 $woppins $button6 2>&1 >/dev/tty)
                    if [[ -n "$button6" ]]; then
                        iniSet "BUTTON6" "${button6//[^[:digit:]]/}"
                    fi
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			FM)	
				configbuttons_wiringOP
				changemod-b6_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
            G)
				editFile "/usr/local/bin/run$button7$longshort7.sh"
                ;;
            GE)
				editFile "/usr/local/bin/run$button7$longshort7.sh"
                ;;
            GF)
				configbuttons_wiringOP
				changeaction-b7_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			GP)				
				button7=$(dialog --title "Change PIN for Button7" --clear --rangebox "Configure your PIN for Button7" 0 60 5 $woppins $button7 2>&1 >/dev/tty)
                    if [[ -n "$button7" ]]; then
                        iniSet "BUTTON7" "${button7//[^[:digit:]]/}"
                    fi
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			GM)	
				configbuttons_wiringOP
				changemod-b7_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
            H)
				editFile "/usr/local/bin/run$button8$longshort8.sh"
                ;;
            HE)
				editFile "/usr/local/bin/run$button8$longshort8.sh"
                ;;
            HF)
				configbuttons_wiringOP
				changeaction-b8_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			HP)				
				button8=$(dialog --title "Change PIN for Button8" --clear --rangebox "Configure your PIN for Button8" 0 60 5 $woppins $button8 2>&1 >/dev/tty)
                    if [[ -n "$button8" ]]; then
                        iniSet "BUTTON8" "${button8//[^[:digit:]]/}"
                    fi
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;
			HM)	
				configbuttons_wiringOP
				changemod-b8_wiringOP
                printMsgs "dialog" "please set all Options like [Action,PIN,MOD] \n than reconfig the Button after that with Option XR \n reconfig activate the new Settings"
                ;;	
            X)
				testsc_wiringOP
                printMsgs "dialog" "Testtime is over, try again if you want"
                ;;
            Y)
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
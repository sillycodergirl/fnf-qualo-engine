# QualO Engine (PE 0.7.3 Fork)

QualO engine is a W.I.P fork of ShadowMario's Psych Engine (0.7.3) for the hit rhythm game, Friday Night Funkin'

This fork tries to fix all the small issues with the current state of psych engine, and more, making development work much smoother for mod developers.

**THERE IS NO MORE SOFTCODING IN THIS FORK.***

As this fork is still being worked on, changes may come and go.

**lua is possible, and ig you CAN softcode if you really wanna try hard enough*

<hr>

## **Changes**

 - Organized assets folder making it much easier to understand! (no more shared folder, and everything in images like what.)
 - No more 'mods' folder, lua and other soft coded mod features are added directly in source.
 - Better root folder management *(theres only 3 required files)*
 - Made the switch to hxvlc rather than hxcodec *(it wont crash as much i swear)*
 - Added a "developer mode", toggle via Project.xml
 - Developer testing area, code ur testing shit there *(hit F8 on main menu, must have dev mode on)*
 - Added a feature to reload assets from the source folder to the current build.
 - Many more QOL features to come!
<hr>

## Building
Building QualO engine is very simple. It's almost the same as building Psych 0.7.3, but with a minor change.

HAXE VERSION: [Haxe 4.2.5](https://haxe.org/download/version/4.2.5/) (i need to update this soon.)

**Required libraries:** 

    haxelib set lime 8.1.2
    haxelib set flixel 5.6.2
    haxelib set flixel-addons 3.2.1
    haxelib set flixel-tools 1.5.1
    haxelib set flixel-ui 2.5.0
    haxelib set openfl 9.3.2
    haxelib set tjson 1.4.0
    haxelib set SScript 11.0.618
    haxelib git flxanimate https://github.com/ShadowMario/flxanimate dev
    haxelib git hxdiscord_rpc https://github.com/MAJigsaw77/hxdiscord_rpc.git
    haxelib git linc_luajit https://github.com/superpowers04/linc_luajit.git
	haxelib git hxvlc https://github.com/MAJigsaw77/hxvlc.git


**IMPORTANT !! IMPORTANT !! IMPORTANT !! IMPORTANT !! IMPORTANT !! IMPORTANT !! IMPORTANT**

**Download and install the batch file for C++ compiling: https://github.com/ShadowMario/FNF-PsychEngine/blob/main/setup/setup-msvc-win.bat**


After installing the needed libraries, just open up the terminal and type either of the commands

    lime test windows (builds and then runs the exe)
    lime build windows (just builds)

## Contact
If you have any issues with the fork, please make an issue.
If you have any requests, please comment it on the official request issue.

Fork by [Alice (@sillycodergirl)](https://twitter.com/sillycodergirl)

# A3XX ECAM Messages
# Joshua Davidson (Octal450)

# Copyright (c) 2020 Josh Davidson (Octal450)

var stateL = 0;
var stateR = 0;
var thrustL = 0;
var thrustR = 0;
var elec = 0;
var speed = 0;
var wow = 0;
var altitude = 0;
setprop("/ECAM/left-msg", "NONE");
setprop("/position/gear-agl-ft", 0);
setprop("/ECAM/Lower/page", "fctl");
# w = White, b = Blue, g = Green, a = Amber, r = Red

var ECAM = {
	init: func() {
		setprop("/ECAM/engine-start-time", 0);
		setprop("/ECAM/engine-start-time-switch", 0);
		setprop("/ECAM/to-memo-enable", 1);
		setprop("/ECAM/to-config", 0);
		setprop("/ECAM/ldg-memo-enable", 0);
		setprop("/systems/gear/landing-gear-warning-light", 0);
	},
	MSGclr: func() {
		setprop("/ECAM/ecam-checklist-active", 0);
		setprop("/ECAM/left-msg", "NONE");
		setprop("/ECAM/msg/line1", "");
		setprop("/ECAM/msg/line2", "");
		setprop("/ECAM/msg/line3", "");
		setprop("/ECAM/msg/line4", "");
		setprop("/ECAM/msg/line5", "");
		setprop("/ECAM/msg/line6", "");
		setprop("/ECAM/msg/line7", "");
		setprop("/ECAM/msg/line8", "");
		setprop("/ECAM/msg/line1c", "w");
		setprop("/ECAM/msg/line2c", "w");
		setprop("/ECAM/msg/line3c", "w");
		setprop("/ECAM/msg/line4c", "w");
		setprop("/ECAM/msg/line5c", "w");
		setprop("/ECAM/msg/line6c", "w");
		setprop("/ECAM/msg/line7c", "w");
		setprop("/ECAM/msg/line8c", "w");
	},
	loop: func() {
		stateL = getprop("/engines/engine[0]/state");
		stateR = getprop("/engines/engine[1]/state");
		thrustL = getprop("/systems/thrust/state1");
		thrustR = getprop("/systems/thrust/state2");
		elec = getprop("/systems/electrical/on");
		speed = getprop("/velocities/airspeed-kt");
		wow = getprop("/gear/gear[0]/wow");
		
		if (stateL == 3 and stateR == 3 and wow == 1) {
			if (getprop("/ECAM/engine-start-time-switch") != 1) {
				setprop("/ECAM/engine-start-time", getprop("/sim/time/elapsed-sec"));
				setprop("/ECAM/engine-start-time-switch", 1);
			}
		} else if (wow == 1) {
			if (getprop("/ECAM/engine-start-time-switch") != 0) {
				setprop("/ECAM/engine-start-time-switch", 0);
			}
		}
		
		if (wow == 0) {
			setprop("/ECAM/to-memo-enable", 0);
		} else if ((stateL != 3 or stateR != 3) and wow == 1) {
			setprop("/ECAM/to-memo-enable", 1);
		}
		
		if (getprop("/position/gear-agl-ft") <= 2000 and (getprop("/FMGC/status/phase") == 3 or getprop("/FMGC/status/phase") == 4 or getprop("/FMGC/status/phase") == 5) and wow == 0) {
			setprop("/ECAM/ldg-memo-enable", 1);
		} else if (getprop("/ECAM/left-msg") == "LDG-MEMO" and getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") <= 80 and wow == 1) {
			setprop("/ECAM/ldg-memo-enable", 0);
		} else if (getprop("/ECAM/left-msg") != "LDG-MEMO") {
			setprop("/ECAM/ldg-memo-enable", 0);
		}
		
		if (getprop("/FMGC/status/phase") == 0 and stateL == 3 and stateR == 3 and getprop("/ECAM/engine-start-time") + 120 < getprop("/sim/time/elapsed-sec") and getprop("/ECAM/to-memo-enable") == 1 and wow == 1) {
			setprop("/ECAM/left-msg", "TO-MEMO");
		} else if (getprop("/ECAM/ldg-memo-enable") == 1) {
			setprop("/ECAM/left-msg", "LDG-MEMO");
		} else {
			setprop("/ECAM/left-msg", "NONE");
		}
		
		if (getprop("/controls/autobrake/mode") == 3 and getprop("/controls/lighting/no-smoking-sign") == 1 and getprop("/controls/lighting/seatbelt-sign") == 1 and getprop("/controls/flight/speedbrake-arm") == 1 and getprop("/controls/flight/flap-pos") > 0 
		and getprop("/controls/flight/flap-pos") < 5) {
			# Do nothing
		} else {
			setprop("/ECAM/to-config", 0);
		}
	},
	toConfig: func() {
		stateL = getprop("/engines/engine[0]/state");
		stateR = getprop("/engines/engine[1]/state");
		wow = getprop("/gear/gear[0]/wow");
		
		if (wow == 1 and stateL == 3 and stateR == 3 and getprop("/ECAM/left-msg") != "TO-MEMO") {
			setprop("/ECAM/to-memo-enable", 1);
			setprop("/ECAM/engine-start-time", getprop("/ECAM/engine-start-time") - 120);
		}
		
		if (getprop("/controls/autobrake/mode") == 3 and getprop("/controls/switches/no-smoking-sign") == 1 and getprop("/controls/switches/seatbelt-sign") == 1 and getprop("/controls/flight/speedbrake-arm") == 1 and getprop("/controls/flight/flap-pos") > 0 
		and getprop("/controls/flight/flap-pos") < 5) {
			setprop("/ECAM/to-config", 1);
		}
	},
};

ECAM.MSGclr();

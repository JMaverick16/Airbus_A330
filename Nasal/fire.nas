# A3XX Fire System
# Jonathan Redpath

# Copyright (c) 2019 Joshua Davidson (Octal450)

#############
# Init Vars #
#############

var level = 0;
var fwdsquib = 0;
var aftsquib = 0;
var fwddet = 0;
var aftdet = 0;
var test = 0;
var guard1 = 0;
var guard2 = 0;
var dischpb1 = 0;
var dischpb2 = 0;
var smokedet1 = 0;
var smokedet2 = 0;
var bottleIsEmpty = 0;
var WeCanExt = 0;
var test2 = 0;
var state = 0;
var dc1 = 0;
var dc2 = 0;
var dcbat = 0;
var pause = 0;

var fire_init = func {
	setprop("/controls/OH/protectors/fwddisch", 0);
	setprop("/controls/OH/protectors/aftdisch", 0);
	setprop("/systems/failures/cargo-fwd-fire", 0);
	setprop("/systems/failures/cargo-aft-fire", 0);
	setprop("/systems/fire/cargo/fwdsquib", 0);
	setprop("/systems/fire/cargo/aftsquib", 0);
	setprop("/systems/fire/cargo/bottlelevel", 100);
	setprop("/systems/fire/cargo/test", 0);
	setprop("/controls/fire/cargo/test", 0);
	setprop("/controls/fire/cargo/fwddisch", 0); # pushbutton
	setprop("/controls/fire/cargo/aftdisch", 0);
	setprop("/controls/fire/cargo/fwddischLight", 0);
	setprop("/controls/fire/cargo/aftdischLight", 0);
	setprop("/controls/fire/cargo/fwdsmokeLight", 0);
	setprop("/controls/fire/cargo/aftsmokeLight", 0);
	setprop("/controls/fire/cargo/bottleempty", 0);
	# status: 1 is ready, 0 is already disch
	setprop("/controls/fire/cargo/status", 1);
	setprop("/controls/fire/cargo/warnfwd", 0);
	setprop("/controls/fire/cargo/warnaft", 0);
	setprop("/controls/fire/cargo/squib1fault", 0);
	setprop("/controls/fire/cargo/squib2fault", 0);
	setprop("/controls/fire/cargo/detfault", 0);
	setprop("/controls/fire/cargo/test/state", 0);
	fire_timer.start();
}

##############
# Main Loops #
##############
var master_fire = func {
	level = getprop("/systems/fire/cargo/bottlelevel");
	fwdsquib = getprop("/systems/fire/cargo/fwdsquib");
	aftsquib = getprop("/systems/fire/cargo/aftsquib");
	fwddet = getprop("/systems/failures/cargo-fwd-fire");
	aftdet = getprop("/systems/failures/cargo-aft-fire");
	test = getprop("/controls/fire/cargo/test");
	guard1 = getprop("/controls/fire/cargo/fwdguard");
	guard2 = getprop("/controls/fire/cargo/aftguard");
	dischpb1 = getprop("/controls/fire/cargo/fwddisch"); 
	dischpb2 = getprop("/controls/fire/cargo/aftdisch");
	smokedet1 = getprop("/controls/fire/cargo/fwdsmokeLight");
	smokedet2 = getprop("/controls/fire/cargo/aftsmokeLight");
	bottleIsEmpty = getprop("/controls/fire/cargo/bottleempty");
	WeCanExt = getprop("/controls/fire/cargo/status");
	test2 = getprop("/systems/fire/cargo/test");
	state = getprop("/controls/fire/cargo/test/state");
	dc1 = getprop("/systems/electrical/bus/dc1");
	dc2 = getprop("/systems/electrical/bus/dc2");
	dcbat = getprop("/systems/electrical/bus/dcbat");
	pause = getprop("/sim/freeze/master");
	
	###############
	# Discharging #
	###############
	
	if (dischpb1) {
		if (WeCanExt == 1 and !fwdsquib and !bottleIsEmpty and (dc1 > 0 or dc2 > 0 or dcbat > 0)) {
			setprop("/systems/fire/cargo/fwdsquib", 1);
		}
	}
	
	if (dischpb1 and fwdsquib and !bottleIsEmpty and !pause) {
		setprop("/systems/fire/cargo/bottlelevel", getprop("/systems/fire/cargo/bottlelevel") - 0.33);
	}
	
	if (dischpb2) {
		if (WeCanExt == 1 and !aftsquib and !bottleIsEmpty and (dc1 > 0 or dc2 > 0 or dcbat > 0)) {
			setprop("/systems/fire/cargo/aftsquib", 1);
		}
	} 
	
	if (dischpb2 and aftsquib and !bottleIsEmpty and !pause) {
		setprop("/systems/fire/cargo/bottlelevel", getprop("/systems/fire/cargo/bottlelevel") - 0.33);
	}
	
	#################
	# Test Sequence #
	#################
	
	if (test) {
		setprop("/systems/fire/cargo/test", 1);
	} else {
		setprop("/systems/fire/cargo/test", 0);
	}
	
	if (test2 and state == 0) {
		setprop("/controls/fire/cargo/fwddischLight", 1);
		setprop("/controls/fire/cargo/aftdischLight", 1);
		settimer(func(){
			setprop("/controls/fire/cargo/fwddischLight", 0);
			setprop("/controls/fire/cargo/aftdischLight", 0);
			setprop("/controls/fire/cargo/test/state", 1);
		}, 5);
	} else if (test2 and state == 1) {
		setprop("/controls/fire/cargo/fwdsmokeLight", 1);
		setprop("/controls/fire/cargo/warnfwd", 1);
		setprop("/controls/fire/cargo/aftsmokeLight", 1);
		setprop("/controls/fire/cargo/warnaft", 1);
		settimer(func(){
			setprop("/controls/fire/cargo/fwdsmokeLight", 0);
			setprop("/controls/fire/cargo/aftsmokeLight", 0);
			setprop("/controls/fire/cargo/warnfwd", 0);
			setprop("/controls/fire/cargo/warnaft", 0);
			setprop("/controls/fire/cargo/test/state", 2);
		}, 5);
	} else if (test2 and state == 2) {
		settimer(func(){
			setprop("/controls/fire/cargo/test/state", 3);
		}, 5);
	} else if (test2 and state == 3) {
		setprop("/controls/fire/cargo/fwdsmokeLight", 1);
		setprop("/controls/fire/cargo/warnfwd", 1);
		setprop("/controls/fire/cargo/aftsmokeLight", 1);
		setprop("/controls/fire/cargo/warnaft", 1);
		settimer(func(){
			setprop("/controls/fire/cargo/fwdsmokeLight", 0);
			setprop("/controls/fire/cargo/aftsmokeLight", 0);
			setprop("/controls/fire/cargo/warnfwd", 0);
			setprop("/controls/fire/cargo/warnaft", 0);
			setprop("/systems/fire/cargo/test", 0);
			setprop("/controls/fire/cargo/test", 0);
			setprop("/controls/fire/cargo/test/state", 0);
		}, 5);
	}
	
	
	##########
	# Status #
	##########
	
	if (level < 0.1 and !test) {
		setprop("/controls/fire/cargo/bottleempty", 1);
		setprop("/controls/fire/cargo/status", 0);
		setprop("/controls/fire/cargo/fwddischLight", 1);
		setprop("/controls/fire/cargo/aftdischLight", 1);
	} else if (!test) {
		setprop("/controls/fire/cargo/bottleempty", 0);
		setprop("/controls/fire/cargo/status", 1);
		setprop("/controls/fire/cargo/fwddischLight", 0);
		setprop("/controls/fire/cargo/aftdischLight", 0);
	}
	
}

###################
# Detection Logic #
###################

setlistener("/systems/failures/cargo-fwd-fire", func() {
	if (getprop("/systems/failures/cargo-fwd-fire")) {
		setprop("/controls/fire/cargo/fwdsmokeLight", 1);
		setprop("/controls/fire/cargo/warnfwd", 1);
	} else {
		setprop("/controls/fire/cargo/fwdsmokeLight", 0);
	}
}, 0, 0);

setlistener("/systems/failures/cargo-aft-fire", func() {
	if (getprop("/systems/failures/cargo-aft-fire")) {
		setprop("/controls/fire/cargo/aftsmokeLight", 1);
		setprop("/controls/fire/cargo/warnaft", 1);
	} else {
		setprop("/controls/fire/cargo/aftsmokeLight", 0);
	}
}, 0, 0);

###################
# Update Function #
###################

var update_fire = func {
	master_fire();
}

var fire_timer = maketimer(0.2, update_fire);
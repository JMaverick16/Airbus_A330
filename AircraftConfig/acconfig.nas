# Aircraft Config Center
# Joshua Davidson (Octal450)

# Copyright (c) 2020 Josh Davidson (Octal450)

var spinning = maketimer(0.05, func {
	var spinning = getprop("/systems/acconfig/spinning");
	if (spinning == 0) {
		setprop("/systems/acconfig/spin", "\\");
		setprop("/systems/acconfig/spinning", 1);
	} else if (spinning == 1) {
		setprop("/systems/acconfig/spin", "|");
		setprop("/systems/acconfig/spinning", 2);
	} else if (spinning == 2) {
		setprop("/systems/acconfig/spin", "/");
		setprop("/systems/acconfig/spinning", 3);
	} else if (spinning == 3) {
		setprop("/systems/acconfig/spin", "-");
		setprop("/systems/acconfig/spinning", 0);
	}
});

var failReset = func {
	setprop("/systems/failures/prim1", 0);
	setprop("/systems/failures/prim2", 0);
	setprop("/systems/failures/prim3", 0);
	setprop("/systems/failures/sec1", 0);
	setprop("/systems/failures/sec2", 0);
	setprop("/systems/failures/aileron-left", 0);
	setprop("/systems/failures/aileron-right", 0);
	setprop("/systems/failures/elevator-left", 0);
	setprop("/systems/failures/elevator-right", 0);
	setprop("/systems/failures/rudder", 0);
	setprop("/systems/failures/spoiler-l1", 0);
	setprop("/systems/failures/spoiler-l2", 0);
	setprop("/systems/failures/spoiler-l3", 0);
	setprop("/systems/failures/spoiler-l4", 0);
	setprop("/systems/failures/spoiler-l5", 0);
	setprop("/systems/failures/spoiler-l6", 0);
	setprop("/systems/failures/spoiler-r1", 0);
	setprop("/systems/failures/spoiler-r2", 0);
	setprop("/systems/failures/spoiler-r3", 0);
	setprop("/systems/failures/spoiler-r4", 0);
	setprop("/systems/failures/spoiler-r5", 0);
	setprop("/systems/failures/spoiler-r6", 0);
	setprop("/systems/failures/elec-ac-ess", 0);
	setprop("/systems/failures/elec-batt1", 0);
	setprop("/systems/failures/elec-batt2", 0);
	setprop("/systems/failures/elec-galley", 0);
	setprop("/systems/failures/elec-genapu", 0);
	setprop("/systems/failures/elec-gen1", 0);
	setprop("/systems/failures/elec-gen2", 0);
	setprop("/systems/failures/bleed-apu", 0);
	setprop("/systems/failures/bleed-ext", 0);
	setprop("/systems/failures/bleed-eng1", 0);
	setprop("/systems/failures/bleed-eng2", 0);
	setprop("/systems/failures/pack1", 0);
	setprop("/systems/failures/pack2", 0);
	setprop("/systems/failures/hyd-blue", 0);
	setprop("/systems/failures/hyd-green", 0);
	setprop("/systems/failures/hyd-yellow", 0);
	setprop("/systems/failures/ptu", 0);
	setprop("/systems/failures/pump-blue-eng", 0);
	setprop("/systems/failures/pump-blue-elec", 0);
	setprop("/systems/failures/pump-green-eng", 0);
	setprop("/systems/failures/pump-green-eng2", 0);
	setprop("/systems/failures/pump-green-elec", 0);
	setprop("/systems/failures/pump-yellow-eng", 0);
	setprop("/systems/failures/pump-yellow-elec", 0);
	setprop("/systems/failures/tank0pump1", 0);
	setprop("/systems/failures/tank0pump2", 0);
	setprop("/systems/failures/tank1pump1", 0);
	setprop("/systems/failures/tank1pump2", 0);
	setprop("/systems/failures/tank2pump1", 0);
	setprop("/systems/failures/tank2pump2", 0);
	setprop("/systems/failures/fuelmode", 0);
	setprop("/systems/failures/cargo-aft-fire", 0);
	setprop("/systems/failures/cargo-fwd-fire", 0);
}

failReset();
setprop("/systems/acconfig/autoconfig-running", 0);
setprop("/systems/acconfig/spinning", 0);
setprop("/systems/acconfig/spin", "-");
setprop("/systems/acconfig/options/revision", 0);
setprop("/systems/acconfig/new-revision", 0);
setprop("/systems/acconfig/out-of-date", 0);
setprop("/systems/acconfig/mismatch-code", "0x000");
setprop("/systems/acconfig/mismatch-reason", "XX");
setprop("/systems/acconfig/options/keyboard-mode", 0);
setprop("/systems/acconfig/options/adirs-skip", 0);
setprop("/systems/acconfig/options/welcome-skip", 0);
setprop("/systems/acconfig/options/no-rendering-warn", 0);
setprop("/systems/acconfig/options/pfd-rate", 1);
setprop("/systems/acconfig/options/nd-rate", 1);
setprop("/systems/acconfig/options/uecam-rate", 1);
setprop("/systems/acconfig/options/lecam-rate", 1);
setprop("/systems/acconfig/options/iesi-rate", 1);
setprop("/systems/acconfig/options/autopush/show-route", 1);
setprop("/systems/acconfig/options/autopush/show-wingtip", 1);
var main_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/main/dialog", "Aircraft/Airbus_A330/AircraftConfig/main.xml");
var welcome_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/welcome/dialog", "Aircraft/Airbus_A330/AircraftConfig/welcome.xml");
var ps_load_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psload/dialog", "Aircraft/Airbus_A330/AircraftConfig/psload.xml");
var ps_loaded_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/psloaded/dialog", "Aircraft/Airbus_A330/AircraftConfig/psloaded.xml");
var init_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/init/dialog", "Aircraft/Airbus_A330/AircraftConfig/ac_init.xml");
var help_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/help/dialog", "Aircraft/Airbus_A330/AircraftConfig/help.xml");
var fbw_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/fbw/dialog", "Aircraft/Airbus_A330/AircraftConfig/fbw.xml");
var fail_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/fail/dialog", "Aircraft/Airbus_A330/AircraftConfig/fail.xml");
var about_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/about/dialog", "Aircraft/Airbus_A330/AircraftConfig/about.xml");
var update_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/update/dialog", "Aircraft/Airbus_A330/AircraftConfig/update.xml");
var updated_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/updated/dialog", "Aircraft/Airbus_A330/AircraftConfig/updated.xml");
var error_mismatch = gui.Dialog.new("sim/gui/dialogs/acconfig/error/mismatch/dialog", "Aircraft/Airbus_A330/AircraftConfig/error-mismatch.xml");
var groundservices_dlg = gui.Dialog.new("sim/gui/dialogs/acconfig/groundsrvc/dialog", "Aircraft/Airbus_A330/AircraftConfig/groundservices.xml");
var du_quality = gui.Dialog.new("sim/gui/dialogs/acconfig/du-quality/dialog", "Aircraft/Airbus_A330/AircraftConfig/du-quality.xml");
var rendering_dlg = gui.Dialog.new("sim/gui/dialogs/rendering/dialog", "Aircraft/Airbus_A330/AircraftConfig/rendering.xml");
spinning.start();
init_dlg.open();

http.load("https://raw.githubusercontent.com/JMaverick16/Airbus_A330/master/revision.txt").done(func(r) setprop("/systems/acconfig/new-revision", r.response));
var revisionFile = (getprop("/sim/aircraft-dir") ~ "/revision.txt");
var current_revision = io.readfile(revisionFile);
print("Airbus_A330 Revision: " ~ current_revision);
setprop("/systems/acconfig/revision", current_revision);

setlistener("/systems/acconfig/new-revision", func {
	if (getprop("/systems/acconfig/new-revision") > current_revision) {
		setprop("/systems/acconfig/out-of-date", 1);
	} else {
		setprop("/systems/acconfig/out-of-date", 0);
	}
});

var fgfsMin = split(".", getprop("/sim/minimum-fg-version"));
var fgfsVer = split(".", getprop("/sim/version/flightgear"));

var versionCheck = func() {
	if (fgfsVer[0] < fgfsMin[0] or fgfsVer[1] < fgfsMin[1]) {
		return 0;
	} else if (fgfsVer[1] == fgfsMin[1]) {
		if (fgfsVer[2] < fgfsMin[2]) {
			return 0;
		} else {
			return 1;
		}
	} else {
		return 1;
	}
}

var mismatch_chk = func {
	if (!versionCheck()) {
		setprop("/systems/acconfig/mismatch-code", "0x121");
		setprop("/systems/acconfig/mismatch-reason", "FGFS version is too old! Please update FlightGear to at least " ~ getprop("/sim/minimum-fg-version") ~ ".");
		if (getprop("/systems/acconfig/out-of-date") != 1) {
			error_mismatch.open();
		}
		libraries.systemsLoop.stop();
		print("Mismatch: 0x121");
		welcome_dlg.close();
	} else if (getprop("/gear/gear[0]/wow") == 0 or getprop("/position/altitude-ft") >= 15000) {
		setprop("/systems/acconfig/mismatch-code", "0x223");
		setprop("/systems/acconfig/mismatch-reason", "Preposterous configuration detected for initialization. Check your position or scenery.");
		if (getprop("/systems/acconfig/out-of-date") != 1) {
			error_mismatch.open();
		}
		libraries.systemsLoop.stop();
		print("Mismatch: 0x223");
		welcome_dlg.close();
	} else if (getprop("/systems/acconfig/libraries-loaded") != 1) {
		setprop("/systems/acconfig/mismatch-code", "0x247");
		setprop("/systems/acconfig/mismatch-reason", "System files are missing or damaged. Please download a new copy of the aircraft.");
		if (getprop("/systems/acconfig/out-of-date") != 1) {
			error_mismatch.open();
		}
		libraries.systemsLoop.stop();
		print("Mismatch: 0x247");
		welcome_dlg.close();
	}
}

setlistener("/sim/signals/fdm-initialized", func {
	init_dlg.close();
	if (getprop("/systems/acconfig/out-of-date") == 1) {
		update_dlg.open();
		print("System: The Airbus_A330 is out of date!");
	} 
	mismatch_chk();
	readSettings();
	if (getprop("/systems/acconfig/out-of-date") != 1 and getprop("/systems/acconfig/options/revision") < current_revision and getprop("/systems/acconfig/mismatch-code") == "0x000") {
		updated_dlg.open();
		if (getprop("/systems/acconfig/options/no-rendering-warn") != 1) {
			renderingSettings.check();
		}
	} else if (getprop("/systems/acconfig/out-of-date") != 1 and getprop("/systems/acconfig/mismatch-code") == "0x000" and getprop("/systems/acconfig/options/welcome-skip") != 1) {
		welcome_dlg.open();
		if (getprop("/systems/acconfig/options/no-rendering-warn") != 1) {
			renderingSettings.check();
		}
	}
	setprop("/systems/acconfig/options/revision", current_revision);
	writeSettings();
	
	if (getprop("/options/system/fo-view") == 1) {
		view.setViewByIndex(100);
	}
	
	spinning.stop();
});

var renderingSettings = {
	check: func() {
		var rembrandt = getprop("/sim/rendering/rembrandt/enabled");
		var ALS = getprop("/sim/rendering/shaders/skydome");
		var customSettings = getprop("/sim/rendering/shaders/custom-settings") == 1;
		var landmass = getprop("/sim/rendering/shaders/landmass") >= 4;
		var model = getprop("/sim/rendering/shaders/model") >= 2;
		if (!rembrandt and (!ALS or !customSettings or !landmass or !model)) {
			rendering_dlg.open();
		}
	},
	fixAll: func() {
		me.fixCore();
		var landmass = getprop("/sim/rendering/shaders/landmass") >= 4;
		var model = getprop("/sim/rendering/shaders/model") >= 2;
		if (!landmass) {
			setprop("/sim/rendering/shaders/landmass", 4);
		}
		if (!model) {
			setprop("/sim/rendering/shaders/model", 2);
		}
	},
	fixCore: func() {
		setprop("/sim/rendering/shaders/skydome", 1); # ALS on
		setprop("/sim/rendering/shaders/custom-settings", 1);
		gui.popupTip("Rendering Settings updated!");
	},
};

var readSettings = func {
	io.read_properties(getprop("/sim/fg-home") ~ "/Export/Airbus_A330-config.xml", "/systems/acconfig/options");
	setprop("/options/system/keyboard-mode", getprop("/systems/acconfig/options/keyboard-mode"));
	setprop("/controls/adirs/skip", getprop("/systems/acconfig/options/adirs-skip"));
	setprop("/sim/model/autopush/route/show", getprop("/systems/acconfig/options/autopush/show-route"));
	setprop("/sim/model/autopush/route/show-wingtip", getprop("/systems/acconfig/options/autopush/show-wingtip"));
	setprop("/options/system/fo-view", getprop("/systems/acconfig/options/fo-view"));
}

var writeSettings = func {
	setprop("/systems/acconfig/options/keyboard-mode", getprop("/options/system/keyboard-mode"));
	setprop("/systems/acconfig/options/adirs-skip", getprop("/controls/adirs/skip"));
	setprop("/systems/acconfig/options/autopush/show-route", getprop("/sim/model/autopush/route/show"));
	setprop("/systems/acconfig/options/autopush/show-wingtip", getprop("/sim/model/autopush/route/show-wingtip"));
	setprop("/systems/acconfig/options/fo-view", getprop("/options/system/fo-view"));
	io.write_properties(getprop("/sim/fg-home") ~ "/Export/Airbus_A330-config.xml", "/systems/acconfig/options");
}

################
# Panel States #
################

# Cold and Dark
var colddark = func {
	if (getprop("/systems/acconfig/mismatch-code") == "0x000") {
		spinning.start();
		ps_loaded_dlg.close();
		ps_load_dlg.open();
		setprop("/systems/acconfig/autoconfig-running", 1);
		setprop("/controls/gear/brake-left", 1);
		setprop("/controls/gear/brake-right", 1);
		# Initial shutdown, and reinitialization.
		setprop("/controls/engines/engine-start-switch", 1);
		setprop("/controls/engines/engine[0]/cutoff-switch", 1);
		setprop("/controls/engines/engine[1]/cutoff-switch", 1);
		setprop("/controls/flight/slats", 0.000);
		setprop("/controls/flight/flaps", 0.000);
		setprop("/controls/flight/flap-lever", 0);
		setprop("/controls/flight/flap-pos", 0);
		setprop("/controls/flight/flap-txt", " ");
		libraries.flaptimer.stop();
		setprop("/controls/flight/speedbrake-arm", 0);
		setprop("/controls/flight/speedbrake", 0);
		setprop("/controls/gear/gear-down", 1);
		setprop("/controls/flight/elevator-trim", 0);
		setprop("/controls/switches/beacon", 0);
		setprop("/controls/switches/strobe", 0.0);
		setprop("/controls/switches/wing-lights", 0);
		setprop("/controls/lighting/nav-lights-switch", 0);
		setprop("/controls/lighting/turnoff-light-switch", 0);
		setprop("/controls/lighting/taxi-light-switch", 0.0);
		setprop("/controls/switches/landing-lights", 0.0);
		setprop("/controls/atc/mode-knob", 0);
		atc.transponderPanel.modeSwitch(1);
		libraries.systemsInit();
		failReset();
		if (getprop("/engines/engine[1]/n2-actual") < 2) {
			colddark_b();
		} else {
			var colddark_eng_off = setlistener("/engines/engine[1]/n2-actual", func {
				if (getprop("/engines/engine[1]/n2-actual") < 2) {
					removelistener(colddark_eng_off);
					colddark_b();
				}
			});
		}
	}
}
var colddark_b = func {
	# Continues the Cold and Dark script, after engines fully shutdown.
	setprop("/controls/APU/master", 0);
	setprop("/controls/APU/start", 0);
	settimer(func {
		setprop("/controls/gear/brake-left", 0);
		setprop("/controls/gear/brake-right", 0);
		setprop("/systems/acconfig/autoconfig-running", 0);
		ps_load_dlg.close();
		ps_loaded_dlg.open();
		spinning.stop();
	}, 2);
}

# Ready to Start Eng
var beforestart = func {
	if (getprop("/systems/acconfig/mismatch-code") == "0x000") {
		spinning.start();
		ps_loaded_dlg.close();
		ps_load_dlg.open();
		setprop("/systems/acconfig/autoconfig-running", 1);
		setprop("/controls/gear/brake-left", 1);
		setprop("/controls/gear/brake-right", 1);
		# First, we set everything to cold and dark.
		setprop("/controls/engines/engine-start-switch", 1);
		setprop("/controls/engines/engine[0]/cutoff-switch", 1);
		setprop("/controls/engines/engine[1]/cutoff-switch", 1);
		setprop("/controls/flight/slats", 0.000);
		setprop("/controls/flight/flaps", 0.000);
		setprop("/controls/flight/flap-lever", 0);
		setprop("/controls/flight/flap-pos", 0);
		setprop("/controls/flight/flap-txt", " ");
		libraries.flaptimer.stop();
		setprop("/controls/flight/speedbrake-arm", 0);
		setprop("/controls/flight/speedbrake", 0);
		setprop("/controls/gear/gear-down", 1);
		setprop("/controls/flight/elevator-trim", 0);
		libraries.systemsInit();
		failReset();
		setprop("/controls/APU/master", 0);
		setprop("/controls/APU/start", 0);
		
		# Now the Startup!
		setprop("/controls/electrical/switches/battery1", 1);
		setprop("/controls/electrical/switches/battery2", 1);
		setprop("/controls/electrical/switches/battery3", 1);
		setprop("/controls/APU/master", 1);
		setprop("/controls/APU/start", 1);
		var apu_rpm_chk = setlistener("/systems/apu/rpm", func {
			if (getprop("/systems/apu/rpm") >= 98) {
				removelistener(apu_rpm_chk);
				beforestart_b();
			}
		});
	}
}
var beforestart_b = func {
	# Continue with engine start prep.
	setprop("/controls/fuel/tank0pump1", 1);
	setprop("/controls/fuel/tank0pump2", 1);
	setprop("/controls/fuel/tank0pump3", 1);
	setprop("/controls/fuel/tank1pump1", 1);
	setprop("/controls/fuel/tank1pump2", 1);
	setprop("/controls/fuel/tank2pump1", 1);
	setprop("/controls/fuel/tank2pump2", 1);
	setprop("/controls/fuel/tank2pump3", 1);
	setprop("/controls/electrical/switches/gen-apu", 1);
	setprop("/controls/electrical/switches/galley", 1);
	setprop("/controls/electrical/switches/gen1", 1);
	setprop("/controls/electrical/switches/gen2", 1);
	setprop("/controls/pneumatic/switches/bleedapu", 1);
	setprop("/controls/pneumatic/switches/bleed1", 1);
	setprop("/controls/pneumatic/switches/bleed2", 1);
	setprop("/controls/pneumatic/switches/pack1", 1);
	setprop("/controls/pneumatic/switches/pack2", 1);
	setprop("/controls/adirs/ir[0]/knob","1");
	setprop("/controls/adirs/ir[1]/knob","1");
	setprop("/controls/adirs/ir[2]/knob","1");
	systems.ADIRS.skip(0);
	systems.ADIRS.skip(1);
	systems.ADIRS.skip(2);
	setprop("/controls/adirs/mcducbtn", 1);
	setprop("/controls/switches/beacon", 1);
	setprop("/controls/switches/wing-lights", 1);
	setprop("/controls/lighting/nav-lights-switch", 1);
	setprop("/controls/radio/rmp[0]/on", 1);
	setprop("/controls/radio/rmp[1]/on", 1);
	setprop("/controls/radio/rmp[2]/on", 1);
	setprop("/systems/fadec/power-avail", 1);
	setprop("/systems/fadec/powered-time", -310);
	settimer(func {
		setprop("/controls/gear/brake-left", 0);
		setprop("/controls/gear/brake-right", 0);
		setprop("/systems/acconfig/autoconfig-running", 0);
		ps_load_dlg.close();
		ps_loaded_dlg.open();
		spinning.stop();
	}, 2);
}

# Ready to Taxi
var taxi = func {
	if (getprop("/systems/acconfig/mismatch-code") == "0x000") {
		spinning.start();
		ps_loaded_dlg.close();
		ps_load_dlg.open();
		setprop("/systems/acconfig/autoconfig-running", 1);
		setprop("/controls/gear/brake-left", 1);
		setprop("/controls/gear/brake-right", 1);
		# First, we set everything to cold and dark.
		setprop("/controls/engines/engine-start-switch", 1);
		setprop("/controls/engines/engine[0]/cutoff-switch", 1);
		setprop("/controls/engines/engine[1]/cutoff-switch", 1);
		setprop("/controls/flight/slats", 0.000);
		setprop("/controls/flight/flaps", 0.000);
		setprop("/controls/flight/flap-lever", 0);
		setprop("/controls/flight/flap-pos", 0);
		setprop("/controls/flight/flap-txt", " ");
		libraries.flaptimer.stop();
		setprop("/controls/flight/speedbrake-arm", 0);
		setprop("/controls/flight/speedbrake", 0);
		setprop("/controls/gear/gear-down", 1);
		setprop("/controls/flight/elevator-trim", 0);
		libraries.systemsInit();
		failReset();
		setprop("/controls/APU/master", 0);
		setprop("/controls/APU/start", 0);
		
		# Now the Startup!
		setprop("/controls/electrical/switches/battery1", 1);
		setprop("/controls/electrical/switches/battery2", 1);
		setprop("/controls/electrical/switches/battery3", 1);
		setprop("/controls/APU/master", 1);
		setprop("/controls/APU/start", 1);
		var apu_rpm_chk = setlistener("/systems/apu/rpm", func {
			if (getprop("/systems/apu/rpm") >= 98) {
				removelistener(apu_rpm_chk);
				taxi_b();
			}
		});
	}
}
var taxi_b = func {
	# Continue with engine start prep, and start engines.
	setprop("/controls/fuel/tank0pump1", 1);
	setprop("/controls/fuel/tank0pump2", 1);
	setprop("/controls/fuel/tank0pump3", 1);
	setprop("/controls/fuel/tank1pump1", 1);
	setprop("/controls/fuel/tank1pump2", 1);
	setprop("/controls/fuel/tank2pump1", 1);
	setprop("/controls/fuel/tank2pump2", 1);
	setprop("/controls/fuel/tank2pump3", 1);
	setprop("/controls/electrical/switches/gen-apu", 1);
	setprop("/controls/electrical/switches/galley", 1);
	setprop("/controls/electrical/switches/gen1", 1);
	setprop("/controls/electrical/switches/gen2", 1);
	setprop("/controls/pneumatic/switches/bleedapu", 1);
	setprop("/controls/pneumatic/switches/bleed1", 1);
	setprop("/controls/pneumatic/switches/bleed2", 1);
	setprop("/controls/pneumatic/switches/pack1", 1);
	setprop("/controls/pneumatic/switches/pack2", 1);
	setprop("/controls/adirs/ir[0]/knob","1");
	setprop("/controls/adirs/ir[1]/knob","1");
	setprop("/controls/adirs/ir[2]/knob","1");
	systems.ADIRS.skip(0);
	systems.ADIRS.skip(1);
	systems.ADIRS.skip(2);
	setprop("/controls/adirs/mcducbtn", 1);
	setprop("/controls/switches/beacon", 1);
	setprop("/controls/lighting/nav-lights-switch", 1);
	setprop("/controls/radio/rmp[0]/on", 1);
	setprop("/controls/radio/rmp[1]/on", 1);
	setprop("/controls/radio/rmp[2]/on", 1);
	setprop("/controls/atc/mode-knob", 2);
	atc.transponderPanel.modeSwitch(3);
	setprop("/systems/fadec/power-avail", 1);
	setprop("/systems/fadec/powered-time", -310);
	setprop("/controls/lighting/turnoff-light-switch", 1);
	setprop("/controls/lighting/taxi-light-switch", 0.5);
	setprop("/instrumentation/altimeter[0]/setting-inhg", getprop("/environment/pressure-sea-level-inhg"));
	settimer(taxi_c, 2);
}
var taxi_c = func {
	setprop("/controls/engines/engine-start-switch", 2);
	setprop("/controls/engines/engine[0]/cutoff-switch", 0);
	setprop("/controls/engines/engine[1]/cutoff-switch", 0);
	settimer(func {
		taxi_d();
	}, 10);
}
var taxi_d = func {
	# After Start items.
	setprop("/controls/engines/engine-start-switch", 1);
	setprop("/controls/APU/master", 0);
	setprop("/controls/APU/start", 0);
	setprop("/controls/pneumatic/switches/bleedapu", 0);
	setprop("/controls/gear/brake-left", 0);
	setprop("/controls/gear/brake-right", 0);
	setprop("/systems/acconfig/autoconfig-running", 0);
	ps_load_dlg.close();
	ps_loaded_dlg.open();
	spinning.stop();
}

# Ready to Takeoff
var takeoff = func {
	if (getprop("/systems/acconfig/mismatch-code") == "0x000") {
		# The same as taxi, except we set some things afterwards.
		taxi();
		var eng_one_chk_c = setlistener("/engines/engine[0]/state", func {
			if (getprop("/engines/engine[0]/state") == 3) {
				removelistener(eng_one_chk_c);
				setprop("/controls/switches/strobe", 1);
				setprop("/controls/lighting/taxi-light-switch", 1);
				setprop("/controls/switches/landing-lights", 1.0);
				setprop("/controls/flight/speedbrake-arm", 1);
				setprop("/controls/flight/flaps", 0.290);
				setprop("/controls/flight/slats", 0.666);
				setprop("/controls/flight/flap-lever", 1);
				setprop("/controls/flight/flap-pos", 2);
				setprop("/controls/flight/flap-txt", "1+F");
				setprop("/controls/atc/mode-knob", 4);
				atc.transponderPanel.modeSwitch(5);
				libraries.flaptimer.start();
				setprop("/controls/flight/elevator-trim", -0.07);
				systems.arm_autobrake(3);
				libraries.ECAM.toConfig();
			}
		});
	}
}

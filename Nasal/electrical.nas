# A3XX Electrical System
# Joshua Davidson (Octal450) and Jonathan Redpath (legoboyvdlp)

# Copyright (c) 2020 Josh Davidson (Octal450)

var ac_volt_std = 115;
var ac_volt_min = 110;
var dc_volt_std = 28;
var dc_volt_min = 25;
var dc_amps_std = 150;
var batt_amps = 2;
var tr_amps_std = 55;
var ac_hz_std = 400;
var ac1_src = "XX";
var ac2_src = "XX";
var power_consumption = nil;
var screen_power_consumption = nil;
var screens = nil;
var lpower_consumption = nil;
var light_power_consumption = nil;
var lights = nil;
var galley_sw = 0;
var idg1_sw = 0;
var idg2_sw = 0;
var gen1_sw = 0;
var gen2_sw = 0;
var gen_apu_sw = 0;
var gen_ext_sw = 0;
var apu_ext_crosstie_sw = 0;
var ac_ess_feed_sw = 0;
var battery1_sw = 0;
var battery2_sw = 0;
var manrat = 0;
var battery1_volts = 0;
var battery2_volts = 0;
var battery1_amps = 0;
var battery2_amps = 0;
var battery1_percent = 0;
var battery2_percent = 0;
var battery1_percent_calc = 0;
var battery2_percent_calc = 0;
var rpmapu = 0;
var extpwr_on = 0;
var stateL = 0;
var stateR = 0;
var xtieL = 0;
var xtieR = 0;
var ac1 = 0;
var ac2 = 0;
var ac_ess = 0;
var dc_ess_shed = 0;
var ac_ess_shed = 0;
var dc1 = 0;
var dc2 = 0;
var dcbat = 0;
var dc_ess = 0;
var gen_1_volts = 0;
var gen_2_volts = 0;
var galley_shed = 0;
var emergen = 0;
var ias = 0;
var rat = 0;
var ac_ess_fail = 0;
var batt1_fail = 0;
var batt2_fail = 0;
var gallery_fail = 0;
var genapu_fail = 0;
var gen1_fail = 0;
var gen2_fail = 0;
var bat1_volts = 0;
var bat2_volts = 0;
var replay = 0;
var wow = 0;

# Power Consumption, cockpit screens
# According to pprune, each LCD uses 60W. Will assume that it reduces linearly to ~50 watts when dimmed, and to 0 watts when off

var screen = {
	name: "",
	type: "", # LCD or CRT, will be used later when we have CRTs
	max_watts: 0,
	dim_watts: 0,
	dim_prop: "",
	elec_prop: "",
	power_consumption: func() {
		var dim_prop = me.dim_prop;
		if (getprop(me.dim_prop) != 0) {
			screen_power_consumption = (50 + (10 * getprop(dim_prop)));
		} else {
			screen_power_consumption = 0;
		} 
		return screen_power_consumption;
	},
	new: func(name,type,max_watts,dim_watts,dim_prop,elec_prop) {
		var s = {parents:[screen]};
		
		s.name = name;
		s.type = type;
		s.max_watts = max_watts;
		s.dim_watts = dim_watts;
		s.dim_prop = dim_prop;
		s.elec_prop = elec_prop;
		
		return s;
	}
};

# Power Consumption, lights
# from docs found on google

var light = {
	name: "",
	max_watts: 0,
	control_prop: "",
	elec_prop: "",
	power_consumption: func() {
		
		if (getprop(me.control_prop) != 0 and getprop(me.elec_prop) != 0) {
			light_power_consumption = me.max_watts * getprop(me.control_prop);
		} else {
			light_power_consumption = 0;
		} 
		return light_power_consumption;
	},
	new: func(name,max_watts,control_prop,elec_prop) {
		var l = {parents:[light]};
		
		l.name = name;
		l.max_watts = max_watts;
		l.control_prop = control_prop;
		l.elec_prop = elec_prop;
		
		return l;
	}
};

# Main Elec System

var ELEC = {
	init: func() {
		setprop("/systems/electrical/elac-test", 0);
		setprop("/controls/switches/annun-test", 0);
		setprop("/systems/electrical/nav-lights-power", 0);
		setprop("/controls/electrical/switches/galley", 1);
		setprop("/controls/electrical/switches/idg1", 0);
		setprop("/controls/electrical/switches/idg2", 0);
		setprop("/controls/electrical/switches/gen1", 1);
		setprop("/controls/electrical/switches/gen2", 1);
		setprop("/controls/electrical/switches/emer-gen", 0);
		setprop("/controls/electrical/switches/gen-apu", 1);
		setprop("/controls/electrical/switches/gen-ext", 0);
		setprop("/controls/electrical/switches/apu-ext-crosstie", 1);
		setprop("/controls/electrical/switches/ac-ess-feed", 0);
		setprop("/controls/electrical/switches/battery1", 0);
		setprop("/controls/electrical/switches/battery2", 0);
		setprop("/controls/electrical/switches/rat-man", 0);
		setprop("/systems/electrical/battery1-volts", 26.5);
		setprop("/systems/electrical/battery2-volts", 26.5);
		setprop("/systems/electrical/battery1-amps", 0);
		setprop("/systems/electrical/battery2-amps", 0);
		setprop("/systems/electrical/battery1-percent", 68);
		setprop("/systems/electrical/battery2-percent", 68);
		setprop("/systems/electrical/battery1-time", 0);
		setprop("/systems/electrical/battery2-time", 0);
		setprop("/systems/electrical/bus/dc1", 0);
		setprop("/systems/electrical/bus/dc2", 0);
		setprop("/systems/electrical/bus/dcbat", 0);
		setprop("/systems/electrical/bus/dc1-amps", 0);
		setprop("/systems/electrical/bus/dc2-amps", 0);
		setprop("/systems/electrical/bus/dc-ess", 0);
		setprop("/systems/electrical/bus/ac1", 0);
		setprop("/systems/electrical/bus/ac2", 0);
		setprop("/systems/electrical/bus/gen1-hz", 0);
		setprop("/systems/electrical/bus/gen2-hz", 0);
		setprop("/systems/electrical/bus/ac-ess", 0);
		setprop("/systems/electrical/bus/dc-ess-shed", 0);
		setprop("/systems/electrical/bus/ac-ess-shed", 0);
		setprop("/systems/electrical/extra/ext-volts", 0);
		setprop("/systems/electrical/extra/apu-volts", 0);
		setprop("/systems/electrical/extra/gen1-volts", 0);
		setprop("/systems/electrical/extra/gen2-volts", 0);
		setprop("/systems/electrical/extra/gen1-load", 0);
		setprop("/systems/electrical/extra/gen2-load", 0);
		setprop("/systems/electrical/extra/tr1-volts", 0);
		setprop("/systems/electrical/extra/tr2-volts", 0);
		setprop("/systems/electrical/extra/tr1-amps", 0);
		setprop("/systems/electrical/extra/tr2-amps", 0);
		setprop("/systems/electrical/extra/ext-hz", 0);
		setprop("/systems/electrical/extra/apu-hz", 0);
		setprop("/systems/electrical/extra/galleyshed", 0);
		setprop("/systems/electrical/gen-apu", 0);
		setprop("/systems/electrical/gen-ext", 0);
		setprop("/systems/electrical/on", 0);
		setprop("/systems/electrical/ac1-src", "XX");
		setprop("/systems/electrical/ac2-src", "XX");
		setprop("/systems/electrical/galley-fault", 0);
		setprop("/systems/electrical/idg1-fault", 0);
		setprop("/systems/electrical/gen1-fault", 0);
		setprop("/systems/electrical/apugen-fault", 0);
		setprop("/systems/electrical/batt1-fault", 0);
		setprop("/systems/electrical/batt2-fault", 0);
		setprop("/systems/electrical/ac-ess-feed-fault", 0);
		setprop("/systems/electrical/gen2-fault", 0);
		setprop("/systems/electrical/idg2-fault", 0);
		setprop("/controls/electrical/xtie/xtieL", 0);
		setprop("/controls/electrical/xtie/xtieR", 0);
		setprop("/controls/electrical/rat", 0);
		setprop("/systems/electrical/battery-available", 0);
		setprop("/systems/electrical/dc2-available", 0);
		# Below are standard FG Electrical stuff to keep things working when the plane is powered
		setprop("/systems/electrical/outputs/adf", 0);
		setprop("/systems/electrical/outputs/audio-panel", 0);
		setprop("/systems/electrical/outputs/audio-panel[1]", 0);
		setprop("/systems/electrical/outputs/autopilot", 0);
		setprop("/systems/electrical/outputs/avionics-fan", 0);
		setprop("/systems/electrical/outputs/beacon", 0);
		setprop("/systems/electrical/outputs/bus", 0);
		setprop("/systems/electrical/outputs/cabin-lights", 0);
		setprop("/systems/electrical/outputs/dme", 0);
		setprop("/systems/electrical/outputs/efis", 0);
		setprop("/systems/electrical/outputs/flaps", 0);
		setprop("/systems/electrical/outputs/fuel-pump", 0);
		setprop("/systems/electrical/outputs/fuel-pump[1]", 0);
		setprop("/systems/electrical/outputs/gps", 0);
		setprop("/systems/electrical/outputs/gps-mfd", 0);
		setprop("/systems/electrical/outputs/hsi", 0);
		setprop("/systems/electrical/outputs/instr-ignition-switch", 0);
		setprop("/systems/electrical/outputs/instrument-lights", 0);
		setprop("/systems/electrical/outputs/landing-lights", 0);
		setprop("/systems/electrical/outputs/map-lights", 0);
		setprop("/systems/electrical/outputs/mk-viii", 0);
		setprop("/systems/electrical/outputs/nav", 0);
		setprop("/systems/electrical/outputs/nav[1]", 0);
		setprop("/systems/electrical/outputs/nav[2]", 0);
		setprop("/systems/electrical/outputs/nav[3]", 0);
		setprop("/systems/electrical/outputs/pitot-head", 0);
		setprop("/systems/electrical/outputs/stobe-lights", 0);
		setprop("/systems/electrical/outputs/tacan", 0);
		setprop("/systems/electrical/outputs/taxi-lights", 0);
		setprop("/systems/electrical/outputs/turn-coordinator", 0);
		
		screens = [screen.new(name: "DU1", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du1", elec_prop:"/systems/electrical/bus/ac-ess"),
			screen.new(name: "DU2", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du2", elec_prop:"/systems/electrical/bus/ac-ess-shed"),
			screen.new(name: "DU3", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du3", elec_prop:"/systems/electrical/bus/ac-ess"),
			screen.new(name: "DU4", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du4", elec_prop:"/systems/electrical/bus/ac2"),
			screen.new(name: "DU5", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du5", elec_prop:"/systems/electrical/bus/ac2"),
			screen.new(name: "DU6", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du6", elec_prop:"/systems/electrical/bus/ac2")];
		
		lights = [light.new(name: "logo-left", max_watts:31.5, control_prop:"/sim/model/lights/logo-lights", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "logo-right", max_watts:31.5, control_prop:"/sim/model/lights/logo-lights", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "upper-beacon", max_watts:40, control_prop:"/sim/model/lights/beacon/state", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "lower-beacon", max_watts:40, control_prop:"/sim/model/lights/beacon/state", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "strobe-left", max_watts:38, control_prop:"/sim/model/lights/strobe/state", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "strobe-right", max_watts:38, control_prop:"/sim/model/lights/strobe/state", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "tail-strobe", max_watts:12, control_prop:"/sim/model/lights/tailstrobe/state", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "tail-strobe-ctl", max_watts:30, control_prop:"/sim/model/lights/tailstrobe/state", elec_prop:"/systems/electrical/bus/ac2"), 
			light.new(name: "tail-nav", max_watts:12, control_prop:"/sim/model/lights/nav-lights", elec_prop:"/systems/electrical/nav-lights-power"),
			light.new(name: "left-nav", max_watts:12, control_prop:"/sim/model/lights/nav-lights", elec_prop:"/systems/electrical/nav-lights-power"),
			light.new(name: "right-nav", max_watts:12, control_prop:"/sim/model/lights/nav-lights", elec_prop:"/systems/electrical/nav-lights-power"),
			light.new(name: "left-land", max_watts:39, control_prop:"/controls/lighting/landing-lights[1]", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "right-land", max_watts:39, control_prop:"/controls/lighting/landing-lights[2]", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "left-taxi", max_watts:31, control_prop:"/sim/model/lights/nose-lights", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "right-taxi", max_watts:31, control_prop:"/sim/model/lights/nose-lights", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "left-turnoff", max_watts:21, control_prop:"/controls/lighting/leftturnoff", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "right-turnoff", max_watts:21, control_prop:"/controls/lighting/rightturnoff", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "left-wing", max_watts:24, control_prop:"/controls/lighting/wing-lights", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "right-wing", max_watts:24, control_prop:"/controls/lighting/wing-lights", elec_prop:"/systems/electrical/bus/ac2"),
			
			light.new(name: "left-dome", max_watts:10, control_prop:"/controls/lighting/dome-norm", elec_prop:"/systems/electrical/bus/dc-ess"),
			light.new(name: "right-dome", max_watts:10, control_prop:"/controls/lighting/dome-norm", elec_prop:"/systems/electrical/bus/dc-ess")];
	},
	loop: func() {
		galley_sw = getprop("/controls/electrical/switches/galley");
		idg1_sw = getprop("/controls/electrical/switches/idg1");
		idg2_sw = getprop("/controls/electrical/switches/idg2");
		gen1_sw = getprop("/controls/electrical/switches/gen1");
		gen2_sw = getprop("/controls/electrical/switches/gen2");
		gen_apu_sw = getprop("/controls/electrical/switches/gen-apu");
		gen_ext_sw = getprop("/controls/electrical/switches/gen-ext");
		apu_ext_crosstie_sw = getprop("/controls/electrical/switches/apu-ext-crosstie");
		ac_ess_feed_sw = getprop("/controls/electrical/switches/ac-ess-feed");
		battery1_sw = getprop("/controls/electrical/switches/battery1");
		battery2_sw = getprop("/controls/electrical/switches/battery2");
		manrat = getprop("/controls/electrical/switches/rat-man");
		battery1_volts = getprop("/systems/electrical/battery1-volts");
		battery2_volts = getprop("/systems/electrical/battery2-volts");
		battery1_percent = getprop("/systems/electrical/battery1-percent");
		battery2_percent = getprop("/systems/electrical/battery2-percent");
		rpmapu = getprop("/systems/apu/rpm");
		extpwr_on = getprop("/controls/switches/cart");
		stateL = getprop("/engines/engine[0]/state");
		stateR = getprop("/engines/engine[1]/state");
		ac1 = getprop("/systems/electrical/bus/ac1");
		ac2 = getprop("/systems/electrical/bus/ac2");
		ac_ess = getprop("/systems/electrical/bus/ac-ess");
		dc_ess_shed = getprop("/systems/electrical/bus/dc-ess-shed");
		ac_ess_shed = getprop("/systems/electrical/bus/ac-ess-shed");
		dc1 = getprop("/systems/electrical/bus/dc1");
		dc2 = getprop("/systems/electrical/bus/dc2");
		dcbat = getprop("/systems/electrical/bus/dcbat");
		dc_ess = getprop("/systems/electrical/bus/dc-ess");
		gen_1_volts = getprop("/systems/electrical/extra/gen1-volts");
		gen_2_volts = getprop("/systems/electrical/extra/gen2-volts");
		galley_shed = getprop("/systems/electrical/extra/galleyshed");
		emergen = getprop("/controls/electrical/switches/emer-gen");
		ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
		rat = getprop("/controls/electrical/rat");
		ac_ess_fail = getprop("/systems/failures/elec-ac-ess");
		batt1_fail = getprop("/systems/failures/elec-batt1");
		batt2_fail = getprop("/systems/failures/elec-batt2");
		gallery_fail = getprop("/systems/failures/elec-galley");
		genapu_fail = getprop("/systems/failures/elec-genapu");
		gen1_fail = getprop("/systems/failures/elec-gen1");
		gen2_fail = getprop("/systems/failures/elec-gen2");
		replay = getprop("/sim/replay/replay-state");
		wow = getprop("/gear/gear[1]/wow");
		
		if (battery1_volts >= 20 and battery1_sw and !batt1_fail) {
			setprop("/systems/electrical/battery1-amps", batt_amps);
		} else {
			setprop("/systems/electrical/battery1-amps", 0);
		}
		
		if (battery2_volts >= 20 and battery2_sw and !batt2_fail) {
			setprop("/systems/electrical/battery2-amps", batt_amps);
		} else {
			setprop("/systems/electrical/battery2-amps", 0);
		}
		
		battery1_amps = getprop("/systems/electrical/battery1-amps");
		battery2_amps = getprop("/systems/electrical/battery2-amps");
		
		if (battery1_amps > 0 or battery2_amps > 0) {
			setprop("/systems/electrical/bus/dcbat", dc_volt_std);
		} else {
			setprop("/systems/electrical/bus/dcbat", 0);
		}
		
		if (battery1_sw == 0 and battery2_sw == 0) {
			setprop("/systems/electrical/battery-available", 0);
		}
		
		if (dc2 >= 25) {
			setprop("/systems/electrical/dc2-available", 1);
		} else {
			setprop("/systems/electrical/dc2-available", 0);
		}
		
		dcbat = getprop("/systems/electrical/bus/dcbat");
		
		if (extpwr_on and gen_ext_sw) {
			setprop("/systems/electrical/gen-ext", 1);
			
		} else {
			setprop("/systems/electrical/gen-ext", 0);
		} 
		
		if (rpmapu >= 94.9 and gen_apu_sw and !gen_ext_sw) {
			setprop("/systems/electrical/gen-apu", 1);
		} else {
			setprop("/systems/electrical/gen-apu", 0);
		}
		
		gen_apu = getprop("/systems/electrical/gen-apu");
		gen_ext = getprop("/systems/electrical/gen-ext");
		
		# Left cross tie yes?
		if (stateL == 3 and gen1_sw and !gen1_fail) {
			setprop("/controls/electrical/xtie/xtieR", 1);
		} else if (extpwr_on and gen_ext_sw) {
			setprop("/controls/electrical/xtie/xtieR", 1);
		} else if (rpmapu >= 94.9 and gen_apu_sw and !genapu_fail) {
			setprop("/controls/electrical/xtie/xtieR", 1);
		} else {
			setprop("/controls/electrical/xtie/xtieR", 0);
		}
		
		# Right cross tie yes?
		if (stateR == 3 and gen2_sw and !gen2_fail) {
			setprop("/controls/electrical/xtie/xtieL", 1);
		} else if (extpwr_on and gen_ext_sw) {
			setprop("/controls/electrical/xtie/xtieL", 1);
		} else if (rpmapu >= 94.9 and gen_apu_sw and !genapu_fail) {
			setprop("/controls/electrical/xtie/xtieL", 1);
		} else {
			setprop("/controls/electrical/xtie/xtieL", 0);
		}
		
		xtieL = getprop("/controls/electrical/xtie/xtieL");
		xtieR = getprop("/controls/electrical/xtie/xtieR");
		
		# Left DC bus yes?
		if (stateL == 3 and gen1_sw and !gen1_fail) {
			setprop("/systems/electrical/bus/dc1", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/extra/tr1-volts", dc_volt_std);
			setprop("/systems/electrical/bus/dc1-amps", dc_amps_std);
			setprop("/systems/electrical/extra/tr1-amps", tr_amps_std);
		} else if (extpwr_on and gen_ext_sw and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/dc1", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/extra/tr1-volts", dc_volt_std);
			setprop("/systems/electrical/bus/dc1-amps", dc_amps_std);
			setprop("/systems/electrical/extra/tr1-amps", tr_amps_std);
		} else if (gen_apu and !genapu_fail and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/dc1", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/extra/tr1-volts", dc_volt_std);
			setprop("/systems/electrical/bus/dc1-amps", dc_amps_std);
			setprop("/systems/electrical/extra/tr1-amps", tr_amps_std);
		} else if (apu_ext_crosstie_sw == 1 and xtieL) {
			setprop("/systems/electrical/bus/dc1", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/extra/tr1-volts", dc_volt_std);
			setprop("/systems/electrical/bus/dc1-amps", dc_amps_std);
			setprop("/systems/electrical/extra/tr1-amps", tr_amps_std);
		} else if (emergen) {
			setprop("/systems/electrical/bus/dc1", 0);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/extra/tr1-volts", 0);
			setprop("/systems/electrical/bus/dc1-amps", 0);
			setprop("/systems/electrical/extra/tr1-amps", 0);
		} else if (dcbat and ias >= 50) {
			setprop("/systems/electrical/bus/dc1", 0);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/extra/tr1-volts", 0);
			setprop("/systems/electrical/bus/dc1-amps", 0);
			setprop("/systems/electrical/extra/tr1-amps", 0);
		} else {
			setprop("/systems/electrical/bus/dc1", 0);
			setprop("/systems/electrical/extra/tr1-volts", 0);
			setprop("/systems/electrical/bus/dc1-amps", 0);
			setprop("/systems/electrical/extra/tr1-amps", 0);
			setprop("/systems/electrical/bus/dc-ess", 0);
		}
		
		# Right DC bus yes?
		if (stateR == 3 and gen2_sw and !gen2_fail) {
			setprop("/systems/electrical/bus/dc2", dc_volt_std);
			setprop("/systems/electrical/extra/tr2-volts", dc_volt_std);
			setprop("/systems/electrical/bus/dc2-amps", dc_amps_std);
			setprop("/systems/electrical/extra/tr2-amps", tr_amps_std);
		} else if (extpwr_on and gen_ext_sw and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/dc2", dc_volt_std);
			setprop("/systems/electrical/extra/tr2-volts", dc_volt_std);
			setprop("/systems/electrical/bus/dc2-amps", dc_amps_std);
			setprop("/systems/electrical/extra/tr2-amps", tr_amps_std);
		} else if (gen_apu and !genapu_fail and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/dc2", dc_volt_std);
			setprop("/systems/electrical/extra/tr2-volts", dc_volt_std);
			setprop("/systems/electrical/bus/dc2-amps", dc_amps_std);
			setprop("/systems/electrical/extra/tr2-amps", tr_amps_std);
		} else if (apu_ext_crosstie_sw == 1  and xtieR) {
			setprop("/systems/electrical/bus/dc2", dc_volt_std);
			setprop("/systems/electrical/extra/tr2-volts", dc_volt_std);
			setprop("/systems/electrical/bus/dc2-amps", dc_amps_std);
			setprop("/systems/electrical/extra/tr2-amps", tr_amps_std);
		} else if (emergen) {
			setprop("/systems/electrical/bus/dc2", 0);
			setprop("/systems/electrical/extra/tr2-volts", 0);
			setprop("/systems/electrical/bus/dc2-amps", 0);
			setprop("/systems/electrical/extra/tr2-amps", 0);
		} else if (dcbat and ias >= 50) {
			setprop("/systems/electrical/bus/dc2", 0);
			setprop("/systems/electrical/extra/tr2-volts", 0);
			setprop("/systems/electrical/bus/dc2-amps", 0);
			setprop("/systems/electrical/extra/tr2-amps", 0);
		} else {
			setprop("/systems/electrical/bus/dc2", 0);
			setprop("/systems/electrical/extra/tr2-volts", 0);
			setprop("/systems/electrical/bus/dc2-amps", 0);
			setprop("/systems/electrical/extra/tr2-amps", 0);
		}
		
		# Left AC bus yes?
		if (stateL == 3 and gen1_sw and !gen1_fail) {
			setprop("/systems/electrical/bus/ac1", ac_volt_std);
			ac1_src = "GEN";
		} else if (extpwr_on and gen_ext_sw and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/ac1", ac_volt_std);
			ac1_src = "EXT";
		} else if (gen_apu and !genapu_fail and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/ac1", ac_volt_std);
			ac1_src = "APU";
		} else if (apu_ext_crosstie_sw == 1 and xtieL) {
			setprop("/systems/electrical/bus/ac1", ac_volt_std);
			ac1_src = "XTIE";
		} else if (emergen) {
			setprop("/systems/electrical/bus/ac1", 0);
			ac1_src = "ESSRAT";
		} else if (dcbat and ias >= 50) {
			setprop("/systems/electrical/bus/ac1", 0);
			ac1_src = "ESSBAT";
		} else {
			setprop("/systems/electrical/bus/ac1", 0);
			ac1_src = "XX";
		}
		
		# Right AC bus yes?
		if (stateR == 3 and gen2_sw and !gen2_fail) {
			setprop("/systems/electrical/bus/ac2", ac_volt_std);
			ac2_src = "GEN";
		} else if (extpwr_on and gen_ext_sw and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/ac2", ac_volt_std);
			ac2_src = "EXT";
		} else if (gen_apu and !genapu_fail and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/ac2", ac_volt_std);
			ac2_src = "APU";
		} else if (apu_ext_crosstie_sw == 1  and xtieR) {
			setprop("/systems/electrical/bus/ac2", ac_volt_std);
			ac2_src = "XTIE";
		} else if (emergen) {
			setprop("/systems/electrical/bus/ac2", 0);
			ac2_src = "ESSRAT";
		} else if (dcbat and ias >= 50) {
			setprop("/systems/electrical/bus/ac2", 0);
			ac2_src = "ESSBAT";
		} else {
			setprop("/systems/electrical/bus/ac2", 0);
			ac2_src = "XX";
		}
		
		ac1 = getprop("/systems/electrical/bus/ac1");
		ac2 = getprop("/systems/electrical/bus/ac2");
		
		# AC ESS bus yes?
		if (!ac_ess_fail) {
			if (ac1 >= 110 and !ac_ess_feed_sw) {
				setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
			} else if (ac2 >= 110 and ac_ess_feed_sw) {
				setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
			} else if (emergen or (dcbat and ias >= 50)) {
				setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
			} else {
				setprop("/systems/electrical/bus/ac-ess", 0);
			}
		} else {
			setprop("/systems/electrical/bus/ac-ess", 0);
		}
		
		ac_ess = getprop("/systems/electrical/bus/ac-ess");
		
		# HZ/Volts yes?
		if (stateL == 3 and gen1_sw and !gen1_fail) {
			setprop("/systems/electrical/extra/gen1-volts", ac_volt_std);
			setprop("/systems/electrical/bus/gen1-hz", ac_hz_std);
		} else {
			setprop("/systems/electrical/extra/gen1-volts", 0);
			setprop("/systems/electrical/bus/gen1-hz", 0);
		}
		
		if (stateR == 3 and gen2_sw and !gen2_fail) {
			setprop("/systems/electrical/extra/gen2-volts", ac_volt_std);
			setprop("/systems/electrical/bus/gen2-hz", ac_hz_std);
		} else {
			setprop("/systems/electrical/extra/gen2-volts", 0);
			setprop("/systems/electrical/bus/gen2-hz", 0);
		}
		
		if (extpwr_on and gen_ext_sw) {
			setprop("/systems/electrical/extra/ext-volts", ac_volt_std);
			setprop("/systems/electrical/extra/ext-hz", ac_hz_std);
		} else {
			setprop("/systems/electrical/extra/ext-volts", 0);
			setprop("/systems/electrical/extra/ext-hz", 0);
		}
		
		if (gen_apu and !genapu_fail) {
			setprop("/systems/electrical/extra/apu-volts", ac_volt_std);
			setprop("/systems/electrical/extra/apu-hz", ac_hz_std);
		} else {
			setprop("/systems/electrical/extra/apu-volts", 0);
			setprop("/systems/electrical/extra/apu-hz", 0);
		}
		
		if (ac1 == 0 and ac2 == 0 and emergen == 0) {
			setprop("/systems/electrical/bus/ac-ess-shed", 0);
		} else {
			setprop("/systems/electrical/bus/ac-ess-shed", ac_volt_std);
		}
		
		if (ac_ess >= 110 and !gallery_fail) {
			if (galley_sw == 1 and !galley_shed) { 
				setprop("/systems/electrical/bus/galley", ac_volt_std);
			} else if (galley_sw or galley_shed) {
				setprop("/systems/electrical/bus/galley", 0);
			}
		} else {
			setprop("/systems/electrical/bus/galley", 0);
		}
		
		if (!gen_apu and !gen_ext_sw and (!gen1_sw or !gen2_sw)) {
			setprop("/systems/electrical/extra/galleyshed", 1);
		} else {
			setprop("/systems/electrical/extra/galleyshed", 0);
		}
		
		if (ac1 < 110 and ac2 < 110 and ias >= 100 and replay == 0) {
			setprop("/controls/hydraulic/rat-deployed", 1);
			setprop("/controls/electrical/rat", 1);
			setprop("/controls/electrical/switches/emer-gen", 1);
		} else if (manrat) {
			setprop("/controls/hydraulic/rat-deployed", 1);
			setprop("/controls/electrical/rat", 1);
			setprop("/controls/electrical/switches/emer-gen", 1);
		}
		
		if (ias < 100 or ac1 >= 110 or ac2 >= 110) {
			setprop("/controls/electrical/switches/emer-gen", 0);
		}
		
		if (emergen == 0 and ac1 == 0 and ac2 == 0) { # as far as I know dc ess is only shed when batteries only
			setprop("/systems/electrical/bus/dc-ess-shed", 0);
		} else {
			setprop("/systems/electrical/bus/dc-ess-shed", ac_volt_std);
		}
		
		dc1 = getprop("/systems/electrical/bus/dc1");
		dc2 = getprop("/systems/electrical/bus/dc2");
		
		if (battery1_percent < 100 and (dc1 > 25 or dc2 > 25) and battery1_sw and !batt1_fail) {
			if (getprop("/systems/electrical/battery1-time") + 5 < getprop("/sim/time/elapsed-sec")) {
				battery1_percent_calc = battery1_percent + 0.75; # Roughly 90 percent every 10 mins
				if (battery1_percent_calc > 100) {
					battery1_percent_calc = 100;
				}
				setprop("/systems/electrical/battery1-percent", battery1_percent_calc);
				setprop("/systems/electrical/battery1-time", getprop("/sim/time/elapsed-sec"));
			}
		} else if (battery1_percent == 100 and (dc1 > 25 or dc2 > 25) and battery1_sw and !batt1_fail) {
			setprop("/systems/electrical/battery1-time", getprop("/sim/time/elapsed-sec"));
		} else if (battery1_amps > 0 and battery1_sw and !batt1_fail) {
			if (getprop("/systems/electrical/battery1-time") + 5 < getprop("/sim/time/elapsed-sec")) {
				battery1_percent_calc = battery1_percent - 0.25; # Roughly 90 percent every 30 mins
				if (battery1_percent_calc < 0) {
					battery1_percent_calc = 0;
				}
				setprop("/systems/electrical/battery1-percent", battery1_percent_calc);
				setprop("/systems/electrical/battery1-time", getprop("/sim/time/elapsed-sec"));
			}
		} else {
			setprop("/systems/electrical/battery1-time", getprop("/sim/time/elapsed-sec"));
		}
		
		if (battery2_percent < 100 and (dc1 > 25 or dc2 > 25) and battery2_sw and !batt2_fail) {
			if (getprop("/systems/electrical/battery2-time") + 5 < getprop("/sim/time/elapsed-sec")) {
				battery2_percent_calc = battery2_percent + 0.75; # Roughly 90 percent every 10 mins
				if (battery2_percent_calc > 100) {
					battery2_percent_calc = 100;
				}
				setprop("/systems/electrical/battery2-percent", battery2_percent_calc);
				setprop("/systems/electrical/battery2-time", getprop("/sim/time/elapsed-sec"));
			}
		} else if (battery2_percent == 100 and (dc1 > 25 or dc2 > 25) and battery2_sw and !batt2_fail) {
			setprop("/systems/electrical/battery2-time", getprop("/sim/time/elapsed-sec"));
		} else if (battery2_amps > 0 and battery2_sw and !batt2_fail) {
			if (getprop("/systems/electrical/battery2-time") + 5 < getprop("/sim/time/elapsed-sec")) {
				battery2_percent_calc = battery2_percent - 0.25; # Roughly 90 percent every 30 mins
				if (battery2_percent_calc < 0) {
					battery2_percent_calc = 0;
				}
				setprop("/systems/electrical/battery2-percent", battery2_percent_calc);
				setprop("/systems/electrical/battery2-time", getprop("/sim/time/elapsed-sec"));
			}
		} else {
			setprop("/systems/electrical/battery2-time", getprop("/sim/time/elapsed-sec"));
		}
		
		battery1_percent = getprop("/systems/electrical/battery1-percent");
		battery2_percent = getprop("/systems/electrical/battery2-percent");
		
		if (battery1_percent >= 10) {
			setprop("/systems/electrical/battery1-volts", math.clamp(24 + (battery1_percent - 10) * (27.9 - 24) / (100 - 10), 24, 27.9));
		} else {
			setprop("/systems/electrical/battery1-volts", math.clamp(battery1_percent * (24) / (10), 0, 24));
		}
		
		if (battery2_percent >= 10) {
			setprop("/systems/electrical/battery2-volts", math.clamp(24 + (battery2_percent - 10) * (27.9 - 24) / (100 - 10), 24, 30));
		} else {
			setprop("/systems/electrical/battery2-volts", math.clamp(battery2_percent * (24) / (10), 0, 24));
		}
		
		dc_ess = getprop("/systems/electrical/bus/dc-ess");
		
		if (dc2 < 25) {
			if (getprop("/it-autoflight/output/ap2") == 1) {
				#libraries.apOff("hard", 2);
				setprop("it-autoflight/input/ap2", 0);
			}
		}
		
		if (dc_ess < 25 and dc2 < 25) {
			if (getprop("/it-autoflight/output/athr") == 1) {
				#libraries.athrOff("hard");
				setprop("it-autoflight/input/athr", 0);
			}
		}
		
		if (dc_ess < 25) {
			if (getprop("/it-autoflight/output/ap1") == 1) {
				#libraries.apOff("hard", 1);
				setprop("it-autoflight/input/ap1", 0);
			}
			
			setprop("systems/electrical/on", 0);
			setprop("/systems/thrust/thr-locked", 0);
			setprop("/systems/electrical/outputs/adf", 0);
			setprop("/systems/electrical/outputs/audio-panel", 0);
			setprop("/systems/electrical/outputs/audio-panel[1]", 0);
			setprop("/systems/electrical/outputs/autopilot", 0);
			setprop("/systems/electrical/outputs/avionics-fan", 0);
			setprop("/systems/electrical/outputs/beacon", 0);
			setprop("/systems/electrical/outputs/bus", 0);
			setprop("/systems/electrical/outputs/cabin-lights", 0);
			setprop("/systems/electrical/outputs/dme", 0);
			setprop("/systems/electrical/outputs/efis", 0);
			setprop("/systems/electrical/outputs/flaps", 0);
			setprop("/systems/electrical/outputs/fuel-pump", 0);
			setprop("/systems/electrical/outputs/fuel-pump[1]", 0);
			setprop("/systems/electrical/outputs/gps", 0);
			setprop("/systems/electrical/outputs/gps-mfd", 0);
			setprop("/systems/electrical/outputs/hsi", 0);
			setprop("/systems/electrical/outputs/instr-ignition-switch", 0);
			setprop("/systems/electrical/outputs/instrument-lights", 0);
			setprop("/systems/electrical/outputs/landing-lights", 0);
			setprop("/systems/electrical/outputs/map-lights", 0);
			setprop("/systems/electrical/outputs/mk-viii", 0);
			setprop("/systems/electrical/outputs/nav", 0);
			setprop("/systems/electrical/outputs/nav[1]", 0);
			setprop("/systems/electrical/outputs/nav[2]", 0);
			setprop("/systems/electrical/outputs/nav[3]", 0);
			setprop("/systems/electrical/outputs/pitot-head", 0);
			setprop("/systems/electrical/outputs/stobe-lights", 0);
			setprop("/systems/electrical/outputs/tacan", 0);
			setprop("/systems/electrical/outputs/taxi-lights", 0);
			setprop("/systems/electrical/outputs/turn-coordinator", 0);
			setprop("/controls/lighting/fcu-panel-norm", 0);
			setprop("/controls/lighting/main-panel-norm", 0);
			setprop("/controls/lighting/overhead-panel-norm", 0);
		} else {
			setprop("/systems/electrical/on", 1);
			setprop("/systems/electrical/outputs/adf", dc_volt_std);
			setprop("/systems/electrical/outputs/audio-panel", dc_volt_std);
			setprop("/systems/electrical/outputs/audio-panel[1]", dc_volt_std);
			setprop("/systems/electrical/outputs/autopilot", dc_volt_std);
			setprop("/systems/electrical/outputs/avionics-fan", dc_volt_std);
			setprop("/systems/electrical/outputs/beacon", dc_volt_std);
			setprop("/systems/electrical/outputs/bus", dc_volt_std);
			setprop("/systems/electrical/outputs/cabin-lights", dc_volt_std);
			setprop("/systems/electrical/outputs/dme", dc_volt_std);
			setprop("/systems/electrical/outputs/efis", dc_volt_std);
			setprop("/systems/electrical/outputs/flaps", dc_volt_std);
			setprop("/systems/electrical/outputs/fuel-pump", dc_volt_std);
			setprop("/systems/electrical/outputs/fuel-pump[1]", dc_volt_std);
			setprop("/systems/electrical/outputs/gps", dc_volt_std);
			setprop("/systems/electrical/outputs/gps-mfd", dc_volt_std);
			setprop("/systems/electrical/outputs/hsi", dc_volt_std);
			setprop("/systems/electrical/outputs/instr-ignition-switch", dc_volt_std);
			setprop("/systems/electrical/outputs/instrument-lights", dc_volt_std);
			setprop("/systems/electrical/outputs/landing-lights", dc_volt_std);
			setprop("/systems/electrical/outputs/map-lights", dc_volt_std);
			setprop("/systems/electrical/outputs/mk-viii", dc_volt_std);
			setprop("/systems/electrical/outputs/nav", dc_volt_std);
			setprop("/systems/electrical/outputs/nav[1]", dc_volt_std);
			setprop("/systems/electrical/outputs/nav[2]", dc_volt_std);
			setprop("/systems/electrical/outputs/nav[3]", dc_volt_std);
			setprop("/systems/electrical/outputs/pitot-head", dc_volt_std);
			setprop("/systems/electrical/outputs/stobe-lights", dc_volt_std);
			setprop("/systems/electrical/outputs/tacan", dc_volt_std);
			setprop("/systems/electrical/outputs/taxi-lights", dc_volt_std);
			setprop("/systems/electrical/outputs/turn-coordinator", dc_volt_std);
			setprop("/controls/lighting/fcu-panel-norm", getprop("/controls/lighting/fcu-panel-knb"));
			setprop("/controls/lighting/main-panel-norm", getprop("/controls/lighting/main-panel-knb"));
			setprop("/controls/lighting/overhead-panel-norm", getprop("/controls/lighting/overhead-panel-knb"));
		}
		
		setprop("/systems/electrical/ac1-src", ac1_src);
		setprop("/systems/electrical/ac2-src", ac2_src);
		
		# Fault lights
		if (gallery_fail and galley_sw) {
			setprop("/systems/electrical/galley-fault", 1);
		} else {
			setprop("/systems/electrical/galley-fault", 0);
		}
		
		if (batt1_fail and battery1_sw) {
			setprop("/systems/electrical/batt1-fault", 1);
		} else {
			setprop("/systems/electrical/batt1-fault", 0);
		}
		
		if (batt2_fail and battery2_sw) {
			setprop("/systems/electrical/batt2-fault", 1);
		} else {
			setprop("/systems/electrical/batt2-fault", 0);
		}
		
		if ((gen1_fail and gen1_sw) or (gen1_sw and stateL != 3)) {
			setprop("/systems/electrical/gen1-fault", 1);
		} else {
			setprop("/systems/electrical/gen1-fault", 0);
		}
		
		if (ac_ess_fail) {
			setprop("/systems/electrical/ac-ess-feed-fault", 1);
		} else {
			setprop("/systems/electrical/ac-ess-feed-fault", 0);
		}
		
		if (genapu_fail and gen_apu_sw) {
			setprop("/systems/electrical/apugen-fault", 1);
		} else {
			setprop("/systems/electrical/apugen-fault", 0);
		}
		
		if ((gen2_fail and gen2_sw) or (gen2_sw and stateR != 3)) {
			setprop("/systems/electrical/gen2-fault", 1);
		} else {
			setprop("/systems/electrical/gen2-fault", 0);
		}
		
		# these two are here because they are on whenever the battery switch is on with no ac source connected (youtube)
		
		if ((battery1_sw or battery2_sw) and dc1 < 25 and ac1 < 110) {
			setprop("/controls/ventilation/blowFail", 1);
		} else {
			setprop("/controls/ventilation/blowFail", 0);
		}
		
		foreach(var screena;screens) { 
			power_consumption = screena.power_consumption();
			if (getprop(screena.elec_prop) != 0) {
				setprop("/systems/electrical/DU/" ~ screena.name ~ "/watts", power_consumption);
			} else {
				setprop("/systems/electrical/DU/" ~ screena.name ~ "/watts", 0);
			}
		}
		
		foreach(var lighta;lights) { 
			power_consumption = lighta.power_consumption();
			if (getprop(lighta.elec_prop) != 0 and getprop(lighta.control_prop) != 0) {
				setprop("/systems/electrical/light/" ~ lighta.name ~ "/watts", power_consumption);
			} else {
				setprop("/systems/electrical/light/" ~ lighta.name ~ "/watts", 0);
			}
		}
	},
};

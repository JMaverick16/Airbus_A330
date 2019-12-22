# A3XX Lower ECAM Canvas

# Copyright (c) 2019 Joshua Davidson (Octal450)

var lowerECAM_apu = nil;
var lowerECAM_eng = nil;
var lowerECAM_fctl = nil;
var lowerECAM_test = nil;
var lowerECAM_display = nil;
var page = "fctl";
var oat = getprop("/environment/temperature-degc");
var blue_psi = 0;
var green_psi = 0;
var yellow_psi = 0;
var elapsedtime = 0;
setprop("/systems/electrical/extra/apu-load", 0);
setprop("/systems/electrical/extra/apu-volts", 0);
setprop("/systems/electrical/extra/apu-hz", 0);
setprop("/systems/pneumatic/bleedapu", 0);
setprop("/engines/engine[0]/oil-psi-actual", 0);
setprop("/engines/engine[1]/oil-psi-actual", 0);
setprop("/ECAM/Lower/APU-N", 0);
setprop("/ECAM/Lower/APU-EGT", 0);
setprop("/ECAM/Lower/Oil-QT[0]", 0);
setprop("/ECAM/Lower/Oil-QT[1]", 0);
setprop("/ECAM/Lower/Oil-PSI[0]", 0);
setprop("/ECAM/Lower/Oil-PSI[1]", 0);
setprop("/ECAM/Lower/aileron-ind-in-left", 0);
setprop("/ECAM/Lower/aileron-ind-in-right", 0);
setprop("/ECAM/Lower/aileron-ind-out-left", 0);
setprop("/ECAM/Lower/aileron-ind-out-right", 0);
setprop("/ECAM/Lower/elevator-ind-left", 0);
setprop("/ECAM/Lower/elevator-ind-right", 0);
setprop("/ECAM/Lower/elevator-trim-deg", 0);
setprop("/fdm/jsbsim/hydraulics/rudder/final-deg", 0);
setprop("/environment/temperature-degc", 0);
setprop("/FMGC/internal/gw", 0);
setprop("/instrumentation/du/du4-test", 0);
setprop("/instrumentation/du/du4-test-time", 0);
setprop("/instrumentation/du/du4-test-amount", 0);

var canvas_lowerECAM_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});

		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		elapsedtime = getprop("/sim/time/elapsed-sec");
		if (getprop("/systems/electrical/bus/ac2") >= 110) {
			if (getprop("/gear/gear[0]/wow") == 1) {
				if (getprop("/systems/acconfig/autoconfig-running") != 1 and getprop("/instrumentation/du/du4-test") != 1) {
					setprop("/instrumentation/du/du4-test", 1);
					setprop("/instrumentation/du/du4-test-amount", math.round((rand() * 5 ) + 35, 0.1));
					setprop("/instrumentation/du/du4-test-time", getprop("/sim/time/elapsed-sec"));
				} else if (getprop("/systems/acconfig/autoconfig-running") == 1 and getprop("/instrumentation/du/du4-test") != 1) {
					setprop("/instrumentation/du/du4-test", 1);
					setprop("/instrumentation/du/du4-test-amount", math.round((rand() * 5 ) + 35, 0.1));
					setprop("/instrumentation/du/du4-test-time", getprop("/sim/time/elapsed-sec") - 30);
				}
			} else {
				setprop("/instrumentation/du/du4-test", 1);
				setprop("/instrumentation/du/du4-test-amount", 0);
				setprop("/instrumentation/du/du4-test-time", -100);
			}
		} else if (getprop("/systems/electrical/ac1-src") == "XX" or getprop("/systems/electrical/ac2-src") == "XX") {
			setprop("/instrumentation/du/du4-test", 0);
		}
		
		if (getprop("/systems/electrical/bus/ac2") >= 110 and getprop("/controls/lighting/DU/du4") > 0.01) {
			if (getprop("/instrumentation/du/du4-test-time") + getprop("/instrumentation/du/du4-test-amount") >= elapsedtime) {
				lowerECAM_apu.page.hide();
				lowerECAM_eng.page.hide();
				lowerECAM_fctl.page.hide();
				lowerECAM_test.page.show();
				lowerECAM_test.update();
			} else {
				lowerECAM_test.page.hide();
				page = getprop("/ECAM/Lower/page");
				if (page == "apu") {
					lowerECAM_apu.page.show();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_apu.update();
				} else if (page == "eng") {
					lowerECAM_apu.page.hide();
					lowerECAM_eng.page.show();
					lowerECAM_fctl.page.hide();
					lowerECAM_eng.update();
				} else if (page == "fctl") {
					lowerECAM_apu.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.show();
					lowerECAM_fctl.update();
				} else {
					lowerECAM_apu.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
				}
			}
		} else {
			lowerECAM_test.page.hide();
			lowerECAM_apu.page.hide();
			lowerECAM_eng.page.hide();
			lowerECAM_fctl.page.hide();
		}
	},
	updateBottomStatus: func() {
		me["TAT"].setText(sprintf("%2.0f", getprop("/environment/temperature-degc")));
		me["SAT"].setText(sprintf("%2.0f", getprop("/environment/temperature-degc")));
		me["GW"].setText(sprintf("%s", math.round(getprop("/FMGC/internal/gw"))));
		me["UTCh"].setText(sprintf("%02d", getprop("/sim/time/utc/hour")));
		me["UTCm"].setText(sprintf("%02d", getprop("/sim/time/utc/minute")));
	},
};

var canvas_lowerECAM_apu = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_apu, canvas_lowerECAM_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["TAT","SAT","GW","UTCh","UTCm","APUN-needle","APUEGT-needle","APUN","APUEGT","APUAvail","APUFlapOpen","APUBleedValve","APUBleedOnline","APUGenOnline","APUGentext","APUGenLoad","APUGenbox","APUGenVolt","APUGenHz","APUBleedPSI","APUfuelLO",
		"text3724","text3728","text3732"];
	},
	update: func() {
		oat = getprop("/environment/temperature-degc");
		
		# Avail and Flap Open
		if (getprop("/systems/apu/flap") == 1) {
			me["APUFlapOpen"].show();
		} else {
			me["APUFlapOpen"].hide();
		}

		if (getprop("/systems/apu/rpm") > 99.5) {
			me["APUAvail"].show();
		} else {
			me["APUAvail"].hide();
		}
		
		if (getprop("/fdm/jsbsim/propulsion/tank[2]/contents-lbs") < 100) {
			me["APUfuelLO"].show();
		} else {
			me["APUfuelLO"].hide();
		}
		
		# APU Gen
		if (getprop("/systems/electrical/extra/apu-volts") > 110) {
			me["APUGenVolt"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["APUGenVolt"].setColor(0.7333,0.3803,0);
		}

		if (getprop("/systems/electrical/extra/apu-hz") > 380) {
			me["APUGenHz"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["APUGenHz"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/controls/APU/master") == 1 or getprop("/systems/apu/rpm") >= 94.9) {
			me["APUGenbox"].show();
			me["APUGenHz"].show();
			me["APUGenVolt"].show();
			me["APUGenLoad"].show();
			me["text3724"].show();
			me["text3728"].show();
			me["text3732"].show();
		} else {
			me["APUGenbox"].hide();
			me["APUGenHz"].hide();
			me["APUGenVolt"].hide();
			me["APUGenLoad"].hide();
			me["text3724"].hide();
			me["text3728"].hide();
			me["text3732"].hide();
		}
		
		if ((getprop("/systems/apu/rpm") > 94.9) and (getprop("/controls/electrical/switches/gen-apu") == 1)) {
			me["APUGenOnline"].show();
		} else {
			me["APUGenOnline"].hide();
		}
		
		if ((getprop("/controls/APU/master") == 0) or ((getprop("/controls/APU/master") == 1) and (getprop("/controls/electrical/switches/gen-apu") == 1) and (getprop("/systems/apu/rpm") > 94.9))) {
			me["APUGentext"].setColor(0.8078,0.8039,0.8078);
		} else if ((getprop("/controls/APU/master") == 1) and (getprop("/controls/electrical/switches/gen-apu") == 0) and (getprop("/systems/apu/rpm") < 94.9)) { 
			me["APUGentext"].setColor(0.7333,0.3803,0);
		}

		me["APUGenLoad"].setText(sprintf("%s", math.round(getprop("/systems/electrical/extra/apu-load"))));
		me["APUGenVolt"].setText(sprintf("%s", math.round(getprop("/systems/electrical/extra/apu-volts"))));
		me["APUGenHz"].setText(sprintf("%s", math.round(getprop("/systems/electrical/extra/apu-hz"))));

		# APU Bleed
		if (getprop("/controls/adirs/ir[1]/knob") != 0 and (getprop("/controls/APU/master") == 1 or getprop("/systems/pneumatic/bleedapu") > 0)) {
			me["APUBleedPSI"].setColor(0.0509,0.7529,0.2941);
			me["APUBleedPSI"].setText(sprintf("%s", math.round(getprop("/systems/pneumatic/bleedapu"))));
		} else {
			me["APUBleedPSI"].setColor(0.7333,0.3803,0);
			me["APUBleedPSI"].setText(sprintf("%s", "XX"));
		}

		if (getprop("/controls/pneumatic/switches/bleedapu") == 1) {
			me["APUBleedValve"].setRotation(90 * D2R);
			me["APUBleedOnline"].show();
		} else {
			me["APUBleedValve"].setRotation(0);
			me["APUBleedOnline"].hide();
		}

		# APU N and EGT
		if (getprop("/controls/APU/master") == 1) {
			me["APUN"].setColor(0.0509,0.7529,0.2941);
			me["APUN"].setText(sprintf("%s", math.round(getprop("/systems/apu/rpm"))));
			me["APUEGT"].setColor(0.0509,0.7529,0.2941);
			me["APUEGT"].setText(sprintf("%s", math.round(getprop("/systems/apu/egt"))));
		} else if (getprop("/systems/apu/rpm") >= 1) {
			me["APUN"].setColor(0.0509,0.7529,0.2941);
			me["APUN"].setText(sprintf("%s", math.round(getprop("/systems/apu/rpm"))));
			me["APUEGT"].setColor(0.0509,0.7529,0.2941);
			me["APUEGT"].setText(sprintf("%s", math.round(getprop("/systems/apu/egt"))));
		} else {
			me["APUN"].setColor(0.7333,0.3803,0);
			me["APUN"].setText(sprintf("%s", "XX"));
			me["APUEGT"].setColor(0.7333,0.3803,0);
			me["APUEGT"].setText(sprintf("%s", "XX"));
		}
		me["APUN-needle"].setRotation((getprop("/ECAM/Lower/APU-N") + 90) * D2R);
		me["APUEGT-needle"].setRotation((getprop("/ECAM/Lower/APU-EGT") + 90) * D2R);

		me.updateBottomStatus();
	},
};

var canvas_lowerECAM_eng = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_eng, canvas_lowerECAM_base]};
		m.init(canvas_group, file);
		
		return m;
	},
	getKeys: func() {
		return ["TAT","SAT","GW","UTCh","UTCm","OilQT1-needle","OilQT2-needle","OilQT1","OilQT2","OilQT1-decimal","OilQT2-decimal","OilPSI1-needle","OilPSI2-needle","OilPSI1","OilPSI2"];
	},
	update: func() {
		# Oil Quantity
		me["OilQT1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/oil-qt-actual"))));
		me["OilQT2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/oil-qt-actual"))));
		me["OilQT1-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/oil-qt-actual"),1))));
		me["OilQT2-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[1]/oil-qt-actual"),1))));
		
		me["OilQT1-needle"].setRotation((getprop("/ECAM/Lower/Oil-QT[0]") + 90) * D2R);
		me["OilQT2-needle"].setRotation((getprop("/ECAM/Lower/Oil-QT[1]") + 90) * D2R);
		
		# Oil Pressure
		if (getprop("/engines/engine[0]/oil-psi-actual") >= 20) {
			me["OilPSI1"].setColor(0.0509,0.7529,0.2941);
			me["OilPSI1-needle"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["OilPSI1"].setColor(1,0,0);
			me["OilPSI1-needle"].setColor(1,0,0);
		}
		
		if (getprop("/engines/engine[1]/oil-psi-actual") >= 20) {
			me["OilPSI2"].setColor(0.0509,0.7529,0.2941);
			me["OilPSI2-needle"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["OilPSI2"].setColor(1,0,0);
			me["OilPSI2-needle"].setColor(1,0,0);
		}
		
		me["OilPSI1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/oil-psi-actual"))));
		me["OilPSI2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/oil-psi-actual"))));
		
		me["OilPSI1-needle"].setRotation((getprop("/ECAM/Lower/Oil-PSI[0]") + 90) * D2R);
		me["OilPSI2-needle"].setRotation((getprop("/ECAM/Lower/Oil-PSI[1]") + 90) * D2R);
		
		me.updateBottomStatus();
	},
};


var canvas_lowerECAM_fctl = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_fctl, canvas_lowerECAM_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return["TAT","SAT","GW","UTCh","UTCm","ailL","ailR","ailL_out","ailR_out","elevL","elevR","PTcc","PT","PTupdn","prim1","prim2","prim3","sec1","sec2","ailLblue","ailRblue","elevLblue","elevRblue","rudderblue","ailLgreen","ailRgreen","ailLgreen2",
		"ailRgreen2","elevLgreen","ruddergreen","PTgreen","elevRyellow","rudderyellow","ailLyellow","ailRyellow","PTyellow","rudder","spdbrkblue","spdbrkgreen","spdbrkyellow","spoiler1Rex","spoiler1Rrt","spoiler2Rex","spoiler2Rrt","spoiler3Rex","spoiler3Rrt",
		"spoiler4Rex","spoiler4Rrt","spoiler5Rex","spoiler5Rrt","spoiler1Lex","spoiler1Lrt","spoiler2Lex","spoiler2Lrt","spoiler3Lex","spoiler3Lrt","spoiler4Lex","spoiler4Lrt","spoiler5Lex","spoiler5Lrt","spoiler1Rf","spoiler2Rf","spoiler3Rf","spoiler4Rf",
		"spoiler5Rf","spoiler1Lf","spoiler2Lf","spoiler3Lf","spoiler4Lf","spoiler5Lf","ailLscale","ailRscale","path4249","path4249-3","path4338","path4249-3-6-7","path4249-3-6-7-5"];
	},
	update: func() { 
		blue_psi = getprop("/systems/hydraulic/blue-psi");
		green_psi = getprop("/systems/hydraulic/green-psi");
		yellow_psi = getprop("/systems/hydraulic/yellow-psi");
		
		# Pitch Trim
		me["PT"].setText(sprintf("%2.1f", math.round(getprop("/ECAM/Lower/elevator-trim-deg"), 0.1)));

		if (math.round(getprop("/ECAM/Lower/elevator-trim-deg"), 0.1) >= 0) {
			me["PTupdn"].setText(sprintf("UP"));
		} else if (math.round(getprop("/ECAM/Lower/elevator-trim-deg"), 0.1) < 0) {
			me["PTupdn"].setText(sprintf("DN"));
		}

		if (green_psi < 1500 and yellow_psi < 1500) {
			me["PT"].setColor(0.7333,0.3803,0);
			me["PTupdn"].setColor(0.7333,0.3803,0);
			me["PTcc"].setColor(0.7333,0.3803,0);
		} else {
			me["PT"].setColor(0.0509,0.7529,0.2941);
			me["PTupdn"].setColor(0.0509,0.7529,0.2941);
			me["PTcc"].setColor(0.0509,0.7529,0.2941);
		}
		
		# Ailerons
		me["ailL"].setTranslation(0,getprop("/ECAM/Lower/aileron-ind-in-left") * 100);
		me["ailR"].setTranslation(0,getprop("/ECAM/Lower/aileron-ind-in-right") * (-100));
		me["ailL_out"].setTranslation(0,getprop("/ECAM/Lower/aileron-ind-out-left") * 100);
		me["ailR_out"].setTranslation(0,getprop("/ECAM/Lower/aileron-ind-out-right") * (-100));
			
		if (blue_psi < 1500 and green_psi < 1500) {
			me["ailL"].setColor(0.7333,0.3803,0);
			me["ailR"].setColor(0.7333,0.3803,0);
			me["ailL_out"].setColor(0.7333,0.3803,0);
			me["ailR_out"].setColor(0.7333,0.3803,0);
		} else {
			me["ailL"].setColor(0.0509,0.7529,0.2941);
			me["ailR"].setColor(0.0509,0.7529,0.2941);
			me["ailL_out"].setColor(0.0509,0.7529,0.2941);
			me["ailR_out"].setColor(0.0509,0.7529,0.2941);
		}
		
		# Elevators
		me["elevL"].setTranslation(0,getprop("/ECAM/Lower/elevator-ind-left") * 100);
		me["elevR"].setTranslation(0,getprop("/ECAM/Lower/elevator-ind-right") * 100);

		if (blue_psi < 1500 and green_psi < 1500) {
			me["elevL"].setColor(0.7333,0.3803,0);
		} else {
			me["elevL"].setColor(0.0509,0.7529,0.2941);
		}
		
		if (blue_psi < 1500 and yellow_psi < 1500) {
			me["elevR"].setColor(0.7333,0.3803,0);
		} else {
			me["elevR"].setColor(0.0509,0.7529,0.2941);
		}
		
		# Rudder
		me["rudder"].setRotation(getprop("/fdm/jsbsim/hydraulics/rudder/final-deg") * -0.0189873417721519);

		if (blue_psi < 1500 and yellow_psi < 1500 and green_psi < 1500) {
			me["rudder"].setColor(0.7333,0.3803,0);
		} else {
			me["rudder"].setColor(0.0509,0.7529,0.2941);
		}
		
		# Spoilers
		if (getprop("/fdm/jsbsim/hydraulics/spoiler-l1/final-deg") < 1.5) {
			me["spoiler1Lex"].hide();
			me["spoiler1Lrt"].show();
		} else {
			me["spoiler1Lrt"].hide();
			me["spoiler1Lex"].show();
		}
		
		if (getprop("/fdm/jsbsim/hydraulics/spoiler-l2/final-deg") < 1.5) {
			me["spoiler2Lex"].hide();
			me["spoiler2Lrt"].show();
		} else {
			me["spoiler2Lrt"].hide();
			me["spoiler2Lex"].show();
		}
		
		if (getprop("/fdm/jsbsim/hydraulics/spoiler-l3/final-deg") < 1.5) {
			me["spoiler3Lex"].hide();
			me["spoiler3Lrt"].show();
		} else {
			me["spoiler3Lrt"].hide();
			me["spoiler3Lex"].show();
		}
		
		if (getprop("/fdm/jsbsim/hydraulics/spoiler-l4/final-deg") < 1.5) {
			me["spoiler4Lex"].hide();
			me["spoiler4Lrt"].show();
		} else {
			me["spoiler4Lrt"].hide();
			me["spoiler4Lex"].show();
		}
		
		if (getprop("/fdm/jsbsim/hydraulics/spoiler-l5/final-deg") < 1.5) {
			me["spoiler5Lex"].hide();
			me["spoiler5Lrt"].show();
		} else {
			me["spoiler5Lrt"].hide();
			me["spoiler5Lex"].show();
		}
		
		if (getprop("/fdm/jsbsim/hydraulics/spoiler-r1/final-deg") < 1.5) {
			me["spoiler1Rex"].hide();
			me["spoiler1Rrt"].show();
		} else {
			me["spoiler1Rrt"].hide();
			me["spoiler1Rex"].show();
		}
		
		if (getprop("/fdm/jsbsim/hydraulics/spoiler-r2/final-deg") < 1.5) {
			me["spoiler2Rex"].hide();
			me["spoiler2Rrt"].show();
		} else {
			me["spoiler2Rrt"].hide();
			me["spoiler2Rex"].show();
		}
		
		if (getprop("/fdm/jsbsim/hydraulics/spoiler-r3/final-deg") < 1.5) {
			me["spoiler3Rex"].hide();
			me["spoiler3Rrt"].show();
		} else {
			me["spoiler3Rrt"].hide();
			me["spoiler3Rex"].show();
		}
		
		if (getprop("/fdm/jsbsim/hydraulics/spoiler-r4/final-deg") < 1.5) {
			me["spoiler4Rex"].hide();
			me["spoiler4Rrt"].show();
		} else {
			me["spoiler4Rrt"].hide();
			me["spoiler4Rex"].show();
		}
		
		if (getprop("/fdm/jsbsim/hydraulics/spoiler-r5/final-deg") < 1.5) {
			me["spoiler5Rex"].hide();
			me["spoiler5Rrt"].show();
		} else {
			me["spoiler5Rrt"].hide();
			me["spoiler5Rex"].show();
		}
		
		# Spoiler Fail
		if (getprop("/systems/failures/spoiler-l1") or green_psi < 1500) {
			me["spoiler1Lex"].setColor(0.7333,0.3803,0);
			me["spoiler1Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/fdm/jsbsim/hydraulics/spoiler-l1/final-deg") < 1.5) {
				me["spoiler1Lf"].show();
			} else {
				me["spoiler1Lf"].hide();
			}
		} else {
			me["spoiler1Lex"].setColor(0.0509,0.7529,0.2941);
			me["spoiler1Lrt"].setColor(0.0509,0.7529,0.2941);
			me["spoiler1Lf"].hide();
		}
		
		if (getprop("/systems/failures/spoiler-l2") or blue_psi < 1500) {
			me["spoiler2Lex"].setColor(0.7333,0.3803,0);
			me["spoiler2Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/fdm/jsbsim/hydraulics/spoiler-l2/final-deg") < 1.5) {
				me["spoiler2Lf"].show();
			} else {
				me["spoiler2Lf"].hide();
			}
		} else {
			me["spoiler2Lex"].setColor(0.0509,0.7529,0.2941);
			me["spoiler2Lrt"].setColor(0.0509,0.7529,0.2941);
			me["spoiler2Lf"].hide();
		}
		
		if (getprop("/systems/failures/spoiler-l3") or blue_psi < 1500) {
			me["spoiler3Lex"].setColor(0.7333,0.3803,0);
			me["spoiler3Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/fdm/jsbsim/hydraulics/spoiler-l3/final-deg") < 1.5) {
				me["spoiler3Lf"].show();
			} else {
				me["spoiler3Lf"].hide();
			}
		} else {
			me["spoiler3Lex"].setColor(0.0509,0.7529,0.2941);
			me["spoiler3Lrt"].setColor(0.0509,0.7529,0.2941);
			me["spoiler3Lf"].hide();
		}
		
		if (getprop("/systems/failures/spoiler-l4") or yellow_psi < 1500) {
			me["spoiler4Lex"].setColor(0.7333,0.3803,0);
			me["spoiler4Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/fdm/jsbsim/hydraulics/spoiler-l4/final-deg") < 1.5) {
				me["spoiler4Lf"].show();
			} else {
				me["spoiler4Lf"].hide();
			}
		} else {
			me["spoiler4Lex"].setColor(0.0509,0.7529,0.2941);
			me["spoiler4Lrt"].setColor(0.0509,0.7529,0.2941);
			me["spoiler4Lf"].hide();
		}
		
		if (getprop("/systems/failures/spoiler-l5") or green_psi < 1500) {
			me["spoiler5Lex"].setColor(0.7333,0.3803,0);
			me["spoiler5Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/fdm/jsbsim/hydraulics/spoiler-l5/final-deg") < 1.5) {
				me["spoiler5Lf"].show();
			} else {
				me["spoiler5Lf"].hide();
			}
		} else {
			me["spoiler5Lex"].setColor(0.0509,0.7529,0.2941);
			me["spoiler5Lrt"].setColor(0.0509,0.7529,0.2941);
			me["spoiler5Lf"].hide();
		}
		
		if (getprop("/systems/failures/spoiler-r1") or green_psi < 1500) {
			me["spoiler1Rex"].setColor(0.7333,0.3803,0);
			me["spoiler1Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/fdm/jsbsim/hydraulics/spoiler-r1/final-deg") < 1.5) {
				me["spoiler1Rf"].show();
			} else {
				me["spoiler1Rf"].hide();
			}
		} else {
			me["spoiler1Rex"].setColor(0.0509,0.7529,0.2941);
			me["spoiler1Rrt"].setColor(0.0509,0.7529,0.2941);
			me["spoiler1Rf"].hide();
		}
		
		if (getprop("/systems/failures/spoiler-r2") or blue_psi < 1500) {
			me["spoiler2Rex"].setColor(0.7333,0.3803,0);
			me["spoiler2Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/fdm/jsbsim/hydraulics/spoiler-r2/final-deg") < 1.5) {
				me["spoiler2Rf"].show();
			} else {
				me["spoiler2Rf"].hide();
			}
		} else {
			me["spoiler2Rex"].setColor(0.0509,0.7529,0.2941);
			me["spoiler2Rrt"].setColor(0.0509,0.7529,0.2941);
			me["spoiler2Rf"].hide();
		}
		
		if (getprop("/systems/failures/spoiler-r3") or blue_psi < 1500) {
			me["spoiler3Rex"].setColor(0.7333,0.3803,0);
			me["spoiler3Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/fdm/jsbsim/hydraulics/spoiler-r3/final-deg") < 1.5) {
				me["spoiler3Rf"].show();
			} else {
				me["spoiler3Rf"].hide();
			}
		} else {
			me["spoiler3Rex"].setColor(0.0509,0.7529,0.2941);
			me["spoiler3Rrt"].setColor(0.0509,0.7529,0.2941);
			me["spoiler3Rf"].hide();
		}
		
		if (getprop("/systems/failures/spoiler-r4") or yellow_psi < 1500) {
			me["spoiler4Rex"].setColor(0.7333,0.3803,0);
			me["spoiler4Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/fdm/jsbsim/hydraulics/spoiler-r4/final-deg") < 1.5) {
				me["spoiler4Rf"].show();
			} else {
				me["spoiler4Rf"].hide();
			}
		} else {
			me["spoiler4Rex"].setColor(0.0509,0.7529,0.2941);
			me["spoiler4Rrt"].setColor(0.0509,0.7529,0.2941);
			me["spoiler4Rf"].hide();
		}
		
		if (getprop("/systems/failures/spoiler-r5") or green_psi < 1500) {
			me["spoiler5Rex"].setColor(0.7333,0.3803,0);
			me["spoiler5Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/fdm/jsbsim/hydraulics/spoiler-r5/final-deg") < 1.5) {
				me["spoiler5Rf"].show();
			} else {
				me["spoiler5Rf"].hide();
			}
		} else {
			me["spoiler5Rex"].setColor(0.0509,0.7529,0.2941);
			me["spoiler5Rrt"].setColor(0.0509,0.7529,0.2941);
			me["spoiler5Rf"].hide();
		}
		
		# Flight Computers		
		if (getprop("/systems/fctl/prim1")) {
			me["prim1"].setColor(0.0509,0.7529,0.2941);
			me["path4249"].setColor(0.0509,0.7529,0.2941);
		} else if ((getprop("/systems/fctl/prim1") == 0) or (getprop("/systems/failures/prim1") == 1)) {
			me["prim1"].setColor(0.7333,0.3803,0);
			me["path4249"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/fctl/prim2")) {
			me["prim2"].setColor(0.0509,0.7529,0.2941);
			me["path4249-3"].setColor(0.0509,0.7529,0.2941);
		} else if ((getprop("/systems/fctl/prim2") == 0) or (getprop("/systems/failures/prim2") == 1)) {
			me["prim2"].setColor(0.7333,0.3803,0);
			me["path4249-3"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/fctl/prim3")) {
			me["prim3"].setColor(0.0509,0.7529,0.2941);
			me["path4338"].setColor(0.0509,0.7529,0.2941);
		} else if ((getprop("/systems/fctl/prim3") == 0) or (getprop("/systems/failures/prim3") == 1)) {
			me["prim3"].setColor(0.7333,0.3803,0);
			me["path4338"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/fctl/sec1")) {
			me["sec1"].setColor(0.0509,0.7529,0.2941);
			me["path4249-3-6-7"].setColor(0.0509,0.7529,0.2941);
		} else if ((getprop("/systems/fctl/sec1") == 0) or (getprop("/systems/failures/sec1") == 1)) {
			me["sec1"].setColor(0.7333,0.3803,0);
			me["path4249-3-6-7"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/fctl/sec2")) {
			me["sec2"].setColor(0.0509,0.7529,0.2941);
			me["path4249-3-6-7-5"].setColor(0.0509,0.7529,0.2941);
		} else if ((getprop("/systems/fctl/sec2") == 0) or (getprop("/systems/failures/sec2") == 1)) {
			me["sec2"].setColor(0.7333,0.3803,0);
			me["path4249-3-6-7-5"].setColor(0.7333,0.3803,0);
		}
		
		# Hydraulic Indicators
		if (getprop("/systems/hydraulic/blue-psi") >= 1500) {
			me["ailLblue"].setColor(0.0509,0.7529,0.2941);
			me["ailRblue"].setColor(0.0509,0.7529,0.2941);
			me["elevLblue"].setColor(0.0509,0.7529,0.2941);
			me["elevRblue"].setColor(0.0509,0.7529,0.2941);
			me["rudderblue"].setColor(0.0509,0.7529,0.2941);
			me["spdbrkblue"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["ailLblue"].setColor(0.7333,0.3803,0);
			me["ailRblue"].setColor(0.7333,0.3803,0);
			me["elevLblue"].setColor(0.7333,0.3803,0);
			me["elevRblue"].setColor(0.7333,0.3803,0);
			me["rudderblue"].setColor(0.7333,0.3803,0);
			me["spdbrkblue"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/hydraulic/green-psi") >= 1500) {
			me["ailLgreen"].setColor(0.0509,0.7529,0.2941);
			me["ailRgreen"].setColor(0.0509,0.7529,0.2941);
			me["ailLgreen2"].setColor(0.0509,0.7529,0.2941);
			me["ailRgreen2"].setColor(0.0509,0.7529,0.2941);
			me["elevLgreen"].setColor(0.0509,0.7529,0.2941);
			me["ruddergreen"].setColor(0.0509,0.7529,0.2941);
			me["PTgreen"].setColor(0.0509,0.7529,0.2941);
			me["spdbrkgreen"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["ailLgreen"].setColor(0.7333,0.3803,0);
			me["ailRgreen"].setColor(0.7333,0.3803,0);
			me["ailLgreen2"].setColor(0.7333,0.3803,0);
			me["ailRgreen2"].setColor(0.7333,0.3803,0);
			me["elevLgreen"].setColor(0.7333,0.3803,0);
			me["ruddergreen"].setColor(0.7333,0.3803,0);
			me["PTgreen"].setColor(0.7333,0.3803,0);
			me["spdbrkgreen"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/hydraulic/yellow-psi") >= 1500) {
			me["ailLyellow"].setColor(0.0509,0.7529,0.2941);
			me["ailRyellow"].setColor(0.0509,0.7529,0.2941);
			me["elevRyellow"].setColor(0.0509,0.7529,0.2941);
			me["rudderyellow"].setColor(0.0509,0.7529,0.2941);
			me["PTyellow"].setColor(0.0509,0.7529,0.2941);
			me["spdbrkyellow"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["ailLyellow"].setColor(0.7333,0.3803,0);
			me["ailRyellow"].setColor(0.7333,0.3803,0);
			me["elevRyellow"].setColor(0.7333,0.3803,0);
			me["rudderyellow"].setColor(0.7333,0.3803,0);
			me["PTyellow"].setColor(0.7333,0.3803,0);
			me["spdbrkyellow"].setColor(0.7333,0.3803,0);
		}
		
		me.updateBottomStatus();
	},
};

var canvas_lowerECAM_test = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});
		
		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_test]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["Test_white","Test_text"];
	},
	update: func() {
		if (getprop("/instrumentation/du/du4-test-time") + 1 >= elapsedtime) {
			me["Test_white"].show();
			me["Test_text"].hide();
		} else {
			me["Test_white"].hide();
			me["Test_text"].show();
		}
	},
};

setlistener("sim/signals/fdm-initialized", func {
	lowerECAM_display = canvas.new({
		"name": "lowerECAM",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	lowerECAM_display.addPlacement({"node": "lecam.screen"});
	var groupApu = lowerECAM_display.createGroup();
	var groupEng = lowerECAM_display.createGroup();
	var groupFctl = lowerECAM_display.createGroup();
	var group_test = lowerECAM_display.createGroup();

	lowerECAM_apu = canvas_lowerECAM_apu.new(groupApu, "Aircraft/Airbus_A330/Models/Instruments/Lower-ECAM/res/apu.svg");
	lowerECAM_eng = canvas_lowerECAM_eng.new(groupEng, "Aircraft/Airbus_A330/Models/Instruments/Lower-ECAM/res/eng.svg");
	lowerECAM_fctl = canvas_lowerECAM_fctl.new(groupFctl, "Aircraft/Airbus_A330/Models/Instruments/Lower-ECAM/res/fctl.svg");
	lowerECAM_test = canvas_lowerECAM_test.new(group_test, "Aircraft/Airbus_A330/Models/Instruments/Common/res/du-test.svg");
	
	lowerECAM_update.start();
	if (getprop("/systems/acconfig/options/lecam-rate") > 1) {
		l_rateApply();
	}
});

var l_rateApply = func {
	lowerECAM_update.restart(0.05 * getprop("/systems/acconfig/options/lecam-rate"));
}

var lowerECAM_update = maketimer(0.05, func {
	canvas_lowerECAM_base.update();
});

var showLowerECAM = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(lowerECAM_display);
}

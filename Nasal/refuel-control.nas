# A33X Refuel Control Code
# For Boom, and Drogues

# Copyright (c) 2020 Josh Davidson (Octal450)

var toggleBoom = func {
	var drogueCmd = getprop("/options/boom-pos-cmd");
	if (drogueCmd < 1 and getprop("/options/hasboom")) {
		setprop("/options/boom-pos-cmd", 1);
	} else {
		setprop("/options/boom-pos-cmd", 0);
	}
}

var toggleDrogues = func {
	var drogueCmd = getprop("/options/drogue-pos-cmd");
	if (drogueCmd < 1) {
		setprop("/options/drogue-pos-cmd", 1);
	} else {
		setprop("/options/drogue-pos-cmd", 0);
	}
}

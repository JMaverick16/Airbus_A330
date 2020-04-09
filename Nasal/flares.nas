#FLARES

var TRUE = 1;
var FALSE = 0;

var flareCount = -1;
var flareStart = -1;

var loop_flare = func {
    # Flare/chaff release
    if (getprop("ai/submodels/submodel[0]/flare-release-snd") == nil) {
        setprop("ai/submodels/submodel[0]/flare-release-snd", FALSE);
        setprop("ai/submodels/submodel[0]/flare-release-out-snd", FALSE);
    }
    var flareOn = getprop("ai/submodels/submodel[0]/flare-release-cmd");
    if (flareOn == TRUE and getprop("ai/submodels/submodel[0]/flare-release") == FALSE
            and getprop("ai/submodels/submodel[0]/flare-release-out-snd") == FALSE
            and getprop("ai/submodels/submodel[0]/flare-release-snd") == FALSE) {
        flareCount = getprop("ai/submodels/submodel[0]/count");
        flareStart = getprop("sim/time/elapsed-sec");
        setprop("ai/submodels/submodel[0]/flare-release-cmd", FALSE);
        if (flareCount > 0) {
            # release a flare
            setprop("ai/submodels/submodel[0]/flare-release-snd", TRUE);
            setprop("ai/submodels/submodel[0]/flare-release", TRUE);
            setprop("rotors/main/blade[1]/flap-deg", flareStart);
            setprop("rotors/main/blade[1]/position-deg", flareStart);
        } else {
            # play the sound for out of flares
            setprop("ai/submodels/submodel[0]/flare-release-out-snd", TRUE);
        }
    }
    if (getprop("ai/submodels/submodel[0]/flare-release-snd") == TRUE and (flareStart + 1) < getprop("sim/time/elapsed-sec")) {
        setprop("ai/submodels/submodel[0]/flare-release-snd", FALSE);
        setprop("rotors/main/blade[1]/flap-deg", 0);
        setprop("rotors/main/blade[1]/position-deg", 0);#MP interpolates between numbers, so nil is better than 0.
    }
    if (getprop("ai/submodels/submodel[0]/flare-release-out-snd") == TRUE and (flareStart + 1) < getprop("sim/time/elapsed-sec")) {
        setprop("ai/submodels/submodel[0]/flare-release-out-snd", FALSE);
    }
    if (flareCount > getprop("ai/submodels/submodel[0]/count")) {
        # A flare was released in last loop, we stop releasing flares, so user have to press button again to release new.
        setprop("ai/submodels/submodel[0]/flare-release", FALSE);
        flareCount = -1;
    }
        settimer(loop_flare, 0.10);
};
loop_flare();
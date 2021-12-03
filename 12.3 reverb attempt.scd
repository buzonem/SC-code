    (
        SynthDef(\fullkickdrum, {
		arg clickamt = 0.2, subcurve = -8, trig = 1.0;
        var subosc, subenv, suboutput, clickosc, clickenv, clickoutput;

        subosc = {SinOsc.ar(60)};
		subenv = {(EnvGen.kr(Env.perc(0.001, 1, 1, subcurve), trig))};

        clickosc = {LPF.ar(WhiteNoise.ar(1),6500)};
		clickenv = {(EnvGen.kr(Env.perc(0.00,0.03,clickamt,-4.0), trig))};

        suboutput = (subosc * subenv);
        clickoutput = (clickosc * clickenv);

        Out.ar(0,
            Pan2.ar(suboutput + clickoutput, 0)
        )

    }).add;
    )


(
SynthDef(\snare, {
	arg pEnvamt = 2.0, sinDecay = 0.5, noiseDecay= 0.3, trig= 1.0, ffreq = 2000;
	var sinosc, sinenv,  noise, noiseenv, penv, sinoutput, noiseoutput, pan;

	sinosc = {SinOsc.ar(180 * penv)};
	sinenv = {(EnvGen.kr(Env.perc(0.001,sinDecay,1.0,-4.0), trig))};

	noise = {BPF.ar(PinkNoise.ar(1),ffreq)};
	noiseenv = {(EnvGen.kr(Env.perc(0.01,noiseDecay,1.0,-4.0), trig))};

	penv = {EnvGen.kr(Env.perc(0.01,0.10,pEnvamt, -4.0), trig)};

	sinoutput = (sinosc * sinenv);
	noiseoutput = (noise * noiseenv);

	Out.ar(0,
		Pan2.ar(sinoutput + noiseoutput, 0)
	)

}).add;
)

(
SynthDef(\glitchhat1, {
	arg noiseDecay = 0.05, fEnvamt = 0.5, trig = 1.0, panpos = 0.0;
	var source, sourceoutput, fEnv, pan;

	fEnv = {(EnvGen.kr(Env.perc(0.01, 0.1, fEnvamt, -4.0), trig))};

	source = {(GlitchHPF.ar(PinkNoise.ar, 10000*fEnv))};

	Out.ar(0,
		Pan2.ar(source, panpos, fEnv)
)
}).add;
)




(
SynthDef(\glitchhat2, {
	|noiseDecay = 0.1, fEnvamt = 1.5, trig = 1.0, panpos = 0.0|
	var source, sourceoutput, fEnv, pan;

	fEnv = {(EnvGen.kr(Env.perc(0.01, 0.1, fEnvamt, 4.0), trig))};

	source = {(GlitchHPF.ar(PinkNoise.ar, 10000*fEnv))};

	Out.ar(0,
		pan=Pan2.ar(source,panpos,1);
			Out.ar(~reverbBus,pan)
)
}).add;
)
////// Reverb Implementation \\\\\\\
((
	SynthDef(\verb, {
		|in, predelay=1, revtime=10, lpf=4500,mix=0.5,amp=1,out=0|
		var dry,wet,temp,source;
		dry = In.ar(in, 2);
		temp = In.ar(in, 2);
		wet=0;
		temp=DelayN.ar(temp, 0.2, predelay);
		32.do {temp=AllpassN.ar(temp, 0.05, {Rand(0.001,0.05)}!2,revtime);
			temp=LPF.ar(temp,lpf);
			wet=wet+temp;
		};
		source=XFade2.ar(dry,wet,mix*2-1,amp);
		Out.ar(out,source);
	}).add;
);
)


(
~reverbBus = Bus.audio(s,2);
~createReverb={~reverbSynth=Synth(\verb, [\in, ~reverbBus])};
ServerTree.add(~createReverb);
)





(
SynthDef(\tri, {
	|gate=1, amp=1, freq=200, panpos=0, envdur=1|
	var sig, pan;
	sig=LFTri.ar(freq,0,EnvGen.ar(Env.perc(0.001,envdur,amp,-15),gate,doneAction:2));
		pan=Pan2.ar(sig,panpos,1);
		Out.ar(~reverbBus,pan)
}).add
)

Synth(\tri, [\panpos, 0])

Synth(\glitchhat1, [\panpos, 0])




Env.perc(0.001, 1, 0.5, -16).test.plot;
Env.perc(0.01, 0.3, 1.0, -4.0).test.plot;
	g = Synth('fullkickdrum')

    t= Synth('snare');
a= Synth('glitchhat1');
a= Synth(\glitchhat2);





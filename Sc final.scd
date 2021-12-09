//node proxy
n = NodeProxy.new(s, \audio, 2);
n.play;
n.stop;



n.fadeTime_(1.0);
n.source = {SinOsc.ar([62,64] * 3.midiratio) * 0.4 * LFPulse.kr(8,0,1)};

//bpm clock\\
t = TempoClock.new(133/60).permanent_(true); /// setting up a flexible tempoclock
t.tempo; //i assignt this to a variable, f, and multiply f by four to achieve a 16th note rhythm.
t.beatDur;

// rhythms and variations

(
n.source = {
	var sig, f;
	f = t.tempo;
	sig = SinOsc.ar([62,64] * 5.midiratio);
	sig = sig * 0.4 * LFPulse.kr(f*4,0,1);
};
)


(
n.source = {
	var sig, f;
	f = t.tempo;
	sig = SinOsc.ar([62,60] * 5.midiratio);
	sig = sig * 0.4 * LFPulse.kr(f*4, 0,1);
};
)


(
n.source = {
	var sig, f, fEnv, sin;
	f = t.tempo;
	fEnv = EnvGen.ar(Env.perc(0.01,0.3,1.0,-4.0), LFPulse.kr(f*4,0,2));
	sin = SinOsc.ar([48,64]);
	sig = GlitchBPF.ar(sin, 60 * fEnv);
};
)


(
n.source = {
	var sig, f, fEnv, sin;
	f = t.tempo;
	fEnv = EnvGen.ar(Env.perc(0.01,0.35,1.0,-8.0), LFPulse.kr(f*4,0,2));
	sin = SinOsc.ar([48,64]);
	sig = GlitchRHPF.ar(sin, 75* fEnv,);
};
)

(
n.source = {
	var sig, f, fEnv, sin, mod;
	f = t.tempo;
	fEnv = EnvGen.ar(Env.perc(0.01,0.1,0.5,-4.0), LFPulse.kr(f*1,0,2));

	sin = SinOsc.ar([48,64],0.0,0.1);
	mod = SinOsc.kr(0.24*SinOsc.kr(36));
	sig = GlitchRHPF.ar(sin, 60*mod, 1.0, 0.4);
};
)

(
n.source = {
	var sig, f, fEnv, sin, mod;
	sin = Klank.ar(`[[696, 1071, 696, 1223], nil, [1, 1, 1, 1]], PinkNoise.ar(0.005));
	mod = SinOsc.kr(36);
	sig = GlitchBPF.ar(sin, 60*mod);
};
)













// pads

n.source = { Klank.ar(`[[696, 1071, 60, 1223], nil, [1, 1, 1, 1]], PinkNoise.ar(0.009)) }



n.source = nil;
n.clock_(t);
n.quant_(4);

/////////////////////////////////////////////////////////
// reverb //
(
Ndef(\hole, {
    var src, delay, amp;

    src = n.source;
    src = src * \amp.kr(1);
    // var src = Impulse.ar(0.5);

    delay = Greyhole.ar(
        src,
        \dtime.kr(0.4),
        \damp.kr(0.1),
        \size.kr(1),
        \diff.kr(0.707),
        \fb.kr(0.8),
        \modDepth.kr(0.01),
        \modFreq.kr(4)
    );
    delay
});
)
Ndef(\src).play;
Ndef(\hole).play;

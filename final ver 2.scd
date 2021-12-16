//node proxy
n = NodeProxy.new(s, \audio, 2);
n.play;
n.stop;



n.fadeTime_(1.0);
n.source = {SinOsc.ar([62,64] * 3.midiratio) * 0.4 * LFPulse.kr(8,0,1)};

//bpm clock\\
t = TempoClock.new(130/60).permanent_(true); /// setting up a flexible tempoclock
t.tempo; //i assignt this to a variable, f, and multiply f by four to achieve a 16th note rhythm.
t.beatDur;

// rhythms and variations

//pattern1
(
n.source = {
	var sig, f;
	f = t.tempo;
	sig = SinOsc.ar([73,74] * 5.midiratio);
	sig = sig * 0.4 * LFPulse.kr(f*4,0,1);
};
)

//pattern 2
(
n.source = {
	var sig, f;
	f = t.tempo;
	sig = SinOsc.ar([73,74] * 5.midiratio);
	sig = sig * 0.4 * LFPulse.kr(f*4, 0,1);
};
)
//pattern 3

(
n.source = {
	var sig, f, fEnv, sin;
	f = t.tempo;
	fEnv = EnvGen.ar(Env.perc(0.01,0.3,1.0,-4.0), LFPulse.kr(f*4,0,2));
	sin = SinOsc.ar([73,74]);
	sig = BPF.ar(sin, 120 * fEnv);
};
)
//pattern 4

(
n.source = {
	var sig, f, fEnv, sin;
	f = t.tempo;
	fEnv = EnvGen.ar(Env.perc(0.01,0.35,1.0,-8.0), LFPulse.kr(f*4,0,2));
	sin = SinOsc.ar([48,64]);
	sig = GlitchHPF.ar(sin, 75* fEnv,);
};
)

(
n.source = {
	var sig, f, fEnv, sin, mod;
	f = t.tempo;
	fEnv = EnvGen.ar(Env.perc(0.01,0.1,0.5,-4.0), LFPulse.kr(f*1,0,2));

	sin = SinOsc.ar([48,64],0.0,0.1);
	mod = SinOsc.kr(4*SinOsc.kr(36));
	sig = GlitchHPF.ar(sin, 60*mod, 1.0, 0.4);
};
)



// Pads, Textures,
(
n.source = {
	var sig, f, fEnv, sin, mod;
	f = t.tempo;
	sin = Klank.ar(`[[659, 1047, 698, 1174], nil, [1, 1, 1, 1]], PinkNoise.ar(0.005));
	mod = LFPulse.kr(f*4, 0.0, 2);
	sig = BPF.ar(sin, 3000 * mod, 1.0);
};
)


(
n.source = {
	var sig, f, fEnv, sin, mod;
	f = t.tempo;
	sin = Klank.ar(`[[659, 1047, 698, 1174], nil, [1, 1, 1, 1]], Impulse.ar(t.tempo*2, 0.0, 0.1));
	mod = Impulse.ar(f*4, 0.0, 2);
	sig = BPF.ar(sin, (1500 * mod));
};
)














// pads

n.source = { Klank.ar(`[[696, 1071, 60, 1223], nil, [1, 1, 1, 1]], PinkNoise.ar(0.009)) }


//
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
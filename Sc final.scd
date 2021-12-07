//node proxy
n = NodeProxy.new(s, \audio, 2);
n.play;
n.stop;



n.fadeTime_(0.02);
n.source = {SinOsc.ar([62,64] * 3.midiratio) * 0.4 * LFPulse.kr(8,0,1)};


t = TempoClock.new(133/60).permanent_(true);
t.tempo;
t.beatDur;

(
n.source = {
	var sig, f;
	f = t.tempo;
	sig = SinOsc.ar([62,64] * 5.midiratio);
	sig = sig * 0.4 * LFPulse.kr(f*4,0,1);
};
)

n.source = nil;

n.clock_(t);
n.quant_(4);

/////////////////////////////////////////////////////////
// pads //
p = NodeProxy.new(s, \audio, 2);
p.play;
p.stop;

(
p.source = {
	var sig, f, f1, f2, f3;
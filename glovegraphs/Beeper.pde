/**
 *  This sketch demonstrates how to use a <code>SineWave</code> with an <code>AudioOutput</code>.<br />
 *  Move the mouse up and down to change the frequency, left and right to change the panning.<br />
 *  <br />
 *  <code>SineWave</code> is a subclass of <code>Oscillator</code>, which is an abstract class that implements the 
 *  interface <code>AudioSignal</code>.<br />
 *  This means that it can be added to an <code>AudioOutput</code> and the <code>AudioOutput</code> will call 
 *  one of the two <code>generate()</code> functions, depending on whether the AudioOutput is STEREO or MONO. 
 *  Since it is an 
 *  abstract class, it can't be directly instantiated, it merely provides the functionality of 
 *  smoothly changing frequency, amplitude and pan. In order to have an <code>Oscillator</code> that actually 
 *  produces sound, you have to extend <code>Oscillator</code> and define the value function. This function 
 *  takes a <b>step</b> value and returns a sample value between -1 and 1. In the case of the SineWave,
 *  the value function returns this: <b>sin(freq * TWO_PI * step)</b><br />
 *  <b>freq</b> is the current frequency (in Hertz) of the <code>Oscillator</code>. It is multiplied by <b>TWO_PI</b> to
 *  set the period of the sine wave properly and then that sine wave is sampled at <b>step</b>.
 */

import ddf.minim.*;
import ddf.minim.signals.*;

class Beeper {
  Minim minim;
  AudioOutput out;
  SineWave sine;

  boolean mute;
  boolean playSound;
  float prevTime = 0;
  float loopTime = 900;
  float beepTime = 100;

  Beeper()
  {
    minim = new Minim(this);
    // get a line out from Minim, default bufferSize is 1024, default sample rate is 44100, bit depth is 16
    out = minim.getLineOut(Minim.STEREO);
    // create a sine wave Oscillator, set to 440 Hz, at 0.5 amplitude, sample rate from line out
    sine = new SineWave(440, 0.5, out.sampleRate());
    // set the portamento speed on the oscillator to 200 milliseconds
    sine.portamento(200);
    // add the oscillator to the line out
    out.addSignal(sine);

    // start the timer
    prevTime = millis();
    playSound = false;
    mute = true;
  }

  void update()
  {
    if (!mute) {
      float time = millis();
      if (playSound) {
        if (time - prevTime > beepTime) {
          out.mute();
          playSound = false;
          println("stop sound");
        }
      } 
      else {
        if (time - prevTime > loopTime) {
          out.unmute();
          playSound = true;
          prevTime = time;
          println("play sound");
        }
      }
    }
  }

  void mute() {
    mute = true;
  }

  void unmute() {
    mute = false;
  }
  
}


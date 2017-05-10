# Event Special Keys

This is a list of special keys for events/pbind. These keys have additional functionality to do thingss like alter how the pattern is played, automate conversions between types, etc. Some of these only work in pbinds, and have no effect in events.

## Event builtins and conversions

Some event keys are used to set standard parameters for the synth (i.e. `instrument`, `out`, etc). Additionally, cl-collider will automatically convert between different units of measurement for data that represents the same property. For example, you can write a pattern that generates pitches based on midi note numbers with `midinote`. Then, in another key after that, you can use `(pk :freq)` to get the frequency of the note (which is automagically converted from the `midinote` value, as if you had used `midinote-freq` on it).

* `instrument`/`inst` - name of the synth you want to trigger.
* `amp`/`db` - 
* `freq`/`midinote`/`degree`+`octave`+`root` -
* `dur`/`delta`
* `sustain`/`legato`
* `tempo`
* `pdef`
* `pbeat`
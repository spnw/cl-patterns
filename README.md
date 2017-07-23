# cl-patterns

A library for writing SuperCollider-esque patterns in Lisp. Aims to emulate most of the patterns that are part of SuperCollider, but make them more robust, expressive, consistent, reflective, and lispy.

* robust - strongly prefer coercing values into something "correct" rather than failing or giving an error.
* expressive - make writing music as easy and "natural" as possible, so that patterns can be built in real-time, in performance settings, without having to think so hard about how to bend the library to your will. i feel this is a weakness of SuperCollider.
* consistent - edge cases minimized, arguments for the various functions in an intuitive order. pretty self-explanatory.
* reflective - store more data about the stream state and more metadata about the patterns. make it easier for a pattern to access the values of another pattern, for patterns to affect other patterns, etc.
* lispy - prefer lisp idioms rather than direct translations of the SuperCollider way of doing things (while still keeping things relatively similar so it's not a huge adjustment for SC users to make).

In addition to emulating most of SuperCollider's patterns system, another goal is to further extend it with more tools and more ways to write patterns/sequences, for example "drum sequence" notation like `k - - - k - - - k - - - k - - -` for a four-to-the-floor beat. The idea is that Lisp's macros should make it possible to more expressively write music with code.

## Intro

Download cl-patterns and put it in your quicklisp local-projects directory, then load it:

```common-lisp
> (ql:quickload :cl-patterns)
> (in-package :cl-patterns)
```

Create a pattern like so:

```common-lisp
> (defparameter pat (pbind :foo (pseq '(1 2 3))
                           :bar (prand '(9 8 7) 5)))
```

Since patterns are basically "templates", you need to turn them into `pstream` objects in order to actually get output from them:

```common-lisp
> (defparameter pstream (as-pstream pat))
```

Then, you can get results from the pstream one at a time with `next`, or many at a time with `next-n`:

```common-lisp
> (defparameter results (next-n pstream 3))
> results
((EVENT :FOO 1 :BAR 8) (EVENT :FOO 2 :BAR 9) (EVENT :FOO 3 :BAR 8))
```

To actually play events (and hear sound output), you'll need to start an audio server. Right now, SuperCollider is the only supported audio server, but in the future, there will be support for Incudine as well as MIDI output through ALSA. In order to be able to connect to SuperCollider, you need the [cl-collider](https://github.com/byulparan/cl-collider) and [scheduler](http://github.com/byulparan/scheduler) libraries installed in your quicklisp `local-projects` directory so that they can be loaded. Then:

``` common-lisp
> (ql:quickload :cl-patterns/supercollider)
> (load #P"/path/to/cl-patterns/supercollider-example.lisp") ;; code to start scsynth and define few example synths.
```

And finally we can play patterns and hear sound:

```common-lisp
> (play (pbind :instrument :kik :freq (pseq '(100 200 400 800) 1)))
```

From here, you can take a look at the code in the `supercollider-example.lisp` file for examples of how to define your own synths. For now there isn't much documentation on how to write synthdefs or patterns in Lisp, but if you're used to writing patterns or SynthDefs in regular sclang, most of them should translate fairly easily. More documentation will be written in the future.

## Features

This library isn't just a copy of SuperCollider's patterns - I wanted to improve upon them as well. Here are a few of the features of this library that are implemented right now:

* It's possible to "inject" an event's values into another from inside a pattern. For example:
```common-lisp
> (next-n (pbind :foo (pseq '(1 2 3 4))
                 :inject (pseq (list (event) (event :bar 1 :baz 2) (event :qux 3))))
          3)
((EVENT :FOO 1)
 (EVENT :FOO 2 :BAR 1 :BAZ 2)
 (EVENT :FOO 3 :QUX 3))
```

* Event parameters that are different representations of the same concept are automatically converted between each other. For example, if you set the `amp` of an event and then try to get its `db`, the amp is automatically converted to db for you.
```common-lisp
> (db (event :amp 0.5))
-6.0205994
> (amp (event :db -3))
0.70794576
```

## Current Status

Right now, the library is in a constant state of flux. Major changes are likely to occur, so any code you write using this library may end up breaking.

Most of the documentation is only half-completed at the moment.

Only the SuperCollider backend is working right now. The Incudine and MIDI backends are not functional at all yet.

## Tour

* README.md - this file. self-expanatory, i'd hope.
* package.lisp - the package definition file.
* LICENSE - the GPLv3 license.
* cl-patterns.asd - cl-patterns systems definition file.

### docs

* doc/basics.org - explanation of the basic concepts of cl-patterns, meant for people who have never used SuperCollider's patterns.
* doc/event-special-keys.org - description of keys that have special effects when used in an event or pbind.
* doc/roadmap.org - general overview of major goals for the future development of cl-patterns.
* doc/sc-differences.org - comprehensive description of things that differ between cl-patterns and SuperCollider.
* doc/sc.org - a list of pattern classes in SuperCollider and their cl-patterns implementation status.
* doc/writing-your-own.org - information about how to write your own pattern classes.

### src

* src/pat-utilities.lisp - random utilities that don't fit anywhere else. also some notes for myself in case i forget to use `alexandria`.
* src/patterns.lisp - the patterns themselves. includes the `pattern` superclass as well as `pbind` and `pseq`, `pk`, etc.
* src/event.lisp - code to represent and deal with events. includes the `event` class, information about special keys (i.e. `freq`, `amp`...), etc.
* src/clock.lisp - the scheduling functionality to make sure that each event is played at the proper time.
* src/scales.lisp - musical pitch (scales/tuning) data and structs.
* src/readtable.lisp - defines a named-readtable for optional syntax sugar.

* src/tests.lisp - test suite using `prove`.

* src/supercollider.lisp - code to interface cl-patterns with the [cl-collider](https://github.com/byulparan/cl-collider) library.
* src/cl-collider-extensions.lisp - a few additions to the cl-collider library for ease of use and cl-pattern interfacing.
* src/supercollider-example.lisp - example code to get started with the `cl-collider` library.
* src/sc-compatibility.lisp - patterns that are 100% compatible with SuperCollider's (unlike the ones in patterns.lisp which aren't guaranteed to be).

* src/incudine.lisp - code to interface cl-patterns with [incudine](https://github.com/titola/incudine).

* src/midi.lisp - code to interface cl-patterns with [cl-alsaseq](https://github.com/rick-monster/cl-alsaseq).

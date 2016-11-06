# cl-patterns

A library for writing SuperCollider-esque patterns in Lisp. Aims to emulate most of the patterns that are part of SuperCollider, but make them more robust, expressive, consistent, reflective, and lispy.

* robust - strongly prefer coercing values into something "correct" rather than failing or giving an error.
* expressive - make writing music as easy and "natural" as possible, so that patterns can be built in real-time, in performance settings, without having to think so hard about how to bend the library to your will. i feel this is a big weakness of SuperCollider.
* consistent - edge cases minimized, arguments for functions in a consistent order. pretty self-explanatory.
* reflective - store more data about the stream state and more metadata about the patterns. make it easier for a pattern to access the values of another pattern, for patterns to affect other patterns, etc.
* lispy - prefer lisp idioms rather than direct translations of the SuperCollider way of doing things (while still keeping things relatively similar so it's not a huge adjustment for SC users to make).

In addition to emulating most of SuperCollider's patterns system, another goal is to further extend it with more tools and more ways to write patterns/sequences, for example "drum sequence" notation like 'k - - - k - - - k - - - k - - -' for a four-to-the-floor beat.

Intro
=====

Create a pattern like so:

```
(defparameter pat (pbind :foo (pseq '(1 2 3))
                         :bar (prand '(9 8 7) 5)))
```

Then, you can get results from the pattern one at a time with `next`, or many at a time with `next-n`:

```
(defparameter list (next-n pat 7))
```

You can play an event using the `play` function:

```
(play (car list))
```

In the future I'll write information on how you can make `play` actually cause sound output from the SuperCollider server.

Tour
====

* event.lisp - code to represent and deal with events (the event class, play functionality, `*event-output-function*`, etc)
* ideas.lisp - right now just a file to keep unsorted work-in-progress ideas in.
* misc.lisp - where i put my code when i'm just messing around with stuff. might be useful as example code, but could also have outdated stuff in it.
* package.lisp - the package.lisp file.
* patterns.lisp - the current version of the patterns. includes the `pattern` superclass as well as `pbind` and `pseq`, `pk`, etc.
* patterns-orig.lisp - the original (oldest) version of patterns.lisp - don't use this. the old (non-CLOS) way of doing things.
* patterns-series.lisp - the previous version of patterns.lisp which used the `SERIES` library to write patterns in a generator style.
* pat-utilities.lisp - random utilities that don't fit anywhere else. also some notes for myself in case i forget to use `alexandria`.
* README.md - this file. self-expanatory, i'd hope.
* supercollider.lisp - code to interface `cl-patterns` with the `cl-collider` library.

Ideas/TODO
==========

* implement rests.
* `tsubseq` function for getting a subsequence based on start and end times of events.
* do "static" things to "dynamic" patterns - i.e. `(pshift (pseq '(1 2 3)) 1)` results in `'(3 1 2 3 1 2 3 ...)` or the like. would work with event patterns too obviously and should "fail" gracefully by still giving output even if the source pattern is infinite-length (maybe just only operate on the first 16 beats, events, or output values by default for infinite patterns).
* automatically convert between different ways to represent the same thing in events
  * for example, if you set an event's `amp` but then try to access its `db`, it calculates the `db` based on the `amp` value.
  * the same should be true for when you set the values - setting `db` and then accessing `amp` will return the value of the `db` you set converted to `amp`
  * interally, an Event only keeps track of `amp` and just converts to whatever type you request, or converts whatever type you give it to `amp`.
* more metadata in patterns and streams so that it's easier to write functions that process streams/patterns/etc
* use the `prove` library to write tests for the patterns.
* make it easy to combine patterns by "injecting" the results of an event pattern into its parent event pattern
  * i.e.:
  `(next-n (pbind :foo (pseq '(hey how are ya)) :inject (pbind :bar (pseq '(1 2 3)))) 3)`
  results in:
  `'((:foo hey :bar 1) (:foo how :bar 2) (:foo are :bar 3))`
* make it possible to easily create lfos for the synth's parameters
  * can embed a synth definition (`sc:defsynth`) as the value, in which case the synth is triggered at the start of each pattern (or maybe for each event?)
  * can embed a `sc:proxy`, in which case the pattern just takes values from the output of the proxy.
  * can embed an Env, in which case a env-playing synth is mapped to the triggered synth's parameter.
  * maybe make it possible to change whether to retrigger for each event or just have the synth/env play for the duration of the pattern. perhaps retrigger if the synth/env is the result of an embedded pbind, but play for the duration if it's just a lone env/synthdef.
* make it possible to send out values at a specific key at a different rate
  * i.e.: `(pbind :dur 1 :foo (pseq '(1 2 3)) :bar (pbind :dur 1/2 :val (pseq '(9 8 7))))` results in `:foo` being set to 1, then 2, then 3 on every beat, while `:bar` is set to 9, then 8, then 7 on every half beat. effectively, the :bar sub-pattern is independent from the main pbind, it's just launched at the same time and ends at the same time.
* make macros to quickly write out patterns with symbols, i.e. k---s---k---s--- for a kick/snare/kick/snare pattern or the like - see `ds` in `misc.lisp`
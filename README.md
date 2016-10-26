# cl-patterns

A library for writing SuperCollider-esque patterns in Lisp. Aims to emulate most of the patterns that are part of SuperCollider, but make them more robust, consistent, lispy, dynamic, and reflective.

Intro
=====

(This code won't work yet - still have to fix a few things)

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

* event.lisp - code to represent and deal with events (the event class, play functionality, `*event-output-type*`, etc)
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

* `tsubseq` function for getting a subsequence based on start and end times of events.
* automatically convert between different ways to represent the same thing in events
  * for example, if you set an event's `amp` but then try to access its `db`, it calculates the `db` based on the `amp` value.
  * the same should be true for when you set the values - setting `db` instead allows you to get the `amp`
  * interally, an Event only keeps track of `amp` and just converts to whatever type you request, or converts whatever type you give it to `amp`.
* more metadata in patterns and streams so that it's easier to write functions that process streams/patterns/etc
* use the `prove` library to write tests for the patterns.
* make it easy to combine patterns by "injecting" the results of an event pattern into its parent event pattern
  * i.e.:
  `(pbind :foo (pseq '(hey how are ya)) :inject (pbind :bar (pseq '(1 2 3))))`
  results in:
  `'((:foo hey :bar 1) (:foo how :bar 2) (:foo are :bar 3))`
* make it possible to really easily create lfos (i.e. maybe embedding a sc:defsynth as the value for a pbind's key?)
* make it possible to send out values at a specific key at a different rate
  * i.e.:
  `(pbind :dur 1 :foo (pseq '(1 2 3)) :bar (pbind :dur 1/2 :val (pseq '(9 8 7))))`
  results in `:foo` being set to 1, then 2, then 3 on every beat, while `:bar` is set to 9, then 8, then 7 on every half beat.
  effectively, the :bar sub-pattern is independent from the main pbind, it's just launched at the same time.
* make macros to quickly write out patterns with symbols, i.e. k---s---k---s--- for a kick/snare/kick/snare pattern or the like.

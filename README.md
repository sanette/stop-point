# stop-point

emacs library for the _stop-point_ method. Useful when you have to
type many parenthesis (), {} etc.  or for LaTeX $$-like constructions.

## Overview

The principle is the following:

* any string can be defined a a _stop-point_. Default is "◀◀"

* when you want to use a $$ construction, bind the key of your choice,
and when you hit it, it inserts "$$◀◀" and the cursor is automatically
placed between the two $$.  Now type your code, for instance $a+b=c$◀◀
and when you are done, press TAB, then the cursor will jump to the
_stop-point_ outside the $$, and the _stop-point_ is deleted.

* if you hit the same key while a region is selected, this does the
  natural thing, ie. it places $'s around the selection.

* Of course it also works for (), {}, \[ \], or for several arguments,
  like \frac{}{}, etc.

* Of course you may use (much) more sophisticated modes like
_yasnippet_, but the _stop-point_ method is super light weight and
enough for many cases.  I've been using this for so many years... this
is really handy.

## Usage

* save *stop.el* anywhere you want

* insert in your .emacs file:

```elisp
(load "/path/to/stop.el")
```

* by default the stop-point will be colorized only in latex-mode.

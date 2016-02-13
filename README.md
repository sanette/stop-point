# stop-point
emacs library for the _stop-point_ method. Useful when you have to type many parenthesis (), {] etc. 
or for LaTeX $$-like constructions.

## Overview

* any string can be defined a a _stop-point_. Default is "◀◀"

* when you want to use a $$ construction, bind the key of your choice, and when you hit it, it inserts
"$$◀◀" and the cursor is automatically placed between the two $$.
Now type your code, for instance $a+b=c$◀◀
and when you are done, press TAB, then the cursor will jump to the _stop-point_ outside the $$, and the _stop-point_ is deleted.

* Of course it works also for (), {}, \[ \], or for several arguments, like \frac{}{}, etc.

* Of course you may use more sophisticaded modes like _yasnippet_,
but the _stop-mode_ method is super light weight and enough for many cases.
I've been using this for so many years... this is really handy.

## Usage

* save *stop.el* anywhere you want

* insert in your .emacs file:

```elisp
(load "/path/to/stop.el")
```

* by default the stop-point will be colorized only in latex-mode. You may change this directly in the source code.

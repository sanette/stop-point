;; STOP method for emacs
;; Vu Ngoc San (c) 1999-2016

;; DEPRECATED: use stop-mode.el instead
;; http://nullprogram.com/blog/2013/02/06/

(transient-mark-mode t)

; TODO use defcustom
(defvar stop-key (kbd "TAB")
  "This defines the key that will be bound to
'go-next-stop-point. Note that you can use a key that you already
use for something else, like TAB, because if there is no
stop-point, then the original binding wills be invoked. The value
of this variable can be changed by setting stop-key before
loading stop.el" )

;;http://stackoverflow.com/questions/9942675/in-elisp-how-do-i-put-a-function-in-a-variable
(fset 'stop-key-old-function
      (lookup-key (current-global-map) stop-key))

(defvar stop-point "◀◀"
  "This character chain serves to put marks in the document.  The
next mark is reached and erased by calling the function
'go-next-stop-point'")
  
(font-lock-add-keywords `latex-mode
			(list (cons stop-point font-lock-warning-face)))

(defun go-next-stop-point ()
  "jumps to the next STOP point (defined by stop-point)
and delete it. If not found,we invoke the old keybinding"
  (interactive)
  (if 
      (re-search-forward
       stop-point
       nil t 1)
      (delete-backward-char (length stop-point))
    (stop-key-old-function)
    )
  )

(defun insert-stop (s n)
"inserts the string s followed by a stop-point, and backward n
chars (from the end of the string s)"
(insert  (concat s stop-point))
  (backward-char (+ n (length stop-point)))
  )

(defun region-insert-stop (s n)
"Same as insert-stop, except that if a region was selected, it is
inserted and the stop-point is removed. THIS USES KILL (the
region is copied)"
  (if mark-active
      (let ((debut (region-beginning))
	    (fin (region-end))
	    (ici (point)))
	(kill-region debut fin)
	(goto-char debut)
	(insert-stop s n)
	(yank)
	(go-next-stop-point))
    (insert-stop s n))
  )

;;
;; that's it for the "library". Below are various usages.
;;

(defun stop-parenthesis ()
"puts parenthesis around the region, if region there
is. Otherwise, inserts a pair of parenthesis, nothing inside, and
a stop-point."
  (interactive)
  (region-insert-stop "()" 1)
  )

(defun stop-braces ()
"puts curly braces around the region, if region there is.
Otherwise, insert a pair of curly braces and a stop-point."
  (interactive)
  (region-insert-stop "{}" 1)
  )


(global-set-key stop-key 'go-next-stop-point)
(global-set-key [f11] 'stop-parenthesis)
(global-set-key [f10] 'stop-braces)


;;
;; LaTeX specific bindings
;;

(defun stop-tex-braces ()
"puts TeX curly braces around the region, if region there
is. Otherwise, inserts a pair of TeX curly braces \{ and \}, and
a stop-point."
  (interactive)
  (region-insert-stop "\\{\\}" 2)
  )

(defun stop-tex-mathline ()
"puts LaTeX formula delimiters \[ and \] around the region, if
region there is. Otherwise, inserts \[ and \], an empty line
inbetween, and a stop-point."
  (interactive)
  (region-insert-stop "\\[

\\]
" 4)
  )

(defun stop-frac ()
  "inserts LaTeX \frac command. If a region is selected, the
region is inserted into the first argument of \frac"
  (interactive)
  (if mark-active
      (progn
	(region-insert-stop "\\frac{}" 1)
	(insert-stop "{}" 1))
    (progn
      (insert "\\frac{")
      (let ((ici (point)))
	(insert (concat "}{" stop-point "}" stop-point))  
	(goto-char ici)
	)
      )
    )
  )

(defun mybackslash ()
  (interactive)
  (insert "\\"))

(defun stop-dollars ()
"puts dollar signs around the region, if region there
is. Otherwise, inserts two dollar signs and a stop-point"
  (interactive)
  (region-insert-stop "$$" 1)
  )

(defun stop-latex-init ()
  "Specific bindings for LaTeX-mode"
  (local-set-key (kbd "C-ù") 'stop-frac)
  (local-set-key [f9] 'stop-dollars)
  (local-set-key [f8] 'stop-tex-braces)
  (local-set-key [f7] 'stop-tex-mathline)
  (local-set-key [f12] 'mybackslash)
  )

(add-hook 'LaTeX-mode-hook 'stop-latex-init)

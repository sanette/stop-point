;; STOP method, minor mode for emacs
;; Vu Ngoc San 1999-2016
;; GPL

;;;###autoload
(defcustom stop-mode nil
  "Toggle stop-mode.
Setting this variable directly does not take effect;
use either \\[customize] or the function `stop-mode'."
  :set 'custom-set-minor-mode
  :initialize 'custom-initialize-default
  :type    'boolean
  :group   'stop
  :require 'stop)

(defvar stop-key (kbd "TAB")
  "This defines the key that will be bound to
'go-next-stop-point. Note that you can use a key that you already
use for something else, like TAB, because if there is no
stop-point, then the original binding wills be invoked.")

;;;###autoload
(defvar stop-key-old-function
	  (lookup-key (current-global-map) stop-key)
"This is the binding that was in use *before* enabling the
stop-mode. It serves to restore the previous behaviour in case no
stop-point is active in the document")

(make-variable-buffer-local
 (defvar stop-point "\u25C0\u25C0" ; remark \u25C0 = "◀"
   "This character chain serves to put marks in the document.  The
next mark is reached and erased by calling the function
'go-next-stop-point'")
 )

;; (font-lock-add-keywords `latex-mode (list (cons stop-point
;; 			font-lock-warning-face)))

(defun go-next-stop-point ()
  "jumps to the next STOP point (defined by stop-point) and
delete it. If not found,we invoke the old keybinding"
  (interactive)
  (if
      (re-search-forward
       stop-point
       nil t 1)
      (delete-backward-char (length stop-point))
    (funcall stop-key-old-function)
    )
  )

(defun insert-stop (s n)
  "inserts the string s followed by a stop-point, and backward n
chars (from the end of the string s)"
  (insert (concat s stop-point))
  (backward-char (+ n (length stop-point)))
  )

(defun region-insert-stop (s n)
  "Same as insert-stop, except that if a region was selected, it
is inserted and the stop-point is removed. THIS USES KILL (the
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

(defun stop-update-keymap (mode)
"Using this we can change the bindings according to the
major-mode"
  (if (eq mode `latex-mode)
      (progn
	(define-key stop-mode-map [f9] 'stop-dollars)
	(define-key stop-mode-map [f8] 'stop-tex-braces)
	(define-key stop-mode-map [f7] 'stop-tex-mathline)
	(define-key stop-mode-map [f12] 'mybackslash)
	(define-key stop-mode-map  (kbd "C-ù") 'stop-frac)
	)
    )
  )

;;;###autoload
(define-minor-mode stop-mode
  "The famous stop-method."
  :lighter " stop"
  :keymap (list 
	   (cons stop-key 'go-next-stop-point)
	   (cons [f11] 'stop-parenthesis)
	   (cons [f10] 'stop-braces)
	   ) ; at this point the major mode is not known yet... this
	     ; is why we update the mode-map below...

  (font-lock-add-keywords 
   nil
   (list (cons stop-point font-lock-warning-face)))
  (stop-update-keymap major-mode)
  )

;;;###autoload
(add-hook 'LaTeX-mode-hook 'stop-mode)
;;;###autoload
(add-hook 'emacs-lisp-mode-hook 'stop-mode)
;(add-hook 'LaTeX-mode-hook 'stop-latex-init)

(provide 'stop-mode)

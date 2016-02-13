;; STOP method for emacs
;; Vu Ngoc San (c) 1999-2016

(transient-mark-mode t)

(defconst stop-key (kbd "TAB")
  "This defines the key that will be bound to
'go-next-stop-point. Note that you can use a key that you already
use for something else, like TAB, because if there is no
stop-point, then the original binding wills be invoked."  )

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
 "insere la chaine s suivie d'un stop-point, et recule de n
caracteres (a partir de la fin de la chaine s)"
(insert  (concat s stop-point))
  (backward-char (+ n (length stop-point)))
  )

(defun region-insert-stop (s n)
  "Comme insert-stop, sauf que si une region etait selectionnee, elle
est inseree et le stop est enleve. UTILISE KILL (la region est copiee)"
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

(defun stop-parentheses ()
  "entoure la region de parentheses, si region il y a. 
Sinon, insere des parentheses ouvrantes et fermantes, sans rien dedans,
 avec un stop-point."
  (interactive)
  (region-insert-stop "()" 1)
  )

(defun stop-dollars ()
  "entoure la region de dollars, si region il y a.
Sinon, insere deux dollars, sans rien dedans,
avec un stop-point."
  (interactive)
  (region-insert-stop "$$" 1)
  )

(defun stop-accolades ()
  "entoure la region d'accolades, si region il y a.
Sinon, insere des accolades ouvrantes et fermantes, sans rien dedans,
 avec un stop-point."
  (interactive)
  (region-insert-stop "{}" 1)
  )

(defun stop-tex-accolades ()
  "entoure la region d'accolades TeX, si region il y a.
Sinon, insere des accolades ouvrantes et fermantes \{ et \}, sans rien dedans,
 avec un stop-point."
  (interactive)
  (region-insert-stop "\\{\\}" 2)
  )

(defun stop-tex-mathline ()
  "entoure la region des délimiteur math \[ et \] LaTeX, si region il y a.
Sinon, insere \[ et \], une ligne vide dedans,
 avec un stop-point."
  (interactive)
  (region-insert-stop "\\[

\\]" 3)
  )

(defun mybackslash ()
  (interactive)
  (insert "\\"))

(global-set-key stop-key 'go-next-stop-point)
;(global-set-key [²] 'go-next-stop-point)
;(global-set-key [S-f11] 'stop-parentheses)
(global-set-key [f11] 'stop-parentheses)
(global-set-key [f10] 'stop-accolades)
(global-set-key [f9] 'stop-dollars)
(global-set-key [f8] 'stop-tex-accolades)
(global-set-key [f7] 'stop-tex-mathline)

(global-set-key [f12] 'mybackslash)

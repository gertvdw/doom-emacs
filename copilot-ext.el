;;; copilot-ext.el -*- lexical-binding: t; -*-

;; A collection of tools and shortcuts.
;; Mostly for my own use.
;; Feel free to use it if you find it useful.
;; I'm not a lisp programmer, so don't expect too much.

;; Author: Gert van der Weyde <gertvdw@gmail.com>
;; Keywords: lisp, tools, shortcuts
;; Version: 0.1

;; copilot customisations thanks to Robert Krahn
;; https://robert.kra.hn/posts/2023-02-22-copilot-emacs-setup/
;; functions renamed because syntax check did not like the slash
(defvar jgw-copilot-manual-mode nil
  "When `t' will only show completions
   when manually triggered, e.g. via M-C-<return>.")

(defun jgw-copilot-change-activation ()
  "Switch between three activation modes:
- automatic: copilot will automatically overlay completions
- manual: you need to press a key (M-C-<return>) to trigger completions
- off: copilot is completely disabled."
  (interactive)
  (if (and copilot-mode jgw-copilot-manual-mode)
      (progn
        (message "deactivating copilot")
        (global-copilot-mode -1)
        (setq jgw-copilot-manual-mode nil))
    (if copilot-mode
        (progn
          (message "activating copilot manual mode")
          (setq jgw-copilot-manual-mode t))
      (message "activating copilot mode")
      (global-copilot-mode))))

(define-key global-map (kbd "M-C-<escape>") #'jgw-copilot-change-activation)

;; disable copilot in these buffers:
(defun jgw-no-copilot-mode ()
  "a helper for jgw-no-copilot-modes"
  (copilot-mode -1))

(defvar jgw-no-copilot-modes '(shell-mode
                               eshell-mode
                               vterm-mode
                               comint-mode
                               compilation-mode
                               debugger-mode
                               dired-mode-hook,
                               compilation-mode-hook,
                               minibuffer-mode-hook)
  "modes in which we want co-pilot disabled")

(defun jgw-copilot-disable-predicate ()
  "when should copilot keep quiet"
  (or jgw-copilot-manual-mode
      (member major-mode jgw-no-copilot-modes)
      (company--active-p)))

;;; gert.el ends here

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Name"
      user-mail-address "Email")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 12 :weight 'semi-light))
;; make sure the same font is used for  frames
(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font-12"))

;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-material)
(setq doom-theme 'doom-gruvbox)

(setq fancy-splash-image (expand-file-name "banners/doom-emacs-gray.svg" doom-user-dir))

;; add a menu item for org journal
(add-to-list '+doom-dashboard-menu-sections
             '("Add journal entry"
               :icon (all-the-icons-octicon "calendar" :face 'doom-dashboard-menu-title)
               :when (featurep! :lang org +journal)
               :face (:inherit (doom-dashboard-menu-title bold))
               :action org-journal-new-entry))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
;; org-agenda in every file under ~/org
(setq org-agenda-files (quote ("~/org")))
(setq org-log-done 'time)

;; recommendations from the manual
;; https://orgmode.org/manual/Activation.html:w
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (("C-c C-f" . copilot-complete)
              :map copilot-completion-map
              ("<right>" . 'copilot-accept-completion)
              ("C-f" . 'copilot-accept-completion)
              ("M-<right>" . 'copilot-accept-completion-by-word)
              ("M-f" . 'copilot-accept-completion-by-word)
              ("M-n" . 'copilot-next-completion)
              ("M-p" . 'copilot-previous-completion)))

;; (use-package docker
;;  :ensure t
;  :bind ("C-c d" . docker))

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))
;; set transparency
;; (set-frame-parameter (selected-frame) 'alpha '(99 99))
;; (add-to-list 'default-frame-alist '(alpha 99 99))

(use-package org-alert
  :ensure t)
(setq alert-default-style 'libnotify)

;; relative imports at last!
(after! lsp-mode
  (setq lsp-clients-typescript-preferences '(:importModuleSpecifierPreference "relative")))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
    '(typescript-mode . ("typescript-language-server" "--stdio" "--log-level=4" "--tsserver-log-verbosity=verbose"
                         :initializationOptions (
                                               ;; :tsserver (:logDirectory "/tmp/")
                                                :preferences (:importModuleSpecifierPreference "relative"))))))

(use-package typescript-mode
  :config
  (define-derived-mode typescriptangular-mode typescript-mode "Angular TS"))


;; temporarily disabled. Using doom-gruvbox for now.
;; (require 'ef-themes)
;; (setq doom-theme 'ef-symbiosis)

;; (use-package auto-virtualenv
;;   :ensure t
;;   :init
;;   (use-package pyvenv
;;     :ensure t)
;;   :config
;;   (add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)
;;   (add-hook 'projectile-after-switch-project-hook 'auto-virtualenv-set-virtualenv)  ;; If using projectile
;;   )
(use-package pyvenv-auto
  :hook ((python-mode . pyvenv-auto-run)))

;; (load! "gert/gert.el")
(load! (expand-file-name "copilot-ext.el" doom-user-dir))
;; (load! (expand-file-name "vue.el" doom-user-dir))

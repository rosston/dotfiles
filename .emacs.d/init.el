(setq lexical-binding t)

(defvar my-packages
  '(use-package))

(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(require 'cl-lib)

(when (cl-find-if (lambda (p) (not (package-installed-p p))) my-packages)
  (package-refresh-contents))

(dolist (pack my-packages)
  (unless (package-installed-p pack)
    (package-install pack)))

(require 'use-package)

(use-package better-defaults
  :ensure t)
(use-package company
  :init (run-with-timer 0 nil (lambda () (global-company-mode t)))
  :ensure t)
(use-package custom
  :init (setq custom-file "~/.emacs.d/custom.el"))
(use-package eldoc
  :commands eldoc-mode)
(use-package evil
  :bind (:map evil-normal-state-map
              (";" . evil-ex))
  :config (progn
            (setq evil-search-module 'evil-search)
            (use-package evil-commentary
              :ensure t
              :init (evil-commentary-mode))
            (use-package evil-leader
              :config (progn
                        (evil-leader/set-leader "<SPC>")
                        (evil-leader/set-key
                          "pf" 'fzf
                          "gs" 'startup-magit
                          "bb" 'ido-switch-buffer))
              :ensure t
              :init (global-evil-leader-mode))
            (use-package evil-search)
            (use-package evil-surround
              :ensure t
              :init (global-evil-surround-mode 1))

            (setq normal-state-cursor-string "\e]50;CursorShape=0\x7")

            (defun my-send-string-to-terminal (string)
              (unless (display-graphic-p) (send-string-to-terminal string)))

            (defun my-evil-terminal-cursor-change ()
              (when (string= (getenv "TERM_PROGRAM") "iTerm.app")
                (add-hook 'evil-insert-state-entry-hook
                          (lambda () (my-send-string-to-terminal "\e]50;CursorShape=1\x7")))
                (add-hook 'evil-insert-state-exit-hook
                          (lambda () (my-send-string-to-terminal normal-state-cursor-string)))))

            (defun my-make-cursor-normal (process-name msg)
              (my-send-string-to-terminal normal-state-cursor-string))

            (add-hook 'after-make-frame-functions (lambda (frame) (my-evil-terminal-cursor-change)))
            (advice-add 'fzf/after-term-handle-exit :after #'my-make-cursor-normal)
            (my-evil-terminal-cursor-change)
            (add-hook 'evil-insert-state-exit-hook
                      (lambda () (soft-caps-lock-mode -1))))
  :ensure t
  :init (progn
          (setq evil-want-keybinding nil)
          (evil-mode t)))
(use-package evil-ediff
  :ensure t)
(use-package fzf
  :config (setq fzf/args "--no-hscroll --margin=0,1,1,0")
  :ensure t)
(use-package ido
  :config (progn
            (ido-mode t)
            (ido-everywhere t)
            (use-package flx-ido
              :config (flx-ido-mode t)
              :ensure t)
            (use-package ido-completing-read+
              :config (ido-ubiquitous-mode t)
              :ensure t)
            (use-package ido-vertical-mode
              :config (ido-vertical-mode)
              :ensure t))
  :ensure t)
(use-package less-css-mode
  :defer t
  :ensure t)
(use-package lisp-mode
  :config (progn
            (add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
            (add-hook 'lisp-interaction-mode-hook 'eldoc-mode)))
(use-package magit
  :config (progn
            (setq evil-collection-magit-want-horizontal-movement t)
            (setq git-commit-summary-max-length 50)
            (setq magit-fetch-arguments '("--prune"))
            (use-package evil-collection
              :after evil
              :ensure t
              :config (evil-collection-init))
            (setq magit-completing-read-function 'magit-ido-completing-read
                  magit-status-buffer-switch-function 'switch-to-buffer))
  :ensure t)
(use-package nlinum
  :config (global-nlinum-mode t)
  :ensure t)
(use-package racket-mode
  :ensure t)
(use-package rainbow-delimiters
  :ensure t
  :init (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))
(use-package smartparens
  :config (require 'smartparens-config)
  :ensure t
  :init (add-hook 'prog-mode-hook #'smartparens-mode))
(use-package smex
  :bind ("M-x" . smex)
  :ensure t)
(use-package spacemacs-theme
  :defer t
  :ensure t
  :init (load-theme 'spacemacs-dark t nil))

(defun startup-magit ()
  (interactive)
  (magit-status)
  (delete-other-windows))

; Shamelessly copied from https://github.com/jordonbiondo/.emacs.d
(defun pbcopy(beg end)
  "Stick the region on yer pastin' board."
  (interactive "r")
  (when (zerop (let ((inhibit-message t))
                 (shell-command-on-region (region-beginning) (region-end) "pbcopy")))
    (message "copied")))

; Shamelessly copied from https://github.com/jordonbiondo/.emacs.d
(defun pbpaste()
  "Insert the contents from `pbpaste'. Won't trigger chords."
  (interactive)
  (insert (shell-command-to-string "pbpaste -Prefer txt")))

(defun soft-caps-capitalize ()
  (upcase-region (1- (point)) (point)))

; Props to https://github.com/jordonbiondo for this mode and its backing function
(define-minor-mode soft-caps-lock-mode
  "A mode for software capslock"
  :init-value nil
  :lighter " softcaps"
  :keymap nil
  (if soft-caps-lock-mode
      (add-hook 'post-self-insert-hook 'soft-caps-capitalize nil t)
    (remove-hook 'post-self-insert-hook 'soft-caps-capitalize t)))

(global-set-key (kbd "C-l") 'soft-caps-lock-mode)

(setq column-number-mode t)
(setq fill-column 80)
(setq scroll-margin 20
      scroll-step 1)

(set-frame-font "Source Code Pro-13" nil t)

(define-key evil-normal-state-map (read-kbd-macro "[b") 'evil-prev-buffer)
(define-key evil-normal-state-map (read-kbd-macro "]b") 'evil-next-buffer)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("02f57ef0a20b7f61adce51445b68b2a7e832648ce2e7efb19d217b6454c1b644" default))
 '(package-selected-packages '(evil general)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;;; Basic

;; I'm sure
(scroll-bar-mode -1) ; Disables the scroll bar
(tool-bar-mode -1) ; Disables the toolbar (with the icons)
(menu-bar-mode -1) ; Disables the menubar (dropdown qt-style menu)
(set-fringe-mode 10) ; Adds some space to the sides
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; Makes ESC escape prompts

(column-number-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; May want to change
(setq inhibit-startup-message t) ; Disables starting screen
(tooltip-mode -1) ; Disables tooltips

;;;; Theming
(load-theme 'doom-one)

;;;; Packages
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(setq undo-limit 67108864) ; 64mb.
(setq undo-strong-limit 100663296) ; 96mb.
(setq undo-outer-limit 1006632960) ; 960mb.
(use-package evil ; Run "M-x package-refresh-contents" before evaluating
  :init
  (setq evil-undo-system 'undo-fu)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join))
(require 'undo-fu)

(require 'disable-mouse)
(global-disable-mouse-mode)
(mapc #'disable-mouse-in-keymap (current-active-maps))

(require 'ivy)
(ivy-mode 1)
;; (setq ivy-initial-inputs-alist nil)

(require 'counsel)
(counsel-mode 1)

(require 'ivy-rich)
(ivy-rich-mode 1)

(setq doom-modeline-height 35)
(require 'doom-modeline)
(doom-modeline-mode 1)

(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(setq which-key-idle-delay 0.5)
(require 'which-key)
(which-key-mode)
;; (diminish 'which-key-mode)

(require 'helpful)
(global-set-key (kbd "C-h k") #'helpful-key)

(use-package general ; Run "M-x package-refresh-contents" before evaluating
  :config
  (general-evil-setup t))

;;;; Functions

(defun bf-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t) 
      (backward-char) (insert "\n") (setq end (1+ end)))
    (indent-region begin end)))

(defun open-init-file()
  "Opens the init.el file for editing."
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;;;; Key bindings
(global-set-key (kbd "C-x b") 'counsel-ibuffer)
(global-set-key (kbd "C-x K") 'kill-this-buffer)
(global-set-key (kbd "C-x I") 'open-init-file)
(define-key prog-mode-map (kbd "C-/") 'comment-line)

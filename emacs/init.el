(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("02f57ef0a20b7f61adce51445b68b2a7e832648ce2e7efb19d217b6454c1b644" default))
 '(package-selected-packages
   '(writefreely subed tide typescript-mode vue-mode dap-mode csproj-mode csharp-mode tree-sitter-indent tree-sitter-langs tree-sitter elcord flycheck company lsp-ui lsp-mode rustic evil-collection evil general)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#282c34" :foreground "#bbc2cf" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 110 :width normal :foundry "PfEd" :family "DejaVu Sans Mono")))))
;;;; Basic

(add-to-list 'load-path (expand-file-name "conf" user-emacs-directory))

;; I'm sure
(scroll-bar-mode -1) ; Disables the scroll bar
(tool-bar-mode -1) ; Disables the toolbar (with the icons)
(menu-bar-mode -1) ; Disables the menubar (dropdown qt-style menu)
(set-fringe-mode 10) ; Adds some space to the sides
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; Makes ESC escape prompts
(setq make-backup-files nil)
(setq auto-save-default nil)

(column-number-mode)

(when (display-graphic-p)
  (set-fontset-font t 'han (font-spec :family "Yu Gothic" :size 16))
  (set-fontset-font t 'kana (font-spec :family "Yu Gothic" :size 16)))

;; (add-hook 'prog-mode-hook 'display-line-numbers-mode)
(dolist (mode '(org-mode-hook
		restclient-mode-hook
		vue-mode-hook
                prog-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode t))))

(setq frame-title-format '("%b - GNU Emacs"))

;; May want to change
(setq inhibit-startup-message t) ; Disables starting screen
(tooltip-mode -1) ; Disables tooltips

;;;; Theming
(load-theme 'doom-one)

;;;; Packages
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")
			 ("non-gnu elpa" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)
;; (unless package-archive-contents
;;   (package-refresh-contents))

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

(use-package evil-collection ; Run "M-x package-refresh-contents" before evaluating
  :after evil
  :config
  (evil-collection-init))

(require 'disable-mouse)
(global-disable-mouse-mode)
(mapc #'disable-mouse-in-keymap (current-active-maps))

(use-package elcord ; Run "M-x package-refresh-contents" before evaluating
  :config
  (elcord-mode)
  (setq elcord-display-buffer-details nil)
  (setq elcord-quiet t)
  (setq elcord-idle-timer 180)
  (setq elcord-idle-message "Idle"))

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
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h f") #'helpful-function)

(use-package general ; Run "M-x package-refresh-contents" before evaluating
  :config
  (general-evil-setup t))

(require 'magit)

(require 'projectile)
(projectile-mode)
(bind-key "C-c p" 'projectile-command-map)
(when (file-directory-p "~/source")
  (setq projectile-project-search-path '("~/source")))

(require 'counsel-projectile)
(counsel-projectile-mode)

(require 'org)
(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-startup-indented t)
(add-hook 'org-mode-hook 'visual-line-mode)
(setq org-agenda-files
      '("~/Documents/org/"))

(require 'org-modern)
(with-eval-after-load 'org (global-org-modern-mode))
(setq org-modern-hide-stars nil)
(setq org-modern-table nil)
(setq org-modern-checkbox nil)

(use-package writefreely
  :after org
  :config (load-library "writefreely-config.el"))

(require 'fcitx)
(setq fcitx-use-dbus nil ; fcitx.el doesn't know fcitx5's new dbus interface
      ;; the command name changed, but the switches and arguments haven't
      fcitx-remote-command "fcitx5-remote")
(fcitx-default-setup)

(require 'mu4e)
(setq mu4e-change-filenames-when-moving t)
(setq mu4e-update-interval (* 5 60))
(setq mu4e-get-mail-command "mbsync -a")
(setq mu4e-maildir "~/.mail/gmail")
(setq mu4e-drafts-folder "/[Gmail]/Drafts")
(setq mu4e-sent-folder "/[Gmail]/Sent Mail")
(setq mu4e-refile-folder "/[Gmail]/All Mail")
(setq mu4e-trash-folder "/[Gmail]/Trash")
(setq mu4e-maildir-shortcuts
      '(("/Inbox" . ?i)
	("/[Gmail]/Sent Mail" . ?s)
	("/[Gmail]/Drafts" . ?d)
	("/[Gmail]/Trash" . ?t)
	("/[Gmail]/All Mail" . ?a)))

(use-package subed
  :ensure t
  :config
  ;; Remember cursor position between sessions
  ;; (add-hook 'subed-mode-hook 'save-place-local-mode)
  ;; Break lines automatically while typing
  ;; (add-hook 'subed-mode-hook 'turn-on-auto-fill)
  ;; Break lines at 40 characters
  ;; (add-hook 'subed-mode-hook (lambda () (setq-local fill-column 40)))
  ;; Some reasonable defaults
  (add-hook 'subed-mode-hook 'subed-enable-pause-while-typing)
  ;; As the player moves, update the point to show the current subtitle
  (add-hook 'subed-mode-hook 'subed-enable-sync-point-to-player)
  ;; As your point moves in Emacs, update the player to start at the current subtitle
  (add-hook 'subed-mode-hook 'subed-enable-sync-player-to-point)
  ;; Replay subtitles as you adjust their start or stop time with M-[, M-], M-{, or M-}
  (add-hook 'subed-mode-hook 'subed-enable-replay-adjusted-subtitle)
  ;; Loop over subtitles
  (add-hook 'subed-mode-hook 'subed-enable-loop-over-current-subtitle)
  ;; Show characters per second
  (add-hook 'subed-mode-hook 'subed-enable-show-cps))

;; LSP
;; Reference: https://robert.kra.hn/posts/rust-emacs-setup/
(use-package lsp-mode ; Run "M-x package-refresh-contents" before evaluating
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default, I prefer clippy
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  ;; enable / disable the hints as you prefer:
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui ; Run "M-x package-refresh-contents" before evaluating
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package company ; Run "M-x package-refresh-contents" before evaluating
  :custom
  (company-idle-delay 0) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :bind
  (:map company-active-map
	      ("C-n". company-select-next)
	      ("C-p". company-select-previous)
	      ("M-<". company-select-first)
	      ("M->". company-select-last)))

;; (use-package yasnippet ; Run "M-x package-refresh-contents" before evaluating
;;   :config
;;   (yas-reload-all)
;;   (add-hook 'prog-mode-hook 'yas-minor-mode)
;;   (add-hook 'text-mode-hook 'yas-minor-mode))

(use-package flycheck) ; Run "M-x package-refresh-contents" before evaluating

(use-package tree-sitter) ; Run "M-x package-refresh-contents" before evaluating
(use-package tree-sitter-langs) ; Run "M-x package-refresh-contents" before evaluating
(use-package tree-sitter-indent) ; Run "M-x package-refresh-contents" before evaluating

;; DAP
(use-package dap-mode) ; Run "M-x package-refresh-contents" before evaluating
(dap-mode 1)
(dap-ui-mode 1)

;; Rust Lang
(use-package rustic ; Run "M-x package-refresh-contents" before evaluating
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t))

;; Csharp lang
(use-package csharp-mode) ; Run "M-x package-refresh-contents" before evaluating
(add-hook 'csharp-mode-hook #'lsp-deferred)

(use-package csproj-mode) ; Run "M-x package-refresh-contents" before evaluating

(require 'sharper)
(global-set-key (kbd "C-c n") 'sharper-main-transient)

(defun my-csharp-mode-hook ()
  "Custom configuration for csharp-mode."
  (setq-local company-minimum-prefix-length 0))
(add-hook 'csharp-mode-hook #'my-csharp-mode-hook)

(define-key csharp-mode-map (kbd "C-c C-c a") 'lsp-execute-code-action)
(define-key csharp-mode-map (kbd "C-c C-c e") 'lsp-treemacs-errors-list)

(require 'dap-netcore)
(setq dap-netcore-download-url "https://github.com/Samsung/netcoredbg/releases/download/2.2.0-974/netcoredbg-linux-amd64.tar.gz")

;; Web langs

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.cshtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

;; Rest Client
(require 'restclient)
(add-to-list 'auto-mode-alist '("\\.http\\'" . restclient-mode))

;; Vue framework

(use-package vue-mode
  :mode "\\.vue\\'"
  :config
  (add-hook 'vue-mode-hook #'lsp))

;; TypeScript Lang

(setq typescript-indent-level 2)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'lsp)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

(use-package typescript-mode)

(use-package tide
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;; Haskell Lang

(require 'haskell-mode)

;; Ebuild Lang

(require 'ebuild-mode)

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
(global-set-key (kbd "C-x A") 'org-agenda-list)
(global-unset-key (kbd "C-x C-c"))
(define-key prog-mode-map (kbd "C-/") 'comment-line)

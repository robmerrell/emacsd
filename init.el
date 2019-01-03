;;
;; Package Management
;;

(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)


;;
;; General Settings
;;

;; Set the $PATH when using a GUI - some configurations depend on this
(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

;; turn off the tool bar, scroll bar and menu bar
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; don't show the startup screen
(setq inhibit-startup-message t)

;; use y or n for choices
(defalias 'yes-or-no-p 'y-or-n-p)

;; turn off the bell
(setq ring-bell-function 'ignore)

;; font
(set-frame-font "DejaVu Sans Mono-12")

;; show trailing whitespace
(setq-default show-trailing-whitespace 1)

;; spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; line numbers
(global-display-line-numbers-mode)

;; don't create backup~ or #auto-save# files
(setq backup-by-copying t
      make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

;; move the custom file, any permanent changes should be done intentionally
(setq custom-file "/tmp/custom-file.el")

;; Add to load-path
(add-to-list 'load-path "~/.emacs.d/lisp")


;;
;; Package configs
;;

(use-package my-buffer)

;; company mode
(use-package company
  :ensure t
  :init
  (setq company-selection-wrap-around t)
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0.5)
  (setq company-tooltip-limit 10)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-flip-when-above t)
  :config
  (push 'company-files company-backends)
  (global-company-mode))
  

;; which key popup
(use-package which-key
  :ensure t
  :config
  (which-key-add-key-based-replacements
    "<SPC>c" "comments"
    "<SPC>d" "documentation"
    "<SPC>e" "errors"
    "<SPC>f" "files"
    "<SPC>g" "goto"
    "<SPC>m" "music"
    "<SPC>p" "project"
    "<SPC>s" "search"
    "<SPC>t" "tests"
    "<SPC>v" "version control")
  :init
  (which-key-mode))

;; general
(use-package general
  :ensure t
  :config
  (general-create-definer my-leader-def :prefix "SPC")

  ;; moving between buffers
  (my-leader-def
    :states '(normal)
    "l" 'next-code-buffer
    "h" 'previous-code-buffer

    "ff" 'find-file
    "fn" 'new-empty-buffer

    "ir" 'indent-region

    "sc" 'evil-ex-nohighlight))

;; Avy
(use-package avy
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "gc" 'avy-goto-char))

;; Ivy
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode 1))
  

;; window switching
(use-package window-numbering
  :ensure t
  :init
  (window-numbering-mode t)
  :general
  (my-leader-def
    :states '(normal)
    "0" 'select-window-0
    "1" 'select-window-1
    "2" 'select-window-2
    "3" 'select-window-3
    "4" 'select-window-4))

(use-package magit :ensure t)

;; Evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode)

  ;; magit
  (use-package evil-magit
    :ensure t
    :general
    (my-leader-def
      :states '(normal)
      "vs" 'magit-status))

  ;; comment toggling
  (use-package evil-commentary
    :ensure t
    :general
    (my-leader-def
      :states '(normal visual)
      "cl" 'evil-commentary-line)
    :config
    (evil-commentary-mode))

  )

(use-package all-the-icons :ensure t)

;; theme
(use-package nord-theme
  :ensure t
  :init
  (setq nord-comment-brightness 15)
  (load-theme 'nord t))

;; Modeline
;; run all-the-icons-install-fonts after install
(use-package doom-modeline
      :ensure t
      :defer t
      :hook (after-init . doom-modeline-init))

;; music
(use-package my-music
  :general
  (my-leader-def
    :states '(normal)
    "mn" 'itunes-now-playing
    "mp" 'itunes-play
    "ms" 'itunes-pause
    "mn" 'itunes-next
    "mr" 'itunes-previous))

;; rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

;; flycheck
(use-package flycheck
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "el" 'list-flycheck-errors
    "en" 'flycheck-next-error
    "ep" 'flycheck-previous-error)
  :init (global-flycheck-mode))

;; projectile
(use-package projectile
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "pf" 'projectile-find-file
    "pb" 'projectile-switch-to-buffer
    "ps" 'projectile-ag
    "pi" 'projectile-invalidate-cache)
  :config
  (progn
    (setq projectile-completion-system 'ivy)
    (setq projectile-completion-system 'default)
    (setq projectile-enable-caching t)
    (setq projectile-indexing-method 'native)
    (add-to-list 'projectile-globally-ignored-directories "vendor")
    (add-to-list 'projectile-globally-ignored-directories "elpa"))
  :config
  (projectile-mode))

;; shackle
(use-package shackle
  :config
  (shackle-mode 1)
  (setq shackle-rules
	`(("*go tests*" :align below :size 16 :select t)
	  ("*Racer Help*" :align below :size 16 :select t)
          ("*rust tests*" :align below :size 16 :select t))))


;;
;; Go
;;

(use-package my-go)
(use-package go-guru :ensure t)

(use-package go-eldoc
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "dp" 'godoc-at-point)
  :config
  (add-hook 'go-mode-hook 'go-eldoc-setup))

(use-package go-mode
  :ensure t
  :mode "\\.go\\'"
  :general
  (my-leader-def go-mode-map
    :states '(normal)
    "gd" 'godef-jump
    "tc" 'go-run-current-test
    "tp" 'go-run-previous-test)
  :init
  (add-hook 'go-mode-hook (lambda () (setq tab-width 4)))
  (setq gofmt-command "goimports")
  (setq gofmt-show-errors nil)
  (add-hook 'before-save-hook 'gofmt-before-save))

(use-package company-go
  :ensure t
  :defer t
  :config
  (setq company-go-show-annotation t)
  :init
  (with-eval-after-load 'company
    (add-to-list 'company-backends 'company-go)))


;;
;; Rust
;;

(use-package my-rust)
(use-package rust-mode
  :ensure t
  :config
  (progn
    (use-package racer
      :ensure t
      :mode ("\\.rs\\'" . rust-mode)
      :general
      (my-leader-def rust-mode-map
        :states '(normal)
        "dp" 'racer-describe
        "gd" 'racer-find-definition
        "tc" 'rust-run-current-test
        "tp" 'rust-run-previous-test)
      :config
      (setq racer-rust-src-path "~/.rustup/toolchains/stable-x86_64-apple-darwin/lib/rustlib/src/rust/src"))
    (use-package flycheck-rust
      :ensure t
      :config
      (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))
    (add-hook 'rust-mode-hook #'racer-mode)
    (add-hook 'racer-mode-hook #'eldoc-mode)
    (add-hook 'racer-mode-hook #'company-mode)
    (add-hook 'rust-mode-hook #'electric-pair-mode)
    (setq rust-format-on-save t)))

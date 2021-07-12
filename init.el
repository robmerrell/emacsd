;;; init.el --- Emacs config entry point
;;; Commentary:
;;; Code:

;;
;; Package Management
;;

(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "https://melpa.org/packages/")))

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
(menu-bar-mode 1)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; don't show the startup screen
(setq inhibit-startup-message t)

;; use y or n for choices
(defalias 'yes-or-no-p 'y-or-n-p)

;; turn off the bell
(setq ring-bell-function 'ignore)

;; font
(add-to-list 'default-frame-alist '(font . "Menlo-15"))
(set-face-attribute 'default t :font "Menlo-15")

;; show trailing whitespace
(setq-default show-trailing-whitespace 1)

;; spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; line numbers
(global-display-line-numbers-mode)
(column-number-mode)

;; don't create backup~ or #auto-save# files
(setq backup-by-copying t
      make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

;; move the custom file, any permanent changes should be done intentionally
(setq custom-file "/tmp/custom-file.el")

;; Add to load-path
(add-to-list 'load-path "~/.emacs.d/lisp")

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

;; get pin in emacs instead of shell
(setq epa-pinentry-mode 'loopback)


;;
;; Package configs
;;

(use-package my-buffer)

;; general
(use-package general
  :ensure t
  :config
  (general-create-definer my-leader-def :prefix "SPC")
  (general-define-key :states 'insert "C-y" 'company-yasnippet)

  (my-leader-def
    :states '(normal)
    ":" '(execute-extended-command :which-key "M-x")

    ;; buffers
    "h" '(previous-code-buffer :which-key "Previous Code Buffer")
    "l" '(next-code-buffer :which-key "Next Code Buffer")

    "bn" '(next-code-buffer :which-key "Next Code Buffer")
    "bp" '(previous-code-buffer :which-key "Previous Code Buffer")
    "bl" '(list-buffers :which-key "Buffer List")
    "bs" '(ivy-switch-buffer :which-key "Switch Buffer")
    "bc" '((lambda () (interactive)(switch-to-buffer "*scratch*")) :which-key "Open Scratch")

    ;; files
    "ff" '(find-file :which-key "Find file")
    "fn" '(new-empty-buffer :which-key "New Empty Buffer")

    ;; highlighting
    "n" '(evil-ex-nohighlight :which-key "Remove Highlight")

    ;; frame management
    "wn" '(make-frame :which-key "New Host Window")

    ;; window movement
    "wl" '(evil-window-right :which-key "Select Right Window")
    "wh" '(evil-window-left :which-key "Select Left Window")
    "wj" '(evil-window-down :which-key "Select Window Below")
    "wk" '(evil-window-up :which-key "Select Window Above")

    ;; window resizing
    "wx" '(evil-window-increase-width :which-key "Increase Width")
    "wy" '(evil-window-increase-height :which-key "Increase Height")
    "wb" '(balance-windows :which-key "Balance Windows"))

  (my-leader-def
    :states '(visual)
    "ci" '(indent-region :which-key "Indent Region")))


;; which-key popup
(use-package which-key
  :ensure t
  :init
  (which-key-mode)
  :config
  (setq which-key-add-column-padding 8)
  (which-key-setup-side-window-bottom)
  (which-key-add-key-based-replacements
    "<SPC><SPC>" "Local Leader"
    "<SPC>b" "Buffers"
    "<SPC>c" "Code"
    "<SPC>f" "Files"
    "<SPC>g" "Git"
    "<SPC>p" "Project"
    "<SPC>r" "REPL"
    "<SPC>t" "Treemacs"
    "<SPC>w" "Window")
  :diminish which-key-mode)


;; Magit
(use-package magit
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "gs" '(magit-status :which-key "Magit Status")
    "gr" '(vc-refresh-state :which-key "Magit Refresh State")
    "gb" '(magit-branch-and-checkout :which-key "Branch and Checkout")
    "gc" '(magit-checkout :which-key "Checkout")))


;; Evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands t)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config
  (global-set-key (kbd "M-v") 'evil-paste-before)

  (evil-mode)

  ;; comment toggling
  (use-package evil-nerd-commenter
    :ensure t
    :general
    (my-leader-def
      :states '(normal visual)
      "cl" '(evilnc-comment-or-uncomment-lines :which-key "Toggle Comments")))

  ;; surround
  (use-package evil-surround
    :ensure t
    :config
    (global-evil-surround-mode 1)))


;; window switching
(use-package window-numbering
  :ensure t
  :init
  (window-numbering-mode t)
  :general
  (my-leader-def
    :states '(normal)
    "w1" '(select-window-1 :which-key "Window 1")
    "w2" '(select-window-2 :which-key "Window 2")
    "w3" '(select-window-3 :which-key "Window 3")
    "w4" '(select-window-4 :which-key "Window 4")))


;; Ivy
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode 1))

(use-package swiper
  :ensure t)

(use-package ivy-posframe
  :ensure t
  :diminish ivy-posframe-mode
  :config
  (setq ivy-posframe-parameters '((internal-border-width . 10)))
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center)))
  (ivy-posframe-mode 1))


;; theme
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-palenight t))
(set-face-background 'vertical-border "black")
(set-face-foreground 'vertical-border (face-background 'vertical-border))
(font-lock-add-keywords 'elixir-mode '(("\@doc" . 'font-lock-doc-face)))
(font-lock-add-keywords 'elixir-mode '(("\@moduledoc" . 'font-lock-doc-face)))
(font-lock-add-keywords 'elixir-mode '(("\@typedoc" . 'font-lock-doc-face)))
(font-lock-add-keywords 'elixir-mode '(("\@spec.*" . 'font-lock-doc-face)))


;; solaire mode
(use-package solaire-mode
  :ensure t
  :config
  (solaire-global-mode +1))


;; doom modeline
(use-package doom-modeline
  :ensure t
  :config
  (setq doom-modeline-lsp t)
  (setq doom-modeline-env-enable-elixir t)
  :init (doom-modeline-mode 1))


;; rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook ((elixir-mode . rainbow-delimiters-mode)
         (emacs-lisp-mode . rainbow-delimiters-mode)))


;; smartparens
(use-package smartparens
  :ensure t
  :init
  (smartparens-global-mode 1)
  :config
  (use-package smartparens-config)
  (setq
   smartparens-strict-mode t
   sp-autoskip-closing-pair 'always
   sp-base-key-bindings 'paredit
   sp-hybrid-kill-entire-symbol nil
   sp-highlight-pair-overlay nil
   sp-highlight-wrap-overlay nil
   sp-highlight-wrap-tag-overlay nil))


;; projectile
(use-package projectile
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "pf" '(projectile-find-file :which-key "Find Project File")
    "pb" '(projectile-switch-to-buffer :which-key "Find Project Buffer")
    "pw" '(projectile-switch-project :which-key "Switch To Project")
    "ps" '(projectile-ripgrep :which-key "Search Project")
    "pi" '(projectile-invalidate-cache :which-key "Invalidate Cache"))
  :config
  (progn
    (use-package projectile-ripgrep :ensure t)
    (setq projectile-completion-system 'ivy)
    (setq projectile-completion-system 'default)
    (setq projectile-enable-caching t)
    (setq projectile-indexing-method 'hybrid)
    (setq projectile-sort-order 'recently-active)
    (add-to-list 'projectile-globally-ignored-directories "node_modules")
    (add-to-list 'projectile-globally-ignored-directories "assets/node_modules")
    (add-to-list 'projectile-globally-ignored-directories "_build")
    (add-to-list 'projectile-globally-ignored-directories "deps")
    (add-to-list 'projectile-globally-ignored-directories "vendor")
    (add-to-list 'projectile-globally-ignored-directories "target")
    (add-to-list 'projectile-globally-ignored-directories ".extension")
    (add-to-list 'projectile-globally-ignored-directories "elpa"))
  :config
  (projectile-mode)
  :diminish projectile-mode)


;; shackle
(use-package shackle
  :ensure t
  :config
  (shackle-mode 1)
  (setq shackle-rules
	`(("*Flycheck errors*" :regexp t :align below :size 8 :select t)
          ("*lsp-help*" :regexp t :align below :size 25 :select t)
          ("*go tests*" :align below :size 25 :select t)
          ;; ("*exunit-compilation*" :align below :size 25 :select t)
          ("*exunit-compilation*" :ignore t)
          ("*compilation*" :align below :size 25 :select t)
          ("*cider-error*" :align below :size 25 :noselect t)
          ("*godoc.*" :regexp t :align below :size 25 :select t)
          ("*HTTP Response*" :regexp t :align below :size 25 :select t)
	  ("*Racer Help*" :align below :size 25 :select t)
          ("*rust tests*" :align below :size 25 :select t))))


;; yasnippet
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
  (use-package yasnippet-snippets :ensure t)
  (yas-global-mode 1))


;; company mode
(use-package company
  :ensure t
  :init
  (setq company-selection-wrap-around t)
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0.0)
  (setq company-tooltip-limit 15)
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-flip-when-above t)
  (setq company-tooltip-align-annotations t)
  :config
  (add-to-list 'company-backends '(company-capf))
  (global-company-mode))


;; lsp-mode
(use-package lsp-mode
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "ck" '(lsp-describe-thing-at-point :which-key "Help At Point")
    "cd" '(lsp-find-definition :which-key "Jump to Definition")
    "cn" '(lsp-rename :which-key "Rename")
    "cr" '(lsp-find-references :which-key "Find References")
    "cs" '(lsp-workspace-restart :which-key "Restart LSP Server"))

  :config
  (use-package lsp-ivy :ensure t)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-enable-snippet t)
  (setq lsp-enable-symbol-highlighting nil)
  (add-to-list 'lsp-file-watch-ignored "vendor$")
  (add-to-list 'lsp-file-watch-ignored "deps$")
  (add-to-list 'lsp-file-watch-ignored "_build$")
  (add-to-list 'lsp-file-watch-ignored ".elixir_ls$")
  (add-to-list 'lsp-file-watch-ignored ".extension$")
  (add-to-list 'lsp-file-watch-ignored "node_modules$")
  :hook ((go-mode . lsp)
         (elixir-mode . lsp)
         (rust-mode . lsp))
  :init (add-to-list 'exec-path "~/.elixir-ls/release")
  :commands lsp)


;; flycheck
(use-package flycheck
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "ce" '(list-flycheck-errors :which-key "Show Errors")
    "cx" '(flycheck-next-error :which-key "Next Error"))
  :init (global-flycheck-mode))


;; treemacs
(use-package treemacs
  :ensure t
  :defer t
  :general
  (my-leader-def
    :states '(normal)
    "tt" '(treemacs :which-key "Toggle Treemacs")
    "tp" '(treemacs-projectile :which-key "Add Projectile Project"))
  :config
  (setq treemacs-no-png-images t)
  (use-package treemacs-projectile :ensure t)
  (use-package treemacs-evil :ensure t))


;; restclient
(use-package restclient
  :ensure t
  :mode ("\\.http$" . restclient-mode)
  :init
  (add-hook 'restclient-mode-hook (lambda () (setq tab-width 2)))
  :commands restclient-mode)
(use-package my-rest)



;;
;; Elixir
;;
(defun swiper-search-def () "Search for 'def '." (interactive) (swiper "def "))
(use-package elixir-mode
  :ensure t
  :mode ("\\.ex\\'" "\\.exs\\'" "mix\\.lock\\'")
  :config
  (use-package exunit :ensure t)
  :general
  (my-leader-def elixir-mode-map
    :states '(normal)
    "cc" '(exunit-verify-single :which-key "Run Current Test")
    "cp" '(exunit-rerun :which-key "Run Previous Test")
    "cf" '(swiper-search-def :which-key "Buffer Functions"))
  :init
  (add-hook 'elixir-mode-hook (lambda () (setq tab-width 2)))
  (add-hook 'elixir-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'lsp-format-buffer nil t))))


;;
;; Emacs Lisp
;;
(use-package emacs-lisp-mode
  :bind
  (("C-<right>" . sp-forward-slurp-sexp)
   ("C-<left>" . sp-forward-barf-sexp)
   ("C-M-<left>" . sp-backward-slurp-sexp)
   ("C-M-<right>" . sp-backward-barf-sexp)))


(provide 'init.el)
;;; init.el ends here

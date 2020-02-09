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
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; don't show the startup screen
(setq inhibit-startup-message t)

;; use y or n for choices
(defalias 'yes-or-no-p 'y-or-n-p)

;; turn off the bell
(setq ring-bell-function 'ignore)

;; font
(add-to-list 'default-frame-alist '(font . "Monaco-12"))
(set-face-attribute 'default t :font "Monaco-12")

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
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (global-company-mode))

;; yasnippet
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets")
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
  (yas-global-mode)
  (global-set-key (kbd "C-s") 'company-yasnippet))


;; which key popup
(use-package which-key
  :ensure t
  :config
  ;; (setq which-key-add-column-padding 8)
  (which-key-setup-side-window-right)
  (which-key-add-key-based-replacements
    "<SPC>b" "Buffers"
    "<SPC>c" "Code"
    "<SPC>cq" "Query"
    "<SPC>f" "Files"
    "<SPC>g" "Git"
    "<SPC>m" "Music"
    "<SPC>p" "Project"
    "<SPC>t" "Treemacs"
    "<SPC>w" "Window")
  :init
  (which-key-mode))

;; general
(use-package general
  :ensure t
  :config
  (general-create-definer my-leader-def :prefix "SPC")
  (general-define-key :states 'insert "C-p" 'company-complete)

  (my-leader-def
    :states '(normal)
    ;; system
    "e" '(eval-last-sexp :which-key "Eval Last s-exp")

    ;; buffers
    "bn" '(next-code-buffer :which-key "Next Code Buffer")
    "bp" '(previous-code-buffer :which-key "Previous Code Buffer")
    "bl" '(list-buffers :which-key "Buffer List")
    "bs" '((lambda () (interactive)(switch-to-buffer "*scratch*")) :which-key "Open Scratch")

    ;; files
    "ff" '(find-file :which-key "Find file")
    "fn" '(new-empty-buffer :which-key "New Empty Buffer")

    ;; highlighting
    "<SPC>" '(evil-ex-nohighlight :which-key "Remove Highlight")

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

;; Avy
(use-package avy
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "j" '(avy-goto-char :which-key "Jump To Character")))

;; Ivy
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode 1))

(use-package ivy-posframe
  :ensure t
  :diminish ivy-postframe-mode
  :config
  (setq ivy-posframe-parameters '((internal-border-width . 10)))
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center)))
  (ivy-posframe-mode 1))


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
      "gs" '(magit-status :which-key "Status")))

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

(use-package all-the-icons :ensure t)

;; theme
(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-palenight t)
  (doom-themes-org-config))

;; smartparens
(use-package smartparens
  :ensure t
  :init
  (smartparens-global-mode 1)
  :config

  (use-package smartparens-config)

  (setq
   smartparens-strict-mode t
   sp-autoinsert-if-followed-by-word t
   sp-autoskip-closing-pair 'always
   sp-base-key-bindings 'paredit
   sp-hybrid-kill-entire-symbol nil
   sp-autoescape-string-quote nil
   sp-highlight-pair-overlay nil
   sp-highlight-wrap-overlay nil
   sp-highlight-wrap-tag-overlay nil))

;; Modeline
;; run all-the-icons-install-fonts after install
(use-package doom-modeline
      :ensure t
      :defer t
      :hook (after-init . doom-modeline-mode))

;; music
(use-package my-music
  :general
  (my-leader-def
    :states '(normal)
    "mi" '(itunes-now-playing :which-key "Song Info")
    "mr" '(itunes-play :which-key "Play")
    "ms" '(itunes-pause :which-key "Pause")
    "mn" '(itunes-next :which-key "Play Next")
    "mp" '(itunes-previous :which-key "Play Previous")))

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
    "ce" '(list-flycheck-errors :which-key "Show Errors"))
  :init (global-flycheck-mode))

(use-package flycheck-golangci-lint
  :ensure t
  :hook (go-mode . flycheck-golangci-lint-setup))

;; projectile
(use-package projectile
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "pf" '(projectile-find-file :which-key "Find Project File")
    "pb" '(projectile-switch-to-buffer :which-key "Find Project Buffer")
    "pr" '(projectile-switch-project :which-key "Switch To Project")
    "ps" '(projectile-ag :which-key "Search Project")
    "pi" '(projectile-invalidate-cache :which-key "Invalidate Cache"))
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
  :ensure t
  :config
  (shackle-mode 1)
  (setq shackle-rules
	`(("*Flycheck errors*" :regexp t :align below :size 8 :select t)
          ("*go tests*" :align below :size 25 :select t)
          ("*godoc.*" :regexp t :align below :size 25 :select t)
	  ("*Racer Help*" :align below :size 25 :select t)
          ("*rust tests*" :align below :size 25 :select t))))

;; treemacs
(use-package treemacs
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "tt" '(treemacs :which-key "Treemacs")))

(use-package treemacs-evil
  :ensure t)

(use-package treemacs-projectile
  :ensure t)

;; lsp-mode
(use-package lsp-mode
  :ensure t
  :general
  (my-leader-def
    :states '(normal)
    "ck" '(toggle-lsp-ui-help :which-key "Help At Point")
    "cd" '(lsp-find-definition :which-key "Jump to Definition")
    "cn" '(lsp-rename :which-key "Rename")
    "cr" '(lsp-find-references :which-key "Find References")
    "ts" '(lsp-treemacs-symbols :which-key "Symbols"))

  :config
  (setq lsp-enable-links nil)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-prefer-flymake :none)
  (add-to-list 'lsp-file-watch-ignored "vendor$")

  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-ignore-duplicate t)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-position 'bottom)
  :hook ((go-mode . lsp))
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package company-lsp
  :ensure t
  :config
  (push 'company-lsp company-backends)
  :commands company-lsp)

(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

;;
;; Go
;;

(use-package my-go)
(use-package go-mode
  :ensure t
  :mode "\\.go\\'"
  :config
  (use-package company-go
    :ensure t
    :defer t
    :config
    (setq company-go-show-annotation t)
    :init
    (with-eval-after-load 'company
      (add-to-list 'company-backends 'company-go)))

  :general
  (my-leader-def go-mode-map
    :states '(normal)
    "cc" '(go-run-current-test :which-key "Run Current Test")
    "cp" '(go-run-previous-test :which-key "Run Previous Test"))
  :init
  (add-hook 'go-mode-hook (lambda () (setq tab-width 4)))
  (setq gofmt-command "goimports")
  (setq gofmt-show-errors nil)
  (add-hook 'before-save-hook 'gofmt-before-save))


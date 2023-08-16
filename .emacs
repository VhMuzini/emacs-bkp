;; Install globaly with npm:
;; typescript
;; typescript-language-server
;; eslint
;; If working with angular: @angular/language-service@next @angular/language-server
;; Need to manually install all the fonts of all the icons on windows
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(web-mode dotenv-mode typescript-mode js2-mode json-mode scss-mode lsp-mode emmet-mode diminish dashboard duplicate-thing projectile undo-tree magit which-key treemacs-icons-dired treemacs yasnippet-snippets swiper yasnippet company-prescient company async ivy avy mark-multiple beacon)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "MS  " :slant normal :weight bold :height 120 :width normal)))))

;; Add melpa to the packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; When working with nvm.
;;(when (memq window-system '(mac ns x))
;;  (exec-path-from-shell-initialize))

;; ---------------------- Editor Settings ------------------

;; Start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Cursor as a bar
(setq-default cursor-type 'bar)

;; Auto close of symbols
(setq electric-pair-pairs '(
                           (?\{ . ?\})
                           (?\( . ?\))
                           (?\[ . ?\])
                           (?\" . ?\")
                           ))
(electric-pair-mode t)

;; No tool,menu and scroll bar
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Disable Auto Save
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Disable ring bell
(setq ring-bell-function 'ignore)

;; Increase garbage collector
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; Allow Copy/paster outside emacs
(setq x-select-enable-clipboard t)

;; Scroll with ctrl + arrow
(defun gcm-scroll-down ()
  (interactive)
  (scroll-up 1))
(defun gcm-scroll-up ()
  (interactive)
  (scroll-down 1))
(global-set-key [(control down)] 'gcm-scroll-down)
(global-set-key [(control up)]   'gcm-scroll-up)
(setq scroll-conservatively 100)

;; Indent with 4 spaces
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil) ;; spaces instead of tabs
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq backward-delete-char-untabify-method 'nil)

;;‘y’ or ‘n’ instead of ‘yes’ or ‘no’ when confirming
(defalias 'yes-or-no-p 'y-or-n-p)

;;Show parent parenthese
(show-paren-mode 1)

;;New lines at the end of the file
(setq next-line-add-newlines t)

;; Set utf-8 as default enconding
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Kill the word properly
(defun daedreth/kill-inner-word ()
  "Kills the entire word your cursor is in. Equivalent to 'ciw' in vim."
  (interactive)
  (forward-char 1)
  (backward-word)
  (kill-word 1))
(global-set-key (kbd "C-c w k") 'daedreth/kill-inner-word)

;; Emacs Treats Camel Case Correctly now
(global-subword-mode 1)

;; Highlight current Line
;;(global-hl-line-mode t)

;; Change the focus to the current splited window
(defun split-and-follow-horizontally ()
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 2") 'split-and-follow-horizontally)

(defun split-and-follow-vertically ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))
(global-set-key (kbd "C-x 3") 'split-and-follow-vertically)

;; ----------------------------------------------------------------------------------------------
;; ------------------------------------ Packages Area -------------------------------------------
;; ----------------------------------------------------------------------------------------------

;; Defer all packages for quickly startup
(setq use-package-always-defer t)

;; Most important part
(use-package doom-themes
  :ensure t
  :defer nil
  :init (load-theme 'doom-moonlight t))

;; Breifly highlight the cursor
(use-package beacon
:ensure t
:defer nil
:config
(beacon-mode 1))

;; Allows you to quickly mark the next occurence of a region and edit them all at once
(use-package mark-multiple
  :ensure t
  :defer nil
  :bind ("C-c q" . 'mark-next-like-this))

;; Move the cursor to char
(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char))

;; Useful frontend completion and functions
(use-package ivy
  :ensure t
  :defer nil
  :config
  (global-set-key (kbd "C-x b") #'ivy-switch-buffer))

;; Use async when possible
(use-package async
:ensure t
:defer nil
:init (dired-async-mode 1))

;; Setting up company mode
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.01)
  (setq company-tooltip-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t)
  (setq company-show-numbers t)
  ;;(setq company-tooltip-limit 20)
  ;;(setq company-dabbrev-downcase 0)
  (setq company-dabbrev-code-minimum-length 3)
  ;;(setq company-dabbrev-other-buffers t)
  (setq company-dabbrev-code-other-buffers t)
  (setq company-dabbrev-ignore-case 'keep-prefix)
  (setq completion-ignore-case t)
  (setq company-transformers '(company-sort-by-occurrence))
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "ESC") #'company-abort)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (setq company-backends '((company-capf :with company-yasnippet :separate
							company-keywords company-files company-dabbrev-code)))
  :hook
  ((prog-mode markdown-mode) . company-mode))

;; Better sort of the suggestions
 (use-package company-prescient
   :ensure t
   :defer nil
   :after (company)
   :config
   (company-prescient-mode 1)
   (prescient-persist-mode))

;; -------------- Yasnippet
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
   (use-package yasnippet-snippets
      :ensure t)
  (yas-reload-all)
  :hook ((typescript-mode-hook . (lambda ()
                                    (yas-activate-extra-mode 'js2-mode)))
         (web-mode-hook . (lambda ()
                             (yas-activate-extra-mode 'html-mode))))
((prog-mode) . yas-minor-mode))

;; Best searcher ever
 (use-package swiper
:ensure t
:bind ("C-s" . 'swiper))

;; Tree view
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (treemacs-git-mode -1)
  (progn
    (setq treemacs-collapse-dirs                 (if (executable-find "python3") 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         30)
    (treemacs-resize-icons 11)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-icons-dired
	:after treemacs dired
	:ensure t
	:config (treemacs-icons-dired-mode))


;; Show which key to use
(use-package which-key
  :ensure t
  :init
  (which-key-mode))

;; Like magic but with a t
(use-package magit
  :ensure t)

;; Undo Tree
(use-package undo-tree
  :ensure t
  :defer nil
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode))

;; Project manager
(use-package projectile
  :ensure t
  :defer nil
  :config
  (projectile-mode t)
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)
  (setq projectile-enable-caching t)
  (setq projectile-require-project-root t)
  ;;(setq projectile-ensure-project nil)
  (setq projectile-globally-ignored-directories '("*node_modules"))
  (setq projectile-completion-system 'ivy)
  (setq projectile-dynamic-mode-line nil))

;; Duplicate current line or marked set
(use-package duplicate-thing
:ensure t
:defer nil
:config
(global-set-key (kbd "C-d") 'duplicate-thing))

;; Front end of emacs!
(use-package dashboard
  :ensure t
  :defer nil
  :config
    (dashboard-setup-startup-hook)
	(setq dashboard-set-init-info t)
    (setq dashboard-startup-banner "~/.emacs.d/img/lain.jpg")
	(setq dashboard-banner-logo-title "Property of Lain")
	(setq dashboard-set-file-icons t)
	(setq dashboard-set-init-info t)
	(setq dashboard-path-max-length 60)
	(setq dashboard-center-content t)
	(setq dashboard-footer-messages '("Hail Lain!"))
    (setq dashboard-items '((recents  . 5)
                            (projects . 5))))

;; LSP Configs
(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-enable-snippet t)
  (setq lsp-modeline-code-actions-mode t)
  (setq lsp-ui-doc-enable nil)
  (setq lsp-idle-delay 0.500)
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-javascript-completions-complete-function-calls t)
  (setq lsp-typescript-suggest-complete-function-calls t)
  (setq lsp-completion-provider :none)
  (setq lsp-completion-show-label-description nil)
  (global-set-key (kbd "C-c r") #'lsp-restart-workspace)
  (add-hook 'before-save-hook #'lsp-format-buffer) ;; Sometimes makes weird stuff
  :hook
  ((prog-mode) #'lsp))

;; Diminish packages
(use-package diminish
  :ensure t
  :defer nil
  :init
  (diminish 'which-key-mode)
  (diminish 'abbrev-mode)
  (diminish 'flycheck-mode)
  (diminish 'beacon-mode)
  (diminish 'subword-mode)
  (diminish 'company-mode)
  (diminish 'eldoc-mode))

;; ----------------------------------------------------------------------------------------------------
;; ------------------------------------- Prog modes area ----------------------------------------------
;; ----------------------------------------------------------------------------------------------------

;; Web development Area
(use-package js2-mode
  :ensure t
  :defer nil
  :commands (js2-mode)
  :mode ("\\.js?\\'" . js2-mode))

(use-package typescript-mode
  :ensure t
  :defer nil
  :commands (typescript-mode)
  :mode ("\\.ts\\'" . typescript-mode))

(use-package dotenv-mode
  :ensure t
  :commands (dotenv-mode)
  :mode ("\\.env\\'" . dotenv-mode))

;; ------ WEB MODE --------
(use-package web-mode
  :ensure t
  :defer nil
  :config
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)
  :commands (web-mode)
  :mode (("\\.html?\\'" . web-mode)
		 ("\\.tsx\\'" . web-mode)
		 ("\\.jsx\\'" . web-mode)))

(use-package emmet-mode
  :ensure t
  :config
  (define-key emmet-mode-keymap (kbd "<tab>") 'emmet-expand-line)
  :hook
  ((web-mode) . emmet-mode))

(use-package company-web-html
  :config
  (add-hook 'web-mode-hook
            (lambda ()
              (setq-local company-backends
                          '((company-capf :with company-web-html
                                               company-yasnippet
                                               company-dabbrev-code
                                               company-keywords))))))

;; Css and SCSS
(use-package scss-mode
  :ensure t
  :defer nil
  :commands (scss-mode)
  :mode ((("\\.css\\'" . scss-mode))
		  ("\\.scss\\'" . scss-mode)))

;; Json-mode
(use-package json-mode
  :ensure t
  :defer nil
  :commands (json-mode)
  :mode ("\\.json?\\'" . json-mode))

;; CSharp
(use-package csharp-mode
:defer nil
:commands (csharp-mode)
:mode ("\\.cs\\'" . csharp-mode))

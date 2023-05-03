;; Install globaly: 
;; typescript
;; typescript-language-server
;; If working with angular: @angular/language-service@next @angular/language-server
;; Need to manually install all the fonts of all the icons
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(duplicate-thing yasnippet-snippets diminish auto-package-update awesome-tab projectile undo-tree company-irony company-c-headers meghanada yasnippet magit which-key treemacs-icons-dired treemacs swiper htmlize all-the-icons highlight-symbol multiple-cursors scss-mode use-package csharp-mode company-tabnine lsp-ui lsp-mode dumb-jump git-modes ng2-mode company-web emmet-mode web-mode-edit-element json-mode dotenv-mode typescript-mode company web-mode js2-mode ivy atom-one-dark-theme))
 '(warning-suppress-types '((lsp-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Consolas" :foundry "outline" :slant normal :weight bold :height 120 :width normal)))))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; ---------------------- My Settings ------------------

;; Start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Display line numbers
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

;; Atom as default Theme
(load-theme 'atom-one-dark t)

;; Cursor as a bar
(setq-default cursor-type 'bar)

;; Auto close parenteses, aspas, chaves e colchetes
(electric-pair-mode 1)

;; No tool,menu and scroll bar
(menu-bar-mode 0)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(use-package avy
  :ensure t
  :bind
    ("M-s" . avy-goto-char))

;; Tabs bar
;;(tab-bar-mode 1)
;;(use-package centaur-tabs
;;  :demand
;;  :config
;;  (centaur-tabs-mode t)
;;  (centaur-tabs-headline-match)
;;  (setq centaur-tabs-style "bar")
;;  (setq centaur-tabs-height 35)
;; (centaur-tabs-change-fonts "Consolas" 160)
;; (setq centaur-tabs-enable-key-bindings t)
;;  :bind
;;  ("C-<prior>" . centaur-tabs-backward)
;;  ("C-<next>" . centaur-tabs-forward))

;; Disable Auto Save
(setq make-backup-files nil)
(setq auto-save-default nil)

;; Disable ring bell
(setq ring-bell-function 'ignore)

;; Increase garbage collector
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;; Enable Line Numbers globaly
(global-display-line-numbers-mode 1)

;; Enable Dumb jumb
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)

;; Allow Copypaster outside emacs
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

;; Indent with 4 spaces
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil) ;; spaces instead of tabs
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq backward-delete-char-untabify-method 'nil)

;;‘y’ or ‘n’ instead of ‘yes’ or ‘no’ when confirming
(defalias 'yes-or-no-p 'y-or-n-p)

;;Show parent parentheses
(show-paren-mode 1)

;;New lines at the end of the file
(setq next-line-add-newlines t)

;; Set utf-8 as default enconding
(setq-default buffer-file-coding-system 'utf-8-unix)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(use-package ivy
:ensure t
:config
(global-set-key (kbd "C-x b") #'ivy-switch-buffer))

;; Setting up company mode
(use-package company
  :ensure t
  :diminish (meghanada-mode company-mode irony-mode)
  :config
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-align-annotations t)
  (setq company-show-numbers t)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") #'company-select-next)
  (define-key company-active-map (kbd "C-p") #'company-select-previous)
  (define-key company-active-map (kbd "SPC") #'company-abort)
  (setq company-backends
        '((company-yasnippet :separate
							 company-tabnine
                             company-files
                             company-keywords
							 company-abbrev
							 company-dabbrev
                             company-capf)))
  :hook
  ((java-mode c-mode c++-mode js2-mode typescript-mode dotenv-mode web-mode json-mode csharp-mode css-mode) . company-mode))

(defun my-company-tab ()
  (interactive)
  (when (company-tooltip-visible-p)
    (company-complete-selection)))
  
(add-hook 'company-mode-hook (lambda ()
                              (define-key company-active-map (kbd "<tab>") 'my-company-tab)))
							  
							  
;; -------------- Yasnippet
(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :hook
  ((c-mode c++-mode js2-mode typescript-mode css-mode) . yas-minor-mode)
  :config
  (yas-reload-all)
  :hook ((typescript-mode-hook . (lambda ()
                                    (yas-activate-extra-mode 'js2-mode)))
         (web-mode-hook . (lambda ()
                             (yas-activate-extra-mode 'html-mode)))))							

;; -------------- LSP Configs
(use-package lsp-mode
  :ensure t
  :config
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-enable-snippet nil)
  (setq lsp-modeline-code-actions-mode t)
  (setq lsp-ui-doc-enable nil)
  (setq lsp-idle-delay 0.500)
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-completion-provider :none)
  (add-hook 'before-save-hook #'lsp-format-buffer) ;; Sometimes makes weird stuff
  :hook
  ((js2-mode c++-mode typescript-mode css-mode java-mode web-mode ng2-mode dotenv-mode) #'lsp))

;; Best searcher ever
 (use-package swiper
:ensure t
:bind ("C-s" . 'swiper))

;; Org mode
  (use-package org
  :config
  (add-hook 'org-mode-hook 'org-indent-mode)
  (add-hook 'org-mode-hook
            #'(lambda ()
               (visual-line-mode 1))))

(use-package org-indent
  :diminish org-indent-mode)

(use-package htmlize
  :ensure t)
	
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
	
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init
  (which-key-mode))
  
(use-package magit
  :ensure t)
  
(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode)
  
(use-package projectile
  :ensure t
  :config
  (projectile-mode t)
  (define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)
  (setq projectile-enable-caching t)
  (setq projectile-require-project-root t)
  ;;(setq projectile-ensure-project nil)
  (setq projectile-completion-system 'ivy)
  (setq projectile-dynamic-mode-line nil))
  
(use-package auto-package-update
  :defer nil
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))
  
;; Diminish packages
(use-package diminish
  :ensure t)

;; Duplicate current line or marked set
(use-package duplicate-thing
:ensure t
:defer nil
:config
(global-set-key (kbd "C-d") 'duplicate-thing))

;; Clock
;;(setq display-time-24hr-format t)
;;(setq display-time-format "%H:%M - %d %B %Y")
;;(display-time-mode 1)
  
;; ------------------------------------- Prog modes area ---------------------------------------------- ;;
  
;; C++
(use-package c++-mode
  :commands (c++-mode)
  :mode ("\\.h\\'" . c++-mode))
  
 (use-package company-c-headers
  :defer nil
  :ensure t)

(use-package company-irony
  :defer nil
  :ensure t
  :config
  (setq company-backends '((company-yasnippet :separate
							company-c-headers
                            company-dabbrev-code
                            company-irony))))
(use-package irony
  :defer nil
  :ensure t
  :config
  :hook
  ((c++-mode c-mode) . irony-mode)
  ('irony-mode-hook) . 'irony-cdb-autosetup-compile-options)
 
  
;; JAVA 
(use-package meghanada
  :ensure t
  :defer nil
  :config
  (add-hook 'java-mode-hook
            (lambda ()
              (meghanada-mode t)))
  (setq meghanada-java-path "java")
  (setq meghanada-maven-path "mvn"))
  

;; Web development Area
  (use-package js2-mode
  :commands (js2-mode)
  :mode ("\\.js\\'" . js2-mode))

(use-package typescript-mode
  :commands (typescript-mode)
  :mode ("\\.ts\\'" . typescript-mode))

(use-package dotenv-mode
  :commands (dotenv-mode)
  :mode ("\\.env\\'" . dotenv-mode))


;; ------ WEB MODE --------
(use-package web-mode
  :config
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-enable-current-element-highlight t)
  (setq web-mode-enable-current-column-highlight t)
  :commands (web-mode)
  :mode (("\\.html?\\'" . web-mode)
		 ("\\.tsx\\'" . web-mode)))
		 

(use-package emmet-mode
:ensure t
:config
(define-key emmet-mode-keymap (kbd "<tab>") 'emmet-expand-line)
:hook
((web-mode) . emmet-mode))

(require 'company-web-html)
(add-hook 'web-mode-hook
          (lambda ()
            (setq-local company-backends
                        '((company-web-html :separate
							company-yasnippet
                           company-dabbrev-code
                           company-keywords)
                          company-capf))))

;; Json-mode
(use-package json-mode
  :commands (json-mode)
  :mode ("\\.json?\\'" . json-mode))

;; CSharp
(use-package csharp-mode
  :commands (csharp-mode)
  :mode ("\\.cs\\'" . csharp-mode))
  
;; Css
(use-package css-mode
  :commands (css-mode)
  :mode ("\\.css\\'" . css-mode))

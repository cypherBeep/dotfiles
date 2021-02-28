;; Credentials
(setq user-full-name    "Sanad"
      user-mail-address "sanaddilipkadu@gmail.com")

(when (equal "" (shell-command-to-string "git config user.name"))
  (shell-command "git config --global user.name \"Sanad Kadu\"")
  (shell-command "git config --global user.email \"500068114@stu.upes.ac.in\""))

;; A little cleaner backup managment.
;; New location for backups.
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))

;; Silently delete execess backup versions
(setq delete-old-versions t)

;; Start emacs in full screen.
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)

;; Only keep the last 200 backups of a file.
(setq kept-old-versions 200)

;; Even version controlled files get to be backed up.
(setq vc-make-backup-files t)

;; Use version numbers for backup files.
(setq version-control t)

;; Global Variables
(defvar efs/default-font-size 180)
(defvar efs/default-variable-font-size 180)

(set-face-attribute 'default nil :font "Fira Code Retina" :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height efs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height efs/default-variable-font-size :weight 'regular)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Package Managment
(require 'package)

;; Internet repositories for new packages.
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.org/packages/")))

;; Update local list of available packages
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Configuration tool use-package is a macro/interface that
;; manages our packages and the way they interact.
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; Although use-package is not a package manager we can make it so,
(setq use-package-always-ensure t)

;; Don't ask me if I want to kill a buffer with a live process attached to it;
;; just kill it please.
(setq kill-buffer-query-functions
  (remq 'process-kill-buffer-query-function
        kill-buffer-query-functions))

;; Sync with systems $PATH
(use-package exec-path-from-shell
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; Using "diminish" to avoid seeing some packages in modeline
(use-package diminish)

;; Changing keys for my mac.
(setq
   ns-command-modifier 'control
   ns-option-modifier 'meta
   ns-control-modifier 'super
   ns-function-modifier 'hyper)

;; Startup
(setq inhibit-startup-message t)

;; Fancy Lambdas
(global-prettify-symbols-mode t)

(defun display-startup-echo-area-message ()
  "The message that is shown after ‘user-init-file’ is loaded."
  (message
      (concat "Welcome "      user-full-name
              "! Emacs "      emacs-version
              "; Org-mode "   org-version
              "; System "     (symbol-name system-type)
              "/"             (system-name)
              "; Time "       (emacs-init-time))))

(setq frame-title-format '("" "%b - Realize the fantasy"))

;; The basics
(setq visible-bell 1)
(tool-bar-mode   -1)  ;; No large icons please
(scroll-bar-mode -1)  ;; No visual indicator please
(menu-bar-mode   -1)  ;; The Mac OS top pane has menu options
(set-fringe-mode 10)  ;; Give some breathing room
(blink-cursor-mode 1)
(electric-pair-mode 1)
(setq show-paren-delay  0)
(setq show-paren-style 'mixed)
(show-paren-mode)
;; TODO: Mode this to another section
(setq-default fill-column 80)

(use-package rainbow-delimiters
  :disabled
  :hook ((org-mode prog-mode text-mode) . rainbow-delimiters-mode))

;; Window containing the cursor is bigger
(use-package golden-ratio
  :disabled
  :diminish golden-ratio-mode
  :init (golden-ratio-mode 1))

(setq-default fill-column 80          ;; Let's avoid going over 80 columns
              truncate-lines nil      ;; I never want to scroll horizontally
              indent-tabs-mode nil)   ;; Use spaces instead of tabs

(add-hook 'emacs-lisp-mode-hook #'check-parens)

(use-package doom-themes :defer t)
(setf custom-safe-themes t)
(load-theme 'doom-one t)

(setq display-line-numbers-width-start t)
(global-display-line-numbers-mode      t)

;; Highlight line with cursor
(global-hl-line-mode t)

;; Beacon for the cursor
(use-package beacon
  :diminish
  :config (setq beacon-color "#666600")
 (defun er-kill-other-buffers ()
  "Kill all buffers but the current one.
Don't mess with special buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (unless (or (eql buffer (current-buffer)) (not (buffer-file-name buffer)))
      (kill-buffer buffer))))
 :hook   ((org-mode text-mode) . beacon-mode))

;; Color just the keywords of a language.
(use-package color-identifiers-mode
  :config (global-color-identifiers-mode))

;; Kill all buffer but current one.
(defun er-kill-other-buffers ()
  "Kill all buffers but the current one.
Don't mess with special buffers."
  (interactive)
  (dolist (buffer (buffer-list))
    (unless (or (eql buffer (current-buffer)) (not (buffer-file-name buffer)))
      (kill-buffer buffer))))

(global-set-key (kbd "C-c K") #'er-kill-other-buffers)


;; change all prompts to y or n
(fset 'yes-or-no-p 'y-or-n-p)

(use-package helpful)

(global-set-key (kbd "C-h f") #'helpful-callable)
(global-set-key (kbd "C-h v") #'helpful-variable)
(global-set-key (kbd "C-h k") #'helpful-key)

;; Quickly open emacs init.el
(defun sk/visit-emacs-config ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "C-c e") 'sk/visit-emacs-config)



;; Essential packages only.
;; ;; Download Evil
;; (unless (package-installed-p 'evil)
;;   (package-install 'evil))

;; ;; Enable Evil
;; (require 'evil)
;; (evil-mode 1)

;; Org-mode for everyting life.
(use-package org
  :ensure org-plus-contrib
  :config (require 'ox-extra) ;; adds the latest contribs to the org-mode repo
  (ox-extras-activate '(ignore-headlines))) ;; ignore headlines.

;; Replace the content marker, “⋯”, with a nice unicode arrow.
(setq org-ellipsis " ⤵")

;; Fold all source blocks on startup.
(setq org-hide-block-startup t)

;; Lists may be labelled with letters.
(setq org-list-allow-alphabetical t)

;; Avoid accidentally editing folded regions, say by adding text after an Org “⋯”.
(setq org-catch-invisible-edits 'show)

;; Tab should do indent in code blocks
(setq org-src-tab-acts-natively t)

;; Give quote and verse blocks a nice look.
(setq org-fontify-quote-and-verse-blocks t)

;; Pressing ENTER on a link should follow it.
(setq org-return-follows-link t)

;; Using org speed commands
(setq org-use-speed-commands t)

;; Making org-mode the default
(setq initial-major-mode 'org-mode)

;; Better bullets than fucking stars.
;; use org-bullets-mode for utf8 symbols as org bullets
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; Increase the size of various headings
(set-face-attribute 'org-document-title nil :font "Cantarell" :weight 'bold :height 1.3)
(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

;; Modeline as spaceline
(use-package spaceline
  :custom (spaceline-buffer-encoding-abbrev-p nil)
          ;; Use an arrow to seperate modeline information
          (powerline-default-separator 'arrow)
          ;; Show “line-number : column-number” in modeline.
          (spaceline-line-column-p t)
          ;; Use two colours to indicate whether a buffer is modified or not.
          (spaceline-highlight-face-func 'spaceline-highlight-face-modified)
  :config (custom-set-faces '(spaceline-unmodified ((t (:foreground "black" :background "gold")))))
          (custom-set-faces '(spaceline-modified   ((t (:foreground "black" :background "cyan")))))
          (require 'spaceline-config)
          (spaceline-helm-mode)
          (spaceline-info-mode)
          (spaceline-emacs-theme))

;; Another essential package other than org-mode is Magit.
(use-package magit
  :bind ("C-M-;" . 'magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package eterm-256color
  :hook (term-mode . eterm-256color-mode))

(use-package vterm
  :load-path "/Users/sanadkadu/emacs-libvterm"
  :commands vterm
  :config
  (setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
  (setq vterm-max-scrollback 10000)) 

;; Complete-anything-mode or company for short , for auto-completion
(use-package company
  :diminish
  :config
  (global-company-mode 1)
  (setq ;; Only 2 letters required for completion to activate.
   company-minimum-prefix-length 2

   ;; Search other buffers for compleition candidates
   company-dabbrev-other-buffers t
   company-dabbrev-code-other-buffers t

   ;; Show candidates according to importance, then case, then in-buffer frequency
   company-transformers '(company-sort-by-backend-importance
                          company-sort-prefer-same-case-prefix
                          company-sort-by-occurrence)

   ;; Flushright any annotations for a compleition;
   ;; e.g., the description of what a snippet template word expands into.
   company-tooltip-align-annotations t

   ;; Allow (lengthy) numbers to be eligible for completion.
   company-complete-number t

   ;; M-⟪num⟫ to select an option according to its number.
   company-show-numbers t

   ;; Show 10 items in a tooltip; scrollbar otherwise or C-s ^_^
   company-tooltip-limit 10

   ;; Edge of the completion list cycles around.
   company-selection-wrap-around t

   ;; Do not downcase completions by default.
   company-dabbrev-downcase nil

   ;; Even if I write something with the ‘wrong’ case,
   ;; provide the ‘correct’ casing.
   company-dabbrev-ignore-case nil

   ;; Immediately activate completion.
   company-idle-delay 0)

  ;; Use C-/ to manually start company mode at point. C-/ is used by undo-tree.
  ;; Override all minor modes that use C-/; bind-key* is discussed below.
  (bind-key* "C-/" #'company-manual-begin)

  ;; Bindings when the company list is active.
  :bind (:map company-active-map
              ("C-d" . company-show-doc-buffer) ;; In new temp buffer
              ("<tab>" . company-complete-selection)
              ;; Use C-n,p for navigation in addition to M-n,p
              ("C-n" . (lambda () (interactive) (company-complete-common-or-cycle 1)))
              ("C-p" . (lambda () (interactive) (company-complete-common-or-cycle -1)))))

;; If I forget the binding or to know more bindings.
(use-package which-key
  :diminish
  :config (which-key-mode)
          (which-key-setup-side-window-bottom)
          (setq which-key-idle-delay 0.05))

;; Helm - Completion & Narrowing Framework
(use-package helm
 :diminish
 :init (helm-mode t)
 :bind (("M-x"     . helm-M-x)
        ("C-x C-f" . helm-find-files)
        ("C-x b"   . helm-mini)     ;; See buffers & recent files; more useful.
        ("C-x r b" . helm-filtered-bookmarks)
        ("C-x C-r" . helm-recentf)  ;; Search for recently edited files
        ("C-c i"   . helm-imenu)
        ("C-h a"   . helm-apropos)
        ;; Look at what was cut recently & paste it in.
        ("M-y" . helm-show-kill-ring)

        :map helm-map
        ;; We can list ‘actions’ on the currently selected item by C-z.
        ("C-z" . helm-select-action)
        ;; Let's keep tab-completetion anyhow.
        ("TAB"   . helm-execute-persistent-action)
        ("<tab>" . helm-execute-persistent-action)))

;; Let helm manage all them buffers and make bookmarks by C-x r b
(setq helm-mini-default-sources '(helm-source-buffers-list
                                    helm-source-recentf
                                    helm-source-bookmarks
                                    helm-source-bookmark-set
                                    helm-source-buffer-not-found))


(use-package helm-swoop
  :bind  (("C-s"     . 'helm-swoop)           ;; search current buffer
          ("C-M-s"   . 'helm-multi-swoop-all) ;; Search all buffer
          ;; Go back to last position where ‘helm-swoop’ was called
          ("C-S-s" . 'helm-swoop-back-to-last-point)
          ;; swoop doesn't work with PDFs, use Emacs' default isearch instead.
          ; :map pdf-view-mode-map ("C-s" . isearch-forward)
          )
  :custom (helm-swoop-speed-or-color nil "Give up colour for speed.")
  (helm-swoop-split-with-multiple-windows nil "Do not split window inside the current window."))

;; Avoid compilation buffer.
(setq compilation-scroll-output t)

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; Organizing my life with org-mode ;;
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Location of my todos/notes file
(setq org-default-notes-file "~/Sync/todo.org")

;; Cannot mark an item DONE if it has a  TODO child.
;; Conversely, all children must be DONE in-order for a parent to be DONE.
(setq org-enforce-todo-dependencies t)

;; At a later time, a time of reflection, we go to our tasks list and actually schedule time
;;to get them done by C-c C-s, org-schedule, then pick a date by entering a number in the form
;; +𝓃 to mean that task is due 𝓃 days from now.

;; Add a note whenever a task's deadline or scheduled date is changed.
(setq org-log-redeadline 'time)
(setq org-log-reschedule 'time)

;; Press C-c a a to see the scheduled tasks for this week
;; C-c C-s to re-schedule the task under the cursor and r to refresh the agenda.
(define-key global-map "\C-ca" 'org-agenda)
;; Show the next 𝓃 days schedule ⇐ C-u 𝓃 C-c a a.

;; Default agenda files
(setq org-agenda-files (list org-default-notes-file))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; After having seen our tasks for the week, we press d to enter daily view for the current day.	    ;;
;; Now we decide whether the items for today are A: of high urgency & important;			    ;;
;; B: of moderate urgency & importance;									    ;;
;; C: Pretty much optional, or very quick or fun to do.							    ;;
;; 													    ;;
;; A tasks should be both important and urgently done on the day they were scheduled.			    ;;
;; Such tasks should be relatively rare!								    ;;
;; If you have too many, you're anxious about priorities and rendering priorities useless.		    ;;
;; C tasks can always be scheduled for another day without much worry.					    ;;
;; Act! If the thought of rescheduling causes you to worry, upgrade it to a B or A.			    ;;
;; As such, most tasks will generally be priority B: Tasks that need to be done, but the exact day isn't    ;;
;; as critical as with an A task. These are the “bread and butter” tasks that make up your day to day life. ;;
;; On a task item, or any org-heading, press , then one of A/B/C to set its priority. Then r to refresh.    ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; More intense the color more important the todo.
(setq org-lowest-priority ?D)
(setq org-priority-faces
'((?A :foreground "red" :weight bold)
  (?B . "orange")
  (?C . "yellow")
  (?D . "green")))

;; Workflow states
(setq org-todo-keywords
      '((sequence "TODO" "ON-HOLD" "URGENT" "|" "DONE")))

;; Since DONE is a terminal state, it has no exit-action.
;; Let's explicitly indicate time should be noted.
(setq org-log-done 'time)

(setq org-todo-keyword-faces
      '(("TODO"      :foreground "orange"       :weight bold)
        ("ON-HOLD"   :foreground "blue"         :weight bold)
        ("URGENT"    :foreground "red"          :weight bold)
        ("DONE"      :foreground "forest green" :weight bold)))

;; Show habits for every day in the agenda
(setq org-habit-show-habits t)
(setq org-habit-show-habits-only-for-today nil)

;; Latex
(use-package tex
  :ensure auctex
  :bind (:map TeX-mode-map
              ("C-c C-o" . TeX-recenter-output-buffer)
              ("C-c C-l" . TeX-next-error)
              ("M-[" . outline-previous-heading)
              ("M-]" . outline-next-heading))
  :hook (LaTeX-mode . reftex-mode)
  :preface
  (defun my/switch-to-help-window (&optional ARG REPARSE)
    "Switches to the *TeX Help* buffer after compilation."
    (other-window 1))
  :custom
  (TeX-auto-save t)
  (TeX-byte-compile t)
  (TeX-clean-confirm nil)
  (TeX-master 'dwim)
  (TeX-parse-self t)
  (TeX-PDF-mode t)
  (TeX-source-correlate-mode t)
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  :config
  (advice-add 'TeX-next-error :after #'my/switch-to-help-window)
  (advice-add 'TeX-recenter-output-buffer :after #'my/switch-to-help-window)
  ;; the ":hook" doesn't work for this one... don't ask me why.
  (add-hook 'TeX-after-compilation-finished-functions 'TeX-revert-document-buffer))

;; Java setup according to writequilt.org
(defun my/point-in-defun-declaration-p ()
  (let ((bod (save-excursion (c-beginning-of-defun)
                             (point))))
    (<= bod
        (point)
        (save-excursion (goto-char bod)
                        (re-search-forward "{")
                        (point)))))

(defun my/is-string-concatenation-p ()
  "Returns true if the previous line is a string concatenation"
  (save-excursion
    (let ((start (point)))
      (forward-line -1)
      (if (re-search-forward " \\\+$" start t) t nil))))

(defun my/inside-java-lambda-p ()
  "Returns true if point is the first statement inside of a lambda"
  (save-excursion
    (c-beginning-of-statement-1)
    (let ((start (point)))
      (forward-line -1)
      (if (search-forward " -> {" start t) t nil))))

(defun my/trailing-paren-p ()
  "Returns true if point is a training paren and semicolon"
  (save-excursion
    (end-of-line)
    (let ((endpoint (point)))
      (beginning-of-line)
      (if (re-search-forward "[ ]*);$" endpoint t) t nil))))

(defun my/prev-line-call-with-no-args-p ()
  "Return true if the previous line is a function call with no arguments"
  (save-excursion
    (let ((start (point)))
      (forward-line -1)
      (if (re-search-forward ".($" start t) t nil))))

(defun my/arglist-cont-nonempty-indentation (arg)
  (if (my/inside-java-lambda-p)
      '+
    (if (my/is-string-concatenation-p)
        16 ;; TODO don't hard-code
      (unless (my/point-in-defun-declaration-p) '++))))

(defun my/statement-block-intro (arg)
  (if (and (c-at-statement-start-p) (my/inside-java-lambda-p)) 0 '+))

(defun my/block-close (arg)
  (if (my/inside-java-lambda-p) '- 0))

(defun my/arglist-close (arg) (if (my/trailing-paren-p) 0 '--))

(defun my/arglist-intro (arg)
  (if (my/prev-line-call-with-no-args-p) '++ 0))

(defconst intellij-java-style
  '((c-basic-offset . 4)
    (c-comment-only-line-offset . (0 . 0))
    ;; the following preserves Javadoc starter lines
    (c-offsets-alist
     .
     ((inline-open . 0)
      (topmost-intro-cont    . +)
      (statement-block-intro . my/statement-block-intro)
      (block-close           . my/block-close)
      (knr-argdecl-intro     . +)
      (substatement-open     . +)
      (substatement-label    . +)
      (case-label            . +)
      (label                 . +)
      (statement-case-open   . +)
      (statement-cont        . +)
      (arglist-intro         . my/arglist-intro)
      (arglist-cont-nonempty . (my/arglist-cont-nonempty-indentation c-lineup-arglist))
      (arglist-close         . my/arglist-close)
      (inexpr-class          . 0)
      (access-label          . 0)
      (inher-intro           . ++)
      (inher-cont            . ++)
      (brace-list-intro      . +)
      (func-decl-cont        . ++))))
  "Elasticsearch's Intellij Java Programming Style")

(c-add-style "intellij" intellij-java-style)
(customize-set-variable 'c-default-style
                        '((java-mode . "intellij")
                          (awk-mode . "awk")
                          (other . "gnu")))

(defun setup-java ()
  (interactive)
  (define-key java-mode-map (kbd "M-,") 'pop-tag-mark)
  (define-key java-mode-map (kbd "C-c M-i") 'java-imports-add-import)
  (c-set-style "intellij" t)
  (subword-mode 1)
  (toggle-truncate-lines 1)
  ;; Generic java stuff things
  (setq-local fci-rule-column 99)
  (setq-local fill-column 140)
  ;; remove the stupid company-eclim backend
  (when (boundp 'company-backends)
    (delete 'company-eclim company-backends)))

(add-hook 'java-mode-hook #'setup-java)

;; Javascript
(setq-default js-indent-level 2)
(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (js2-imenu-extras-setup)
  (setq-default js-auto-indent-flag nil))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-completion-style 'emacs)
 '(package-selected-packages
   '(oauth2 simple-httpd auctex helm-swoop spaceline doom-themes org-bullets company shell-pop magit org-plus-contrib exec-path-from-shell helm which-key diminish use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(spaceline-modified ((t (:foreground "black" :background "cyan"))))
 '(spaceline-unmodified ((t (:foreground "black" :background "gold")))))

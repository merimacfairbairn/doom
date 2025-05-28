;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "Open Sans" :size 16))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)
(setq scroll-margin 10)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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


;; START OF MY CONFIG

;; Map C-c to ESC in insert and visual
(after! evil
  ;; Fix ESC delay in terminals
  (setq evil-escape-delay 0.1)

  ;; C-c as ESC replacement
  (map! :map evil-insert-state-map "C-c" #'evil-normal-state
        :map evil-visual-state-map "C-c" #'evil-normal-state))

;; Different Heading sizes
(setq org-fontify-whole-heading-line t)  ; Enable if not already set

;; Set different font sizes for headings
(custom-set-faces!
  '(org-level-1 :height 1.4 :weight bold :inherit outline-1)
  '(org-level-2 :height 1.3 :weight bold :inherit outline-2)
  '(org-level-3 :height 1.2 :weight bold :inherit outline-3)
  '(org-level-4 :height 1.1 :weight bold :inherit outline-4))

;; Hide emphasis markers
(use-package org-appear
  :commands (org-appear-mode)
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-hide-emphasis-markers t)
  (setq org-appear-autoemphasis t
        org-appear-autolinks    t
        org-appear-autosubmarkers t))

(setq org-log-done                           t
      org-auto-align-tags                t
      org-tags-column                    -80
      org-fold-catch-invisible-edits     'show-and-error
      org-special-ctrl-a/e               t
      org-insert-heading-respect-content t)

;; wrap for orgmode
(add-hook 'org-mode-hook 'visual-line-mode)

;; Org Agenda config
(setq org-agenda-span 7)
(setq org-agenda-start-on-weekday 1)

;; org-roam setup
(use-package! org-roam
  :after org
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (file-truename "~/org/roam/"))
  (org-roam-completion-everywhere t)
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?"
      :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                         "#+title: ${title}\n#+date: %U\n")
      :unnarrowed t)))

  (setq org-roam-dailies-directory "daily/")
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry
           "* %<%I:%M %p>: %?"
           :if-new (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n"))))
  :config
  (org-roam-db-autosync-mode))

;; Org-roam UI
(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(map! :leader :prefix "n r" :desc "Org-roam UI graph" "g" #'org-roam-ui-open)

(use-package org-superstar
  :config
  (setq org-superstar-leading-bullet " ")
  (setq org-superstar-special-todo-items t) ;; Makes TODO header bullets into boxes
  (setq org-superstar-todo-bullet-alist '(("TODO"  . 9744)
					  ("DONE"  . 9745)))
  :hook (org-mode . org-superstar-mode))

(after! evil-collection
  (evil-collection-init '(calendar)))

;; Enable org-mode allerts
(use-package org-alert
  :after org
  :config
  (setq alert-default-style 'libnotify
        org-alert-interval 300
        org-alert-notify-cutoff 10)
  (org-alert-enable))

;; Add s and S back
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)

(map! :map evil-normal-state-map
      "s" #'evil-substitute
      "S" #'evil-change-whole-line)

;; Set different pitches for orgmode
(use-package! mixed-pitch
  :hook (org-mode . mixed-pitch-mode)
  :config
  ;; Ensure certain faces remain fixed-pitch
  (setq mixed-pitch-fixed-pitch-faces
        '(org-code
          org-block
          org-table
          org-verbatim
          org-meta-line
          org-checkbox
          line-number
          line-number-current-line))
  ;; Optionally adjust the height of variable-pitch text
  (setq mixed-pitch-set-height t))

(after! org
  (setq org-capture-templates
        (cl-remove-if (lambda (template)
                        (string= (car template) "t"))
                      org-capture-templates))

  (add-to-list 'org-capture-templates
               '("m" "Meeting Notes" entry
                 (file+headline "~/org/meetings.org" "Meetings")
                 "* MEETING with %^{Person} :MEETING:\n%?"))
  (add-to-list 'org-capture-templates
               '("t" "Personal Todo" entry
                 (file+headline "~/org/todo.org" "Inbox")
                 "* TODO %?\n"))
  (setq org-ellipsis " ▼ "))

(map! :map dired-mode-map
      :n "%" #'dired-create-empty-file)

(use-package! tree-sitter
  :hook (prog-mode . turn-on-tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (setq tree-sitter-debug-jump-buttons t
        tree-sitter-debug-highlight-jump-region t))

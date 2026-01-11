(use-package! tree-sitter
  :hook (prog-mode . turn-on-tree-sitter-mode)
  :hook (tree-sitter-after-on . tree-sitter-hl-mode)
  :config
  (require 'tree-sitter-langs)
  (global-tree-sitter-mode)
  (setq tree-sitter-debug-jump-buttons t
        tree-sitter-debug-highlight-jump-region t))

(after! orderless
  (setq orderless-matching-styles '(orderless-literal
                                    orderless-flex
                                    orderless-regexp
                                    orderless-initialism)))

(setq doom-theme 'doom-gruvbox)

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14)
      doom-variable-pitch-font (font-spec :family "Open Sans" :size 16))

(setq display-line-numbers-type 'relative)
(setq scroll-margin 10)

(setq org-directory "~/org/")

;; Agenda calendar
(setq org-agenda-span 7)
(setq org-agenda-start-on-weekday 1)

(defun my/org-capture-student-location ()
  "Return (buffer . point) for capture in selected student file."
  (let ((file (expand-file-name
               (completing-read "Student: "
                                (directory-files "~/org/sessions" nil "\\.org$"))
               "~/org/sessions")))
    ;; Open the file if not already, go to end, return (buffer . point)
    (with-current-buffer (find-file-noselect file)
      (goto-char (point-max))
      (cons (current-buffer) (point)))))

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

(add-to-list 'org-capture-templates
  '("s" "Session note"
    entry
    (file+headline "~/org/sessions/inbox.org" "Sessions")
    "* %^{Session Date}t %^g\n\n** Things to work on\n\n - %^{Anything to work on}\n   + %?\n\n** Warm up\n - %^{Warm up}\n\n** Combinations\n - %^{Combos}\n\n** - Drills\n %^{Drills}\n\n** Other\n - %^{Other}\n"
    :prepend t))

    (setq org-refile-use-outline-path 'file)
    (setq org-outline-path-complete-in-steps nil)

  (setq org-ellipsis " ▼ "))

(after! org
  (add-to-list 'org-agenda-files (expand-file-name "~/org/sessions/") t)
  (setq org-agenda-files
        (append org-agenda-files
                (directory-files-recursively "~/org/sessions/" "\\.org$")))

  ;; refile targets can include those files
  (setq org-refile-targets
        '((org-agenda-files :maxlevel . 3)))

  ;; nicer path completion
  (setq org-outline-path-complete-in-steps nil
        org-refile-use-outline-path 'file))

(use-package org-alert
  :after org
  :config
  (setq alert-default-style 'libnotify
        org-alert-interval 300
        org-alert-notify-cutoff 10)
  (org-alert-enable))

(setq org-fontify-whole-heading-line t)
(custom-set-faces!
  '(org-level-1 :height 1.4 :weight bold :inherit outline-1)
  '(org-level-2 :height 1.3 :weight bold :inherit outline-2)
  '(org-level-3 :height 1.2 :weight bold :inherit outline-3)
  '(org-level-4 :height 1.1 :weight bold :inherit outline-4))

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

;; wrap for orgmode
(add-hook 'org-mode-hook 'visual-line-mode)

;; Hide emphasis markers
(use-package org-appear
  :commands (org-appear-mode)
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-hide-emphasis-markers t)
  (setq org-appear-autoemphasis t
        org-appear-autolinks    t
        org-appear-autosubmarkers t))

(setq org-log-done                       t
      org-auto-align-tags                t
      org-tags-column                    -80
      org-fold-catch-invisible-edits     'show-and-error
      org-special-ctrl-a/e               t
      org-insert-heading-respect-content t)

(use-package org-superstar
  :config
  (setq org-superstar-leading-bullet " ")
  (setq org-superstar-special-todo-items t) ;; Makes TODO header bullets into boxes
  (setq org-superstar-todo-bullet-alist '(("TODO"  . 9744)
					  ("DONE"  . 9745)))
  :hook (org-mode . org-superstar-mode))

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

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

;; Map C-c to ESC in insert and visual
(after! evil
  ;; Fix ESC delay in terminals
  (setq evil-escape-delay 0.1)
  ;; C-c as ESC replacement
  (map! :map evil-insert-state-map "C-c" #'evil-normal-state
        :map evil-visual-state-map "C-c" #'evil-normal-state))

;; Evil bindings for calendar
(after! evil-collection
  (evil-collection-init '(calendar)))

;; Add s and S back
(remove-hook 'doom-first-input-hook #'evil-snipe-mode)
(map! :map evil-normal-state-map
      "s" #'evil-substitute
      "S" #'evil-change-whole-line)

;; % to create new file like in Vim
(map! :map dired-mode-map
      :n "%" #'dired-create-empty-file)

;; Org roam web UI
(map! :leader :prefix "n r" :desc "Org-roam UI graph" "g" #'org-roam-ui-open)

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Liu Ying"
      user-mail-address "liuying127@hisilicon.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-monokai-classic)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; A large gc-cons-threshold may cause freezing and stuttering during long-term interactive use.
;; If you experience freezing, decrease this amount, if you experience stuttering, increase this amount.

(winum-mode t)
(map! :leader
      "0" 'winum-select-window-0-or-10
      "1" 'winum-select-window-1
      "2" 'winum-select-window-2
      "3" 'winum-select-window-3
      "4" 'winum-select-window-4
      "5" 'winum-select-window-5
      "6" 'winum-select-window-6
      "8" 'split-window-below
      "9" 'split-window-right
      )
(map! (:leader (:desc "open filetree" :g "0" #'treemacs-select-window)) )

(defconst *sys/win32*
  (eq system-type 'windows-nt)
  "Are we running on a WinTel system?")

(defconst *sys/linux*
  (eq system-type 'gnu/linux)
  "Are we running on a GNU/Linux system?")

(defconst *sys/mac*
  (eq system-type 'darwin)
  "Are we running on a Mac system?")

(defconst python-p
  (or (executable-find "python3")
      (and (executable-find "python")
           (> (length (shell-command-to-string "python --version | grep 'Python 3'")) 0)))
  "Do we have python3?")

(defconst pip-p
  (or (executable-find "pip3")
      (and (executable-find "pip")
           (> (length (shell-command-to-string "pip --version | grep 'python 3'")) 0)))
  "Do we have pip3?")

(defconst clangd-p
  (or (executable-find "clangd")  ;; usually
      (executable-find "/usr/local/opt/llvm/bin/clangd"))  ;; macOS
  "Do we have clangd?")

(defconst eaf-env-p
  (and *sys/linux* (display-graphic-p) python-p pip-p
       (not (equal (shell-command-to-string "pip freeze | grep '^PyQt\\|PyQtWebEngine'") "")))
  "Do we have EAF environment setup?")

(when *sys/win32*
  (after! org-pomodoro
    :config
    (add-hook 'org-pomodoro-finished-hook
              (lambda ()
                (org-notify "A pomodoro is finished, take a break !!!")
                ))
    (add-hook 'org-pomodoro-short-break-finished-hook
              (lambda ()
                (org-notify "A short break done, ready a new pomodoro !!!")
                ))
    (add-hook 'org-pomodoro-long-break-finished-hook
              (lambda ()
                (org-notify "A long break done, ready a new pomodoro !!!")
                ))
    ))

;; Diminish, a feature that removes certain minor modes from mode-line.
;; (use-package diminish)

;; ;; Unbind unneeded keys
;; (global-set-key (kbd "C-z") nil)
;; (global-set-key (kbd "M-z") nil)
;; (global-set-key (kbd "M-m") nil)
;; (global-set-key (kbd "C-x C-z") nil)
;; (global-set-key (kbd "M-/") nil)
;; ;; Truncate lines
;; (global-set-key (kbd "C-x C-l") #'toggle-truncate-lines)
;; ;; Adjust font size like web browsers
;; (global-set-key (kbd "C-=") #'text-scale-increase)
;; (global-set-key (kbd "C-+") #'text-scale-increase)
;; (global-set-key (kbd "C--") #'text-scale-decrease)
;; ;; Move up/down paragraph
;; (global-set-key (kbd "M-n") #'forward-paragraph)
;; (global-set-key (kbd "M-p") #'backward-paragraph)

(use-package color-rg
  :load-path (lambda () (expand-file-name "site-elisp/color-rg" user-emacs-directory))
  :if (executable-find "rg")
  :bind ("C-M-s" . color-rg-search-input))


(defun save-all-buffers ()
  "Instead of `save-buffer', save all opened buffers by calling `save-some-buffers' with ARG t."
  (interactive)
  (save-some-buffers t))
(global-set-key (kbd "C-x C-s") nil)
(global-set-key (kbd "C-x C-s") #'save-all-buffers)

(use-package popup-kill-ring
  :bind ("M-y" . popup-kill-ring))

(use-package discover-my-major
  :bind ("C-h C-m" . discover-my-major))

;; (use-package ace-window
;;   :bind ("C-x C-o" . ace-window))

(use-package aweshell
  :load-path (lambda () (expand-file-name "site-elisp/aweshell" user-emacs-directory))
  :commands (aweshell-new aweshell-dedicated-open)
  :bind
  (("M-#" . aweshell-dedicated-open)
   (:map eshell-mode-map ("M-#" . aweshell-dedicated-close))))

(use-package shell-here
  :bind ("M-~" . shell-here)
  :config
  (when *sys/linux*
    ;; (setq explicit-shell-file-name "/bin/bash")
    ))

(use-package multi-term
  :load-path (lambda () (expand-file-name "site-elisp/multi-term" user-emacs-directory))
  :commands (multi-term)
  :bind
  (("M-$" . multi-term)
   (:map dired-mode-map ("M-$" . multi-term)))
  :custom
  ;; (multi-term-program (executable-find "bash"))
  (term-bind-key-alist
   '(("C-c C-c" . term-interrupt-subjob)
     ("C-c C-e" . term-send-esc)
     ("C-p" . previous-line)
     ("C-n" . next-line)
     ("C-m" . term-send-return)
     ("C-y" . term-paste)
     ("M-f" . term-send-forward-word)
     ("M-b" . term-send-backward-word)
     ("M-o" . term-send-backspace)
     ("M-p" . term-send-up)
     ("M-n" . term-send-down)
     ("M-M" . term-send-forward-kill-word)
     ("M-N" . term-send-backward-kill-word)
     ("<C-backspace>" . term-send-backward-kill-word)
     ("<M-backspace>" . term-send-backward-kill-word)
     ("C-r" . term-send-reverse-search-history)
     ("M-d" . term-send-delete-word)
     ("M-," . term-send-raw)
     ("M-." . comint-dynamic-complete))))

(use-package term-keys
  :if (not (display-graphic-p))
  :config (term-keys-mode t))

(use-package ibuffer
  :ensure nil
  :bind ("C-x C-b" . ibuffer)
  :init
  (use-package ibuffer-vc
    :commands (ibuffer-vc-set-filter-groups-by-vc-root)
    :custom
    (ibuffer-vc-skip-if-remote 'nil))
  :custom
  (ibuffer-formats
   '((mark modified read-only locked " "
           (name 35 35 :left :elide)
           " "
           (size 9 -1 :right)
           " "
           (mode 16 16 :left :elide)
           " " filename-and-process)
     (mark " "
           (name 16 -1)
           " " filename))))

(unless *sys/win32*
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (set-language-environment "UTF-8")
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8))
;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(when (display-graphic-p)
  (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))

;; Replace selection on insert
(delete-selection-mode 1)

;; Map Alt key to Meta
(setq x-alt-keysym 'meta)

;; When buffer is closed, saves the cursor location
(save-place-mode 1)

;; Set history-length longer
(setq-default history-length 500)

;; Move the backup fies to user-emacs-directory/.backup
(setq backup-directory-alist `(("." . ,(expand-file-name ".backup" user-emacs-directory))))

;; Ask before killing emacs
(setq confirm-kill-emacs 'y-or-n-p)

;; Turn Off Cursor Alarms
(setq ring-bell-function 'ignore)

;; Show Keystrokes in Progress Instantly
(setq echo-keystrokes 0.1)

;; Don't Lock Files
(setq-default create-lockfiles nil)

;; Better Compilation
(setq-default compilation-always-kill t) ; kill compilation process before starting another

(setq-default compilation-ask-about-save nil) ; save all buffers on `compile'

(setq-default compilation-scroll-output t)

;; ad-handle-definition warnings are generated when functions are redefined with `defadvice',
;; they are not helpful.
(setq ad-redefinition-action 'accept)

;; Move Custom-Set-Variables to Different File
(setq custom-file (concat user-emacs-directory "custom-set-variables.el"))
(load custom-file 'noerror)

;; So Long mitigates slowness due to extremely long lines.
;; Currently available in Emacs master branch *only*!
(when (fboundp 'global-so-long-mode)
  (global-so-long-mode))

;; Add a newline automatically at the end of the file upon save.
(setq require-final-newline t)

;; Default .args, .in, .out files to text-mode
(add-to-list 'auto-mode-alist '("\\.in\\'" . text-mode))
(add-to-list 'auto-mode-alist '("\\.out\\'" . text-mode))
(add-to-list 'auto-mode-alist '("\\.args\\'" . text-mode))
(add-to-list 'auto-mode-alist '("\\.bb\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.bbclass\\'" . shell-script-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd\\'" . markdown-mode))

;; Resizes the window width based on the input
(defun resize-window-width (w)
  "Resizes the window width based on W."
  (interactive (list (if (> (count-windows) 1)
                         (read-number "Set the current window width in [1~9]x10%: ")
                       (error "You need more than 1 window to execute this function!"))))
  (message "%s" w)
  (window-resize nil (- (truncate (* (/ w 10.0) (frame-width))) (window-total-width)) t))

;; Resizes the window height based on the input
(defun resize-window-height (h)
  "Resizes the window height based on H."
  (interactive (list (if (> (count-windows) 1)
                         (read-number "Set the current window height in [1~9]x10%: ")
                       (error "You need more than 1 window to execute this function!"))))
  (message "%s" h)
  (window-resize nil (- (truncate (* (/ h 10.0) (frame-height))) (window-total-height)) nil))

;; Setup shorcuts for window resize width and height
;; (global-set-key (kbd "C-z w") #'resize-window-width)
;; (global-set-key (kbd "C-z h") #'resize-window-height)

(defun resize-window (width delta)
  "Resize the current window's size.  If WIDTH is non-nil, resize width by some DELTA."
  (if (> (count-windows) 1)
      (window-resize nil delta width)
    (error "You need more than 1 window to execute this function!")))

;; Setup shorcuts for window resize width and height
(global-set-key (kbd "M-W =") (lambda () (interactive) (resize-window t 5)))
(global-set-key (kbd "M-W M-+") (lambda () (interactive) (resize-window t 5)))
(global-set-key (kbd "M-W -") (lambda () (interactive) (resize-window t -5)))
(global-set-key (kbd "M-W M-_") (lambda () (interactive) (resize-window t -5)))

(global-set-key (kbd "M-H =") (lambda () (interactive) (resize-window nil 5)))
(global-set-key (kbd "M-H M-+") (lambda () (interactive) (resize-window nil 5)))
(global-set-key (kbd "M-H -") (lambda () (interactive) (resize-window nil -5)))
(global-set-key (kbd "M-H M-_") (lambda () (interactive) (resize-window nil -5)))

(defun save-and-update-includes ()
  "Update the line numbers of #+INCLUDE:s in current buffer.
Only looks at INCLUDEs that have either :range-begin or :range-end.
This function does nothing if not in `org-mode', so you can safely
add it to `before-save-hook'."
  (interactive)
  (when (derived-mode-p 'org-mode)
    (save-excursion
      (goto-char (point-min))
      (while (search-forward-regexp
              "^\\s-*#\\+INCLUDE: *\"\\([^\"]+\\)\".*:range-\\(begin\\|end\\)"
              nil 'noerror)
        (let* ((file (expand-file-name (match-string-no-properties 1)))
               lines begin end)
          (forward-line 0)
          (when (looking-at "^.*:range-begin *\"\\([^\"]+\\)\"")
            (setq begin (match-string-no-properties 1)))
          (when (looking-at "^.*:range-end *\"\\([^\"]+\\)\"")
            (setq end (match-string-no-properties 1)))
          (setq lines (decide-line-range file begin end))
          (when lines
            (if (looking-at ".*:lines *\"\\([-0-9]+\\)\"")
                (replace-match lines :fixedcase :literal nil 1)
              (goto-char (line-end-position))
              (insert " :lines \"" lines "\""))))))))

(add-hook 'before-save-hook #'save-and-update-includes)

(defun decide-line-range (file begin end)
  "Visit FILE and decide which lines to include.
BEGIN and END are regexps which define the line range to use."
  (let (l r)
    (save-match-data
      (with-temp-buffer
        (insert-file-contents file)
        (goto-char (point-min))
        (if (null begin)
            (setq l "")
          (search-forward-regexp begin)
          (setq l (line-number-at-pos (match-beginning 0))))
        (if (null end)
            (setq r "")
          (search-forward-regexp end)
          (setq r (1+ (line-number-at-pos (match-end 0)))))
        (format "%s-%s" (+ l 1) (- r 1)))))) ;; Exclude wrapper

;; MiniBuffer Functions
(defun abort-minibuffer-using-mouse ()
  "Abort the minibuffer when using the mouse."
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'abort-minibuffer-using-mouse)

;; keep the point out of the minibuffer
(setq-default minibuffer-prompt-properties '(read-only t point-entered minibuffer-avoid-prompt face minibuffer-prompt))

;; Display Line Overlay
(defun display-line-overlay+ (pos str &optional face)
  "Display line at POS as STR with FACE.

FACE defaults to inheriting from default and highlight."
  (let ((ol (save-excursion
              (goto-char pos)
              (make-overlay (line-beginning-position)
                            (line-end-position)))))
    (overlay-put ol 'display str)
    (overlay-put ol 'face
                 (or face '(:background null :inherit highlight)))
    ol))

;; Read Lines From File
(defun read-lines (file-path)
  "Return a list of lines of a file at FILE-PATH."
  (with-temp-buffer (insert-file-contents file-path)
                    (split-string (buffer-string) "\n" t)))

(defun where-am-i ()
  "An interactive function showing function `buffer-file-name' or `buffer-name'."
  (interactive)
  (message (kill-new (if (buffer-file-name) (buffer-file-name) (buffer-name)))))

(use-package page-break-lines
  :diminish
  :init (global-page-break-lines-mode))


;; Configurations to smooth scrolling.
;; Vertical Scroll
(setq scroll-step 1)
(setq scroll-margin 1)
(setq scroll-conservatively 101)
(setq scroll-up-aggressively 0.01)
(setq scroll-down-aggressively 0.01)
(setq auto-window-vscroll nil)
(setq fast-but-imprecise-scrolling nil)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
;; Horizontal Scroll
(setq hscroll-step 1)
(setq hscroll-margin 1)

;; Title Bar
(setq-default frame-title-format '("HiEMACS - " user-login-name "@" system-name " - %b"))

;; Simplify Yes/No Prompts
(fset 'yes-or-no-p 'y-or-n-p)
(setq use-dialog-box nil)

;; Disable Splash Screen
;; (setq inhibit-startup-screen nil)
;; (setq initial-major-mode 'text-mode)
;; (setq initial-scratch-message "Better to run then curse the road...\n")

;; Modeline Time and Battery
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(tool-bar-mode 0)
(menu-bar-mode 1)
(scroll-bar-mode 0)

(use-package magit
  :if (executable-find "git")
  :bind
  ((:map magit-status-mode-map
    ("M-RET" . magit-diff-visit-file-other-window)))
  :config
  (defun magit-log-follow-current-file ()
    "A wrapper around `magit-log-buffer-file' with `--follow' argument."
    (interactive)
    (magit-log-buffer-file t)))

;; (use-package treemacs
;;   :init
;;   (with-eval-after-load 'winum
;;     (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
;;   :custom
;;   (treemacs-collapse-dirs 3)
;;   (treemacs-deferred-git-apply-delay 0.5)
;;   (treemacs-display-in-side-window t)
;;   (treemacs-file-event-delay 5000)
;;   (treemacs-file-follow-delay 0.2)
;;   (treemacs-follow-after-init t)
;;   (treemacs-follow-recenter-distance 0.1)
;;   (treemacs-git-command-pipe "")
;;   (treemacs-goto-tag-strategy 'refetch-index)
;;   (treemacs-indentation 2)
;;   (treemacs-indentation-string " ")
;;   (treemacs-is-never-other-window nil)
;;   (treemacs-max-git-entries 5000)
;;   (treemacs-no-png-images nil)
;;   (treemacs-no-delete-other-windows t)
;;   (treemacs-project-follow-cleanup nil)
;;   (treemacs-persist-file (expand-file-name ".cache/treemacs-persist" user-emacs-directory))
;;   (treemacs-recenter-after-file-follow nil)
;;   (treemacs-recenter-after-tag-follow nil)
;;   (treemacs-show-cursor nil)
;;   (treemacs-show-hidden-files t)
;;   (treemacs-silent-filewatch nil)
;;   (treemacs-silent-refresh nil)
;;   (treemacs-sorting 'alphabetic-desc)
;;   (treemacs-space-between-root-nodes t)
;;   (treemacs-tag-follow-cleanup t)
;;   (treemacs-tag-follow-delay 1.5)
;;   (treemacs-width 35)
;;   :config
;;   ;; The default width and height of the icons is 22 pixels. If you are
;;   ;; using a Hi-DPI display, uncomment this to double the icon size.
;;   ;;(treemacs-resize-icons 44)
;;   (treemacs-follow-mode t)
;;   (treemacs-filewatch-mode t)
;;   (treemacs-fringe-indicator-mode t)
;;   :bind
;;   (("M-0"       . treemacs-select-window)
;;    ("C-x t 1"   . treemacs-delete-other-windows)
;;    ("C-x t t"   . treemacs)
;;    ("C-x t B"   . treemacs-bookmark)
;;    ("C-x t C-t" . treemacs-find-file)
;;    ("C-x t M-t" . treemacs-find-tag))
;;   (:map treemacs-mode-map ("C-p" . treemacs-previous-line)))

;; (use-package yasnippet
;;   :diminish yas-minor-mode
;;   :init
;;   (use-package yasnippet-snippets :after yasnippet)
;;   :hook ((prog-mode LaTeX-mode org-mode) . yas-minor-mode)
;;   :bind
;;   (:map yas-minor-mode-map ("C-c C-n" . yas-expand-from-trigger-key))
;;   (:map yas-keymap
;;         (("TAB" . smarter-yas-expand-next-field)
;;          ([(tab)] . smarter-yas-expand-next-field)))
;;   :config
;;   (yas-reload-all)
;;   (defun smarter-yas-expand-next-field ()
;;     "Try to `yas-expand' then `yas-next-field' at current cursor position."
;;     (interactive)
;;     (let ((old-point (point))
;;           (old-tick (buffer-chars-modified-tick)))
;;       (yas-expand)
;;       (when (and (eq old-point (point))
;;                  (eq old-tick (buffer-chars-modified-tick)))
;;         (ignore-errors (yas-next-field))))))

(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :diminish smartparens-mode
  :bind
  (:map smartparens-mode-map
   ("C-M-f" . sp-forward-sexp)
   ("C-M-b" . sp-backward-sexp)
   ("C-M-a" . sp-backward-down-sexp)
   ("C-M-e" . sp-up-sexp)
   ("C-M-w" . sp-copy-sexp)
   ("C-M-k" . sp-change-enclosing)
   ("M-k" . sp-kill-sexp)
   ("C-M-<backspace>" . sp-splice-sexp-killing-backward)
   ("C-S-<backspace>" . sp-splice-sexp-killing-around)
   ("C-]" . sp-select-next-thing-exchange))
  :custom
  (sp-escape-quotes-after-insert nil)
  :config
  ;; Stop pairing single quotes in elisp
  (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
  (sp-local-pair 'org-mode "[" nil :actions nil))


;; Match Parenthesis
;; Show matching parenthesis
(show-paren-mode 1)
;; we will call `blink-matching-open` ourselves...
(remove-hook 'post-self-insert-hook
             #'blink-paren-post-self-insert-function)

;; this still needs to be set for `blink-matching-open` to work
(setq blink-matching-paren 'show)
(let ((ov nil)) ; keep track of the overlay
  (advice-add
   #'show-paren-function
   :after
   (defun show-paren--off-screen+ (&rest _args)
     "Display matching line for off-screen paren."
     (when (overlayp ov)
       (delete-overlay ov))
     ;; check if it's appropriate to show match info,
     ;; see `blink-paren-post-self-insert-function'
     (when (and (overlay-buffer show-paren--overlay)
                (not (or cursor-in-echo-area
                         executing-kbd-macro
                         noninteractive
                         (minibufferp)
                         this-command))
                (and (not (bobp))
                     (memq (char-syntax (char-before)) '(?\) ?\$)))
                (= 1 (logand 1 (- (point)
                                  (save-excursion
                                    (forward-char -1)
                                    (skip-syntax-backward "/\\")
                                    (point))))))
       ;; rebind `minibuffer-message' called by
       ;; `blink-matching-open' to handle the overlay display
       (cl-letf (((symbol-function #'minibuffer-message)
                  (lambda (msg &rest args)
                    (let ((msg (apply #'format-message msg args)))
                      (setq ov (display-line-overlay+
                                (window-start) msg))))))
         (blink-matching-open))))))

(use-package evil-matchit)
(global-evil-matchit-mode 1)

;; Indentation Configuration
(setq-default indent-tabs-mode nil)
(setq-default indent-line-function 'insert-tab)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default js-switch-indent-offset 4)
(c-set-offset 'comment-intro 0)
(c-set-offset 'innamespace 0)
(c-set-offset 'case-label '+)
(c-set-offset 'access-label 0)
(c-set-offset (quote cpp-macro) 0 nil)
(defun smart-electric-indent-mode ()
  "Disable 'electric-indent-mode in certain buffers and enable otherwise."
  (cond ((and (eq electric-indent-mode t)
              (member major-mode '(erc-mode text-mode)))
         (electric-indent-mode 0))
        ((eq electric-indent-mode nil) (electric-indent-mode 1))))
(add-hook 'post-command-hook #'smart-electric-indent-mode)

(use-package awesome-pair
  :load-path (lambda () (expand-file-name "site-elisp/awesome-pair" user-emacs-directory))
  :bind
  (:map prog-mode-map
   (("M-D" . awesome-pair-kill)
    ("SPC" . awesome-pair-space)
    ("=" . awesome-pair-equal)
    ("M-F" . awesome-pair-jump-right)
    ("M-B" . awesome-pair-jump-left)))
  :hook (prog-mode . awesome-pair-mode))

(use-package delete-block
  :load-path (lambda () (expand-file-name "site-elisp/delete-block" user-emacs-directory))
  :bind
  (("M-d" . delete-block-forward)
   ("C-<backspace>" . delete-block-backward)
   ("M-<backspace>" . delete-block-forward)
   ("M-DEL" . delete-block-backward)))

;; roam v2 configuration
(setq org-roam-directory "~/org/")

(use-package rime
	:custom
	(setq rime-translate-keybindings
		    '("C-f" "C-b" "C-n" "C-p" "C-g" "<left>" "<right>" "<up>" "<down>" "<prior>" "<next>" "<delete>"))
	(setq rime-show-candidate 'posframe)
	(setq rime-disable-predicates
		    '(rime-predicate-evil-mode-p
			    rime-predicate-after-alphabet-char-p
				  rime-predicate-prog-in-code-p))
	(setq mode-line-mule-info '((:eval (rime-lighter))))
	(default-input-method "rime")
  )

(use-package citre
  :defer t
  :init
  ;; This is needed in `:init' block for lazy load to work.
  (require 'citre-config)
  ;; Bind your frequently used commands.
  (global-set-key (kbd "<f5>") 'citre-jump)
  (global-set-key (kbd "<f6>") 'citre-jump-back)
  (global-set-key (kbd "<f4>") 'citre-ace-peek)
  (global-set-key (kbd "C-M-i") 'citre-completion-at-point)
  :config
  (setq
   ;; Set this if readtags is not in your path.
   ;;
   ;; citre-readtags-program "/path/to/readtags"
   ;;
   ;; Set this if you use project management plugin like projectile.  It's
   ;; used for things like displaying paths relatively, see its docstring.
   citre-project-root-function #'projectile-project-root))

;; kbd-macro key binding
(global-set-key (kbd "C-x x") 'call-last-kbd-macro)

;; add space after ","
(global-set-key (kbd ",")
                #'(lambda ()
                    (interactive)
                    (insert ", ")))

(defun yasnippet-current-line ();; C-c TAB
  (interactive)
  (let ((current-line (string-trim-right (thing-at-point 'line t))))
    (end-of-line)
    (newline-and-indent)
    (yas-expand-snippet (yasnippet-string-to-template (string-trim current-line)))))

(defun yasnippet-string-to-template (string)
  (let ((count 1))
    (labels ((rep (text)
                  (let ((replace (format "${%d:%s}" count text)))
                    (incf count)
                    replace)))
            (replace-regexp-in-string "[a-zA-Z0-9]+" #'rep string))))

(global-set-key (kbd "C-c TAB") 'yasnippet-current-line)

(setq org-taskjuggler-default-reports
      '("textreport report \"Plan\" {
  formats html
  header '== %title =='
  center -8<-
    [#Plan Plan] | [#Resource_Allocation Resource Allocation]
    ----
    === Plan ===
    <[report id=\"plan\"]>
    ----
    === Resource Allocation ===
    <[report id=\"resourceGraph\"]>
  ->8-
}
# A traditional Gantt chart with a project overview.
taskreport plan \"\" {
  headline \"Project Plan\"
  columns bsi, name {width 350}, start, end, effort, chart {scale week width 800}
  loadunit shortauto
  hideresource 1
}
# A graph showing resource allocation. It identifies whether each
# resource is under- or over-allocated for.
resourcereport resourceGraph \"\" {
  headline \"Resource Allocation Graph\"
  columns no, name, effort, annualleave, complete, weekly {width 700}
  loadunit shortauto
  hidetask ~(isleaf() & isleaf_())
  sorttasks plan.start.up
}")
      )

(setq org-taskjuggler-default-global-properties
      "
shift s40 \"Part time shift\" {
  workinghours wed, thu, fri off
}
leaves holiday \"National Day\" 2021-10-01 +5d,
       holiday \"Dragon Boat Festival\" 2021-06-12 +3d,
       holiday \"Mid-Autumn Festival\" 2021-09-19 +2d
")

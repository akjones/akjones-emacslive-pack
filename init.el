(live-load-config-file "bindings.el")

(setq user-full-name "Andrew Jones")
(setq user-mail-address "andrew@andrewjones.id.au")

(defconst emacs-external-dir "~/.emacs-external")
(unless (file-exists-p emacs-external-dir)
  (make-directory emacs-external-dir))

(defconst elpa-dir (concat emacs-external-dir "/" "elpa"))
(unless (file-exists-p elpa-dir)
  (make-directory elpa-dir))

(require 'package)
(setq package-user-dir elpa-dir)
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("melpa" . "http://melpa.milkbox.net/packages/")))

(unless package--initialized
  (package-initialize))

(when (null package-archive-contents)
  (package-refresh-contents))

(dolist (package
         '(ack-and-a-half
           ag
           projectile
           web-mode
           coffee-mode
           sass-mode
           haml-mode
           slime))

  (if (not (package-installed-p package))
      (package-install package)))

;; Add all packages to the load path
(let ((base elpa-dir))
  (add-to-list 'load-path base)
  (dolist (f (directory-files base))
    (let ((name (concat base "/" f)))
      (when (and (file-directory-p name)
                 (not (equal f ".."))
                 (not (equal f ".")))
        (add-to-list 'load-path name)))))

(require 'projectile)
(projectile-global-mode)
(setq projectile-indexing-method 'git)
(setq projectile-keymap-prefix (kbd "C-c C-p"))

(add-hook 'prog-mode-hook
          '(lambda ()
             (font-lock-add-keywords
              nil `(("(?\\(lambda\\>\\)"
                     (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                               ,(make-char 'greek-iso8859-7 107))
                                                              nil)))))))

(custom-set-variables
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t))

(setq js-indent-level 2)

(custom-set-variables '(coffee-tab-width 2))

(add-hook 'js2-mode-hook
          (lambda ()
            (slime-js-minor-mode 1)))


(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c C-l") 'slime-eval-buffer))

(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "C-c C-j") 'slime-connect))

(defun vi-open-line-above ()
  "Insert a newline above the current line and put point at beginning."
  (interactive)
  (unless (bolp)
    (beginning-of-line))
  (newline)
  (forward-line -1)
  (indent-according-to-mode))

(defun vi-open-line-below ()
  "Insert a newline below the current line and put point at beginning."
  (interactive)
  (unless (eolp)
    (end-of-line))
  (newline-and-indent))

(define-key global-map (kbd "C-c C-l o") 'vi-open-line-above)
(define-key global-map (kbd "C-c C-l p") 'vi-open-line-below)

(define-key global-map (kbd " C-c y") 'yas-expand)

(setq user-extempore-directory "/usr/local/Cellar/extempore/0.5/")
(autoload 'extempore-mode (concat user-extempore-directory "extras/extempore.el") "" t)
(add-to-list 'auto-mode-alist '("\\.xtm$" . extempore-mode))

(autoload #'llvm-mode (concat user-extempore-directory "extras/llvm-mode.el")
  "Major mode for editing LLVM IR files" t)

(add-to-list 'auto-mode-alist '("\\.ir$" . llvm-mode))
(add-to-list 'auto-mode-alist '("\\.ll$" . llvm-mode))

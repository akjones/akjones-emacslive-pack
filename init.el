(live-load-config-file "bindings.el")
(live-load-config-file "js.el")
(live-load-config-file "extempore.el")
(live-load-config-file "go.el")

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
           go-mode
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

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (shell-command-to-string "$SHELL -i -c 'echo $PATH'")))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(if window-system (set-exec-path-from-shell-PATH))

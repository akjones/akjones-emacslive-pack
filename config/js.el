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

(global-set-key (kbd "C-c w k") 'windmove-up)
(global-set-key (kbd "C-c w h") 'windmove-left)
(global-set-key (kbd "C-c w l") 'windmove-right)
(global-set-key (kbd "C-c w j") 'windmove-down)

(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C--") 'er/contract-region)

(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;;; treesit-fold-transient.el --- Transient menu for treesit-fold  -*- lexical-binding: t; -*-

;;; usage with use-package of repository has been cloned locally:
;;
;; (use-package treesit-fold-transient
;;   :load-path "/path/to/tree-sitter-fold"
;;   ;; wait for the main package to load first
;;   :after treesit-fold
;;
;;   ;; globally bind A-<down> to open the menu
;;   :bind ("A-<down>" . treesit-fold-menu)
;;
;;   :config
;;   ;; replace the default "t" binding inside the menu with "A-<down>"
;;   (transient-replace-suffix 'treesit-fold-menu "t"
;;     '("A-<down>" "Toggle node at point" treesit-fold-toggle)))

(require 'transient)

(defun treesit-fold-menu--mode-indicator (mode)
  "Return a short on/off indicator string for MODE."
  (if (and (boundp mode) (symbol-value mode))
      (propertize "on"  'face 'transient-value)
    (propertize "off" 'face 'transient-inactive-value)))

(transient-define-prefix treesit-fold-menu ()
  "Transient menu for treesit-fold."
  [:description
   (lambda ()
     (format "treesit-fold  [mode: %s  indicators: %s  comments: %s]"
             (treesit-fold-menu--mode-indicator 'treesit-fold-mode)
             (treesit-fold-menu--mode-indicator 'treesit-fold-indicators-mode)
             (treesit-fold-menu--mode-indicator 'treesit-fold-line-comment-mode)))]

  ["Fold / Unfold"
   ("c" "Close node at point"     treesit-fold-close)
   ("o" "Open node at point"      treesit-fold-open)
   ("r" "Open recursively"        treesit-fold-open-recursively)
   ("t" "Toggle node at point"    treesit-fold-toggle)
   ""
   ("C" "Close all in buffer"    treesit-fold-close-all)
   ("O" "Open all in buffer"     treesit-fold-open-all)]

  ["Toggle modes"
   ("m" treesit-fold-menu--toggle-mode
    :description (lambda ()
                   (format "Buffer fold mode        [%s]"
                           (treesit-fold-menu--mode-indicator
                            'treesit-fold-mode))))
   ("M" treesit-fold-menu--toggle-global-mode
    :description (lambda ()
                   (format "Global fold mode        [%s]"
                           (treesit-fold-menu--mode-indicator
                            'global-treesit-fold-mode))))
   ("i" treesit-fold-menu--toggle-indicators
    :description (lambda ()
                   (format "Buffer indicators mode  [%s]"
                           (treesit-fold-menu--mode-indicator
                            'treesit-fold-indicators-mode))))
   ("I" treesit-fold-menu--toggle-global-indicators
    :description (lambda ()
                   (format "Global indicators mode  [%s]"
                           (treesit-fold-menu--mode-indicator
                            'global-treesit-fold-indicators-mode))))
   ("l" treesit-fold-menu--toggle-line-comments
    :description (lambda ()
                   (format "Line comment folding    [%s]"
                           (treesit-fold-menu--mode-indicator
                            'treesit-fold-line-comment-mode))))])

(transient-define-suffix treesit-fold-menu--toggle-mode ()
  "Toggle `treesit-fold-mode' in the current buffer."
  (interactive)
  (call-interactively #'treesit-fold-mode))

(transient-define-suffix treesit-fold-menu--toggle-global-mode ()
  "Toggle `global-treesit-fold-mode'."
  (interactive)
  (call-interactively #'global-treesit-fold-mode))

(transient-define-suffix treesit-fold-menu--toggle-indicators ()
  "Toggle `treesit-fold-indicators-mode' in the current buffer."
  (interactive)
  (if (fboundp 'treesit-fold-indicators-mode)
      (call-interactively #'treesit-fold-indicators-mode)
    (message "treesit-fold-indicators-mode not available")))

(transient-define-suffix treesit-fold-menu--toggle-global-indicators ()
  "Toggle `global-treesit-fold-indicators-mode'."
  (interactive)
  (if (fboundp 'global-treesit-fold-indicators-mode)
      (call-interactively #'global-treesit-fold-indicators-mode)
    (message "global-treesit-fold-indicators-mode not available")))

(transient-define-suffix treesit-fold-menu--toggle-line-comments ()
  "Toggle `treesit-fold-line-comment-mode' in the current buffer."
  (interactive)
  (call-interactively #'treesit-fold-line-comment-mode))

(provide 'treesit-fold-transient)
;;; treesit-fold-transient.el ends here

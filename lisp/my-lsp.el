(defvar my-lsp-help-open nil)

(defun toggle-lsp-ui-help ()
  (interactive)
  (if my-lsp-help-open
      (progn
        (setq my-lsp-help-open nil)
        (lsp-ui-doc-hide))
    (progn
      (setq my-lsp-help-open t)
      (lsp-ui-doc-show))))

(provide 'my-lsp)

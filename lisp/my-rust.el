(defvar rust-test-last-test "")

(defun rust-test-generate-test-command (test-name)
  (concat "cargo test -- --nocapture " test-name))

(defun rust-run-test ()
  (interactive)
  (with-help-window "*rust tests*"
    (princ (shell-command-to-string rust-test-last-test))))

(defun rust-run-current-test ()
  (interactive)
  (save-excursion
    (re-search-backward "#\\[test\\]\n\s+fn\s+\\([[:alnum:]_]*\\)")
    (setq rust-test-last-test (rust-test-generate-test-command (match-string-no-properties 1)))
    (rust-run-test)))

(defun rust-run-previous-test ()
  (interactive)
  (rust-run-test))

(provide 'my-rust)

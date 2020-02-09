(defvar go-test-last-test "")

(defun go-test-generate-test-command (test-name)
  (concat "/usr/local/bin/go test -v -timeout 30s " (go-current-buffer-package) " -run " test-name "$"))

(defun go-current-buffer-package ()
  (replace-regexp-in-string
   "/Users/robmerrell/projects/globalgo/src/" "" (file-name-directory buffer-file-name)))

(defun format-go-test-output (output)
  (replace-regexp-in-string "" "\n" output))

(defun go-run-test ()
  (interactive)
  (with-help-window "*go tests*"
    (princ (concat go-test-last-test "\n" "\n"))
    (princ (concat "-------------------------------------------------------" "\n\n"))
    (princ (format-go-test-output (shell-command-to-string go-test-last-test)))))

(defun go-run-current-test ()
  (interactive)
  (if (string-match "_test\\.go" buffer-file-name)
      (save-excursion
        (re-search-backward "^func[ ]+\\(([[:alnum:]]*?[ ]?[*]?[[:alnum:]]+)[ ]+\\)?\\(Test[[:alnum:]_]+\\)(.*)")
        (setq go-test-last-test (go-test-generate-test-command (match-string-no-properties 2)))
        (go-run-test))
    (error "Must be in a _test.go file")))

(defun go-run-previous-test ()
  (interactive)
  (go-run-test))

(provide 'my-go)

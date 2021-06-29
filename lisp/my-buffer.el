;;; my-buffer.el --- functions for managing buffers
;;; Commentary:
;;; Code:

(defun new-empty-buffer ()
  "Create a new buffer called untitled(<n>)."
  (interactive)
  (let ((newbuf (generate-new-buffer-name "untitled")))
    (switch-to-buffer newbuf)))

(defun next-code-buffer ()
  "Switch to the next code buffer."
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (next-buffer)
    (while
        (and
         (string-match-p "^\*|^magit:.*" (buffer-name))
         (not (equal bread-crumb (buffer-name))))
      (next-buffer))))

(defun previous-code-buffer ()
  "Switch the the previous code buffer."
  (interactive)
  (let (( bread-crumb (buffer-name) ))
    (previous-buffer)
    (while
        (and
         (string-match-p "^\*|^magit:.*" (buffer-name))
         (not (equal bread-crumb (buffer-name))))
      (previous-buffer))))

(provide 'my-buffer)
;;; my-buffer.el ends here

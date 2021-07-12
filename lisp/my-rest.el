;;; my-buffer.el --- functions for managing REST calls
;;; Commentary:
;;; Code:

(defun my-rest-token (host-alias token)
  "Using auth-source get an encrypted token.  Where HOST-ALIAS is the hostname and TOKEN is the api token."
  (when-let (source (car (auth-source-search :host host-alias :user token)))
    (funcall (plist-get source :secret))))

(defun my-rest-host (host-alias)
  "Get the hostname for a HOST-ALIAS."
  (my-rest-token host-alias "host"))

(provide 'my-rest)
;;; my-rest.el ends here

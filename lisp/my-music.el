(defun itunes-mac-query (status-type)
  (s-chomp (shell-command-to-string (s-format "osascript -e 'tell application \"iTunes\" to $0 of current track as string'" 'elt (list status-type)))))

(defun itunes-mac-command (command)
  (shell-command-to-string (concat "osascript -e 'tell application \"iTunes\" to " command "'")))

(defun itunes-now-playing ()
  (interactive)
  (let ((artist (itunes-mac-query "artist"))
	(track (itunes-mac-query "name"))
	(album (itunes-mac-query "album")))
    (message (concat artist " ::: " album " -> " track))))

(defun itunes-play ()
  (interactive)
  (itunes-mac-command "play"))

(defun itunes-pause ()
  (interactive)
  (itunes-mac-command "pause"))

(defun itunes-next ()
  (interactive)
  (itunes-mac-command "next track"))

(defun itunes-previous ()
  (interactive)
  (itunes-mac-command "previous track"))
  

(provide 'my-music)

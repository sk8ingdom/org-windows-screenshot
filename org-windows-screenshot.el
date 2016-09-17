;;; org-windows-screenshot.el --- GNU Emacs screenshot utility for Windows 7

;; Copyright (C) 2016 Dominic Surano

;; Author: Dominic Surano <sk8ingdom@gmail.com>
;; Keywords: screenshot, utility, windows, batch, script

;; This file is not is part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; == Info ==
;; Org-windows-screenshot is a simple utility to save screenshots from
;; GNU Emacs using the npocmaka's batch.scripts library
;; (https://github.com/npocmaka/batch.scripts), specifically screenCapture.bat
;; (https://github.com/npocmaka/batch.scripts/blob/master/hybrids/.net/c/screenCapture.bat),
;; which is required to use the software.
;;
;; == Setup ==
;; Place this file in your load-path and add the following to your .emacs
;; configuration:
;;
;;    (require 'org-windows-screenshot)
;;    (setq org-windows-screenshot-command
;;          "C:/path/to/screenCapture.bat")
;;    (setq org-windows-screenshot-directory
;;          "C:/where/you/want/to/save/screenshots/")
;;    (global-set-key "\C-cs" 'org-windows-screenshot)
;;
;; where the directories have been modified to fit your specific configuration.
;;
;; == Usage ==
;; If you're using the key-binding in the setup above, just press C-c C-s which
;; will prompt for the specific window you want to capture. The name doesn't have
;; to be exact, just close.
;;
;; For example, typing =Emacs <RET>= will save JUST your Emacs window. If you
;; leave the prompt blank, it will capture the entire screen, although this
;; only seems to work for the primary monitor if you're using a multi-monitor
;; setup which might be a limitation of screenCapture.bat.
;;
;; Upon successful completion, an org-link to the screenshot will be added to
;; org-stored-links which can be inserted with org-insert-link which, for me,
;; is bound to =C-c C-l=. The link is in the following form:
;;
;;    [[C:/path/to/picture/YYY-MM-DD-HH-MM-SS.png][YYY-MM-DD-HH-MM-SS.png]]

;;; Code:

(defvar org-windows-screenshot-command nil
  "File path location of screenCapture.bat utility unless it's already in
%PATH%.")
(defvar org-windows-screenshot-directory nil
  "Location to store screenshots.")

(defun org-windows-screenshot (window-title)
  "Take a screenshot as save it as a time stamped file in
`org-screenshot-directory' using `org-screenshot-command' and add a link to
`org-stored-links' which can be inserted with `org-insert-link'.

WINDOW-TITLE is the name of the window you want to capture. It doesn't need
to be exact--it will find the closest match. If you want to capture the entire
screen, just hit <RET>"
  (interactive "sWhich window do you want to capture?: ")
  (let (filename)
    (setq filename (concat (format-time-string "%Y-%m-%d-%H-%M-%S") ".png"))
    ;; ;; This doesn't work and I'm not sure why
    ;; (call-process org-screenshot-command
    ;;               nil
    ;;               nil
    ;;               nil
    ;;               (concat org-screenshot-directory filename " "
    ;;                       window-title))
    (shell-command (concat "\"" org-windows-screenshot-command "\" "
                           "\"" org-windows-screenshot-directory filename "\" "
                           window-title))
    (message (concat org-windows-screenshot-directory filename " saved!"))
    ;; I feel like this should be done with add-to-list instead...
    (setq org-stored-links (cons (list (concat org-windows-screenshot-directory
                                               filename)
                                       filename)
                                 org-stored-links))))
(provide 'org-windows-screenshot)

;;; org-windows-screenshot.el ends here

;;; fnhh.el --- File Name Handler Hack -*- lexical-binding:t -*-

;; Maintainer: DK @a13
;; Package: fnhh
;; Homepage: https://github.com/a13/fnhh
;; Version: 0.0.1
;; Package-Requires: ((emacs "25.1"))
;; Keywords: internal

;; This file is not part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;; unsets `file-name-handler-alist' on load and restores it on `after-init-hook'

;;; Code:

(defvar fnhh--handler-alist nil
  "A variable to store `file-name-handler-alist' initial value.")

(defgroup fnhh nil
  "File name handler hack"
  :group 'startup)

(defcustom fnhh-initial-alist nil
  "The temporary substitution for `file-name-handler-alist'."
  :group 'fnhh
  :type 'list)


(defcustom fnhh-hook 'emacs-startup-hook
  "A hook to restore the `file-name-handler-alist' value."
  :group 'fnhh
  :type 'symbol)

(defun fnhh-restore ()
  "Restore variables and hooks."
  (when fnhh--handler-alist
    (customize-set-variable 'file-name-handler-alist
                            (copy-alist fnhh--handler-alist)
                            "Restored by FNHH")
    (setq fnhh--handler-alist nil))
  (remove-hook fnhh-hook #'fnhh-restore))

(defun fnhh-store ()
  "Set variables and hooks."
  (setq fnhh--handler-alist file-name-handler-alist)
  (setq file-name-handler-alist fnhh-initial-alist)
  (add-hook fnhh-hook #'fnhh-restore))

;;;###autoload
(define-minor-mode fnhh-mode
  "Minor mode to hack `file-name-handler-alist.'"
  :global t
  (if fnhh-mode
      (fnhh-store)
    (fnhh-restore)))

(provide 'fnhh)

;;; fnhh.el ends here

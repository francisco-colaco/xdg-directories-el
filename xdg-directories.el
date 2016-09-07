;;; xdg-directories.el --- XDG directory specification

;; Copyright (C) 2016  Francisco Miguel Colaço

;; Author: Francisco Miguel Colaço <francisco.colaco@gmail.com>
;; Keywords: XDG, directory, cache, config

;;; Commentary:
;;;
;;; XDG-DIRECTORIES contains functions to locate user Emacs files, in
;;; accordance to the XDG Base Directory Specification.
;;;
;;; There are different domains to the files, as they are broken into
;;; config, data, cache and runtime.  We advise the users of this
;;; package to look at the aforementioned specification to learn the
;;; differences of the domains.
;;;
;;; The locate-* functions are to be used by package writers.  User
;;; Emacs configuration, data and cache files can then be segregated
;;; into their own directories, making it simple to migrate
;;; configurations among several machines --- since the files that are
;;; unnecessary, being cached files, could easily not be transmitted.
;;;
;;; This package is released under the GNU General Public License,
;;; version 3.0 or, at your choice, above.  One may read the GNU
;;; General Public License at the GNU Web site, at http://www.gnu.org
;;;

;;; Code:

(defgroup xdg-directories
    ()
  "XDG Base Directory Specification"
  :group 'environment
  :link '(emacs-library-link "xdg-directories"))


(defun xdg-get-path (domain &optional name)
  "Return the directory at DOMAIN, with an optional NAME relative to it."
  (let ((dir (substring (shell-command-to-string (concat "xdg-user-dir " "PICTURES")) 0 -1)))
    (if name
        (expand-file-name name dir)
        dir)))


(defcustom xdg-data-home
  (or (getenv "XDG_DATA_HOME") (expand-file-name "~/.local/share"))
  "Directory to store data files.

This directory stores data files for application."
  :group 'xdg-directories
  :type 'directory)


(defcustom xdg-config-home
  (or (getenv "XDG_CONFIG_HOME") (expand-file-name "~/.config"))
  "Directory to store configuration files.

This directory stores files that configure applications.  This
directory should not contain machine generated session files."
  :group 'xdg-directories
  :type 'directory)


(defcustom xdg-cache-home
  (or (getenv "XDG_CACHE_HOME") (expand-file-name "~/.cache"))
  "Directory to store non essential files.

In this directory, user specific non essential data files are
stored.  These files should not contain information that cannot
be regenerated, in case they are erased."
  :group 'xdg-directories
  :type 'directory)


(defcustom xdg-runtime-dir
  (getenv "XDG_RUNTIME_DIR")
  "Directory to store temporary files.

In this directory, files that pertain only to this session are
stored.  These files can be erased when the application quits
or the user logs out."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-emacs-data-home
  (expand-file-name "emacs" xdg-data-home)
  "Directory to store user Emacs data files.

This directory stores data files for Emacs and it's
components or packages."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-emacs-config-home
  (expand-file-name "emacs" xdg-config-home)
  "Directory to store user Emacs configuration files.

This directory stores configuration files for Emacs and it's
components or packages, and should not contain machine
generated session files."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-emacs-cache-home
  (expand-file-name "emacs" xdg-cache-home)
  "Directory to store user Emacs cache files.

This directory stores non essential data files for Emacs and
it's components or packages, and should not contain any files
that would cause loss of information when erased."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-emacs-runtime-dir
  (expand-file-name "emacs" xdg-runtime-dir)
  "Directory to store user Emacs temporary files.

This directory stores files that may be erased when the user
logs out."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-desktop-directory
  (xdg-get-path "DESKTOP")
  "The desktop directory."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-download-directory
  (xdg-get-path "DOWNLOAD")
  "The downloads directory.

This is the default directory where the user stores transferred files."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-templates-directory
  (xdg-get-path "TEMPLATES")
  "The templates directory.

This is the default directory where the user stores template files."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-public-share-directory
  (xdg-get-path "PUBLICSHARE")
  "The public share directory.

This is a directory that is shared with other users."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-documents-directory
  (xdg-get-path "DOCUMENTS")
  "The documents directory.

This is the directory where the user stores documents."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-music-directory
  (xdg-get-path "MUSIC")
  "The music directory.

This is the directory where the user stores music and sound files."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-pictures-directory
  (xdg-get-path "PICTURES")
  "The pictures directory.

This is the directory where the user stores pictures and image files."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-videos-directory
  (xdg-get-path "VIDEOS")
  "The video directory.

  This is the directory where the user stores video files."
  :group 'xdg-directories
  :type 'directory)


(defun xdg-get-user-file (filename directory &optional create-parent-dirs)
  "Locate NAME under DIRECTORY, wherther it exists or not.

If CREATE-PARENT-DIRS is T, the parent directories are created.

Returns the complete file path, so it can be chained."
  (let ((file (expand-file-name name directory)))
    ;; Create any parent directories, if so requested.
    (if create-parent-dirs
      (unless (file-exists-p directory)
        (make-directory directory t)))
    ;; Return the name of the file with the given path.
    file))


(defun locate-user-emacs-cache-file (filename &optional create-parent-dirs)
  "Locate a cache file named FILENAME.

The file may exist or not under the user Emacs cache dir (under
XDG-CACHE-HOME/emacs).  The path of the file is returned
regardless of it's existence.

If CREATE-PARENT-DIRS is t, then the directory and its parent
dirs will be created in case they are not found."
  (xdg-get-user-file filename user-emacs-cache-home create-parent-dirs))


(defun locate-user-emacs-config-file (filename &optional create-parent-dirs)
  "Locate a config file named FILENAME.

The file may exist or not under the user Emacs config dir (under
XDG-CONFIG-HOME/emacs).  The path of the file is returned
regardless of it's existence.

If CREATE-PARENT-DIRS is t, then the directory and its parent
dirs will be created in case they are not found."
  (xdg-get-user-file filename user-emacs-config-home create-parent-dirs))


(defun locate-user-emacs-data-file (filename &optional create-parent-dirs)
  "Locate a data file named FILENAME.

The file may exist or not under the user Emacs data dir (under
XDG-DATA-HOME/emacs).  The path of the file is returned
regardless of it's existence.

If CREATE-PARENT-DIRS is t, then the directory and its parent
dirs will be created in case they are not found."
  (xdg-get-user-file filename user-emacs-data-home create-parent-dirs))


(defun locate-user-emacs-runtime-file (filename &optional create-parent-dirs)
  "Locate a runtime file named FILENAME.

The file may exist or not under the user Emacs runtime dir (under
XDG-RUNTIME-DIR/emacs).  The path of the file is returned
regardless of it's existence.

If CREATE-PARENT-DIRS is t, then the directory and its parent
dirs will be created in case they are not found."
  (xdg-get-user-file filename user-emacs-runtime-dir create-parent-dirs))


(defun locate-user-document-file (filename)
  "Locate a document file named FILENAME.

The file resides under 'user-documents-directory' and may exist
or not."
  (expand-file-name filename user-documents-directory))


(provide 'xdg-directories)
;;; xdg-directories.el ends here

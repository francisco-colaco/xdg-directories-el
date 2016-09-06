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

(require 's)


(defgroup xdg-directories
    ()
  "XDG Directory Specification"
  :group 'environment
  :link '(emacs-library-link "xdg-directories"))


(defun xdg-get-path (domain &optional path)
  "Return the directory at DOMAIN, with an optional PATH relative to it."
  (let ((dir (s-chomp (shell-command-to-string (concat "xdg-user-dir " domain)))))
    (if path
        (expand-file-name path dir)
        dir)))


(defcustom xdg-data-home
  (or (getenv "XDG_DATA_HOME") (expand-file-name "~/.local/share"))
  "The base directory relative to which user specific data files
  should be stored."
  :group 'xdg-directories
  :type 'directory)


(defcustom xdg-config-home
  (or (getenv "XDG_CONFIG_HOME") (expand-file-name "~/.config"))
  "The base directory relative to which user specific
  configuration files should be stored."
  :group 'xdg-directories
  :type 'directory)


(defcustom xdg-cache-home
  (or (getenv "XDG_CACHE_HOME") (expand-file-name "~/.cache"))
  "The base directory relative to which user specific
  non-essential data files should be stored."
  :group 'xdg-directories
  :type 'directory)


(defcustom xdg-runtime-dir
  (getenv "XDG_RUNTIME_DIR")
  "The directory where files that pertain only to this session
  are stored.  These files can be erased when the application quits
  or the user logs out."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-emacs-data-home
  (expand-file-name "emacs" xdg-data-home)
  "The base directory relative to which user Emacs specific data
  files should be stored."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-emacs-config-home
  (expand-file-name "emacs" xdg-config-home)
  "The base directory relative to which user Emacs specific
  configuration files should be stored."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-emacs-cache-home
  (expand-file-name "emacs" xdg-cache-home)
  "The base directory relative to which user Emacs specific
  non-essential data files should be stored."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-emacs-runtime-dir
  (expand-file-name "emacs" xdg-runtime-dir)
  "The directory where Emacs files that pertain only to this session
  are stored.  These files can be erased when the application quits
  or the user logs out."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-desktop-directory
  (xdg-get-path "DESKTOP")
  "The desktop directory."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-download-directory
  (xdg-get-path "DOWNLOAD")
  "The directory where the user stores his downloaded files by default."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-templates-directory
  (xdg-get-path "TEMPLATES")
  "The directory where the user stores his templates."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-public-share-directory
  (xdg-get-path "PUBLICSHARE")
  "The directory where the user stores his shared files."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-documents-directory
  (xdg-get-path "DOCUMENTS")
  "The directory where the user stores his documents."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-music-directory
  (xdg-get-path "MUSIC")
  "The directory where the user stores his music."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-pictures-directory
  (xdg-get-path "PICTURES")
  "The directory where the user stores his pictures."
  :group 'xdg-directories
  :type 'directory)


(defcustom user-videos-directory
  (xdg-get-path "VIDEOS")
  "The directory where the user stores his videos."
  :group 'xdg-directories
  :type 'directory)


(defun xdg-get-user-file (filename parent-directory &optional create-parent-dirs)
  "Locate FILENAME under PARENT-DIRECTORY/emacs, wherther it exists or not.

If CREATE-PARENT-DIRS is T, the parent directories are created."
  (let* ((base-dir (expand-file-name "emacs" parent-directory))
         (file (expand-file-name filename base-dir))
         (dir (file-name-directory file)))
    ;; Create any parent directories, if so requested.
    (if create-parent-dirs
        (unless (file-exists-p dir)
          (make-directory dir t)))
    ;; Return the file name.
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

The file may exist or not under the user Emacs documents
dir (which is predetermined by this package using operating
system tools or, if found lacking, sensible defaults).  The path
of the file is returned regardless of it's existence.

If CREATE-PARENT-DIRS is t, then the directory and its parent
dirs will be created in case they are not found."
  (expand-file-name filename user-documents-directory))


(provide 'xdg-directories)
;;; xdg-directories.el ends here

xdg-directories.el: locate files in Emacs under the XDG Base Directory
Specification.

# Introduction and purpose

The XDG Base Directory Specification is located at
https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
and defines where application generated files should be looked for by
defining one or more base directories relative to which files should
be located.

xdg-directories.el allows the package writers to locate a file in
Emacs user directories for different domains: data, configuration,
cache and runtime.  It locates files in the domains defined using the
utility xdg-user-dir, when it is found, or by sensible defaults.

Using this package, an emacs-lisp package writer can put different
files under different directories, according to the domain thereof.  A
cache file, which is normally not wanted in backups, can be named
under ~/.cache/emacs/<filename>, whereas a configuration file would be
under a different directory, in ~/.config/emacs/.  Passwords and
security sensible files can also made to be in a directory where, as
the user logs out, is normally erased.

# Usage

In Linux (or where the executable xdg-user-dir can be found), the
operating system will be inquired on where the different directories
are to be located.  On other operating systems, sensible defaults are
used.

The variables that store the directory paths are available in
Customize, under the group XDG Directories.

Files from several domains can be located.  Located means here, at the
lack of a better term, named, since the file name will be returned,
regardless of the file existence.

- User documents:

> (locate-user-document-file "org/agenda.txt")
> "/home/francisco.colaco/Documentos/org/agenda.txt"

- Configuration files:

> (locate-user-emacs-config-file "init.el")
> "/home/francisco.colaco/.config/emacs/emacs/init.el"

- Data files:

> (locate-user-emacs-data-file "recentf")
> "/home/francisco.colaco/.local/share/emacs/emacs/recentf"

- Cache files:

> (locate-user-emacs-cache-file "elfeed/index")
> "/home/francisco.colaco/.cache/emacs/emacs/elfeed/index"

- Runtime files:

> (locate-user-emacs-runtime-file "credentials.txt")
> "/run/user/1000/emacs/emacs/credentials.txt"

* Examples

> (setq custom-file (locate-user-emacs-config-file "custom.el"))

> (setq org-directory (locate-user-document-file "org"))

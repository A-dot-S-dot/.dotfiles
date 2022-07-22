;;; init.el -*- lexical-binding: t; -*-

;; Workaround for an error

(doom! :completion
       company
       (vertico +icons)

       :ui
       doom
       doom-dashboard
       hl-todo
       hydra
       modeline
       ophints
       (popup +all +defaults)
       vc-gutter
       nav-flash
       indent-guides
       (treemacs +lsp)
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       snippets

       :emacs
       (dired +icons +ranger)
       electric
       undo
       vc

       :term
       vterm

       :email
       (mu4e +org)

       :checkers
       syntax
       (spell +flyspell +everywhere)

       :tools
       biblio
       (debugger +lsp)
       (eval +overlay)
       (lookup +docsets +dictionary)
       (lsp +peek)
       magit
       pdf

       :lang
       emacs-lisp
       latex
       (markdown +grip)
       (org +pretty +roam2 +dragndrop)
       (python +lsp +pyright)
       (haskell +lsp)

       :config
       literate
       (default +bindings +smartparens))

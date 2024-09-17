UltiSnipsAddFiletypes tex
UltiSnipsAddFiletypes markdown
call vimtex#init()

nmap <leader>wo :call custom#OpenWikiPageWithBrowserSync()<cr>
nmap <leader>wO :call custom#OpenWikiPageWithFirefox()<cr>
nmap dsl :WikiLinkRemove<cr>
nmap <leader>fp :Pandoc! pdf --standalone --citeproc<cr>
nmap <leader>et :call custom#EditMetadata("title")<cr>

augroup export
  autocmd!
  autocmd BufWritePost ~/Nextcloud/Notes/Wiki/*.md {
    if ! b:wiki.in_journal
      silent! !pandoc --quiet --standalone --toc --extract-media=.. --metadata-file=metadata.yaml --lua-filter=links-to-html.lua --mathjax --template=easy_template.html --citeproc -f markdown -t html5 % -o %:p:h/build/%:t:r.html
    endif
    }
augroup end

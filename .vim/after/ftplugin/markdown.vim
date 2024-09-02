UltiSnipsAddFiletypes tex
UltiSnipsAddFiletypes markdown
call vimtex#init()

nmap <leader>wo :call custom#OpenWikiPageWithBrowserSync()<cr>
nmap <leader>wO :call custom#OpenWikiPageWithFirefox()<cr>
nmap dsl :WikiLinkRemove<cr>
nmap <leader>fp :Pandoc! pdf --standalone --citeproc<cr>
nmap <leader>et :call custom#EditMetadata("title")<cr>

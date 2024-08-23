UltiSnipsAddFiletypes tex
UltiSnipsAddFiletypes markdown
call vimtex#init()

nmap <leader>wo :call custom#OpenWikiPageWithBrowserSync()<cr>
nmap <leader>wO :call custom#OpenWikiPageWithFirefox()<cr>
nmap dsl :WikiLinkRemove<cr>

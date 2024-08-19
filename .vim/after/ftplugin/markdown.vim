UltiSnipsAddFiletypes tex
UltiSnipsAddFiletypes markdown
call vimtex#init()

nmap <leader>wo :call custom#OpenWikiWithBrowserSync()<cr>
nmap <leader>wO :call custom#OpenWikiWithFirefox()<cr>
nmap dsl :WikiLinkRemove<cr>

function! custom#GetRandomPageName() abort
  return printf("0x%08x", str2nr(strftime('%s')))
endfunction

function! custom#RemoveUnderscores(ctx, text) abort
  return substitute(a:ctx.name, '_', ' ', 'g')
endfunction

function! custom#OpenWikiPage() abort
  let l:fzf_opts = join([
    \ '-d"#####" --with-nth=-1 --print-query --prompt "WikiPages> "',
    \ '--expect=alt-enter',
    \ g:wiki_fzf_opts,
    \])

  call fzf#run(fzf#wrap({
    \ 'source': map(
    \   wiki#page#get_all(),
    \   {_, x ->  x[0] .. '#####' .. s:transform(x[1]) }),
    \ 'sink*': funcref('s:open_page'),
    \ 'options': l:fzf_opts
    \}))
endfunction

function! s:transform(entry) abort
  " Remove '_' and '/'
  return substitute(substitute(a:entry, '_', ' ', 'g'), '^/', '', 'g')
endfunction

function! s:open_page(lines) abort
  " a:lines is a list with two or three elements. Two if there were no
  " matches, and three if there is one or more matching names. The first
  " element is the search query; the second is either an empty string or the
  " alternative key 'alt-enter' if this was pressed; the third element
  " contains the selected item.

  if empty(a:lines[0]) && !empty(a:lines[1])
    call wiki#url#follow(custom#GetRandomPageName())
  elseif len(a:lines) == 2 || !empty(a:lines[1])
    call wiki#url#follow(a:lines[0])
  else
    execute 'edit ' .. split(a:lines[2], '#####')[0]
  endif
endfunction

function! custom#OpenWikiPageWithBrowserSync() abort
  let l:page = expand('%:t:r')
  let l:command = join([
    \ 'browser-sync ',
    \ g:wiki_root  . '/build ',
    \ '--startPath=' . l:page . '.html ',
    \ '--watch &',
    \])
  call system(l:command)
endfunction

function! custom#OpenWikiPageWithFirefox() abort
  let l:page = expand('%:t:r')
  let l:command = join([
    \ 'firefox ',
    \ g:wiki_root  . '/build/' . l:page . '.html'
    \])
  call system(l:command)
endfunction

function! custom#AddWikiLink(...) abort
  let l:mode = a:0 > 0 ? a:1 : ''
  let l:fzf_opts = join([
    \ '-d"#####" --with-nth=-1 --print-query --prompt "WikiLinkAdd> "',
    \ g:wiki_fzf_opts,
    \])

  call fzf#run(fzf#wrap({
    \ 'source': map(
    \   wiki#page#get_all(),
    \   {_, x ->  x[0] .. '#####' .. l:mode .. '#####' .. s:transform(x[1]) }),
    \ 'sink*': funcref('s:add_link'),
    \ 'options': l:fzf_opts
    \}))
endfunction

function! s:add_link(lines) abort
  " a:lines is a list with one or two elements. Two if there was a match, else
  " one. The first element is the search query; the second element contains the
  " selected item.
  let l:path = len(a:lines) == 2
    \ ? split(a:lines[1], '#####')[0]
    \ : a:lines[0]
  let l:mode = split(a:lines[1], '#####')[1]

  call s:add_wiki_link(l:path, l:mode, { 'transform_relative': v:true })
endfunction

function! s:add_wiki_link(path, mode, ...) abort
  if wiki#paths#is_abs(a:path)
    let l:cwd = expand('%:p:h')
    let l:url = stridx(a:path, l:cwd) == 0
      \ ? wiki#paths#to_wiki_url(a:path, l:cwd)
      \ : '/' .. wiki#paths#to_wiki_url(a:path)
  else
    let l:creator = wiki#link#get_creator()
    let l:url = has_key(l:creator, 'url_transform')
      \ ? l:creator.url_transform(a:path)
      \ : a:path
  endif

  if a:mode == 'visual'
    let l:at_last_col = getpos("'>")[2] >= col('$') - 1
    normal! gv"wd
    let l:text = trim(getreg('w'))
  elseif a:mode == 'insert'
    let l:text = l:url =~ '^0x'
      \ ? '(' .. fnamemodify(l:url, ":r") .. ')'
      \ : substitute(fnamemodify(l:url, ":r"), '_', ' ', 'g')
  else
    let l:text = ''
  endif

  let l:options = extend({
    \ 'position': getcurpos()[1:2],
    \ 'text': l:text,
    \}, a:0 > 0 ? a:1 : {})

  let l:link_string = wiki#link#template(l:url, l:options.text)

  let l:line = getline(l:options.position[0])
  if a:mode ==# 'insert' && l:options.position[1] == col('$') - 1
    call setline(l:options.position[0], l:line . l:link_string)
  if a:mode ==# 'visual' && l:at_last_col
    call setline(l:options.position[0], l:line . l:link_string)
  else
    call setline(l:options.position[0],
      \ strpart(l:line, 0, l:options.position[1]-1)
      \ .. l:link_string
      \ .. strpart(l:line, l:options.position[1]-1))
  endif

  if l:options.position == getcurpos()[1:2]
    call cursor(
      \ l:options.position[0],
      \ l:options.position[1] + len(l:link_string)
      \)
  endif

  if a:mode=='insert'
    call feedkeys('a')
  endif
endfunction

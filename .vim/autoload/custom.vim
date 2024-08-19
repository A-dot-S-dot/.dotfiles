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

  if l:mode == 'visual'
    call s:add_link_visual(l:path)
  elseif l:mode == 'insert'
    call s:add_link_insert(l:path)
  else
    call s:add_link_normal(l:path)
  endif
endfunction

function! s:add_link_visual(path) abort
  let l:url = s:get_url(a:path)
  let l:at_last_col = getpos("'>")[2] >= col('$') - 1
  normal! gv"wd
  let l:text = trim(getreg('w'))

  call s:add_link_string(l:url, l:text, l:at_last_col)
endfunction

function! s:get_url(path) abort
  if wiki#paths#is_abs(a:path)
    return s:get_existing_url(a:path)
  else
    return s:get_new_url(a:path)
  endif
endfunction

function! s:get_existing_url(path) abort
  let l:cwd = expand('%:p:h')
  let l:url = stridx(a:path, l:cwd) == 0
    \ ? wiki#paths#to_wiki_url(a:path, l:cwd)
    \ : '/' .. wiki#paths#to_wiki_url(a:path)
  return l:url
endfunction

function! s:get_new_url(path) abort
  let l:creator = wiki#link#get_creator()
  let l:url = has_key(l:creator, 'url_transform')
    \ ? l:creator.url_transform(a:path)
    \ : a:path
  return l:url
endfunction

function! s:add_link_string(url, text, at_last_col) abort
  let l:link_string = wiki#link#template(a:url, a:text)
  let l:position = getcurpos()[1:2]
  let l:line = getline(l:position[0])

  if a:at_last_col
    call setline(l:position[0], l:line . l:link_string)
  else
    call setline(l:position[0],
      \ strpart(l:line, 0, l:position[1]-1)
      \ .. l:link_string
      \ .. strpart(l:line, l:position[1]-1))
  endif
endfunction

function! s:add_link_insert(path) abort
  let l:url = s:get_url(a:path)
  let l:at_last_col = getcurpos()[1] == col('$') - 1
  let l:text = l:url =~ '^0x'
    \ ? '(' .. fnamemodify(l:url, ":r") .. ')'
    \ : substitute(fnamemodify(l:url, ":r"), '_', ' ', 'g')

  call s:add_link_string(l:url, l:text, l:at_last_col)
  call feedkeys('a')
endfunction

function! s:add_link_normal(path) abort
  let l:url = s:get_url(a:path)
  let l:text = ''

  call s:add_link_string(l:url, l:text, 0)
endfunction

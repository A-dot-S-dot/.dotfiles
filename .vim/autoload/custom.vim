function! custom#GetRandomPageName() abort
  return printf("0x%08x", str2nr(strftime('%s')))
endfunction

function! custom#IsJournalFile() abort
  if expand("%:p") =~ g:wiki_journal.name
    return v:true
  endif
  return v:false
endfunction

function! custom#GetTitle(ctx) abort
  let l:title = substitute(a:ctx.name, '_', ' ', 'g')
  return cases#capitalize(l:title)
endfunction

function! custom#GetDate(ctx) abort
  return strftime(" %d. %b %Y - %a - %H:%M")
endfunction

function! custom#EditMetadata(key) abort
  let key_line = search("^"..a:key..":")
  if l:key_line
    call setline(l:key_line, a:key..": ")
  else
    call append(1, a:key..": ")
    let l:key_line = 2
  endif
  call cursor(l:key_line, 7)
  call feedkeys('a')
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
  let l:entry = substitute(a:entry, '_', ' ', 'g')
  let l:entry = substitute(l:entry, '^/', '', '')
  return cases#capitalize(l:entry)
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
    call wiki#url#follow(substitute(a:lines[0], ' ', '_', 'g'))
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
  let l:mode = a:0 > 0 ? a:1 : 'normal'
  let l:fzf_opts = join([
    \ '-d"#####" --with-nth=-1 --print-query --prompt "WikiLinkAdd> "',
    \ '--expect=alt-enter',
    \ g:wiki_fzf_opts,
    \])

  call fzf#run(fzf#wrap({
    \ 'source': map(
    \   wiki#page#get_all(),
    \   {_, x ->  x[0] .. '#####' .. s:transform(x[1]) }),
    \ 'sink*': funcref('s:add_link_'..l:mode),
    \ 'options': l:fzf_opts
    \}))
endfunction

function! s:add_link_visual(lines) abort
  let l:path = s:get_path(a:lines)
  let l:url = s:get_url(l:path)
  let l:at_last_col = getpos("'>")[2] >= col('$') - 1
  normal! gv"wd
  let l:text = trim(getreg('w'))

  call s:add_link_string(l:url, l:text, l:at_last_col)
endfunction

function! s:get_path(lines) abort
  " a:lines is a list with two or three elements. Two if there were no
  " matches, and three if there is one or more matching names. The first
  " element is the search query; the second is either an empty string or the
  " alternative key 'alt-enter' if this was pressed; the third element
  " contains the selected item.

  if empty(a:lines[0]) && !empty(a:lines[1])
    return custom#GetRandomPageName()
  elseif len(a:lines) == 2 || !empty(a:lines[1])
    return a:lines[0]
  else
    return split(a:lines[2], '#####')[0]
  endif
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
  return substitute(a:path, ' ', '_', 'g')..".md"
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

  if l:position == getcurpos()[1:2]
    call cursor(
          \ l:position[0],
          \ l:position[1] + len(l:link_string)
          \)
  endif
endfunction

function! s:add_link_insert(lines) abort
  let l:path = s:get_path(a:lines)
  let l:url = s:get_url(l:path)
  let l:at_last_col = getcurpos()[2] == col('$') - 1
  let l:text = l:url =~ '^0x'
    \ ? '(' .. fnamemodify(l:url, ":r") .. ')'
    \ : substitute(fnamemodify(l:url, ":r"), '_', ' ', 'g')

  call s:add_link_string(l:url, l:text, l:at_last_col)
  call feedkeys('a')
endfunction

function! s:add_link_normal(lines) abort
  let l:path = s:get_path(a:lines)
  let l:url = s:get_url(l:path)
  let l:text = l:url =~ '^0x'
    \ ? '(' .. fnamemodify(l:url, ":r") .. ')'
    \ : substitute(fnamemodify(l:url, ":r"), '_', ' ', 'g')

  call s:add_link_string(l:url, l:text, 0)
endfunction

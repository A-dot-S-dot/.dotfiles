let g:exclusions = [
  \'a', 'an', 'and', 'as', 'at',
  \'but', 'by',
  \'en',
  \'for',
  \'if', 'in', 'is',
  \'nor',
  \'oder', 'of', 'on', 'or',
  \'per',
  \'the', 'to',
  \'v.', 'vs.', 'via', 'von',
  \'und',
  \]


function! cases#capitalize(string)
  let l:words = split(a:string, " ")
  let l:cap_string = cases#capitalize_word(l:words[0])

  if len(l:words)>1
    for word in l:words[1:]
      let l:cap_string ..= " "..cases#capitalize_word(word)
    endfor
  endif

  return l:cap_string
endfunction

function! cases#capitalize_word(word) abort
  if (index(g:exclusions, a:word)>=0) || (toupper(a:word[0]) ==# a:word[0])
    return a:word
  else
    return toupper(a:word[0]) .. a:word[1:]
  endif
endfunction

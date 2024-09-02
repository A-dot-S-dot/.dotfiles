let g:exclusions = [
  \'a', 'an', 'and', 'as', 'at',
  \'but', 'by',
  \'die', 'der', 'das', 'des', 'dem', 'den', 'dessen',
  \'en', 'ein', 'eine', 'einer',
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

  for i in range(len(l:words))
    let l:word = split(l:words[i], "-")
    for j in range(len(l:word))
      let l:word[j] = cases#capitalize_word(l:word[j])
    endfor
    let l:words[i]=join(l:word, "-")
  endfor

  return join(l:words)
endfunction

function! cases#capitalize_word(word) abort
  if (index(g:exclusions, a:word)>=0) || (toupper(a:word[0]) ==# a:word[0])
    return a:word
  else
    return toupper(a:word[0]) .. a:word[1:]
  endif
endfunction

function solarizedtheme
  set -gx FZF_DEFAULT_OPTS '--color light'

  set -Ux fish_color_autosuggestion 93a1a1
  set -Ux fish_color_cancel -r
  set -Ux fish_color_command 586e75
  set -Ux fish_color_comment 93a1a1
  set -Ux fish_color_cwd green
  set -Ux fish_color_cwd_root red
  set -Ux fish_color_end 268bd2
  set -Ux fish_color_error dc322f
  set -Ux fish_color_escape 'bryellow'  '--bold'
  set -Ux fish_color_history_current --bold
  set -Ux fish_color_host normal
  set -Ux fish_color_match --background=brblue
  set -Ux fish_color_normal normal
  set -Ux fish_color_operator bryellow
  set -Ux fish_color_param 657b83
  set -Ux fish_color_quote 839496
  set -Ux fish_color_redirection 6c71c4
  set -Ux fish_color_search_match 'bryellow'  '--background=white'
  set -Ux fish_color_selection 'white'  '--bold'  '--background=brblack'
  set -Ux fish_color_status red
  set -Ux fish_color_user brgreen
  set -Ux fish_color_valid_path --underline
  set -Ux fish_pager_color_completion green
  set -Ux fish_pager_color_description 'B3A06D'  'yellow'
  set -Ux fish_pager_color_prefix 'cyan'  '--underline'
  set -Ux fish_pager_color_progress 'brwhite'  '--background=cyan'
end

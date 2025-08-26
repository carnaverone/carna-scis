# bash completion for carna-scis
_carna_scis() {
  local cur prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  local cmds="hash verify rand hex secrets --help --version -h -V"

  if [[ ${COMP_CWORD} -eq 1 ]]; then
    COMPREPLY=( $(compgen -W "${cmds}" -- "${cur}") )
    return 0
  fi

  case "${COMP_WORDS[1]}" in
    hex) COMPREPLY=( $(compgen -W "enc dec" -- "${cur}") );;
    secrets) COMPREPLY=( $(compgen -W "scan" -- "${cur}") );;
  esac
}
complete -F _carna_scis carna-scis

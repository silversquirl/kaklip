declare-option -docstring 'Command to synchronize data from Kakoune to the system clipboard' str-list kaklip_push_cmd xsel --clipboard --nodetach -i
declare-option -docstring 'Command to synchronize data from the system clipboard to Kakoune' str-list kaklip_pull_cmd xsel --clipboard -o

define-command kaklip-push -hidden -docstring 'Push " register changes to system clipboard' %{
	echo %sh{
		{
			printf '%s' "$kak_main_reg_dquote" | eval "$kak_quoted_opt_kaklip_push_cmd" &
			while [ -e "/tmp/kaklip_$kak_session" ]; do :; done
			>"/tmp/kaklip_$kak_session"
			wait
			rm "/tmp/kaklip_$kak_session"
		} >/dev/null 2>&1 </dev/null &
	}
}

define-command kaklip-pull -hidden -docstring 'Pull system clipboard changes to " register' %{
	eval -no-hooks %sh{
		[ -e "/tmp/kaklip_$kak_session" ] || echo 'reg dquote %sh{eval "$kak_quoted_opt_kaklip_pull_cmd"}'
	}
}

hook global RegisterModified '"' kaklip-push
hook global FocusIn .* kaklip-pull
hook global KakBegin .* kaklip-pull

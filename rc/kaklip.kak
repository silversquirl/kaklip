provide-module kaklip %§

declare-option -docstring 'clipboard sync command' str kaklip_cmd %sh{
	if command -v xsel >/dev/null 2>&1; then
		echo 'xsel --clipboard --nodetach'
	elif command -v xclip >/dev/null 2>&1; then
		echo 'xclip -selection clipboard -quiet 2>/dev/null'
	else
		echo "Cannot find xsel or xclip!" >&2
		exit 1
	fi
}

define-command kaklip-push -hidden -docstring 'Push " register changes to system clipboard' %{
	echo %sh{
		{
			printf '%s' "$kak_main_reg_dquote" | eval "$kak_opt_kaklip_cmd" -i &
			while [ -e /tmp/kaklip_pushing ]; do :; done
			>/tmp/kaklip_pushing
			wait
			rm /tmp/kaklip_pushing
		} >&- 2>&- <&- &
	}
}

define-command kaklip-pull -hidden -docstring 'Pull system clipboard changes to " register' %{
	eval -no-hooks %sh{
		[ -e /tmp/kaklip_pushing ] || echo 'reg dquote %sh{eval "$kak_opt_kaklip_cmd" -o}'
	}
}

hook global RegisterModified '"' kaklip-push
hook global FocusIn .* kaklip-pull
hook global KakBegin .* kaklip-pull

§

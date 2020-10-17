# kaklip

kaklip synchronizes Kakoune's `"` register with the X11 clipboard.
There are other plugins for clipboard integration, however kaklip addresses some issues that the alternatives do not:

- Unlike [clipboard.kak], kaklip uses the default register, rather than a specific "OS clipboard" register
- Unlike both [clipboard.kak] and [kakboard], kaklip properly handles multiple selections

[clipboard.kak]: https://github.com/Parasrah/clipboard.kak
[kakboard]: https://github.com/lePerdu/kakboard

## Multiple selections

I stated above that kaklip "properly handles multiple selections".
What did I mean by this?

Kakoune, as you probably know, supports multiple selections.
When you copy text from multiple selections, it stores each selection separately in the chosen register (`"` by default).
X11, on the other hand, only supports storing a single piece of text in the clipboard.

The simplest solution to this problem is to only synchronize the main selection to the system clipboard.
However, when the system clipboard is synchronized back to Kakoune, this also removes those selections from Kakoune's copy of the clipboard.
kaklip solves this problem by keeping track of where the current clipboard data comes from, and only synchronizing to Kakoune when necessary.

## Installation

The recommended way to use kaklip is using [plug.kak]:

```kak
plug "vktec/kaklip"
```

Alternatively, you can copy `rc/kaklip.kak` to your autoload.

[plug.kak]: https://github.com/robertmeta/plug.kak

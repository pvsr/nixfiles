# pylint: disable=C0111
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401

config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103

c.aliases = {
    "q": "quit",
    "w": "session-save",
    "wq": "quit --save",
    "x": "quit --save",
    "h": "help",
}

c.confirm_quit = ["downloads"]

c.new_instance_open_target = "tab-silent"
c.new_instance_open_target_window = "last-focused"

c.window.hide_decoration = False

def terminal(*args):
    return ["ghostty", "-e", *args]

c.editor.command = terminal("hx", "{file}:{line}:{column0}")
c.fileselect.handler = "external"
c.fileselect.single_file.command = terminal("ranger", "--choosefile={}")
c.fileselect.multiple_files.command = terminal("ranger", "--choosefiles={}")
c.fileselect.folder.command = terminal("ranger", "--choosedir={}")

c.auto_save.session = True

c.content.autoplay = False
c.content.pdfjs = True

c.completion.open_categories = ["quickmarks", "bookmarks", "history", "filesystem"]
c.completion.shrink = True
c.completion.scrollbar.width = 0
c.completion.scrollbar.padding = 0

c.hints.auto_follow = "always"
c.hints.mode = "letter"

c.tabs.background = True
c.tabs.favicons.scale = 0.9
c.tabs.last_close = "close"
c.tabs.mode_on_change = "restore"
c.tabs.show = "multiple"
c.tabs.indicator.width = 0
c.tabs.padding = { "bottom": 4, "left": 3, "right": 3, "top": 4 }

c.url.open_base_url = True

c.fonts.default_size = "14pt"
c.fonts.hints = "bold 13pt default_family"
c.fonts.prompts = "13pt sans_serif"

config.bind("<Ctrl-w>", "rl-rubout ' /'", mode="command")
config.bind("<Ctrl-w>", "rl-rubout ' /'", mode="prompt")

config.bind("<Ctrl+e>", "cmd-run-with-count 2 scroll down")
config.bind("<Ctrl+y>", "cmd-run-with-count 2 scroll up")
config.bind("ge", "scroll-to-perc")

config.bind("xp", "open -b -- {clipboard}")
config.bind("xP", "open -b -- {primary}")

config.bind(",d", "hint all delete")
config.bind(",r", "cmd-set-text :open {url:domain}/")
config.bind(",R", "cmd-set-text :open -t {url:domain}/")
config.bind(";X", "hint links spawn -dv mpv --profile=no-term {hint-url}")
config.bind(";x", "hint links spawn -dv umpv --profile=no-term {hint-url}")
config.bind("xX", "spawn -dv mpv --profile=no-term {url}")
config.bind("xx", "spawn -dv umpv --profile=no-term {url}")

config.bind("pw", "open https://en.wikipedia.org/wiki/Special:Search?search={primary}")
config.bind("Pw", "open -t https://en.wikipedia.org/wiki/Special:Search?search={primary}")
config.bind("PW", "open -b https://en.wikipedia.org/wiki/Special:Search?search={primary}")

QUTE_PASS_CMD = (
    "qute-pass --username-target secret "
    "--username-pattern '(?:username|email): (.+)' "
    "--dmenu-invocation 'fuzzel --dmenu'"
)
config.bind("zl", f"spawn --userscript {QUTE_PASS_CMD}")
config.bind("zpl", f"spawn --userscript {QUTE_PASS_CMD} --password-only")
config.bind("zul", f"spawn --userscript {QUTE_PASS_CMD} --username-only")

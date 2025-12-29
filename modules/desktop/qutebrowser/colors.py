# pylint: disable=C0111
from qutebrowser.config.configfiles import ConfigAPI  # noqa: F401
from qutebrowser.config.config import ConfigContainer  # noqa: F401

config: ConfigAPI = config  # noqa: F821 pylint: disable=E0602,C0103
c: ConfigContainer = c  # noqa: F821 pylint: disable=E0602,C0103

dark0_hard = "#1d2021"
dark0 = "#282828"
dark0_soft = "#32302f"
dark1 = "#3c3836"
dark2 = "#504945"
dark3 = "#665c54"
dark4 = "#7c6f64"

gray = "#928374"

light0_hard = "#f9f5d7"
light0 = "#fbf1c7"
light0_soft = "#f2e5bc"
light1 = "#ebdbb2"
light2 = "#d5c4a1"
light3 = "#bdae93"
light4 = "#a89984"

bright_red = "#fb4934"
bright_green = "#b8bb26"
bright_yellow = "#fabd2f"
bright_blue = "#83a598"
bright_purple = "#d3869b"
bright_aqua = "#8ec07c"
bright_orange = "#fe8019"

neutral_red = "#cc241d"
neutral_green = "#98971a"
neutral_yellow = "#d79921"
neutral_blue = "#458588"
neutral_purple = "#b16286"
neutral_aqua = "#689d6a"
neutral_orange = "#d65d0e"

faded_red = "#9d0006"
faded_green = "#79740e"
faded_yellow = "#b57614"
faded_blue = "#076678"
faded_purple = "#8f3f71"
faded_aqua = "#427b58"
faded_orange = "#af3a03"


def hexColorToDecStr(color):
    num = int(color[1:], 16)
    b = num & 0xFF
    g = (num & (0xFF << 8)) >> 8
    r = (num & (0xFF << 16)) >> 16
    return str(r) + ", " + str(g) + ", " + str(b)


c.colors.completion.even.bg = dark0
c.colors.completion.odd.bg = dark1
c.colors.completion.fg = [bright_green, light3, neutral_orange]
c.colors.completion.match.fg = bright_red

c.colors.completion.category.bg = (
    "qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 " + gray + ", stop:1 " + dark2 + ")"
)
c.colors.completion.category.fg = light1
c.colors.completion.category.border.top = dark1
c.colors.completion.category.border.bottom = dark0

c.colors.completion.item.selected.bg = bright_yellow
c.colors.completion.item.selected.fg = dark0
c.colors.completion.item.selected.border.top = neutral_yellow
c.colors.completion.item.selected.border.bottom = neutral_yellow
c.colors.completion.item.selected.match.fg = faded_red

c.colors.completion.scrollbar.bg = dark1
c.colors.completion.scrollbar.fg = light1

c.colors.downloads.bar.bg = dark0
c.colors.downloads.error.bg = neutral_red
c.colors.downloads.error.fg = light1
c.colors.downloads.start.bg = faded_blue
c.colors.downloads.start.fg = light1
c.colors.downloads.stop.bg = faded_green
c.colors.downloads.stop.fg = light1
c.colors.downloads.system.bg = "rgb"
c.colors.downloads.system.fg = "rgb"

c.colors.hints.bg = (
    "qlineargradient(x1:0, y1:0, x2:0, y2:1,"
    + " stop:0 rgba("
    + hexColorToDecStr(light1)
    + ", 0.8),"
    + " stop:1 rgba("
    + hexColorToDecStr(light4)
    + ", 0.8))"
)
c.colors.hints.fg = dark0
c.colors.hints.match.fg = neutral_green

c.colors.keyhint.bg = "rgba(" + hexColorToDecStr(dark0) + ", 80%)"
c.colors.keyhint.fg = light1
c.colors.keyhint.suffix.fg = bright_yellow

c.colors.messages.error.bg = neutral_red
c.colors.messages.error.border = faded_red
c.colors.messages.error.fg = light1

c.colors.messages.info.bg = dark0
c.colors.messages.info.border = dark1
c.colors.messages.info.fg = light1

c.colors.messages.warning.bg = neutral_orange
c.colors.messages.warning.border = faded_orange
c.colors.messages.warning.fg = light1

c.colors.prompts.fg = light1
c.colors.prompts.bg = dark1
c.colors.prompts.selected.fg = bright_yellow
c.colors.prompts.selected.bg = dark2
c.colors.prompts.border = "1px solid " + gray

c.colors.statusbar.normal.bg = dark0
c.colors.statusbar.normal.fg = light1

c.colors.statusbar.private.bg = dark1
c.colors.statusbar.private.fg = light1

c.colors.statusbar.progress.bg = light1

c.colors.statusbar.caret.bg = faded_purple
c.colors.statusbar.caret.fg = light1
c.colors.statusbar.caret.selection.bg = neutral_purple
c.colors.statusbar.caret.selection.fg = light1

c.colors.statusbar.command.bg = dark0
c.colors.statusbar.command.fg = light1

c.colors.statusbar.command.private.bg = dark2
c.colors.statusbar.command.private.fg = light1

c.colors.statusbar.insert.bg = faded_green
c.colors.statusbar.insert.fg = light1

c.colors.statusbar.passthrough.bg = faded_blue
c.colors.statusbar.passthrough.fg = light1

c.colors.statusbar.url.fg = light1
c.colors.statusbar.url.success.http.fg = c.colors.statusbar.url.fg
c.colors.statusbar.url.success.https.fg = bright_green
c.colors.statusbar.url.hover.fg = bright_blue
c.colors.statusbar.url.warn.fg = neutral_yellow
c.colors.statusbar.url.error.fg = bright_orange

c.colors.tabs.bar.bg = dark2
c.colors.tabs.indicator.error = bright_red
c.colors.tabs.indicator.start = neutral_blue
c.colors.tabs.indicator.stop = neutral_green
c.colors.tabs.indicator.system = "rgb"

c.colors.tabs.even.bg = dark0
c.colors.tabs.even.fg = light1
c.colors.tabs.odd.bg = dark0
c.colors.tabs.odd.fg = light1
c.colors.tabs.selected.even.bg = dark2
c.colors.tabs.selected.even.fg = light1
c.colors.tabs.selected.odd.bg = dark2
c.colors.tabs.selected.odd.fg = light1

c.colors.tabs.pinned.even.bg = dark1
c.colors.tabs.pinned.even.fg = light1
c.colors.tabs.pinned.odd.bg = dark1
c.colors.tabs.pinned.odd.fg = light1
c.colors.tabs.pinned.selected.even.bg = c.colors.tabs.selected.even.bg
c.colors.tabs.pinned.selected.even.fg = c.colors.tabs.selected.even.fg
c.colors.tabs.pinned.selected.odd.bg = c.colors.tabs.selected.odd.bg
c.colors.tabs.pinned.selected.odd.fg = c.colors.tabs.selected.odd.fg

c.colors.webpage.bg = ""
c.colors.webpage.preferred_color_scheme = "dark"

# ┌────────────────────┐
# │░▄▀▄░▀█▀░▀█▀░█░░░█▀▀│
# │░█\█░░█░░░█░░█░░░█▀▀│
# │░░▀\░░▀░░▀▀▀░▀▀▀░▀▀▀│
# └────────────────────┘
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import os, subprocess

mod = "mod4"
terminal = "kitty"
# Colorscheme (the best one)
dracula = {
    "red": "#ff5555",
    "select": "#6272a4",
    "purple": "#bd93f9",
    "fg": "f8f8f2",
    "yellow": "#f1fa8c",
    "bg": "#282a36",
    "cyan": "#8be9fd",
    "green": "#50fa7b",
    "grey": "#44475a"
}


keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.layout.next(), desc="Focus next window"),
    Key([mod, "shift"], "Tab", lazy.layout.previous(), desc="Focus previous window"),
    # Move windows between left/right columns or move up/down in current stack.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "space", lazy.window.toggle_floating(), desc="Float window"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "shift"], "e", lazy.spawn("/home/aman/.local/bin/eww open --toggle powermenu"), desc="Powermenu"),
    Key([mod], "r", lazy.spawn("rofi -show combi -disable-history"), desc="Rofi"), # Rofi
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Fullscreen window"),
    # Volume Control
    Key([],"XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%")),
    Key([],"XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%")),
    Key([],"XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
]

# Groups
groups = [
    Group("1", matches = [Match(wm_class="brave-browser")], label = "", layout = "max"),
    Group("2", matches = [Match(wm_class=["kitty","kate"])], label = "",),
    Group("3", matches = [Match(wm_class="deadbeef")], label = "" ,),
    Group("4"),
    Group("5", matches = [Match(wm_class="Steam")], label = "",layout = "max"),
]
for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])

# Layouts
layout_themes = {
    'border_width': 3,
    'border_focus': dracula['select'],
    'border_normal': dracula['bg'],
    'margin': 3,
}
layouts = [
    layout.MonadTall(**layout_themes,ratio=0.6,max_ratio=0.8,min_ratio=0.3),
    layout.TreeTab(panel_width=103,fontsize=10,previous_on_rm=True,vspace=-1,padding_x=0,font='JetbrainsMonoSemibold',margin_x=0,
                   sections=['Windows'],section_left=25,
                   # Colors
                   **layout_themes,
                   active_bg=dracula['select'],inactive_bg=dracula['grey'],bg_color=dracula['grey'],urgent_bg=dracula['red'],urgent_fg=dracula['fg'],
                   active_fg=dracula['fg'],inactive_fg=dracula['fg'],section_fg=dracula['fg'],),
    layout.Max(**layout_themes)
    # layout.Stack(num_stacks=1,**layout_themes),
    # layout.VerticalTile(),
    # layout.Zoomy(),
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
]
floating_layout = layout.Floating(**layout_themes,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)


# Widgets
widget_defaults = dict(
    font="JetbrainsMonoNerdFont",
    fontsize=12,
    padding=3,
    background=dracula['bg'],
    foreground=dracula['fg'],
)
extension_defaults = widget_defaults.copy()
screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(
                    border_width=2,disable_drag=True,padding=2,hide_unused=True,highlight_method="line",
                    highlight_color=[dracula['grey'],dracula['grey']],inactive=dracula['fg'],this_current_screen_border=dracula['purple'],urgent=dracula['red']),
                widget.WindowName(
                    fontsize=11,font='JetbrainsMonoNerdFont'),
                widget.TextBox(text='',padding=0,foreground=dracula['purple']),
                widget.TextBox(
                    text='ewwidgets',foreground=dracula['bg'],background=dracula['purple'],
                    mouse_callbacks={'Button1': lazy.spawn('/home/aman/.local/bin/eww open-many --toggle stats music apps keybind')}),
                widget.TextBox(text='',padding=0,foreground=dracula['bg'],background=dracula['purple']),
                widget.HDDGraph(
                    border_color=dracula['cyan'],border_width=1,fill_color=dracula['select'],graph_color=dracula['select']),
                widget.TextBox(text='',padding=0,foreground=dracula['select']),
                widget.Memory(
                    format='RAM:{MemUsed:.0f}{mm}/{MemTotal:.0f}{mm}',background=dracula['select']),
                widget.TextBox(text='',padding=0,foreground=dracula['bg'],background=dracula['select']),
                widget.PulseVolume(
                    fmt='{}',step=1,),
                widget.TextBox(text='',padding=0,foreground=dracula['green']),
                widget.Battery(
                    format="{char}{percent:1.0%}",charge_char="",discharge_char="",full_char='',background=dracula['green'],low_background=dracula['red'], foreground=dracula['bg'],update_interval=5,),
                widget.TextBox(text='',padding=0,background=dracula['green'],foreground=dracula['bg']),
                widget.Clock(
                    format='%-d|%b|%Y(%a) %H:%M:%S',foreground=dracula['cyan']),
                widget.Sep(
                    foreground=dracula['fg']),
                widget.Systray(
                    padding=2,icon_size=18,),
                #widget.Sep(
                #    foreground=dracula['fg'],padding=20),
                widget.CurrentLayoutIcon(
                    scale=0.55)],
            24,
            background=dracula['bg'],
            foreground=dracula['fg'],
            border_width=[2, 2, 2, 2],
            border_color=[dracula['cyan'], dracula['cyan'], dracula['cyan'], dracula['cyan']],
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

auto_minimize = True
wl_input_rules = None
wmname = "LG3D"

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

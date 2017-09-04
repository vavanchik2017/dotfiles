-- Create cache folder
io.popen("mkdir -p ${HOME}/.cache/awesome")

-- Locale
os.setlocale("en_US.UTF-8")

-- Include libraries
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox") -- Widget and layout library
local beautiful = require("beautiful") -- Theme handling library
local naughty = require("naughty") -- Notification library
local menubar = require("menubar")
local vicious = require("vicious") -- sudo pacman -S vicious
local lain = require("lain") -- packer -S lain-git

-- Error handling
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop
		if in_error then return end
		in_error = true
		naughty.notify({ preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = err })
		in_error = false
	end)
end

-- Variable definitions
-- Theme
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/main/theme.lua")
-- Remap Mod4 to another key using xmodmap or other tools ((if it is needed).
modkey = "Mod4"
-- Main variables
terminal = "terminator"
filemanager = "pcmanfm"
browser = "chromium"
editor = "vim"
editor_cmd = "vim"
--steam = os.execute("pgrep -u $USER -x steam || (ulimit -n 4096 && steam -silent &)")

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts = {
	awful.layout.suit.floating,
	--awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	--awful.layout.suit.tile.top,
	--awful.layout.suit.fair,
	--awful.layout.suit.fair.horizontal,
	--awful.layout.suit.spiral,
	--awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	--awful.layout.suit.max.fullscreen,
	--awful.layout.suit.magnifier
}

-- Wallpaper
if beautiful.wallpaper then
	for s = 1, screen.count() do
		gears.wallpaper.maximized(beautiful.wallpaper, s, true)
	end
end

-- Tags
tags = {}
for s = 1, screen.count() do
	tags[s] = awful.tag({ "α", "β", "γ", "δ", "ε", "ζ" }, s, { layouts[1], layouts[1], layouts[1], layouts[1], layouts[1], layouts[1] })
end

-- Create a laucher widget and a main menu
myawesomemenu = {
	{ "steam", steam },
	{ "restart", awesome.restart },
	{ "quit", awesome.quit }
}

mymainmenu = awful.menu({
	items = {
		{ "Awesome Settings", myawesomemenu, beautiful.awesome_icon }
	}
})

mylauncher = awful.widget.launcher({
	menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- Wibox {
-- Create a textclock widget
mytextclock = awful.widget.textclock("%H:%M")

-- Calendar
--lain.widgets.calendar:attach(mytextclock)

-- Memory
memicon = wibox.widget.imagebox()
memicon:set_image(beautiful.widget_mem)
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, "$2MB", 13)

-- Memory bar
memwidget2 = awful.widget.progressbar()
memwidget2:set_width(8)
memwidget2:set_height(10)
memwidget2:set_vertical(true)
memwidget2:set_background_color("#494B4F")
memwidget2:set_border_color(nil)
memwidget2:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#AECF96"}, {0.5, "#88A175"}, {1, "#FF5656" }}})
vicious.register(memwidget2, vicious.widgets.mem, "$1", 13)

-- CPU
cpuicon = wibox.widget.imagebox()
cpuicon:set_image(beautiful.widget_cpu)
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "$1%")

-- CPU bar
cpuwidget2 = awful.widget.graph()
cpuwidget2:set_width(5)
cpuwidget2:set_background_color("#494B4F")
cpuwidget2:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#FF5656"}, {0.5, "#88A175"}, {1, "#AECF96" }}})
vicious.register(cpuwidget2, vicious.widgets.cpu, "$1")

-- Separator
separator = wibox.widget.textbox()
separator2 = wibox.widget.textbox()
separator:set_text("  ")
separator2:set_text(" ")

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
	awful.button({ }, 1, awful.tag.viewonly),
	awful.button({ modkey }, 1, awful.client.movetotag),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, awful.client.toggletag),
	awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
	awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
	awful.button({ }, 1, function (c)
		if c == client.focus then
			c.minimized = true
		else
			-- Without this, the following
			-- :isvisible() makes no sense
			c.minimized = false
		if not c:isvisible() then
			awful.tag.viewonly(c:tags()[1])
		end
		-- This will also un-minimize
		-- the client, if needed
		client.focus = c
		c:raise()
	end
end),
awful.button({ }, 3, function (c)
	c:kill()
end),
awful.button({ }, 4, function ()
	awful.client.focus.byidx(1)
	if client.focus then client.focus:raise() end
end),
awful.button({ }, 5, function ()
	awful.client.focus.byidx(-1)
	if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do
	-- Create a promptbox for each screen
	mypromptbox[s] = awful.widget.prompt()
	-- Create an imagebox widget which will contains an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	mylayoutbox[s] = awful.widget.layoutbox(s)
	-- Create a taglist widget
	mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

	-- Create a tasklist widget
	mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

	-- Create the wibox
	mywibox[s] = awful.wibox({ position = "top", screen = s })

	-- Widgets that are aligned to the left
	local left_layout = wibox.layout.fixed.horizontal()
	left_layout:add(mylauncher)
	left_layout:add(mytaglist[s])
	left_layout:add(separator2)
	left_layout:add(mypromptbox[s])

	-- Widgets that are aligned to the right
	local right_layout = wibox.layout.fixed.horizontal()
	if s == 1 then right_layout:add(wibox.widget.systray()) end
	right_layout:add(separator)
	right_layout:add(memwidget)
	right_layout:add(separator)
	right_layout:add(cpuwidget)
	-- right_layout:add(cpuwidget2)
	right_layout:add(separator)
	right_layout:add(mytextclock)
	right_layout:add(mylayoutbox[s])

	-- Now bring it all together (with the tasklist in the middle)
	local layout = wibox.layout.align.horizontal()
	layout:set_left(left_layout)
	layout:set_middle(mytasklist[s])
	layout:set_right(right_layout)

	mywibox[s]:set_widget(layout)
end
-- } Wibox

-- Mouse bindings
root.buttons(awful.util.table.join(
	awful.button({ }, 3, function () mymainmenu:toggle() end)
	--awful.button({ }, 4, awful.tag.viewnext),
	--awful.button({ }, 5, awful.tag.viewprev)
))

-- Key bindings {
globalkeys = awful.util.table.join(
	awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
	awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
	awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
	awful.key({ modkey,           }, "j",
		function ()
			awful.client.focus.byidx( 1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,           }, "k",
		function ()
			awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
		end),
	awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
	awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
	awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
	awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
	awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
	awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
	awful.key({ modkey,           }, "Tab",
		function ()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end),

	-- Media keys
	awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer set Master 5%+") end),
	awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer set Master 5%-") end),
	awful.key({ }, "XF86AudioMute", function () awful.util.spawn("amixer sset Master toggle") end),

	-- Media keys: cmus
	--awful.key({}, "#173", function () awful.util.spawn_with_shell('cmus-remote -r') end),
	--awful.key({}, "#172", function () awful.util.spawn_with_shell('cmus-remote -u') end),
	--awful.key({}, "#171", function () awful.util.spawn_with_shell('cmus-remote -n') end),
	--awful.key({}, "#174", function () awful.util.spawn_with_shell('cmus-remote -s') end),

	-- Standard program
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
	awful.key({ modkey,           }, "i", function () awful.util.spawn(filemanager) end),
	awful.key({ modkey, "Control" }, "r", awesome.restart),
	--awful.key({ modkey, "Shift"   }, "q", awesome.quit),

	awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
	awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
	awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
	awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
	awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
	awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
	awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
	awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

	awful.key({ modkey, "Control" }, "n", awful.client.restore),

	-- Prompt
	awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

	awful.key({ modkey }, "x",
		function ()
			awful.prompt.run({ prompt = "Run Lua code: " },
			mypromptbox[mouse.screen].widget,
			awful.util.eval, nil,
			awful.util.getdir("cache") .. "/history_eval")
		end),

	-- Menubar
	awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
	awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
	awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
	awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
	awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
	awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
	awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
	awful.key({ modkey,           }, "n",
		function (c)
			-- The client currently has the input focus, so it cannot be
			-- minimized, since minimized clients can't have the focus.
			c.minimized = true
		end),
	awful.key({ modkey,           }, "m",
		function (c)
			c.maximized_horizontal = not c.maximized_horizontal
			c.maximized_vertical   = not c.maximized_vertical
		end)
)

-- Bind all key numbers to tags.
for i = 1, 9 do
	globalkeys = awful.util.table.join(globalkeys,
		-- View tag only.
		awful.key({ modkey,           }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				local tag = awful.tag.gettags(screen)[i]
				if tag then
					awful.tag.viewonly(tag)
				end
			end),
		-- Toggle tag.
		awful.key({ modkey, "Control" }, "#" .. i + 9,
			function ()
				local screen = mouse.screen
				local tag = awful.tag.gettags(screen)[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end),
		-- Move client to tag.
		awful.key({ modkey, "Shift"  }, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = awful.tag.gettags(client.focus.screen)[i]
					if tag then
						awful.client.movetotag(tag)
					end
				end
			end),
		-- Toggle tag.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
			function ()
				if client.focus then
					local tag = awful.tag.gettags(client.focus.screen)[i]
					if tag then
						awful.client.toggletag(tag)
					end
				end
			end))
end

clientbuttons = awful.util.table.join(
	awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
	awful.button({ modkey }, 1, awful.mouse.client.move),
	awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- } Key bindings

-- Rules {
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{ rule = { },
	callback = function(c)
		c.maximized, c.maximized_vertical, c.maximized_horizontal = false, false, false
	end,
	properties = { border_width = beautiful.border_width,
	border_color = beautiful.border_normal,
	focus = awful.client.focus.filter,
	raise = true,
	keys = clientkeys,
	buttons = clientbuttons } },
}
-- } Rules

-- Signals {
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
	-- Enable sloppy focus
	--c:connect_signal("mouse::enter", function(c)
		--if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			--and awful.client.focus.filter(c) then
			--client.focus = c
		--end
	--end)

	if not startup then
		-- Set the windows at the slave,
		--i.e. put it at the end of others instead of setting it master.
		--awful.client.setslave(c)

		-- Put windows in a smart way, only if they does not set an initial position.
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end

	local titlebars_enabled = false
	if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
		-- buttons for the titlebar
		local buttons = awful.util.table.join(
			awful.button({ }, 1, function()
				client.focus = c
				c:raise()
				awful.mouse.client.move(c)
			end),
			awful.button({ }, 3, function()
				client.focus = c
				c:raise()
				awful.mouse.client.resize(c)
			end)
		)

		-- Widgets that are aligned to the left
		local left_layout = wibox.layout.fixed.horizontal()
		left_layout:add(awful.titlebar.widget.iconwidget(c))
		left_layout:buttons(buttons)

		-- Widgets that are aligned to the right
		local right_layout = wibox.layout.fixed.horizontal()
		right_layout:add(awful.titlebar.widget.floatingbutton(c))
		right_layout:add(awful.titlebar.widget.maximizedbutton(c))
		right_layout:add(awful.titlebar.widget.stickybutton(c))
		right_layout:add(awful.titlebar.widget.ontopbutton(c))
		right_layout:add(awful.titlebar.widget.closebutton(c))

		-- The title goes in the middle
		local middle_layout = wibox.layout.flex.horizontal()
		local title = awful.titlebar.widget.titlewidget(c)
		title:set_align("center")
		middle_layout:add(title)
		middle_layout:buttons(buttons)

		-- Now bring it all together
		local layout = wibox.layout.align.horizontal()
		layout:set_left(left_layout)
		layout:set_right(right_layout)
		layout:set_middle(middle_layout)

		awful.titlebar(c):set_widget(layout)
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- } Rules

-- Functions to help launch run commands in a terminal using ":" keyword
function check_for_terminal (command)
	if command:sub(1,1) == ":" then
		command = terminal .. ' -e "' .. command:sub(2) .. '"'
	end
	awful.util.spawn(command)
end

-- User apps autostart
os.execute("pgrep -u $USER -x screencloud || (screencloud &)")
os.execute("pgrep -u $USER -x compton || (compton --backend glx --vsync opengl-swc -G &)")
os.execute("pgrep -u $USER -x redshift-gtk || (redshift-gtk &)")
os.execute("pgrep -u $USER -x steam || (ulimit -n 4096 && steam -silent &)")
os.execute("pgrep -u $USER -x psi-plus || (psi-plus &)")
os.execute("pgrep -u $USER -x Telegram || (/home/noirhat/opt/telegram/Telegram &)")
os.execute("pgrep -u $USER -x quiterss || (quiterss &)")
os.execute("pgrep -u $USER -x 'bash ./bot.sh -n' || (terminator --command='cd /home/noirhat/projects/bot_developershelper; ./bot.sh -n' &)")
--os.execute("pgrep -u $USER -x calibre-server || (calibre-server &)")

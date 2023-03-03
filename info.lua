t = ...  -- Required for this info file to work.

t.shortname = "Future"  -- The name that will be displayed on the button in the plugins list. Should be no longer than 21 characters, or it will be wider than the button.
t.longname = "Future"  -- This can be about twice as long
t.author = "AllyTally"  -- Your name
t.version = "1.0-alpha"  -- The current version of this plugin, can be anything you want
t.minimumved = "1.10.0"  -- The minimum version of Ved this plugin is designed to work with. If unsure, just use the latest version.
t.description = [[
Support for VVVVVV PRs which may or may not get merged in the future.
]]  -- The description that will be displayed in the plugins list. This uses the help/notepad system, so you can use text formatting here, and even images!
future_path = t.internal_pluginpath .. "/"
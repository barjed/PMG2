-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Hide the status bar
display.setStatusBar(display.HiddenStatusBar);

local storyboard = require "storyboard";

-- load mainmenu.lua
storyboard.gotoScene( "code/battle" );

-- Add any objects that should appear on all scenes below (e.g. ta
-- -- b bar, hud, etc.):

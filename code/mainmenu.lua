----------------------------------------------------------------------------------
--
-- mainmenu.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" );
local scene = storyboard.newScene();

local widget = require "widget";

----------------------------------------------------------------------------------
-- 
--	NOTE:
--	
--	Code outside of listener functions (below) will only be executed once,
--	unless storyboard.removeScene() is called.
-- 
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local onStart = function(e)
	if e.phase == "release" then
		storyboard.gotoScene( "cutscene" );
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view;
	
	-- content size variables
	local _W = display.contentWidth; local _H = display.contentHeight;
	
	-- new group for holding the Menu Elements
	local mainMenu = display.newGroup();
	-- mainMenu:setReferencePoint(display.CenterReferencePoint);
	
	-- main menu items
	local plhWelcomeText = display.newText("PixMilk Game #2", 0, 0, native.systemFont, 24*2);
	plhWelcomeText:setReferencePoint(display.CenterReferencePoint);
	plhWelcomeText.xScale = .5; plhWelcomeText.yScale = .5;
	
	local plhBuildNumber = display.newText("build 001", 0, 0, native.systemFont, 14*2);
	plhBuildNumber:setReferencePoint(display.CenterReferencePoint);
	plhBuildNumber.xScale = .5; plhBuildNumber.yScale = .5;
	
	local startButton = widget.newButton{
		id = "startBtn",
		left = 0, top = 0,
		label = "Start Game",
		width = 124, height = 42,
		cornerRadius = 8,
		onEvent = onStart
	}
	
	local debugButton = widget.newButton{
		id = "debugBtn",
		left = 0, top = 0,
		label = "Debug",
		width = 124, height = 42,
		cornerRadius = 8
	}

	-- populate the groups
	-- mainMenu:insert(plhWelcomeText);
	-- mainMenu:insert(plhBuildNumber);
	mainMenu:insert(startButton.view);
	mainMenu:insert(debugButton.view);
	
	-- position the elements
	plhWelcomeText.x = _W / 2; plhWelcomeText.y = _H / 2;
	plhBuildNumber.x = _W / 2; plhBuildNumber.y = (_H / 2) + 20;
	
	debugButton.y = 70;
	
	-- position the groups
	mainMenu.x = (_W / 2) - 60; mainMenu.y = _H - ( _H / 3);
	-----------------------------------------------------------------------------
		
	--	CREATE display objects and add them to 'group' here.
	--	Example use-case: Restore 'group' from previously saved state.
	
	-----------------------------------------------------------------------------
	
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
		
	--	INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)
	
	-----------------------------------------------------------------------------
	
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	local group = self.view
	
	-----------------------------------------------------------------------------
	
	--	INSERT code here (e.g. remove listeners, widgets, save state, etc.)
	
	-----------------------------------------------------------------------------
	display.remove(startButton);
	display.remove(debugButton);
	plhWelcomeText:removeSelf();
	plhDebugtext:removeSelf();
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene
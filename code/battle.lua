----------------------------------------------------------------------------------
--
-- battle.lua
--
----------------------------------------------------------------------------------

local storyboard = require( "storyboard" );
local json = require("json");
local jtools = require("code/jsonTools");
local backgrounds = require("code/battleBackground")
local tiles = require("code/battleTiles");
local guis = require("code/battleGui");
local entities = require ("code/battleEntity");
local TextCandy = require("code/lib_text_candy");

local _W = display.contentWidth;
local _H = display.contentHeight;
local battleConfig, background, tilemap, battleGui;
local backgroundGroup, tileGroup, entitiesGroup, effectsGroup, guiGroup;

local battleEntities;
local battleTiles = {};
local scene = storyboard.newScene();

-- INPUT STATES
local inputState = "NONE";
local inputFocus;


-- Called when the scene's view does not exist:
function scene:createScene( event )
    local group = self.view

    -- load the battle data form a JSON file
    battleConfig = json.decode(jtools.jsonFile("data/battles/battleconfig.json"));

    -- create the groups which act as layers (z-index)
    backgroundGroup = display.newGroup();
    tileGroup = display.newGroup();
    entitiesGroup = display.newGroup();
    effectsGroup = display.newGroup();
    guiGroup = display.newGroup();

    -- insert all of the groups into the parent storyboard group
    group:insert(backgroundGroup);
    group:insert(tileGroup);
    group:insert(entitiesGroup);
    group:insert(effectsGroup);
    group:insert(guiGroup);

    -- create the background
    background = backgrounds.new(battleConfig.background.default);
    backgroundGroup:insert(background);

    -- create the base tilemap
    tilemap = tiles.newTilemap(battleTiles, tileGroup);

    -- create the entities
    battleEntities = entities.new(battleConfig.sprite.charA.idlerun);

    -- create the gui
    battleGui = guis.new(guiGroup);

end

-- Event handling function block

-- a tile is touched
local function tileClick(e)
    if(e.phase == "ended") then
        if(inputState == "MOVE") then
            entities.move(battleEntities, e.target, entitiesGroup, battleTiles);
        end
    end

    return true;
end

-- a gui element is touched
local function guiClick(e)
    if(e.phase == "ended") then
        if(e.target.id == "move") then
            inputState = "MOVE";
            inputFocus = e.target;
            tiles.highlightMovable(battleTiles, battleEntities.column, battleEntities.row, battleEntities.moveRange);
        end

        guis.itemTouched(e.target.id, battleGui);
    end

    return true;
end

-- an entity is touched
local function entityClick(e)
    if(e.phase == "ended") then
        inputFocus = e.target;
        entities.select(e.target);
    end

    return true;
end
-- -----------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    local group = self.view

    -- add event listeners to the tiles
    for index,value in pairs(battleTiles) do
        for i,v in pairs(value) do
            if(v ~= 0) then
                v:addEventListener("touch", tileClick);
            end
        end
    end

    -- add event listeners to the buttons
    for index,value in pairs(battleGui) do
        value.button:addEventListener("touch", guiClick);
    end

    -- add event listeners to the entities
    battleEntities:addEventListener("touch", entityClick);
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
    local group = self.view

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
    local group = self.view

end


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

return scene
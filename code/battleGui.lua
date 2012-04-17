------------------------------------------------------------------------------------
--
-- battleGui.lua
--
----------------------------------------------------------------------------------
module(..., package.seeall);

local _W = display.contentWidth;
local _H = display.contentHeight;
local json = require("json");
local TextCandy = require("code/lib_text_candy");
local jtools = require("code/jsonTools");

local guiConfig;

local function createActionMenu(gui, group)
    -- static variable definitions
    -- define the vertical margin between the buttons
    local actionMargin = 40;

    -- define the action buttons starting x
    local actionX = 60;

    -- define the starting opacity of the action buttons
    local actionOpacity = 0.7;

    -- define the paddings of button texts
    local actionPaddingX = -50;
    local actionPaddingY = -10;

    -- allocate the memory in the dictionary
    gui["move"] = {};
    gui["attack"] = {};
    --gui["skill"] = {};
    --gui["item"] = {};

    -- load the action menu buttons and assign them
    gui["move"].button = display.newImageRect("assets/images/gui_battle_menu.png", 135, 35);
    gui["attack"].button = display.newImageRect("assets/images/gui_battle_menu.png", 135, 35);
    --gui["skill"].button = display.newImageRect("assets/images/gui_battle_menu.png", 135, 35);
    --gui["item"].button = display.newImageRect("assets/images/gui_battle_menu.png", 135, 35);


    -- position the action buttons
    gui["move"].button.x = actionX;
    gui["move"].button.y = 20;

    gui["attack"].button.x = actionX;
    gui["attack"].button.y = gui["move"].button.y + actionMargin;

    --gui["skill"].button.x = actionX;
    --gui["skill"].button.y = gui["attack"].button.y + actionMargin;

    --gui["item"].button.x = actionX;
    --gui["item"].button.y = gui["skill"].button.y + actionMargin;

    -- load the corresponding button texts
    gui["move"].text = TextCandy.CreateText({
        fontName = guiConfig.fontName,
        x = gui["move"].button.x + actionPaddingX,
        y = gui["move"].button.y + actionPaddingY,
        text = "Move",
        originX = "LEFT",
        originY = "TOP",
    });
    gui["move"].text.xScale = .5;
    gui["move"].text.yScale = .5;

    gui["attack"].text = TextCandy.CreateText({
        fontName = guiConfig.fontName,
        x = gui["attack"].button.x + actionPaddingX,
        y = gui["attack"].button.y + actionPaddingY,
        text = "Attack",
        originX = "LEFT",
        originY = "TOP",
    });
    gui["attack"].text.xScale = .5;
    gui["attack"].text.yScale = .5;

    -- set the opacity of the buttons
    gui["move"].button.alpha = actionOpacity;
    gui["attack"].button.alpha = actionOpacity;
    --gui["skill"].button.alpha = actionOpacity;
    --gui["item"].button.alpha = actionOpacity;

    -- set the additional IDs
    gui["move"].button.id = "move";
    gui["attack"].button.id = "attack";

    -- insert the buttons into the display group
    group:insert(gui["move"].button);
    group:insert(gui["attack"].button);
    --group:insert(gui["skill"].button);
    --group:insert(gui["item"].button);
end

function itemTouched(item, gui)
    if(item == "move") then
        -- fade in the selected button, fade out the rest
        transition.to(gui[item].button, {time=500, alpha=0.9});
        transition.to(gui[item].text, {time=500, alpha=0.9});
        transition.to(gui["attack"].button, {time=500, alpha=0.2});
        transition.to(gui["attack"].text, {time=500, alpha=0.2});
    end

    if(item == "attack") then
        -- fade in the selected button, fade out the rest
        transition.to(gui[item].button, {time=500, alpha=0.9});
        transition.to(gui[item].text, {time=500, alpha=0.9});
        transition.to(gui["move"].button, {time=500, alpha=0.2});
        transition.to(gui["move"].text, {time=500, alpha=0.2});
    end
end

function new(group)
    -- prepare the dictionary for the gui
    local gui = {};

    -- load default config from JSON
    guiConfig = json.decode(jtools.jsonFile("data/battles/battleconfig.json")).gui;
    TextCandy.AddVectorFont(guiConfig.fontName, "0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz'*@():,$.!-%+?;#/_", guiConfig.fontSize);

    -- create the action menu
    createActionMenu(gui, group);

    -- return the dictionary
    return gui;

end

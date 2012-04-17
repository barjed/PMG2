----------------------------------------------------------------------------------
--
-- sceneActor.lua
--
-- This class creates an ACTOR object, which represents
-- a currently speaking character in a cutscene.
--
-- Avatars have the following properties:
-- id, name, path, width, height, offsetX, offsetY, facing
--
----------------------------------------------------------------------------------
module(..., package.seeall);

local json = require("json");
local jtools = require("code/jsonTools");
local _W = display.contentWidth; local _H = display.contentHeight;

function new(params)
    -- load default avatar data from JSON
    local actorConfig = json.decode(jtools.jsonFile("data/actorconfig.json"));

    local actor;
    if (params) then
        actor = params.avatar;
    else
        return nil;
    end

    -- check if parameters are specified, if not, load defaults
    local path;
    local width;
    local height;
    local offsetX;
    local offsetY;
    local facing;
    local visible;

    -- match the actor from the default config
    local defaultActor;
    for index, act in pairs(actorConfig) do
        if (act.id == actor.id) then
            defaultActor = act;
        end
    end

    if (actor.path == nil) then
        path = "default";
    else
        path = actor.path;
    end

    if (actor.width == nil) then
        width = defaultActor.width;
    else
        width = actor.width;
    end

    if (actor.height == nil) then
        height = defaultActor.height;
    else
        height = actor.height;
    end

    if (actor.offsetX == nil) then
        offsetX = defaultActor.offsetX;
    else
        offsetX = actor.offsetX;
    end

    if (actor.offsetY == nil) then
        offsetY = defaultActor.offsetY;
    else
        offsetY = actor.offsetY;
    end

    if (actor.facing == nil) then
        facing = defaultActor.facing;
    else
        facing = actor.facing;
    end

    if (actor.visible == nil) then
        visible = "true";
    else
        visible = actor.visible;
    end

    -- match image display path
    local matchedPath;
    for index, pth in pairs(defaultActor.paths) do
        if (path == index) then
            matchedPath = pth;
        end
    end

    local newActor = display.newImageRect(matchedPath, width, height);

    newActor:setReferencePoint(display.CenterReferencePoint);
    newActor.x = width / 2 + offsetX;
    newActor.y = _H + offsetY;
    newActor.xScale = facing;

    -- prepare a dimmed version of the avatar, for cross fading
    -- since color transitions are not supported in Corona
    newActor.dimmed = display.newImageRect(matchedPath, width, height);
    newActor.dimmed:setFillColor(150, 150, 150);
    newActor.dimmed.alpha = 0;
    newActor.dimmed:setReferencePoint(display.CenterReferencePoint);
    newActor.dimmed.x = width / 2 + offsetX;
    newActor.dimmed.y = _H + offsetY;
    newActor.dimmed.xScale = facing;

    -- expose additional variables
    newActor.id = defaultActor.id;
    newActor.visible = visible;

    return newActor;
end

function update(delAct, newAct)
    delAct:removeSelf();
    delAct = nil;
    local act = new({ avatar = newAct });
    return act;
end
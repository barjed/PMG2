------------------------------------------------------------------------------------
--
-- battleEntity.lua
--
----------------------------------------------------------------------------------
module(..., package.seeall);

local tiles = require("code/battleTiles");

local _W = display.contentWidth;
local _H = display.contentHeight;

-- flag is set to true if the entity is currently moving
local entityMoving = false;
local moveTransition;
local moveLine;

-- utility methods
-- ---------------
-- creates a polyline
local function drawLine(x1, y1, x2, y2, group)
    local newLine = display.newLine(x1, y1, x2, y2);
    newLine:setColor(0, 230, 255, 190);
    newLine.width = 2;

    -- insert to the entity display group and set it back so it doesn't obscure entities
    group:insert(newLine);
    newLine:toBack();

    -- animate the line
    transition.to(newLine, {time=500, alpha=0});

    return newLine;
end

-- creates a new instance of the Entity class
function new(entity)
    local frameOptions = {};
    frameOptions.frames = {};

    -- convert JSON frame data to Sprite API frame data format
    for index,value in pairs(entity.frames) do
        local newFrame = {};
        newFrame["x"] = value.x;
        newFrame["y"] = value.y;
        newFrame["width"] = value.width;
        newFrame["height"] = value.height;
        table.insert(frameOptions.frames, index, newFrame)
    end

    frameOptions.sheetContentWidth = entity.sheetContentWidth;
    frameOptions.sheetContentHeight = entity.sheetContentHeight;

    -- create a new ImageSheet based on the loaded data
    local entitySheet = graphics.newImageSheet("assets/images/charA_idlerun.png", frameOptions);

    -- convert JSON sequence data to Sprite API sequence data format
    local sequenceData = {};

    for index,value in pairs(entity.sequences) do
        local newSequence = {};
        newSequence["name"] = value.name;
        newSequence["time"] = value.time;
        newSequence["start"] = value.start;
        newSequence["count"] = value.count;
        newSequence["loopDirection"] = value.loopDirection;
        table.insert(sequenceData, newSequence);
    end

    -- display a new sprite
    local newEntity = display.newSprite( entitySheet, sequenceData)

    -- position the sprite
    newEntity.x = _W / 2;
    newEntity.y = _H / 2;

    -- facing of the sprite
    newEntity.xScale = -1;

    -- set the initial sequence
    newEntity:setSequence("idle");

    -- play the animation
    newEntity:play();

    -- PLACEHOLDER STATS
    newEntity.moveRange = 2;
    newEntity.row = 4;
    newEntity.column = 6;

    return newEntity;
end

-- moves the Entity
function move(entity, targetTile, group, battleTiles)

    -- check if the target tile is in range
    if(targetTile.column < entity.column - entity.moveRange or targetTile.column > entity.column + entity.moveRange)
        or (targetTile.row < entity.row - entity.moveRange or targetTile.row > entity.row + entity.moveRange) then
            print("lolol")
            return false;

    end

    -- event that reverts the animation back after the movements has stopped
    local function moveCompleted(e)
        entity:setSequence("idle");
        entity:play();
        entityMoving = false;

        -- remove the move line
        moveLine:removeSelf();
        moveLine = nil;

        -- reset the tile appearance
        transition.to(targetTile, {time=500, alpha=0.5});

        -- reset the tiles highlights
        tiles.highlightNone(battleTiles);

        return true;
    end

    -- offset for correcting entities position relative to the tile
    local offsetY = -15;

    -- offset the event target coordinates
    local x = targetTile.x + 20;
    local y = targetTile.y + 40;

    -- draw a line from the entity to the origin of the touch
    moveLine = drawLine(entity.x, entity.y-offsetY, x, y, group);

    -- change the entity's facing if the touch occurred behind it's back
    if(x > entity.x and entity.xScale == 1) then
        entity.xScale = -1;
    elseif(x < entity.x and entity.xScale == -1) then
        entity.xScale = 1;
    end

    -- TODO: CREATE PATHFINDING
    local function findPath(startTile, endTile)

        -- move as far horizontally, as possible
        local endHorTile = battleTiles[startTile.row][endTile.column - 1];
    end


    -- stop the previous transition if a new touch occured before the the transition finished
    if(entityMoving) then
        transition.cancel(moveTransition);
    end

    -- animate the target tile
    transition.to(targetTile, {time=500, alpha=1})

    entity:setSequence("run");
    entity:play();
    moveTransition = transition.to(entity, {time=1000, x=x, y=y+offsetY, onComplete=moveCompleted});
    entityMoving = true;

    -- update the coordinates of the entity
    entity.row = targetTile.row;
    entity.column = targetTile.column;
end

function select(entity)
    entity:setFillColor(200,200,0);
end

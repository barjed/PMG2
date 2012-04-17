----------------------------------------------------------------------------------
--
-- battleBackground.lua
--
----------------------------------------------------------------------------------
module(..., package.seeall);

function newTilemap(array, group)
    local initialX = 0;
    local initialY = 0;
    local offsetX = 40;
    local offsetY = 35;
    local bonusOffsetX = 0;

    -- create the matrix and preload it with 0s
    for i=1,7 do
        array[i] = {}     -- create a new row
        for j=1,11 do
            array[i][j] = 0
        end
    end

    -- generate 70 tiles
    for column = 1, 11, 1 do
        for row = 1, 7, 1 do

            -- if the row is even, move to left
            if(row % 2 == 0) then
                bonusOffsetX = -20;
            else
                bonusOffsetX = 0;
            end

            -- add additional tile if we are in an even row
            if (row % 2 == 0 or row % 2 ~= 0 and column ~= 11) then
                local newTile = display.newImageRect("assets/images/tile.png", 35, 40);
                newTile.x = bonusOffsetX + initialX + offsetX * column
                newTile.y = initialY + offsetY * row;
                newTile:setReferencePoint(display.CenterReferencePoint);

                -- set the default opacity
                newTile.alpha = 0.5;

                -- add various highlighted variations
                newTile.movable = display.newImageRect("assets/images/tile_move.png", 35, 40);
                newTile.movable.x = newTile.x;
                newTile.movable.y = newTile.y;
                newTile.movable.alpha = 0;

                -- expose the matrix location
                newTile.row = row;
                newTile.column = column;

                -- insert into display group and data array
                group:insert(newTile);
                group:insert(newTile.movable)

                -- fill the matrix
                for i=1,7 do
                    for j=1,11 do
                        if(i == row and j == column) then
                            array[i][j] = newTile;
                        end
                    end
                end

            end
        end
    end

    group.x = 20;
    group.y = 40;
end

-- highlight desired tiles blue (movable)
function highlightMovable(tiles, originX, originY, range)
    for index,value in pairs(tiles) do
        for i,v in pairs(value) do
            if(v ~= 0) then
                if(v.column >= originX - range and v.column <= originX + range) then
                    if(v.row >= originY - range and v.row <= originY + range) then
                        transition.to(v.movable, {time=500, alpha=0.5})
                    end
                end
            end
        end
    end
end

-- disable all highlights
function highlightNone(tiles)
    for index,value in pairs(tiles) do
        for i,v in pairs(value) do
            if(v ~= 0) then
                transition.to(v.movable, {time=500, alpha=0})
            end
        end
    end
end





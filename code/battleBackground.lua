----------------------------------------------------------------------------------
--
-- battleBackground.lua
--
----------------------------------------------------------------------------------
module(..., package.seeall);

function new(background)
    local newBg = display.newImageRect(background.path, background.width, background.height);
    newBg.x = background.x;
    newBg.y = background.y;
    newBg:setReferencePoint(display.CenterReferencePoint);

    return newBg;
end
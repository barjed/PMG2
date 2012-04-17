----------------------------------------------------------------------------------
--
-- sceneEffect.lua
--
-- This class creates a SCENEEFFECT object
--
----------------------------------------------------------------------------------
module(..., package.seeall);

local _W = display.contentWidth; local _H = display.contentHeight;

function new(params)
    local newEffect;

    if (params.effect == "flash") then
        newEffect = display.newRect(0, 0, _W, _H);
        newEffect:setReferencePoint(display.CenterReferencePoint);
        newEffect:setFillColor(255, 255, 255);
        newEffect.alpha = 0;

        -- animate
        transition.to(newEffect, { time = 150, alpha = 1, transition = easing.inExpo });

        local function fadeOut(e)
            transition.to(newEffect, { time = 150, alpha = 0, transition = easing.OutExpo });
        end

        timer.performWithDelay(200, fadeOut);
    end

    if (params.effect == "redscreenIn") then
        newEffect = display.newRect(0, 0, _W, _H);
        newEffect:setReferencePoint(display.CenterReferencePoint);
        newEffect:setFillColor(255, 0, 0);
        newEffect.alpha = 0;

        -- animate
        transition.to(newEffect, { time = 500, alpha = .5, transition = easing.inExpo });

        local function fadeOut(e)
            transition.to(newEffect, { time = 500, alpha = 0, transition = easing.OutExpo });
        end

        timer.performWithDelay(500, fadeOut);
    end

    return newEffect;
end
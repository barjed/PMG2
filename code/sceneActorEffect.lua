----------------------------------------------------------------------------------
--
-- sceneActorEffect.lua
--
-- This class creates a SCENEACTOREFFECT object
--
----------------------------------------------------------------------------------
module(..., package.seeall);

local _W = display.contentWidth;
local _H = display.contentHeight;
local shakeFlag = "left";

function new(params)

    -- pass the incoming actor object and the effect type
    local actor;

    if (params) then
        actor = params.actor;
    else
        return nil;
    end

    if (params.effect == "fadeIn") then
        -- transition.to(actor.dimmed, {time=500, alpha=1});
        transition.to(actor, { time = 500, alpha = 1 });
    end

    if (params.effect == "fadeOut") then
        transition.to(actor.dimmed, { time = 500, alpha = 0 });
        transition.to(actor, { time = 500, alpha = 0 });
    end
    if (params.effect == "shake") then
        local shakeTimer;
        local originX = actor.x;
        local shakeTimes = 15;

        local function shake(e)
            if (e.count < shakeTimes) then
                if (shakeFlag == "left") then
                    -- shake left
                    transition.to(actor, { time = 40, x = actor.x - 5 });
                    shakeFlag = "right";
                else
                    -- shake right
                    transition.to(actor, { time = 40, x = actor.x + 5 });
                    shakeFlag = "left";
                end
            else
                actor.x = originX;
            end
        end

        shakeTimer = timer.performWithDelay(50, shake, shakeTimes);
    end
end

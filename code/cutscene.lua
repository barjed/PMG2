----------------------------------------------------------------------------------
--
-- cutscene.lua
--
----------------------------------------------------------------------------------

local TextCandy = require("code/lib_text_candy");
local storyboard = require("storyboard")
local json = require("json");
local scene = storyboard.newScene()
local avatars = require("code/sceneActor");
local texts = require("code/sceneText");
local sceneEffects = require("code/sceneEffect");
local actorEffects = require("code/sceneActorEffect");
local jtools = require("code/jsonTools");

local bg, speechbg, text, sceneData, avatarData, nextText, displayText;
local namebg, nameGroup, nameText, previousNameX, sceneGroup, actorGroup, backgroundGroup, effectGroup;

local _W = display.contentWidth;
local _H = display.contentHeight;
local actors = {};
local choices = {};
local isChoices = false;

-- begins the actual cutscene
local function beginCutscene(e)
    -- fade in the cutscene group
    transition.to(sceneGroup, { time = 500, alpha = 1 });

    -- Display first text of the table
    displayText = texts.new({ text = nextText });
    -- group:insert(displayText);
    sceneGroup:insert(displayText);
end

local function showActors(e)
    -- fade in the actors group
    transition.to(actorGroup, { time = 500, alpha = 1 });
end

-- Called when the scene's view does not exist:
function scene:createScene(event)
    local group = self.view

    -- create the groups
    -- this also determines their Z-index order
    backgroundGroup = display.newGroup();
    actorGroup = display.newGroup();
    effectGroup = display.newGroup();
    sceneGroup = display.newGroup();

    group:insert(backgroundGroup);
    group:insert(actorGroup);
    group:insert(effectGroup);
    group:insert(sceneGroup);

    -- load the scene data from a JSON file
    sceneData = json.decode(jtools.jsonFile("data/scenes/t01.json"));

    -- load the avatar data form a JSON file
    avatarData = json.decode(jtools.jsonFile("data/actorconfig.json"));

    -- background of the scene
    -- TODO: Put it in a separate module
    bg = display.newImageRect(sceneData.bg, 480, 320);
    bg:setReferencePoint(display.CenterReferencePoint);
    bg.x = 240; bg.y = 160;
    backgroundGroup:insert(bg);

    -- load actors
    for index, act in pairs(sceneData.actors) do
        -- look for corresponding avatar objects from avatar.json
        -- and load them to the memory
        actors[act.id] = avatars.new({ avatar = act });
        actorGroup:insert(actors[act.id]);
        actorGroup:insert(actors[act.id].dimmed);
    end

    -- load speech background
    -- TODO: Put it in a separate module
    speechbg = display.newImageRect("assets/images/speech_bg.png", 480, 120);
    speechbg:setReferencePoint(display.CenterReferencePoint);
    speechbg.x = 240; speechbg.y = _H - 60;
    group:insert(speechbg);
    sceneGroup:insert(speechbg);

    -- name group
    nameGroup = display.newGroup();
    --group:insert(nameGroup);
    sceneGroup:insert(nameGroup);

    -- load name background
    -- TODO: Put it in a separate module
    -- namebg = display.newImageRect("assets/images/name_bg.png", 120, 30);
    namebg = display.newRect(0, 0, 120, 30);
    namebg:setReferencePoint(display.CenterReferencePoint);
    namebg.x = 0 + 60; namebg.y = speechbg.y - 60;
    namebg:setFillColor(0, 0, 0);
    nameGroup:insert(namebg);

    -- Preload the ID of the next text
    nextText = sceneData.scenetexts[sceneData.first];

    -- Load and display the name text for the first character
    nameText = texts.newName({ name = nextText.authorName });
    nameGroup:insert(nameText);

    -- highlight first speaking actor, dim the others
    for index, actor in pairs(actors) do
        if (actor.visible ~= "false") then
            if (actor.id ~= nextText.author) then
                actor.dimmed.alpha = 1;
            else
                actor.dimmed.alpha = 1;

                -- highlight the speaker
                transition.to(actor.dimmed, { time = 500, alpha = 0 });
            end
        else
            actor.alpha = 0;
            actor.dimmed.alpha = 0;
        end
    end


    -- animate the name group
    nameGroup.alpha = 0;
    transition.to(nameGroup, { time = 500, alpha = 1 });

    -- hide the cutscene and actor group
    sceneGroup.alpha = 0;
    actorGroup.alpha = 0;

    timer.performWithDelay(1000, showActors);
    timer.performWithDelay(2000, beginCutscene);
end




-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
    local group = self.view

    -- This function handles the drawing of common scene objects
    -- Creates scene and avatar effects, moves the name text and box
    -- and highlights the speaking actor
    local function shiftScene()
        local speakingActor;

        -- create a scene effect, if applicable
        if (nextText.sceneEffect ~= nil) then
            sceneEffects.new({ effect = nextText.sceneEffect });
        end

        -- highlight the speaking actor, dim the others
        -- also update the speaking actor's avatar
        for index, actor in pairs(actors) do
            if (actor.id ~= nextText.author) then

                -- ACTOR IS _NOT_ THE SPEAKING ONE
                -- animate the actor only if it's not permanently hidden
                if (actor.visible ~= "false") then
                    transition.to(actor.dimmed, { time = 500, alpha = 1 });
                else
                    actor.alpha = 0;
                    actor.dimmed.alpha = 0;
                end
            else

                -- ACTOR _IS_ THE SPEAKING ONE
                -- check if actor should changed its visibility from now on
                if (nextText.actorVisible == "true") then
                    actor.visible = "true";
                    -- actor.alpha = 1;
                    -- actor.dimmed.alpha = 1;
                elseif (nextText.actorVisible == "false") then
                    actor.visible = "false";
                end

                -- animate the actor only if the previous speaker was a different actor
                if (actor.dimmed.alpha ~= 0) then
                    actor.dimmed.alpha = 1;

                    -- highlight the speaker
                    transition.to(actor.dimmed, { time = 500, alpha = 0 });
                end

                -- update the speaking actor's avatar, if applicable
                if (nextText.actorImg ~= nil) then
                    local newActor = actor;
                    newActor.path = nextText.actorImg;
                    actors[actor.id] = avatars.update(actor, newActor);
                    actorGroup:insert(actors[actor.id]);
                    actorGroup:insert(actors[actor.id].dimmed);
                end

                -- create an actor effect, if applicable
                if (nextText.actorEffect ~= nil) then
                    actorEffects.new({ actor = actors[actor.id], effect = nextText.actorEffect });
                end

                speakingActor = actor;
            end
        end

        -- move the name group
        -- make sure that the speaking actor actually exists
        -- additionally, perform the namebg animation only if it actually moved
        nameText:setText(nextText.authorName);

        if (speakingActor ~= nil) then
            if (speakingActor.x > (_W / 2)) then
                if (nameGroup.x ~= (_W - 120)) then
                    nameGroup.alpha = .5;
                    transition.to(nameGroup, { time = 400, alpha = 1 });
                    nameGroup.x = _W - 120;
                end
                transition.to(nameGroup, { time = 400, alpha = 1 });
            elseif (speakingActor.x < (_W / 2)) then
                if (nameGroup.x ~= 0) then
                    nameGroup.alpha = .5;
                    transition.to(nameGroup, { time = 400, alpha = 1 });
                    nameGroup.x = 0;
                end
            end
        elseif (speakingActor == nil) then
            if (nameGroup.x ~= 0) then
                nameGroup.alpha = .5;
                nameGroup.x = 0;
                transition.to(nameGroup, { time = 400, alpha = 1 });
            end
        end
    end

    -- Event handler: pickChoice
    local function pickChoice(e)

        local function deleteChoices(e)

            -- remove the choice objects
            for index, choice in pairs(choices) do
                choices[index].bg:removeSelf();
                choices[index]:removeSelf();
                choices[index]:removeEventListener("touch", pickChoice);
                choices[index] = nil;
            end
        end

        local function dimChosen(e)
            transition.to(e.source.choice, { time = 1000, alpha = 0 });
            transition.to(e.source.choice.bg, { time = 1000, alpha = 0 });
        end

        if (e.phase == "ended") then
            for index, choice in pairs(choices) do
                if (choice == e.target) then
                    nextText = sceneData.scenetexts[choice.next];
                    displayText = texts.update(displayText, nextText);

                    -- highlight the selected choice, then dim it
                    transition.to(choice, { time = 500, alpha = 1 });
                    transition.to(choice.bg, { time = 500, alpha = 1 });

                    -- delay the dimming, so it won't cross with highlighting
                    local t = timer.performWithDelay(500, dimChosen);
                    t.choice = choice;
                else
                    -- dim the not selected choices
                    transition.to(choice, { time = 500, alpha = 0 });
                    transition.to(choice.bg, { time = 500, alpha = 0 });
                end
            end

            -- delete the used choices
            timer.performWithDelay(2000, deleteChoices);
            isChoices = false;
            shiftScene();
        end
    end

    -- Event handler: change text
    local function changeText(e)
        if (e.phase == "ended") then

            -- Change the text to the next one only if
            -- the current one has been displayed completely
            if (displayText:transitionActive() == false) then

                if (nextText.choice == nil) then
                    nextText = sceneData.scenetexts[nextText.next];
                    displayText = texts.update(displayText, nextText);
                end

                -- create the choice dialogs
                if (nextText.choice ~= nil and isChoices == false) then
                    for index, choice in pairs(nextText.choice) do
                        local newChoice = texts.newChoice({ text = choice });
                        newChoice.alpha = 0;
                        newChoice.bg.alpha = 0;
                        transition.to(newChoice, { time = 500, alpha = 1 });
                        transition.to(newChoice.bg, { time = 500, alpha = 0.5 });
                        choices[index] = newChoice;

                        -- add event listeners to the choices
                        choices[index]:addEventListener("touch", pickChoice);
                    end
                    isChoices = true;
                end

                shiftScene();

                -- if user pressed on the text and the text is
                -- still animating, display it instantly
            else
                local noAnimText = displayText;
                noAnimText.inAnim = "none";
                displayText = texts.update(displayText, noAnimText);
            end
        end
    end

    speechbg:addEventListener("touch", changeText);
end


-- Called when scene is about to move offscreen:
function scene:exitScene(event)
    local group = self.view

    displayText:removeEventListener("touch", changeText);
    speechbg:removeEventListener("touch", changeText);
    -----------------------------------------------------------------------------

    --	INSERT code here (e.g. stop timers, remove listeners, unload sounds, etc.)

    -----------------------------------------------------------------------------
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene(event)
    local group = self.view

    -----------------------------------------------------------------------------

    --	INSERT code here (e.g. remove listeners, widgets, save state, etc.)

    -----------------------------------------------------------------------------
end


---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener("createScene", scene)

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener("enterScene", scene)

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener("exitScene", scene)

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener("destroyScene", scene)

---------------------------------------------------------------------------------

return scene
----------------------------------------------------------------------------------
--
-- sceneText.lua
--
-- This class creates a SCENETEXT object
--
----------------------------------------------------------------------------------
module(..., package.seeall);

local json = require("json");
local TextCandy = require("code/lib_text_candy");
local jtools = require("code/jsonTools");
local _W = display.contentWidth; local _H = display.contentHeight;
local nameLeftX, nameRightX, nameLeftY, nameRightY;

function new(params)
    -- load default config from JSON
    local textDefault = json.decode(jtools.jsonFile("data/scenes/sceneconfig.json")).scenetext;

    -- load the character sound
    local charSound = audio.loadSound("assets/audio/char.wav")

    -- pass the incoming text object
    local text;
    if (params) then
        text = params.text;
    else
        return nil;
    end

    -- check if parameters are specified, if not, load defaults
    local fontName;
    local fontSize;
    local offsetX;
    local offsetY;
    local wrapWidth;
    local align;
    local inAnim;
    local delay;

    if (text.fontName == nil) then
        fontName = textDefault.fontName;
    else
        fontName = text.fontName;
    end

    if (text.fontSize == nil) then
        fontSize = textDefault.fontSize;
    else
        fontSize = text.fontSize;
    end

    if (text.offsetX == nil) then
        offsetX = textDefault.offsetX;
    else
        offsetX = text.offsetX;
    end

    if (text.offsetY == nil) then
        offsetY = textDefault.offsetY;
    else
        offsetY = text.offsetY;
    end

    if (text.wrapWidth == nil) then
        wrapWidth = textDefault.wrapWidth;
    else
        wrapWidth = text.wrapWidth;
    end

    if (text.align == nil) then
        align = textDefault.align;
    else
        align = text.align;
    end

    if (text.inAnim == nil) then
        inAnim = textDefault.inAnim;
    else
        inAnim = text.inAnim;
    end

    if (text.delay == nil) then
        delay = textDefault.delay;
    else
        delay = text.delay;
    end

    TextCandy.AddVectorFont(fontName, "0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz'*@():,$.!-%+?;#/_", fontSize);

    local newText = TextCandy.CreateText({
        fontName = fontName,
        x = 0 + offsetX,
        y = _H + offsetY,
        text = text.text,
        originX = "LEFT",
        originY = "TOP",
        textFlow = align,
        wrapWidth = wrapWidth,
        charBaseLine = "CENTER",
        showOrigin = false,
    })

    newText.xScale = .5; newText.yScale = .5;

    local animFrom, inCharDelay, inMode;
    if (inAnim == "default") then
        animFrom = { time = 300, alpha = .2, transition = easing.outExpo };
        inCharDelay = 50;
        inMode = "LEFT_RIGHT";
    elseif (inAnim == "smash") then
        animFrom = { time = 500, alpha = 0, transition = easing.outExpo, xScale = 50, yScale = 50 }
        inCharDelay = 100;
        inMode = "LEFT_RIGHT";
    elseif (inAnim == "none") then
        animFrom = nil;
        inCharDelay = 0;
        inMode = nil;
    end

    newText:applyInOutTransition({
        hideCharsBefore = true,
        hideCharsAfter = true,
        startNow = true,
        loop = false,
        autoRemoveText = false,
        restartOnChange = true,
        -- IN TRANSITION
        inDelay = delay,
        inCharDelay = inCharDelay,
        inMode = inMode,
        AnimateFrom = animFrom
    })

    -- db:close();

    return newText;
end

function newName(params)
    -- load config JSON data
    local config = json.decode(jtools.jsonFile("data/scenes/sceneconfig.json"));

    TextCandy.AddVectorFont(config.nametext.fontName, "0123456789AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz'*@():,$.!-%+?;#/_", config.nametext.fontSize);

    local name;

    if (params) then
        name = params.name;
    else
        return nil;
    end

    local newText = TextCandy.CreateText({
        fontName = config.nametext.fontName,
        x = 10 + config.nametext.offsetX,
        y = (_H / 2) + config.nametext.offsetY,
        text = name,
        originX = "LEFT",
        originY = "CENTER",
        textFlow = "LEFT",
        wrapWidth = 0,
        charBaseLine = "CENTER",
        showOrigin = false,
    })

    newText.xScale = .5; newText.yScale = .5;
    return newText;
end

function newChoice(params)
    -- load default config from JSON
    local textDefault = json.decode(jtools.jsonFile("data/scenes/sceneconfig.json")).scenechoice;

    local text;

    if (params) then
        text = params.text;
    else
        return nil;
    end

    -- check if parameters are specified, if not
    -- load defaults
    local fontName;
    local fontSize;
    local offsetX;
    local offsetY;
    local wrapWidth;
    local align;
    local inAnim;
    local delay;

    if (text.fontName == nil) then
        fontName = textDefault.fontName;
    else
        fontName = text.fontName;
    end

    if (text.fontSize == nil) then
        fontSize = textDefault.fontSize;
    else
        fontSize = text.fontSize;
    end

    if (text.offsetX == nil) then
        offsetX = textDefault.offsetX;
    else
        offsetX = text.offsetX;
    end

    if (text.offsetY == nil) then
        offsetY = textDefault.offsetY;
    else
        offsetY = text.offsetY;
    end

    if (text.wrapWidth == nil) then
        wrapWidth = textDefault.wrapWidth;
    else
        wrapWidth = text.wrapWidth;
    end

    if (text.align == nil) then
        align = textDefault.align;
    else
        align = text.align;
    end

    if (text.inAnim == nil) then
        inAnim = textDefault.inAnim;
    else
        inAnim = text.inAnim;
    end

    if (text.delay == nil) then
        delay = textDefault.delay;
    else
        delay = text.delay;
    end

    -- calculate the final offsetY
    offsetY = offsetY - (40 * text.no);

    -- create the background for the choice texts
    local choicebg = display.newRect(0, _H + offsetY - 15, 480, 30);
    choicebg:setReferencePoint(display.CenterReferencePoint);
    choicebg:setFillColor(0, 0, 60);
    choicebg.alpha = 0.5;

    local newText = TextCandy.CreateText({
        fontName = fontName,
        fontSize = fontSize,
        x = 0 + offsetX,
        y = _H + offsetY,
        text = text.text,
        originX = "LEFT",
        originY = "CENTER",
        textFlow = align,
        wrapWidth = wrapWidth,
        charBaseLine = "CENTER",
        showOrigin = false,
    })

    -- apply the bg
    newText.bg = choicebg;
    --newText:addBackground(choicebg,0,0,0.5,0,0);

    newText.xScale = .5; newText.yScale = .5;
    newText.next = text.next;
    return newText;
end

function update(delTxt, newTxt)
    TextCandy.DeleteText(delTxt);
    delTxt = nil;
    local txt = new({ text = newTxt });
    return txt;
end


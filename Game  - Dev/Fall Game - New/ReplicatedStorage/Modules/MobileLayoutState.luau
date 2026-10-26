-- [PATH] ReplicatedStorage / Modules / MobileLayoutState @Type ModuleScript


local u1 = {
    SCALE_MIN = 50,
    SCALE_MAX = 300,
    SCALE_STEP = 5,
    OPACITY_MIN = 10,
    OPACITY_MAX = 100,
    OPACITY_STEP = 5,
    BUTTON_IDS = {
        Use = 1,
        Sprint = 2,
        Jump = 3,
        Crouch = 4,
        Reload = 5,
        Open = 6,
        Change = 7,
        Upgrade = 8,
        Rotate = 9,
        Inventory = 10,
        Close = 11,
        Menu = 12,
        Attachment = 13,
        ADS = 14,
        Inspect = 15,
        NVG = 16,
        FreeLook = 17
    },
    EDITABLE = { "Use", "Sprint", "Jump", "Crouch", "Reload", "Open", "Change", "Upgrade", "Rotate", "Inventory", "Attachment", "ADS", "Inspect", "NVG", "FreeLook" },
    SIZES = { {
            Key = "SMALL",
            Mult = 0.85
        }, {
            Key = "MEDIUM",
            Mult = 1
        }, {
            Key = "LARGE",
            Mult = 1.25
        } },
    EMPTY = "2",
    Buttons = {},
    Hydrated = false,
    Changed = Instance.new("BindableEvent")
};
local v2 = {};

for i, v in u1.BUTTON_IDS do
    if v2[v] then
        error((`TWO MOBILE BUTTONS WITH THE SAME ID ({v}) - {v2[v]} = {i}`));
    end;

    v2[v] = i;
end;

u1.ID_TO_NAME = v2;

for _, v in u1.EDITABLE do
    if not u1.BUTTON_IDS[v] then
        error((`EDITABLE MOBILE BUTTON WITH NO ID - {v}`));
    end;
end;

local function EncodeCoord(p3: number?) -- Line: 122
    if p3 == nil then
        return "";
    end;

    local math_round_ret = math.round(p3 * 1000);
    local math_clamp_ret = math.clamp(math_round_ret, 0, 1000);

    return tostring(math_clamp_ret);
end;

local function EncodePercent(p4: number?) -- Line: 127
    if p4 == nil then
        return "";
    end;

    local math_round_ret = math.round(p4);

    return tostring(math_round_ret);
end;

local function SnapPercent(p5: number, p6: number, p7: number, p8: number) -- Line: 132
    local v9 = math.round(p5 / p8) * p8;

    return math.clamp(v9, p6, p7);
end;

function u1.EncodeRecord(p10: table) -- Line: 138
    -- upvalues: u1 (copy)
    local v11 = { "2" };

    for _, v in u1.EDITABLE do
        local v12 = p10[v];

        if v12 then
            local v13;

            if v12.X == nil then
                v13 = false;
            else
                v13 = v12.Y ~= nil;
            end;

            if v13 or (v12.Scale ~= nil or v12.Opacity ~= nil) then
                local v14 = u1.BUTTON_IDS[v];
                local X = v12.X;
                local v15;

                if X == nil then
                    v15 = "";
                else
                    local math_round_ret = math.round(X * 1000);
                    local math_clamp_ret = math.clamp(math_round_ret, 0, 1000);
                    v15 = tostring(math_clamp_ret);
                end;

                local Y = v12.Y;
                local v16;

                if Y == nil then
                    v16 = "";
                else
                    local math_round_ret = math.round(Y * 1000);
                    local math_clamp_ret = math.clamp(math_round_ret, 0, 1000);
                    v16 = tostring(math_clamp_ret);
                end;

                local Scale = v12.Scale;
                local v17;

                if Scale == nil then
                    v17 = "";
                else
                    local math_round_ret = math.round(Scale);
                    v17 = tostring(math_round_ret);
                end;

                local Opacity = v12.Opacity;
                local v18;

                if Opacity == nil then
                    v18 = "";
                else
                    local math_round_ret = math.round(Opacity);
                    v18 = tostring(math_round_ret);
                end;

                local v19 = `{v14}:{v15},{v16},{v17},{v18}`;
                table.insert(v11, v19);
            end;
        end;
    end;

    return table.concat(v11, "|");
end;

function u1.Parse(p20: string?) -- Line: 153
    -- upvalues: u1 (copy)
    if type(p20) ~= "string" or (#p20 == 0 or #p20 > 512) then
        return nil;
    end;

    local string_split_ret = string.split(p20, "|");
    local v21 = string_split_ret[1];

    if v21 ~= "2" and v21 ~= "1" then
        return nil;
    end;

    if #string_split_ret > #u1.EDITABLE + 1 then
        return nil;
    end;

    local v22 = {};
    local v23 = {};

    for i = 2, #string_split_ret do
        local v24, v25 = string_split_ret[i]:match("^(%d+):(.*)$");

        if v24 then
            v24 = tonumber(v24);
        end;

        local v26;

        if v24 then
            v26 = u1.ID_TO_NAME[v24];
        else
            v26 = v24;
        end;

        if not v26 or v22[v24] then
            return nil;
        end;

        v22[v24] = true;
        local v27, v28, v29, v30;

        if v21 == "1" then
            v27, v28, v29 = v25:match("^(%d*),(%d*),(%d*)$");
            v30 = "";
        else
            v27, v28, v29, v30 = v25:match("^(%d*),(%d*),(%d*),(%d*)$");
        end;

        if not v27 then
            return nil;
        end;

        local v31 = {};

        if v27 ~= "" or v28 ~= "" then
            local v32 = tonumber(v27);
            local v33 = tonumber(v28);

            if not (v32 and v33) then
                return nil;
            end;

            if v32 > 1000 or v33 > 1000 then
                return nil;
            end;

            v31.X = v32 / 1000;
            v31.Y = v33 / 1000;
        end;

        if v29 ~= "" then
            local v34 = tonumber(v29);

            if not v34 then
                return nil;
            end;

            if v21 == "1" then
                local v35 = u1.SIZES[v34];

                if not v35 then
                    return nil;
                end;

                v34 = math.round(v35.Mult * 100);
            end;

            if v34 < u1.SCALE_MIN or u1.SCALE_MAX < v34 then
                return nil;
            end;

            if v34 ~= 100 then
                v31.Scale = v34;
            end;
        end;

        if v30 ~= "" then
            local v36 = tonumber(v30);

            if not (v36 and (v36 >= u1.OPACITY_MIN and u1.OPACITY_MAX >= v36)) then
                return nil;
            end;

            if v36 ~= 100 then
                v31.Opacity = v36;
            end;
        end;

        local v37;

        if v31.X == nil and (v31.Scale == nil and v31.Opacity == nil) then
            if v21 ~= "1" then
                return nil;
            end;

            v37 = i;
        else
            v23[v26] = v31;
            v37 = i;
        end;
    end;

    return v23;
end;

function u1.Sanitize(p38: string?) -- Line: 219
    -- upvalues: u1 (copy)
    local v39 = u1.Parse(p38);

    if not v39 then
        return nil, false;
    end;

    local v40 = u1.EncodeRecord(v39);

    if v40 == "2" then
        return nil, true;
    end;

    return v40, true;
end;

function u1.Encode() -- Line: 228
    -- upvalues: u1 (copy)
    local v41 = u1.EncodeRecord(u1.Buttons);

    if v41 == "2" then
        return nil;
    end;

    return v41;
end;

function u1.Apply(p42: string?) -- Line: 236
    -- upvalues: u1 (copy)
    local v43;

    if p42 == nil then
        v43 = nil;
    else
        v43 = u1.Parse(p42);
    end;

    table.clear(u1.Buttons);

    if not v43 then
        return;
    end;

    for i, v in v43 do
        u1.Buttons[i] = v;
    end;
end;

function u1.Snapshot() -- Line: 246
    -- upvalues: u1 (copy)
    local v44 = {};

    for i, v in u1.Buttons do
        v44[i] = table.clone(v);
    end;

    return v44;
end;

function u1.Restore(p45: table) -- Line: 254
    -- upvalues: u1 (copy)
    table.clear(u1.Buttons);

    for i, v in p45 do
        u1.Buttons[i] = table.clone(v);
    end;
end;

function u1.IsEditable(p46: string?) -- Line: 262
    -- upvalues: u1 (copy)
    local v47;

    if p46 == nil then
        v47 = false;
    else
        v47 = table.find(u1.EDITABLE, p46) ~= nil;
    end;

    return v47;
end;

local function EntryFor(p48: string) -- Line: 266
    -- upvalues: u1 (copy)
    local v49 = u1.Buttons[p48];

    if not v49 then
        v49 = {};
        u1.Buttons[p48] = v49;
    end;

    return v49;
end;

local function DropIfEmpty(p50: string) -- Line: 275
    -- upvalues: u1 (copy)
    local v51 = u1.Buttons[p50];

    if v51 and (v51.X == nil and (v51.Scale == nil and v51.Opacity == nil)) then
        u1.Buttons[p50] = nil;
    end;
end;

function u1.GetScale(p52: string) -- Line: 283
    -- upvalues: u1 (copy)
    local v53 = u1.Buttons[p52];

    return v53 and v53.Scale or 100;
end;

function u1.GetSizeMult(p54: string) -- Line: 288
    -- upvalues: u1 (copy)
    return u1.GetScale(p54) / 100;
end;

function u1.GetOpacity(p55: string) -- Line: 293
    -- upvalues: u1 (copy)
    local v56 = u1.Buttons[p55];

    return v56 and v56.Opacity or 100;
end;

function u1.SetPosition(p57: string, p58: number, p59: number) -- Line: 299
    -- upvalues: u1 (copy)
    if not u1.IsEditable(p57) then
        return;
    end;

    local v60 = u1.Buttons[p57];

    if not v60 then
        v60 = {};
        u1.Buttons[p57] = v60;
    end;

    local math_round_ret = math.round(p58 * 1000);
    v60.X = math.clamp(math_round_ret, 0, 1000) / 1000;
    local math_round_ret2 = math.round(p59 * 1000);
    v60.Y = math.clamp(math_round_ret2, 0, 1000) / 1000;
end;

function u1.SetScale(p61: string, p62: number) -- Line: 307
    -- upvalues: u1 (copy)
    if not u1.IsEditable(p61) then
        return;
    end;

    local SCALE_MIN = u1.SCALE_MIN;
    local SCALE_MAX = u1.SCALE_MAX;
    local SCALE_STEP = u1.SCALE_STEP;
    local v63 = math.round(p62 / SCALE_STEP) * SCALE_STEP;
    local math_clamp_ret = math.clamp(v63, SCALE_MIN, SCALE_MAX);
    local v64 = u1.Buttons[p61];

    if not v64 then
        v64 = {};
        u1.Buttons[p61] = v64;
    end;

    if math_clamp_ret == 100 then
        math_clamp_ret = nil;
    end;

    v64.Scale = math_clamp_ret;
    local v65 = u1.Buttons[p61];

    if v65 and (v65.X == nil and (v65.Scale == nil and v65.Opacity == nil)) then
        u1.Buttons[p61] = nil;
    end;
end;

function u1.SetOpacity(p66: string, p67: number) -- Line: 314
    -- upvalues: u1 (copy)
    if not u1.IsEditable(p66) then
        return;
    end;

    local OPACITY_MIN = u1.OPACITY_MIN;
    local OPACITY_MAX = u1.OPACITY_MAX;
    local OPACITY_STEP = u1.OPACITY_STEP;
    local v68 = math.round(p67 / OPACITY_STEP) * OPACITY_STEP;
    local math_clamp_ret = math.clamp(v68, OPACITY_MIN, OPACITY_MAX);
    local v69 = u1.Buttons[p66];

    if not v69 then
        v69 = {};
        u1.Buttons[p66] = v69;
    end;

    if math_clamp_ret == 100 then
        math_clamp_ret = nil;
    end;

    v69.Opacity = math_clamp_ret;
    local v70 = u1.Buttons[p66];

    if v70 and (v70.X == nil and (v70.Scale == nil and v70.Opacity == nil)) then
        u1.Buttons[p66] = nil;
    end;
end;

function u1.LabelOf(p71: userdata) -- Line: 324
    return p71:FindFirstChild("Label") or p71;
end;

function u1.Reset() -- Line: 330
    -- upvalues: u1 (copy)
    table.clear(u1.Buttons);
end;

u1.Defaults = {};

function u1.SetDefault(p72: string, p73: number, p74: number, p75: number, p76: number) -- Line: 339
    -- upvalues: u1 (copy)
    u1.Defaults[p72] = {
        X = p73,
        Y = p74,
        W = p75,
        H = p76
    };
end;

function u1.GetCentre(p77: string) -- Line: 343
    -- upvalues: u1 (copy)
    local v78 = u1.Defaults[p77];
    local v79 = u1.Buttons[p77];
    local v80 = v79 and v79.X;

    if not v80 then
        if v78 then
            v80 = v78.X;
        else
            v80 = v78;
        end;
    end;

    local v81 = v79 and v79.Y;

    if v81 then
        v78 = v81;
    elseif v78 then
        v78 = v78.Y;
    end;

    return v80, v78;
end;

function u1.GetSize(p82: string) -- Line: 351
    -- upvalues: u1 (copy)
    local v83 = u1.Defaults[p82];

    if not v83 then
        return nil, nil;
    end;

    local SizeMult = u1.GetSizeMult(p82);

    return v83.W * SizeMult, v83.H * SizeMult;
end;

u1.FADE_LAYERS = {
    {
        Prop = "BackgroundTransparency",

        Get = function(p84) -- Line: 367, Name: Get
            return p84;
        end
    },
    {
        Prop = "BackgroundTransparency",

        Get = function(p85) -- Line: 368, Name: Get
            return p85:FindFirstChild("Select");
        end
    },
    {
        Prop = "ImageTransparency",

        Get = function(p86) -- Line: 369, Name: Get
            return p86:FindFirstChild("Dust");
        end
    },
    {
        Prop = "TextTransparency",

        Get = function(p87) -- Line: 370, Name: Get
            -- upvalues: u1 (copy)
            return u1.LabelOf(p87);
        end
    },
    {
        Prop = "Transparency",

        Get = function(p88) -- Line: 371, Name: Get
            -- upvalues: u1 (copy)
            return u1.LabelOf(p88):FindFirstChildOfClass("UIStroke");
        end
    },
    {
        Prop = "Transparency",

        Get = function(p89) -- Line: 372, Name: Get
            return p89:FindFirstChildOfClass("UIStroke");
        end
    },
    {
        Prop = "ImageTransparency",

        Get = function(p90) -- Line: 373, Name: Get
            return p90:FindFirstChild("Icon");
        end
    },
    {
        Prop = "TextTransparency",

        Get = function(p91) -- Line: 374, Name: Get
            return p91:FindFirstChild("Count");
        end
    }
};
u1.FADE_DEFAULT = 0.4;
u1.FadeDefaults = {};

function u1.SetFadeDefault(p92: string, p93: userdata) -- Line: 383
    -- upvalues: u1 (copy)
    local v94 = {};

    for i, v in u1.FADE_LAYERS do
        local v95 = v.Get(p93);
        local v96;

        if v95 then
            v96 = v95[v.Prop];
        else
            v96 = nil;
        end;

        v94[i] = v96;
    end;

    u1.FadeDefaults[p92] = v94;
end;

function u1.FadeLayer(p97: number, p98: number) -- Line: 396
    -- upvalues: u1 (copy)
    local FADE_DEFAULT = u1.FADE_DEFAULT;

    if p98 <= FADE_DEFAULT then
        return p97 * (p98 / FADE_DEFAULT);
    end;

    return p97 + (1 - p97) * ((p98 - FADE_DEFAULT) / (1 - FADE_DEFAULT));
end;

function u1.ApplyFade(p99: string, p100: userdata, p101: number) -- Line: 410
    -- upvalues: u1 (copy)
    local v102 = u1.FadeDefaults[p99];

    if not v102 then
        return nil;
    end;

    local v103 = u1.GetOpacity(p99) / 100;
    local v104 = nil;

    for i, v in u1.FADE_LAYERS do
        local v105 = v102[i];

        if v105 ~= nil then
            local v106 = v.Get(p100);

            if v106 then
                local v107 = 1 - (1 - u1.FadeLayer(v105, p101)) * v103;
                v106[v.Prop] = v107;

                if i == 1 then
                    v104 = v107;
                end;
            end;
        end;
    end;

    return v104;
end;

return u1;
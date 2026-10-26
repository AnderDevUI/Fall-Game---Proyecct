-- [PATH] ReplicatedStorage / Modules / SettingsModule @Type ModuleScript


local u1 = {
    Settings = nil,
    SkinPresets = nil,
    Categories = { "General", "Graphics", "Controls", "Sound", "Gamepad", "Mobile" },
    Config = {
        General = { {
                Type = "Slider",
                Text = "Field Of View",
                Id = 1,
                DefaultValue = 70,
                SliderStep = 1,
                InputStep = 0.01,
                Range = { 60, 80 }
            }, {
                Type = "Slider",
                Text = "Chat Scale",
                Id = 49,
                DefaultValue = 0.85,
                SliderStep = 0.01,
                InputStep = 0.01,
                Range = { 0.1, 1 }
            }, {
                Type = "Checkbox",
                Text = "Auto Hide All Signs",
                Id = 2,
                DefaultValue = false
            }, {
                Type = "Checkbox",
                Text = "Hide Chat",
                Id = 33,
                DefaultValue = false
            }, {
                Type = "Checkbox",
                Text = "Mute Jukeboxes",
                Id = 34,
                DefaultValue = false
            }, {
                Type = "Checkbox",
                Text = "Decrease Camera Shake",
                Id = 35,
                DefaultValue = false
            }, {
                Type = "Checkbox",
                Text = "Randomize Skin Selection",
                Id = 47,
                DefaultValue = false
            } },
        Graphics = { {
                Type = "Header",
                Text = "Performance"
            }, {
                Type = "Checkbox",
                Text = "Shadows",
                Id = 3,
                DefaultValue = true
            }, {
                Type = "Slider",
                Text = "Max Gib Count",
                Id = 4,
                DefaultValue = 100,
                SliderStep = 1,
                InputStep = 1,
                Range = { 10, 100 }
            }, {
                Type = "Checkbox",
                Text = "Impacts",
                Id = 43,
                DefaultValue = true
            }, {
                Type = "Checkbox",
                Text = "Blood",
                Id = 44,
                DefaultValue = true
            }, {
                Type = "Checkbox",
                Text = "Bullet Casings",
                Id = 45,
                DefaultValue = true
            }, {
                Type = "Header",
                Text = "Viewmodel"
            }, {
                Type = "Slider",
                Text = "Outline Transparency",
                Id = 5,
                DefaultValue = 0,
                SliderStep = 0.1,
                InputStep = 0.01,
                Range = { 0, 1 }
            }, {
                Type = "Checkbox",
                Text = "Toggle Outline",
                Id = 6,
                DefaultValue = true
            }, {
                Type = "Header",
                Text = "Crosshair"
            }, {
                Type = "Checkbox",
                Text = "Toggle Crosshair",
                Id = 36,
                DefaultValue = true
            } },
        Controls = {
            {
                Type = "Header",
                Text = "Sensitivity"
            },
            {
                Type = "Slider",
                Text = "Mouse Sensitivity",
                Id = 7,
                DefaultValue = 1,
                SliderStep = 0.01,
                InputStep = 0.001,
                Range = { 0.001, 10 }
            },
            {
                Type = "Slider",
                Text = "Vehicle Sensitivity",
                Id = 50,
                DefaultValue = 0.3,
                SliderStep = 0.01,
                InputStep = 0.001,
                Range = { 0.001, 10 }
            },
            {
                Type = "Header",
                Text = "Movement"
            },
            {
                Type = "Keybind",
                Text = "Move Forward",
                Id = 8,
                DefaultValue = "W"
            },
            {
                Type = "Keybind",
                Text = "Move Backward",
                Id = 9,
                DefaultValue = "S"
            },
            {
                Type = "Keybind",
                Text = "Move Right",
                Id = 10,
                DefaultValue = "D"
            },
            {
                Type = "Keybind",
                Text = "Move Left",
                Id = 11,
                DefaultValue = "A"
            },
            {
                Type = "Keybind",
                Text = "Jump",
                Id = 12,
                DefaultValue = "Space"
            },
            {
                Type = "Keybind",
                Text = "Sprint",
                Id = 13,
                DefaultValue = "LeftShift"
            },
            {
                Type = "Checkbox",
                Text = "Toggle Sprint",
                Id = 14,
                DefaultValue = false
            },
            {
                Type = "Keybind",
                Text = "Crouch",
                Id = 15,
                DefaultValue = "C"
            },
            {
                Type = "Checkbox",
                Text = "Toggle Crouch",
                Id = 16,
                DefaultValue = false
            },
            {
                Type = "Keybind",
                Text = "Free Look",
                Id = 17,
                DefaultValue = "LeftAlt"
            },
            {
                Type = "Header",
                Text = "Actions"
            },
            {
                Type = "Keybind",
                Text = "Interact",
                Id = 18,
                DefaultValue = "E"
            },
            {
                Type = "Keybind",
                Text = "Open Map",
                Id = 19,
                DefaultValue = "G"
            },
            {
                Type = "Header",
                Text = "Combat"
            },
            {
                Type = "Keybind",
                Text = "Reload",
                Id = 20,
                DefaultValue = "R"
            },
            {
                Type = "Keybind",
                Text = "Aim Down Sight",
                Id = 37,
                DefaultValue = "MB2",
                AllowMouse = true
            },
            {
                Type = "Keybind",
                Text = "Use Attachment",
                Id = 21,
                DefaultValue = "F"
            },
            {
                Type = "Keybind",
                Text = "Inspect",
                Id = 22,
                DefaultValue = "N"
            },
            {
                Type = "Keybind",
                Text = "Use Armor Mod",
                Id = 48,
                DefaultValue = "X"
            },
            {
                Type = "Header",
                Text = "Building"
            },
            {
                Type = "Keybind",
                Text = "Rotate Building",
                Id = 38,
                DefaultValue = "R",
                IgnoreConflict = true
            },
            {
                Type = "Keybind",
                Text = "Change Building",
                Id = 39,
                DefaultValue = "MB2",
                IgnoreConflict = true,
                AllowMouse = true
            },
            {
                Type = "Header",
                Text = "Inventory"
            },
            {
                Type = "Keybind",
                Text = "Toolbar Left",
                Id = 40,
                DefaultValue = "M.WheelUp",
                AllowMouse = true
            },
            {
                Type = "Keybind",
                Text = "Toolbar Right",
                Id = 41,
                DefaultValue = "M.WheelDown",
                AllowMouse = true
            },
            {
                Type = "Keybind",
                Text = "Open Inventory",
                Id = 23,
                DefaultValue = "Tab"
            },
            {
                Type = "Keybind",
                Text = "Open Crafting",
                Id = 24,
                DefaultValue = "Q"
            },
            {
                Type = "Keybind",
                Text = "Quick Loot",
                Id = 25,
                DefaultValue = "H"
            },
            {
                Type = "Header",
                Text = "Chat"
            },
            {
                Type = "Keybind",
                Text = "Start Typing",
                Id = 26,
                DefaultValue = "Return"
            },
            {
                Type = "Keybind",
                Text = "Start Command",
                Id = 27,
                DefaultValue = "Slash"
            },
            {
                Type = "Keybind",
                Text = "Switch Channels",
                Id = 28,
                DefaultValue = "Tab",
                IgnoreConflict = true
            },
            {
                Type = "Header",
                Text = "Cinematic Mode"
            },
            {
                Type = "Keybind",
                Text = "Hide UI",
                Id = 29,
                DefaultValue = "M"
            }
        },
        Sound = { {
                Type = "Slider",
                Text = "Master Volume",
                Id = 30,
                DefaultValue = 1,
                SliderStep = 0.1,
                InputStep = 0.01,
                Range = { 0, 1 }
            }, {
                Type = "Slider",
                Text = "SFX Volume",
                Id = 31,
                DefaultValue = 1,
                SliderStep = 0.1,
                InputStep = 0.01,
                Range = { 0, 1 }
            }, {
                Type = "Slider",
                Text = "Gunshot Volume",
                Id = 42,
                DefaultValue = 1,
                SliderStep = 0.1,
                InputStep = 0.01,
                Range = { 0, 1 }
            }, {
                Type = "Slider",
                Text = "Jukebox Volume",
                Id = 32,
                DefaultValue = 1,
                SliderStep = 0.1,
                InputStep = 0.01,
                Range = { 0, 1 }
            }, {
                Type = "Slider",
                Text = "Music Volume",
                Id = 46,
                DefaultValue = 1,
                SliderStep = 0.1,
                InputStep = 0.01,
                Range = { 0, 1 }
            } },
        Gamepad = {
            {
                Type = "Header",
                Text = "Sensitivity"
            },
            {
                Type = "Slider",
                Text = "Mouse Sensitivity",
                Id = 67,
                DefaultValue = 0.65,
                SliderStep = 0.01,
                InputStep = 0.001,
                Range = { 0.001, 3 }
            },
            {
                Type = "Slider",
                Text = "Aiming Sensitivty",
                Id = 68,
                DefaultValue = 0.27,
                SliderStep = 0.01,
                InputStep = 0.001,
                Range = { 0.001, 3 }
            },
            {
                Type = "Slider",
                Text = "Joystick Deadzone",
                Id = 70,
                DefaultValue = 0.225,
                SliderStep = 0.01,
                InputStep = 0.001,
                Range = { 0.001, 0.9 }
            },
            {
                Type = "Header",
                Text = "Movement"
            },
            {
                Type = "Keybind",
                Text = "Jump",
                Id = 51,
                DefaultValue = "ButtonA"
            },
            {
                Type = "Keybind",
                Text = "Sprint",
                Id = 64,
                DefaultValue = "ButtonL3"
            },
            {
                Type = "Checkbox",
                Text = "Toggle Sprint",
                Id = 52,
                DefaultValue = false
            },
            {
                Type = "Keybind",
                Text = "Crouch",
                Id = 53,
                DefaultValue = "ButtonB"
            },
            {
                Type = "Checkbox",
                Text = "Toggle Crouch",
                Id = 65,
                DefaultValue = true
            },
            {
                Type = "Header",
                Text = "Actions"
            },
            {
                Type = "Keybind",
                Text = "Interact/Reload",
                Id = 54,
                DefaultValue = "ButtonX"
            },
            {
                Type = "Keybind",
                Text = "Open Map",
                Id = 55,
                DefaultValue = "DPadDown"
            },
            {
                Type = "Header",
                Text = "Combat"
            },
            {
                Type = "Keybind",
                Text = "Fire",
                Id = 71,
                DefaultValue = "ButtonR2"
            },
            {
                Type = "Keybind",
                Text = "Aim Down Sight",
                Id = 56,
                DefaultValue = "ButtonL2",
                AllowMouse = true
            },
            {
                Type = "Keybind",
                Text = "Use Attachment",
                Id = 57,
                DefaultValue = "DPadUp"
            },
            {
                Type = "Keybind",
                Text = "Inspect",
                Id = 58,
                DefaultValue = "DPadLeft"
            },
            {
                Type = "Keybind",
                Text = "Use Armor Mod",
                Id = 59,
                DefaultValue = "DPadRight"
            },
            {
                Type = "Header",
                Text = "Camera"
            },
            {
                Type = "Keybind",
                Text = "Free Look",
                Id = 72,
                DefaultValue = "ButtonR3"
            },
            {
                Type = "Header",
                Text = "Building"
            },
            {
                Type = "Keybind",
                Text = "Rotate Building",
                Id = 60,
                DefaultValue = "ButtonX",
                IgnoreConflict = true
            },
            {
                Type = "Keybind",
                Text = "Change Building",
                Id = 66,
                DefaultValue = "ButtonL2",
                IgnoreConflict = true,
                AllowMouse = true
            },
            {
                Type = "Keybind",
                Text = "Place Building",
                Id = 69,
                DefaultValue = "ButtonR2",
                IgnoreConflict = true
            },
            {
                Type = "Header",
                Text = "Inventory"
            },
            {
                Type = "Keybind",
                Text = "Toolbar Left",
                Id = 61,
                DefaultValue = "ButtonL1",
                AllowMouse = true
            },
            {
                Type = "Keybind",
                Text = "Toolbar Right",
                Id = 62,
                DefaultValue = "ButtonR1",
                AllowMouse = true
            },
            {
                Type = "Keybind",
                Text = "Open Inventory/Crafting",
                Id = 63,
                DefaultValue = "ButtonY"
            }
        },
        Mobile = { {
                Type = "Header",
                Text = "Sensitivity"
            }, {
                Type = "Slider",
                Text = "Mobile Sensitivity",
                Id = 73,
                DefaultValue = 1,
                SliderStep = 0.01,
                InputStep = 0.01,
                Range = { 0.01, 3 }
            }, {
                Type = "Slider",
                Text = "Mobile Aim Sensitivity",
                Id = 74,
                DefaultValue = 1,
                SliderStep = 0.01,
                InputStep = 0.01,
                Range = { 0.01, 3 }
            }, {
                Type = "Checkbox",
                Text = "Disable Button Camera Movement",
                Id = 77,
                DefaultValue = false
            }, {
                Type = "Checkbox",
                Text = "Aim When Firing",
                Id = 78,
                DefaultValue = false
            }, {
                Type = "Header",
                Text = "Appearance",
                Hidden = true
            }, {
                Type = "Slider",
                Text = "Mobile Button Transparency",
                Id = 75,
                DefaultValue = 0.4,
                SliderStep = 0.05,
                InputStep = 0.01,
                Hidden = true,
                Range = { 0, 0.95 }
            }, {
                Type = "Header",
                Text = "Aim Assist"
            }, {
                Type = "Checkbox",
                Text = "Mobile Aim Assist",
                Id = 76,
                DefaultValue = true
            } }
    }
};
local Players = game:GetService("Players");
local u2 = {};
local u3 = nil;

function u1.CreateDefaultSettings() -- Line: 695
    -- upvalues: u1 (copy)
    local v4 = {};

    for _, v in u1.Config do
        for _, v2 in v do
            local Id = v2.Id;

            if Id then
                v4[Id] = v2.DefaultValue;
            end;
        end;
    end;

    return v4;
end;

function u1.GetSettingFromId(p5) -- Line: 707
    -- upvalues: u2 (copy), u1 (copy)
    local v6 = u2[p5];

    if v6 then
        return v6;
    end;

    for _, v in u1.Config do
        for _, v2 in v do
            if v2.Id == p5 then
                u2[p5] = v2;

                return v2;
            end;
        end;
    end;
end;

function u1.SanitizeSliderValue(p7, p8) -- Line: 721
    if type(p8) ~= "number" then
        return nil;
    end;

    if p8 ~= p8 then
        return nil;
    end;

    if math.abs(p8) == (1 / 0) then
        return nil;
    end;

    local v9 = p7.Range[1];
    local v10 = p7.Range[2];
    local v11 = math.round(p8 / p7.InputStep) * p7.InputStep;

    return math.clamp(v11, v9, v10);
end;

function u1.CheckKeybind(p12, p13, p14) -- Line: 729
    -- upvalues: u1 (copy)
    if p14 then
        local SettingFromId = u1.GetSettingFromId(p14);

        if SettingFromId and SettingFromId.IgnoreConflict then
            return;
        end;
    end;

    for i, v in p12 do
        if i ~= p14 and v == p13 then
            local SettingFromId = u1.GetSettingFromId(i);

            if SettingFromId and not SettingFromId.IgnoreConflict then
                return SettingFromId;
            end;
        end;
    end;
end;

local u15 = nil;
local u16 = {
    ButtonStart = true,
    ButtonSelect = true
};

function u1.IsKeybindAllowed(p17, u18) -- Line: 749
    -- upvalues: u1 (copy), u15 (ref), u16 (copy)
    local SettingFromId = u1.GetSettingFromId(p17);

    if not (SettingFromId and (SettingFromId.Type == "Keybind" and type(u18) == "string")) then
        return false;
    end;

    if not u15 then
        u15 = {};

        for _, v in u1.Config.Gamepad do
            if v.Id then
                u15[v.Id] = true;
            end;
        end;
    end;

    local v19 = u15[p17] == true;

    if u18 == "MB2" or (u18 == "M.WheelUp" or u18 == "M.WheelDown") then
        return not v19 and SettingFromId.AllowMouse == true;
    end;

    local success, result = pcall(function() -- Line: 762
        -- upvalues: u18 (copy)
        return Enum.KeyCode[u18];
    end);

    if not (success and (result and result ~= Enum.KeyCode.Unknown)) then
        return false;
    end;

    local v20 = u18:sub(1, 6) == "Button" and true or u18:sub(1, 4) == "DPad";

    if v19 then
        if v20 then
            v20 = not u16[u18];
        end;

        return v20;
    end;

    local v21 = not v20;

    if v21 then
        if u18:sub(1, 10) == "Thumbstick" then
            v21 = false;
        else
            v21 = u18:sub(1, 5) ~= "Mouse";
        end;
    end;

    return v21;
end;

function u1.ApplySettings(p22, p23) -- Line: 773
    -- upvalues: u1 (copy)
    u1.Settings = p22;

    if p23 then
        u1.SkinPresets = p23;
    end;
end;

function u1.GetSkinPreset(p24: table, p25: number, p26: string, p27: any) -- Line: 780
    -- upvalues: u1 (copy)
    local v28 = (p27 or u1.SkinPresets)[tostring(p25)];

    if not v28 then
        return "Default";
    end;

    local v29 = `{p26}/{v28}`;

    return not table.find(p24, v29) and "Default" or v28;
end;

function u1.SetSkinPreset(p30: table?, p31: number, p32: string) -- Line: 788
    if not p30 then
        return;
    end;

    local v33 = tostring(p31);

    if p32 == "Default" then
        p32 = nil;
    end;

    p30[v33] = p32;
end;

function u1.GetSetting(p34: string, p35: string, p36: any) -- Line: 793
    -- upvalues: u1 (copy)
    for _, v in u1.Config[p34] do
        if v.Text == p35 then
            local v37 = p36 or u1.Settings;

            if v37 then
                local v38 = v37[v.Id];

                if v38 ~= nil then
                    return v38;
                end;
            end;

            return v.DefaultValue;
        end;
    end;
end;

function u1.ResetSettings(p39: any, p40: string, p41: any) -- Line: 809
    -- upvalues: u1 (copy)
    local v42 = u1.Config[p40];

    if not v42 then
        return false;
    end;

    local v43 = false;

    for _, v in v42 do
        local Id = v.Id;

        if Id then
            local DefaultValue = v.DefaultValue;
            local v44 = p39[Id] ~= DefaultValue;

            if not v43 and v44 then
                if p41 == false then
                    return true;
                end;

                v43 = true;
            end;

            if p41 ~= false then
                p39[Id] = DefaultValue;

                if v44 and p41 then
                    p41(Id, v);
                end;
            end;
        end;
    end;

    return v43;
end;

function u1.MainMenuOpen() -- Line: 830
    -- upvalues: Players (copy), u3 (ref)
    local LocalPlayer = Players.LocalPlayer;

    if not LocalPlayer then
        return;
    end;

    if not u3 then
        u3 = LocalPlayer.PlayerGui:FindFirstChild("MainMenu");
    end;

    if u3 then
        return u3.Enabled;
    end;
end;

local v45 = {};
local v46 = 0;

for i, v in u1.Config do
    local v47 = i;

    for _, v2 in v do
        local Id = v2.Id;

        if Id then
            local v48 = v45[Id];

            if v48 then
                error((`TWO SETTINGS WITH SAME ID ({Id}) WERE FOUND ({v48.Text} = {v2.Text}, CATEGORY = {v47})`));
            end;

            v45[Id] = v2;
            v46 = math.max(v46, Id);
        end;
    end;
end;

for i = 1, v46 do
    local v49;

    if v45[i] then
        v49 = i;
    else
        error((`GAP BETWEEN SETTING IDS - THIS CAN CAUSE SAVING ISSUES (ID: {i}) (LENGTH: {#v45}) (HIGHEST: {v46})`));
        v49 = i;
    end;
end;

return u1;
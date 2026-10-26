-- [PATH] ReplicatedStorage / Modules / GamepadIconModule @Type ModuleScript


local PlayerScripts = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts");
local u1 = PlayerScripts:FindFirstChild("PreferredInputController") or PlayerScripts:WaitForChild("PreferredInputController", 5);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SettingsModule = require(script.Parent:WaitForChild("SettingsModule"));
local u2 = {
    ButtonA = {
        Xbox = "ButtonA@2x.png",
        PS = "ButtonCross@2x.png"
    },
    ButtonB = {
        Xbox = "ButtonB@2x.png",
        PS = "ButtonCircle@2x.png"
    },
    ButtonX = {
        Xbox = "ButtonX@2x.png",
        PS = "ButtonSquare@2x.png"
    },
    ButtonY = {
        Xbox = "ButtonY@2x.png",
        PS = "ButtonTriangle@2x.png"
    },
    ButtonL1 = {
        Xbox = "ButtonLB@2x.png",
        PS = "ButtonL1@2x.png"
    },
    ButtonR1 = {
        Xbox = "ButtonRB@2x.png",
        PS = "ButtonR1@2x.png"
    },
    ButtonL2 = {
        Xbox = "ButtonLT@2x.png",
        PS = "ButtonL2@2x.png"
    },
    ButtonR2 = {
        Xbox = "ButtonRT@2x.png",
        PS = "ButtonR2@2x.png"
    },
    ButtonL3 = {
        Xbox = "ButtonLS@2x.png",
        PS = "ButtonL3@2x.png"
    },
    ButtonR3 = {
        Xbox = "ButtonRS@2x.png",
        PS = "ButtonR3@2x.png"
    },
    DPadUp = {
        Xbox = "DPadUp@2x.png",
        PS = "DPadUp@2x.png"
    },
    DPadDown = {
        Xbox = "DPadDown@2x.png",
        PS = "DPadDown@2x.png"
    },
    DPadLeft = {
        Xbox = "DPadLeft@2x.png",
        PS = "DPadLeft@2x.png"
    },
    DPadRight = {
        Xbox = "DPadRight@2x.png",
        PS = "DPadRight@2x.png"
    }
};
local u3 = {
    ButtonA = {
        Xbox = "A",
        PS = "CRS"
    },
    ButtonB = {
        Xbox = "B",
        PS = "CIR"
    },
    ButtonX = {
        Xbox = "X",
        PS = "SQR"
    },
    ButtonY = {
        Xbox = "Y",
        PS = "TRI"
    }
};
local u4 = {};
local u5 = {};

local function PruneRegistered() -- Line: 51
    -- upvalues: u5 (copy)
    if #u5 < 200 then
        return;
    end;

    for i = #u5, 1, -1 do
        local Instance = u5[i].Instance;
        local v6;

        if Instance and Instance:IsDescendantOf(game) then
            v6 = i;
        else
            table.remove(u5, i);
            v6 = i;
        end;
    end;
end;

function u4.GetIcon(p7: string) -- Line: 61
    -- upvalues: u1 (copy), u2 (copy)
    local v8 = u1 and u1:GetAttribute("IsPlayStation");
    local v9 = u2[p7];

    if v9 then
        return (v8 and "rbxasset://textures/ui/Controls/PlayStationController/" or "rbxasset://textures/ui/Controls/XboxController/") .. (v8 and v9.PS or v9.Xbox);
    end;

    return "rbxasset://textures/ui/Controls/XboxController/" .. p7 .. "@2x.png";
end;

function u4.GetText(p10: string) -- Line: 71
    -- upvalues: u1 (copy), u3 (copy)
    local v11 = u1 and u1:GetAttribute("IsPlayStation");
    local v12 = u3[p10];

    if v12 then
        return v11 and v12.PS or v12.Xbox;
    end;

    return p10:gsub("^Button", "");
end;

function u4.Register(p13: any, p14: string) -- Line: 80
    -- upvalues: PruneRegistered (copy), u5 (copy), u4 (copy)
    PruneRegistered();
    table.insert(u5, {
        Instance = p13,
        Button = p14
    });
    p13.Image = u4.GetIcon(p14);
end;

function u4.GetBoundButton(p15: string, p16: string) -- Line: 87
    -- upvalues: SettingsModule (copy)
    local Setting = SettingsModule.GetSetting(p15, p16);

    return type(Setting) ~= "string" and "ButtonA" or Setting;
end;

function u4.GetSettingIcon(p17: string, p18: string) -- Line: 92
    -- upvalues: u4 (copy)
    return u4.GetIcon(u4.GetBoundButton(p17, p18));
end;

function u4.RegisterSetting(p19: any, p20: string, p21: string) -- Line: 97
    -- upvalues: PruneRegistered (copy), u5 (copy), u4 (copy)
    PruneRegistered();
    table.insert(u5, {
        Instance = p19,
        Category = p20,
        Setting = p21
    });
    p19.Image = u4.GetSettingIcon(p20, p21);
end;

function u4.UpdateAll() -- Line: 103
    -- upvalues: u5 (copy), u4 (copy)
    for i = #u5, 1, -1 do
        local v22 = u5[i];
        local v23;

        if v22.Instance and v22.Instance.Parent then
            local Instance = v22.Instance;
            local v24;

            if v22.Button then
                v24 = u4.GetIcon(v22.Button);
            else
                v24 = u4.GetSettingIcon(v22.Category, v22.Setting);
            end;

            Instance.Image = v24;
            v23 = i;
        else
            table.remove(u5, i);
            v23 = i;
        end;
    end;
end;

if u1 then
    u1:GetAttributeChangedSignal("IsPlayStation"):Connect(u4.UpdateAll);
end;

ReplicatedStorage:GetAttributeChangedSignal("Settings"):Connect(u4.UpdateAll);
task.spawn(function() -- Line: 120
    -- upvalues: SettingsModule (copy), u4 (copy)
    while not SettingsModule.Settings do
        task.wait(0.5);
    end;

    u4.UpdateAll();
end);

return u4;
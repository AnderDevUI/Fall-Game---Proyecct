-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / NavBarUIModule @Type ModuleScript


local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local SelectedBackground = script:WaitForChild("SelectedBackground");
local Color3_fromRGB_ret = Color3.fromRGB(46, 84, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(75, 123, 255);
local Color3_fromRGB_ret3 = Color3.fromRGB(189, 209, 255);
local UIConstants = require(script.Parent:WaitForChild("UIConstants"));
local script_InventoryUIModule = require(script.InventoryUIModule);
local script_SettingsUIModule = require(script.SettingsUIModule);
local script_ShopUIModule = require(script.ShopUIModule);
local script_MobileUIModule = require(script.MobileUIModule);
local BundleContentsModule = require(script.ShopUIModule.BundleContentsModule);
local CaseContentsModule = require(script.ShopUIModule.CaseContentsModule);
local u1 = nil;
local u2 = nil;
local u3 = nil;

local function ApplyBackgroundImage(p4: userdata) -- Line: 31
    -- upvalues: Color3_fromRGB_ret (copy), SelectedBackground (copy)
    local SelectedBackground2 = p4:FindFirstChild("SelectedBackground");

    if SelectedBackground2 then
        SelectedBackground2.ImageColor3 = Color3_fromRGB_ret;

        return;
    end;

    SelectedBackground:Clone().Parent = p4;
end;

local function GetButtonFromFrameName(p5: string) -- Line: 41
    -- upvalues: UIConstants (copy)
    return UIConstants.NAV_BUTTONS:FindFirstChild(p5 == "ServerList" and "Play" or p5);
end;

local function RememberTab(p6: userdata) -- Line: 54
    -- upvalues: UIConstants (copy)
    local MainMenu = UIConstants.PLAYER_GUI:FindFirstChild("MainMenu");

    if not MainMenu then
        return;
    end;

    MainMenu:SetAttribute("ShopTab", p6.Name);
end;

local function SelectButton(p7: userdata) -- Line: 62
    -- upvalues: u3 (ref), Color3_fromRGB_ret3 (copy), SelectedBackground (copy)
    local Attribute = p7:GetAttribute("BaseSize");
    local Attribute2 = p7:GetAttribute("SizeMultiplier");
    p7.Size = UDim2.new(Attribute.X.Scale * Attribute2, 0, Attribute.Y.Scale * Attribute2, 0);

    if u3 == p7 then
        return;
    end;

    local v8 = p7:FindFirstChild("Detail") and p7.Detail:FindFirstChild("Frame");

    if v8 and v8:FindFirstChild("UIStroke") then
        v8.UIStroke.Color = Color3_fromRGB_ret3;
    end;

    local SelectedBackground2 = p7.Detail:FindFirstChild("SelectedBackground");

    if not SelectedBackground2 then
        SelectedBackground2 = SelectedBackground:Clone();
        SelectedBackground2.Parent = p7.Detail;
    end;

    SelectedBackground2.ImageColor3 = Color3_fromRGB_ret3;
end;

local function DeselectButton(p9: userdata) -- Line: 79
    -- upvalues: u3 (ref)
    if u3 == p9 then
        return;
    end;

    p9.Size = p9:GetAttribute("BaseSize");
    local v10 = p9:FindFirstChild("Detail") and p9.Detail:FindFirstChild("Frame");

    if v10 and v10:FindFirstChild("UIStroke") then
        v10.UIStroke.Color = v10.UIStroke:GetAttribute("Color_Base");
    end;

    local v11 = p9:FindFirstChild("Detail") and p9.Detail:FindFirstChild("SelectedBackground");

    if v11 then
        if v11:GetAttribute("UpdateImage") then
            v11.ImageColor3 = v11:GetAttribute("UpdateImage");

            return;
        end;

        v11:Destroy();
    end;
end;

local u12 = {};

function u12.Load() -- Line: 98
    -- upvalues: script_InventoryUIModule (copy), script_SettingsUIModule (copy), script_ShopUIModule (copy), script_MobileUIModule (copy), u12 (copy)
    script_InventoryUIModule.Load();
    script_SettingsUIModule.Load();
    script_ShopUIModule.Load();
    script_MobileUIModule.Load();
    u12.RunShopDecalLoop();
end;

function u12.ChangeFrame(p13: userdata?) -- Line: 111
    -- upvalues: BundleContentsModule (copy), CaseContentsModule (copy), UIConstants (copy), u1 (ref), u2 (ref), DeselectButton (copy), SelectButton (copy)
    BundleContentsModule.Close();
    CaseContentsModule.Close();
    local v14 = p13 or UIConstants.FRAME_SETTINGS;
    local Name = v14.Name;
    local v15 = UIConstants.NAV_BUTTONS:FindFirstChild(Name == "ServerList" and "Play" or Name);

    if u1 == v14 then
        return;
    end;

    if u2 and u2 ~= v15 then
        DeselectButton(u2);
    end;

    if u1 and u1 ~= v14 then
        u1.Visible = false;
    end;

    u1 = v14;
    u2 = v15;
    u1.Visible = true;

    if u2 then
        SelectButton(u2);
    end;

    local MainMenu = UIConstants.PLAYER_GUI:FindFirstChild("MainMenu");

    if not MainMenu then
        return;
    end;

    MainMenu:SetAttribute("ShopTab", u1.Name);
end;

function u12.RestoreTab() -- Line: 139
    -- upvalues: UIConstants (copy), u12 (copy)
    local MainMenu = UIConstants.PLAYER_GUI:FindFirstChild("MainMenu");

    if MainMenu then
        MainMenu = MainMenu:GetAttribute("ShopTab");
    end;

    local v16;

    if type(MainMenu) == "string" then
        v16 = UIConstants.FRAME_MAIN:FindFirstChild(MainMenu);
    else
        v16 = nil;
    end;

    u12.ChangeFrame(v16);
end;

function u12.Enter(p17: userdata) -- Line: 146
    -- upvalues: u3 (ref), u2 (ref), Color3_fromRGB_ret2 (copy), SelectedBackground (copy), Color3_fromRGB_ret (copy), TweenService (copy)
    u3 = p17;

    if p17:FindFirstChild("Detail") and (p17.Detail:FindFirstChild("Frame") and p17.Detail.Frame:FindFirstChild("UIStroke")) then
        p17.Detail.Frame.UIStroke.Color = Color3_fromRGB_ret2;
    end;

    local v18;

    if p17:FindFirstChild("Detail") and p17.Detail:FindFirstChild("SelectedBackground") then
        v18 = p17.Detail.SelectedBackground;
    else
        v18 = SelectedBackground:Clone();
        v18.Parent = p17.Detail;
    end;

    v18.ImageColor3 = Color3_fromRGB_ret;

    if u2 == p17 then
        return;
    end;

    local Attribute = p17:GetAttribute("BaseSize");
    local Attribute2 = p17:GetAttribute("SizeMultiplier");
    TweenService:Create(p17, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0), {
        Size = UDim2.new(Attribute.X.Scale * Attribute2, 0, Attribute.Y.Scale * Attribute2, 0)
    }):Play();
end;

function u12.Leave(p19: userdata) -- Line: 182
    -- upvalues: u3 (ref), u2 (ref), Color3_fromRGB_ret3 (copy)
    if u3 == p19 then
        u3 = nil;
    end;

    local v20 = u2 == p19;

    if p19:FindFirstChild("Detail") and (p19.Detail:FindFirstChild("Frame") and p19.Detail.Frame:FindFirstChild("UIStroke")) then
        local UIStroke = p19.Detail.Frame.UIStroke;
        UIStroke.Color = v20 and Color3_fromRGB_ret3 or UIStroke:GetAttribute("Color_Base");
    end;

    local v21;

    if p19:FindFirstChild("Detail") and p19.Detail:FindFirstChild("SelectedBackground") then
        v21 = p19.Detail.SelectedBackground;
    else
        v21 = nil;
    end;

    if v21 then
        if v21:GetAttribute("UpdateImage") then
            v21.ImageColor3 = v20 and Color3_fromRGB_ret3 or v21:GetAttribute("UpdateImage");
        elseif v20 then
            v21.ImageColor3 = Color3_fromRGB_ret3;
        else
            v21:Destroy();
        end;
    end;

    if v20 then
        return;
    end;

    p19.Size = p19:GetAttribute("BaseSize");
end;

function u12.RunShopDecalLoop() -- Line: 220
    -- upvalues: UIConstants (copy), RunService (copy)
    local u22 = 1;
    local u23 = 1.01;
    local u24 = true;
    local Size = UIConstants.NAV_BUTTON_SHOP_ROTATER.Size;
    local u25 = false;
    RunService:BindToRenderStep("ShopRotation", Enum.RenderPriority.Camera.Value, function(p26: number) -- Line: 227, Name: ApplyRotation
        -- upvalues: u25 (ref), UIConstants (ref), u22 (ref), Size (copy), u23 (ref), u24 (ref)
        if u25 then
            u25 = false;

            return;
        end;

        u25 = true;
        UIConstants.NAV_BUTTON_SHOP_ROTATER.Rotation = u22;
        UIConstants.NAV_BUTTON_SHOP_ROTATER.Size = UDim2.new(Size.X.Scale * u23, 0, Size.Y.Scale * u23, 0);

        if u22 >= 360 then
            u22 = 0;
        else
            u22 = u22 + 1;
        end;

        if u24 and u23 >= 1.2 then
            u24 = false;
        elseif not u24 and u23 <= 0.8 then
            u24 = true;
        end;

        u23 = u23 + (u24 and p26 * 0.005 or p26 * -0.005);
        task.wait();
    end);
end;

return u12;
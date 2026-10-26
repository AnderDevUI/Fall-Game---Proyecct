-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / NavBarUIModule / SettingsUIModule @Type ModuleScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local Mouse = Players.LocalPlayer:GetMouse();
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Parent = script.Parent.Parent;
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local ConfirmModule = require(Parent:WaitForChild("ConfirmModule"));
local SoundModule = require(Parent:WaitForChild("SoundModule"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local SettingRemotes = ReplicatedStorage:WaitForChild("SettingRemotes");
local Color3_fromRGB_ret = Color3.fromRGB(75, 123, 255);
local Color3_new_ret = Color3.new(1, 1, 1);
local UIConstants = require(Parent:WaitForChild("UIConstants"));
local GamepadService = game:GetService("GamepadService");
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = 0;
local u11 = nil;
local u12 = nil;
local u13, v14;

if SettingsModule.Settings then
    u13 = SettingsModule.Settings;
    v14 = SettingsModule.SkinPresets;
else
    u13, v14 = SettingRemotes:WaitForChild("Fetch"):InvokeServer();
end;

SettingsModule.ApplySettings(u13, v14);

local function UpdateCheckbox(p15, u16, p17) -- Line: 52
    -- upvalues: TweenService (copy)
    local Bar = p15.Bar;

    if not Bar then
        warn("UpdateCheckbox called without barFrame found");

        return;
    end;

    Bar.BarGreen.Position = Bar.BarGreen:GetAttribute(u16 and "PositionFalse" or "PositionTrue");
    Bar.BarGreen.Visible = not u16;
    Bar.BarRed.Position = Bar.BarGreen:GetAttribute(u16 and "PositionFalse" or "PositionTrue");
    Bar.BarRed.Visible = u16;
    local v18 = {
        Position = Bar.BarGreen:GetAttribute(u16 and "PositionTrue" or "PositionFalse")
    };
    local TweenInfo_new_ret = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
    local v19 = TweenService:Create(Bar.BarGreen, TweenInfo_new_ret, v18);
    local v20 = TweenService:Create(Bar.BarRed, TweenInfo_new_ret, v18);
    v19:Play();
    v20:Play();
    v19.Completed:Connect(function() -- Line: 69
        -- upvalues: Bar (copy), u16 (copy)
        Bar.BarGreen.Visible = u16;
        Bar.BarRed.Visible = not u16;
    end);
end;

local function UpdateSlider(p21, p22, p23, p24, p25) -- Line: 75
    -- upvalues: NumberUtil (copy)
    local v26 = p23.Range[1];
    local v27 = p23.Range[2];
    local v28 = tonumber(p22) or v26;
    local math_clamp_ret = math.clamp(v28, v26, v27);
    local v29 = math.max(math_clamp_ret - v26, 0) / (v27 - v26);

    if v26 > 0 then
        v29 = 0.02 + v29 * 0.98;
    end;

    local UDim2_new_ret = UDim2.new(v29, 0, 1, 0);

    if p25 then
        p21.Holder.ColorImage.Size = UDim2_new_ret;
    else
        p21.Holder.ColorImage:TweenSize(UDim2_new_ret, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.12, true);
    end;

    if not p24 then
        p21.Frame.NumberDisplay.Text = tostring(NumberUtil:RoundNumber(math_clamp_ret, 3));
    end;

    return math_clamp_ret;
end;

local function UpdateKeybind(p30, u31, p32) -- Line: 93
    -- upvalues: UIConstants (copy), SettingsModule (copy), u13 (ref), u4 (ref), u9 (ref), UserInputService (copy)
    local v33 = false;
    local v34;

    if type(u31) == "string" then
        if u31 == "MB2" or u31:find("M.Wheel") then
            v34 = u31;
            v33 = true;
        else
            local v35;
            v35, v34 = pcall(function() -- Line: 102
                -- upvalues: u31 (copy)
                return Enum.KeyCode[u31];
            end);

            if not (v35 and v34) then
                return false;
            end;

            u31 = v34.Name;
        end;
    else
        v34 = u31;
        u31 = u31.Name;
    end;

    if p30:IsDescendantOf(UIConstants.SETTINGS_CHANGEKEY) then
        local v36 = SettingsModule.CheckKeybind(u13, u31, p32 or u4);
        local Description = UIConstants.SETTINGS_CHANGEKEY.Frame.Description;
        local v37;

        if v36 then
            v37 = `KEYBIND CANNOT BE SET - CONFLICTING WITH [{v36.Text:upper()}]`;
        else
            v37 = u9 and "Press a controller button to set this hotkey, or its current one to cancel" or "Press a key on your keyboard to adjust this hotkey";
        end;

        Description.Text = v37;
        UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons.Save.Visible = v36 == nil;
    end;

    local v38;

    if v33 then
        v38 = nil;
    else
        v38 = UserInputService:GetImageForKeyCode(v34);
    end;

    if v38 and v38 ~= "" then
        p30.KeyImage.Image = v38;
        p30.KeyImage.Visible = true;
        p30.KeyText.Visible = false;
    else
        local v39;

        if v33 then
            v39 = u31;
        else
            v39 = UserInputService:GetStringForKeyCode(v34);
        end;

        if v39 and (v39 ~= "" and v39 ~= " ") then
            u31 = v39;
        end;

        p30.KeyText.Text = u31;
        p30.KeyImage.Visible = false;
        p30.KeyText.Visible = true;
    end;

    return true;
end;

local function UpdateReset() -- Line: 132
    -- upvalues: UIConstants (copy), SettingsModule (copy), u13 (ref), u2 (ref)
    UIConstants.SETTINGS_RESET.Visible = SettingsModule.ResetSettings(u13, u2, false);
end;

local function SetSetting(p40, p41, p42) -- Line: 136
    -- upvalues: u13 (ref), UIConstants (copy), SettingsModule (copy), u2 (ref), SettingRemotes (copy), ReplicatedStorage (copy)
    u13[p40] = p41;
    UIConstants.SETTINGS_RESET.Visible = SettingsModule.ResetSettings(u13, u2, false);

    if not p42 then
        return;
    end;

    SettingRemotes.Update:FireServer("Settings", p40, p41);
    ReplicatedStorage:SetAttribute("Settings", true);
end;

local function UpdateSetting(p43, p44, p45, p46, p47) -- Line: 144
    -- upvalues: SettingsModule (copy), UIConstants (copy), u13 (ref), UpdateCheckbox (copy), UpdateSlider (copy), UpdateKeybind (copy)
    local v48 = p46 or SettingsModule.GetSettingFromId(p44);
    local Type = v48.Type;
    local v49 = p45 or UIConstants.FRAME_SETTINGS[p43].Frame:FindFirstChild((tostring(p44)));

    if not v49 then
        return;
    end;

    local v50 = u13[p44];

    if Type == "Checkbox" then
        UpdateCheckbox(v49.ClickButton, v50, p47);

        return;
    end;

    if Type == "Slider" then
        UpdateSlider(v49.DragSlider, v50, v48, false, p47);

        return;
    end;

    if Type == "Keybind" then
        UpdateKeybind(v49.ClickButton, v50, p44);
    end;
end;

local function SelectNavButton(p51: userdata) -- Line: 163
    -- upvalues: u1 (ref), u2 (ref), UIConstants (copy), Color3_new_ret (copy), Color3_fromRGB_ret (copy), SettingsModule (copy), u13 (ref)
    if u1 == p51 then
        return;
    end;

    local v52 = u2 and UIConstants.FRAME_SETTINGS:FindFirstChild(u2);

    if v52 then
        v52.Visible = false;
    end;

    if u1 then
        u1.Detail.Frame.UIStroke.Color = u1.Detail.Frame.UIStroke:GetAttribute("ColorDefault");
        u1.Detail.Frame.TextLabel.TextColor3 = Color3_new_ret;
    end;

    u2 = p51.Name;
    u1 = p51;
    UIConstants.FRAME_SETTINGS:FindFirstChild(u2).Visible = true;
    p51.Detail.Frame.UIStroke.Color = Color3_fromRGB_ret;
    p51.Detail.Frame.TextLabel.TextColor3 = Color3_fromRGB_ret;
    UIConstants.SETTINGS_RESET.Visible = SettingsModule.ResetSettings(u13, u2, false);
end;

local function HoverNavButton(p53: userdata) -- Line: 185
    -- upvalues: u1 (ref), Color3_new_ret (copy)
    if u1 == p53 then
        return;
    end;

    p53.Detail.Frame.UIStroke.Color = Color3_new_ret;
end;

local function LeaveNavButton(p54: userdata) -- Line: 191
    -- upvalues: u1 (ref)
    if u1 == p54 then
        return;
    end;

    local UIStroke = p54.Detail.Frame.UIStroke;
    UIStroke.Color = UIStroke:GetAttribute("ColorDefault");
end;

local function HoverSound(p55: userdata) -- Line: 198
    -- upvalues: SoundModule (copy)
    p55.MouseEnter:Connect(function() -- Line: 199
        -- upvalues: SoundModule (ref)
        SoundModule.PlaySound("Hover");
    end);
end;

local u56 = {};

local function FitCanvas(p57: userdata) -- Line: 209
    -- upvalues: u56 (copy)
    local v58 = not (p57.Parent and p57.Parent:IsA("GuiObject")) and 0 or p57.Parent.AbsoluteSize.Y;

    if v58 <= 0 or p57.AbsoluteSize.Y <= 0 then
        return;
    end;

    local v59 = p57.AbsoluteSize.Y / v58;
    local v60 = p57:FindFirstChildOfClass("UIListLayout");
    local v61 = 0;
    local v62 = 0;

    for _, child in p57:GetChildren() do
        local v63 = u56[child];

        if v63 then
            v61 = v61 + v63;
            v62 = v62 + 1;
        end;
    end;

    local v64 = v61 + (not v60 and 0 or v60.Padding.Offset) * math.max(v62 - 1, 0) / v58;
    local math_max_ret = math.max(v64, v59);
    p57.CanvasSize = UDim2.new(p57.CanvasSize.X.Scale, p57.CanvasSize.X.Offset, math_max_ret, 0);

    for _, child in p57:GetChildren() do
        local v65 = u56[child];

        if v65 then
            child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, v65 / math_max_ret, child.Size.Y.Offset);
        end;
    end;

    local v66 = v59 + 0.0001 < math_max_ret;
    p57.ScrollingEnabled = v66;

    if not v66 then
        p57.CanvasPosition = Vector2.zero;
    end;
end;

local function RestoreGamepadCursor() -- Line: 236
    -- upvalues: u11 (ref), u12 (ref), GamepadService (copy)
    u11 = false;
    u12 = nil;
    pcall(function() -- Line: 239
        -- upvalues: GamepadService (ref)
        GamepadService:EnableGamepadCursor(nil);
    end);
end;

local function CloseHotkey(p67) -- Line: 244
    -- upvalues: UIConstants (copy), u11 (ref), u12 (ref), GamepadService (copy)
    UIConstants.SETTINGS_CHANGEKEY.Visible = false;

    if not u11 then
        return;
    end;

    if p67 then
        u12 = p67;

        return;
    end;

    u11 = false;
    u12 = nil;
    pcall(function() -- Line: 239
        -- upvalues: GamepadService (ref)
        GamepadService:EnableGamepadCursor(nil);
    end);
end;

local function SaveHotkey(p68) -- Line: 254
    -- upvalues: u6 (ref), UIConstants (copy), u11 (ref), u12 (ref), GamepadService (copy), u13 (ref), u4 (ref), SettingsModule (copy), u2 (ref), SettingRemotes (copy), ReplicatedStorage (copy), UpdateKeybind (copy), u7 (ref)
    if not u6 then
        return;
    end;

    UIConstants.SETTINGS_CHANGEKEY.Visible = false;

    if u11 then
        if p68 then
            u12 = p68;
        else
            u11 = false;
            u12 = nil;
            pcall(function() -- Line: 239
                -- upvalues: GamepadService (ref)
                GamepadService:EnableGamepadCursor(nil);
            end);
        end;
    end;

    local v69;

    if type(u6) == "string" then
        v69 = u6;
    else
        v69 = u6.Name;
    end;

    if v69 == u13[u4] then
        return;
    end;

    if not SettingsModule.IsKeybindAllowed(u4, v69) then
        return;
    end;

    local v70 = u4;
    u13[v70] = v69;
    UIConstants.SETTINGS_RESET.Visible = SettingsModule.ResetSettings(u13, u2, false);
    SettingRemotes.Update:FireServer("Settings", v70, v69);
    ReplicatedStorage:SetAttribute("Settings", true);
    UpdateKeybind(u7, v69);
end;

local function HotkeyFromInput(p71: userdata) -- Line: 266
    -- upvalues: SettingsModule (copy), u4 (ref)
    local UserInputType = p71.UserInputType;
    local v72;

    if UserInputType == Enum.UserInputType.MouseButton2 then
        v72 = "MB2";
    elseif UserInputType == Enum.UserInputType.MouseWheel then
        v72 = p71.Position.Z > 0 and "M.WheelUp" or "M.WheelDown";
    else
        if UserInputType ~= Enum.UserInputType.Keyboard and UserInputType.Name:sub(1, 7) ~= "Gamepad" then
            return nil;
        end;

        v72 = p71.KeyCode;
    end;

    local v73;

    if type(v72) == "string" then
        v73 = v72;
    else
        v73 = v72.Name;
    end;

    if SettingsModule.IsKeybindAllowed(u4, v73) then
        return v72;
    end;

    return nil;
end;

return {
    Load = function() -- Line: 284
        -- upvalues: UIConstants (copy), SoundModule (copy), SelectNavButton (copy), u1 (ref), Color3_new_ret (copy), u11 (ref), u12 (ref), GamepadService (copy), SaveHotkey (copy), u8 (ref), u2 (ref), ConfirmModule (copy), SettingRemotes (copy), SettingsModule (copy), u13 (ref), UpdateSetting (copy), UserInputService (copy), u10 (ref), HotkeyFromInput (copy), u6 (ref), UpdateKeybind (copy), u9 (ref), u3 (ref), u5 (ref), ReplicatedStorage (copy), UpdateCheckbox (copy), Mouse (copy), NumberUtil (copy), UpdateSlider (copy), u4 (ref), u7 (ref), u56 (copy), FitCanvas (copy)
        for _, child in pairs(UIConstants.SETTINGS_NAV:GetChildren()) do
            if child:IsA("TextButton") then
                child.MouseButton1Click:Connect(function() -- Line: 290
                    -- upvalues: SoundModule (ref), SelectNavButton (ref), child (copy)
                    SoundModule.PlaySound("Click");
                    SelectNavButton(child);
                end);
                child.MouseEnter:Connect(function() -- Line: 294
                    -- upvalues: SoundModule (ref), child (copy), u1 (ref), Color3_new_ret (ref)
                    SoundModule.PlaySound("Hover");
                    local v74 = child;

                    if u1 == v74 then
                        return;
                    end;

                    v74.Detail.Frame.UIStroke.Color = Color3_new_ret;
                end);
                child.MouseLeave:Connect(function() -- Line: 298
                    -- upvalues: child (copy), u1 (ref)
                    local v75 = child;

                    if u1 == v75 then
                        return;
                    end;

                    local UIStroke = v75.Detail.Frame.UIStroke;
                    UIStroke.Color = UIStroke:GetAttribute("ColorDefault");
                end);
            end;
        end;

        UIConstants.SETTINGS_CHANGEKEY:WaitForChild("Frame"):WaitForChild("Buttons"):WaitForChild("Cancel").MouseButton1Click:Connect(function() -- Line: 304
            -- upvalues: SoundModule (ref), UIConstants (ref), u11 (ref), u12 (ref), GamepadService (ref)
            SoundModule.PlaySound("Click");
            UIConstants.SETTINGS_CHANGEKEY.Visible = false;

            if not u11 then
                return;
            end;

            u11 = false;
            u12 = nil;
            pcall(function() -- Line: 239
                -- upvalues: GamepadService (ref)
                GamepadService:EnableGamepadCursor(nil);
            end);
        end);
        UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons.Cancel.MouseEnter:Connect(function() -- Line: 308
            -- upvalues: SoundModule (ref), UIConstants (ref), u1 (ref), Color3_new_ret (ref)
            SoundModule.PlaySound("Hover");
            local Cancel = UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons.Cancel;

            if u1 == Cancel then
                return;
            end;

            Cancel.Detail.Frame.UIStroke.Color = Color3_new_ret;
        end);
        UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons.Cancel.MouseLeave:Connect(function() -- Line: 312
            -- upvalues: UIConstants (ref), u1 (ref)
            local Cancel = UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons.Cancel;

            if u1 == Cancel then
                return;
            end;

            local UIStroke = Cancel.Detail.Frame.UIStroke;
            UIStroke.Color = UIStroke:GetAttribute("ColorDefault");
        end);
        UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons:WaitForChild("Save").MouseButton1Click:Connect(function() -- Line: 315
            -- upvalues: SoundModule (ref), SaveHotkey (ref)
            SoundModule.PlaySound("Click");
            SaveHotkey();
        end);
        UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons.Save.MouseEnter:Connect(function() -- Line: 319
            -- upvalues: SoundModule (ref), UIConstants (ref), u1 (ref), Color3_new_ret (ref)
            SoundModule.PlaySound("Hover");
            local Save = UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons.Save;

            if u1 == Save then
                return;
            end;

            Save.Detail.Frame.UIStroke.Color = Color3_new_ret;
        end);
        UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons.Save.MouseLeave:Connect(function() -- Line: 323
            -- upvalues: UIConstants (ref), u1 (ref)
            local Save = UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons.Save;

            if u1 == Save then
                return;
            end;

            local UIStroke = Save.Detail.Frame.UIStroke;
            UIStroke.Color = UIStroke:GetAttribute("ColorDefault");
        end);
        UIConstants.SETTINGS_RESET.MouseEnter:Connect(function() -- Line: 199
            -- upvalues: SoundModule (ref)
            SoundModule.PlaySound("Hover");
        end);
        UIConstants.SETTINGS_RESET.MouseButton1Click:Connect(function() -- Line: 329
            -- upvalues: SoundModule (ref), u8 (ref), u2 (ref), ConfirmModule (ref), SettingRemotes (ref), SettingsModule (ref), u13 (ref), UpdateSetting (ref), UIConstants (ref)
            SoundModule.PlaySound("Click");

            if u8 then
                return;
            end;

            u8 = u2;
            local v76 = ConfirmModule.Prompt("NONE", "Are you sure you want to reset this category to default settings?");
            local u77 = u8;
            u8 = nil;

            if not v76 then
                return;
            end;

            if SettingRemotes.Reset:InvokeServer(u77) then
                SettingsModule.ResetSettings(u13, u77, function(p78, p79) -- Line: 340
                    -- upvalues: UpdateSetting (ref), u77 (copy)
                    UpdateSetting(u77, p78, nil, p79, false);
                end);
                UIConstants.SETTINGS_RESET.Visible = SettingsModule.ResetSettings(u13, u2, false);
            end;
        end);
        local Teleport = SettingRemotes:FindFirstChild("Teleport");
        local ReturnToMenu = UIConstants.FRAME_SETTINGS:FindFirstChild("ReturnToMenu");

        if Teleport and ReturnToMenu then
            local TextLabel = ReturnToMenu.Frame.TextLabel;
            local Text = TextLabel.Text;
            local u80 = false;
            local u81 = false;
            ReturnToMenu.Visible = true;
            ReturnToMenu.MouseEnter:Connect(function() -- Line: 199
                -- upvalues: SoundModule (ref)
                SoundModule.PlaySound("Hover");
            end);
            ReturnToMenu.Activated:Connect(function() -- Line: 356
                -- upvalues: SoundModule (ref), u81 (ref), u80 (ref), TextLabel (copy), Text (copy), Teleport (copy)
                SoundModule.PlaySound("Click");

                if u81 then
                    return;
                end;

                if u80 then
                    u81 = true;
                    TextLabel.Text = "TELEPORTING...";
                    Teleport:FireServer();
                    task.wait(30);
                    TextLabel.Text = Text;
                    u81 = false;

                    return;
                end;

                u80 = true;

                for i = 3, 1, -1 do
                    if u81 then
                        break;
                    end;

                    TextLabel.Text = `ARE YOU SURE? ({i})`;
                    task.wait(1);
                    local _ = i;
                end;

                u80 = false;

                if u81 then
                    return;
                end;

                TextLabel.Text = Text;
            end);
            ReturnToMenu.AnchorPoint = Vector2.new(0.5, 0.5);
            ReturnToMenu.Position = UDim2.fromScale(0.115, 0.496);
            ReturnToMenu.Size = UDim2.fromScale(0.143, 0.217);
            ReturnToMenu.ZIndex = 2;
            ReturnToMenu.Parent = UIConstants.FRAME_NAVBAR;
        end;

        UserInputService.InputBegan:Connect(function(p82) -- Line: 391
            -- upvalues: UIConstants (ref), u10 (ref), HotkeyFromInput (ref), u6 (ref), UpdateKeybind (ref), u9 (ref), SoundModule (ref), SaveHotkey (ref)
            if not UIConstants.SETTINGS_CHANGEKEY.Visible then
                return;
            end;

            if os.clock() - u10 < 0.2 then
                return;
            end;

            local v83 = HotkeyFromInput(p82);

            if not v83 then
                return;
            end;

            u6 = v83;
            UpdateKeybind(UIConstants.SETTINGS_CHANGEKEY.Frame.Frame, u6);

            if u9 and UIConstants.SETTINGS_CHANGEKEY.Frame.Buttons.Save.Visible then
                SoundModule.PlaySound("Click");
                SaveHotkey(p82.KeyCode);
            end;
        end);
        UserInputService.InputChanged:Connect(function(p84) -- Line: 405
            -- upvalues: UIConstants (ref), HotkeyFromInput (ref), u6 (ref), UpdateKeybind (ref)
            if not UIConstants.SETTINGS_CHANGEKEY.Visible then
                return;
            end;

            if p84.UserInputType ~= Enum.UserInputType.MouseWheel then
                return;
            end;

            local v85 = HotkeyFromInput(p84);

            if not v85 then
                return;
            end;

            u6 = v85;
            UpdateKeybind(UIConstants.SETTINGS_CHANGEKEY.Frame.Frame, u6);
        end);
        UserInputService.InputEnded:Connect(function(p86) -- Line: 414
            -- upvalues: u12 (ref), u11 (ref), GamepadService (ref), u3 (ref), u13 (ref), u5 (ref), SettingRemotes (ref), ReplicatedStorage (ref)
            if u12 and p86.KeyCode == u12 then
                u11 = false;
                u12 = nil;
                pcall(function() -- Line: 239
                    -- upvalues: GamepadService (ref)
                    GamepadService:EnableGamepadCursor(nil);
                end);
            end;

            local UserInputType = p86.UserInputType;
            local v87;

            if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
                v87 = true;
            elseif UserInputType == Enum.UserInputType.Gamepad1 then
                v87 = p86.KeyCode == Enum.KeyCode.ButtonA;
            else
                v87 = false;
            end;

            if v87 and u3 then
                local v88 = u13[u3];

                if v88 ~= u5 then
                    SettingRemotes.Update:FireServer("Settings", u3, v88);
                    ReplicatedStorage:SetAttribute("Settings", true);
                end;

                u3 = nil;
            end;
        end);

        for _, v in SettingsModule.Categories do
            local Frame = UIConstants.FRAME_SETTINGS:WaitForChild(v):WaitForChild("Frame");
            local Scale = Frame.CanvasSize.Y.Scale;
            local v89 = SettingsModule.Config[v];

            if v89 then
                local u90 = v;

                for _, v2 in v89 do
                    if not v2.Hidden then
                        local Type = v2.Type;
                        local Id = v2.Id;
                        local v91 = script[Type]:Clone();

                        if Type == "Checkbox" then
                            local ClickButton = v91.ClickButton;
                            ClickButton.MouseEnter:Connect(function() -- Line: 199
                                -- upvalues: SoundModule (ref)
                                SoundModule.PlaySound("Hover");
                            end);
                            ClickButton.Activated:Connect(function() -- Line: 445
                                -- upvalues: SoundModule (ref), u13 (ref), Id (copy), UIConstants (ref), SettingsModule (ref), u2 (ref), SettingRemotes (ref), ReplicatedStorage (ref), UpdateCheckbox (ref), ClickButton (copy)
                                SoundModule.PlaySound("Click");
                                local v92 = not u13[Id];
                                local v93 = Id;
                                u13[v93] = v92;
                                UIConstants.SETTINGS_RESET.Visible = SettingsModule.ResetSettings(u13, u2, false);
                                SettingRemotes.Update:FireServer("Settings", v93, v92);
                                ReplicatedStorage:SetAttribute("Settings", true);
                                UpdateCheckbox(ClickButton, v92);
                            end);
                        elseif Type == "Slider" then
                            local DragSlider = v91.DragSlider;
                            local NumberDisplay = DragSlider.Frame.NumberDisplay;
                            local u94 = v2.Range[1];
                            local u95 = v2.Range[2];
                            local SliderStep = v2.SliderStep;
                            local _ = v2.InputStep;
                            DragSlider.MouseEnter:Connect(function() -- Line: 199
                                -- upvalues: SoundModule (ref)
                                SoundModule.PlaySound("Hover");
                            end);
                            DragSlider.MouseButton1Down:Connect(function() -- Line: 459
                                -- upvalues: u3 (ref), SoundModule (ref), Id (copy), u5 (ref), u13 (ref), DragSlider (copy), Mouse (ref), NumberUtil (ref), u94 (copy), u95 (copy), SliderStep (copy), UpdateSlider (ref), v2 (copy), UIConstants (ref), SettingsModule (ref), u2 (ref)
                                if u3 then
                                    return;
                                end;

                                SoundModule.PlaySound("Click");
                                u3 = Id;
                                u5 = u13[Id];

                                while u3 and DragSlider.Parent do
                                    local X = DragSlider.AbsoluteSize.X;
                                    local v96 = math.max(Mouse.X - DragSlider.AbsolutePosition.X, 0) / X;
                                    local v97 = NumberUtil:Lerp(u94, u95, (math.min(v96, 1))) / SliderStep;
                                    local v98 = math.round(v97) * SliderStep;
                                    local math_max_ret = math.max(v98, u94);

                                    if math_max_ret ~= u13[Id] then
                                        u13[Id] = UpdateSlider(DragSlider, math_max_ret, v2, false);
                                        UIConstants.SETTINGS_RESET.Visible = SettingsModule.ResetSettings(u13, u2, false);
                                    end;

                                    task.wait();
                                end;
                            end);
                            NumberDisplay.Focused:Connect(function() -- Line: 477
                                -- upvalues: SoundModule (ref)
                                SoundModule.PlaySound("Click");
                            end);
                            NumberDisplay:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 480
                                -- upvalues: DragSlider (copy), NumberDisplay (copy), UpdateSlider (ref), v2 (copy)
                                if not DragSlider.Parent then
                                    return;
                                end;

                                local v99 = tonumber(NumberDisplay.Text);

                                if not v99 then
                                    return;
                                end;

                                UpdateSlider(DragSlider, v99, v2, true);
                            end);
                            NumberDisplay.FocusLost:Connect(function() -- Line: 486
                                -- upvalues: DragSlider (copy), u13 (ref), Id (copy), NumberDisplay (copy), UpdateSlider (ref), v2 (copy), SettingsModule (ref), UIConstants (ref), u2 (ref), SettingRemotes (ref), ReplicatedStorage (ref)
                                if not DragSlider.Parent then
                                    return;
                                end;

                                local v100 = u13[Id];
                                local v101 = tonumber(NumberDisplay.Text);

                                if not v101 then
                                    UpdateSlider(DragSlider, v100, v2, false);

                                    return;
                                end;

                                local v102 = SettingsModule.SanitizeSliderValue(v2, v101);

                                if not v102 then
                                    UpdateSlider(DragSlider, v100, v2, false);

                                    return;
                                end;

                                local v103 = UpdateSlider(DragSlider, v102, v2, false);

                                if v103 == u13[Id] then
                                    return;
                                end;

                                local v104 = Id;
                                u13[v104] = v103;
                                UIConstants.SETTINGS_RESET.Visible = SettingsModule.ResetSettings(u13, u2, false);
                                SettingRemotes.Update:FireServer("Settings", v104, v103);
                                ReplicatedStorage:SetAttribute("Settings", true);
                            end);
                        elseif Type == "Keybind" then
                            local ClickButton = v91.ClickButton;
                            ClickButton.MouseEnter:Connect(function() -- Line: 199
                                -- upvalues: SoundModule (ref)
                                SoundModule.PlaySound("Hover");
                            end);
                            ClickButton.Activated:Connect(function() -- Line: 506
                                -- upvalues: SoundModule (ref), u13 (ref), Id (copy), u9 (ref), u90 (copy), UpdateKeybind (ref), UIConstants (ref), u4 (ref), u6 (ref), u7 (ref), ClickButton (copy), u10 (ref), v2 (copy), GamepadService (ref), u11 (ref), u12 (ref)
                                SoundModule.PlaySound("Click");
                                local v105 = u13[Id];
                                u9 = u90 == "Gamepad";

                                if not UpdateKeybind(UIConstants.SETTINGS_CHANGEKEY.Frame.Frame, v105, Id) then
                                    return;
                                end;

                                u4 = Id;

                                if v105 ~= "MB2" and not v105:find("M.Wheel") then
                                    v105 = Enum.KeyCode[v105];
                                end;

                                u6 = v105;
                                u7 = ClickButton;
                                u10 = os.clock();
                                UIConstants.SETTINGS_CHANGEKEY.Frame.HotkeyName.Text = v2.Text;
                                UIConstants.SETTINGS_CHANGEKEY.Visible = true;

                                if u9 and GamepadService.GamepadCursorEnabled then
                                    u11 = true;
                                    u12 = nil;
                                    pcall(function() -- Line: 522
                                        -- upvalues: GamepadService (ref)
                                        GamepadService:DisableGamepadCursor();
                                    end);
                                end;
                            end);
                        end;

                        if Id then
                            UpdateSetting(u90, Id, v91, v2, true);
                        end;

                        v91.Name = not Id and "Header" or tostring(Id);
                        v91.Size = UDim2.new(v91.Size.X.Scale, v91.Size.X.Offset, v91.Size.Y.Scale * (u90 == "Controls" and 0.8 or 1), v91.Size.Y.Offset);
                        v91.Description.Text = v2.Text;
                        v91.Parent = Frame;
                        v91.Visible = true;
                        u56[v91] = v91.Size.Y.Scale * Scale;
                    end;
                end;

                FitCanvas(Frame);
                Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 537
                    -- upvalues: FitCanvas (ref), Frame (copy)
                    FitCanvas(Frame);
                end);
            end;
        end;

        SelectNavButton(UIConstants.FRAME_SETTINGS:WaitForChild("NavBar"):WaitForChild("General"));
        UIConstants.SETTINGS_RESET.Visible = SettingsModule.ResetSettings(u13, u2, false);
    end
};
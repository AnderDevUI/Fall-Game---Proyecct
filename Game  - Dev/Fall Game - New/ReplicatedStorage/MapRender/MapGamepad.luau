-- [PATH] ReplicatedStorage / MapRender / MapGamepad @Type ModuleScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ContextActionService = game:GetService("ContextActionService");
local RunService = game:GetService("RunService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local GuiUtil = require(Modules:WaitForChild("GuiUtil"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local GamepadIconModule = require(Modules:WaitForChild("GamepadIconModule"));
local LocalPlayer = Players.LocalPlayer;
local u1 = Enum.ContextActionPriority.High.Value + 100;
local u2 = {
    Enum.KeyCode.ButtonA,
    Enum.KeyCode.ButtonB,
    Enum.KeyCode.ButtonX,
    Enum.KeyCode.ButtonY,
    Enum.KeyCode.ButtonL1,
    Enum.KeyCode.ButtonR1,
    Enum.KeyCode.ButtonL2,
    Enum.KeyCode.ButtonR2,
    Enum.KeyCode.ButtonL3,
    Enum.KeyCode.ButtonR3,
    Enum.KeyCode.DPadUp,
    Enum.KeyCode.DPadDown,
    Enum.KeyCode.DPadLeft,
    Enum.KeyCode.DPadRight,
    Enum.KeyCode.Thumbstick1,
    Enum.KeyCode.Thumbstick2
};
local u3 = {
    [Enum.KeyCode.DPadUp] = Vector2.new(0, -1),
    [Enum.KeyCode.DPadDown] = Vector2.new(0, 1),
    [Enum.KeyCode.DPadLeft] = Vector2.new(-1, 0),
    [Enum.KeyCode.DPadRight] = Vector2.new(1, 0)
};
local Color3_fromRGB_ret = Color3.fromRGB(255, 255, 255);
local Color3_fromRGB_ret2 = Color3.fromRGB(16, 16, 18);
local u4 = {
    Closer = nil
};
local u5 = setmetatable({}, {
    __mode = "k"
});

function u4.Register(p6: userdata, p7: any) -- Line: 83
    -- upvalues: u5 (copy)
    local v8 = u5[p6];

    if not v8 then
        v8 = {};
        u5[p6] = v8;
    end;

    for i, v in p7 do
        v8[i] = v;
    end;
end;

function u4.OnPress(p9: userdata, p10: any, p11: string?) -- Line: 95
    -- upvalues: u4 (copy)
    u4.Register(p9, {
        Press = p10,
        Hint = p11
    });

    return p9.Activated:Connect(p10);
end;

local u12 = {
    On = false,
    Mode = "Map",
    Map = nil,
    Tools = nil,
    Content = nil,
    Reticle = nil,
    FocusRing = nil,
    Tip = nil,
    TipList = nil,
    HintSig = nil,
    Focus = nil,
    LT = 0,
    RT = 0,
    Drawing = false,
    Target = nil,
    TargetEntry = nil,
    Hold = nil,
    PruneAt = 0,
    Rows = {},
    Stick = Vector2.zero,
    Nav = {
        Dir = nil,
        From = nil,
        Next = 0
    }
};

local function _() -- Line: 115
    return require(script.Parent:WaitForChild("MapTools"));
end;

local function _() -- Line: 119
    return require(script.Parent:WaitForChild("MapLook"));
end;

local function _() -- Line: 123
    -- upvalues: LocalPlayer (copy)
    local v13 = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("PreferredInputController");

    if v13 then
        v13 = v13:GetAttribute("PreferredInput");
    end;

    return v13;
end;

local function _() -- Line: 128
    -- upvalues: LocalPlayer (copy)
    local v14 = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("PreferredInputController");

    return v14 and v14:GetAttribute("JoystickDeadzone") or 0.225;
end;

local function u19(p15: userdata) -- Line: 135
    if not p15.Parent then
        return false;
    end;

    local v16 = p15.AbsolutePosition + p15.AbsoluteSize / 2;
    local v17 = p15;

    while p15 and not p15:IsA("LayerCollector") do
        if p15:IsA("GuiObject") then
            if not p15.Visible then
                return false;
            end;

            if p15 ~= v17 and (p15.ClipsDescendants and not p15:IsA("ScrollingFrame")) then
                local AbsolutePosition = p15.AbsolutePosition;
                local AbsoluteSize = p15.AbsoluteSize;

                if v16.X < AbsolutePosition.X or (v16.Y < AbsolutePosition.Y or (v16.X > AbsolutePosition.X + AbsoluteSize.X or v16.Y > AbsolutePosition.Y + AbsoluteSize.Y)) then
                    return false;
                end;
            end;
        end;

        p15 = p15.Parent;
    end;

    local v18;

    if p15 == nil then
        v18 = false;
    else
        v18 = not p15:IsA("ScreenGui") or p15.Enabled;
    end;

    return v18;
end;

local function _() -- Line: 159
    -- upvalues: u12 (copy)
    return u12.Map.AbsolutePosition + u12.Map.AbsoluteSize / 2;
end;

local function _(p20: userdata) -- Line: 163
    -- upvalues: u12 (copy)
    local v21;

    if u12.Content == nil then
        v21 = false;
    else
        v21 = p20:IsDescendantOf(u12.Content);
    end;

    return v21;
end;

local function u27(p22) -- Line: 168
    -- upvalues: u12 (copy), GamepadIconModule (copy)
    local Tip = u12.Tip;

    if not Tip then
        return;
    end;

    local v23 = {};

    for _, v in p22 do
        table.insert(v23, v[1] .. v[2]);
    end;

    local table_concat_ret = table.concat(v23, "|");

    if table_concat_ret == u12.HintSig then
        return;
    end;

    u12.HintSig = table_concat_ret;
    local math_max_ret = math.max(#p22, 1);
    local v24 = math_max_ret * 0.026 + (math_max_ret - 1) * 0.008;

    for i, v in u12.Rows do
        local v25 = p22[i];
        v.Visible = v25 ~= nil;

        if v25 then
            v.LayoutOrder = i;
            v.Text = " - " .. v25[2];
            v.Size = UDim2.new(v.Size.X.Scale, v.Size.X.Offset, 0.026 / v24, 0);
            local v26 = v:FindFirstChildWhichIsA("ImageLabel");

            if v26 then
                v26.Image = GamepadIconModule.GetIcon(v25[1]);
            end;
        end;
    end;

    if u12.TipList then
        u12.TipList.Padding = UDim.new(0.008 / v24, 0);
    end;

    Tip.Size = UDim2.new(Tip.Size.X.Scale, Tip.Size.X.Offset, v24, 0);
end;

local function u35() -- Line: 205
    -- upvalues: u12 (copy), u27 (copy)
    local Pad = require(script.Parent:WaitForChild("MapTools")).Pad;
    local v28 = {};

    if u12.Mode == "Tools" then
        local Focus = u12.Focus;
        local v29 = { "ButtonA", Focus and Focus:IsA("TextBox") and "Type" or "Select" };
        table.insert(v28, v29);
        table.insert(v28, { "DPadRight", "Move" });
        local v30 = { "ButtonB", Pad.Editing() and "Done" or "Back" };
        table.insert(v28, v30);

        if Pad.PenOn() then
            table.insert(v28, { "ButtonL1", "Undo" });
            table.insert(v28, { "ButtonR1", "Redo" });
        end;
    else
        local TargetEntry = u12.TargetEntry;
        local v31 = Pad.PenOn();

        if TargetEntry and TargetEntry.Press then
            table.insert(v28, { "ButtonA", TargetEntry.Hint or "Select" });
        elseif v31 then
            local v32 = { "ButtonA", Pad.Erasing() and "Erase (hold)" or "Draw (hold)" };
            table.insert(v28, v32);
        elseif Pad.CanPlace() then
            table.insert(v28, { "ButtonA", "Place Marker" });
        end;

        if TargetEntry and TargetEntry.Second then
            table.insert(v28, { "ButtonX", TargetEntry.SecondHint or "Remove" });
        elseif not TargetEntry then
            table.insert(v28, { "ButtonX", v31 and "Pen Off" or "Draw" });
        end;

        if v31 then
            table.insert(v28, { "ButtonL1", "Undo" });
            table.insert(v28, { "ButtonR1", "Redo" });
            local v33 = { "DPadUp", Pad.Erasing() and "Pen" or "Eraser" };
            table.insert(v28, v33);
            table.insert(v28, { "DPadRight", "Colour" });
        else
            table.insert(v28, { "ButtonR2", "Zoom In" });
            table.insert(v28, { "ButtonL2", "Zoom Out" });
            table.insert(v28, { "ButtonL3", "Find Me" });
        end;

        table.insert(v28, { "ButtonY", "Tools" });
        local v34 = { "ButtonB", (Pad.Editing() or require(script.Parent:WaitForChild("MapLook")).Pad.ListOpen()) and "Back" or "Close Map" };
        table.insert(v28, v34);
    end;

    while #v28 > 8 do
        table.remove(v28, #v28 - 1);
    end;

    u27(v28);
end;

local function u40(p36: userdata) -- Line: 252
    -- upvalues: u5 (copy), u12 (copy), u19 (copy)
    local v37 = u5[p36];
    local v38;

    if v37 == nil then
        v38 = false;
    else
        v38 = (v37.Press ~= nil or p36:IsA("TextBox")) and p36:IsA("GuiObject");

        if v38 then
            local v39;

            if u12.Content == nil then
                v39 = false;
            else
                v39 = p36:IsDescendantOf(u12.Content);
            end;

            v38 = not v39 and p36:IsDescendantOf(u12.Map) and u19(p36);
        end;
    end;

    return v38;
end;

local function u43(p41: userdata?) -- Line: 258
    -- upvalues: u5 (copy), u40 (copy)
    local v42 = {};

    for i in u5 do
        if u40(i) and (p41 == nil or i:IsDescendantOf(p41)) then
            table.insert(v42, i);
        end;
    end;

    return v42;
end;

local function u48(p44: userdata?) -- Line: 269
    -- upvalues: u43 (copy)
    local v45 = (1 / 0);
    local v46 = nil;

    for _, v in u43(p44) do
        local AbsolutePosition = v.AbsolutePosition;
        local v47 = math.floor(AbsolutePosition.Y / 8) * 100000 + AbsolutePosition.X;

        if v47 < v45 then
            v46 = v;
            v45 = v47;
        end;
    end;

    return v46;
end;

local function _(p49: userdata?) -- Line: 281
    -- upvalues: u5 (copy)
    if p49 then
        p49 = u5[p49];
    end;

    if p49 and p49.Leave then
        task.spawn(p49.Leave);
    end;
end;

local function _(p50: userdata?) -- Line: 288
    -- upvalues: u5 (copy)
    if p50 then
        p50 = u5[p50];
    end;

    if p50 and p50.Enter then
        task.spawn(p50.Enter);
    end;
end;

local function u54(p51: userdata) -- Line: 296
    local Parent = p51.Parent;

    while Parent and not Parent:IsA("LayerCollector") do
        if Parent:IsA("ScrollingFrame") then
            local AbsolutePosition = Parent.AbsolutePosition;
            local AbsoluteSize = Parent.AbsoluteSize;
            local AbsolutePosition2 = p51.AbsolutePosition;
            local AbsoluteSize2 = p51.AbsoluteSize;
            local CanvasPosition = Parent.CanvasPosition;
            local v52;

            if AbsolutePosition2.X < AbsolutePosition.X then
                v52 = AbsolutePosition2.X - AbsolutePosition.X;
            else
                v52 = AbsolutePosition2.X + AbsoluteSize2.X <= AbsolutePosition.X + AbsoluteSize.X and 0 or AbsolutePosition2.X + AbsoluteSize2.X - AbsolutePosition.X - AbsoluteSize.X;
            end;

            local v53;

            if AbsolutePosition2.Y < AbsolutePosition.Y then
                v53 = AbsolutePosition2.Y - AbsolutePosition.Y;
            else
                v53 = AbsolutePosition2.Y + AbsoluteSize2.Y <= AbsolutePosition.Y + AbsoluteSize.Y and 0 or AbsolutePosition2.Y + AbsoluteSize2.Y - AbsolutePosition.Y - AbsoluteSize.Y;
            end;

            if v52 ~= 0 or v53 ~= 0 then
                Parent.CanvasPosition = CanvasPosition + Vector2.new(v52, v53);
            end;
        end;

        Parent = Parent.Parent;
    end;
end;

local function _(p55: userdata?) -- Line: 313
    -- upvalues: u12 (copy), u5 (copy), u54 (copy)
    if p55 == u12.Focus then
        return;
    end;

    local Focus = u12.Focus;

    if Focus then
        Focus = u5[Focus];
    end;

    if Focus and Focus.Leave then
        task.spawn(Focus.Leave);
    end;

    u12.Focus = p55;

    if p55 then
        u54(p55);

        if p55 then
            p55 = u5[p55];
        end;

        if p55 and p55.Enter then
            task.spawn(p55.Enter);
        end;
    end;
end;

local function u64(p56) -- Line: 326
    -- upvalues: u12 (copy), u40 (copy), u48 (copy), u5 (copy), u54 (copy), u43 (copy)
    local Focus = u12.Focus;

    if Focus and u40(Focus) then
        local v57 = Focus.AbsolutePosition + Focus.AbsoluteSize / 2;
        local v58 = (1 / 0);
        local v59 = nil;

        for _, v in u43() do
            if v ~= Focus then
                local v60 = v.AbsolutePosition + v.AbsoluteSize / 2 - v57;
                local v61 = v60.X * p56.X + v60.Y * p56.Y;

                if v61 > 2 then
                    local v62 = v61 + math.abs(v60.X * p56.Y - v60.Y * p56.X) * 2;

                    if v62 < v58 then
                        v59 = v;
                        v58 = v62;
                    end;
                end;
            end;
        end;

        if v59 then
            if v59 == u12.Focus then
                return;
            end;

            local Focus2 = u12.Focus;

            if Focus2 then
                Focus2 = u5[Focus2];
            end;

            if Focus2 and Focus2.Leave then
                task.spawn(Focus2.Leave);
            end;

            u12.Focus = v59;

            if v59 then
                u54(v59);

                if v59 then
                    v59 = u5[v59];
                end;

                if v59 and v59.Enter then
                    task.spawn(v59.Enter);
                end;
            end;
        end;

        return;
    end;

    local v63 = u48();

    if v63 == u12.Focus then
        return;
    end;

    local Focus2 = u12.Focus;

    if Focus2 then
        Focus2 = u5[Focus2];
    end;

    if Focus2 and Focus2.Leave then
        task.spawn(Focus2.Leave);
    end;

    u12.Focus = v63;

    if v63 then
        u54(v63);

        if v63 then
            v63 = u5[v63];
        end;

        if v63 and v63.Enter then
            task.spawn(v63.Enter);
        end;
    end;
end;

local function u67() -- Line: 355
    -- upvalues: u12 (copy), u48 (copy)
    local v65 = u12.Tools and u12.Tools:FindFirstChild("MarkerEditor");

    if v65 and v65.Visible then
        return v65;
    end;

    for _, v in { "BagList", "ShopList" } do
        local v66 = u12.Map:FindFirstChild(v);

        if v66 and (v66.Visible and u48(v66)) then
            return v66;
        end;
    end;

    return nil;
end;

local function u71(p68: userdata?) -- Line: 369
    -- upvalues: u12 (copy), u5 (copy), u48 (copy), u54 (copy)
    u12.Mode = "Tools";

    if u12.Drawing then
        u12.Drawing = false;
        require(script.Parent:WaitForChild("MapTools")).Pad.End();
    end;

    local Target = u12.Target;

    if Target then
        Target = u5[Target];
    end;

    if Target and Target.Leave then
        task.spawn(Target.Leave);
    end;

    u12.Target = nil;
    u12.TargetEntry = nil;
    local v69 = u12.Tools and u12.Tools:FindFirstChild("Controls");
    local v70 = u48(p68) or v69 and u48(v69) or u48();

    if v70 ~= u12.Focus then
        local Focus = u12.Focus;

        if Focus then
            Focus = u5[Focus];
        end;

        if Focus and Focus.Leave then
            task.spawn(Focus.Leave);
        end;

        u12.Focus = v70;

        if v70 then
            u54(v70);

            if v70 then
                v70 = u5[v70];
            end;

            if v70 and v70.Enter then
                task.spawn(v70.Enter);
            end;
        end;
    end;

    if not u12.Focus then
        u12.Mode = "Map";
    end;
end;

local function _() -- Line: 384
    -- upvalues: u12 (copy), u5 (copy)
    if u12.Focus ~= nil then
        local Focus = u12.Focus;

        if Focus then
            Focus = u5[Focus];
        end;

        if Focus and Focus.Leave then
            task.spawn(Focus.Leave);
        end;

        u12.Focus = nil;
    end;

    u12.Mode = "Map";
    local Nav = u12.Nav;
    u12.Nav.Dir = nil;
    Nav.From = nil;
end;

local function _() -- Line: 391
    -- upvalues: u12 (copy), u67 (copy), u71 (copy)
    task.defer(function() -- Line: 392
        -- upvalues: u12 (ref), u67 (ref), u71 (ref)
        if not u12.On then
            return;
        end;

        local v72 = u67();

        if v72 then
            u71(v72);
        end;
    end);
end;

local function u73() -- Line: 404
    -- upvalues: u12 (copy), u5 (copy), u4 (copy)
    local Pad = require(script.Parent:WaitForChild("MapTools")).Pad;

    if u12.Drawing then
        u12.Drawing = false;
        Pad.End();
    end;

    if Pad.CloseEditor() then
        if u12.Focus ~= nil then
            local Focus = u12.Focus;

            if Focus then
                Focus = u5[Focus];
            end;

            if Focus and Focus.Leave then
                task.spawn(Focus.Leave);
            end;

            u12.Focus = nil;
        end;

        u12.Mode = "Map";
        local Nav = u12.Nav;
        u12.Nav.Dir = nil;
        Nav.From = nil;

        return;
    end;

    if require(script.Parent:WaitForChild("MapLook")).Pad.CloseLists() then
        if u12.Focus ~= nil then
            local Focus = u12.Focus;

            if Focus then
                Focus = u5[Focus];
            end;

            if Focus and Focus.Leave then
                task.spawn(Focus.Leave);
            end;

            u12.Focus = nil;
        end;

        u12.Mode = "Map";
        local Nav = u12.Nav;
        u12.Nav.Dir = nil;
        Nav.From = nil;

        return;
    end;

    if u12.Mode ~= "Tools" then
        if u4.Closer then
            u4.Closer();
        end;

        return;
    end;

    if u12.Focus ~= nil then
        local Focus = u12.Focus;

        if Focus then
            Focus = u5[Focus];
        end;

        if Focus and Focus.Leave then
            task.spawn(Focus.Leave);
        end;

        u12.Focus = nil;
    end;

    u12.Mode = "Map";
    local Nav = u12.Nav;
    u12.Nav.Dir = nil;
    Nav.From = nil;
end;

local function _(p74: userdata) -- Line: 427
    -- upvalues: u5 (copy)
    if p74:IsA("TextBox") then
        p74:CaptureFocus();

        return;
    end;

    local v75 = u5[p74];

    if v75 and v75.Press then
        v75.Press();
    end;
end;

local function _(p76: string) -- Line: 439
    -- upvalues: u5 (copy)
    local v77 = require(script.Parent:WaitForChild("MapTools")).Pad.Buttons();

    if v77 then
        v77 = v77[p76];
    end;

    if v77 then
        if v77:IsA("TextBox") then
            v77:CaptureFocus();

            return;
        end;

        local v78 = u5[v77];

        if v78 and v78.Press then
            v78.Press();
        end;
    end;
end;

local function _(p79: number) -- Line: 447
    -- upvalues: u5 (copy)
    local Pad = require(script.Parent:WaitForChild("MapTools")).Pad;
    local v80 = Pad.Swatches();

    if not v80 or #v80 == 0 then
        return;
    end;

    local v81 = v80[(Pad.Colour() - 1 + p79) % #v80 + 1];

    if v81:IsA("TextBox") then
        v81:CaptureFocus();

        return;
    end;

    local v82 = u5[v81];

    if v82 and v82.Press then
        v82.Press();
    end;
end;

local function u108(p83: any, p84: boolean) -- Line: 458
    -- upvalues: u12 (copy), u3 (copy), u64 (copy), u73 (copy), u40 (copy), u5 (copy), u67 (copy), u71 (copy)
    local Pad = require(script.Parent:WaitForChild("MapTools")).Pad;

    if u12.Mode == "Tools" then
        local v85 = u3[p83];

        if v85 then
            if p84 then
                u64(v85);
                local Nav = u12.Nav;
                local Nav2 = u12.Nav;
                local Nav3 = u12.Nav;
                local v86 = os.clock() + 0.32;
                Nav.Dir = v85;
                Nav2.From = "DPad";
                Nav3.Next = v86;

                return;
            end;

            if u12.Nav.Dir == v85 and u12.Nav.From == "DPad" then
                local Nav = u12.Nav;
                u12.Nav.Dir = nil;
                Nav.From = nil;

                return;
            end;
        elseif p84 then
            if p83 == Enum.KeyCode.ButtonA then
                local Focus = u12.Focus;

                if Focus and u40(Focus) then
                    if Focus:IsA("TextBox") then
                        Focus:CaptureFocus();

                        return;
                    end;

                    local v87 = u5[Focus];

                    if v87 and v87.Press then
                        v87.Press();

                        return;
                    end;
                end;
            else
                if p83 == Enum.KeyCode.ButtonY then
                    if u12.Focus ~= nil then
                        local Focus = u12.Focus;

                        if Focus then
                            Focus = u5[Focus];
                        end;

                        if Focus and Focus.Leave then
                            task.spawn(Focus.Leave);
                        end;

                        u12.Focus = nil;
                    end;

                    u12.Mode = "Map";
                    local Nav = u12.Nav;
                    u12.Nav.Dir = nil;
                    Nav.From = nil;

                    return;
                end;

                if p83 == Enum.KeyCode.ButtonL1 and Pad.PenOn() then
                    local v88 = require(script.Parent:WaitForChild("MapTools")).Pad.Buttons();

                    if v88 then
                        v88 = v88.Undo;
                    end;

                    if v88 then
                        if v88:IsA("TextBox") then
                            v88:CaptureFocus();

                            return;
                        end;

                        local v89 = u5[v88];

                        if v89 and v89.Press then
                            v89.Press();

                            return;
                        end;
                    end;
                elseif p83 == Enum.KeyCode.ButtonR1 and Pad.PenOn() then
                    local v90 = require(script.Parent:WaitForChild("MapTools")).Pad.Buttons();

                    if v90 then
                        v90 = v90.Redo;
                    end;

                    if v90 then
                        if v90:IsA("TextBox") then
                            v90:CaptureFocus();

                            return;
                        end;

                        local v91 = u5[v90];

                        if v91 and v91.Press then
                            v91.Press();
                        end;
                    end;
                end;
            end;
        elseif p83 == Enum.KeyCode.ButtonB then
            u73();

            return;
        end;

        return;
    end;

    local TargetEntry = u12.TargetEntry;

    if p84 then
        if p83 == Enum.KeyCode.ButtonA then
            if TargetEntry and TargetEntry.Press then
                TargetEntry.Press();
                task.defer(function() -- Line: 392
                    -- upvalues: u12 (ref), u67 (ref), u71 (ref)
                    if not u12.On then
                        return;
                    end;

                    local v92 = u67();

                    if v92 then
                        u71(v92);
                    end;
                end);

                return;
            end;

            if Pad.PenOn() then
                u12.Drawing = Pad.Begin(u12.Map.AbsolutePosition + u12.Map.AbsoluteSize / 2);

                return;
            end;

            if Pad.PlaceMarker(u12.Map.AbsolutePosition + u12.Map.AbsoluteSize / 2) then
                task.defer(function() -- Line: 392
                    -- upvalues: u12 (ref), u67 (ref), u71 (ref)
                    if not u12.On then
                        return;
                    end;

                    local v93 = u67();

                    if v93 then
                        u71(v93);
                    end;
                end);

                return;
            end;
        elseif p83 == Enum.KeyCode.ButtonX then
            if TargetEntry and TargetEntry.Second then
                if TargetEntry.SecondHold then
                    u12.Hold = {
                        Entry = TargetEntry,
                        At = os.clock()
                    };

                    return;
                end;

                TargetEntry.Second();

                return;
            end;

            if not TargetEntry then
                if u12.Drawing then
                    u12.Drawing = false;
                    Pad.End();
                end;

                local v94 = require(script.Parent:WaitForChild("MapTools")).Pad.Buttons();

                if v94 then
                    v94 = v94.Pen;
                end;

                if v94 then
                    if v94:IsA("TextBox") then
                        v94:CaptureFocus();

                        return;
                    end;

                    local v95 = u5[v94];

                    if v95 and v95.Press then
                        v95.Press();

                        return;
                    end;
                end;
            end;
        else
            if p83 == Enum.KeyCode.ButtonY then
                u71(nil);

                return;
            end;

            if p83 == Enum.KeyCode.ButtonL1 and Pad.PenOn() then
                local v96 = require(script.Parent:WaitForChild("MapTools")).Pad.Buttons();

                if v96 then
                    v96 = v96.Undo;
                end;

                if v96 then
                    if v96:IsA("TextBox") then
                        v96:CaptureFocus();

                        return;
                    end;

                    local v97 = u5[v96];

                    if v97 and v97.Press then
                        v97.Press();

                        return;
                    end;
                end;
            elseif p83 == Enum.KeyCode.ButtonR1 and Pad.PenOn() then
                local v98 = require(script.Parent:WaitForChild("MapTools")).Pad.Buttons();

                if v98 then
                    v98 = v98.Redo;
                end;

                if v98 then
                    if v98:IsA("TextBox") then
                        v98:CaptureFocus();

                        return;
                    end;

                    local v99 = u5[v98];

                    if v99 and v99.Press then
                        v99.Press();

                        return;
                    end;
                end;
            elseif p83 == Enum.KeyCode.DPadUp and Pad.PenOn() then
                local v100 = require(script.Parent:WaitForChild("MapTools")).Pad.Buttons();

                if v100 then
                    v100 = v100.Eraser;
                end;

                if v100 then
                    if v100:IsA("TextBox") then
                        v100:CaptureFocus();

                        return;
                    end;

                    local v101 = u5[v100];

                    if v101 and v101.Press then
                        v101.Press();

                        return;
                    end;
                end;
            elseif p83 == Enum.KeyCode.DPadLeft and Pad.PenOn() then
                local Pad2 = require(script.Parent:WaitForChild("MapTools")).Pad;
                local v102 = Pad2.Swatches();

                if v102 then
                    if #v102 == 0 then
                        return;
                    end;

                    local v103 = v102[(Pad2.Colour() - 1 + -1) % #v102 + 1];

                    if v103:IsA("TextBox") then
                        v103:CaptureFocus();

                        return;
                    end;

                    local v104 = u5[v103];

                    if v104 and v104.Press then
                        v104.Press();

                        return;
                    end;
                end;
            elseif p83 == Enum.KeyCode.DPadRight and Pad.PenOn() then
                local Pad2 = require(script.Parent:WaitForChild("MapTools")).Pad;
                local v105 = Pad2.Swatches();

                if v105 then
                    if #v105 == 0 then
                        return;
                    end;

                    local v106 = v105[(Pad2.Colour() - 1 + 1) % #v105 + 1];

                    if v106:IsA("TextBox") then
                        v106:CaptureFocus();

                        return;
                    end;

                    local v107 = u5[v106];

                    if v107 and v107.Press then
                        v107.Press();

                        return;
                    end;
                end;
            elseif p83 == Enum.KeyCode.ButtonL3 then
                Pad.Recentre();
            end;
        end;

        return;
    end;

    if p83 == Enum.KeyCode.ButtonA and u12.Drawing then
        u12.Drawing = false;
        Pad.End();

        return;
    end;

    if p83 == Enum.KeyCode.ButtonX then
        u12.Hold = nil;

        return;
    end;

    if p83 == Enum.KeyCode.ButtonB then
        u73();
    end;
end;

local function u115(p109: string, p110: any, p111: userdata) -- Line: 540
    -- upvalues: u12 (copy), u108 (copy), u3 (copy), u73 (copy)
    if not u12.On then
        return Enum.ContextActionResult.Pass;
    end;

    local KeyCode = p111.KeyCode;
    local v112 = p110 == Enum.UserInputState.End and true or p110 == Enum.UserInputState.Cancel;

    if KeyCode == Enum.KeyCode.Thumbstick1 then
        local v113;

        if v112 then
            v113 = Vector2.zero;
        else
            v113 = Vector2.new(p111.Position.X, p111.Position.Y);
        end;

        u12.Stick = v113;
    elseif KeyCode == Enum.KeyCode.ButtonL2 then
        u12.LT = v112 and 0 or p111.Position.Z;
    elseif KeyCode == Enum.KeyCode.ButtonR2 then
        u12.RT = v112 and 0 or p111.Position.Z;
    elseif KeyCode ~= Enum.KeyCode.Thumbstick2 then
        if p110 == Enum.UserInputState.Begin then
            u108(KeyCode, true);
        elseif v112 then
            local Pad = require(script.Parent:WaitForChild("MapTools")).Pad;

            if u12.Mode == "Tools" then
                local v114 = u3[KeyCode];

                if v114 then
                    if u12.Nav.Dir == v114 and u12.Nav.From == "DPad" then
                        local Nav = u12.Nav;
                        u12.Nav.Dir = nil;
                        Nav.From = nil;
                    end;
                elseif KeyCode == Enum.KeyCode.ButtonB then
                    u73();
                end;
            else
                local _ = u12.TargetEntry;

                if KeyCode == Enum.KeyCode.ButtonA and u12.Drawing then
                    u12.Drawing = false;
                    Pad.End();
                elseif KeyCode == Enum.KeyCode.ButtonX then
                    u12.Hold = nil;
                elseif KeyCode == Enum.KeyCode.ButtonB then
                    u73();
                end;
            end;
        end;
    end;

    return Enum.ContextActionResult.Sink;
end;

local function _() -- Line: 563
    -- upvalues: u12 (copy), LocalPlayer (copy)
    local Map = u12.Map;
    local v116;

    if Map == nil or Map.Parent == nil then
        v116 = false;
    else
        v116 = Map.Visible;

        if v116 then
            if Map:GetAttribute("Locked") == true then
                v116 = false;
            else
                local v117 = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("PreferredInputController");

                if v117 then
                    v117 = v117:GetAttribute("PreferredInput");
                end;

                v116 = v117 == "Gamepad";
            end;
        end;
    end;

    return v116;
end;

local function u119() -- Line: 569
    -- upvalues: u12 (copy), SettingsModule (copy), u2 (copy), ContextActionService (copy), u115 (copy), u1 (copy)
    u12.On = true;
    u12.Mode = "Map";
    u12.Stick = Vector2.zero;
    u12.LT = 0;
    u12.RT = 0;
    u12.Drawing = false;
    u12.Hold = nil;
    u12.HintSig = nil;
    local Nav = u12.Nav;
    u12.Nav.Dir = nil;
    Nav.From = nil;
    local Setting = SettingsModule.GetSetting("Gamepad", "Open Map");
    local v118 = {};

    for _, v in u2 do
        if v.Name ~= Setting then
            table.insert(v118, v);
        end;
    end;

    ContextActionService:BindActionAtPriority("MapGamepad", u115, false, u1, table.unpack(v118));

    if u12.Reticle then
        u12.Reticle.Visible = true;
    end;

    if u12.Tip then
        u12.Tip.Visible = true;
    end;
end;

local function u120() -- Line: 592
    -- upvalues: u12 (copy), ContextActionService (copy), u5 (copy)
    u12.On = false;
    ContextActionService:UnbindAction("MapGamepad");

    if u12.Drawing then
        u12.Drawing = false;
        require(script.Parent:WaitForChild("MapTools")).Pad.End();
    end;

    require(script.Parent:WaitForChild("MapTools")).Pad.SetPoint(nil);
    local Target = u12.Target;

    if Target then
        Target = u5[Target];
    end;

    if Target and Target.Leave then
        task.spawn(Target.Leave);
    end;

    u12.Target = nil;
    u12.TargetEntry = nil;

    if u12.Focus ~= nil then
        local Focus = u12.Focus;

        if Focus then
            Focus = u5[Focus];
        end;

        if Focus and Focus.Leave then
            task.spawn(Focus.Leave);
        end;

        u12.Focus = nil;
    end;

    u12.Mode = "Map";
    u12.Hold = nil;

    for _, v in { u12.Reticle, u12.FocusRing, u12.Tip } do
        if v then
            v.Visible = false;
        end;
    end;
end;

local function u141(p121: number) -- Line: 613
    -- upvalues: u12 (copy), LocalPlayer (copy), u120 (copy), u119 (copy), u5 (copy), GuiUtil (copy), u64 (copy), u40 (copy), u67 (copy), u48 (copy), u54 (copy), u19 (copy), u35 (copy)
    local On = u12.On;
    local Map = u12.Map;
    local v122;

    if Map == nil or Map.Parent == nil then
        v122 = false;
    else
        v122 = Map.Visible;

        if v122 then
            if Map:GetAttribute("Locked") == true then
                v122 = false;
            else
                local v123 = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("PreferredInputController");

                if v123 then
                    v123 = v123:GetAttribute("PreferredInput");
                end;

                v122 = v123 == "Gamepad";
            end;
        end;
    end;

    if On ~= v122 then
        if u12.On then
            u120();
        else
            u119();
        end;
    end;

    if not u12.On then
        return;
    end;

    local os_clock_ret = os.clock();
    local Pad = require(script.Parent:WaitForChild("MapTools")).Pad;
    local Map2 = u12.Map;
    local Tools = u12.Tools;
    local v124 = u12.Map.AbsolutePosition + u12.Map.AbsoluteSize / 2;

    if u12.PruneAt <= os_clock_ret then
        u12.PruneAt = os_clock_ret + 2;

        for i in u5 do
            if not i:IsDescendantOf(game) then
                u5[i] = nil;
            end;
        end;
    end;

    local v125 = (u12.RT <= 0.1 and 0 or u12.RT) - (u12.LT <= 0.1 and 0 or u12.LT);
    local ZoomInfo = GuiUtil:GetZoomInfo(Map2);

    if ZoomInfo and v125 ~= 0 then
        local v126 = ZoomInfo.TargetScale * math.exp(v125 * 1.4 * p121);
        ZoomInfo.TargetScale = math.clamp(v126, ZoomInfo.MinZoom, ZoomInfo.MaxZoom);
        ZoomInfo.ZoomAnchor = Vector2.new(0.5, 0.5);
        task.spawn(GuiUtil.StartZoomLoop, GuiUtil, Map2);
    end;

    local v127 = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("PreferredInputController");
    local v128 = v127 and v127:GetAttribute("JoystickDeadzone") or 0.225;
    local Stick = u12.Stick;
    local Magnitude = Stick.Magnitude;

    if u12.Mode == "Tools" then
        local Nav = u12.Nav;

        if math.max(v128, 0.5) < Magnitude then
            local v129;

            if math.abs(Stick.X) > math.abs(Stick.Y) then
                v129 = Vector2.new(math.sign(Stick.X), 0);
            else
                v129 = Vector2.new(0, -math.sign(Stick.Y));
            end;

            if Nav.Dir ~= v129 or Nav.From ~= "Stick" then
                u64(v129);
                Nav.Dir = v129;
                Nav.From = "Stick";
                Nav.Next = os_clock_ret + 0.32;
            end;
        elseif Nav.From == "Stick" then
            Nav.Dir = nil;
            Nav.From = nil;
        end;

        if u12.Nav.Dir and u12.Nav.Next <= os_clock_ret then
            u12.Nav.Next = os_clock_ret + 0.13;
            u64(u12.Nav.Dir);
        end;

        if not (u12.Focus and u40(u12.Focus)) then
            local v130 = u67();
            local v131;

            if Tools then
                v131 = Tools:FindFirstChild("Controls");
            else
                v131 = Tools;
            end;

            local v132 = v130 and u48(v130);

            if v132 then
                v131 = v132;
            elseif v131 then
                v131 = u48(v131);
            end;

            if v131 then
                if v131 ~= u12.Focus then
                    local Focus = u12.Focus;

                    if Focus then
                        Focus = u5[Focus];
                    end;

                    if Focus and Focus.Leave then
                        task.spawn(Focus.Leave);
                    end;

                    u12.Focus = v131;

                    if v131 then
                        u54(v131);

                        if v131 then
                            v131 = u5[v131];
                        end;

                        if v131 and v131.Enter then
                            task.spawn(v131.Enter);
                        end;
                    end;
                end;
            else
                if u12.Focus ~= nil then
                    local Focus = u12.Focus;

                    if Focus then
                        Focus = u5[Focus];
                    end;

                    if Focus and Focus.Leave then
                        task.spawn(Focus.Leave);
                    end;

                    u12.Focus = nil;
                end;

                u12.Mode = "Map";
                local Nav2 = u12.Nav;
                u12.Nav.Dir = nil;
                Nav2.From = nil;
            end;
        end;
    else
        if v128 < Magnitude then
            local v133 = math.clamp((Magnitude - v128) / (1 - v128), 0, 1) ^ 1.6;
            local v134 = Stick.Unit * v133 * 520 * p121;
            Pad.PanBy(Vector2.new(-v134.X, v134.Y));
        end;

        local v135 = (1 / 0);
        local v136 = nil;

        for i, v in u5 do
            if (v.Press or (v.Second or v.Enter)) and i:IsA("GuiObject") then
                local v137;

                if u12.Content == nil then
                    v137 = false;
                else
                    v137 = i:IsDescendantOf(u12.Content);
                end;

                if v137 then
                    local AbsolutePosition = i.AbsolutePosition;
                    local AbsoluteSize = i.AbsoluteSize;

                    if v124.X >= AbsolutePosition.X - 10 and (v124.Y >= AbsolutePosition.Y - 10 and (v124.X <= AbsolutePosition.X + AbsoluteSize.X + 10 and (v124.Y <= AbsolutePosition.Y + AbsoluteSize.Y + 10 and u19(i)))) then
                        local Magnitude2 = (AbsolutePosition + AbsoluteSize / 2 - v124).Magnitude;

                        if Magnitude2 < v135 then
                            v136 = i;
                            v135 = Magnitude2;
                        end;
                    end;
                end;
            end;
        end;

        if v136 ~= u12.Target then
            local Target = u12.Target;

            if Target then
                Target = u5[Target];
            end;

            if Target and Target.Leave then
                task.spawn(Target.Leave);
            end;

            local v138;

            if v136 then
                v138 = u5[v136];
            else
                v138 = v136;
            end;

            u12.Target = v136;
            u12.TargetEntry = v138;
            u12.Hold = nil;

            if v136 then
                v136 = u5[v136];
            end;

            if v136 and v136.Enter then
                task.spawn(v136.Enter);
            end;
        end;

        local Hold = u12.Hold;

        if Hold and os_clock_ret - Hold.At >= 0.6 then
            u12.Hold = nil;

            if Hold.Entry == u12.TargetEntry and Hold.Entry.Second then
                Hold.Entry.Second();
            end;
        end;

        if u12.Drawing then
            Pad.Extend(v124);
        end;
    end;

    local AbsolutePosition = Tools.AbsolutePosition;
    u12.Reticle.Visible = u12.Mode == "Map";
    u12.Reticle.Position = UDim2.fromOffset(v124.X - AbsolutePosition.X, v124.Y - AbsolutePosition.Y);
    local Focus = u12.Focus;
    local v139;

    if u12.Mode == "Tools" then
        v139 = Focus ~= nil;
    else
        v139 = false;
    end;

    u12.FocusRing.Visible = v139;

    if Focus then
        local v140 = Focus.AbsolutePosition - Map2.AbsolutePosition;
        local AbsoluteSize = Focus.AbsoluteSize;
        u12.FocusRing.Position = UDim2.fromOffset(v140.X - 4, v140.Y - 4);
        u12.FocusRing.Size = UDim2.fromOffset(AbsoluteSize.X + 8, AbsoluteSize.Y + 8);
    end;

    if u12.Mode ~= "Map" then
        v124 = nil;
    end;

    Pad.SetPoint(v124);
    u35();
end;

function u4.Attach(p142: userdata) -- Line: 736
    -- upvalues: u12 (copy), u120 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy)
    if u12.On then
        u120();
    end;

    local MapTools = p142:WaitForChild("MapTools", 10);
    local Frame = p142:WaitForChild("Frame", 10);

    if Frame then
        Frame = Frame:WaitForChild("Map", 10);
    end;

    if not (MapTools and Frame) then
        return;
    end;

    u12.Map = p142;
    u12.Tools = MapTools;
    u12.Content = Frame;
    u12.Focus = nil;
    u12.Target = nil;
    u12.TargetEntry = nil;
    local Frame2 = Instance.new("Frame");
    Frame2.Name = "PadReticle";
    Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame2.Size = UDim2.fromOffset(26, 26);
    Frame2.BackgroundTransparency = 1;
    Frame2.ZIndex = 40;
    Frame2.Visible = false;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3_fromRGB_ret;
    UIStroke.Thickness = 2;
    UIStroke.Parent = Frame2;
    Instance.new("UICorner", Frame2).CornerRadius = UDim.new(1, 0);
    local Frame3 = Instance.new("Frame");
    Frame3.Name = "Dot";
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame3.Position = UDim2.fromScale(0.5, 0.5);
    Frame3.Size = UDim2.fromOffset(5, 5);
    Frame3.BackgroundColor3 = Color3_fromRGB_ret;
    Frame3.BorderSizePixel = 0;
    Frame3.ZIndex = 40;
    Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0);
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Color = Color3_fromRGB_ret2;
    UIStroke2.Thickness = 1;
    UIStroke2.Parent = Frame3;
    Frame3.Parent = Frame2;
    local Frame4 = Instance.new("Frame");
    Frame4.Name = "Edge";
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.Position = UDim2.fromScale(0.5, 0.5);
    Frame4.Size = UDim2.new(1, 4, 1, 4);
    Frame4.BackgroundTransparency = 1;
    Frame4.ZIndex = 39;
    Instance.new("UICorner", Frame4).CornerRadius = UDim.new(1, 0);
    local UIStroke3 = Instance.new("UIStroke");
    UIStroke3.Color = Color3_fromRGB_ret2;
    UIStroke3.Thickness = 1;
    UIStroke3.Transparency = 0.3;
    UIStroke3.Parent = Frame4;
    Frame4.Parent = Frame2;
    Frame2.Parent = MapTools;
    u12.Reticle = Frame2;
    local Frame5 = Instance.new("Frame");
    Frame5.Name = "PadFocus";
    Frame5.BackgroundTransparency = 1;
    Frame5.ZIndex = 100;
    Frame5.Visible = false;
    Instance.new("UICorner", Frame5).CornerRadius = UDim.new(0, 10);
    local UIStroke4 = Instance.new("UIStroke");
    UIStroke4.Color = Color3_fromRGB_ret;
    UIStroke4.Thickness = 3;
    UIStroke4.Parent = Frame5;
    Frame5.Parent = p142;
    u12.FocusRing = Frame5;
    local MapToolTip = p142:FindFirstChild("MapToolTip");
    u12.Rows = {};

    if MapToolTip then
        local PlaceMarker = MapToolTip:FindFirstChild("PlaceMarker");

        for _, child in MapToolTip:GetChildren() do
            if child:IsA("GuiObject") then
                child.Visible = false;
            end;
        end;

        if PlaceMarker then
            for i = 1, 8 do
                local v143 = PlaceMarker:Clone();
                v143.Name = "PadHint" .. i;
                v143.Visible = false;
                v143.Parent = MapToolTip;
                u12.Rows[i] = v143;
                local _ = i;
            end;
        end;

        MapToolTip.AnchorPoint = Vector2.new(0, 1);
        MapToolTip.Position = UDim2.new(0, 24, 1, -24);
        MapToolTip.Visible = false;
        local v144 = MapToolTip:FindFirstChildWhichIsA("UIListLayout");

        if v144 then
            v144.HorizontalAlignment = Enum.HorizontalAlignment.Right;
            v144.VerticalAlignment = Enum.VerticalAlignment.Bottom;
        end;

        u12.TipList = v144;
    end;

    u12.Tip = MapToolTip;
    u12.HintSig = nil;
end;

u4.Debug = {
    Feed = function(p145: string, p146: string, p147: vector?) -- Line: 844, Name: Feed
        -- upvalues: u115 (copy)
        return u115("MapGamepad", Enum.UserInputState[p146], {
            KeyCode = Enum.KeyCode[p145],
            Position = p147 or Vector3.new(0, 0, 0)
        });
    end,

    State = function() -- Line: 848, Name: State
        -- upvalues: u12 (copy)
        local v148 = {
            On = u12.On,
            Mode = u12.Mode
        };
        local v149 = u12.Focus and u12.Focus:GetFullName();
        v148.Focus = v149;
        local v150 = u12.Target and u12.Target:GetFullName();
        v148.Target = v150;
        v148.Drawing = u12.Drawing;
        v148.Hints = u12.HintSig;

        return v148;
    end
};
RunService.RenderStepped:Connect(function(p151) -- Line: 854
    -- upvalues: u12 (copy), u141 (copy)
    if u12.Map then
        u141(p151);
    end;
end);

return u4;
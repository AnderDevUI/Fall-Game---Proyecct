-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / NavBarUIModule / MobileUIModule @Type ModuleScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local MobileLayoutState = require(Modules:WaitForChild("MobileLayoutState"));
local MobileModule = require(Modules:WaitForChild("MobileModule"));
local Parent = script.Parent.Parent;
local SoundModule = require(Parent:WaitForChild("SoundModule"));
local PlayerDataModule = require(Parent:WaitForChild("PlayerDataModule"));
local UIConstants = require(Parent:WaitForChild("UIConstants"));
local SettingRemotes = ReplicatedStorage:WaitForChild("SettingRemotes");
local Color3_fromRGB_ret = Color3.fromRGB(75, 123, 255);
Color3.new(1, 1, 1);
local u1 = {
    Use = "Use / Shoot",
    Open = "Interact",
    ADS = "Aim",
    Attachment = "Light / Laser",
    NVG = "Night Vision",
    FreeLook = "Free Look"
};
local v2 = {};
local u3 = {};
local u4 = {};
local u5 = {};
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = false;
local u10 = nil;
local u11 = 0;
local u12 = nil;
local u13 = false;

local function PreviewFade() -- Line: 72
    -- upvalues: MobileLayoutState (copy)
    return MobileLayoutState.FADE_DEFAULT;
end;

local function EditorLive() -- Line: 85
    -- upvalues: UIConstants (copy), Parent (copy), u13 (ref)
    local v14;

    if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
        v14 = u13;
    else
        v14 = false;
    end;

    return v14;
end;

local function TabLive() -- Line: 91
    -- upvalues: UIConstants (copy), Parent (copy)
    local v15;

    if UIConstants.MOBILE_TAB.Visible == true then
        v15 = Parent:GetAttribute("Open") == true;
    else
        v15 = false;
    end;

    return v15;
end;

local function QueueSave() -- Line: 98
    -- upvalues: MobileLayoutState (copy), u10 (ref), u11 (ref), SettingRemotes (copy)
    if not MobileLayoutState.Hydrated then
        return;
    end;

    local u16 = MobileLayoutState.Encode() or MobileLayoutState.EMPTY;

    if u16 == u10 then
        return;
    end;

    u10 = u16;
    u11 = u11 + 1;
    local u17 = u11;
    task.delay(0.6, function() -- Line: 105
        -- upvalues: u17 (copy), u11 (ref), SettingRemotes (ref), u16 (copy)
        if u17 ~= u11 then
            return;
        end;

        SettingRemotes.Update:FireServer("MobileLayout", u16);
    end);
end;

local function SetStrokeSelected(p18: string, p19: boolean) -- Line: 114
    -- upvalues: u3 (copy), Color3_fromRGB_ret (copy), u5 (copy), MobileLayoutState (copy)
    local v20 = u3[p18];
    local v21;

    if v20 then
        v21 = v20:FindFirstChildOfClass("UIStroke");
    else
        v21 = v20;
    end;

    if not v21 then
        return;
    end;

    if p19 then
        v21.Color = Color3_fromRGB_ret;
        v21.Transparency = 0;
        v21.Thickness = 4;

        return;
    end;

    local v22 = u5[p18];

    if v22 then
        v21.Color = v22.Color;
        v21.Thickness = v22.Thickness;
    end;

    MobileLayoutState.ApplyFade(p18, v20, MobileLayoutState.FADE_DEFAULT);
end;

local function ApplyMock(p23: string?) -- Line: 135
    -- upvalues: u3 (copy), MobileLayoutState (copy), u6 (ref), Color3_fromRGB_ret (copy)
    local v24;

    if p23 then
        v24 = u3[p23];
    else
        v24 = p23;
    end;

    if not v24 then
        return;
    end;

    local Centre, v25 = MobileLayoutState.GetCentre(p23);
    local Size, v26 = MobileLayoutState.GetSize(p23);

    if Centre and v25 then
        v24.Position = UDim2.fromScale(Centre, v25);
    end;

    if Size and v26 then
        v24.Size = UDim2.fromScale(Size, v26);
    end;

    MobileLayoutState.ApplyFade(p23, v24, MobileLayoutState.FADE_DEFAULT);

    if p23 == u6 then
        local v27 = u3[p23];

        if v27 then
            v27 = v27:FindFirstChildOfClass("UIStroke");
        end;

        if not v27 then
            return;
        end;

        v27.Color = Color3_fromRGB_ret;
        v27.Transparency = 0;
        v27.Thickness = 4;
    end;
end;

local function SetRow(p28: userdata, p29: number, p30: number, p31: number) -- Line: 149
    local DragSlider = p28.DragSlider;
    local ColorImage = DragSlider.Holder:FindFirstChild("ColorImage");

    if ColorImage then
        ColorImage.Size = UDim2.fromScale(math.clamp((p29 - p30) / (p31 - p30), 0, 1), 1);
    end;

    DragSlider.Frame.NumberDisplay.Text = `{p29}%`;
end;

local function RefreshPanel() -- Line: 158
    -- upvalues: UIConstants (copy), u6 (ref), u1 (copy), MobileLayoutState (copy)
    local EditPanel = UIConstants.MOBILE_EDITOR.EditPanel;
    local ScaleRow = EditPanel.ScaleRow;
    local OpacityRow = EditPanel.OpacityRow;
    ScaleRow.Visible = u6 ~= nil;
    OpacityRow.Visible = u6 ~= nil;

    if not u6 then
        EditPanel.Title.Description.Text = "Tap a button to edit";

        return;
    end;

    EditPanel.Title.Description.Text = u1[u6] or u6;
    local Scale = MobileLayoutState.GetScale(u6);
    local SCALE_MIN = MobileLayoutState.SCALE_MIN;
    local SCALE_MAX = MobileLayoutState.SCALE_MAX;
    local DragSlider = ScaleRow.DragSlider;
    local ColorImage = DragSlider.Holder:FindFirstChild("ColorImage");

    if ColorImage then
        ColorImage.Size = UDim2.fromScale(math.clamp((Scale - SCALE_MIN) / (SCALE_MAX - SCALE_MIN), 0, 1), 1);
    end;

    DragSlider.Frame.NumberDisplay.Text = `{Scale}%`;
    local Opacity = MobileLayoutState.GetOpacity(u6);
    local OPACITY_MIN = MobileLayoutState.OPACITY_MIN;
    local OPACITY_MAX = MobileLayoutState.OPACITY_MAX;
    local DragSlider2 = OpacityRow.DragSlider;
    local ColorImage2 = DragSlider2.Holder:FindFirstChild("ColorImage");

    if ColorImage2 then
        ColorImage2.Size = UDim2.fromScale(math.clamp((Opacity - OPACITY_MIN) / (OPACITY_MAX - OPACITY_MIN), 0, 1), 1);
    end;

    DragSlider2.Frame.NumberDisplay.Text = `{Opacity}%`;
end;

local function SetSelected(p32: string?) -- Line: 172
    -- upvalues: u6 (ref), u3 (copy), u4 (copy), u5 (copy), MobileLayoutState (copy), Color3_fromRGB_ret (copy), RefreshPanel (copy)
    if u6 == p32 then
        return;
    end;

    local v33 = u6;
    local v34;

    if v33 then
        v34 = u3[v33];
    else
        v34 = v33;
    end;

    u6 = p32;

    if v34 then
        v34.ZIndex = u4[v33] or 2;
        local v35 = u3[v33];
        local v36;

        if v35 then
            v36 = v35:FindFirstChildOfClass("UIStroke");
        else
            v36 = v35;
        end;

        if v36 then
            local v37 = u5[v33];

            if v37 then
                v36.Color = v37.Color;
                v36.Thickness = v37.Thickness;
            end;

            MobileLayoutState.ApplyFade(v33, v35, MobileLayoutState.FADE_DEFAULT);
        end;
    end;

    local v38;

    if p32 then
        v38 = u3[p32];
    else
        v38 = p32;
    end;

    if v38 then
        v38.ZIndex = 50;
        local v39 = u3[p32];

        if v39 then
            v39 = v39:FindFirstChildOfClass("UIStroke");
        end;

        if v39 then
            v39.Color = Color3_fromRGB_ret;
            v39.Transparency = 0;
            v39.Thickness = 4;
        end;
    end;

    RefreshPanel();
end;

local function BuildMocks() -- Line: 191
    -- upvalues: u9 (ref), UIConstants (copy), u3 (copy), u4 (copy), u5 (copy), MobileLayoutState (copy), ApplyMock (copy)
    if u9 then
        return;
    end;

    local MobileTouchButtons = UIConstants.GUI_MAIN:FindFirstChild("MobileTouchButtons");

    if not MobileTouchButtons then
        return;
    end;

    local Mocks = UIConstants.MOBILE_EDITOR.Mocks;
    Mocks:ClearAllChildren();
    table.clear(u3);
    table.clear(u4);
    table.clear(u5);

    for i, v in MobileLayoutState.EDITABLE do
        local v40 = MobileTouchButtons:FindFirstChild(v);

        if v40 then
            local v41 = v40:Clone();
            v41.Name = v;
            v41.Visible = true;
            v41.Active = true;
            v41.AutoButtonColor = false;
            v41.ZIndex = 2 + i;
            u4[v] = v41.ZIndex;
            local Hint = v41:FindFirstChild("Hint");

            if Hint then
                Hint.Visible = false;
            end;

            local v42 = MobileLayoutState.LabelOf(v41);

            if v42.Text == "" then
                v42.Text = v;
            end;

            local v43 = v41:FindFirstChildOfClass("UIStroke");

            if v43 then
                u5[v] = {
                    Color = v43:GetAttribute("ColorDefault") or v43.Color,
                    Thickness = v43.Thickness
                };
            end;

            v41.Parent = Mocks;
            u3[v] = v41;
            ApplyMock(v);
        end;
    end;

    u9 = true;
end;

local function InRect(p44: userdata, p45) -- Line: 235
    local AbsolutePosition = p44.AbsolutePosition;
    local AbsoluteSize = p44.AbsoluteSize;
    local v46;

    if p45.X >= AbsolutePosition.X and (p45.X <= AbsolutePosition.X + AbsoluteSize.X and p45.Y >= AbsolutePosition.Y) then
        v46 = p45.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v46 = false;
    end;

    return v46;
end;

local function MockAtPosition(p47) -- Line: 242
    -- upvalues: u3 (copy)
    local v48 = -1;
    local v49 = nil;

    for i, v in u3 do
        if v.Visible then
            local AbsolutePosition = v.AbsolutePosition;
            local AbsoluteSize = v.AbsoluteSize;
            local v50;

            if p47.X >= AbsolutePosition.X and (p47.X <= AbsolutePosition.X + AbsoluteSize.X and p47.Y >= AbsolutePosition.Y) then
                v50 = p47.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
            else
                v50 = false;
            end;

            if v50 and v.ZIndex > v48 then
                v48 = v.ZIndex;
                v49 = i;
            end;
        end;
    end;

    return v49;
end;

local function RefreshAllMocks() -- Line: 253
    -- upvalues: u3 (copy), ApplyMock (copy), RefreshPanel (copy), MobileLayoutState (copy)
    for i in u3 do
        ApplyMock(i);
    end;

    RefreshPanel();
    MobileLayoutState.Changed:Fire();
end;

local function SetSliderFromPointer(p51: userdata, p52: number) -- Line: 262
    -- upvalues: u6 (ref), MobileLayoutState (copy), ApplyMock (copy), RefreshPanel (copy)
    if not u6 then
        return;
    end;

    local DragSlider = p51.DragSlider;
    local X = DragSlider.AbsoluteSize.X;

    if X <= 0 then
        return;
    end;

    local math_clamp_ret = math.clamp((p52 - DragSlider.AbsolutePosition.X) / X, 0, 1);

    if p51.Name == "ScaleRow" then
        MobileLayoutState.SetScale(u6, MobileLayoutState.SCALE_MIN + math_clamp_ret * (MobileLayoutState.SCALE_MAX - MobileLayoutState.SCALE_MIN));
    else
        MobileLayoutState.SetOpacity(u6, MobileLayoutState.OPACITY_MIN + math_clamp_ret * (MobileLayoutState.OPACITY_MAX - MobileLayoutState.OPACITY_MIN));
    end;

    ApplyMock(u6);
    RefreshPanel();
end;

local function SetOpen(p53: boolean) -- Line: 277
    -- upvalues: UIConstants (copy), BuildMocks (copy), u7 (ref), u8 (ref), u6 (ref), u3 (copy), u4 (copy), u5 (copy), MobileLayoutState (copy), RefreshPanel (copy), u12 (ref), ApplyMock (copy)
    local Visible = UIConstants.MOBILE_EDITOR.Visible;

    if p53 then
        BuildMocks();
    end;

    UIConstants.MOBILE_EDITOR.Visible = p53;
    UIConstants.MOBILE_EDITOR.EditPanel.Visible = p53;
    UIConstants.MOBILE_TAB_EDIT.Visible = not p53;
    UIConstants.MOBILE_TAB_LIST.Visible = not p53;

    if p53 then
        if not Visible then
            u12 = MobileLayoutState.Snapshot();
        end;

        for i in u3 do
            ApplyMock(i);
        end;

        RefreshPanel();
        MobileLayoutState.Changed:Fire();

        return;
    end;

    u7 = nil;
    u8 = nil;

    if u6 ~= nil then
        local v54 = u6;
        local v55;

        if v54 then
            v55 = u3[v54];
        else
            v55 = v54;
        end;

        u6 = nil;

        if v55 then
            v55.ZIndex = u4[v54] or 2;
            local v56 = u3[v54];
            local v57;

            if v56 then
                v57 = v56:FindFirstChildOfClass("UIStroke");
            else
                v57 = v56;
            end;

            if v57 then
                local v58 = u5[v54];

                if v58 then
                    v57.Color = v58.Color;
                    v57.Thickness = v58.Thickness;
                end;

                MobileLayoutState.ApplyFade(v54, v56, MobileLayoutState.FADE_DEFAULT);
            end;
        end;

        RefreshPanel();
    end;

    if u12 then
        MobileLayoutState.Restore(u12);
        u12 = nil;

        for i in u3 do
            ApplyMock(i);
        end;

        RefreshPanel();
        MobileLayoutState.Changed:Fire();
    end;
end;

local function RefreshOpen() -- Line: 306
    -- upvalues: UIConstants (copy), Parent (copy), u13 (ref), SetOpen (copy)
    local v59;

    if UIConstants.MOBILE_TAB.Visible == true then
        v59 = Parent:GetAttribute("Open") == true;
    else
        v59 = false;
    end;

    if not v59 then
        u13 = false;
    end;

    local v60;

    if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
        v60 = u13;
    else
        v60 = false;
    end;

    SetOpen(v60);
end;

local function CloseEditor() -- Line: 311
    -- upvalues: u13 (ref), UIConstants (copy), Parent (copy), SetOpen (copy)
    u13 = false;
    local v61;

    if UIConstants.MOBILE_TAB.Visible == true then
        v61 = Parent:GetAttribute("Open") == true;
    else
        v61 = false;
    end;

    if not v61 then
        u13 = false;
    end;

    local v62;

    if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
        v62 = u13;
    else
        v62 = false;
    end;

    SetOpen(v62);
end;

local function HandleConfirm() -- Line: 317
    -- upvalues: SoundModule (copy), u12 (ref), QueueSave (copy), MobileLayoutState (copy), u13 (ref), UIConstants (copy), Parent (copy), SetOpen (copy)
    SoundModule.PlaySound("Click");
    u12 = nil;
    QueueSave();
    MobileLayoutState.Changed:Fire();
    u13 = false;
    local v63;

    if UIConstants.MOBILE_TAB.Visible == true then
        v63 = Parent:GetAttribute("Open") == true;
    else
        v63 = false;
    end;

    if not v63 then
        u13 = false;
    end;

    local v64;

    if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
        v64 = u13;
    else
        v64 = false;
    end;

    SetOpen(v64);
end;

local function HandleCancel() -- Line: 326
    -- upvalues: SoundModule (copy), u13 (ref), UIConstants (copy), Parent (copy), SetOpen (copy)
    SoundModule.PlaySound("Click");
    u13 = false;
    local v65;

    if UIConstants.MOBILE_TAB.Visible == true then
        v65 = Parent:GetAttribute("Open") == true;
    else
        v65 = false;
    end;

    if not v65 then
        u13 = false;
    end;

    local v66;

    if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
        v66 = u13;
    else
        v66 = false;
    end;

    SetOpen(v66);
end;

local function HandleReset() -- Line: 333
    -- upvalues: SoundModule (copy), MobileLayoutState (copy), u3 (copy), ApplyMock (copy), RefreshPanel (copy)
    SoundModule.PlaySound("Click");
    MobileLayoutState.Reset();

    for i in u3 do
        ApplyMock(i);
    end;

    RefreshPanel();
    MobileLayoutState.Changed:Fire();
end;

local u67 = {};
script.AncestryChanged:Connect(function() -- Line: 344
    -- upvalues: u67 (copy)
    if script:IsDescendantOf(game) then
        return;
    end;

    for _, v in u67 do
        v:Disconnect();
    end;

    table.clear(u67);
end);
u67[#u67 + 1] = UserInputService.InputBegan:Connect(function(p68) -- Line: 355
    -- upvalues: UIConstants (copy), Parent (copy), u13 (ref), SoundModule (copy), u12 (ref), QueueSave (copy), MobileLayoutState (copy), SetOpen (copy), u3 (copy), ApplyMock (copy), RefreshPanel (copy), u8 (ref), SetSliderFromPointer (copy), MockAtPosition (copy), u6 (ref), u4 (copy), u5 (copy), Color3_fromRGB_ret (copy), u7 (ref)
    local v69;

    if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
        v69 = u13;
    else
        v69 = false;
    end;

    if not v69 then
        return;
    end;

    local UserInputType = p68.UserInputType;

    if UserInputType ~= Enum.UserInputType.Touch and UserInputType ~= Enum.UserInputType.MouseButton1 then
        return;
    end;

    local Vector2_new_ret = Vector2.new(p68.Position.X, p68.Position.Y);
    local SETTINGS_NAV = UIConstants.SETTINGS_NAV;
    local AbsolutePosition = SETTINGS_NAV.AbsolutePosition;
    local AbsoluteSize = SETTINGS_NAV.AbsoluteSize;
    local v70;

    if Vector2_new_ret.X >= AbsolutePosition.X and (Vector2_new_ret.X <= AbsolutePosition.X + AbsoluteSize.X and Vector2_new_ret.Y >= AbsolutePosition.Y) then
        v70 = Vector2_new_ret.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v70 = false;
    end;

    if v70 then
        return;
    end;

    local EditPanel = UIConstants.MOBILE_EDITOR.EditPanel;

    if EditPanel.Visible then
        local AbsolutePosition2 = EditPanel.AbsolutePosition;
        local AbsoluteSize2 = EditPanel.AbsoluteSize;
        local v71;

        if Vector2_new_ret.X >= AbsolutePosition2.X and (Vector2_new_ret.X <= AbsolutePosition2.X + AbsoluteSize2.X and Vector2_new_ret.Y >= AbsolutePosition2.Y) then
            v71 = Vector2_new_ret.Y <= AbsolutePosition2.Y + AbsoluteSize2.Y;
        else
            v71 = false;
        end;

        if v71 then
            local Confirm = EditPanel.Confirm;
            local AbsolutePosition3 = Confirm.AbsolutePosition;
            local AbsoluteSize3 = Confirm.AbsoluteSize;
            local v72;

            if Vector2_new_ret.X >= AbsolutePosition3.X and (Vector2_new_ret.X <= AbsolutePosition3.X + AbsoluteSize3.X and Vector2_new_ret.Y >= AbsolutePosition3.Y) then
                v72 = Vector2_new_ret.Y <= AbsolutePosition3.Y + AbsoluteSize3.Y;
            else
                v72 = false;
            end;

            if v72 then
                SoundModule.PlaySound("Click");
                u12 = nil;
                QueueSave();
                MobileLayoutState.Changed:Fire();
                u13 = false;
                local v73;

                if UIConstants.MOBILE_TAB.Visible == true then
                    v73 = Parent:GetAttribute("Open") == true;
                else
                    v73 = false;
                end;

                if not v73 then
                    u13 = false;
                end;

                local v74;

                if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
                    v74 = u13;
                else
                    v74 = false;
                end;

                SetOpen(v74);

                return;
            end;

            local Cancel = EditPanel.Cancel;
            local AbsolutePosition4 = Cancel.AbsolutePosition;
            local AbsoluteSize4 = Cancel.AbsoluteSize;
            local v75;

            if Vector2_new_ret.X >= AbsolutePosition4.X and (Vector2_new_ret.X <= AbsolutePosition4.X + AbsoluteSize4.X and Vector2_new_ret.Y >= AbsolutePosition4.Y) then
                v75 = Vector2_new_ret.Y <= AbsolutePosition4.Y + AbsoluteSize4.Y;
            else
                v75 = false;
            end;

            if v75 then
                SoundModule.PlaySound("Click");
                u13 = false;
                local v76;

                if UIConstants.MOBILE_TAB.Visible == true then
                    v76 = Parent:GetAttribute("Open") == true;
                else
                    v76 = false;
                end;

                if not v76 then
                    u13 = false;
                end;

                local v77;

                if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
                    v77 = u13;
                else
                    v77 = false;
                end;

                SetOpen(v77);

                return;
            end;

            local Reset = EditPanel.Reset;
            local AbsolutePosition5 = Reset.AbsolutePosition;
            local AbsoluteSize5 = Reset.AbsoluteSize;
            local v78;

            if Vector2_new_ret.X >= AbsolutePosition5.X and (Vector2_new_ret.X <= AbsolutePosition5.X + AbsoluteSize5.X and Vector2_new_ret.Y >= AbsolutePosition5.Y) then
                v78 = Vector2_new_ret.Y <= AbsolutePosition5.Y + AbsoluteSize5.Y;
            else
                v78 = false;
            end;

            if not v78 then
                for _, v in { EditPanel.ScaleRow, EditPanel.OpacityRow } do
                    if v.Visible then
                        local AbsolutePosition6 = v.AbsolutePosition;
                        local AbsoluteSize6 = v.AbsoluteSize;
                        local v79;

                        if Vector2_new_ret.X >= AbsolutePosition6.X and (Vector2_new_ret.X <= AbsolutePosition6.X + AbsoluteSize6.X and Vector2_new_ret.Y >= AbsolutePosition6.Y) then
                            v79 = Vector2_new_ret.Y <= AbsolutePosition6.Y + AbsoluteSize6.Y;
                        else
                            v79 = false;
                        end;

                        if v79 then
                            u8 = {
                                Row = v,
                                Input = p68
                            };
                            SetSliderFromPointer(v, Vector2_new_ret.X);

                            return;
                        end;
                    end;
                end;

                return;
            end;

            SoundModule.PlaySound("Click");
            MobileLayoutState.Reset();

            for i in u3 do
                ApplyMock(i);
            end;

            RefreshPanel();
            MobileLayoutState.Changed:Fire();

            return;
        end;
    end;

    local v80 = MockAtPosition(Vector2_new_ret);

    if v80 then
        local v81 = u6 == v80;

        if not v81 then
            SoundModule.PlaySound("Click");
        end;

        if u6 ~= v80 then
            local v82 = u6;
            local v83;

            if v82 then
                v83 = u3[v82];
            else
                v83 = v82;
            end;

            u6 = v80;

            if v83 then
                v83.ZIndex = u4[v82] or 2;
                local v84 = u3[v82];
                local v85;

                if v84 then
                    v85 = v84:FindFirstChildOfClass("UIStroke");
                else
                    v85 = v84;
                end;

                if v85 then
                    local v86 = u5[v82];

                    if v86 then
                        v85.Color = v86.Color;
                        v85.Thickness = v86.Thickness;
                    end;

                    MobileLayoutState.ApplyFade(v82, v84, MobileLayoutState.FADE_DEFAULT);
                end;
            end;

            local v87;

            if v80 then
                v87 = u3[v80];
            else
                v87 = v80;
            end;

            if v87 then
                v87.ZIndex = 50;
                local v88 = u3[v80];

                if v88 then
                    v88 = v88:FindFirstChildOfClass("UIStroke");
                end;

                if v88 then
                    v88.Color = Color3_fromRGB_ret;
                    v88.Transparency = 0;
                    v88.Thickness = 4;
                end;
            end;

            RefreshPanel();
        end;

        local Centre, v89 = MobileLayoutState.GetCentre(v80);
        u7 = {
            Moved = false,
            Name = v80,
            Input = p68,
            StartPointer = Vector2_new_ret,
            StartCentre = Vector2.new(Centre or 0, v89 or 0),
            WasSelected = v81
        };

        return;
    end;

    if u6 == nil then
        return;
    end;

    local v90 = u6;
    local v91;

    if v90 then
        v91 = u3[v90];
    else
        v91 = v90;
    end;

    u6 = nil;

    if v91 then
        v91.ZIndex = u4[v90] or 2;
        local v92 = u3[v90];
        local v93;

        if v92 then
            v93 = v92:FindFirstChildOfClass("UIStroke");
        else
            v93 = v92;
        end;

        if v93 then
            local v94 = u5[v90];

            if v94 then
                v93.Color = v94.Color;
                v93.Thickness = v94.Thickness;
            end;

            MobileLayoutState.ApplyFade(v90, v92, MobileLayoutState.FADE_DEFAULT);
        end;
    end;

    RefreshPanel();
end);

local function IsMoveOf(p95: userdata, p96: userdata) -- Line: 402
    if p95.UserInputType == Enum.UserInputType.Touch then
        return p96 == p95;
    end;

    return p96.UserInputType == Enum.UserInputType.MouseMovement;
end;

local function IsEndOf(p97: userdata, p98: userdata) -- Line: 409
    if p97.UserInputType == Enum.UserInputType.Touch then
        return p98 == p97;
    end;

    return p98.UserInputType == Enum.UserInputType.MouseButton1;
end;

u67[#u67 + 1] = UserInputService.InputChanged:Connect(function(p99) -- Line: 416
    -- upvalues: UIConstants (copy), Parent (copy), u13 (ref), u8 (ref), SetSliderFromPointer (copy), u7 (ref), u3 (copy), MobileLayoutState (copy), ApplyMock (copy)
    local v100;

    if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
        v100 = u13;
    else
        v100 = false;
    end;

    if not v100 then
        return;
    end;

    if not u8 then
        if u7 then
            local Input = u7.Input;
            local v101;

            if Input.UserInputType == Enum.UserInputType.Touch then
                v101 = p99 == Input;
            else
                v101 = p99.UserInputType == Enum.UserInputType.MouseMovement;
            end;

            if v101 then
                local v102 = Vector2.new(p99.Position.X, p99.Position.Y) - u7.StartPointer;

                if not u7.Moved and v102.Magnitude < 6 then
                    return;
                end;

                u7.Moved = true;
                local AbsoluteSize = UIConstants.MOBILE_EDITOR.AbsoluteSize;

                if AbsoluteSize.X <= 0 or AbsoluteSize.Y <= 0 then
                    return;
                end;

                local v103 = u3[u7.Name];
                local v104 = not v103 and 0 or v103.Size.X.Scale / 2;
                local v105 = not v103 and 0 or v103.Size.Y.Scale / 2;
                local math_clamp_ret = math.clamp(u7.StartCentre.X + v102.X / AbsoluteSize.X, v104, 1 - v104);
                local math_clamp_ret2 = math.clamp(u7.StartCentre.Y + v102.Y / AbsoluteSize.Y, v105, 1 - v105);
                MobileLayoutState.SetPosition(u7.Name, math_clamp_ret, math_clamp_ret2);
                ApplyMock(u7.Name);

                return;
            end;
        end;

        return;
    end;

    local Input = u8.Input;
    local v106;

    if Input.UserInputType == Enum.UserInputType.Touch then
        v106 = p99 == Input;
    else
        v106 = p99.UserInputType == Enum.UserInputType.MouseMovement;
    end;

    if v106 then
        SetSliderFromPointer(u8.Row, p99.Position.X);
    end;
end);
u67[#u67 + 1] = UserInputService.InputEnded:Connect(function(p107) -- Line: 443
    -- upvalues: UIConstants (copy), Parent (copy), u13 (ref), u8 (ref), MobileLayoutState (copy), u7 (ref), u6 (ref), u3 (copy), u4 (copy), u5 (copy), RefreshPanel (copy)
    local v108;

    if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
        v108 = u13;
    else
        v108 = false;
    end;

    if not v108 then
        return;
    end;

    if not u8 then
        if u7 then
            local Input = u7.Input;
            local v109;

            if Input.UserInputType == Enum.UserInputType.Touch then
                v109 = p107 == Input;
            else
                v109 = p107.UserInputType == Enum.UserInputType.MouseButton1;
            end;

            if v109 then
                local v110 = u7;
                u7 = nil;

                if v110.Moved then
                    MobileLayoutState.Changed:Fire();

                    return;
                end;

                if v110.WasSelected then
                    if u6 == nil then
                        return;
                    end;

                    local v111 = u6;
                    local v112;

                    if v111 then
                        v112 = u3[v111];
                    else
                        v112 = v111;
                    end;

                    u6 = nil;

                    if v112 then
                        v112.ZIndex = u4[v111] or 2;
                        local v113 = u3[v111];
                        local v114;

                        if v113 then
                            v114 = v113:FindFirstChildOfClass("UIStroke");
                        else
                            v114 = v113;
                        end;

                        if v114 then
                            local v115 = u5[v111];

                            if v115 then
                                v114.Color = v115.Color;
                                v114.Thickness = v115.Thickness;
                            end;

                            MobileLayoutState.ApplyFade(v111, v113, MobileLayoutState.FADE_DEFAULT);
                        end;
                    end;

                    RefreshPanel();
                end;

                return;
            end;
        end;

        return;
    end;

    local Input = u8.Input;
    local v116;

    if Input.UserInputType == Enum.UserInputType.Touch then
        v116 = p107 == Input;
    else
        v116 = p107.UserInputType == Enum.UserInputType.MouseButton1;
    end;

    if v116 then
        u8 = nil;
        MobileLayoutState.Changed:Fire();
    end;
end);

function v2.Load() -- Line: 462
    -- upvalues: MobileModule (copy), UIConstants (copy), SoundModule (copy), u13 (ref), Parent (copy), SetOpen (copy), MobileLayoutState (copy), PlayerDataModule (copy), u10 (ref), RefreshOpen (copy)
    local v117 = MobileModule.IsTouchDevice();
    local MOBILE_TAB_BUTTON = UIConstants.MOBILE_TAB_BUTTON;

    if MOBILE_TAB_BUTTON then
        MOBILE_TAB_BUTTON.Visible = v117;
    end;

    local v118 = v117 and 0.20633333333333334 or 0.25;

    for _, child in UIConstants.SETTINGS_NAV:GetChildren() do
        if child:IsA("TextButton") then
            child.Size = UDim2.new(v118, 0, child.Size.Y.Scale, child.Size.Y.Offset);
        end;
    end;

    UIConstants.MOBILE_EDITOR.Visible = false;
    UIConstants.MOBILE_EDITOR.EditPanel.Visible = false;
    UIConstants.MOBILE_TAB_EDIT.Visible = true;
    UIConstants.MOBILE_TAB_LIST.Visible = true;
    UIConstants.MOBILE_TAB_EDIT.MouseButton1Click:Connect(function() -- Line: 486
        -- upvalues: SoundModule (ref), u13 (ref), UIConstants (ref), Parent (ref), SetOpen (ref)
        SoundModule.PlaySound("Click");
        u13 = true;
        local v119;

        if UIConstants.MOBILE_TAB.Visible == true then
            v119 = Parent:GetAttribute("Open") == true;
        else
            v119 = false;
        end;

        if not v119 then
            u13 = false;
        end;

        local v120;

        if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
            v120 = u13;
        else
            v120 = false;
        end;

        SetOpen(v120);
    end);

    if not MobileLayoutState.Hydrated then
        MobileLayoutState.Hydrated = true;
        MobileLayoutState.Apply(PlayerDataModule.MobileLayout);
        MobileLayoutState.Changed:Fire();
    end;

    u10 = MobileLayoutState.Encode() or MobileLayoutState.EMPTY;
    UIConstants.MOBILE_TAB:GetPropertyChangedSignal("Visible"):Connect(RefreshOpen);
    Parent:GetAttributeChangedSignal("Open"):Connect(RefreshOpen);
    local v121;

    if UIConstants.MOBILE_TAB.Visible == true then
        v121 = Parent:GetAttribute("Open") == true;
    else
        v121 = false;
    end;

    if not v121 then
        u13 = false;
    end;

    local v122;

    if UIConstants.MOBILE_TAB.Visible == true and Parent:GetAttribute("Open") == true then
        v122 = u13;
    else
        v122 = false;
    end;

    SetOpen(v122);
end;

return v2;
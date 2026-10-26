-- [PATH] ReplicatedStorage / CharacterScripts / WheelController @Type LocalScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local TweenUtil = require(Modules:WaitForChild("TweenUtil"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local MobileModule = require(Modules:WaitForChild("MobileModule"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local Open = script:WaitForChild("Open");
local Close = script:WaitForChild("Close");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
script_Parent:WaitForChild("Humanoid");
local PreferredInputController = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PreferredInputController");
local Main = PlayerGui:WaitForChild("Main");
local Wheel = Main:WaitForChild("Wheel");
local Options = Main:WaitForChild("MobileTouchButtons"):WaitForChild("Options");
local Row = Options:WaitForChild("Row");
local Option = Options:WaitForChild("Option");
local UIListLayout = Options:WaitForChild("UIListLayout");

local function getDeadzone() -- Line: 48
    -- upvalues: PreferredInputController (copy)
    return PreferredInputController:GetAttribute("JoystickDeadzone") or 0.225;
end;

local u1 = {
    Dialog = true
};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = 0;
local u7 = {};
local u8 = 1;
local u9 = nil;
local u10 = 1;
local u11 = {};

local function _() -- Line: 78
    -- upvalues: PreferredInputController (copy)
    local v12 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

    return v12;
end;

local function u15(p13) -- Line: 82
    -- upvalues: UserInputService (copy), PreferredInputController (copy)
    local success, result = pcall(function() -- Line: 83
        -- upvalues: UserInputService (ref)
        return UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1);
    end);

    if not (success and result) then
        return nil;
    end;

    for _, v in pairs(result) do
        if v.KeyCode == Enum.KeyCode.Thumbstick1 then
            local X = v.Position.X;
            local Y = v.Position.Y;

            if math.sqrt(X * X + Y * Y) <= (PreferredInputController:GetAttribute("JoystickDeadzone") or 0.225) then
                return nil;
            end;

            local math_atan2_ret = math.atan2(X, Y);
            local math_deg_ret = math.deg(math_atan2_ret);

            if math_deg_ret < 0 then
                math_deg_ret = math_deg_ret + 360;
            end;

            local v14 = 360 / p13;

            return math.floor((math_deg_ret + (p13 == 2 and (v14 / 2 or 0) or 0)) % 360 / v14) + 1;
        end;
    end;

    return nil;
end;

local function u18(p16, p17) -- Line: 109
    -- upvalues: u10 (ref), Wheel (copy), u2 (ref), u6 (ref), NumberUtil (copy)
    u10 = p16;

    for _, child in pairs(Wheel:GetChildren()) do
        for _, v in pairs(u2 == child and { child.Red, unpack(child.Icon:GetChildren()) } or (child:IsA("Frame") and {} or { child })) do
            if v.Name ~= "Red" or (u6 ~= 0 or not p17 and v.ImageTransparency ~= 1) then
                v[(v:IsA("TextLabel") and "Text" or (v:IsA("ImageLabel") and "Image" or "Background")) .. "Transparency"] = NumberUtil:Lerp(v.Name == "BG" and 0.2 or 0, 1, p16);
            end;
        end;
    end;

    Wheel.Visible = p16 < 1;
end;

local function u23(p19) -- Line: 124
    -- upvalues: Wheel (copy), NumberUtil (copy), u3 (ref), u4 (ref), u8 (ref), u18 (copy), RunService (copy)
    if p19 then
        Wheel.Size = NumberUtil:MultUDim2ByNum(u3, 1.3);
    end;

    Wheel:TweenSize(NumberUtil:MultUDim2ByNum(u3, p19 and 1 or 1.3), p19 and "Out" or "In", "Quart", 0.175, true);
    local v20 = tick();
    local v21 = p19 and 0 or 1;

    if u4 and not p19 then
        u4:Cancel();
    end;

    if u8 ~= v21 then
        u8 = v21;

        while true do
            local v22 = tick() - v20;
            local math_min_ret = math.min(v22 / 0.1, 1);

            if p19 then
                math_min_ret = 1 - math_min_ret or math_min_ret;
            end;

            u18(math_min_ret, p19);

            if v22 >= 0.1 then
                break;
            end;

            RunService.Heartbeat:Wait();
        end;
    end;
end;

local function u27(p24) -- Line: 151
    -- upvalues: Wheel (copy), u2 (ref), u4 (ref), TweenUtil (copy), u5 (ref), u6 (ref)
    Wheel.SelectedImage.Image = p24 and (p24.Image or "") or "";
    Wheel.SelectedName.Text = p24 and (p24.Name or "") or "";
    Wheel.SelectedDesc.Text = p24 and (p24.Description or "") or "";
    Wheel.SelectedCost.Text = p24 and (type(p24.Cost) == "function" and p24.Cost() or (p24.Cost or "")) or "";

    if not u2 then
        return;
    end;

    if p24 then
        u4 = TweenUtil:Tween(u2.Red, "ImageTransparency", 0, 0.2, "Quart");
    else
        u2.Red.ImageTransparency = 1;
    end;

    for _, child in pairs(u2.Icon:GetChildren()) do
        local v25 = tonumber(child.Name:sub(2));
        local v26 = u5[v25];
        child.ImageColor3 = script:GetAttribute(v25 == u6 and "IconSelectedColor" or ((v26 == nil or not v26.Selectable) and "IconUnavailableColor" or "IconUnselectedColor"));
    end;
end;

local function u31(p28, p29) -- Line: 169
    -- upvalues: u2 (ref), u6 (ref), TweenUtil (copy), u27 (copy)
    if not u2 or u6 == p28 then
        return;
    end;

    local v30 = tonumber(u2.Name:sub(6));
    TweenUtil:Tween(u2.Red, "Rotation", 360 / v30 * (p28 - 1), u6 == 0 and 0 or 0.2, "Quart");
    u6 = p28;
    u27(p29);
end;

local function u38(p32) -- Line: 179
    -- upvalues: Wheel (copy)
    local v33 = nil;
    local v34 = nil;
    local v35 = nil;
    local v36 = nil;

    for _, child in pairs(Wheel:GetChildren()) do
        local v37 = child:IsA("Frame") and tonumber(child.Name:match("^Wheel(%d+)$"));

        if v37 then
            if p32 <= v37 and (not v33 or v37 < v33) then
                v35 = child;
                v33 = v37;
            end;

            if not v34 or v34 < v37 then
                v36 = child;
                v34 = v37;
            end;
        end;
    end;

    if v35 then
        return v35, v33, false;
    end;

    return v36, v34, true;
end;

local function u39() -- Line: 195
    -- upvalues: u7 (ref), RunService (copy)
    for _, v in pairs(u7) do
        v:Disconnect();
    end;

    u7 = {};
    pcall(function() -- Line: 200
        -- upvalues: RunService (ref)
        RunService:UnbindFromRenderStep("WheelGamepadInput");
    end);
end;

local function u43(p40) -- Line: 205
    -- upvalues: PlayerGui (copy)
    local TouchGui = PlayerGui:FindFirstChild("TouchGui");
    local v41 = TouchGui and TouchGui.Enabled and TouchGui:FindFirstChild("TouchControlFrame");

    if v41 then
        v41 = v41:FindFirstChild("DynamicThumbstickFrame");
    end;

    if not v41 then
        return false;
    end;

    local AbsolutePosition = v41.AbsolutePosition;
    local AbsoluteSize = v41.AbsoluteSize;
    local v42;

    if p40.X >= AbsolutePosition.X and (p40.X <= AbsolutePosition.X + AbsoluteSize.X and p40.Y >= AbsolutePosition.Y) then
        v42 = p40.Y <= AbsolutePosition.Y + AbsoluteSize.Y;
    else
        v42 = false;
    end;

    return v42;
end;

local function _() -- Line: 215
    -- upvalues: u11 (ref)
    for _, v in u11 do
        v:Destroy();
    end;

    u11 = {};
end;

local function _(p44) -- Line: 222
    -- upvalues: u11 (ref), Row (copy), Options (copy)
    local v45 = u11[p44];

    if v45 then
        return v45;
    end;

    local v46 = Row:Clone();
    v46.Name = "Row" .. p44;
    v46.LayoutOrder = p44;
    v46.Visible = true;
    v46.Parent = Options;
    u11[p44] = v46;

    return v46;
end;

local function u59(p47, p48) -- Line: 234
    -- upvalues: u39 (copy), u11 (ref), Options (copy), UIListLayout (copy), Row (copy), Option (copy), u1 (copy), u7 (ref), RunService (copy), UserInputService (copy), u43 (copy)
    script:SetAttribute("Open", true);
    script:SetAttribute("WheelType", p48);
    u39();

    for _, v in u11 do
        v:Destroy();
    end;

    u11 = {};
    local math_ceil_ret = math.ceil(#p47 / 4);
    local math_max_ret = math.max(math_ceil_ret, 1);
    local v49 = math_max_ret * 0.14168937329700274 + (math_max_ret - 1) * 0.01634877384196185;
    Options.Size = UDim2.fromScale(0.472630173564753, v49);
    UIListLayout.Padding = UDim.new(0.01634877384196185 / v49, 0);
    Row.Size = UDim2.fromScale(1, 0.14168937329700274 / v49);
    local u50 = nil;

    for i, v in ipairs(p47) do
        local v51 = (i - 1) // 4 + 1;
        local v52 = u11[v51];

        if not v52 then
            v52 = Row:Clone();
            v52.Name = "Row" .. v51;
            v52.LayoutOrder = v51;
            v52.Visible = true;
            v52.Parent = Options;
            u11[v51] = v52;
        end;

        local v53 = Option:Clone();
        v53.Name = "Option" .. i;
        v53.LayoutOrder = i;
        v53.Icon.Image = v.Image or "";
        v53.Label.Text = v.Name or "";

        if v.Color then
            v53.Label.TextColor3 = v.Color;
        end;

        if u1[p48] then
            v53.Label.Position = UDim2.fromScale(0.05, 0.05);
            v53.Label.Size = UDim2.fromScale(0.9, 0.9);
        end;

        v53.Cost.Text = type(v.Cost) == "function" and v.Cost() or (v.Cost or "");
        v53.Cost.Visible = v53.Cost.Text ~= "";

        if v.Selectable then
            table.insert(u7, v53.Activated:Connect(function() -- Line: 263
                -- upvalues: u50 (ref), i (copy)
                u50 = i;
                script:SetAttribute("Open", false);
            end));
        else
            v53.BackgroundColor3 = v53.BackgroundColor3:Lerp(Color3.new(), 0.5);
            v53.BackgroundTransparency = 0.55;
            v53.Icon.ImageColor3 = v53.Icon.ImageColor3:Lerp(Color3.new(), 0.45);
            v53.Label.TextTransparency = 0.4;
            v53.Cost.TextTransparency = 0.4;
        end;

        v53.Visible = true;
        v53.Parent = v52;
    end;

    Options.Visible = true;
    RunService.Heartbeat:Wait();

    if not u1[p48] then
        local u54 = nil;
        local u55 = nil;
        table.insert(u7, UserInputService.InputBegan:Connect(function(p56, p57) -- Line: 286
            -- upvalues: u43 (ref), u54 (ref), u55 (ref)
            if p56.UserInputType ~= Enum.UserInputType.Touch or (p57 or u43(p56.Position)) then
                return;
            end;

            u54 = p56;
            u55 = p56.Position;
        end));
        table.insert(u7, UserInputService.InputEnded:Connect(function(p58) -- Line: 290
            -- upvalues: u54 (ref), u55 (ref)
            if p58 ~= u54 then
                return;
            end;

            u54 = nil;

            if (p58.Position - u55).Magnitude <= 12 then
                script:SetAttribute("Open", false);
            end;
        end));
    end;

    while script:GetAttribute("Open") do
        RunService.Heartbeat:Wait();
    end;

    if script:GetAttribute("WheelType") == p48 then
        u39();

        for _, v in u11 do
            v:Destroy();
        end;

        u11 = {};
        Options.Visible = false;
    end;

    return u50;
end;

local function v76(p60, p61, p62) -- Line: 309
    -- upvalues: MobileModule (copy), u59 (copy), u39 (copy), u2 (ref), u38 (copy), u6 (ref), u5 (ref), u27 (copy), u7 (ref), u31 (copy), PreferredInputController (copy), UserInputService (copy), SettingsModule (copy), RunService (copy), u15 (copy), Wheel (copy), u23 (copy)
    if MobileModule.IsTouch() then
        return u59(p60, p61);
    end;

    script:SetAttribute("Open", true);
    script:SetAttribute("WheelType", p61);
    u39();

    if u2 then
        u2.Visible = false;
    end;

    local v63 = #p60;
    local v64, u65, v66 = u38(v63);
    u2 = v64;

    if v66 then
        warn(("[WheelController] %s wheel has %d options but the biggest wheel only has %d segments, leaving out the rest"):format(tostring(p61), v63, u65));
        p60 = table.move(p60, 1, u65, 1, {});
        v63 = u65;
    end;

    for _, v in pairs({ u2.Icon, u2.Hitbox }) do
        for _, child in pairs(v:GetChildren()) do
            local v67 = tonumber(child.Name:sub(2));

            if v67 and child:IsA("GuiObject") then
                child.Visible = v67 <= v63;
            end;
        end;
    end;

    u6 = 0;
    u5 = p60;
    u27();
    local v68 = false;
    local u69 = false;

    for i, v in pairs(p60) do
        local v70 = u2.Hitbox["Q" .. i];
        u2.Icon["Q" .. i].Image = v.Image;

        if v.Selectable then
            table.insert(u7, v70.MouseEnter:Connect(function() -- Line: 344
                -- upvalues: u31 (ref), i (copy), v (copy)
                u31(i, v);
            end));
        end;

        if v.SelectFirst then
            u31(i, v);
            v68 = true;
        end;
    end;

    local v71 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

    if v71 and (not v68 and p60[1]) then
        u31(1, p60[1]);
    end;

    table.insert(u7, UserInputService.InputBegan:Connect(function(p72) -- Line: 357
        -- upvalues: SettingsModule (ref), u69 (ref)
        if p72.UserInputType == Enum.UserInputType.MouseButton1 or p72.KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Fire") then
            task.wait();
            u69 = true;
            script:SetAttribute("Open", false);
        end;
    end));
    RunService:BindToRenderStep("WheelGamepadInput", Enum.RenderPriority.Input.Value, function() -- Line: 367
        -- upvalues: u2 (ref), u5 (ref), u15 (ref), u65 (copy), u31 (ref)
        if not (u2 and u5) then
            return;
        end;

        local v73 = u15(u65);

        if not v73 then
            return;
        end;

        local v74 = u5[v73];

        if v74 and v74.Selectable then
            u31(v73, v74);
        end;
    end);
    u2.Visible = true;
    local xtra = Wheel.xtra;
    local v75 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad" and p61 ~= "Blueprint";
    xtra.Visible = v75;
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default;
    UserInputService.MouseIconEnabled = true;
    task.spawn(u23, true);

    while script:GetAttribute("Open") do
        RunService.Heartbeat:Wait();
    end;

    if script:GetAttribute("WheelType") == p61 then
        u39();
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
        UserInputService.MouseIconEnabled = false;
        task.spawn(u23, false);
        Wheel.xtra.Visible = false;
    end;

    if not p62 or u69 then
        return u6;
    end;
end;

local function v77() -- Line: 401
    -- upvalues: Wheel (copy), u9 (ref), u10 (ref), u3 (ref)
    local Y = Wheel.AbsoluteSize.Y;

    if Y == u9 or u10 % 1 ~= 0 then
        return;
    end;

    u9 = Y;
    u3 = UDim2.new(0, Y, 0.7, 0);
    Wheel.Size = u3;
end;

Wheel:GetPropertyChangedSignal("AbsoluteSize"):Connect(v77);
Open.OnInvoke = v76;

function Close.OnInvoke(p78) -- Line: 396
    if p78 and p78 ~= script:GetAttribute("WheelType") then
        return;
    end;

    script:SetAttribute("Open", false);
end;

u3 = Wheel.Size;
u18(1);
Wheel.Visible = false;
local Y = Wheel.AbsoluteSize.Y;

if Y ~= u9 and u10 % 1 == 0 then
    u9 = Y;
    u3 = UDim2.new(0, Y, 0.7, 0);
    Wheel.Size = u3;
end;
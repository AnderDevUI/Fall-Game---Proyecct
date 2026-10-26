-- [PATH] ReplicatedStorage / MapRender / MapUIStyle @Type ModuleScript


local u5 = {
    Fonts = {
        Medium = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        SemiBold = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        Bold = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        Heavy = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    },
    Images = {
        Backdrop = "rbxassetid://80868408959715",
        Strip = "rbxassetid://114733946113824",
        Dust = "rbxassetid://131707575557451",
        Banner = "rbxassetid://892437234448703233"
    },
    Colours = {
        Panel = Color3.fromRGB(31, 31, 31),
        Row = Color3.fromRGB(58, 58, 61),
        RowDark = Color3.fromRGB(34, 34, 36),
        Field = Color3.fromRGB(28, 28, 30),
        Edge = Color3.fromRGB(25, 25, 25),
        Text = Color3.new(1, 1, 1),
        Muted = Color3.fromRGB(172, 172, 178),
        Grey = Color3.fromRGB(70, 70, 74),
        Blue = Color3.fromRGB(33, 150, 243),
        Green = Color3.fromRGB(104, 170, 48),
        Red = Color3.fromRGB(204, 52, 46),
        Orange = Color3.fromRGB(226, 122, 36),
        Gold = Color3.fromRGB(212, 160, 30),
        Purple = Color3.fromRGB(104, 62, 196),
        Knob = Color3.fromRGB(112, 112, 118)
    },
    RowTransparency = 0.22,

    Darker = function(p1, p2: number) -- Line: 55, Name: Darker
        return Color3.new(p1.R * p2, p1.G * p2, p1.B * p2);
    end,

    Lighter = function(p3, p4: number) -- Line: 58, Name: Lighter
        return p3:Lerp(Color3.new(1, 1, 1), p4);
    end,

    ReferenceSize = Vector2.new(1920, 1080),
    ScaleMin = 0.5,
    ScaleMax = 2.5,
    Scale = 1
};
local BindableEvent = Instance.new("BindableEvent");
u5.ScaleChanged = BindableEvent.Event;
local u6 = {};

local function measureScale() -- Line: 78
    -- upvalues: u5 (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.ViewportSize;
    end;

    if not (workspace_CurrentCamera and (workspace_CurrentCamera.X >= 2 and workspace_CurrentCamera.Y >= 2)) then
        return u5.Scale;
    end;

    local ReferenceSize = u5.ReferenceSize;
    local math_min_ret = math.min(workspace_CurrentCamera.X / ReferenceSize.X, workspace_CurrentCamera.Y / ReferenceSize.Y);

    return math.clamp(math_min_ret, u5.ScaleMin, u5.ScaleMax);
end;

local function refreshScale() -- Line: 87
    -- upvalues: u5 (copy), u6 (copy), BindableEvent (copy)
    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        workspace_CurrentCamera = workspace_CurrentCamera.ViewportSize;
    end;

    local v7;

    if workspace_CurrentCamera and (workspace_CurrentCamera.X >= 2 and workspace_CurrentCamera.Y >= 2) then
        local ReferenceSize = u5.ReferenceSize;
        local math_min_ret = math.min(workspace_CurrentCamera.X / ReferenceSize.X, workspace_CurrentCamera.Y / ReferenceSize.Y);
        v7 = math.clamp(math_min_ret, u5.ScaleMin, u5.ScaleMax);
    else
        v7 = u5.Scale;
    end;

    if math.abs(v7 - u5.Scale) < 0.0001 then
        return;
    end;

    u5.Scale = v7;

    for i in u6 do
        i.Scale = v7;
    end;

    BindableEvent:Fire(v7);
end;

if game:GetService("RunService"):IsClient() then
    local u8 = nil;

    local function watchCamera() -- Line: 100
        -- upvalues: u8 (ref), refreshScale (copy), u5 (copy), u6 (copy), BindableEvent (copy)
        if u8 then
            u8:Disconnect();
        end;

        local workspace_CurrentCamera = workspace.CurrentCamera;

        if workspace_CurrentCamera then
            u8 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshScale);
        end;

        local workspace_CurrentCamera2 = workspace.CurrentCamera;

        if workspace_CurrentCamera2 then
            workspace_CurrentCamera2 = workspace_CurrentCamera2.ViewportSize;
        end;

        local v9;

        if workspace_CurrentCamera2 and (workspace_CurrentCamera2.X >= 2 and workspace_CurrentCamera2.Y >= 2) then
            local ReferenceSize = u5.ReferenceSize;
            local math_min_ret = math.min(workspace_CurrentCamera2.X / ReferenceSize.X, workspace_CurrentCamera2.Y / ReferenceSize.Y);
            v9 = math.clamp(math_min_ret, u5.ScaleMin, u5.ScaleMax);
        else
            v9 = u5.Scale;
        end;

        if math.abs(v9 - u5.Scale) < 0.0001 then
            return;
        end;

        u5.Scale = v9;

        for i in u6 do
            i.Scale = v9;
        end;

        BindableEvent:Fire(v9);
    end;

    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCamera);

    if u8 then
        u8:Disconnect();
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;

    if workspace_CurrentCamera then
        u8 = workspace_CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshScale);
    end;

    local workspace_CurrentCamera2 = workspace.CurrentCamera;

    if workspace_CurrentCamera2 then
        workspace_CurrentCamera2 = workspace_CurrentCamera2.ViewportSize;
    end;

    local v10;

    if workspace_CurrentCamera2 and (workspace_CurrentCamera2.X >= 2 and workspace_CurrentCamera2.Y >= 2) then
        local ReferenceSize = u5.ReferenceSize;
        local math_min_ret = math.min(workspace_CurrentCamera2.X / ReferenceSize.X, workspace_CurrentCamera2.Y / ReferenceSize.Y);
        v10 = math.clamp(math_min_ret, u5.ScaleMin, u5.ScaleMax);
    else
        v10 = u5.Scale;
    end;

    if math.abs(v10 - u5.Scale) >= 0.0001 then
        u5.Scale = v10;

        for i in u6 do
            i.Scale = v10;
        end;

        BindableEvent:Fire(v10);
    end;
end;

function u5.EffectiveScale(p11: userdata?) -- Line: 115
    local v12 = 1;

    while p11 do
        local v13 = p11:FindFirstChildOfClass("UIScale");

        if v13 then
            v12 = v12 * v13.Scale;
        end;

        p11 = p11.Parent;
    end;

    return v12;
end;

local function child(p14: userdata, p15: string, p16: string) -- Line: 128
    local v17 = p14:FindFirstChild(p16);

    if not v17 then
        v17 = Instance.new(p15);
        v17.Name = p16;
        v17.Parent = p14;
    end;

    return v17;
end;

function u5.Scaled(p18: userdata) -- Line: 139
    -- upvalues: u5 (copy), u6 (copy)
    local StyleScale = p18:FindFirstChild("StyleScale");

    if not StyleScale then
        StyleScale = Instance.new("UIScale");
        StyleScale.Name = "StyleScale";
        StyleScale.Parent = p18;
    end;

    StyleScale.Scale = u5.Scale;

    if not u6[StyleScale] then
        u6[StyleScale] = true;
        StyleScale.Destroying:Connect(function() -- Line: 144
            -- upvalues: u6 (ref), StyleScale (copy)
            u6[StyleScale] = nil;
        end);
    end;

    return StyleScale;
end;

function u5.Dust(p19: userdata, p20, p21: number?) -- Line: 152
    -- upvalues: u5 (copy)
    local StyleDust = p19:FindFirstChild("StyleDust");

    if not StyleDust then
        StyleDust = Instance.new("ImageLabel");
        StyleDust.Name = "StyleDust";
        StyleDust.Parent = p19;
    end;

    StyleDust.BackgroundTransparency = 1;
    StyleDust.Size = UDim2.fromScale(1, 1);
    StyleDust.Image = u5.Images.Dust;
    StyleDust.ScaleType = Enum.ScaleType.Tile;
    StyleDust.TileSize = p20 or UDim2.fromScale(0.4, 1.2);
    StyleDust.ImageColor3 = Color3.fromRGB(17, 17, 17);
    StyleDust.ImageTransparency = p21 or 0.7;
    StyleDust.ZIndex = p19.ZIndex;

    return StyleDust;
end;

local function backdropShade(p22: userdata) -- Line: 167
    local StyleShade = p22:FindFirstChild("StyleShade");

    if StyleShade then
        StyleShade:Destroy();
    end;
end;

local Rect_new_ret = Rect.new(64, 40, 959, 682);

function u5.Backdrop(u23: userdata, p24: any) -- Line: 190
    -- upvalues: u5 (copy), Rect_new_ret (copy)
    local v25 = p24 or {};
    u23.BackgroundTransparency = 1;
    local u26 = v25.SliceScale or 0.55;
    local u27 = v25.Bleed or 16;
    local u28;

    if v25.Outside then
        u27 = math.ceil(64 * u26);
        u28 = math.ceil(40 * u26);

        if v25.Even then
            u27 = math.max(u27, u28);
            u28 = u27;
        end;
    else
        u28 = u27;
    end;

    local v29 = v25.Behind == true;
    local u30;

    if v29 then
        u30 = v25.Host or (u23.Parent or u23);
    else
        u30 = u23;
    end;

    local v31 = v29 and (u23.Name .. "StyleBackdrop" or "StyleBackdrop") or "StyleBackdrop";
    local u32 = u30:FindFirstChild(v31);

    if not u32 then
        u32 = Instance.new("ImageLabel");
        u32.Name = v31;
        u32.Parent = u30;
    end;

    u32.BackgroundTransparency = 1;
    u32.AnchorPoint = Vector2.new(0.5, 0.5);

    if v29 then
        local function follow() -- Line: 217
            -- upvalues: u30 (copy), u23 (copy), u32 (copy), u27 (ref), u28 (ref), u26 (copy)
            local v33 = u30;
            local v34 = 1;

            while v33 do
                local v35 = v33:FindFirstChildOfClass("UIScale");

                if v35 then
                    v34 = v34 * v35.Scale;
                end;

                v33 = v33.Parent;
            end;

            local v36 = u23;
            local v37 = 1;

            while v36 do
                local v38 = v36:FindFirstChildOfClass("UIScale");

                if v38 then
                    v37 = v37 * v38.Scale;
                end;

                v36 = v36.Parent;
            end;

            local v39 = v37 / v34;
            local v40 = u23.AbsoluteSize / v34;
            local v41 = (u23.AbsolutePosition - u30.AbsolutePosition) / v34;
            u32.Size = UDim2.fromOffset(v40.X + u27 * 2 * v39, v40.Y + u28 * 2 * v39);
            u32.Position = UDim2.fromOffset(v41.X + v40.X / 2, v41.Y + v40.Y / 2);
            u32.SliceScale = u26 * v39;
            u32.Visible = u23.Visible;
        end;

        follow();
        u23:GetPropertyChangedSignal("AbsoluteSize"):Connect(follow);
        u23:GetPropertyChangedSignal("AbsolutePosition"):Connect(follow);
        u23:GetPropertyChangedSignal("Visible"):Connect(follow);
    else
        u32.Position = UDim2.fromScale(0.5, 0.5);
        u32.Size = UDim2.new(1, u27 * 2, 1, u28 * 2);
    end;

    u32.Image = u5.Images.Backdrop;
    u32.ScaleType = Enum.ScaleType.Slice;
    u32.SliceCenter = Rect_new_ret;

    if not v29 then
        u32.SliceScale = u26;
    end;

    u32.ImageColor3 = v25.Colour or u5.Colours.Panel;
    u32.ImageTransparency = v25.Transparency or 0.3;
    u32.ZIndex = v29 and u23.ZIndex - 1 or 0;
    local v42 = v25.Shade ~= false and u32:FindFirstChild("StyleShade");

    if v42 then
        v42:Destroy();
    end;

    u5.Dust(u32, UDim2.fromScale(0.18, 0.23), 0.9);

    return u32;
end;

function u5.Strip(u43: userdata, p44: any) -- Line: 262
    -- upvalues: u5 (copy)
    local v45 = p44 or {};
    u43.BackgroundTransparency = 1;
    local u46 = v45.Behind == true;
    local u47;

    if u46 then
        u47 = u43.Parent or u43;
    else
        u47 = u43;
    end;

    local v48 = u46 and (u43.Name .. "StyleStrip" or "StyleStrip") or "StyleStrip";
    local u49 = u47:FindFirstChild(v48);

    if not u49 then
        u49 = Instance.new("ImageLabel");
        u49.Name = v48;
        u49.Parent = u47;
    end;

    u49.BackgroundTransparency = 1;
    u49.AnchorPoint = Vector2.new(0.5, 0.5);
    u49.Image = u5.Images.Strip;
    u49.ScaleType = Enum.ScaleType.Tile;
    u49.Rotation = 90;
    u49.ImageColor3 = v45.Colour or u5.Colours.Panel;
    u49.ImageTransparency = v45.Transparency or 0.25;
    u49.ZIndex = u46 and (u43.ZIndex - 1 or 0) or 0;
    local StyleShade = u49:FindFirstChild("StyleShade");

    if StyleShade then
        StyleShade:Destroy();
    end;

    u5.Dust(u49, UDim2.fromScale(1.1, 0.12), 0.75);
    local u50 = v45.Bleed or 8;
    local u51 = v45.BleedX or 10;

    local function layout() -- Line: 281
        -- upvalues: u47 (copy), u43 (copy), u51 (copy), u50 (copy), u49 (copy), u46 (copy)
        local v52 = u47;
        local v53 = 1;

        while v52 do
            local v54 = v52:FindFirstChildOfClass("UIScale");

            if v54 then
                v53 = v53 * v54.Scale;
            end;

            v52 = v52.Parent;
        end;

        local v55 = u43;
        local v56 = 1;

        while v55 do
            local v57 = v55:FindFirstChildOfClass("UIScale");

            if v57 then
                v56 = v56 * v57.Scale;
            end;

            v55 = v55.Parent;
        end;

        local v58 = v56 / v53;
        local v59 = u43.AbsoluteSize / v53;
        local v60 = v59.Y + u50 * 2 * v58;
        u49.Size = UDim2.fromOffset(v60, v59.X + u51 * 2 * v58);
        u49.TileSize = UDim2.fromOffset(v60 * 1.1, v60 * 4.2);

        if not u46 then
            u49.Position = UDim2.fromScale(0.5, 0.5);

            return;
        end;

        local v61 = (u43.AbsolutePosition - u47.AbsolutePosition) / v53;
        u49.Position = UDim2.fromOffset(v61.X + v59.X / 2, v61.Y + v59.Y / 2);
        u49.Visible = u43.Visible;
    end;

    layout();
    u43:GetPropertyChangedSignal("AbsoluteSize"):Connect(layout);

    if u46 then
        u43:GetPropertyChangedSignal("AbsolutePosition"):Connect(layout);
        u43:GetPropertyChangedSignal("Visible"):Connect(layout);
    end;

    return u49;
end;

function u5.Banner(u62: userdata, p63: any) -- Line: 315
    -- upvalues: u5 (copy)
    local v64 = p63 or {};
    u62.BackgroundTransparency = 1;
    local u65 = v64.Behind == true;
    local u66;

    if u65 then
        u66 = u62.Parent or u62;
    else
        u66 = u62;
    end;

    local v67 = u65 and (u62.Name .. "StyleBanner" or "StyleBanner") or "StyleBanner";
    local u68 = u66:FindFirstChild(v67);

    if not u68 then
        u68 = Instance.new("ImageLabel");
        u68.Name = v67;
        u68.Parent = u66;
    end;

    u68.BackgroundTransparency = 1;
    u68.AnchorPoint = Vector2.new(0.5, 0.5);
    u68.Image = u5.Images.Banner;
    u68.ImageRectOffset = Vector2.new(12, 62);
    u68.ImageRectSize = Vector2.new(906, 118);
    u68.ScaleType = Enum.ScaleType.Stretch;
    u68.ImageColor3 = v64.Colour or u5.Colours.Panel;
    u68.ImageTransparency = v64.Transparency or 0.2;
    u68.ZIndex = u65 and (u62.ZIndex - 1 or 0) or 0;
    u5.Dust(u68, UDim2.fromScale(0.12, 1), 0.8);
    local u69 = v64.Bleed or 10;
    local u70 = v64.BleedX or 22;

    local function v80() -- Line: 335
        -- upvalues: u66 (copy), u62 (copy), u68 (copy), u70 (copy), u69 (copy), u65 (copy)
        local v71 = u66;
        local v72 = 1;

        while v71 do
            local v73 = v71:FindFirstChildOfClass("UIScale");

            if v73 then
                v72 = v72 * v73.Scale;
            end;

            v71 = v71.Parent;
        end;

        local v74 = u62;
        local v75 = 1;

        while v74 do
            local v76 = v74:FindFirstChildOfClass("UIScale");

            if v76 then
                v75 = v75 * v76.Scale;
            end;

            v74 = v74.Parent;
        end;

        local v77 = v75 / v72;
        local v78 = u62.AbsoluteSize / v72;
        u68.Size = UDim2.fromOffset(v78.X + u70 * 2 * v77, v78.Y + u69 * 2 * v77);

        if not u65 then
            u68.Position = UDim2.fromScale(0.5, 0.5);

            return;
        end;

        local v79 = (u62.AbsolutePosition - u66.AbsolutePosition) / v72;
        u68.Position = UDim2.fromOffset(v79.X + v78.X / 2, v79.Y + v78.Y / 2);
        u68.Visible = u62.Visible;
    end;

    v80();
    u62:GetPropertyChangedSignal("AbsoluteSize"):Connect(v80);

    if u65 then
        u62:GetPropertyChangedSignal("AbsolutePosition"):Connect(v80);
        u62:GetPropertyChangedSignal("Visible"):Connect(v80);
    end;

    return u68;
end;

function u5.Round(p81: userdata, p82: number?) -- Line: 359
    local StyleCorner = p81:FindFirstChild("StyleCorner");

    if not StyleCorner then
        StyleCorner = Instance.new("UICorner");
        StyleCorner.Name = "StyleCorner";
        StyleCorner.Parent = p81;
    end;

    StyleCorner.CornerRadius = UDim.new(0, p82 or 3);
end;

function u5.Fill(p83: userdata, p84, p85: any) -- Line: 371
    -- upvalues: u5 (copy)
    local v86 = type(p85) == "table" and p85 and p85 or {};
    p83.BackgroundColor3 = p84;
    p83.BackgroundTransparency = v86.Transparency or 0;
    p83.BorderSizePixel = 0;
    local StyleEdge = p83:FindFirstChild("StyleEdge");

    if not StyleEdge then
        StyleEdge = Instance.new("UIStroke");
        StyleEdge.Name = "StyleEdge";
        StyleEdge.Parent = p83;
    end;

    StyleEdge.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    StyleEdge.Color = v86.Rim or u5.Lighter(p84, 0.38);
    StyleEdge.Thickness = v86.RimThickness or 2;
    StyleEdge.Transparency = v86.RimTransparency or 0.15;
    local StyleShade = p83:FindFirstChild("StyleShade");

    if not StyleShade then
        StyleShade = Instance.new("UIGradient");
        StyleShade.Name = "StyleShade";
        StyleShade.Parent = p83;
    end;

    StyleShade.Rotation = 90;
    StyleShade.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.55, Color3.fromRGB(226, 226, 226)), ColorSequenceKeypoint.new(1, Color3.fromRGB(176, 176, 176)) });
    local Corner = v86.Corner;
    local StyleCorner = p83:FindFirstChild("StyleCorner");

    if not StyleCorner then
        StyleCorner = Instance.new("UICorner");
        StyleCorner.Name = "StyleCorner";
        StyleCorner.Parent = p83;
    end;

    StyleCorner.CornerRadius = UDim.new(0, Corner or 3);
end;

function u5.FitText(p87: userdata, p88: number, p89: number?, p90: number?, p91: number?) -- Line: 396
    p87.TextScaled = true;
    p87.TextWrapped = false;
    local StyleFit = p87:FindFirstChild("StyleFit");

    if not StyleFit then
        StyleFit = Instance.new("UITextSizeConstraint");
        StyleFit.Name = "StyleFit";
        StyleFit.Parent = p87;
    end;

    StyleFit.MaxTextSize = math.floor(p88);
    StyleFit.MinTextSize = p91 or 7;
    local v92 = p89 and UDim.new(0, p89) or UDim.new(0.05, 2);
    local StylePad = p87:FindFirstChild("StylePad");

    if not StylePad then
        StylePad = Instance.new("UIPadding");
        StylePad.Name = "StylePad";
        StylePad.Parent = p87;
    end;

    StylePad.PaddingLeft = v92;
    StylePad.PaddingRight = v92;
    local UDim_new_ret = UDim.new(0, p90 or 4);
    local UDim_new_ret2 = UDim.new(0, p90 or 4);
    StylePad.PaddingTop = UDim_new_ret;
    StylePad.PaddingBottom = UDim_new_ret2;
end;

function u5.TextEdge(p93: userdata, p94: number?) -- Line: 412
    local StyleTextEdge = p93:FindFirstChild("StyleTextEdge");

    if not StyleTextEdge then
        StyleTextEdge = Instance.new("UIStroke");
        StyleTextEdge.Name = "StyleTextEdge";
        StyleTextEdge.Parent = p93;
    end;

    StyleTextEdge.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual;
    StyleTextEdge.Color = Color3.new(0, 0, 0);
    StyleTextEdge.Thickness = 1;
    StyleTextEdge.Transparency = p94 or 0.5;
end;

function u5.Button(p95: userdata, p96, p97: number?, p98: any) -- Line: 421
    -- upvalues: u5 (copy)
    u5.Fill(p95, p96, p98);
    p95.FontFace = u5.Fonts.Bold;
    p95.TextSize = p97 or 14;
    p95.TextColor3 = u5.Colours.Text;
    p95.AutoButtonColor = true;
    p95.Text = string.upper(p95.Text);
    u5.FitText(p95, p97 or 14, nil, 5);
    u5.TextEdge(p95);
    u5.Dust(p95, UDim2.fromScale(0.4, 1.2), 0.88);
end;

function u5.SoftButton(p99: userdata, p100: number?) -- Line: 434
    -- upvalues: u5 (copy)
    u5.Button(p99, Color3.fromRGB(88, 90, 96), p100, {
        Transparency = 0.3,
        RimTransparency = 0.45,
        RimThickness = 1.5,
        Rim = Color3.fromRGB(150, 152, 158)
    });
end;

u5.Images.Glow = "rbxassetid://6288018083";

function u5.Glow(u101: userdata, p102, p103: number?, p104: userdata?, u105: userdata?) -- Line: 444
    -- upvalues: u5 (copy)
    local u106 = p104 or u101.Parent;
    local v107 = u101.Name .. "StyleGlow";
    local u108 = u106:FindFirstChild(v107);

    if not u108 then
        u108 = Instance.new("ImageLabel");
        u108.Name = v107;
        u108.Parent = u106;
    end;

    u108.BackgroundTransparency = 1;
    u108.AnchorPoint = Vector2.new(0.5, 0.5);
    u108.Image = u5.Images.Glow;
    u108.ScaleType = Enum.ScaleType.Stretch;
    u108.ImageColor3 = p102;
    u108.ImageTransparency = 1 - (p103 or 0.45);
    u108.ZIndex = u101.ZIndex - 1;

    local function v118() -- Line: 456
        -- upvalues: u101 (copy), u106 (copy), u108 (copy), u105 (copy)
        local AbsoluteSize = u101.AbsoluteSize;
        local v109 = u101.AbsolutePosition - u106.AbsolutePosition;
        local UDim2_fromOffset = UDim2.fromOffset;
        local X = AbsoluteSize.X;
        local v110 = u101;
        local v111 = 1;

        while v110 do
            local v112 = v110:FindFirstChildOfClass("UIScale");

            if v112 then
                v111 = v111 * v112.Scale;
            end;

            v110 = v110.Parent;
        end;

        local v113 = u106;
        local v114 = 1;

        while v113 do
            local v115 = v113:FindFirstChildOfClass("UIScale");

            if v115 then
                v114 = v114 * v115.Scale;
            end;

            v113 = v113.Parent;
        end;

        u108.Size = UDim2_fromOffset(X + v111 * 44 / v114, AbsoluteSize.Y * 2.2);
        u108.Position = UDim2.fromOffset(v109.X + AbsoluteSize.X / 2, v109.Y + AbsoluteSize.Y / 2);
        local Visible = u101.Visible;

        if Visible and u105 then
            local v116 = u101.AbsolutePosition + AbsoluteSize / 2;
            local AbsolutePosition = u105.AbsolutePosition;
            local v117 = u105.AbsolutePosition + u105.AbsoluteSize;

            if v116.X >= AbsolutePosition.X and (v116.Y >= AbsolutePosition.Y and v116.X <= v117.X) then
                Visible = v116.Y <= v117.Y;
            else
                Visible = false;
            end;
        end;

        u108.Visible = Visible;
    end;

    v118();

    if u105 then
        u105:GetPropertyChangedSignal("AbsoluteSize"):Connect(v118);
        u105:GetPropertyChangedSignal("AbsolutePosition"):Connect(v118);
    end;

    u101:GetPropertyChangedSignal("AbsoluteSize"):Connect(v118);
    u101:GetPropertyChangedSignal("AbsolutePosition"):Connect(v118);
    u101:GetPropertyChangedSignal("Visible"):Connect(v118);

    return u108;
end;

function u5.Row(p119: userdata) -- Line: 482
    -- upvalues: u5 (copy)
    u5.Fill(p119, u5.Colours.Row, {
        RimTransparency = 0.35,
        RimThickness = 1,
        Corner = 3,
        Transparency = u5.RowTransparency,
        Rim = Color3.fromRGB(16, 16, 18)
    });
end;

function u5.Inset(p120: userdata) -- Line: 488
    -- upvalues: u5 (copy)
    u5.Fill(p120, u5.Colours.Field, {
        Transparency = 0.15,
        RimTransparency = 0.2,
        RimThickness = 1,
        Corner = 3,
        Rim = Color3.fromRGB(12, 12, 13)
    });
end;

function u5.Chip(p121: userdata, p122, p123: number?) -- Line: 494
    -- upvalues: u5 (copy)
    u5.Fill(p121, p122, {
        RimThickness = 1,
        RimTransparency = 0.1,
        Corner = 2
    });
    p121.FontFace = u5.Fonts.Bold;
    p121.TextSize = p123 or 11;
    p121.TextColor3 = u5.Colours.Text;
    u5.FitText(p121, p123 or 11, 8, 3);
    u5.TextEdge(p121, 0.55);
end;

function u5.Panel(p124: userdata) -- Line: 505
    -- upvalues: u5 (copy)
    u5.Backdrop(p124);
end;

return u5;
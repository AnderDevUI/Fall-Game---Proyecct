-- [PATH] ReplicatedStorage / MapRender / MapRenderClient @Type ModuleScript


local EncodingService = game:GetService("EncodingService");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AssetService = game:GetService("AssetService");
local MapRender = ReplicatedStorage:WaitForChild("MapRender");
local MapImageCodec = require(MapRender:WaitForChild("MapImageCodec"));
local u1 = {
    DecodeBudget = 0.004,
    PageSize = 1024,
    Header = nil,
    Id = nil,
    Pages = {},
    Scale = 1,
    TilesDrawn = 0,
    Complete = false,
    Labels = {},
    LabelsVisible = true,
    Info = nil,
    Teammates = {},
    TierColours = {
        [0] = Color3.fromRGB(236, 236, 236),
        [1] = Color3.fromRGB(255, 214, 64),
        [2] = Color3.fromRGB(184, 112, 255),
        [3] = Color3.fromRGB(255, 122, 196),
        [4] = Color3.fromRGB(255, 72, 72),
        [5] = Color3.fromRGB(24, 24, 24)
    },
    LabelColours = {
        None = Color3.fromRGB(236, 236, 236),
        Yellow = Color3.fromRGB(255, 214, 64),
        Purple = Color3.fromRGB(184, 112, 255),
        Pink = Color3.fromRGB(255, 122, 196),
        Green = Color3.fromRGB(96, 226, 116),
        Red = Color3.fromRGB(255, 72, 72),
        Black = Color3.fromRGB(24, 24, 24)
    },
    UseLabelColours = false,
    LabelStyle = {
        StrokeTransparency = 0,
        TextSize = 31,
        MinTextSize = 16,
        Width = 265,
        Height = 69,
        Font = Font.new("rbxasset://fonts/families/Kalam.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        Colour = Color3.fromRGB(255, 241, 213),
        StrokeColour = Color3.new(0, 0, 0)
    }
};
local BindableEvent = Instance.new("BindableEvent");
local BindableEvent2 = Instance.new("BindableEvent");
local BindableEvent3 = Instance.new("BindableEvent");
local BindableEvent4 = Instance.new("BindableEvent");
u1.Started = BindableEvent.Event;
u1.TileDrawn = BindableEvent2.Event;
u1.Finished = BindableEvent3.Event;
u1.InfoChanged = BindableEvent4.Event;
local u2 = {};
local u3 = 1;
local u4 = false;
local u5 = {};
local buffer_readu8 = buffer.readu8;
local buffer_writeu8 = buffer.writeu8;

local function destroyPages() -- Line: 106
    -- upvalues: u1 (copy)
    for _, v in u1.Pages do
        v.Image:Destroy();
    end;

    u1.Pages = {};
end;

local function allocate(p6) -- Line: 113
    -- upvalues: destroyPages (copy), u1 (copy), AssetService (copy), u3 (ref)
    destroyPages();
    local u7 = 1;

    while true do
        local v8 = 0;

        while true do
            if v8 == 0 then
                v8 = -1;

                if u7 > 8 then
                    return false;
                end;

                local v9 = u1.PageSize * u7;
                local math_ceil_ret = math.ceil(p6.Width / v9);
                local v10 = {};
                local v11 = true;

                for i = 0, math.ceil(p6.Height / v9) - 1 do
                    local v12 = i;

                    for i2 = 0, math_ceil_ret - 1 do
                        local v13 = i2 * v9;
                        local v14 = v12 * v9;
                        local math_min_ret = math.min(v9, p6.Width - v13);
                        local math_min_ret2 = math.min(v9, p6.Height - v14);
                        local success, result = pcall(function() -- Line: 125
                            -- upvalues: AssetService (ref), math_min_ret (copy), u7 (ref), math_min_ret2 (copy)
                            return AssetService:CreateEditableImage({
                                Size = Vector2.new(math.ceil(math_min_ret / u7), (math.ceil(math_min_ret2 / u7)))
                            });
                        end);

                        if not (success and result) then
                            v11 = false;
                            break;
                        end;

                        v10[#v10 + 1] = {
                            Image = result,
                            Content = Content.fromObject(result),
                            X0 = v13,
                            Y0 = v14,
                            W = math_min_ret,
                            H = math_min_ret2
                        };
                        local _ = i2;
                    end;

                    if not v11 then
                        if v11 then
                            u1.Pages = v10;
                            u1.Scale = u7;
                            u3 = math_ceil_ret;

                            return true;
                        end;

                        for i2, v in v10 do
                            v.Image:Destroy();
                        end;

                        u7 = u7 * 2;
                        v8 = 0;
                        break;
                    end;
                end;

                if v8 ~= 0 then
                    continue;
                end;

                if v11 then
                    u1.Pages = v10;
                    u1.Scale = u7;
                    u3 = math_ceil_ret;

                    return true;
                end;

                for i2, v in v10 do
                    v.Image:Destroy();
                end;

                u7 = u7 * 2;
                break;
            else
                break;
            end;
        end;
    end;
end;

local function shrink(p15, p16, p17, p18) -- Line: 152
    -- upvalues: buffer_readu8 (copy), buffer_writeu8 (copy)
    local math_max_ret = math.max(1, p16 // p18);
    local math_max_ret2 = math.max(1, p17 // p18);
    local buffer_create_ret = buffer.create(math_max_ret * math_max_ret2 * 4);
    local v19 = p18 * p18;

    for i = 0, math_max_ret2 - 1 do
        local v20 = i;

        for i2 = 0, math_max_ret - 1 do
            local v21 = i2;
            local v22 = 0;
            local v23 = 0;
            local v24 = 0;

            for i3 = v20 * p18, v20 * p18 + p18 - 1 do
                local v25 = (i3 * p16 + v21 * p18) * 4;
                local _ = i3;

                for i4 = 1, p18 do
                    v22 = v22 + buffer_readu8(p15, v25);
                    v23 = v23 + buffer_readu8(p15, v25 + 1);
                    v24 = v24 + buffer_readu8(p15, v25 + 2);
                    v25 = v25 + 4;
                    local _ = i4;
                end;
            end;

            local v26 = (v20 * math_max_ret + v21) * 4;
            buffer_writeu8(buffer_create_ret, v26, v22 // v19);
            buffer_writeu8(buffer_create_ret, v26 + 1, v23 // v19);
            buffer_writeu8(buffer_create_ret, v26 + 2, v24 // v19);
            buffer_writeu8(buffer_create_ret, v26 + 3, 255);
        end;
    end;

    return buffer_create_ret, math_max_ret, math_max_ret2;
end;

local function drawTile(p27, p28) -- Line: 178
    -- upvalues: u1 (copy), MapImageCodec (copy), EncodingService (copy), u3 (ref), shrink (copy)
    local Header = u1.Header;
    local v29, v30, v31, v32 = MapImageCodec.TileRect(Header, p27);
    local v33 = EncodingService:DecompressBuffer(p28, Enum.CompressionAlgorithm.Zstd);
    local v34 = MapImageCodec.DecodeTile(v33, v31, v32, Header);
    local Scale = u1.Scale;
    local v35 = u1.PageSize * Scale;
    local v36 = u1.Pages[v30 // v35 * u3 + v29 // v35 + 1];

    if Scale > 1 then
        v34, v31, v32 = shrink(v34, v31, v32, Scale);
    end;

    v36.Image:WritePixelsBuffer(Vector2.new((v29 - v36.X0) // Scale, (v30 - v36.Y0) // Scale), Vector2.new(v31, v32), v34);
end;

local u37 = {};
local u38 = {};
local u39 = {};

function u1.RestoreTile(p40: number) -- Line: 202
    -- upvalues: u37 (copy), u1 (copy), drawTile (copy)
    local v41 = u37[p40];

    if not (v41 and u1.Header) then
        return false;
    end;

    drawTile(p40, v41);

    return true;
end;

function u1.TileOriginal(p42: number) -- Line: 214
    -- upvalues: u38 (copy), u37 (copy), u1 (copy), MapImageCodec (copy), EncodingService (copy), shrink (copy), u39 (copy)
    local v43 = u38[p42];

    if v43 then
        return v43[1], v43[2], v43[3], v43[4], v43[5];
    end;

    local v44 = u37[p42];
    local Header = u1.Header;

    if not (v44 and Header) then
        return nil;
    end;

    local v45, v46, v47, v48 = MapImageCodec.TileRect(Header, p42);
    local v49 = EncodingService:DecompressBuffer(v44, Enum.CompressionAlgorithm.Zstd);
    local v50 = MapImageCodec.DecodeTile(v49, v47, v48, Header);
    local Scale = u1.Scale;

    if Scale > 1 then
        v50, v47, v48 = shrink(v50, v47, v48, Scale);
    end;

    u38[p42] = {
        v50,
        v47,
        v48,
        v45 // Scale,
        v46 // Scale
    };
    u39[#u39 + 1] = p42;

    if #u39 > 24 then
        u38[table.remove(u39, 1)] = nil;
    end;

    return v50, v47, v48, v45 // Scale, v46 // Scale;
end;

local function drain() -- Line: 241
    -- upvalues: u2 (copy), u1 (copy), drawTile (copy), BindableEvent2 (copy), BindableEvent3 (copy)
    if #u2 == 0 then
        return;
    end;

    local v51 = os.clock() + u1.DecodeBudget;

    while true do
        local table_remove_ret = table.remove(u2, 1);
        local success, result = pcall(drawTile, table_remove_ret[1], table_remove_ret[2]);

        if not success then
            warn("[MapRenderClient] tile " .. table_remove_ret[1] .. " failed: " .. tostring(result));
        end;

        local v52 = u1;
        v52.TilesDrawn = v52.TilesDrawn + 1;
        local v53 = u1.Header.TilesX * u1.Header.TilesY;
        BindableEvent2:Fire(table_remove_ret[1], u1.TilesDrawn, v53);

        if v53 <= u1.TilesDrawn then
            u1.Complete = true;
            BindableEvent3:Fire();
        end;

        if #u2 == 0 or v51 < os.clock() then
            return;
        end;
    end;
end;

local function clearMade(p54, p55) -- Line: 262
    for _, child in p54:GetChildren() do
        if child ~= p55 and child:GetAttribute("MapRenderMade") then
            child:Destroy();
        end;
    end;
end;

local function declutter(p56: userdata) -- Line: 292
    local X = p56.AbsoluteSize.X;
    local Y = p56.AbsoluteSize.Y;

    if X <= 0 or Y <= 0 then
        return false;
    end;

    local workspace_CurrentCamera = workspace.CurrentCamera;
    local v57 = workspace_CurrentCamera and (Y / math.max(workspace_CurrentCamera.ViewportSize.Y, 1) or 1.5) or 1.5;
    local math_sqrt_ret = math.sqrt(v57 / 1.5);
    local math_clamp_ret = math.clamp(math_sqrt_ret, 0.55, 1);
    local v58 = false;

    for _, child in p56:GetChildren() do
        local v59 = child:IsA("TextLabel") and child:GetAttribute("MapRenderMade") and child:FindFirstChildOfClass("UITextSizeConstraint");

        if v59 then
            local Attribute = child:GetAttribute("LabelMaxText");

            if not Attribute then
                Attribute = v59.MaxTextSize;
                child:SetAttribute("LabelMaxText", Attribute);
            end;

            local math_floor_ret = math.floor(Attribute * math_clamp_ret + 0.5);
            local math_max_ret = math.max(1, math_floor_ret);

            if v59.MaxTextSize ~= math_max_ret then
                v59.MaxTextSize = math_max_ret;
                v58 = true;
            end;
        end;
    end;

    local v60 = {};

    for _, child in p56:GetChildren() do
        if child:IsA("TextLabel") and (child:GetAttribute("MapRenderMade") and child.Visible) then
            local Attribute = child:GetAttribute("LabelU");
            local Attribute2 = child:GetAttribute("LabelV");

            if Attribute and Attribute2 then
                local v61 = child:GetAttribute("LabelOX") or 0;
                local v62 = child:GetAttribute("LabelOY") or 0;
                local AbsoluteSize = child.AbsoluteSize;
                local TextBounds = child.TextBounds;
                local math_min_ret = math.min(AbsoluteSize.X, TextBounds.X);
                local math_min_ret2 = math.min(AbsoluteSize.Y, TextBounds.Y);
                v60[#v60 + 1] = {
                    D = 0,
                    T = child,
                    U = Attribute,
                    V = Attribute2,
                    OX = v61,
                    OY = v62,
                    X = Attribute * X + v61,
                    Home = Attribute2 * Y + v62,
                    W = math_min_ret + 4,
                    H = math_min_ret2 + 2,
                    Max = math_min_ret2 * 0.75
                };
            end;
        end;
    end;

    for i = 1, 30 do
        local _ = i;
        local v63 = {};

        for i2 = 1, #v60 do
            local v64 = v60[i2];
            local _ = i2;

            for i3 = i2 + 1, #v60 do
                local v65 = v60[i3];
                local v66;

                if (v64.W + v65.W) / 2 > math.abs(v64.X - v65.X) then
                    local v67 = v64.Home + v64.D;
                    local v68 = v65.Home + v65.D;
                    local v69 = (v64.H + v65.H) / 2 - math.abs(v67 - v68);

                    if v69 > 0.5 then
                        local v70;

                        if v67 == v68 then
                            v70 = v64.X <= v65.X and -1 or 1;
                        else
                            v70 = v67 < v68 and -1 or 1;
                        end;

                        v63[v64] = (v63[v64] or 0) + v70 * v69 / 2;
                        v63[v65] = (v63[v65] or 0) - v70 * v69 / 2;
                        v66 = i3;
                    else
                        v66 = i3;
                    end;
                else
                    v66 = i3;
                end;
            end;
        end;

        local v71 = false;

        for i2, v in v63 do
            local math_clamp_ret2 = math.clamp(i2.D + v * 0.5, -i2.Max, i2.Max);
            v71 = math.abs(math_clamp_ret2 - i2.D) > 0.05 and true or v71;
            i2.D = math_clamp_ret2;
        end;

        if not v71 then
            break;
        end;
    end;

    for _, v in v60 do
        v.T.Position = UDim2.new(v.U, v.OX, v.V, v.OY + math.floor(v.D + 0.5));
    end;

    return v58;
end;

local u72 = setmetatable({}, {
    __mode = "k"
});

local function watchLabels(u73: userdata) -- Line: 371
    -- upvalues: u72 (copy), declutter (copy)
    local u74 = u72[u73];

    if not u74 then
        u74 = {
            Queued = false
        };
        u72[u73] = u74;

        function u74.Queue() -- Line: 376
            -- upvalues: u74 (ref), u73 (copy), declutter (ref)
            if u74.Queued then
                return;
            end;

            u74.Queued = true;
            task.defer(function() -- Line: 381
                -- upvalues: u74 (ref), u73 (ref), declutter (ref)
                u74.Queued = false;

                if u73.Parent and declutter(u73) then
                    task.delay(0.05, u74.Queue);
                end;
            end);
        end;

        u73:GetPropertyChangedSignal("AbsoluteSize"):Connect(u74.Queue);
    end;

    u74.Queue();
    task.delay(0.25, u74.Queue);
end;

local function layout(p75) -- Line: 396
    -- upvalues: u5 (copy), clearMade (copy), u1 (copy), MapImageCodec (copy), watchLabels (copy)
    local v76 = u5[p75] or {};
    local PageTemplate = v76.PageTemplate;

    if PageTemplate then
        clearMade(p75, PageTemplate);
    else
        p75:ClearAllChildren();
    end;

    local Header = u1.Header;

    if not Header then
        return;
    end;

    for i, v in u1.Pages do
        local v77;

        if PageTemplate then
            v77 = PageTemplate:Clone();
            v77.Visible = true;
        else
            v77 = Instance.new("ImageLabel");
            v77.BackgroundTransparency = 1;
            v77.BorderSizePixel = 0;
        end;

        v77.Name = "Page" .. i;
        v77:SetAttribute("MapRenderMade", true);
        v77.Position = UDim2.fromScale(v.X0 / Header.Width, v.Y0 / Header.Height);
        v77.Size = UDim2.fromScale(v.W / Header.Width, v.H / Header.Height);
        v77.ImageContent = v.Content;
        v77.Parent = p75;
    end;

    local LabelTemplate = v76.LabelTemplate;

    if LabelTemplate and v76.Labels then
        local Labels = v76.Labels;
        clearMade(Labels, LabelTemplate);
        Labels.Visible = u1.LabelsVisible;

        for _, v in u1.Labels do
            local v78, v79 = MapImageCodec.WorldToUV(Header, v.X, v.Z);
            local v80 = LabelTemplate:Clone();
            v80.Name = v.Name;
            v80:SetAttribute("MapRenderMade", true);
            v80.Position = UDim2.fromScale(v78, v79) + LabelTemplate.Position;
            v80:SetAttribute("LabelU", v78);
            v80:SetAttribute("LabelV", v79);
            v80:SetAttribute("LabelOX", LabelTemplate.Position.X.Offset);
            v80:SetAttribute("LabelOY", LabelTemplate.Position.Y.Offset);
            local Attribute = LabelTemplate:GetAttribute("WrapAfter");

            if Attribute and Attribute < #v.Name then
                local Size = LabelTemplate.Size;
                v80.Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale * 2, Size.Y.Offset * 2);
            end;

            v80.Text = v.Name;
            v80.Visible = true;
            v80.Parent = Labels;
        end;

        watchLabels(Labels);

        return;
    end;

    local v81 = v76.Labels or p75;
    local Labels = v81:FindFirstChild("Labels");

    if Labels then
        Labels:Destroy();
    end;

    local Frame = Instance.new("Frame");
    Frame.Name = "Labels";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.ZIndex = 3;
    Frame.Visible = u1.LabelsVisible;
    Frame.Parent = v81;
    local TierColours = u1.TierColours;
    local LabelStyle = u1.LabelStyle;

    for _, v in u1.Labels do
        local v82, v83 = MapImageCodec.WorldToUV(Header, v.X, v.Z);
        local Colour = LabelStyle.Colour;

        if u1.UseLabelColours then
            Colour = v.Colour and u1.LabelColours[v.Colour] or (TierColours[v.Tier] or TierColours[0]);
        end;

        local TextLabel = Instance.new("TextLabel");
        TextLabel.Name = v.Name;
        TextLabel:SetAttribute("MapRenderMade", true);
        TextLabel:SetAttribute("LabelU", v82);
        TextLabel:SetAttribute("LabelV", v83);
        TextLabel.AnchorPoint = Vector2.new(0.5, 0.5);
        TextLabel.Position = UDim2.fromScale(v82, v83);
        TextLabel.Size = UDim2.fromOffset(LabelStyle.Width, LabelStyle.Height);
        TextLabel.BackgroundTransparency = 1;
        TextLabel.FontFace = LabelStyle.Font;
        TextLabel.LineHeight = 1;
        TextLabel.TextSize = LabelStyle.TextSize;
        TextLabel.TextScaled = true;
        TextLabel.TextWrapped = true;
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center;
        TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
        TextLabel.Text = v.Name;
        TextLabel.TextColor3 = Colour;
        TextLabel.TextStrokeColor3 = LabelStyle.StrokeColour;
        TextLabel.TextStrokeTransparency = LabelStyle.StrokeTransparency;
        TextLabel.ZIndex = 4;
        local UITextSizeConstraint = Instance.new("UITextSizeConstraint");
        UITextSizeConstraint.MaxTextSize = LabelStyle.TextSize;
        UITextSizeConstraint.MinTextSize = LabelStyle.MinTextSize;
        UITextSizeConstraint.Parent = TextLabel;
        TextLabel.Parent = Frame;
    end;

    watchLabels(Frame);
end;

function u1.SetLabelsVisible(p84: boolean) -- Line: 511
    -- upvalues: u1 (copy), u5 (copy)
    u1.LabelsVisible = p84;

    for i, v in u5 do
        local v85;

        if v and v.LabelTemplate then
            v85 = v.Labels;
        else
            local v86;

            if v then
                v86 = v.Labels or i;
            else
                v86 = i;
            end;

            v85 = v86:FindFirstChild("Labels");
        end;

        if v85 then
            v85.Visible = p84;
        end;
    end;
end;

function u1.CornerColour() -- Line: 524
    -- upvalues: u1 (copy), buffer_readu8 (copy)
    local u87 = u1.Pages[1];

    if not u87 or u1.TilesDrawn == 0 then
        return nil;
    end;

    local Size = u87.Image.Size;
    local math_min_ret = math.min(16, Size.X, Size.Y);
    local success, result = pcall(function() -- Line: 531
        -- upvalues: u87 (copy), math_min_ret (copy)
        return u87.Image:ReadPixelsBuffer(Vector2.new(0, 0), Vector2.new(math_min_ret, math_min_ret));
    end);

    if not success then
        return nil;
    end;

    local v88 = math_min_ret * math_min_ret;
    local v89 = 0;
    local v90 = 0;
    local v91 = 0;

    for i = 0, v88 - 1 do
        if buffer_readu8(result, i * 4 + 3) == 0 then
            return nil;
        end;

        v89 = v89 + buffer_readu8(result, i * 4);
        v90 = v90 + buffer_readu8(result, i * 4 + 1);
        v91 = v91 + buffer_readu8(result, i * 4 + 2);
        local _ = i;
    end;

    return Color3.fromRGB(math.floor(v89 / v88 + 0.5), math.floor(v90 / v88 + 0.5), (math.floor(v91 / v88 + 0.5)));
end;

function u1.Build(p92, p93) -- Line: 552
    -- upvalues: u1 (copy)
    local Frame = Instance.new("Frame");
    Frame.Name = "MapRender";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.fromScale(1, 1);
    Frame.ClipsDescendants = true;
    u1.Attach(Frame, p93);
    Frame.Parent = p92;

    return Frame;
end;

function u1.Attach(u94, p95) -- Line: 569
    -- upvalues: u5 (copy), layout (copy)
    if u5[u94] then
        return u94;
    end;

    u5[u94] = p95 or {};
    layout(u94);
    u94.Destroying:Connect(function() -- Line: 575
        -- upvalues: u5 (ref), u94 (copy)
        u5[u94] = nil;
    end);

    return u94;
end;

function u1.WorldToUV(p96) -- Line: 583
    -- upvalues: u1 (copy), MapImageCodec (copy)
    local Header = u1.Header;

    if not Header then
        return nil;
    end;

    local v97, v98 = MapImageCodec.WorldToUV(Header, p96.X, p96.Z);

    return Vector2.new(v97, v98);
end;

function u1.Receive(p99, p100, p101, p102) -- Line: 595
    -- upvalues: u1 (copy), u2 (copy), u37 (copy), u38 (copy), u39 (copy), allocate (copy), u5 (copy), layout (copy), BindableEvent (copy), BindableEvent4 (copy)
    if p99 ~= "Header" then
        if p99 == "Labels" then
            if p100 == u1.Id and (u1.Header and type(p101) == "table") then
                u1.Labels = p101;

                for i in u5 do
                    layout(i);
                end;

                return;
            end;
        elseif p99 == "Info" then
            if p100 == u1.Id and (u1.Header and type(p101) == "table") then
                u1.Info = p101;
                BindableEvent4:Fire(p101);

                return;
            end;
        elseif p99 == "Tile" and (p100 == u1.Id and u1.Header) then
            u2[#u2 + 1] = { p101, p102 };
            u37[p101] = p102;
        end;

        return;
    end;

    u1.Id = p100;
    u1.Header = p101;
    u1.TilesDrawn = 0;
    u1.Complete = false;
    u1.Labels = {};
    u1.Info = nil;
    table.clear(u2);
    table.clear(u37);
    table.clear(u38);
    table.clear(u39);

    if allocate(p101) then
        for i in u5 do
            layout(i);
        end;

        BindableEvent:Fire(p101);

        return;
    end;

    warn("[MapRenderClient] no EditableImage memory for the map, even at 1/8 resolution");
    u1.Header = nil;
end;

local u103 = nil;

function u1.Run() -- Line: 639
    -- upvalues: u103 (ref), RunService (copy), drain (copy)
    if not u103 then
        u103 = RunService.Heartbeat:Connect(drain);
    end;
end;

local u104 = false;

function u1.Want() -- Line: 648
    -- upvalues: u104 (ref), u1 (copy), ReplicatedStorage (copy)
    if u104 or u1.Complete then
        return;
    end;

    local MapRemotes = ReplicatedStorage:FindFirstChild("MapRemotes");

    if MapRemotes then
        MapRemotes = MapRemotes:FindFirstChild("RenderWanted");
    end;

    if MapRemotes then
        u104 = true;
        MapRemotes:FireServer();
    end;
end;

function u1.Start() -- Line: 660
    -- upvalues: u4 (ref), ReplicatedStorage (copy), u1 (copy)
    if u4 then
        return;
    end;

    u4 = true;
    ReplicatedStorage:WaitForChild("ClientSignals"):WaitForChild("MapRender").OnClientEvent:Connect(u1.Receive);
    u1.Run();
end;

return u1;
-- [PATH] ReplicatedStorage / MapRender / SeedLab @Type ModuleScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local AssetService = game:GetService("AssetService");
local script_Parent = script.Parent;
local MapUIStyle = require(script_Parent:WaitForChild("MapUIStyle"));
local math_clamp = math.clamp;
local math_floor = math.floor;
local Colours = MapUIStyle.Colours;
local u1 = {
    Dark = Colours.Field,
    Field = Colours.Grey,
    Line = Colours.Edge,
    Accent = Colours.Blue,
    Text = Colours.Text,
    Muted = Colours.Muted,
    Danger = Colours.Red,
    Go = Colours.Green,
    Warn = Color3.fromRGB(240, 178, 40),
    Moved = Color3.fromRGB(255, 214, 64),
    Bold = MapUIStyle.Fonts.Bold,
    Medium = MapUIStyle.Fonts.SemiBold,
    Heavy = MapUIStyle.Fonts.Heavy,
    Road = Color3.fromRGB(46, 46, 50),
    Dirt = Color3.fromRGB(150, 116, 74),
    River = Color3.fromRGB(72, 150, 224)
};
local u2 = { {
        Key = "MapSize",
        Name = "Map size"
    }, {
        Key = "IslandScale",
        Name = "Island size"
    }, {
        Key = "Template",
        Name = "Island template"
    }, {
        Key = "Satellites",
        Name = "Satellite islands"
    }, {
        Key = "Icebergs",
        Name = "Icebergs"
    } };
local u3 = { "Tier 0 (no cards)", "Tier 1 (yellow)", "Tier 2 (purple)", "Tier 3 (pink)", "Tier 4 (doors)", "Tier 5 (red door)" };
local u4 = {
    {
        Name = "Move",
        Label = "MOVE",
        Biome = nil,
        Width = 70,
        Colour = Colours.Grey
    },
    {
        Name = "Forest",
        Label = "FOREST",
        Biome = 1,
        Width = 84,
        Colour = Color3.fromRGB(86, 140, 58)
    },
    {
        Name = "Desert",
        Label = "DESERT",
        Biome = 2,
        Width = 84,
        Colour = Color3.fromRGB(196, 150, 72)
    },
    {
        Name = "Tundra",
        Label = "TUNDRA",
        Biome = 3,
        Width = 84,
        Colour = Color3.fromRGB(126, 176, 214)
    },
    {
        Name = "Erase",
        Label = "ERASE",
        Biome = 0,
        Width = 70,
        Colour = Colours.Red
    }
};
local u5 = { Color3.fromRGB(70, 160, 50), Color3.fromRGB(240, 170, 60), Color3.fromRGB(110, 190, 255) };
local u6 = {
    ["."] = Color3.fromRGB(34, 61, 98),
    [","] = Color3.fromRGB(56, 96, 132),
    b = Color3.fromRGB(212, 196, 146),
    B = Color3.fromRGB(222, 228, 234),
    ["1"] = Color3.fromRGB(98, 131, 62),
    ["2"] = Color3.fromRGB(206, 176, 110),
    ["3"] = Color3.fromRGB(238, 241, 245),
    I = Color3.fromRGB(190, 222, 242)
};
local u7 = {
    b = true,
    B = true,
    ["1"] = true,
    ["2"] = true,
    ["3"] = true
};
local u8 = {};

local function make(p9: string, p10: string, p11: any, p12: userdata) -- Line: 84
    local v13 = p12:FindFirstChild(p10);

    if v13 and v13.ClassName ~= p9 then
        v13:Destroy();
        v13 = nil;
    end;

    if not v13 then
        v13 = Instance.new(p9);
        v13.Name = p10;
    end;

    for i, v in p11 do
        v13[i] = v;
    end;

    v13.Parent = p12;

    return v13;
end;

local function corner(p14: userdata, p15: number) -- Line: 100
    -- upvalues: make (copy)
    make("UICorner", "UICorner", {
        CornerRadius = UDim.new(0, p15)
    }, p14);
end;

local function outline(p16: userdata, p17, p18: number, p19: number?) -- Line: 103
    -- upvalues: make (copy)
    return make("UIStroke", "Edge", {
        Color = p17,
        Thickness = p18,
        Transparency = p19 or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, p16);
end;

local function text(p20: userdata, p21: string, p22: any) -- Line: 107
    -- upvalues: u1 (copy), make (copy)
    local v23 = {
        BackgroundTransparency = 1,
        TextSize = 13,
        TextColor3 = u1.Text,
        FontFace = u1.Medium,
        TextXAlignment = Enum.TextXAlignment.Left
    };

    for i, v in p22 do
        v23[i] = v;
    end;

    return make("TextLabel", p21, v23, p20);
end;

local function button(p24: userdata, p25: string, p26: string, p27, p28: any) -- Line: 115
    -- upvalues: make (copy), MapUIStyle (copy)
    local v29 = make("TextButton", p25, {
        Text = p26
    }, p24);
    MapUIStyle.Button(v29, p27, p28.TextSize or 13);

    for i, v in p28 do
        if i ~= "TextSize" then
            v29[i] = v;
        end;
    end;

    return v29;
end;

local function sliderRow(p30: userdata, p31: string, p32: number) -- Line: 127
    -- upvalues: make (copy), MapUIStyle (copy), text (copy), u1 (copy)
    local v33 = make("Frame", p31, {
        Size = UDim2.new(1, 0, 0, 40),
        LayoutOrder = p32
    }, p30);
    MapUIStyle.Row(v33);
    text(v33, "Title", {
        Text = "",
        TextSize = 14,
        FontFace = u1.Bold,
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(0.34, -12, 1, 0),
        TextTruncate = Enum.TextTruncate.AtEnd
    });
    local v34 = make("Frame", "Box", {
        Position = UDim2.new(0.34, 0, 0.5, -13),
        Size = UDim2.new(0.3, -8, 0, 26)
    }, v33);
    MapUIStyle.Inset(v34);
    text(v34, "Value", {
        Text = "",
        TextSize = 12,
        Size = UDim2.fromScale(1, 1),
        FontFace = u1.Bold,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd
    });
    local v35 = make("Frame", "Track", {
        Position = UDim2.new(0.64, 0, 0.5, -11),
        Size = UDim2.new(0.36, -10, 0, 22)
    }, v33);
    MapUIStyle.Inset(v35);
    local v36 = make("Frame", "Fill", {
        ZIndex = 2,
        Size = UDim2.fromScale(0, 1)
    }, v35);
    MapUIStyle.Fill(v36, u1.Accent, {
        RimThickness = 1,
        RimTransparency = 0.15,
        Corner = 3,
        Rim = Color3.fromRGB(120, 196, 255)
    });
    local v37 = make("Frame", "Knob", {
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromOffset(22, 22)
    }, v35);
    MapUIStyle.Fill(v37, Color3.fromRGB(52, 166, 255), {
        RimThickness = 2,
        RimTransparency = 0,
        Corner = 4,
        Rim = Color3.fromRGB(150, 210, 255)
    });
    MapUIStyle.Glow(v37, u1.Accent, 0.35).ZIndex = 3;
    make("TextButton", "Hit", {
        Text = "",
        BackgroundTransparency = 1,
        ZIndex = 3,
        Position = UDim2.new(0.64, -8, 0, 0),
        Size = UDim2.new(0.36, 6, 1, 0)
    }, v33);

    return v33;
end;

function u8.Build(p38: userdata) -- Line: 152
    -- upvalues: make (copy), MapUIStyle (copy), Colours (copy), text (copy), u1 (copy), button (copy), u4 (copy), sliderRow (copy), u2 (copy), u3 (copy)
    local v39 = {};
    local StatusBar = p38:WaitForChild("StatusBar");
    v39.Chip = make("TextButton", "SeedLab", {
        LayoutOrder = 4,
        AutoButtonColor = true,
        Text = "SEED LAB",
        ZIndex = 20,
        Visible = false,
        Size = UDim2.fromOffset(112, 20)
    }, StatusBar);
    MapUIStyle.Chip(v39.Chip, Colours.Grey);
    local v40 = make("Frame", "SeedLab", {
        Active = true,
        Visible = false,
        ZIndex = 40,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 900, 0, 40),
        Size = UDim2.new(0, 500, 1, -140)
    }, p38);
    v39.Panel = v40;
    MapUIStyle.Backdrop(v40, {
        Transparency = 0.4,
        Outside = true,
        Even = true,
        SliceScale = 0.4,
        Colour = Color3.fromRGB(42, 42, 44)
    });
    MapUIStyle.Scaled(v40);
    local v41 = make("Frame", "Header", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(18, 18),
        Size = UDim2.new(1, -36, 0, 52)
    }, v40);
    MapUIStyle.Banner(v41, {
        Transparency = 0.15,
        Bleed = 4,
        BleedX = 6
    });
    text(v41, "Title", {
        Text = "SEED LAB",
        TextSize = 26,
        FontFace = u1.Heavy,
        Position = UDim2.fromOffset(12, 3),
        Size = UDim2.new(1, -70, 0, 30)
    });
    text(v41, "Subtitle", {
        Text = "CONCEPT PREVIEW  -  NOTHING CHANGES UNTIL YOU REGENERATE",
        TextSize = 11,
        FontFace = u1.Bold,
        TextColor3 = u1.Muted,
        Position = UDim2.fromOffset(12, 32),
        Size = UDim2.new(1, -70, 0, 14)
    });
    v39.Close = button(v41, "Close", "", u1.Danger, {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(32, 32)
    });

    for i, v in { 45, -45 } do
        local v42 = make("Frame", "Bar" .. i, {
            BorderSizePixel = 0,
            ZIndex = 3,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(14, 3),
            Rotation = v,
            BackgroundColor3 = u1.Text
        }, v39.Close);
        MapUIStyle.Round(v42, 1);
    end;

    local u43 = make("ScrollingFrame", "Body", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        Position = UDim2.fromOffset(10, 78),
        Size = UDim2.new(1, -14, 1, -192),
        ScrollBarImageColor3 = u1.Muted,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y
    }, v40);
    v39.Body = u43;
    make("UIPadding", "UIPadding", {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 24),
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8)
    }, u43);
    make("UIListLayout", "UIListLayout", {
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, u43);
    local u44 = 0;

    local function nextOrder() -- Line: 191
        -- upvalues: u44 (ref)
        u44 = u44 + 1;

        return u44;
    end;

    local function section(p45: string, p46: string) -- Line: 195
        -- upvalues: make (ref), u44 (ref), u43 (copy), MapUIStyle (ref), text (ref), u1 (ref)
        local v47 = {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 32)
        };
        u44 = u44 + 1;
        v47.LayoutOrder = u44;
        local v48 = make("Frame", p45, v47, u43);
        MapUIStyle.Banner(v48, {
            Transparency = 0.2,
            Bleed = 5,
            BleedX = 8
        });
        text(v48, "Title", {
            TextSize = 15,
            Text = string.upper(p46),
            FontFace = u1.Bold,
            Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -24, 1, 0)
        });
    end;

    section("SeedSection", "Seed");
    local v49 = {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40)
    };
    u44 = u44 + 1;
    v49.LayoutOrder = u44;
    local v50 = make("Frame", "SeedRow", v49, u43);
    v39.SeedBox = make("TextBox", "SeedBox", {
        Text = "",
        PlaceholderText = "SEED NUMBER",
        TextSize = 18,
        ClearTextOnFocus = false,
        Size = UDim2.new(1, -260, 1, 0),
        PlaceholderColor3 = u1.Muted,
        FontFace = u1.Bold,
        TextColor3 = u1.Text,
        TextXAlignment = Enum.TextXAlignment.Left
    }, v50);
    MapUIStyle.Inset(v39.SeedBox);
    make("UIPadding", "UIPadding", {
        PaddingLeft = UDim.new(0, 12)
    }, v39.SeedBox);
    v39.Random = button(v50, "Random", "RANDOMIZE", u1.Accent, {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0, 132, 1, 0)
    });
    v39.Current = make("TextButton", "Current", {
        Text = "CURRENT SEED",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -140, 0, 0),
        Size = UDim2.new(0, 112, 1, 0)
    }, v50);
    MapUIStyle.SoftButton(v39.Current, 11);
    local v51 = {
        Text = "...",
        TextSize = 22,
        FontFace = u1.Heavy,
        Size = UDim2.new(1, 0, 0, 26)
    };
    u44 = u44 + 1;
    v51.LayoutOrder = u44;
    v39.Name = text(u43, "SeedName", v51);
    local v52 = {
        Text = "",
        TextSize = 12,
        RichText = true,
        FontFace = u1.Bold,
        TextColor3 = u1.Muted,
        Size = UDim2.new(1, 0, 0, 14)
    };
    u44 = u44 + 1;
    v52.LayoutOrder = u44;
    v39.Info = text(u43, "SeedInfo", v52);
    section("PreviewSection", "Preview");
    local v53 = {
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = UDim2.fromOffset(454, 454),
        BackgroundColor3 = Color3.fromRGB(34, 61, 98)
    };
    u44 = u44 + 1;
    v53.LayoutOrder = u44;
    local v54 = make("Frame", "Canvas", v53, u43);
    v39.Canvas = v54;
    make("UIStroke", "Edge", {
        Thickness = 2,
        Transparency = 0,
        Color = u1.Line,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, v54);
    v39.PanCatcher = make("TextButton", "PanCatcher", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        ZIndex = 1,
        Size = UDim2.fromScale(1, 1)
    }, v54);
    local v55 = make("Frame", "View", {
        BackgroundTransparency = 1,
        ZIndex = 2,
        Size = UDim2.fromScale(1, 1)
    }, v54);
    v39.View = v55;
    v39.Image = make("ImageLabel", "Image", {
        BackgroundTransparency = 1,
        ZIndex = 1,
        Size = UDim2.fromScale(1, 1)
    }, v55);
    v39.PaintLayer = make("ImageLabel", "Paint", {
        BackgroundTransparency = 1,
        ZIndex = 2,
        Visible = false,
        ResampleMode = Enum.ResamplerMode.Pixelated
    }, v55);
    v39.GridLayer = make("Frame", "Grid", {
        BackgroundTransparency = 1,
        ZIndex = 3,
        Size = UDim2.fromScale(1, 1)
    }, v55);
    v39.RoutesLayer = make("Frame", "Routes", {
        BackgroundTransparency = 1,
        ZIndex = 4,
        Size = UDim2.fromScale(1, 1)
    }, v55);
    v39.SiteLayer = make("Frame", "Sites", {
        BackgroundTransparency = 1,
        ZIndex = 5,
        Size = UDim2.fromScale(1, 1)
    }, v55);
    v39.Brush = make("Frame", "Brush", {
        BackgroundTransparency = 0.85,
        Visible = false,
        ZIndex = 4,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1)
    }, v54);
    make("UICorner", "UICorner", {
        CornerRadius = UDim.new(1, 0)
    }, v39.Brush);
    local Brush = v39.Brush;
    make("UIStroke", "Edge", {
        Thickness = 1.5,
        Transparency = 0.1,
        Color = Color3.new(1, 1, 1),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, Brush);
    local v56 = make("Frame", "ZoomBar", {
        BackgroundTransparency = 1,
        ZIndex = 5,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -6, 0, 6),
        Size = UDim2.fromOffset(0, 24),
        AutomaticSize = Enum.AutomaticSize.X
    }, v54);
    make("UIListLayout", "UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }, v56);
    v39.ZoomLabel = text(v56, "Zoom", {
        Text = "1.0x",
        TextSize = 11,
        LayoutOrder = 0,
        BackgroundTransparency = 0.1,
        ZIndex = 5,
        FontFace = u1.Bold,
        Size = UDim2.fromOffset(42, 24),
        TextXAlignment = Enum.TextXAlignment.Center,
        BackgroundColor3 = u1.Dark
    });
    make("UIStroke", "Edge", {
        Thickness = 1,
        Transparency = 0,
        Color = u1.Line,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, v39.ZoomLabel);
    v39.ZoomOut = button(v56, "ZoomOut", "-", u1.Field, {
        LayoutOrder = 1,
        TextSize = 16,
        ZIndex = 5,
        Size = UDim2.fromOffset(24, 24)
    });
    v39.ZoomIn = button(v56, "ZoomIn", "+", u1.Field, {
        LayoutOrder = 2,
        TextSize = 16,
        ZIndex = 5,
        Size = UDim2.fromOffset(24, 24)
    });
    v39.ZoomFit = button(v56, "ZoomFit", "FIT", u1.Field, {
        LayoutOrder = 3,
        TextSize = 11,
        ZIndex = 5,
        Size = UDim2.fromOffset(38, 24)
    });
    v39.BusyCover = make("Frame", "Busy", {
        BackgroundTransparency = 0.45,
        Visible = false,
        ZIndex = 6,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = u1.Dark
    }, v54);
    v39.BusyText = text(v39.BusyCover, "Text", {
        Text = "Working...",
        TextSize = 14,
        TextWrapped = true,
        ZIndex = 7,
        FontFace = u1.Bold,
        Size = UDim2.fromScale(1, 1),
        TextXAlignment = Enum.TextXAlignment.Center
    });
    v39.Tip = text(v54, "Tip", {
        Text = "",
        TextSize = 12,
        BackgroundTransparency = 0.1,
        Visible = false,
        ZIndex = 8,
        RichText = true,
        FontFace = u1.Bold,
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = u1.Dark
    });
    make("UIPadding", "UIPadding", {
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6),
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3)
    }, v39.Tip);
    make("UIStroke", "Edge", {
        Thickness = 1,
        Transparency = 0,
        Color = u1.Line,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, v39.Tip);
    local v57 = {
        Text = "Scroll to zoom, drag the map to pan. Drag a monument to move it, right-click it (or press R over it) to turn it. Yellow dot: moved; red outline: clashes; amber: tight.",
        TextSize = 11,
        TextWrapped = true,
        TextColor3 = u1.Muted,
        Size = UDim2.new(1, 0, 0, 42)
    };
    u44 = u44 + 1;
    v57.LayoutOrder = u44;
    text(u43, "Hint", v57);
    local v58 = {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    };
    u44 = u44 + 1;
    v58.LayoutOrder = u44;
    local v59 = make("Frame", "MonumentRow", v58, u43);
    v39.ResetSites = make("TextButton", "ResetSites", {
        Text = "RESET MONUMENTS",
        Size = UDim2.new(0, 150, 1, 0)
    }, v59);
    MapUIStyle.SoftButton(v39.ResetSites, 11);
    v39.MonumentInfo = text(v59, "Info", {
        Text = "",
        TextSize = 12,
        RichText = true,
        TextColor3 = u1.Muted,
        Position = UDim2.fromOffset(162, 0),
        Size = UDim2.new(1, -162, 1, 0)
    });
    local v60 = {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    };
    u44 = u44 + 1;
    v60.LayoutOrder = u44;
    local v61 = make("Frame", "RoutesRow", v60, u43);
    v39.RoutesButton = button(v61, "Show", "SHOW ROADS & RIVERS", u1.Accent, {
        TextSize = 11,
        Size = UDim2.new(0, 190, 1, 0)
    });
    v39.RoutesInfo = text(v61, "Info", {
        Text = "Works them out for real - about 30 s (the server works hard meanwhile)",
        TextSize = 12,
        RichText = true,
        TextWrapped = true,
        TextColor3 = u1.Muted,
        Position = UDim2.fromOffset(202, 0),
        Size = UDim2.new(1, -202, 1, 0)
    });
    section("PaintSection", "Paint biomes");
    local v62 = {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34)
    };
    u44 = u44 + 1;
    v62.LayoutOrder = u44;
    local v63 = make("Frame", "PaintTools", v62, u43);
    make("UIListLayout", "UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }, v63);
    v39.ToolButtons = {};

    for i, v in u4 do
        local v64 = button(v63, v.Name, v.Label, v.Colour, {
            TextSize = 12,
            LayoutOrder = i,
            Size = UDim2.fromOffset(v.Width, 32)
        });
        make("UIStroke", "Picked", {
            Thickness = 2,
            Enabled = false,
            Color = Color3.new(1, 1, 1),
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        }, v64).Enabled = v.Name == "Move";
        v39.ToolButtons[v.Name] = v64;
    end;

    v39.Sliders = {};
    u44 = u44 + 1;
    v39.Sliders.Brush = sliderRow(u43, "Brush", u44);
    v39.Sliders.Brush.Title.Text = "Brush size";
    local v65 = {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30)
    };
    u44 = u44 + 1;
    v65.LayoutOrder = u44;
    local v66 = make("Frame", "PaintRow", v65, u43);
    v39.ClearPaint = make("TextButton", "ClearPaint", {
        Text = "CLEAR PAINT",
        Size = UDim2.new(0, 150, 1, 0)
    }, v66);
    MapUIStyle.SoftButton(v39.ClearPaint, 11);
    v39.PaintInfo = text(v66, "Info", {
        Text = "",
        TextSize = 12,
        RichText = true,
        TextWrapped = true,
        TextColor3 = u1.Muted,
        Position = UDim2.fromOffset(162, 0),
        Size = UDim2.new(1, -162, 1, 0)
    });
    local v67 = {
        Text = "Pick a biome and drag on the preview to paint it; right-drag still pans. Painted ground is built as that biome (desert and tundra keep a strip of forest between them).",
        TextSize = 11,
        TextWrapped = true,
        TextColor3 = u1.Muted,
        Size = UDim2.new(1, 0, 0, 30)
    };
    u44 = u44 + 1;
    v67.LayoutOrder = u44;
    text(u43, "PaintHint", v67);
    section("ShapeSection", "Island shape");
    local v68 = {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 40)
    };
    u44 = u44 + 1;
    v68.LayoutOrder = u44;
    local v69 = make("Frame", "ShapeRow", v68, u43);
    v39.ShapeBox = make("TextBox", "ShapeBox", {
        Text = "",
        PlaceholderText = "ALPHA MAP IMAGE ID",
        TextSize = 16,
        ClearTextOnFocus = false,
        Size = UDim2.new(1, -192, 1, 0),
        PlaceholderColor3 = u1.Muted,
        FontFace = u1.Bold,
        TextColor3 = u1.Text,
        TextXAlignment = Enum.TextXAlignment.Left
    }, v69);
    MapUIStyle.Inset(v39.ShapeBox);
    make("UIPadding", "UIPadding", {
        PaddingLeft = UDim.new(0, 12)
    }, v39.ShapeBox);
    v39.ShapeLoad = button(v69, "Load", "LOAD", u1.Accent, {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -88, 0, 0),
        Size = UDim2.new(0, 96, 1, 0)
    });
    v39.ShapeClear = make("TextButton", "Clear", {
        Text = "CLEAR",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.new(0, 80, 1, 0)
    }, v69);
    MapUIStyle.SoftButton(v39.ShapeClear, 11);
    local v70 = {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 52)
    };
    u44 = u44 + 1;
    v70.LayoutOrder = u44;
    local v71 = make("Frame", "ShapeInfo", v70, u43);
    v39.ShapeThumb = make("ImageLabel", "Thumb", {
        Image = "",
        Size = UDim2.fromOffset(52, 52),
        BackgroundColor3 = Color3.fromRGB(34, 61, 98),
        ScaleType = Enum.ScaleType.Fit
    }, v71);
    make("UIStroke", "Edge", {
        Thickness = 1,
        Transparency = 0,
        Color = u1.Line,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, v39.ShapeThumb);
    v39.ShapeInfo = text(v71, "Info", {
        Text = "",
        TextSize = 12,
        RichText = true,
        TextWrapped = true,
        TextColor3 = u1.Muted,
        Position = UDim2.fromOffset(64, 0),
        Size = UDim2.new(1, -64, 1, 0)
    });
    u44 = u44 + 1;
    v39.Sliders.ShapeScale = sliderRow(u43, "ShapeScale", u44);
    v39.Sliders.ShapeScale.Title.Text = "Shape scale";
    section("IslandSection", "Island");

    for _, v in u2 do
        u44 = u44 + 1;
        v39.Sliders[v.Key] = sliderRow(u43, v.Key, u44);
        v39.Sliders[v.Key].Title.Text = v.Name;
    end;

    section("BiomeSection", "Biomes");
    u44 = u44 + 1;
    v39.Sliders["Weight" .. 1] = sliderRow(u43, "Weight" .. 1, u44);
    u44 = u44 + 1;
    v39.Sliders["Weight" .. 2] = sliderRow(u43, "Weight" .. 2, u44);
    u44 = u44 + 1;
    v39.Sliders["Weight" .. 3] = sliderRow(u43, "Weight" .. 3, u44);
    section("MonumentSection", "Monuments per tier");

    for i, v in u3 do
        local v72 = "Tier" .. i - 1;
        u44 = u44 + 1;
        v39.Sliders[v72] = sliderRow(u43, v72, u44);
        v39.Sliders[v72].Title.Text = v;
    end;

    section("NumbersSection", "Numbers");
    local v73 = {
        Text = "",
        TextSize = 12,
        TextWrapped = true,
        RichText = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.new(1, 0, 0, 16)
    };
    u44 = u44 + 1;
    v73.LayoutOrder = u44;
    v39.Stats = text(u43, "Stats", v73);
    local v74 = make("Frame", "Footer", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, -18),
        Size = UDim2.new(1, 0, 0, 88)
    }, v40);
    v39.Status = text(v74, "Status", {
        Text = "",
        TextSize = 12,
        TextWrapped = true,
        FontFace = u1.Bold,
        TextColor3 = u1.Muted,
        TextYAlignment = Enum.TextYAlignment.Top,
        Position = UDim2.fromOffset(18, 0),
        Size = UDim2.new(1, -36, 0, 32)
    });
    v39.Defaults = button(v74, "Defaults", "RESET TO DEFAULT", u1.Danger, {
        TextSize = 12,
        ZIndex = 2,
        Position = UDim2.new(0, 18, 1, -46),
        Size = UDim2.fromOffset(156, 46)
    });
    v39.Regenerate = button(v74, "Regenerate", "REGENERATE MAP", u1.Go, {
        TextSize = 19,
        ZIndex = 2,
        Position = UDim2.new(0, 184, 1, -46),
        Size = UDim2.new(1, -202, 0, 46)
    });
    v39.RegenerateGlow = MapUIStyle.Glow(v39.Regenerate, u1.Go, 0.4);
    MapUIStyle.Glow(v39.Defaults, u1.Danger, 0.3);
    local v75 = make("TextButton", "Confirm", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 0.25,
        Visible = false,
        ZIndex = 20,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(14, 14, 16)
    }, v40);
    v39.Confirm = v75;
    local v76 = make("Frame", "Box", {
        BackgroundTransparency = 1,
        ZIndex = 21,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(428, 250)
    }, v75);
    MapUIStyle.Backdrop(v76, {
        Transparency = 0.12,
        Even = true,
        SliceScale = 0.3,
        Colour = Color3.fromRGB(36, 36, 38)
    });
    local v77 = make("Frame", "Header", {
        BackgroundTransparency = 1,
        ZIndex = 22,
        Position = UDim2.fromOffset(14, 14),
        Size = UDim2.new(1, -28, 0, 36)
    }, v76);
    MapUIStyle.Banner(v77, {
        Transparency = 0.12,
        Bleed = 2,
        BleedX = 0
    });
    text(v77, "Title", {
        Text = "REGENERATE THE MAP?",
        TextSize = 18,
        ZIndex = 23,
        FontFace = u1.Heavy,
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -24, 1, 0)
    });
    v39.ConfirmText = text(v76, "Message", {
        Text = "",
        TextSize = 13,
        TextWrapped = true,
        RichText = true,
        ZIndex = 22,
        TextYAlignment = Enum.TextYAlignment.Top,
        Position = UDim2.fromOffset(20, 62),
        Size = UDim2.new(1, -40, 0, 116)
    });
    v39.ConfirmCancel = make("TextButton", "Cancel", {
        Text = "CANCEL",
        ZIndex = 22,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 20, 1, -18),
        Size = UDim2.new(0.5, -26, 0, 42)
    }, v76);
    MapUIStyle.SoftButton(v39.ConfirmCancel, 13);
    v39.ConfirmGo = button(v76, "Go", "REGENERATE", Colours.Orange, {
        TextSize = 15,
        ZIndex = 22,
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -20, 1, -18),
        Size = UDim2.new(0.5, -26, 0, 42)
    });
    local v78 = make("Folder", "Templates", {}, v40);
    v39.GridLineTemplate = make("Frame", "GridLine", {
        BackgroundTransparency = 0.55,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 2,
        BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    }, v78);
    v39.GridLabelTemplate = text(v78, "GridLabel", {
        Text = "",
        TextSize = 10,
        TextTransparency = 0.15,
        Visible = false,
        ZIndex = 2,
        FontFace = u1.Bold,
        TextColor3 = Color3.fromRGB(20, 20, 22)
    });
    v39.RouteTemplate = make("Frame", "Route", {
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 3,
        AnchorPoint = Vector2.new(0.5, 0.5)
    }, v78);
    local v79 = make("TextButton", "Site", {
        Text = "",
        AutoButtonColor = false,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 4
    }, v78);
    make("UIStroke", "Edge", {
        Thickness = 1,
        Transparency = 0.25,
        Color = Color3.new(1, 1, 1),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    }, v79);
    local v80 = make("Frame", "Dot", {
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 5,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(1, 0),
        Size = UDim2.fromOffset(7, 7),
        BackgroundColor3 = u1.Moved
    }, v79);
    make("UICorner", "UICorner", {
        CornerRadius = UDim.new(0, 4)
    }, v80);
    v39.SiteTemplate = v79;

    return v39;
end;

local u81 = {
    Defaults = nil,
    Params = nil,
    Current = nil,
    Routes = nil,
    PreviewVersion = 0,
    EditVersion = 0,
    InFlight = false,
    Again = false,
    Routing = false,
    Regenerating = false,
    StatusText = "Tweak the concept, then regenerate. Nothing changes until you do.",
    StatusColour = nil,
    FirstOpen = true,
    Open = false,
    PreviewImage = nil,
    PreviewN = 0,
    Paint = nil,
    PaintN = 0,
    PaintImage = nil,
    Tool = "Move",
    Brush = 2,
    Painting = false,
    PaintDirty = false,
    ShapeNote = nil,
    Edits = {}
};

local function colName(p82: number) -- Line: 401
    return string.rep(string.char(p82 % 26 + 65), p82 // 26 + 1);
end;

local function isOwner() -- Line: 405
    -- upvalues: Players (copy)
    return Players.LocalPlayer:GetAttribute("Owner") == true;
end;

local u83 = nil;

function u8.Attach(u84: userdata) -- Line: 411
    -- upvalues: u83 (ref), Players (copy), u8 (copy), ReplicatedStorage (copy), script_Parent (copy), u81 (copy), u1 (copy), math_clamp (copy), AssetService (copy), u6 (copy), math_floor (copy), u7 (copy), u4 (copy), u5 (copy), MapUIStyle (copy), UserInputService (copy), u3 (copy), Colours (copy), TweenService (copy), colName (copy)
    if u83 == u84 then
        return;
    end;

    u83 = u84;
    local LocalPlayer = Players.LocalPlayer;

    if Players.LocalPlayer:GetAttribute("Owner") ~= true then
        local StatusBar = u84:FindFirstChild("StatusBar");

        if StatusBar then
            StatusBar = StatusBar:FindFirstChild("SeedLab");
        end;

        if StatusBar then
            StatusBar.Visible = false;
        end;

        local SeedLab = u84:FindFirstChild("SeedLab");

        if SeedLab then
            SeedLab.Visible = false;
        end;

        local u85 = nil;
        u85 = LocalPlayer:GetAttributeChangedSignal("Owner"):Connect(function() -- Line: 429
            -- upvalues: Players (ref), u84 (copy), u85 (ref), u83 (ref), u8 (ref)
            if Players.LocalPlayer:GetAttribute("Owner") == true and u84.Parent then
                u85:Disconnect();

                if u83 == u84 then
                    u83 = nil;
                end;

                u8.Attach(u84);
            end;
        end);
        u84.Destroying:Connect(function() -- Line: 438
            -- upvalues: u85 (ref)
            u85:Disconnect();
        end);

        return;
    end;

    local MapRemotes = ReplicatedStorage:WaitForChild("MapRemotes");
    local SeedLab = MapRemotes:WaitForChild("SeedLab");
    local SeedLabStatus = MapRemotes:WaitForChild("SeedLabStatus");
    local MapRenderClient = require(script_Parent:WaitForChild("MapRenderClient"));
    local u86 = u8.Build(u84);
    local u87 = {};

    local function on(p88, p89) -- Line: 449
        -- upvalues: u87 (copy)
        local v90 = p88:Connect(p89);
        table.insert(u87, v90);

        return v90;
    end;

    local Panel = u86.Panel;
    local Canvas = u86.Canvas;
    local View = u86.View;
    local Body = u86.Body;
    local u91 = {};
    local u92 = {
        Zoom = 1,
        X = 0,
        Y = 0,
        PanFrom = nil,
        Drag = nil,
        Hovered = nil,
        Slider = nil
    };
    local u93 = {};
    local u94 = {};

    function u91.SetStatus(p95: string, p96) -- Line: 461
        -- upvalues: u81 (ref), u86 (copy), u1 (ref)
        u81.StatusText = p95;
        u81.StatusColour = p96;
        u86.Status.Text = p95;
        u86.Status.TextColor3 = p96 or u1.Muted;
    end;

    function u91.Request() -- Line: 468
        -- upvalues: u81 (ref), u91 (copy)
        local table_clone_ret = table.clone(u81.Params);
        table_clone_ret.Weights = table.clone(u81.Params.Weights);
        table_clone_ret.Shape = u81.Params.Shape and table.clone(u81.Params.Shape) or nil;
        table_clone_ret.Paint = u91.PaintText();

        return table_clone_ret;
    end;

    function u91.ApplyView() -- Line: 477
        -- upvalues: u92 (copy), math_clamp (ref), View (copy), u86 (copy)
        local v97 = 454 * u92.Zoom;
        local math_min_ret = math.min(0, 454 - v97);
        local math_max_ret = math.max(0, 454 - v97);
        u92.X = math_clamp(u92.X, math_min_ret, math_max_ret);
        u92.Y = math_clamp(u92.Y, math_min_ret, math_max_ret);
        View.Size = UDim2.fromOffset(v97, v97);
        View.Position = UDim2.fromOffset(u92.X, u92.Y);
        u86.ZoomLabel.Text = u92.Zoom < 1 and string.format("%.2fx", u92.Zoom) or string.format("%.1fx", u92.Zoom);
    end;

    function u91.ZoomAbout(p98: number, p99: number, p100: number) -- Line: 488
        -- upvalues: math_clamp (ref), u92 (copy), u91 (copy)
        local v101 = math_clamp(p98, 0.35, 8);
        local v102 = (p99 - u92.X) / (454 * u92.Zoom);
        local v103 = (p100 - u92.Y) / (454 * u92.Zoom);
        u92.Zoom = v101;
        u92.X = p99 - v102 * 454 * v101;
        u92.Y = p100 - v103 * 454 * v101;
        u91.ApplyView();
    end;

    local v104 = u86.ZoomIn.Activated:Connect(function() -- Line: 495
        -- upvalues: u91 (copy), u92 (copy)
        u91.ZoomAbout(u92.Zoom * 1.5, 227, 227);
    end);
    table.insert(u87, v104);
    local v105 = u86.ZoomOut.Activated:Connect(function() -- Line: 498
        -- upvalues: u91 (copy), u92 (copy)
        u91.ZoomAbout(u92.Zoom / 1.5, 227, 227);
    end);
    table.insert(u87, v105);
    local v106 = u86.ZoomFit.Activated:Connect(function() -- Line: 501
        -- upvalues: u92 (copy), u91 (copy)
        u92.Zoom = 1;
        u92.X = 0;
        u92.Y = 0;
        u91.ApplyView();
    end);
    table.insert(u87, v106);
    local v108 = u86.PanCatcher.InputBegan:Connect(function(p107) -- Line: 505
        -- upvalues: u81 (ref), u91 (copy), u92 (copy)
        local UserInputType = p107.UserInputType;

        if UserInputType ~= Enum.UserInputType.MouseButton1 and UserInputType ~= Enum.UserInputType.Touch or u81.Tool == "Move" then
            if UserInputType == Enum.UserInputType.MouseButton1 or (UserInputType == Enum.UserInputType.MouseButton2 or UserInputType == Enum.UserInputType.MouseButton3) then
                u92.PanFrom = { Vector2.new(p107.Position.X, p107.Position.Y), u92.X, u92.Y };
            end;

            return;
        end;

        u81.Painting = true;
        u91.PaintAt(Vector2.new(p107.Position.X, p107.Position.Y));
    end);
    table.insert(u87, v108);
    local v109 = Canvas.MouseEnter:Connect(function() -- Line: 517
        -- upvalues: Body (copy)
        Body.ScrollingEnabled = false;
    end);
    table.insert(u87, v109);
    local v110 = Canvas.MouseLeave:Connect(function() -- Line: 520
        -- upvalues: Body (copy)
        Body.ScrollingEnabled = true;
    end);
    table.insert(u87, v110);

    local function slider(p111: string, u112: number, u113: number, u114: number, u115: any, u116: any) -- Line: 525
        -- upvalues: u86 (copy), math_clamp (ref), u92 (copy), u87 (copy), u94 (copy)
        local v117 = u86.Sliders[p111];
        local Value = v117.Box.Value;
        local Track = v117.Track;
        local Fill = Track.Fill;
        local Knob = Track.Knob;
        local Hit = v117.Hit;
        local KnobStyleGlow = Track:FindFirstChild("KnobStyleGlow");
        local StyleEdge = Knob:FindFirstChild("StyleEdge");
        local u118 = {
            Extra = "",
            Value = u112
        };

        function u118.Set(p119: number) -- Line: 532
            -- upvalues: u112 (copy), u114 (copy), u113 (copy), math_clamp (ref), u118 (copy), Fill (copy), Knob (copy), Value (copy), u115 (copy)
            local v120 = math_clamp(math.round((p119 - u112) / u114) * u114 + u112, u112, u113);
            u118.Value = v120;
            local v121 = (v120 - u112) / (u113 - u112);
            Fill.Size = UDim2.fromScale(v121, 1);
            Knob.Position = UDim2.fromScale(v121, 0.5);
            Value.Text = u115(v120) .. u118.Extra;
        end;

        function u118.FromX(p122: number) -- Line: 540
            -- upvalues: Track (copy), math_clamp (ref), u118 (copy), u112 (copy), u113 (copy)
            local v123 = math_clamp((p122 - Track.AbsolutePosition.X) / math.max(Track.AbsoluteSize.X, 1), 0, 1);
            u118.Set(u112 + v123 * (u113 - u112));
        end;

        function u118.Commit() -- Line: 544
            -- upvalues: u116 (copy), u118 (copy)
            u116(u118.Value);
        end;

        local u124 = false;

        function u118.Light() -- Line: 548
            -- upvalues: u124 (ref), u92 (ref), u118 (copy), KnobStyleGlow (copy), StyleEdge (copy), Knob (copy)
            local v125 = u124 or u92.Slider == u118;

            if KnobStyleGlow then
                KnobStyleGlow.ImageTransparency = v125 and 0.25 or 0.6;
            end;

            if StyleEdge then
                StyleEdge.Color = v125 and Color3.fromRGB(215, 238, 255) or Color3.fromRGB(150, 210, 255);
            end;

            Knob.Size = v125 and UDim2.fromOffset(24, 24) or UDim2.fromOffset(22, 22);
        end;

        local v126 = Hit.MouseEnter:Connect(function() -- Line: 558
            -- upvalues: u124 (ref), u118 (copy)
            u124 = true;
            u118.Light();
        end);
        table.insert(u87, v126);
        local v127 = Hit.MouseLeave:Connect(function() -- Line: 562
            -- upvalues: u124 (ref), u118 (copy)
            u124 = false;
            u118.Light();
        end);
        table.insert(u87, v127);
        local v129 = Hit.InputBegan:Connect(function(p128) -- Line: 566
            -- upvalues: u92 (ref), u118 (copy)
            if p128.UserInputType == Enum.UserInputType.MouseButton1 or p128.UserInputType == Enum.UserInputType.Touch then
                u92.Slider = u118;
                u118.Light();
                u118.FromX(p128.Position.X);
            end;
        end);
        table.insert(u87, v129);
        u94[p111] = u118;

        return u118;
    end;

    function u91.DrawCells(u130) -- Line: 578
        -- upvalues: u81 (ref), AssetService (ref), u86 (copy), u6 (ref), math_floor (ref)
        if u81.PreviewN ~= u130.N or not u81.PreviewImage then
            if u81.PreviewImage then
                u81.PreviewImage:Destroy();
                u81.PreviewImage = nil;
            end;

            local success, result = pcall(function() -- Line: 584
                -- upvalues: AssetService (ref), u130 (copy)
                return AssetService:CreateEditableImage({
                    Size = Vector2.new(u130.N, u130.N)
                });
            end);

            if not (success and result) then
                return;
            end;

            local N = u130.N;
            u81.PreviewImage = result;
            u81.PreviewN = N;
        end;

        u86.Image.ImageContent = Content.fromObject(u81.PreviewImage);
        local N = u130.N;
        local buffer_create_ret = buffer.create(N * N * 4);
        local v131 = {};

        for i, v in u6 do
            local string_byte_ret = string.byte(i);
            local v132 = math_floor(v.R * 255 + 0.5);
            local v133 = math_floor(v.G * 255 + 0.5);
            local bit32_lshift_ret = bit32.lshift(v133, 8);
            local v134 = math_floor(v.B * 255 + 0.5);
            local bit32_lshift_ret2 = bit32.lshift(v134, 16);
            v131[string_byte_ret] = bit32.bor(v132, bit32_lshift_ret, bit32_lshift_ret2, 4278190080);
        end;

        local Cells = u130.Cells;
        local v135 = v131[46];

        for i = 1, N * N do
            local v136 = v131[string.byte(Cells, i)] or v135;
            buffer.writeu32(buffer_create_ret, (i - 1) * 4, v136);
            local _ = i;
        end;

        u81.PreviewImage:WritePixelsBuffer(Vector2.zero, Vector2.new(N, N), buffer_create_ret);
    end;

    function u91.DrawGrid(p137) -- Line: 608
        -- upvalues: u86 (copy), math_floor (ref), math_clamp (ref)
        u86.GridLayer:ClearAllChildren();
        local Grid = p137.Grid;
        local Side = p137.Side;
        local v138 = (Side - Grid.Cols * Grid.Cell) / 2 / Side;
        local u139 = Grid.Cell / Side;

        local function gridLine(p140, p141) -- Line: 614
            -- upvalues: u86 (ref)
            local v142 = u86.GridLineTemplate:Clone();
            v142.Position = p140;
            v142.Size = p141;
            v142.Visible = true;
            v142.Parent = u86.GridLayer;
        end;

        for i = 0, Grid.Cols do
            local UDim2_fromScale_ret = UDim2.fromScale(v138 + i * u139, 0);
            local UDim2_new_ret = UDim2.new(0, 1, 1, 0);
            local v143 = u86.GridLineTemplate:Clone();
            v143.Position = UDim2_fromScale_ret;
            v143.Size = UDim2_new_ret;
            v143.Visible = true;
            v143.Parent = u86.GridLayer;
            local _ = i;
        end;

        for i = 0, Grid.Rows do
            local UDim2_new_ret = UDim2.new(v138, 0, i * u139, 0);
            local UDim2_new_ret2 = UDim2.new(Grid.Cols * u139, 0, 0, 1);
            local v144 = u86.GridLineTemplate:Clone();
            v144.Position = UDim2_new_ret;
            v144.Size = UDim2_new_ret2;
            v144.Visible = true;
            v144.Parent = u86.GridLayer;
            local _ = i;
        end;

        local v145 = 454 * u139;
        local v146 = v145 >= 15 and 1 or 2;
        local u147 = math_clamp(math_floor(v145 * 0.42), 7, 11);

        local function gridLabel(p148: string, p149) -- Line: 629
            -- upvalues: u86 (ref), u147 (copy), u139 (copy)
            local v150 = u86.GridLabelTemplate:Clone();
            v150.Text = p148;
            v150.TextSize = u147;
            v150.Position = p149;
            v150.Visible = true;
            v150.Size = UDim2.new(u139, -2, 0, u147 + 2);
            v150.Parent = u86.GridLayer;
        end;

        for i = 0, Grid.Cols - 1, v146 do
            local string_rep_ret = string.rep(string.char(i % 26 + 65), i // 26 + 1);
            local UDim2_new_ret = UDim2.new(v138 + i * u139, 2, 0, 1);
            local v151 = u86.GridLabelTemplate:Clone();
            v151.Text = string_rep_ret;
            v151.TextSize = u147;
            v151.Position = UDim2_new_ret;
            v151.Visible = true;
            v151.Size = UDim2.new(u139, -2, 0, u147 + 2);
            v151.Parent = u86.GridLayer;
            local _ = i;
        end;

        for i = 1, Grid.Rows - 1, v146 do
            local v152 = tostring(i);
            local UDim2_new_ret = UDim2.new(v138, 2, i * u139, 1);
            local v153 = u86.GridLabelTemplate:Clone();
            v153.Text = v152;
            v153.TextSize = u147;
            v153.Position = UDim2_new_ret;
            v153.Visible = true;
            v153.Size = UDim2.new(u139, -2, 0, u147 + 2);
            v153.Parent = u86.GridLayer;
            local _ = i;
        end;
    end;

    function u91.Placement(p154) -- Line: 644
        -- upvalues: u81 (ref)
        local v155 = u81.Edits[p154.Name];
        local v156 = v155 and v155.Rot or p154.Rot;
        local W = p154.W;
        local D = p154.D;

        if v156 % 2 == 1 then
            local v157 = D;
            D = W;
            W = v157;
        end;

        local v158 = v155 and v155.X0 or p154.X0;
        local v159 = v155 and v155.Z0 or p154.Z0;

        return v158, v159, v158 + W, v159 + D, v156;
    end;

    function u91.Problem(p160) -- Line: 657
        -- upvalues: u81 (ref), u91 (copy), math_floor (ref), u7 (ref)
        local Current = u81.Current;
        local v161, v162, v163, v164 = u91.Placement(p160);
        local v165 = Current.Gap or 312;
        local v166 = nil;
        local v167 = nil;

        for _, v in Current.Sites do
            if v ~= p160 then
                local v168, v169, v170, v171 = u91.Placement(v);
                local math_max_ret = math.max(v168 - v163, 0, v161 - v170);
                local math_max_ret2 = math.max(v169 - v164, 0, v162 - v171);
                local math_sqrt_ret = math.sqrt(math_max_ret * math_max_ret + math_max_ret2 * math_max_ret2);

                if v168 < v163 and (v161 < v170 and (v169 < v164 and v162 < v171)) then
                    return "clash", "overlaps " .. v.Display;
                end;

                if math_sqrt_ret < v165 * 0.5 and v166 == nil then
                    v167 = string.format("only %d studs from %s", math_floor(math_sqrt_ret), v.Display);
                    v166 = "tight";
                end;
            end;
        end;

        local N = Current.N;
        local Side = Current.Side;
        local v172 = Current.CX - Side / 2;
        local v173 = Current.CZ - Side / 2;
        local v174 = math_floor((v161 - v172) / Side * N);
        local v175 = math_floor((v163 - v172) / Side * N);
        local v176 = math_floor((v162 - v173) / Side * N);
        local v177 = math_floor((v164 - v173) / Side * N);
        local v178 = 0;
        local v179 = 0;

        for i = math.max(v176, 0), math.min(v177, N - 1) do
            local v180 = i;

            for i2 = math.max(v174, 0), math.min(v175, N - 1) do
                v178 = v178 + 1;
                local v181;

                if u7[string.sub(Current.Cells, v180 * N + i2 + 1, v180 * N + i2 + 1)] then
                    v179 = v179 + 1;
                    v181 = i2;
                else
                    v181 = i2;
                end;
            end;
        end;

        local v182 = v178 > 0 and v179 / v178 or 0;

        if p160.Ocean or p160.Wet > 0.97 then
            if v182 > 0.02 then
                return "clash", "an offshore monument on land";
            end;
        elseif p160.Wet < 0.03 then
            if v182 < 0.97 then
                return "clash", string.format("%d%% of it in the sea", (math.round((1 - v182) * 100)));
            end;
        else
            if v182 < 0.25 then
                return "clash", "a coastal monument out at sea";
            end;

            if v182 > 0.97 then
                return "tight", "a coastal monument with no sea for its water";
            end;
        end;

        return v166, v167;
    end;

    function u91.RefreshMonumentInfo() -- Line: 708
        -- upvalues: u81 (ref), u91 (copy), u86 (copy)
        local Current = u81.Current;

        if not Current then
            return;
        end;

        local v183 = 0;
        local v184 = 0;
        local v185 = 0;

        for _, v in Current.Sites do
            if u81.Edits[v.Name] then
                v183 = v183 + 1;
            end;

            local v186 = u91.Problem(v);

            if v186 == "clash" then
                v185 = v185 + 1;
            elseif v186 == "tight" then
                v184 = v184 + 1;
            end;
        end;

        local v187 = { string.format("%d monuments", #Current.Sites) };

        if v183 > 0 then
            table.insert(v187, string.format("<font color=\"#FFD640\">%d moved</font>", v183));
        end;

        if v185 > 0 then
            table.insert(v187, string.format("<font color=\"#E8403A\">%d clashing</font>", v185));
        end;

        if v184 > 0 then
            table.insert(v187, string.format("<font color=\"#F0B228\">%d tight</font>", v184));
        end;

        u86.MonumentInfo.Text = table.concat(v187, "  |  ");
    end;

    function u91.LayoutSite(p188) -- Line: 738
        -- upvalues: u81 (ref), u91 (copy), u1 (ref)
        local Current = u81.Current;
        local Site = p188.Site;
        local v189, v190, v191, v192 = u91.Placement(Site);
        p188.Button.Position = UDim2.fromScale((v189 - (Current.CX - Current.Side / 2)) / Current.Side, (v190 - (Current.CZ - Current.Side / 2)) / Current.Side);
        p188.Button.Size = UDim2.fromScale((v191 - v189) / Current.Side, (v192 - v190) / Current.Side);
        p188.Dot.Visible = u81.Edits[Site.Name] ~= nil;
        local v193 = u91.Problem(Site);
        p188.Stroke.Color = v193 == "clash" and u1.Danger or (v193 == "tight" and u1.Warn or Color3.new(1, 1, 1));
        p188.Stroke.Thickness = v193 and 2 or 1;
        p188.Stroke.Transparency = v193 and 0 or 0.25;
    end;

    function u91.RelayoutSites() -- Line: 752
        -- upvalues: u93 (copy), u91 (copy)
        for _, v in u93 do
            u91.LayoutSite(v);
        end;

        u91.RefreshMonumentInfo();
    end;

    function u91.ShowTip(p194) -- Line: 759
        -- upvalues: u91 (copy), u86 (copy)
        local Site = p194.Site;
        local v195, v196 = u91.Problem(Site);
        local v197 = { Site.Display };

        if (Site.Tier or 0) > 0 then
            v197[1] = v197[1] .. string.format("  <font color=\"#A5A5AC\">tier %d</font>", Site.Tier);
        end;

        if v196 then
            table.insert(v197, string.format("<font color=\"%s\">%s</font>", v195 == "clash" and "#E8403A" or "#F0B228", v196));
        end;

        u86.Tip.Text = table.concat(v197, "\n");
        u86.Tip.Visible = true;
    end;

    function u91.RotateSite(p198) -- Line: 773
        -- upvalues: u91 (copy), u81 (ref), u92 (copy)
        local v199, v200, v201, v202, v203 = u91.Placement(p198);
        local v204 = (v203 + 1) % 4;
        local W = p198.W;
        local D = p198.D;

        if v204 % 2 == 1 then
            local v205 = D;
            D = W;
            W = v205;
        end;

        u81.Edits[p198.Name] = {
            X0 = math.round(((v199 + v201) / 2 - W / 2) / 4) * 4,
            Z0 = math.round(((v200 + v202) / 2 - D / 2) / 4) * 4,
            Rot = v204
        };
        u91.RelayoutSites();
        u91.MarkRoutesStale();

        if u92.Hovered and u92.Hovered.Site == p198 then
            u91.ShowTip(u92.Hovered);
        end;
    end;

    function u91.WorldAt(p206) -- Line: 789
        -- upvalues: u81 (ref), View (copy)
        local Current = u81.Current;
        local AbsolutePosition = View.AbsolutePosition;
        local AbsoluteSize = View.AbsoluteSize;

        return Current.CX - Current.Side / 2 + (p206.X - AbsolutePosition.X) / AbsoluteSize.X * Current.Side, Current.CZ - Current.Side / 2 + (p206.Y - AbsolutePosition.Y) / AbsoluteSize.Y * Current.Side;
    end;

    function u91.DrawSites(p207) -- Line: 795
        -- upvalues: u86 (copy), u93 (copy), u92 (copy), MapRenderClient (copy), u81 (ref), u91 (copy)
        u86.SiteLayer:ClearAllChildren();
        table.clear(u93);
        u92.Hovered = nil;
        u86.Tip.Visible = false;

        for _, v in p207.Sites do
            local v208 = u86.SiteTemplate:Clone();
            v208.Name = "Site";
            v208.BackgroundColor3 = MapRenderClient.TierColours[v.Tier or 0] or MapRenderClient.TierColours[0];
            v208.Visible = true;
            v208.Interactable = u81.Tool == "Move";
            v208.Parent = u86.SiteLayer;
            local u209 = {
                Button = v208,
                Dot = v208.Dot,
                Stroke = v208.Edge,
                Site = v
            };
            u93[v.Name] = u209;
            v208.MouseEnter:Connect(function() -- Line: 809
                -- upvalues: u92 (ref), u209 (copy), u91 (ref)
                u92.Hovered = u209;
                u91.ShowTip(u209);
            end);
            v208.MouseLeave:Connect(function() -- Line: 813
                -- upvalues: u92 (ref), u209 (copy), u86 (ref)
                if u92.Hovered == u209 then
                    u92.Hovered = nil;

                    if not u92.Drag then
                        u86.Tip.Visible = false;
                    end;
                end;
            end);
            v208.InputBegan:Connect(function(p210) -- Line: 821
                -- upvalues: u91 (ref), v (copy), u92 (ref), u209 (copy)
                if p210.UserInputType ~= Enum.UserInputType.MouseButton1 then
                    if p210.UserInputType == Enum.UserInputType.MouseButton2 then
                        u91.RotateSite(v);
                    end;

                    return;
                end;

                local v211, v212 = u91.WorldAt(Vector2.new(p210.Position.X, p210.Position.Y));
                local v213, v214 = u91.Placement(v);
                u92.Drag = {
                    Entry = u209,
                    OffX = v211 - v213,
                    OffZ = v212 - v214
                };
            end);
            u91.LayoutSite(u209);
        end;

        u91.RefreshMonumentInfo();
    end;

    function u91.ShowPreview(p215) -- Line: 835
        -- upvalues: u81 (ref), u91 (copy), u86 (copy), u94 (copy)
        u81.Current = p215;
        local v216 = u81;
        v216.PreviewVersion = v216.PreviewVersion + 1;
        u91.ClearRoutes();
        local v217 = {};

        for _, v in p215.Sites do
            v217[v.Name] = true;
        end;

        for i in u81.Edits do
            if not v217[i] then
                u81.Edits[i] = nil;
            end;
        end;

        u91.DrawCells(p215);
        u91.DrawGrid(p215);
        u91.DrawSites(p215);
        u91.ApplyView();
        u86.Name.Text = "Seed " .. p215.Seed;
        local Coast = p215.Coast;
        u86.Info.Text = (u81.Defaults and u81.Defaults.Current == p215.Seed and "<font color=\"#60E274\">IN PLAY</font>  |  " or "") .. string.format("Island #%s%s%s  |  %d satellite%s, %d iceberg%s", tostring(Coast.Template or "?"), (Coast.Turn or 0) == 0 and "" or (string.format(", turned %d°", Coast.Turn * 90) or ""), Coast.Mirrored and ", mirrored" or "", Coast.Satellites, Coast.Satellites == 1 and "" or "s", Coast.Icebergs, Coast.Icebergs == 1 and "" or "s");
        local Stats = p215.Stats;

        for i = 1, 3 do
            local v218 = u94["Weight" .. i];
            local v219;

            if v218 then
                v218.Extra = string.format("  -  %d%%", (math.round((Stats.Shares[i] or 0) * 100)));
                v218.Set(v218.Value);
                v219 = i;
            else
                v219 = i;
            end;
        end;

        local v220 = {};
        local string_format = string.format;
        local math_round_ret = math.round(Stats.Land * 100);
        local v221 = p215.Grid.Cols - 1;
        v220[1], v220[2] = string_format("Land: <b>%d%%</b> of the grid  |  grid A-%s by 0-%d, %d-stud cells", math_round_ret, string.rep(string.char(v221 % 26 + 65), v221 // 26 + 1), p215.Grid.Rows - 1, (math.round(p215.Grid.Cell))), string.format("Monuments: <b>%d / %d</b> placed", Stats.Placed, Stats.Total);

        for _, v in Stats.TierPlan or {} do
            table.insert(v220, v);
        end;

        if Stats.Dropped and #Stats.Dropped > 0 then
            table.insert(v220, string.format("<font color=\"#F0B228\">Not on this map (%d): %s</font>", #Stats.Dropped, table.concat(Stats.Dropped, ", ")));
        end;

        if Stats.Swapped and #Stats.Swapped > 0 then
            local v222 = "<font color=\"#F0B228\">No room, swapped: " .. table.concat(Stats.Swapped, ", ") .. "</font>";
            table.insert(v220, v222);
        end;

        if #Stats.Skipped > 0 then
            local v223 = "<font color=\"#E8403A\">No room for: " .. table.concat(Stats.Skipped, ", ") .. "</font>";
            table.insert(v220, v223);
        end;

        if #Stats.Relaxed > 0 then
            local v224 = "<font color=\"#A5A5AC\">Squeezed in: " .. table.concat(Stats.Relaxed, ", ") .. "</font>";
            table.insert(v220, v224);
        end;

        u86.Stats.Text = table.concat(v220, "\n");
        u91.DrawPaint();
    end;

    function u91.RequestPreview() -- Line: 892
        -- upvalues: u81 (ref), u86 (copy), u91 (copy), SeedLab (copy), Panel (copy), u1 (ref)
        if u81.InFlight then
            u81.Again = true;

            return;
        end;

        u81.InFlight = true;
        u86.BusyText.Text = "Working it out...";
        u86.BusyCover.Visible = true;
        task.spawn(function() -- Line: 900
            -- upvalues: u81 (ref), u91 (ref), SeedLab (ref), Panel (ref), u1 (ref), u86 (ref)
            while true do
                u81.Again = false;
                local v225 = u91.Request();
                local success, result = pcall(SeedLab.InvokeServer, SeedLab, "Preview", v225);

                if not u81.Again and Panel.Parent then
                    if success and (type(result) == "table" and not result.Error) then
                        u91.ShowPreview(result);
                    else
                        u91.SetStatus("Preview failed: " .. tostring(success and (result and result.Error) or "no answer"), u1.Danger);
                    end;
                end;

                if not u81.Again then
                    u81.InFlight = false;

                    if Panel.Parent then
                        u86.BusyCover.Visible = u81.Routing;
                    end;

                    return;
                end;
            end;
        end);
    end;

    function u91.PaintGrid() -- Line: 922
        -- upvalues: u81 (ref)
        local v226 = u81.Defaults and u81.Defaults.PaintN or 64;

        if not u81.Paint or u81.PaintN ~= v226 then
            u81.Paint = table.create(v226 * v226, 0);
            u81.PaintN = v226;
        end;

        return u81.Paint, v226;
    end;

    function u91.PaintText() -- Line: 929
        -- upvalues: u91 (copy)
        local v227, v228 = u91.PaintGrid();
        local table_create_ret = table.create(v228 * v228);
        local v229 = false;

        for i = 1, v228 * v228 do
            local v230 = v227[i];
            table_create_ret[i] = string.char(48 + v230);
            local v231;

            if v230 > 0 then
                v231 = i;
                v229 = true;
            else
                v231 = i;
            end;
        end;

        return v229 and table.concat(table_create_ret) or nil;
    end;

    function u91.Tool() -- Line: 941
        -- upvalues: u4 (ref), u81 (ref)
        for _, v in u4 do
            if v.Name == u81.Tool then
                return v;
            end;
        end;

        return u4[1];
    end;

    function u91.DrawPaint() -- Line: 950
        -- upvalues: u91 (copy), u81 (ref), u86 (copy), AssetService (ref), u5 (ref), math_floor (ref)
        local v232, u233 = u91.PaintGrid();
        local Current = u81.Current;
        local v234 = 0;

        for i = 1, u233 * u233 do
            local v235;

            if v232[i] > 0 then
                v234 = v234 + 1;
                v235 = i;
            else
                v235 = i;
            end;
        end;

        local PaintInfo = u86.PaintInfo;
        local v236;

        if v234 > 0 then
            local string_format = string.format;
            local math_round_ret = math.round(v234 / (u233 * u233) * 100);
            v236 = string_format("<b>%d%%</b> of the map painted", (math.max(1, math_round_ret))) or "Nothing painted - the seed lays the biomes out";
        else
            v236 = "Nothing painted - the seed lays the biomes out";
        end;

        PaintInfo.Text = v236;

        if v234 == 0 or not (Current and Current.MapSize) then
            u86.PaintLayer.Visible = false;

            return;
        end;

        if not u81.PaintImage then
            local success, result = pcall(function() -- Line: 966
                -- upvalues: AssetService (ref), u233 (copy)
                return AssetService:CreateEditableImage({
                    Size = Vector2.new(u233, u233)
                });
            end);

            if not (success and result) then
                return;
            end;

            u81.PaintImage = result;
        end;

        u86.PaintLayer.ImageContent = Content.fromObject(u81.PaintImage);
        local buffer_create_ret = buffer.create(u233 * u233 * 4);

        for i = 1, u233 * u233 do
            local v237 = v232[i];
            local v238;

            if v237 > 0 then
                local v239 = (i - 1) % u233;
                local v240 = (i - 1) // u233;
                local v241 = (v239 == 0 or (v240 == 0 or (v239 == u233 - 1 or (v240 == u233 - 1 or (v232[i - 1] ~= v237 or (v232[i + 1] ~= v237 or v232[i - u233] ~= v237)))))) and true or v232[i + u233] ~= v237;
                local v242 = u5[v237] or Color3.new(1, 1, 1);
                local v243 = (i - 1) * 4;
                local v244 = math_floor(v242.R * 255);
                buffer.writeu8(buffer_create_ret, v243, v244);
                local v245 = math_floor(v242.G * 255);
                buffer.writeu8(buffer_create_ret, v243 + 1, v245);
                local v246 = math_floor(v242.B * 255);
                buffer.writeu8(buffer_create_ret, v243 + 2, v246);
                buffer.writeu8(buffer_create_ret, v243 + 3, v241 and 215 or 105);
                v238 = i;
            else
                v238 = i;
            end;
        end;

        u81.PaintImage:WritePixelsBuffer(Vector2.zero, Vector2.new(u233, u233), buffer_create_ret);
        local v247 = Current.MapSize / 2;
        u86.PaintLayer.Position = UDim2.fromScale((-v247 - (Current.CX - Current.Side / 2)) / Current.Side, (-v247 - (Current.CZ - Current.Side / 2)) / Current.Side);
        u86.PaintLayer.Size = UDim2.fromScale(Current.MapSize / Current.Side, Current.MapSize / Current.Side);
        u86.PaintLayer.Visible = true;
    end;

    function u91.PaintAt(p248) -- Line: 998
        -- upvalues: u81 (ref), u91 (copy), math_floor (ref)
        local Current = u81.Current;
        local v249 = u91.Tool();

        if not (Current and (Current.MapSize and v249.Biome)) then
            return;
        end;

        local v250, v251 = u91.PaintGrid();
        local v252, v253 = u91.WorldAt(p248);
        local v254 = Current.MapSize / 2;
        local v255 = (v252 / v254 + 1) * 0.5 * v251;
        local v256 = (v253 / v254 + 1) * 0.5 * v251;
        local v257 = u81.Brush - 0.5;
        local v258 = false;

        for i = math_floor(v256 - v257), math_floor(v256 + v257) do
            local v259 = i;

            for i2 = math_floor(v255 - v257), math_floor(v255 + v257) do
                local v260;

                if i2 >= 0 and (v259 >= 0 and (i2 < v251 and v259 < v251)) then
                    local v261 = i2 + 0.5 - v255;
                    local v262 = v259 + 0.5 - v256;

                    if v261 * v261 + v262 * v262 <= v257 * v257 + 0.25 then
                        local v263 = v259 * v251 + i2 + 1;

                        if v250[v263] == v249.Biome then
                            v260 = i2;
                        else
                            v250[v263] = v249.Biome;
                            v260 = i2;
                            v258 = true;
                        end;
                    else
                        v260 = i2;
                    end;
                else
                    v260 = i2;
                end;
            end;
        end;

        if v258 then
            u81.PaintDirty = true;
            u91.DrawPaint();
        end;
    end;

    function u91.ShowBrush(p264) -- Line: 1030
        -- upvalues: u91 (copy), u81 (ref), u86 (copy), Canvas (copy), MapUIStyle (ref), u92 (copy), u5 (ref)
        local v265 = u91.Tool();
        local Current = u81.Current;

        if not (v265.Biome and (Current and (Current.MapSize and u81.Open))) then
            u86.Brush.Visible = false;

            return;
        end;

        local v266 = (p264 - Canvas.AbsolutePosition) / MapUIStyle.Scale;

        if v266.X < 0 or (v266.Y < 0 or (v266.X > 454 or v266.Y > 454)) then
            u86.Brush.Visible = false;

            return;
        end;

        local _, v267 = u91.PaintGrid();
        local math_max_ret = math.max((u81.Brush * 2 - 1) * (Current.MapSize / v267 / Current.Side * 454 * u92.Zoom), 6);
        u86.Brush.Size = UDim2.fromOffset(math_max_ret, math_max_ret);
        u86.Brush.Position = UDim2.fromOffset(v266.X, v266.Y);
        u86.Brush.BackgroundColor3 = u5[v265.Biome] or Color3.new(1, 1, 1);
        u86.Brush.Visible = true;
    end;

    function u91.SetTool(p268: string) -- Line: 1050
        -- upvalues: u81 (ref), u86 (copy), u93 (copy)
        u81.Tool = p268;

        for i, v in u86.ToolButtons do
            v.Picked.Enabled = i == p268;
        end;

        for _, v in u93 do
            v.Button.Interactable = p268 == "Move";
        end;

        if p268 == "Move" then
            u86.Brush.Visible = false;
        end;
    end;

    for _, v in u4 do
        local v269 = u86.ToolButtons[v.Name].Activated:Connect(function() -- Line: 1064
            -- upvalues: u91 (copy), v (copy)
            u91.SetTool(v.Name);
        end);
        table.insert(u87, v269);
    end;

    local v273 = u86.ClearPaint.Activated:Connect(function() -- Line: 1068
        -- upvalues: u91 (copy), u81 (ref)
        local v270, v271 = u91.PaintGrid();
        local v272 = false;

        for i = 1, v271 * v271 do
            v272 = v272 or v270[i] > 0;
            v270[i] = 0;
            local _ = i;
        end;

        u91.DrawPaint();

        if v272 and u81.Params then
            u91.RequestPreview();
        end;
    end);
    table.insert(u87, v273);

    function u91.ShowShape() -- Line: 1082
        -- upvalues: u81 (ref), u86 (copy), u94 (copy)
        local v274 = u81.Params and u81.Params.Shape;

        if v274 then
            u86.ShapeThumb.Image = "rbxassetid://" .. tostring(v274.Id);
            u86.ShapeBox.Text = tostring(v274.Id);
            u86.ShapeInfo.Text = u81.ShapeNote or string.format("Image <b>%d</b> is the island\'s outline.", v274.Id);
        else
            u86.ShapeThumb.Image = "";
            u86.ShapeInfo.Text = "None: the seed picks the outline. Paste an image\'s id (up to 1024 a side, kept to its own proportions) - opaque is land, transparent is sea.";
        end;

        if u94.ShapeScale then
            u94.ShapeScale.Set(v274 and v274.Scale or 0.9);
        end;

        for _, v in { "IslandScale", "Template" } do
            if u94[v] then
                u94[v].Set(u94[v].Value);
            end;
        end;
    end;

    function u91.LoadShape() -- Line: 1102
        -- upvalues: u81 (ref), u86 (copy), SeedLab (copy), Panel (copy), u94 (copy), u91 (copy)
        if not u81.Params then
            return;
        end;

        local v275 = nil;

        for i in u86.ShapeBox.Text:gmatch("%d+") do
            if not v275 or #i > #v275 then
                v275 = i;
            end;
        end;

        local u276 = tonumber(v275);

        if not u276 then
            u86.ShapeInfo.Text = "<font color=\"#E8403A\">Paste the alpha map\'s image id first.</font>";

            return;
        end;

        u86.ShapeInfo.Text = "Reading the image...";
        task.spawn(function() -- Line: 1118
            -- upvalues: SeedLab (ref), u276 (ref), Panel (ref), u81 (ref), u94 (ref), u91 (ref), u86 (ref)
            local success, result = pcall(SeedLab.InvokeServer, SeedLab, "LoadShape", u276);

            if not Panel.Parent then
                return;
            end;

            if not (success and (type(result) == "table" and not result.Error)) then
                u86.ShapeInfo.Text = "<font color=\"#E8403A\">" .. tostring(success and (result and result.Error) or "No answer from the server.") .. "</font>";

                return;
            end;

            local v277 = u81.Params.Shape == nil;
            u81.Params.Shape = {
                Id = result.Id,
                Scale = u81.Params.Shape and u81.Params.Shape.Scale or 0.9
            };
            u81.ShapeNote = string.format("<b>%d x %d</b>, read by its %s  |  <b>%d%%</b> land", result.Width or result.Size, result.Height or result.Size, tostring(result.Mode), (math.round((result.Land or 0) * 100)));

            if v277 then
                local Params = u81.Params;
                u81.Params.Satellites = 0;
                Params.Icebergs = 0;
                u94.Satellites.Set(0);
                u94.Icebergs.Set(0);
                local v278 = u81;
                v278.ShapeNote = v278.ShapeNote .. "  |  satellites and icebergs off (below)";
            end;

            table.clear(u81.Edits);
            u91.ShowShape();
            u91.RequestPreview();
        end);
    end;

    local v279 = u86.ShapeLoad.Activated:Connect(u91.LoadShape);
    table.insert(u87, v279);
    local v281 = u86.ShapeBox.FocusLost:Connect(function(p280) -- Line: 1144
        -- upvalues: u91 (copy)
        if p280 then
            u91.LoadShape();
        end;
    end);
    table.insert(u87, v281);
    local v282 = u86.ShapeClear.Activated:Connect(function() -- Line: 1149
        -- upvalues: u81 (ref), u86 (copy), u91 (copy)
        if not (u81.Params and u81.Params.Shape) then
            u86.ShapeBox.Text = "";

            return;
        end;

        u81.Params.Shape = nil;
        u81.ShapeNote = nil;
        u86.ShapeBox.Text = "";
        table.clear(u81.Edits);
        u91.ShowShape();
        u91.RequestPreview();
    end);
    table.insert(u87, v282);

    function u91.Segment(p283: any, p284: number, p285: number, p286: number, p287: number, p288: number, p289) -- Line: 1165
        -- upvalues: u86 (copy)
        local v290 = 454 / p283.Side;
        local v291 = p283.CX - p283.Side / 2;
        local v292 = p283.CZ - p283.Side / 2;
        local v293 = (p284 - v291) * v290;
        local v294 = (p285 - v292) * v290;
        local v295 = (p286 - v291) * v290;
        local v296 = (p287 - v292) * v290;
        local v297 = v295 - v293;
        local v298 = v296 - v294;
        local math_sqrt_ret = math.sqrt(v297 * v297 + v298 * v298);

        if math_sqrt_ret < 0.01 then
            return;
        end;

        local v299 = u86.RouteTemplate:Clone();
        v299.Position = UDim2.fromScale((v293 + v295) / 2 / 454, (v294 + v296) / 2 / 454);
        v299.Size = UDim2.new(math_sqrt_ret / 454, p288 * 0.6, 0, p288);
        local math_atan2_ret = math.atan2(v298, v297);
        v299.Rotation = math.deg(math_atan2_ret);
        v299.BackgroundColor3 = p289;
        v299.Visible = true;
        v299.Parent = u86.RoutesLayer;
    end;

    function u91.Polyline(p300: any, p301: any, p302: number, p303) -- Line: 1184
        -- upvalues: u91 (copy)
        for i = 1, #p301 - 3, 2 do
            u91.Segment(p300, p301[i], p301[i + 1], p301[i + 2], p301[i + 3], p302, p303);
            local _ = i;
        end;
    end;

    function u91.FadeRoutes(p304: number) -- Line: 1189
        -- upvalues: u86 (copy)
        for _, child in u86.RoutesLayer:GetChildren() do
            if child:IsA("Frame") then
                child.BackgroundTransparency = p304;
            end;
        end;
    end;

    function u91.ClearRoutes() -- Line: 1196
        -- upvalues: u81 (ref), u86 (copy)
        u81.Routes = nil;
        u86.RoutesLayer:ClearAllChildren();
        u86.RoutesButton.Text = u81.Routing and "WORKING..." or "SHOW ROADS & RIVERS";
        u86.RoutesInfo.Text = "Works them out for real - about 30 s (the server works hard meanwhile)";
    end;

    function u91.MarkRoutesStale() -- Line: 1202
        -- upvalues: u81 (ref), u91 (copy), u86 (copy)
        local v305 = u81;
        v305.EditVersion = v305.EditVersion + 1;

        if u81.Routes and not u81.Routes.Stale then
            u81.Routes.Stale = true;
            u91.FadeRoutes(0.65);
            u86.RoutesButton.Text = "UPDATE ROADS & RIVERS";
            u86.RoutesInfo.Text = "<font color=\"#F0B228\">Out of date - the monuments moved</font>";
        end;
    end;

    function u91.DrawRoutes(p306, p307) -- Line: 1211
        -- upvalues: u86 (copy), u91 (copy), math_clamp (ref), u1 (ref)
        u86.RoutesLayer:ClearAllChildren();

        for _, v in p307.Rivers do
            u91.Polyline(p306, v.P, math_clamp(v.W / p306.Side * 454, 2, 5), u1.River);
        end;

        for _, v in p307.Roads do
            if v.Dirt then
                u91.Polyline(p306, v.P, 1.5, u1.Dirt);
            end;
        end;

        for _, v in p307.Roads do
            if not v.Dirt then
                u91.Polyline(p306, v.P, 2.5, u1.Road);
            end;
        end;
    end;

    local v309 = u86.RoutesButton.Activated:Connect(function() -- Line: 1227
        -- upvalues: u81 (ref), u91 (copy), u86 (copy), SeedLab (copy), Panel (copy), u1 (ref)
        if u81.Routing or (not u81.Current or u81.InFlight) then
            return;
        end;

        if u81.Routes and not u81.Routes.Stale then
            u91.ClearRoutes();

            return;
        end;

        u81.Routing = true;
        local PreviewVersion = u81.PreviewVersion;
        local EditVersion = u81.EditVersion;
        local Current = u81.Current;
        u86.BusyText.Text = "Working out the roads and rivers...\nthe real height, lake, road and river passes - about 30 s";
        u86.BusyCover.Visible = true;
        u86.RoutesButton.Text = "WORKING...";
        local u308 = u91.Request();
        task.spawn(function() -- Line: 1242
            -- upvalues: SeedLab (ref), u308 (copy), u81 (ref), Panel (ref), u86 (ref), PreviewVersion (copy), u91 (ref), u1 (ref), Current (copy), EditVersion (copy)
            local success, result = pcall(SeedLab.InvokeServer, SeedLab, "Routes", u308, u81.Edits);
            u81.Routing = false;

            if not Panel.Parent then
                return;
            end;

            u86.BusyText.Text = "Working it out...";
            u86.BusyCover.Visible = u81.InFlight;

            if PreviewVersion ~= u81.PreviewVersion then
                u91.ClearRoutes();

                return;
            end;

            if not (success and (type(result) == "table" and not result.Error)) then
                u91.SetStatus("Roads and rivers failed: " .. tostring(success and (result and result.Error) or "no answer"), u1.Danger);
                u91.ClearRoutes();

                return;
            end;

            Current.Cells = result.Cells;
            u91.DrawCells(Current);
            u81.Routes = {
                Stale = false,
                Data = result
            };
            u91.DrawRoutes(Current, result);
            u91.RelayoutSites();
            u86.RoutesButton.Text = "HIDE ROADS & RIVERS";
            u86.RoutesInfo.Text = string.format("<b>%d</b> roads, %.1f km  |  <b>%d</b> rivers, %.1f km%s  <font color=\"#A5A5AC\">(%d s)</font>", #result.Roads, (result.RoadLength or 0) / 1000, #result.Rivers, (result.RiverLength or 0) / 1000, (result.FailedLinks or 0) > 0 and (string.format("  |  <font color=\"#E8403A\">%d links failed</font>", result.FailedLinks) or "") or "", (math.round(result.Seconds or 0)));

            if EditVersion ~= u81.EditVersion then
                u91.MarkRoutesStale();
            end;
        end);
    end);
    table.insert(u87, v309);
    local v323 = UserInputService.InputChanged:Connect(function(p310) -- Line: 1277
        -- upvalues: Panel (copy), u81 (ref), Canvas (copy), MapUIStyle (ref), u91 (copy), u92 (copy), math_clamp (ref), u86 (copy)
        if p310.UserInputType ~= Enum.UserInputType.MouseMovement and p310.UserInputType ~= Enum.UserInputType.MouseWheel then
            return;
        end;

        if not (Panel.Visible and u81.Open) then
            return;
        end;

        local Vector2_new_ret = Vector2.new(p310.Position.X, p310.Position.Y);

        if p310.UserInputType == Enum.UserInputType.MouseWheel then
            local v311 = (Vector2_new_ret - Canvas.AbsolutePosition) / MapUIStyle.Scale;

            if v311.X >= 0 and (v311.Y >= 0 and (v311.X <= 454 and v311.Y <= 454)) then
                u91.ZoomAbout(u92.Zoom * (p310.Position.Z > 0 and 1.25 or 0.8), v311.X, v311.Y);
            end;

            return;
        end;

        if u81.Painting then
            u91.PaintAt(Vector2_new_ret);
        end;

        u91.ShowBrush(Vector2_new_ret);

        if u92.PanFrom then
            local v312 = (Vector2_new_ret - u92.PanFrom[1]) / MapUIStyle.Scale;
            local v313 = u92.PanFrom[3] + v312.Y;
            u92.X = u92.PanFrom[2] + v312.X;
            u92.Y = v313;
            u91.ApplyView();
        end;

        if u92.Slider then
            u92.Slider.FromX(Vector2_new_ret.X);
        end;

        local Drag = u92.Drag;

        if Drag and u81.Current then
            local Site = Drag.Entry.Site;
            local _, _, _, _, v314 = u91.Placement(Site);
            local v315, v316 = u91.WorldAt(Vector2_new_ret);
            local v317 = u81.Current.TotalExtent / 2;
            local v318 = math_clamp(math.round((v315 - Drag.OffX) / 4) * 4, -v317, v317);
            local v319 = math_clamp(math.round((v316 - Drag.OffZ) / 4) * 4, -v317, v317);
            u81.Edits[Site.Name] = {
                X0 = v318,
                Z0 = v319,
                Rot = v314
            };
            u91.LayoutSite(Drag.Entry);
            u91.ShowTip(Drag.Entry);
        end;

        if u86.Tip.Visible then
            local AbsolutePosition = Canvas.AbsolutePosition;
            local Scale = MapUIStyle.Scale;
            local v320 = u86.Tip.AbsoluteSize.Y / Scale;
            local v321 = math_clamp((Vector2_new_ret.X - AbsolutePosition.X) / Scale + 14, 0, (math.max(454 - u86.Tip.AbsoluteSize.X / Scale, 0)));
            local v322 = math_clamp((Vector2_new_ret.Y - AbsolutePosition.Y) / Scale - v320 - 10, 0, (math.max(454 - v320, 0)));
            u86.Tip.Position = UDim2.fromOffset(v321, v322);
        end;
    end);
    table.insert(u87, v323);
    local v325 = UserInputService.InputEnded:Connect(function(p324) -- Line: 1325
        -- upvalues: u92 (copy), u81 (ref), u91 (copy), u86 (copy)
        local UserInputType = p324.UserInputType;

        if UserInputType == Enum.UserInputType.MouseButton1 or (UserInputType == Enum.UserInputType.MouseButton2 or UserInputType == Enum.UserInputType.MouseButton3) then
            u92.PanFrom = nil;
        end;

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
            if u81.Painting then
                u81.Painting = false;

                if u81.PaintDirty then
                    u81.PaintDirty = false;
                    u91.RequestPreview();
                end;
            end;

            if u92.Slider then
                local Slider = u92.Slider;
                u92.Slider = nil;
                Slider.Light();
                Slider.Commit();
            end;

            if u92.Drag then
                u92.Drag = nil;
                u91.RelayoutSites();
                u91.MarkRoutesStale();

                if not u92.Hovered then
                    u86.Tip.Visible = false;
                end;
            end;
        end;
    end);
    table.insert(u87, v325);
    local v328 = UserInputService.InputBegan:Connect(function(p326, p327) -- Line: 1354
        -- upvalues: u81 (ref), Panel (copy), u92 (copy), u91 (copy)
        if p326.KeyCode == Enum.KeyCode.R and (not p327 and (u81.Open and (Panel.Visible and u92.Hovered))) then
            u91.RotateSite(u92.Hovered.Site);
        end;
    end);
    table.insert(u87, v328);

    function u91.SyncSliders() -- Line: 1361
        -- upvalues: u81 (ref), u94 (copy), u3 (ref), u86 (copy), u91 (copy)
        local Params = u81.Params;
        u94.MapSize.Set(Params.MapSize);
        u94.IslandScale.Set(Params.IslandScale);
        u94.Template.Set(Params.Template);
        u94.Satellites.Set(Params.Satellites);
        u94.Icebergs.Set(Params.Icebergs);

        for i = 1, #u3 do
            local v329 = u94["Tier" .. i - 1];
            local v330;

            if v329 then
                v329.Set(Params["Tier" .. i - 1] or -1);
                v330 = i;
            else
                v330 = i;
            end;
        end;

        if u94["Weight" .. 1] then
            u94["Weight" .. 1].Set(Params.Weights[1]);
        end;

        if u94["Weight" .. 2] then
            u94["Weight" .. 2].Set(Params.Weights[2]);
        end;

        if u94["Weight" .. 3] then
            u94["Weight" .. 3].Set(Params.Weights[3]);
        end;

        u86.SeedBox.Text = tostring(Params.Seed);

        if u94.Brush then
            u94.Brush.Set(u81.Brush);
        end;

        u91.ShowShape();
    end;

    function u91.NewSeed(p331: number) -- Line: 1385
        -- upvalues: u81 (ref), u86 (copy), u91 (copy)
        u81.Params.Seed = p331;
        u86.SeedBox.Text = tostring(p331);
        table.clear(u81.Edits);
        u91.RequestPreview();
    end;

    local v332 = u86.Random.Activated:Connect(function() -- Line: 1391
        -- upvalues: u81 (ref), u91 (copy)
        if u81.Params then
            u91.NewSeed(Random.new():NextInteger(1, 99999999));
        end;
    end);
    table.insert(u87, v332);
    local v333 = u86.Current.Activated:Connect(function() -- Line: 1396
        -- upvalues: u81 (ref), u91 (copy), u1 (ref)
        local Defaults = u81.Defaults;

        if Defaults then
            Defaults = Defaults.Current;
        end;

        if type(Defaults) ~= "number" then
            u91.SetStatus("The map in play has no seed yet - it is still loading.", u1.Danger);

            return;
        end;

        u91.SetStatus(string.format("Showing the map in play: seed %d.", Defaults));
        u91.StartFromCurrent();
        u91.SyncSliders();
        u91.RequestPreview();
    end);
    table.insert(u87, v333);
    local v336 = u86.SeedBox.FocusLost:Connect(function() -- Line: 1408
        -- upvalues: u81 (ref), u86 (copy), math_floor (ref), u91 (copy)
        if not u81.Params then
            return;
        end;

        local v334 = u86.SeedBox.Text:gsub("%D", "");
        local v335 = tonumber(v334);

        if v335 and (v335 >= 1 and v335 <= 99999999) then
            if math_floor(v335) ~= u81.Params.Seed then
                u91.NewSeed((math_floor(v335)));
            end;
        else
            u86.SeedBox.Text = tostring(u81.Params.Seed);
        end;
    end);
    table.insert(u87, v336);
    local v337 = u86.ResetSites.Activated:Connect(function() -- Line: 1421
        -- upvalues: u81 (ref), u91 (copy)
        table.clear(u81.Edits);
        u91.RelayoutSites();
        u91.MarkRoutesStale();
    end);
    table.insert(u87, v337);
    local v340 = u86.Defaults.Activated:Connect(function() -- Line: 1426
        -- upvalues: u81 (ref), u3 (ref), u91 (copy)
        local Defaults = u81.Defaults;

        if not (Defaults and u81.Params) then
            return;
        end;

        local Params = u81.Params;
        local IslandScale = Defaults.IslandScale;
        Params.MapSize = Defaults.MapSize;
        Params.IslandScale = IslandScale;
        Params.Template = 0;
        Params.Satellites = -1;
        Params.Icebergs = -1;

        for i = 1, #u3 do
            Params["Tier" .. i - 1] = -1;
            local _ = i;
        end;

        Params.Weights = table.clone(Defaults.Weights);
        Params.Shape = nil;
        u81.ShapeNote = nil;
        local v338, v339 = u91.PaintGrid();

        for i = 1, v339 * v339 do
            v338[i] = 0;
            local _ = i;
        end;

        table.clear(u81.Edits);
        u91.SyncSliders();
        u91.ShowShape();
        u91.RequestPreview();
    end);
    table.insert(u87, v340);

    function u91.StartFromCurrent() -- Line: 1449
        -- upvalues: u81 (ref), u3 (ref), u91 (copy)
        local Defaults = u81.Defaults;
        local v341;

        if type(Defaults.CurrentParams) == "table" then
            v341 = Defaults.CurrentParams or nil;
        else
            v341 = nil;
        end;

        u81.Params = {
            Seed = type(Defaults.Current) == "number" and Defaults.Current or Defaults.Seed,
            MapSize = v341 and v341.MapSize or Defaults.MapSize,
            IslandScale = v341 and v341.IslandScale or Defaults.IslandScale,
            Template = v341 and (v341.Template or 0) or 0,
            Satellites = v341 and (v341.Satellites or -1) or -1,
            Icebergs = v341 and (v341.Icebergs or -1) or -1,
            Weights = table.clone(v341 and v341.Weights or Defaults.Weights)
        };

        for i = 1, #u3 do
            local v342 = "Tier" .. i - 1;
            u81.Params[v342] = v341 and (tonumber(v341[v342]) or -1) or -1;
            local _ = i;
        end;

        if v341 and (type(v341.Shape) == "table" and tonumber(v341.Shape.Id)) then
            u81.Params.Shape = {
                Id = tonumber(v341.Shape.Id),
                Scale = tonumber(v341.Shape.Scale) or 0.9
            };
        end;

        u81.ShapeNote = nil;
        local v343, v344 = u91.PaintGrid();
        local v345;

        if v341 and (type(v341.Paint) == "string" and #v341.Paint == v344 * v344) then
            v345 = v341.Paint or nil;
        else
            v345 = nil;
        end;

        for i = 1, v344 * v344 do
            v343[i] = v345 and (string.byte(v345, i) - 48 or 0) or 0;
            local _ = i;
        end;

        table.clear(u81.Edits);

        if type(Defaults.CurrentEdits) == "table" then
            for i, v in Defaults.CurrentEdits do
                u81.Edits[i] = v;
            end;
        end;
    end;

    function u91.RefreshRegenerate() -- Line: 1480
        -- upvalues: u81 (ref), u86 (copy), MapUIStyle (ref), u1 (ref)
        if u81.Regenerating then
            u86.Regenerate.Text = "REGENERATING...";
            MapUIStyle.Fill(u86.Regenerate, u1.Field);
            u86.RegenerateGlow.ImageColor3 = u1.Field;
            u86.Regenerate.AutoButtonColor = false;

            return;
        end;

        u86.Regenerate.Text = "REGENERATE MAP";
        MapUIStyle.Fill(u86.Regenerate, u1.Go);
        u86.RegenerateGlow.ImageColor3 = u1.Go;
        u86.Regenerate.AutoButtonColor = true;
    end;

    local v348 = u86.Regenerate.Activated:Connect(function() -- Line: 1493
        -- upvalues: u81 (ref), u91 (copy), u86 (copy)
        if u81.Regenerating or not (u81.Params and (u81.Current and not u81.InFlight)) then
            return;
        end;

        local Params = u81.Params;
        local _ = u81.Current;
        local v346 = 0;

        for _ in u81.Edits do
            v346 = v346 + 1;
        end;

        local v347 = {};

        if Params.Shape then
            table.insert(v347, "its alpha map outline");
        end;

        if u91.PaintText() then
            table.insert(v347, "the painted biomes");
        end;

        if v346 > 0 then
            table.insert(v347, string.format("%d moved monument%s", v346, v346 == 1 and "" or "s"));
        end;

        u86.ConfirmText.Text = string.format("The map is rebuilt on seed <b>%d</b>%s, <b>live</b>: everyone stays in, waits under the loading screen and lands on the new map\'s nearest beach.\n\n<font color=\"#F0B228\">The world is wiped: every base, bag, bed, deployable, drop and vehicle goes with the old map.</font>", Params.Seed, #v347 > 0 and ", with " .. table.concat(v347, ", ") or "");
        u86.Confirm.Visible = true;
    end);
    table.insert(u87, v348);
    local v349 = u86.ConfirmCancel.Activated:Connect(function() -- Line: 1519
        -- upvalues: u86 (copy)
        u86.Confirm.Visible = false;
    end);
    table.insert(u87, v349);
    local v350 = u86.Confirm.Activated:Connect(function() -- Line: 1522
        -- upvalues: u86 (copy)
        u86.Confirm.Visible = false;
    end);
    table.insert(u87, v350);
    local v352 = u86.ConfirmGo.Activated:Connect(function() -- Line: 1525
        -- upvalues: u86 (copy), u81 (ref), u91 (copy), u1 (ref), SeedLab (copy), Panel (copy)
        u86.Confirm.Visible = false;

        if u81.Regenerating then
            return;
        end;

        local u351 = u91.Request();
        u81.Regenerating = true;
        u91.RefreshRegenerate();
        u91.SetStatus("Starting the regenerate...", u1.Text);
        task.spawn(function() -- Line: 1534
            -- upvalues: SeedLab (ref), u351 (copy), u81 (ref), Panel (ref), u91 (ref), u1 (ref)
            local success, result = pcall(SeedLab.InvokeServer, SeedLab, "Regenerate", u351, u81.Edits);

            if success and (type(result) == "table" and result.Started) then
                return;
            end;

            u81.Regenerating = false;

            if Panel.Parent then
                u91.SetStatus(tostring(success and (result and result.Error) or "No answer from the server."), u1.Danger);
                u91.RefreshRegenerate();
            end;
        end);
    end);
    table.insert(u87, v352);
    local v355 = SeedLabStatus.OnClientEvent:Connect(function(p353, p354) -- Line: 1546
        -- upvalues: u81 (ref), u91 (copy), u1 (ref), SeedLab (copy)
        if p354 == "error" then
            u81.Regenerating = false;
            u91.SetStatus(tostring(p353), u1.Danger);
        elseif p354 == "done" then
            u81.Regenerating = false;
            u91.SetStatus(tostring(p353), Color3.fromRGB(96, 226, 116));
            task.spawn(function() -- Line: 1554
                -- upvalues: SeedLab (ref), u81 (ref)
                local success, result = pcall(SeedLab.InvokeServer, SeedLab, "Defaults");

                if success and (type(result) == "table" and not result.Error) then
                    u81.Defaults = result;
                end;
            end);
        else
            u91.SetStatus(tostring(p353), u1.Text);
        end;

        u91.RefreshRegenerate();
    end);
    table.insert(u87, v355);

    function u91.Place(p356: boolean) -- Line: 1568
        -- upvalues: MapUIStyle (ref), u84 (copy), Panel (copy)
        local Scale = MapUIStyle.Scale;
        local v357 = u84:FindFirstChild("MapTools") and u84.MapTools:FindFirstChild("Controls");
        local v358 = u84.AbsolutePosition.X + u84.AbsoluteSize.X;
        local v359 = v358 - (v357 and (v357.AbsoluteSize.X > 0 and v357.AbsolutePosition.X) or v358 - 16) + 12 + 26 * Scale;
        local v360 = 12 + 26 * Scale;
        Panel.Size = UDim2.new(0, 500, 1 / Scale, -(v360 + (10 + 32 * Scale + 12 + 26 * Scale)) / Scale);

        return p356 and UDim2.new(1, -v359, 0, v360) or UDim2.new(1, 526 * Scale + 40, 0, v360);
    end;

    local u361 = nil;

    function u91.SetOpen(p362: boolean) -- Line: 1580
        -- upvalues: u81 (ref), u86 (copy), MapUIStyle (ref), u1 (ref), Colours (ref), u361 (ref), Panel (copy), u91 (copy), TweenService (ref)
        u81.Open = p362;
        u86.Chip.Text = p362 and "SEED LAB ON" or "SEED LAB";
        MapUIStyle.Chip(u86.Chip, p362 and u1.Accent or Colours.Grey);

        if u361 then
            u361:Cancel();
        end;

        if p362 then
            Panel.Visible = true;

            if u81.FirstOpen and u81.Defaults then
                u81.FirstOpen = false;
                u91.StartFromCurrent();
                u91.SyncSliders();
                u91.RequestPreview();
            end;
        else
            u86.Confirm.Visible = false;
        end;

        u361 = TweenService:Create(Panel, TweenInfo.new(p362 and 0.32 or 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = u91.Place(p362)
        });
        u361.Completed:Connect(function(p363) -- Line: 1600
            -- upvalues: u81 (ref), Panel (ref)
            if p363 == Enum.PlaybackState.Completed and not u81.Open then
                Panel.Visible = false;
            end;
        end);
        u361:Play();
    end;

    local v364 = u86.Chip.Activated:Connect(function() -- Line: 1607
        -- upvalues: u81 (ref), u91 (copy)
        if u81.Defaults then
            u91.SetOpen(not u81.Open);
        end;
    end);
    table.insert(u87, v364);
    local v365 = u86.Close.Activated:Connect(function() -- Line: 1612
        -- upvalues: u91 (copy)
        u91.SetOpen(false);
    end);
    table.insert(u87, v365);
    local v366 = MapUIStyle.ScaleChanged:Connect(function() -- Line: 1615
        -- upvalues: Panel (copy), u91 (copy), u81 (ref)
        Panel.Position = u91.Place(u81.Open);
    end);
    table.insert(u87, v366);
    local v367 = u84:GetAttributeChangedSignal("Locked"):Connect(function() -- Line: 1619
        -- upvalues: u84 (copy), u81 (ref), u91 (copy)
        if u84:GetAttribute("Locked") == true and u81.Open then
            u91.SetOpen(false);
        end;
    end);
    table.insert(u87, v367);

    function u91.RefreshChip() -- Line: 1625
        -- upvalues: u86 (copy), Players (ref), u81 (ref), u91 (copy)
        local Chip = u86.Chip;
        local v368 = Players.LocalPlayer:GetAttribute("Owner") == true and u81.Defaults ~= nil;
        Chip.Visible = v368;

        if not u86.Chip.Visible and u81.Open then
            u91.SetOpen(false);
        end;
    end;

    local v369 = LocalPlayer:GetAttributeChangedSignal("Owner"):Connect(function() -- Line: 1631
        -- upvalues: u91 (copy), Players (ref), u81 (ref)
        u91.RefreshChip();

        if Players.LocalPlayer:GetAttribute("Owner") == true and not u81.Defaults then
            u91.Fetch();
        end;
    end);
    table.insert(u87, v369);

    function u91.Fetch() -- Line: 1637
        -- upvalues: SeedLab (copy), u81 (ref), u91 (copy), Panel (copy)
        task.spawn(function() -- Line: 1638
            -- upvalues: SeedLab (ref), u81 (ref), u91 (ref), Panel (ref)
            local success, result = pcall(SeedLab.InvokeServer, SeedLab, "Defaults");

            if success and (type(result) == "table" and not result.Error) then
                u81.Defaults = result;
                u81.Regenerating = u81.Regenerating or result.Busy == true;
                u91.Build();
            end;

            if Panel.Parent then
                u91.RefreshChip();
            end;
        end);
    end;

    local u370 = false;

    function u91.Build() -- Line: 1653
        -- upvalues: u370 (ref), u81 (ref), Panel (copy), u91 (copy), slider (copy), math_floor (ref), colName (ref), u3 (ref), u86 (copy), u94 (copy)
        if u370 or not (u81.Defaults and Panel.Parent) then
            return;
        end;

        u370 = true;
        local Defaults = u81.Defaults;

        local function commit(u371: string, u372: boolean?) -- Line: 1659
            -- upvalues: u81 (ref), u91 (ref)
            return function(p373) -- Line: 1660
                -- upvalues: u81 (ref), u371 (copy), u372 (copy), u91 (ref)
                if u81.Params and u81.Params[u371] ~= p373 then
                    u81.Params[u371] = p373;

                    if u372 then
                        table.clear(u81.Edits);
                    end;

                    u91.RequestPreview();
                end;
            end;
        end;

        local u374 = "MapSize";
        local u375 = true;
        slider("MapSize", Defaults.SizeMin, Defaults.SizeMax, 256, function(p376) -- Line: 1670
            -- upvalues: math_floor (ref), colName (ref)
            local v377 = math_floor(p376 * 1.25 / 445.2173913043478 + 0.5);
            local math_max_ret = math.max(1, v377);

            return string.format("%d  -  A-%s", p376, colName(math_max_ret - 1));
        end, function(p378) -- Line: 1660
            -- upvalues: u81 (ref), u374 (copy), u375 (copy), u91 (ref)
            if u81.Params and u81.Params[u374] ~= p378 then
                u81.Params[u374] = p378;

                if u375 then
                    table.clear(u81.Edits);
                end;

                u91.RequestPreview();
            end;
        end);
        local u379 = "IslandScale";
        local u380 = nil;
        slider("IslandScale", 0.8, 1.15, 0.01, function(p381) -- Line: 1674
            -- upvalues: u81 (ref)
            return u81.Params and u81.Params.Shape and "ALPHA MAP" or string.format("%d%%", (math.round(p381 * 100)));
        end, function(p382) -- Line: 1660
            -- upvalues: u81 (ref), u379 (copy), u380 (copy), u91 (ref)
            if u81.Params and u81.Params[u379] ~= p382 then
                u81.Params[u379] = p382;

                if u380 then
                    table.clear(u81.Edits);
                end;

                u91.RequestPreview();
            end;
        end);
        local u383 = "Template";
        local u384 = nil;
        slider("Template", 0, Defaults.Templates, 1, function(p385) -- Line: 1680
            -- upvalues: u81 (ref)
            return u81.Params and u81.Params.Shape and "ALPHA MAP" or (p385 == 0 and "BY SEED" or string.format("#%d", p385));
        end, function(p386) -- Line: 1660
            -- upvalues: u81 (ref), u383 (copy), u384 (copy), u91 (ref)
            if u81.Params and u81.Params[u383] ~= p386 then
                u81.Params[u383] = p386;

                if u384 then
                    table.clear(u81.Edits);
                end;

                u91.RequestPreview();
            end;
        end);
        slider("Brush", 1, 6, 1, function(p387) -- Line: 1686
            return string.format("%d cell%s", p387 * 2 - 1, p387 == 1 and "" or "s");
        end, function(p388) -- Line: 1688
            -- upvalues: u81 (ref)
            u81.Brush = p388;
        end);
        slider("ShapeScale", Defaults.ShapeScaleMin or 0.25, Defaults.ShapeScaleMax or 1.5, 0.01, function(p389) -- Line: 1691
            return string.format("%d%%", (math.round(p389 * 100)));
        end, function(p390) -- Line: 1693
            -- upvalues: u81 (ref), u91 (ref)
            local v391 = u81.Params and u81.Params.Shape;

            if v391 and v391.Scale ~= p390 then
                v391.Scale = p390;
                u91.RequestPreview();
            end;
        end);
        local u392 = "Satellites";
        local u393 = nil;
        slider("Satellites", -1, 6, 1, function(p394) -- Line: 1700
            return p394 < 0 and "BY SEED" or tostring(p394);
        end, function(p395) -- Line: 1660
            -- upvalues: u81 (ref), u392 (copy), u393 (copy), u91 (ref)
            if u81.Params and u81.Params[u392] ~= p395 then
                u81.Params[u392] = p395;

                if u393 then
                    table.clear(u81.Edits);
                end;

                u91.RequestPreview();
            end;
        end);
        local u396 = "Icebergs";
        local u397 = nil;
        slider("Icebergs", -1, 3, 1, function(p398) -- Line: 1703
            return p398 < 0 and "BY SEED" or tostring(p398);
        end, function(p399) -- Line: 1660
            -- upvalues: u81 (ref), u396 (copy), u397 (copy), u91 (ref)
            if u81.Params and u81.Params[u396] ~= p399 then
                u81.Params[u396] = p399;

                if u397 then
                    table.clear(u81.Edits);
                end;

                u91.RequestPreview();
            end;
        end);

        for i = 1, #u3 do
            local u400 = "Tier" .. i - 1;
            local u401 = nil;
            slider("Tier" .. i - 1, -1, Defaults.TierCountMax or 16, 1, function(p402) -- Line: 1707
                return p402 < 0 and "AUTO" or tostring(p402);
            end, function(p403) -- Line: 1660
                -- upvalues: u81 (ref), u400 (copy), u401 (copy), u91 (ref)
                if u81.Params and u81.Params[u400] ~= p403 then
                    u81.Params[u400] = p403;

                    if u401 then
                        table.clear(u81.Edits);
                    end;

                    u91.RequestPreview();
                end;
            end);
            local _ = i;
        end;

        for i = 1, 3 do
            u86.Sliders["Weight" .. i].Title.Text = tostring(Defaults.BiomeNames and Defaults.BiomeNames[i] or "Biome " .. i);
            slider("Weight" .. i, 0.3, 6, 0.1, function(p404) -- Line: 1713
                return string.format("%.1f", p404);
            end, function(p405) -- Line: 1715
                -- upvalues: u81 (ref), i (copy), u91 (ref)
                if u81.Params and u81.Params.Weights[i] ~= p405 then
                    u81.Params.Weights[i] = p405;
                    u91.RequestPreview();
                end;
            end);
            local _ = i;
        end;

        u94.Brush.Set(u81.Brush);
        u91.SetTool(u81.Tool);
        u91.ShowShape();

        if u81.Params then
            u91.SyncSliders();

            if u81.Current then
                local Current = u81.Current;
                local Routes = u81.Routes;
                u91.ShowPreview(Current);

                if Routes then
                    u81.Routes = Routes;
                    u91.DrawRoutes(Current, Routes.Data);

                    if Routes.Stale then
                        u91.FadeRoutes(0.65);
                    end;
                end;
            end;
        end;
    end;

    Panel.Position = u91.Place(false);
    Panel.Visible = false;
    u81.Open = false;
    u86.Confirm.Visible = false;
    u91.SetStatus(u81.StatusText, u81.StatusColour);
    u91.RefreshRegenerate();
    u91.ApplyView();

    if u81.Defaults then
        u91.Build();
    end;

    u91.RefreshChip();

    if Players.LocalPlayer:GetAttribute("Owner") == true and not u81.Defaults then
        u91.Fetch();
    end;

    Panel.Destroying:Connect(function() -- Line: 1757
        -- upvalues: u87 (copy), u83 (ref), u84 (copy)
        for _, v in u87 do
            v:Disconnect();
        end;

        table.clear(u87);

        if u83 == u84 then
            u83 = nil;
        end;
    end);
end;

return u8;
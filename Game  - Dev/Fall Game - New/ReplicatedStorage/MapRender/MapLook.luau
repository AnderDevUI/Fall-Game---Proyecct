-- [PATH] ReplicatedStorage / MapRender / MapLook @Type ModuleScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local AssetService = game:GetService("AssetService");
local MapRenderClient = require(script.Parent:WaitForChild("MapRenderClient"));
local MapTools = require(script.Parent:WaitForChild("MapTools"));
local MapGamepad = require(script.Parent:WaitForChild("MapGamepad"));
local MapUIStyle = require(script.Parent:WaitForChild("MapUIStyle"));
local GuiUtil = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GuiUtil"));
local Items = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Items"));
local ActiveBenchModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ActiveBenchModule"));
local NumberUtil = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("NumberUtil"));
local Values = ReplicatedStorage:WaitForChild("Values");
local MapRemotes = ReplicatedStorage:WaitForChild("MapRemotes");
local LocalPlayer = Players.LocalPlayer;
local math_floor = math.floor;
local math_clamp = math.clamp;
local math_sqrt = math.sqrt;
local math_max = math.max;
local math_min = math.min;
local u1 = {
    BackdropSpan = 11,
    BackdropDarken = 0.08,
    BackdropRes = 192,
    OpenZoom = 5,
    ZoomMin = 2.5,
    ZoomMinUnlocked = 0.2,
    MarkerPx = 26,
    MarkerZoom = 6,
    MarkerZoomExp = 0.2,
    MarkerMin = 16,
    MarkerMax = 34,
    YouZoomedIn = 1.5,
    TeamShare = 0.574,
    ZoneFillTransparency = 0.72,
    RadFillTransparency = 0.8,
    DeathLongAgo = 10800,
    WaterFallback = Color3.fromRGB(50, 73, 108),
    MarkerFill = Color3.fromRGB(255, 204, 41),
    TeamFill = Color3.fromRGB(33, 150, 243),
    ZoneColour = Color3.fromRGB(235, 64, 52),
    RadLow = Color3.fromRGB(255, 214, 10),
    RadHigh = Color3.fromRGB(232, 40, 40),
    RadEdge = Color3.fromRGB(150, 70, 230),
    BarBackdrop = {
        Behind = true,
        Outside = true,
        SliceScale = 0.3,
        Transparency = 0.22
    },
    Staff = { "Owner", "Admin" }
};
local u2 = {};
local u3 = nil;
local u4 = {
    Base = nil,
    Matched = false,
    Image = nil
};
local u5 = {
    Image = nil,
    Px = 0,
    Angle = (1 / 0),
    Fallback = false,
    Label = nil
};
local u6 = {};
local u7 = {
    Locked = true,
    Zones = false,
    ZoneList = nil,
    ZoneAsking = false,
    Spawns = false,
    SpawnList = nil,
    SpawnAsking = false,
    Radiation = false,
    RadList = nil,
    RadAsking = false
};
local u8 = {};

local function _(p9, p10: number) -- Line: 102
    return Color3.new(p9.R * (1 - p10), p9.G * (1 - p10), p9.B * (1 - p10));
end;

local function _() -- Line: 106
    -- upvalues: u1 (copy), LocalPlayer (copy)
    for _, v in u1.Staff do
        if LocalPlayer:GetAttribute(v) == true then
            return true;
        end;
    end;

    return false;
end;

local function u25(p11) -- Line: 117
    -- upvalues: u4 (copy), AssetService (copy), u1 (copy), math_max (copy), math_sqrt (copy), math_clamp (copy), math_floor (copy)
    u4.Base = p11;

    if not u4.Image then
        local success, result = pcall(function() -- Line: 120
            -- upvalues: AssetService (ref), u1 (ref)
            return AssetService:CreateEditableImage({
                Size = Vector2.new(u1.BackdropRes, u1.BackdropRes)
            });
        end);

        if success and result then
            u4.Image = result;
        end;
    end;

    local Image = u4.Image;

    if not Image then
        return;
    end;

    local BackdropRes = u1.BackdropRes;
    local BackdropSpan = u1.BackdropSpan;
    local buffer_create_ret = buffer.create(BackdropRes * BackdropRes * 4);
    local v12 = BackdropSpan / 2 - 0.5;
    local v13 = p11.R * 255;
    local v14 = p11.G * 255;
    local v15 = p11.B * 255;

    for i = 0, BackdropRes - 1 do
        local v16 = math_max(math.abs(((i + 0.5) / BackdropRes - 0.5) * BackdropSpan) - 0.5, 0);
        local v17 = i;

        for i2 = 0, BackdropRes - 1 do
            local v18 = math_max(math.abs(((i2 + 0.5) / BackdropRes - 0.5) * BackdropSpan) - 0.5, 0);
            local v19 = math_clamp(math_sqrt(v18 * v18 + v16 * v16) / v12, 0, 1);
            local v20 = 1 - u1.BackdropDarken * (v19 * v19 * (3 - v19 * 2));
            local v21 = (v17 * BackdropRes + i2) * 4;
            local v22 = math_floor(v13 * v20 + 0.5);
            buffer.writeu8(buffer_create_ret, v21, v22);
            local v23 = math_floor(v14 * v20 + 0.5);
            buffer.writeu8(buffer_create_ret, v21 + 1, v23);
            local v24 = math_floor(v15 * v20 + 0.5);
            buffer.writeu8(buffer_create_ret, v21 + 2, v24);
            buffer.writeu8(buffer_create_ret, v21 + 3, 255);
            local _ = i2;
        end;
    end;

    Image:WritePixelsBuffer(Vector2.zero, Vector2.new(BackdropRes, BackdropRes), buffer_create_ret);
end;

local function u27() -- Line: 154
    -- upvalues: u3 (ref), u4 (copy), u1 (copy)
    if not u3 then
        return;
    end;

    local v26 = u4.Base or u1.WaterFallback;
    local BackdropDarken = u1.BackdropDarken;
    u3.Map.BackgroundColor3 = Color3.new(v26.R * (1 - BackdropDarken), v26.G * (1 - BackdropDarken), v26.B * (1 - BackdropDarken));

    if u4.Image then
        u3.Ocean.ImageContent = Content.fromObject(u4.Image);
        u3.Ocean.BackgroundTransparency = 1;

        return;
    end;

    u3.Ocean.BackgroundColor3 = v26;
    u3.Ocean.BackgroundTransparency = 0;
end;

local function u30() -- Line: 170
    -- upvalues: u4 (copy), MapRenderClient (copy), u25 (copy), u27 (copy)
    if u4.Matched then
        return;
    end;

    local v28 = MapRenderClient.CornerColour();
    local Info = MapRenderClient.Info;
    local v29;

    if v28 then
        v29 = v28;
    elseif Info and typeof(Info.WaterColour) == "Color3" then
        v29 = Info.WaterColour or nil;
    else
        v29 = nil;
    end;

    if v29 and v29 ~= u4.Base then
        u25(v29);
        u27();
    end;

    if v28 then
        u4.Matched = true;
    end;
end;

local function _(p31, p32, p33, p34, p35, p36) -- Line: 187
    -- upvalues: math_clamp (copy), math_sqrt (copy)
    local v37 = p35 - p33;
    local v38 = p36 - p34;
    local v39 = math_clamp(((p31 - p33) * v37 + (p32 - p34) * v38) / (v37 * v37 + v38 * v38), 0, 1);
    local v40 = p31 - p33 - v37 * v39;
    local v41 = p32 - p34 - v38 * v39;

    return math_sqrt(v40 * v40 + v41 * v41);
end;

local function u83(p42: userdata, u43: number, p44: number) -- Line: 197
    -- upvalues: u5 (copy), AssetService (copy), math_max (copy), u1 (copy), math_sqrt (copy), math_clamp (copy), math_min (copy), math_floor (copy)
    u5.Label = p42;

    if u5.Fallback then
        p42.Size = UDim2.fromOffset(u43, u43);

        return;
    end;

    if u43 ~= u5.Px or not u5.Image then
        if u5.Image then
            u5.Image:Destroy();
            u5.Image = nil;
        end;

        local success, result = pcall(function() -- Line: 208
            -- upvalues: AssetService (ref), u43 (copy)
            return AssetService:CreateEditableImage({
                Size = Vector2.new(u43, u43)
            });
        end);

        if not (success and result) then
            u5.Fallback = true;
            p42.BackgroundTransparency = 0;
            p42.UIStroke.Enabled = true;
            p42.Size = UDim2.fromOffset(u43, u43);

            return;
        end;

        u5.Image = result;
        u5.Px = u43;
    end;

    p42.ImageContent = Content.fromObject(u5.Image);
    p42.Size = UDim2.fromOffset(u43, u43);
    u5.Angle = p44;
    local v45 = u43 / 2;
    local v46 = v45 - 0.5;
    local v47 = v46 - math_max(1.25, u43 * 0.065);
    local v48 = math_max(0.9, u43 * 0.047);
    local v49 = u43 * -0.17;
    local v50 = u43 * 0.12;
    local v51 = u43 * -0.14;
    local v52 = u43 * 0.17;
    local v53 = u43 * 0.12;
    local math_cos_ret = math.cos(p44);
    local math_sin_ret = math.sin(p44);
    local buffer_create_ret = buffer.create(u43 * u43 * 4);
    local MarkerFill = u1.MarkerFill;
    local v54 = MarkerFill.R * 255;
    local v55 = MarkerFill.G * 255;
    local v56 = MarkerFill.B * 255;

    for i = 0, u43 - 1 do
        local v57 = i;

        for i2 = 0, u43 - 1 do
            local v58 = i2 + 0.5 - v45;
            local v59 = v57 + 0.5 - v45;
            local v60 = math_sqrt(v58 * v58 + v59 * v59);
            local v61 = math_clamp(v46 - v60 + 0.5, 0, 1);
            local v62 = (v57 * u43 + i2) * 4;
            local v63;

            if v61 <= 0 then
                buffer.writeu32(buffer_create_ret, v62, 0);
                v63 = i2;
            else
                local v64 = math_clamp(v47 - v60 + 0.5, 0, 1);
                local v65 = v58 * math_cos_ret + v59 * math_sin_ret;
                local v66 = -v58 * math_sin_ret + v59 * math_cos_ret;
                local v67 = 0 - v49;
                local v68 = v51 - v50;
                local v69 = math_clamp(((v65 - v49) * v67 + (v66 - v50) * v68) / (v67 * v67 + v68 * v68), 0, 1);
                local v70 = v65 - v49 - v67 * v69;
                local v71 = v66 - v50 - v68 * v69;
                local v72 = math_sqrt(v70 * v70 + v71 * v71);
                local v73 = v52 - 0;
                local v74 = v53 - v51;
                local v75 = math_clamp(((v65 - 0) * v73 + (v66 - v51) * v74) / (v73 * v73 + v74 * v74), 0, 1);
                local v76 = v65 - 0 - v73 * v75;
                local v77 = v66 - v51 - v74 * v75;
                local v78 = v64 * (1 - math_clamp(v48 - math_min(v72, (math_sqrt(v76 * v76 + v77 * v77))) + 0.5, 0, 1));
                local v79 = math_floor(v54 * v78 + 0.5);
                buffer.writeu8(buffer_create_ret, v62, v79);
                local v80 = math_floor(v55 * v78 + 0.5);
                buffer.writeu8(buffer_create_ret, v62 + 1, v80);
                local v81 = math_floor(v56 * v78 + 0.5);
                buffer.writeu8(buffer_create_ret, v62 + 2, v81);
                local v82 = math_floor(v61 * 255 + 0.5);
                buffer.writeu8(buffer_create_ret, v62 + 3, v82);
                v63 = i2;
            end;
        end;
    end;

    u5.Image:WritePixelsBuffer(Vector2.zero, Vector2.new(u43, u43), buffer_create_ret);
end;

local function u103(u84: number) -- Line: 261
    -- upvalues: u6 (copy), AssetService (copy), math_max (copy), u1 (copy), math_sqrt (copy), math_clamp (copy), math_floor (copy)
    if u6[u84] == nil then
        local success, result = pcall(function() -- Line: 263
            -- upvalues: AssetService (ref), u84 (copy)
            return AssetService:CreateEditableImage({
                Size = Vector2.new(u84, u84)
            });
        end);

        if success and result then
            local v85 = u84 / 2;
            local v86 = v85 - 0.5;
            local v87 = v86 - math_max(1.25, u84 * 0.075);
            local TeamFill = u1.TeamFill;
            local v88 = TeamFill.R * 255;
            local v89 = TeamFill.G * 255;
            local v90 = TeamFill.B * 255;
            local buffer_create_ret = buffer.create(u84 * u84 * 4);

            for i = 0, u84 - 1 do
                local v91 = i;

                for i2 = 0, u84 - 1 do
                    local v92 = i2 + 0.5 - v85;
                    local v93 = v91 + 0.5 - v85;
                    local v94 = math_sqrt(v92 * v92 + v93 * v93);
                    local v95 = math_clamp(v86 - v94 + 0.5, 0, 1);
                    local v96;

                    if v95 > 0 then
                        local v97 = math_clamp(v87 - v94 + 0.5, 0, 1);
                        local v98 = (v91 * u84 + i2) * 4;
                        local v99 = math_floor(v88 * v97 + 0.5);
                        buffer.writeu8(buffer_create_ret, v98, v99);
                        local v100 = math_floor(v89 * v97 + 0.5);
                        buffer.writeu8(buffer_create_ret, v98 + 1, v100);
                        local v101 = math_floor(v90 * v97 + 0.5);
                        buffer.writeu8(buffer_create_ret, v98 + 2, v101);
                        local v102 = math_floor(v95 * 255 + 0.5);
                        buffer.writeu8(buffer_create_ret, v98 + 3, v102);
                        v96 = i2;
                    else
                        v96 = i2;
                    end;
                end;
            end;

            result:WritePixelsBuffer(Vector2.zero, Vector2.new(u84, u84), buffer_create_ret);
            u6[u84] = Content.fromObject(result);
        else
            u6[u84] = false;
        end;
    end;

    return u6[u84] or nil;
end;

local function u106() -- Line: 297
    -- upvalues: u3 (ref)
    local v104 = u3.TeammateTemplate:Clone();
    v104.Name = "Teammate";
    v104.Parent = u3.Overlay;
    local v105 = u3.TeammateNameTemplate:Clone();
    v105.Name = "TeammateName";
    v105.Parent = u3.Overlay;

    return {
        Px = 0,
        Dot = v104,
        Name = v105
    };
end;

local function _(p107: userdata) -- Line: 310
    local v108 = p107:IsA("TextLabel");

    if v108 then
        if p107.Name == "TeamCursor" or (p107.Name == "PlayerCursor" or p107:FindFirstChild("PlayerName") == nil) then
            v108 = false;
        else
            v108 = p107:FindFirstChild("Rotator") ~= nil;
        end;
    end;

    return v108;
end;

local function _() -- Line: 316
    -- upvalues: u3 (ref), GuiUtil (copy)
    local v109 = u3 and GuiUtil:GetZoomInfo(u3.Map);

    return v109;
end;

local function u113() -- Line: 320
    -- upvalues: u3 (ref), GuiUtil (copy), u7 (copy), u1 (copy), LocalPlayer (copy)
    local v110 = u3 and GuiUtil:GetZoomInfo(u3.Map);

    if not v110 then
        return;
    end;

    local v111;

    if u7.Locked then
        v111 = u1.ZoomMin;
    else
        local v112 = false;

        for _, v in u1.Staff do
            if LocalPlayer:GetAttribute(v) == true then
                v112 = true;
                break;
            end;
        end;

        if v112 then
            v111 = u1.ZoomMinUnlocked;
        else
            v111 = u1.ZoomMin;
        end;
    end;

    if v110.MinZoom ~= v111 then
        v110.MinZoom = v111;
    end;

    if v110.TargetScale < v111 then
        v110.TargetScale = v111;
        v110.ZoomAnchor = nil;
        task.spawn(GuiUtil.StartZoomLoop, GuiUtil, u3.Map);
    end;
end;

local function u119() -- Line: 336
    -- upvalues: u3 (ref), u7 (copy), u1 (copy), MapUIStyle (copy)
    if not u3 then
        return;
    end;

    local Bar = u3.Bar;
    Bar.ZoomLock.Text = not u7.Locked and "UNLOCKED" or string.format("LOCKED %gx", u1.ZoomMin);
    local v114;

    if u7.Locked then
        v114 = MapUIStyle.Colours.Grey;
    else
        v114 = MapUIStyle.Colours.Orange;
    end;

    MapUIStyle.Chip(Bar.ZoomLock, v114);
    Bar.Zones.Text = u7.Zones and "ZONES ON" or "ZONES";
    local v115;

    if u7.Zones then
        v115 = MapUIStyle.Colours.Red;
    else
        v115 = MapUIStyle.Colours.Grey;
    end;

    MapUIStyle.Chip(Bar.Zones, v115);
    u3.ZoneLayer.Visible = u7.Zones and Bar.Visible;
    Bar.Spawns.Text = u7.Spawns and "SPAWNS ON" or "SPAWNS";
    local v116;

    if u7.Spawns then
        v116 = MapUIStyle.Colours.Green;
    else
        v116 = MapUIStyle.Colours.Grey;
    end;

    MapUIStyle.Chip(Bar.Spawns, v116);
    u3.SpawnLayer.Visible = u7.Spawns and Bar.Visible;
    local v117;

    if u7.RadList == nil then
        v117 = false;
    else
        v117 = u7.RadList.Enabled == false;
    end;

    Bar.Radiation.Text = u7.Radiation and (v117 and "RADIATION (OFF)" or "RADIATION ON") or "RADIATION";
    local v118;

    if u7.Radiation then
        v118 = MapUIStyle.Colours.Gold;
    else
        v118 = MapUIStyle.Colours.Grey;
    end;

    MapUIStyle.Chip(Bar.Radiation, v118);
    u3.RadLayer.Visible = u7.Radiation and Bar.Visible;
end;

local function u121() -- Line: 355
    -- upvalues: MapRenderClient (copy), u3 (ref), GuiUtil (copy), u1 (copy)
    local Header = MapRenderClient.Header;

    if not Header then
        return "waiting for the map...";
    end;

    local Info = MapRenderClient.Info;
    local v120 = u3 and GuiUtil:GetZoomInfo(u3.Map);

    return string.format("%s%dx%d  |  %.2f studs/px  |  %d/%d tiles%s  |  zoom %.2fx", Info and (Info.Seed and string.format("seed %d  |  ", Info.Seed)) or "", Header.Width, Header.Height, Header.PixelSize, MapRenderClient.TilesDrawn, Header.TilesX * Header.TilesY, MapRenderClient.Scale > 1 and string.format("  |  held at 1/%d", MapRenderClient.Scale) or "", v120 and v120.Scale or u1.OpenZoom);
end;

local function u124(u122: userdata) -- Line: 372
    -- upvalues: u8 (copy), u124 (ref)
    local string_gsub_ret = string.gsub(u122.Text, "%d", "8");
    local v123 = u8[string_gsub_ret];

    if v123 then
        u122.Size = UDim2.fromOffset(v123, 32);

        return;
    end;

    if v123 == false then
        return;
    end;

    u8[string_gsub_ret] = false;
    task.spawn(function() -- Line: 382
        -- upvalues: string_gsub_ret (copy), u122 (copy), u8 (ref), u124 (ref)
        local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
        GetTextBoundsParams.Text = string_gsub_ret;
        GetTextBoundsParams.Font = u122.FontFace;
        GetTextBoundsParams.Size = u122.TextSize;
        GetTextBoundsParams.Width = 4000;
        local success, result = pcall(function() -- Line: 388
            -- upvalues: GetTextBoundsParams (copy)
            return game:GetService("TextService"):GetTextBoundsAsync(GetTextBoundsParams);
        end);
        u8[string_gsub_ret] = not success and 470 or math.ceil(result.X) + 2;

        if u122.Parent then
            u124(u122);
        end;
    end);
end;

local function u126() -- Line: 400
    -- upvalues: u3 (ref), u1 (copy), LocalPlayer (copy), u119 (copy), u113 (copy)
    if not u3 then
        return;
    end;

    local Bar = u3.Bar;
    local v125 = false;

    for _, v in u1.Staff do
        if LocalPlayer:GetAttribute(v) == true then
            v125 = true;
            break;
        end;
    end;

    if v125 then
        v125 = u3.Map:GetAttribute("Locked") ~= true;
    end;

    Bar.Visible = v125;
    u119();
    u113();
end;

local function u149() -- Line: 412
    -- upvalues: u3 (ref), MapRenderClient (copy), u7 (copy), u1 (copy), math_floor (copy), AssetService (copy)
    if not u3 then
        return;
    end;

    for _, child in u3.ZoneLayer:GetChildren() do
        if child ~= u3.ZoneBlockTemplate and child ~= u3.ZoneShapeTemplate then
            child:Destroy();
        end;
    end;

    for _, v in u3.ZoneImages do
        v:Destroy();
    end;

    table.clear(u3.ZoneImages);
    local Header = MapRenderClient.Header;
    local ZoneList = u7.ZoneList;

    if not Header or type(ZoneList) ~= "table" then
        return;
    end;

    local v127 = Header.Width * Header.PixelSize;
    local v128 = Header.Height * Header.PixelSize;
    local ZoneColour = u1.ZoneColour;
    local v129 = math_floor(ZoneColour.R * 255);
    local v130 = math_floor(ZoneColour.G * 255);
    local v131 = math_floor(ZoneColour.B * 255);

    for _, v in ZoneList do
        if type(v) == "table" and (type(v.X) == "number" and type(v.Z) == "number") then
            local v132 = MapRenderClient.WorldToUV((Vector3.new(v.X, 0, v.Z)));

            if v132 then
                local v133 = nil;
                local v134;

                if type(v.Mask) == "string" and (v.MW and v.MH) then
                    local success, result = pcall(function() -- Line: 444
                        -- upvalues: AssetService (ref), v (copy)
                        return AssetService:CreateEditableImage({
                            Size = Vector2.new(v.MW, v.MH)
                        });
                    end);

                    if success and result then
                        local MW = v.MW;
                        local MH = v.MH;

                        local function _(p135, p136) -- Line: 449
                            -- upvalues: MW (copy), MH (copy), v (copy)
                            local v137;

                            if p135 >= 0 and (p136 >= 0 and (p135 < MW and p136 < MH)) then
                                v137 = string.byte(v.Mask, p136 * MW + p135 + 1) == 49;
                            else
                                v137 = false;
                            end;

                            return v137;
                        end;

                        local buffer_create_ret = buffer.create(MW * MH * 4);
                        v134 = v;

                        for i = 0, MH - 1 do
                            local v138 = i;

                            for i2 = 0, MW - 1 do
                                local v139 = (v138 * MW + i2) * 4;
                                local v140;

                                if i2 >= 0 and (v138 >= 0 and (i2 < MW and v138 < MH)) then
                                    v140 = string.byte(v134.Mask, v138 * MW + i2 + 1) == 49;
                                else
                                    v140 = false;
                                end;

                                local v141;

                                if v140 then
                                    local v142 = i2 - 1;
                                    local v143;

                                    if v142 >= 0 and (v138 >= 0 and (v142 < MW and v138 < MH)) then
                                        v143 = string.byte(v134.Mask, v138 * MW + v142 + 1) == 49;
                                    else
                                        v143 = false;
                                    end;

                                    if v143 then
                                        local v144 = i2 + 1;

                                        if v144 >= 0 and (v138 >= 0 and (v144 < MW and v138 < MH)) then
                                            v143 = string.byte(v134.Mask, v138 * MW + v144 + 1) == 49;
                                        else
                                            v143 = false;
                                        end;

                                        if v143 then
                                            local v145 = v138 - 1;

                                            if i2 >= 0 and (v145 >= 0 and (i2 < MW and v145 < MH)) then
                                                v143 = string.byte(v134.Mask, v145 * MW + i2 + 1) == 49;
                                            else
                                                v143 = false;
                                            end;

                                            if v143 then
                                                local v146 = v138 + 1;

                                                if i2 >= 0 and (v146 >= 0 and (i2 < MW and v146 < MH)) then
                                                    v143 = string.byte(v134.Mask, v146 * MW + i2 + 1) == 49;
                                                else
                                                    v143 = false;
                                                end;
                                            end;
                                        end;
                                    end;

                                    buffer.writeu8(buffer_create_ret, v139, v129);
                                    buffer.writeu8(buffer_create_ret, v139 + 1, v130);
                                    buffer.writeu8(buffer_create_ret, v139 + 2, v131);
                                    local v147 = not v143 and 220 or math_floor((1 - u1.ZoneFillTransparency) * 255);
                                    buffer.writeu8(buffer_create_ret, v139 + 3, v147);
                                    v141 = i2;
                                else
                                    v141 = i2;
                                end;
                            end;
                        end;

                        result:WritePixelsBuffer(Vector2.zero, Vector2.new(MW, MH), buffer_create_ret);
                        table.insert(u3.ZoneImages, result);
                        v133 = u3.ZoneShapeTemplate:Clone();
                        v133.ImageContent = Content.fromObject(result);
                    else
                        v134 = v;
                    end;
                else
                    v134 = v;
                end;

                local v148 = v133 or u3.ZoneBlockTemplate:Clone();
                v148.Name = tostring(v134.Site or "?");
                v148.Position = UDim2.fromScale(v132.X, v132.Y);
                v148.Size = UDim2.fromScale((v134.SX or 0) / v127, (v134.SZ or 0) / v128);
                local math_atan2_ret = math.atan2(v134.RZ or 0, v134.RX or 1);
                v148.Rotation = math.deg(math_atan2_ret);
                v148.Visible = true;
                v148.Parent = u3.ZoneLayer;
            end;
        end;
    end;
end;

local function u152() -- Line: 485
    -- upvalues: u3 (ref), MapRenderClient (copy), u7 (copy)
    if not u3 then
        return;
    end;

    for _, child in u3.SpawnLayer:GetChildren() do
        if child ~= u3.SpawnPadTemplate then
            child:Destroy();
        end;
    end;

    if not MapRenderClient.Header or type(u7.SpawnList) ~= "table" then
        return;
    end;

    for i, v in u7.SpawnList do
        if type(v) == "table" and (type(v.X) == "number" and type(v.Z) == "number") then
            local v150 = MapRenderClient.WorldToUV((Vector3.new(v.X, 0, v.Z)));

            if v150 then
                local v151 = u3.SpawnPadTemplate:Clone();
                v151.Name = tostring(i);
                v151.Position = UDim2.fromScale(v150.X, v150.Y);
                v151.Visible = true;
                v151.Parent = u3.SpawnLayer;
            end;
        end;
    end;
end;

local function _(p153) -- Line: 515
    -- upvalues: u1 (copy), math_clamp (copy)
    if (p153.Res or 0) >= 999 then
        return u1.RadEdge;
    end;

    return u1.RadLow:Lerp(u1.RadHigh, (math_clamp(((p153.Str or 0) - 1) / 3, 0, 1)));
end;

local function u167() -- Line: 522
    -- upvalues: u3 (ref), MapRenderClient (copy), u7 (copy), u1 (copy), math_clamp (copy)
    if not u3 then
        return;
    end;

    for _, child in u3.RadLayer:GetChildren() do
        if child ~= u3.RadDiscTemplate and (child ~= u3.RadBlockTemplate and child ~= u3.RadLabelTemplate) then
            child:Destroy();
        end;
    end;

    local Header = MapRenderClient.Header;
    local RadList = u7.RadList;

    if not (Header and (type(RadList) == "table" and type(RadList.Zones) == "table")) then
        return;
    end;

    local v154 = Header.Width * Header.PixelSize;
    local v155 = Header.Height * Header.PixelSize;
    local v156 = {};

    for _, v in RadList.Zones do
        if type(v) == "table" and (type(v.X) == "number" and type(v.Z) == "number") then
            table.insert(v156, v);
        end;
    end;

    table.sort(v156, function(p157, p158) -- Line: 544
        return (p157.Y or 0) > (p158.Y or 0);
    end);
    local v159 = false;

    for i, v in v156 do
        local v160 = MapRenderClient.WorldToUV((Vector3.new(v.X, 0, v.Z)));

        if v160 then
            local v161;

            if (v.Res or 0) >= 999 then
                v161 = u1.RadEdge;
            else
                v161 = u1.RadLow:Lerp(u1.RadHigh, (math_clamp(((v.Str or 0) - 1) / 3, 0, 1)));
            end;

            local v162 = (v.Res or 0) >= 999;
            local v163;

            if type(v.R) == "number" then
                v163 = u3.RadDiscTemplate:Clone();
                v163.Size = UDim2.fromScale(v.R * 2 / v154, v.R * 2 / v155);
            else
                v163 = u3.RadBlockTemplate:Clone();
                v163.Size = UDim2.fromScale((v.SX or 0) / v154, (v.SZ or 0) / v155);
                local math_atan2_ret = math.atan2(v.RZ or 0, v.RX or 1);
                v163.Rotation = math.deg(math_atan2_ret);
            end;

            v163.Name = "Zone" .. i;
            v163.Position = UDim2.fromScale(v160.X, v160.Y);
            v163.BackgroundColor3 = v161;
            v163.BackgroundTransparency = v.Under and 0.93 or u1.RadFillTransparency;
            local v164 = v163:FindFirstChildOfClass("UIStroke");

            if v164 then
                v164.Color = v161;
                v164.Transparency = v.Under and 0.6 or 0.1;
            end;

            v163.ZIndex = i;
            v163.Visible = true;
            v163.Parent = u3.RadLayer;

            if not (v162 and v159) then
                local v165 = u3.RadLabelTemplate:Clone();
                v165.Name = "Label" .. i;
                local v166 = v162 and "no armour protects" or string.format("%d resistance protects", v.Res or 0);
                v165.Text = string.format("%s\n+%g rad/s  |  %s", v162 and "Map edge" or tostring(v.Kit or "Radiation"), v.Str or 0, v166) .. (not v.Under and "" or "\n(under " .. tostring(v.Under) .. "\'s zone: doesn\'t count)");
                v165.TextColor3 = v161;
                v165.Position = UDim2.fromScale(v160.X, v160.Y);
                v165.ZIndex = 1000 + i;
                v165.Visible = true;
                v165.Parent = u3.RadLayer;
                v159 = v159 or v162;
            end;
        end;
    end;
end;

local function u169() -- Line: 595
    -- upvalues: LocalPlayer (copy), u1 (copy)
    local Attribute = LocalPlayer.PlayerGui:GetAttribute("LastDeathAt");

    if type(Attribute) ~= "number" then
        return "Died";
    end;

    local v168 = os.clock() - Attribute;

    if v168 < 60 then
        return "Died just now";
    end;

    if v168 < 3600 then
        return string.format("Died %dm ago", v168 // 60);
    end;

    return v168 >= u1.DeathLongAgo and "Died a long time ago" or string.format("Died %dh %dm ago", v168 // 3600, v168 % 3600 // 60);
end;

local u178 = {
    ClusterPx = 30,
    Tick = 0.25,
    Open = nil,
    Hover = nil,
    Beds = nil,
    Zoom = 0,
    Shown = false,
    NextTick = 0,
    Ring = MapUIStyle.Colours.Orange,
    RingHover = MapUIStyle.Colours.Green,
    RingCooling = Color3.fromRGB(110, 110, 112),
    IconCooling = Color3.fromRGB(125, 125, 125),
    Pins = {},
    Rows = {},

    Remaining = function(p170) -- Line: 623, Name: Remaining
        -- upvalues: Values (copy)
        local ServerOS = Values:FindFirstChild("ServerOS");

        return (not ServerOS or type(p170.BedTimer) ~= "number") and 0 or math.max(p170.BedTimer - (ServerOS.Value - (p170.LastRespawn or 0)), 0);
    end,

    ImageOf = function(p171) -- Line: 631, Name: ImageOf
        -- upvalues: Items (copy)
        local v172 = Items[p171.ID];

        if v172 then
            v172 = v172.Image;
        end;

        if type(v172) == "table" then
            v172 = v172.Default;
        end;

        return v172 or "";
    end,

    Room = function(p173: userdata) -- Line: 639, Name: Room
        -- upvalues: u3 (ref), MapUIStyle (copy)
        local v174 = 8;
        local v175 = p173.AbsoluteSize.Y - 8;
        local v176 = u3 and u3.Map.Parent and u3.Map.Parent:FindFirstChild("Death");

        if v176 and v176.Visible then
            local v177 = 26 * MapUIStyle.Scale + 6;
            local Y = p173.AbsolutePosition.Y;
            local Header = v176:FindFirstChild("Header");
            local Footer = v176:FindFirstChild("Footer");

            if Header and Header.Visible then
                v174 = math.max(v174, Header.AbsolutePosition.Y + Header.AbsoluteSize.Y - Y + v177);
            end;

            if Footer and Footer.Visible then
                v175 = math.min(v175, Footer.AbsolutePosition.Y - Y - v177);
            end;
        end;

        return v174, v175;
    end
};

function u178.CloseList() -- Line: 656
    -- upvalues: u178 (copy), u3 (ref)
    u178.Open = nil;

    for _, v in u178.Rows do
        v.Row:Destroy();
    end;

    table.clear(u178.Rows);

    if u3 then
        u3.BagList.Visible = false;
    end;
end;

function u178.Unhover() -- Line: 667
    -- upvalues: u178 (copy)
    local Hover = u178.Hover;
    u178.Hover = nil;

    if Hover and Hover.Parent then
        Hover.Delete.Visible = false;
        Hover.NameTag.Visible = false;
    end;
end;

function u178.Pick(p179) -- Line: 678
    -- upvalues: u3 (ref), u2 (copy), u178 (copy)
    if not (u3 and (u3.Map:GetAttribute("Locked") == true and u2.Respawn)) then
        return false;
    end;

    if u178.Remaining(p179) > 0 then
        return true;
    end;

    local Index = p179.Index;

    if type(Index) ~= "number" and type(shared.Beds) == "table" then
        for i, v in shared.Beds do
            if v == p179 then
                Index = i;
                break;
            end;
        end;
    end;

    if type(Index) == "number" then
        u2.Respawn(Index);
    end;

    return true;
end;

function u178.Delete(p180) -- Line: 700
    -- upvalues: MapRemotes (copy)
    if type(p180.Index) == "number" and typeof(p180.Position) == "Vector3" then
        MapRemotes.DeleteBag:FireServer(p180.Index, p180.Position);
    end;
end;

function u178.Paint(p181: userdata, p182: any) -- Line: 707
    -- upvalues: u178 (copy)
    local v183 = (1 / 0);

    for _, v in p182 do
        v183 = math.min(v183, u178.Remaining(v));
    end;

    local v184 = v183 > 0;
    p181.Timer.Visible = v184;

    if v184 then
        local Seconds = p181.Timer.Seconds;
        local math_ceil_ret = math.ceil(v183);
        Seconds.Text = tostring(math_ceil_ret);
    end;

    local Icon = p181.Icon;
    local v185;

    if v184 then
        v185 = u178.IconCooling;
    else
        v185 = Color3.new(1, 1, 1);
    end;

    Icon.ImageColor3 = v185;
    local v186;

    if u178.Hover == p181 then
        v186 = u178.RingHover;
    elseif v184 then
        v186 = u178.RingCooling;
    else
        v186 = u178.Ring;
    end;

    p181.Ring.Color = v186;
end;

function u178.PaintRows() -- Line: 721
    -- upvalues: u178 (copy)
    for _, v in u178.Rows do
        local v187 = u178.Remaining(v.Bed);
        v.Row.Timer.Visible = v187 > 0;
        local Seconds = v.Row.Timer.Seconds;
        local math_ceil_ret = math.ceil(v187);
        Seconds.Text = tostring(math_ceil_ret);
        local Icon = v.Row.Ring.Icon;
        local v188;

        if v187 > 0 then
            v188 = u178.IconCooling;
        else
            v188 = Color3.new(1, 1, 1);
        end;

        Icon.ImageColor3 = v188;
    end;
end;

function u178.OpenList(p189: string) -- Line: 730
    -- upvalues: u178 (copy), u3 (ref), MapGamepad (copy)
    local v190 = u178.Pins[p189];

    if not (u3 and v190) then
        return;
    end;

    u178.CloseList();
    u178.Unhover();

    if u178.CloseOthers then
        u178.CloseOthers();
    end;

    u178.Open = p189;
    local BagList = u3.BagList;
    local v191 = 0;
    local v192 = 0;

    for i, v in v190.Members do
        if v.ID == 194 then
            v192 = v192 + 1;
        else
            v191 = v191 + 1;
        end;

        local u193 = u3.BagRowTemplate:Clone();
        u193.Name = "BagRow";
        u193.LayoutOrder = i;
        u193.Ring.Icon.Image = u178.ImageOf(v);
        u193.BagName.Text = string.upper((tostring(v.Name or "Sleeping Bag")));
        u193.MouseEnter:Connect(function() -- Line: 750
            -- upvalues: u193 (copy), u178 (ref)
            u193.Ring.UIStroke.Color = u178.RingHover;
        end);
        u193.MouseLeave:Connect(function() -- Line: 753
            -- upvalues: u193 (copy), u178 (ref)
            u193.Ring.UIStroke.Color = u178.Ring;
        end);
        MapGamepad.OnPress(u193.Delete, function() -- Line: 756
            -- upvalues: u178 (ref), v (copy), u193 (copy)
            u178.Delete(v);
            u193.Visible = false;
        end);
        u193.InputBegan:Connect(function(p194) -- Line: 760
            -- upvalues: u193 (copy), u178 (ref), v (copy)
            if p194.UserInputType ~= Enum.UserInputType.MouseButton1 and p194.UserInputType ~= Enum.UserInputType.Touch then
                return;
            end;

            if p194.Position.X >= u193.Delete.AbsolutePosition.X - 4 then
                return;
            end;

            u178.Pick(v);
        end);
        u193.Visible = true;
        u193.Parent = BagList;
        table.insert(u178.Rows, {
            Row = u193,
            Bed = v
        });
    end;

    local v195 = #v190.Members;
    BagList.Header.Count.Text.Text = tostring(v195);
    local Title = BagList.Header.Title;
    local v196;

    if v192 > 0 and v191 > 0 then
        v196 = string.format("%d BAGS & BEDS", v195);
    elseif v192 > 0 then
        v196 = string.format("%d BED%s", v195, v195 == 1 and "" or "S");
    else
        v196 = string.format("%d SLEEPING BAG%s", v195, v195 == 1 and "" or "S");
    end;

    Title.Text = v196;
    u178.PaintRows();
    local Parent = BagList.Parent;
    local Pin = v190.Pin;
    local v197 = Pin.AbsolutePosition + Pin.AbsoluteSize / 2 - Parent.AbsolutePosition;
    BagList.Visible = true;
    local AbsoluteSize = BagList.AbsoluteSize;
    local v198;

    if v197.X + 28 + AbsoluteSize.X <= Parent.AbsoluteSize.X then
        v198 = v197.X + 28;
    else
        v198 = v197.X - 28 - AbsoluteSize.X;
    end;

    local v199, v200 = u178.Room(Parent);
    local v201 = v197.Y - 24;
    local math_max_ret = math.max(v200 - AbsoluteSize.Y, v199);
    local math_clamp_ret = math.clamp(v201, v199, math_max_ret);
    BagList.Position = UDim2.fromOffset(v198, math_clamp_ret);
end;

function u178.Layout() -- Line: 793
    -- upvalues: u178 (copy), MapRenderClient (copy), u3 (ref), MapUIStyle (copy), MapGamepad (copy)
    for _, v in u178.Pins do
        v.Pin:Destroy();
    end;

    table.clear(u178.Pins);
    u178.Hover = nil;
    local Open = u178.Open;
    local shared_Beds = shared.Beds;

    if type(shared_Beds) ~= "table" or not MapRenderClient.Header then
        u178.CloseList();

        return;
    end;

    local AbsoluteSize = u3.Content.AbsoluteSize;
    local v202 = u178.ClusterPx * MapUIStyle.Scale;
    local v203 = {};

    for _, v in shared_Beds do
        if type(v) == "table" and typeof(v.Position) == "Vector3" then
            local v204 = MapRenderClient.WorldToUV(v.Position);

            if v204 then
                local v205 = v204 * AbsoluteSize;
                local v206 = v;
                local v207 = nil;

                for _, v2 in v203 do
                    if (v2.Px - v205).Magnitude <= v202 then
                        v207 = v2;
                        break;
                    end;
                end;

                if v207 then
                    table.insert(v207.Members, v206);
                    v207.Sum = v207.Sum + v204;
                    v207.Px = v207.Sum / #v207.Members * AbsoluteSize;
                else
                    table.insert(v203, {
                        Members = { v206 },
                        Sum = v204,
                        Px = v205
                    });
                end;
            end;
        end;
    end;

    for _, v in v203 do
        local Members = v.Members;
        local v208 = {};

        for _, v2 in Members do
            local v209 = tostring(v2.Index);
            table.insert(v208, v209);
        end;

        table.sort(v208);
        local table_concat_ret = table.concat(v208, ",");
        local u210 = u3.BagPinTemplate:Clone();
        u210.Name = "BagPin";
        local v211 = v.Sum / #Members;
        u210.Position = UDim2.fromScale(v211.X, v211.Y);
        u210.Icon.Image = u178.ImageOf(Members[1]);
        u210.Count.Visible = #Members > 1;
        u210.Count.Text = tostring(#Members);
        u210.NameTag.Text = tostring(Members[1].Name or "Sleeping Bag");

        if #Members == 1 then
            local u212 = Members[1];

            local function v213() -- Line: 850
                -- upvalues: u178 (ref), u210 (copy), Members (copy)
                if u178.Hover ~= u210 then
                    u178.Unhover();
                    u178.Hover = u210;
                end;

                u210.Delete.Visible = true;
                u210.NameTag.Visible = true;
                u178.Paint(u210, Members);
            end;

            local function _() -- Line: 859
                -- upvalues: u178 (ref), u210 (copy), Members (copy)
                task.delay(0.15, function() -- Line: 860
                    -- upvalues: u178 (ref), u210 (ref), Members (ref)
                    if u178.Hover == u210 and not (u210:GetAttribute("Over") or u210.Delete:GetAttribute("Over")) then
                        u178.Unhover();
                        u178.Paint(u210, Members);
                    end;
                end);
            end;

            u210.MouseEnter:Connect(function() -- Line: 867
                -- upvalues: u210 (copy), u178 (ref), Members (copy)
                u210:SetAttribute("Over", true);

                if u178.Hover ~= u210 then
                    u178.Unhover();
                    u178.Hover = u210;
                end;

                u210.Delete.Visible = true;
                u210.NameTag.Visible = true;
                u178.Paint(u210, Members);
            end);
            u210.MouseLeave:Connect(function() -- Line: 868
                -- upvalues: u210 (copy), u178 (ref), Members (copy)
                u210:SetAttribute("Over", nil);
                task.delay(0.15, function() -- Line: 860
                    -- upvalues: u178 (ref), u210 (ref), Members (ref)
                    if u178.Hover == u210 and not (u210:GetAttribute("Over") or u210.Delete:GetAttribute("Over")) then
                        u178.Unhover();
                        u178.Paint(u210, Members);
                    end;
                end);
            end);
            u210.Delete.MouseEnter:Connect(function() -- Line: 869
                -- upvalues: u210 (copy)
                u210.Delete:SetAttribute("Over", true);
            end);
            u210.Delete.MouseLeave:Connect(function() -- Line: 870
                -- upvalues: u210 (copy), u178 (ref), Members (copy)
                u210.Delete:SetAttribute("Over", nil);
                task.delay(0.15, function() -- Line: 860
                    -- upvalues: u178 (ref), u210 (ref), Members (ref)
                    if u178.Hover == u210 and not (u210:GetAttribute("Over") or u210.Delete:GetAttribute("Over")) then
                        u178.Unhover();
                        u178.Paint(u210, Members);
                    end;
                end);
            end);

            local function v214() -- Line: 871
                -- upvalues: u178 (ref), u212 (copy), u210 (copy)
                u178.Delete(u212);
                u210.Visible = false;
            end;

            MapGamepad.OnPress(u210, function() -- Line: 875
                -- upvalues: u178 (ref), u212 (copy), u210 (copy), Members (copy)
                if not u178.Pick(u212) then
                    if u178.Hover ~= u210 then
                        u178.Unhover();
                        u178.Hover = u210;
                    end;

                    u210.Delete.Visible = true;
                    u210.NameTag.Visible = true;
                    u178.Paint(u210, Members);
                end;
            end, "Show Bag");
            u210.Delete.Activated:Connect(v214);
            MapGamepad.Register(u210, {
                SecondHint = "Remove Bag (Hold)",
                SecondHold = true,
                Second = v214,
                Enter = v213,

                Leave = function() -- Line: 882, Name: Leave
                    -- upvalues: u178 (ref), u210 (copy), Members (copy)
                    if u178.Hover == u210 then
                        u178.Unhover();
                        u178.Paint(u210, Members);
                    end;
                end
            });
        else
            MapGamepad.OnPress(u210, function() -- Line: 889
                -- upvalues: u178 (ref), table_concat_ret (copy)
                if u178.Open == table_concat_ret then
                    u178.CloseList();

                    return;
                end;

                u178.OpenList(table_concat_ret);
            end, "Open List");
        end;

        u210.Visible = true;
        u210.Parent = u3.BagLayer;
        MapUIStyle.Scaled(u210);
        u178.Pins[table_concat_ret] = {
            Pin = u210,
            Members = Members
        };
        u178.Paint(u210, Members);
    end;

    if Open and u178.Pins[Open] then
        u178.OpenList(Open);

        return;
    end;

    u178.CloseList();
end;

function u178.Clear() -- Line: 910
    -- upvalues: u178 (copy)
    for _, v in u178.Pins do
        v.Pin:Destroy();
    end;

    table.clear(u178.Pins);
    u178.Hover = nil;
    u178.CloseList();
    u178.Beds = nil;
end;

function u178.Step(p215: number) -- Line: 921
    -- upvalues: u3 (ref), MapTools (copy), u178 (copy)
    if u3.Map:GetAttribute("Locked") ~= true and not MapTools.Shown("SleepingBags") then
        if u178.Shown then
            u178.Shown = false;
            u178.Clear();
        end;

        return;
    end;

    if not (u178.Shown and (shared.Beds == u178.Beds and math.abs(p215 - u178.Zoom) <= u178.Zoom * 0.02)) then
        local shared_Beds = shared.Beds;
        u178.Shown = true;
        u178.Beds = shared_Beds;
        u178.Zoom = p215;
        u178.Layout();
    end;

    local os_clock_ret = os.clock();

    if u178.NextTick <= os_clock_ret then
        u178.NextTick = os_clock_ret + u178.Tick;

        for _, v in u178.Pins do
            u178.Paint(v.Pin, v.Members);
        end;

        u178.PaintRows();
    end;
end;

local u239 = {
    ClusterPx = 30,
    Scan = 1,
    Open = nil,
    Showing = nil,
    Sig = nil,
    Zoom = 0,
    Shown = false,
    NextScan = 0,
    Ring = Color3.fromRGB(20, 22, 16),
    RingHover = Color3.new(1, 1, 1),
    Pins = {},
    Machines = {},
    Rows = {},

    Offers = function(p216) -- Line: 960, Name: Offers
        -- upvalues: Items (copy)
        local v217;

        if type(p216) == "table" then
            v217 = p216.Offers;
        else
            v217 = false;
        end;

        if type(v217) ~= "table" then
            return nil;
        end;

        local v218 = {};

        for i = 1, 5 do
            local v219 = v217[i * 2 - 1];
            local v220 = v217[i * 2];
            local v221;

            if type(v219) == "table" and (type(v220) == "table" and (v219[1] ~= 0 and (v220[1] ~= 0 and (Items[v219[1]] and Items[v220[1]])))) then
                table.insert(v218, { v219, v220 });
                v221 = i;
            else
                v221 = i;
            end;
        end;

        if #v218 > 0 then
            return v218;
        end;

        return nil;
    end,

    Where = function(p222) -- Line: 975, Name: Where
        local Pos = p222.Pos;

        if typeof(Pos) == "Vector3" then
            return Pos;
        end;

        if typeof(Pos) == "Vector2" then
            return Vector3.new(Pos.X, 0, Pos.Y);
        end;

        return nil;
    end,

    Image = function(p223) -- Line: 985, Name: Image
        -- upvalues: Items (copy)
        local v224 = Items[p223];

        if v224 then
            v224 = v224.Image;
        end;

        if type(v224) == "table" then
            v224 = v224.Default;
        end;

        return v224 or "";
    end,

    Place = function(p225: userdata, p226: userdata) -- Line: 992, Name: Place
        -- upvalues: u178 (copy)
        local Parent = p225.Parent;
        local v227 = p226.AbsolutePosition - Parent.AbsolutePosition;
        local AbsoluteSize = p226.AbsoluteSize;
        p225.Visible = true;
        local AbsoluteSize2 = p225.AbsoluteSize;
        local v228;

        if v227.X + AbsoluteSize.X + 12 + AbsoluteSize2.X <= Parent.AbsoluteSize.X then
            v228 = v227.X + AbsoluteSize.X + 12;
        else
            v228 = v227.X - 12 - AbsoluteSize2.X;
        end;

        local v229, v230 = u178.Room(Parent);
        local v231 = v227.Y + AbsoluteSize.Y / 2 - 30;
        local math_max_ret = math.max(v230 - AbsoluteSize2.Y, v229);
        local math_clamp_ret = math.clamp(v231, v229, math_max_ret);
        p225.Position = UDim2.fromOffset(v228, math_clamp_ret);
    end,

    PlaceBelow = function(p232: userdata, p233: userdata) -- Line: 1005, Name: PlaceBelow
        -- upvalues: MapUIStyle (copy), u178 (copy)
        local Parent = p232.Parent;
        local v234 = p233.AbsolutePosition - Parent.AbsolutePosition;
        p232.Visible = true;
        local AbsoluteSize = p232.AbsoluteSize;
        local AbsoluteSize2 = Parent.AbsoluteSize;
        local v235 = 62 * MapUIStyle.Scale;
        local v236 = v234.Y + p233.AbsoluteSize.Y + v235;
        local v237, v238 = u178.Room(Parent);

        if v238 < v236 + AbsoluteSize.Y then
            v236 = math.max(v234.Y - v235 - AbsoluteSize.Y, v237);
        end;

        local UDim2_fromOffset = UDim2.fromOffset;
        local X = v234.X;
        local math_max_ret = math.max(AbsoluteSize2.X - AbsoluteSize.X - 8, 8);
        p232.Position = UDim2_fromOffset(math.clamp(X, 8, math_max_ret), v236);
    end
};

function u239.CloseOffers() -- Line: 1021
    -- upvalues: u239 (copy), u3 (ref)
    u239.Showing = nil;

    for _, v in u239.Rows do
        v:Destroy();
    end;

    table.clear(u239.Rows);

    if u3 then
        u3.ShopOffers.Visible = false;
    end;
end;

function u239.CloseList() -- Line: 1032
    -- upvalues: u239 (copy), u3 (ref)
    u239.Open = nil;

    for _, v in u239.Machines do
        v:Destroy();
    end;

    table.clear(u239.Machines);

    if u3 then
        u3.ShopList.Visible = false;
    end;
end;

function u239.ShowOffers(p240: string, p241: userdata, p242: boolean?) -- Line: 1044
    -- upvalues: u239 (copy), u178 (copy), ActiveBenchModule (copy), u3 (ref), NumberUtil (copy)
    if u239.Showing == p240 then
        u239.CloseOffers();

        return;
    end;

    u178.CloseList();
    local v243 = u239.Offers(ActiveBenchModule.GetClientInfoFromTag(p240));
    u239.CloseOffers();

    if not (u3 and v243) then
        return;
    end;

    u239.Showing = p240;

    for i, v in v243 do
        local v244 = v[1];
        local v245 = v[2];
        local v246 = u3.OfferRowTemplate:Clone();
        v246.Name = "OfferRow";
        v246.LayoutOrder = i;
        v246.Give.ItemImage.Image = u239.Image(v244[1]);
        v246.GiveAmount.Text = "x" .. NumberUtil:FormatNumber(v244[2] or 1);
        v246.Receive.ItemImage.Image = u239.Image(v245[1]);
        v246.ReceiveAmount.Text = "x" .. NumberUtil:FormatNumber(v245[2] or 1);
        v246.Visible = true;
        v246.Parent = u3.ShopOffers;
        table.insert(u239.Rows, v246);
    end;

    if p242 then
        u239.PlaceBelow(u3.ShopOffers, p241);

        return;
    end;

    u239.Place(u3.ShopOffers, p241);
end;

function u239.OpenList(p247: string) -- Line: 1076
    -- upvalues: u239 (copy), u3 (ref), u178 (copy), MapGamepad (copy)
    local v248 = u239.Pins[p247];

    if not (u3 and v248) then
        return;
    end;

    u239.CloseList();
    u239.CloseOffers();
    u178.CloseList();
    u239.Open = p247;

    for i, v in v248.Tags do
        local u249 = u3.MachineTemplate:Clone();
        u249.Name = "Machine";
        u249.LayoutOrder = i;

        local function v250() -- Line: 1089
            -- upvalues: u249 (copy), u239 (ref)
            u249.Ring.Color = u239.RingHover;
        end;

        local function v251() -- Line: 1090
            -- upvalues: u249 (copy), u239 (ref)
            u249.Ring.Color = u239.Ring;
        end;

        u249.MouseEnter:Connect(v250);
        u249.MouseLeave:Connect(v251);
        MapGamepad.OnPress(u249, function() -- Line: 1093
            -- upvalues: u239 (ref), v (copy), u3 (ref)
            u239.ShowOffers(v, u3.ShopList, true);
        end);
        MapGamepad.Register(u249, {
            Enter = v250,
            Leave = v251
        });
        u249.Visible = true;
        u249.Parent = u3.ShopStrip;
        table.insert(u239.Machines, u249);
    end;

    u3.ShopList.Header.Count.Text.Text = tostring(#v248.Tags);
    u3.ShopList.Header.Title.Text = #v248.Tags == 1 and "SHOP MACHINE" or "SHOP MACHINES";
    u239.Place(u3.ShopList, v248.Pin);
end;

function u239.Layout(p252) -- Line: 1107
    -- upvalues: u239 (copy), u3 (ref), MapUIStyle (copy), MapGamepad (copy)
    for _, v in u239.Pins do
        v.Pin:Destroy();
    end;

    table.clear(u239.Pins);
    local Open = u239.Open;
    local Showing = u239.Showing;
    local AbsoluteSize = u3.Content.AbsoluteSize;
    local v253 = u239.ClusterPx * MapUIStyle.Scale;
    local v254 = {};

    for _, v in p252 do
        local v255 = v.UV * AbsoluteSize;
        local v256 = v;
        local v257 = nil;

        for _, v2 in v254 do
            if (v2.Px - v255).Magnitude <= v253 then
                v257 = v2;
                break;
            end;
        end;

        if v257 then
            table.insert(v257.Tags, v256.Tag);
            v257.Sum = v257.Sum + v256.UV;
            v257.Px = v257.Sum / #v257.Tags * AbsoluteSize;
        else
            table.insert(v254, {
                Tags = { v256.Tag },
                Sum = v256.UV,
                Px = v255
            });
        end;
    end;

    local v258 = false;

    for _, v in v254 do
        table.sort(v.Tags);
        local table_concat_ret = table.concat(v.Tags, ",");
        local v259 = #v.Tags == 1;
        local v260;

        if v259 then
            v260 = u3.ShopPinTemplate;
        else
            v260 = u3.ShopClusterTemplate;
        end;

        local u261 = v260:Clone();
        u261.Name = v259 and "ShopPin" or "ShopCluster";
        local v262 = v.Sum / #v.Tags;
        u261.Position = UDim2.fromScale(v262.X, v262.Y);

        if v259 then
            local u263 = v.Tags[1];
            v258 = v258 or u263 == Showing;

            local function v264() -- Line: 1145
                -- upvalues: u261 (copy), u239 (ref)
                u261.Ring.Color = u239.RingHover;
                u261.ZIndex = 7;
            end;

            local function v265() -- Line: 1146
                -- upvalues: u261 (copy), u239 (ref)
                u261.Ring.Color = u239.Ring;
                u261.ZIndex = 6;
            end;

            u261.MouseEnter:Connect(v264);
            u261.MouseLeave:Connect(v265);
            MapGamepad.OnPress(u261, function() -- Line: 1149
                -- upvalues: u239 (ref), u263 (copy), u261 (copy)
                u239.CloseList();
                u239.ShowOffers(u263, u261);
            end, "Show Offers");
            MapGamepad.Register(u261, {
                Enter = v264,
                Leave = v265
            });
        else
            u261.Count.Text = tostring(#v.Tags);
            MapGamepad.OnPress(u261, function() -- Line: 1156
                -- upvalues: u239 (ref), table_concat_ret (copy)
                if u239.Open ~= table_concat_ret then
                    u239.OpenList(table_concat_ret);

                    return;
                end;

                u239.CloseList();
                u239.CloseOffers();
            end, "Open List");
        end;

        u261.Visible = true;
        u261.Parent = u3.ShopLayer;
        MapUIStyle.Scaled(u261);
        u239.Pins[table_concat_ret] = {
            Pin = u261,
            Tags = v.Tags
        };
    end;

    if Open and u239.Pins[Open] then
        u239.OpenList(Open);

        return;
    end;

    u239.CloseList();

    if not v258 then
        u239.CloseOffers();
    end;
end;

function u178.CloseOthers() -- Line: 1180
    -- upvalues: u239 (copy)
    u239.CloseList();
    u239.CloseOffers();
end;

function u239.Clear() -- Line: 1185
    -- upvalues: u239 (copy)
    for _, v in u239.Pins do
        v.Pin:Destroy();
    end;

    table.clear(u239.Pins);
    u239.CloseList();
    u239.CloseOffers();
    u239.Sig = nil;
end;

function u239.Step(p266: number) -- Line: 1196
    -- upvalues: u3 (ref), MapTools (copy), MapRenderClient (copy), u239 (copy), ActiveBenchModule (copy)
    if not ((u3.Map:GetAttribute("Locked") == true or MapTools.Shown("VendingMachines")) and MapRenderClient.Header) then
        if u239.Shown then
            u239.Shown = false;
            u239.Clear();
        end;

        return;
    end;

    local os_clock_ret = os.clock();
    local v267 = math.abs(p266 - u239.Zoom) > u239.Zoom * 0.02;

    if u239.Shown and (not v267 and os_clock_ret < u239.NextScan) then
        return;
    end;

    u239.NextScan = os_clock_ret + u239.Scan;
    local v268 = {};
    local v269 = {};

    for i, v in ActiveBenchModule.GetAllRawClientInfos() do
        local v270 = u239.Offers(v) and u239.Where(v);
        local v271;

        if v270 then
            v271 = MapRenderClient.WorldToUV(v270);
        else
            v271 = v270;
        end;

        if v271 then
            table.insert(v268, {
                Tag = i,
                UV = v271
            });
            table.insert(v269, string.format("%s@%d,%d", i, v270.X // 1, v270.Z // 1));
        end;
    end;

    table.sort(v269);
    local table_concat_ret = table.concat(v269, ";");

    if not (u239.Shown and (not v267 and table_concat_ret == u239.Sig)) then
        u239.Shown = true;
        u239.Sig = table_concat_ret;
        u239.Zoom = p266;
        u239.Layout(v268);
    end;
end;

local function u294() -- Line: 1229
    -- upvalues: u3 (ref), u113 (copy), GuiUtil (copy), MapUIStyle (copy), u1 (copy), math_clamp (copy), math_floor (copy), LocalPlayer (copy), MapRenderClient (copy), u5 (copy), u83 (copy), math_max (copy), u106 (copy), Players (copy), u103 (copy), u178 (copy), u239 (copy), u169 (copy), u121 (copy)
    if not (u3 and (u3.Map.Visible and u3.Map.Parent)) then
        return;
    end;

    u113();
    local v272 = u3 and GuiUtil:GetZoomInfo(u3.Map);
    local v273 = v272 and v272.Scale or u3.Frame.Size.X.Scale;
    local Scale = MapUIStyle.Scale;
    local v274 = math_clamp(u1.MarkerPx * Scale * (v273 / u1.MarkerZoom) ^ (-u1.MarkerZoomExp), u1.MarkerMin * Scale, u1.MarkerMax * Scale);
    local v275;

    if v272 then
        v275 = v272.MaxZoom or v273;
    else
        v275 = v273;
    end;

    local v276 = u1.MarkerZoom >= v275 and 0 or math_clamp((v273 - u1.MarkerZoom) / (v275 - u1.MarkerZoom), 0, 1);
    local v277 = math_floor(v274 * (1 + (u1.YouZoomedIn - 1) * v276) + 0.5);
    local v278 = u3.Content.AbsolutePosition - u3.Overlay.AbsolutePosition;
    local AbsoluteSize = u3.Content.AbsoluteSize;
    local workspace_CurrentCamera = workspace.CurrentCamera;
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    local v279 = Character and Character.Position;

    if not v279 then
        if workspace_CurrentCamera then
            v279 = workspace_CurrentCamera.CFrame.Position;
        else
            v279 = workspace_CurrentCamera;
        end;
    end;

    if v279 then
        v279 = MapRenderClient.WorldToUV(v279);
    end;

    local v280;

    if v279 == nil or workspace_CurrentCamera == nil then
        v280 = false;
    else
        v280 = u3.PlayerCursor.Visible;
    end;

    if u3.You.Visible ~= v280 then
        u3.You.Visible = v280;
    end;

    if v280 then
        local LookVector = workspace_CurrentCamera.CFrame.LookVector;
        local math_atan2_ret = math.atan2(LookVector.X, -LookVector.Z);
        local math_abs_ret = math.abs((math_atan2_ret - u5.Angle + 3.141592653589793) % 6.283185307179586 - 3.141592653589793);

        if v277 ~= u5.Px or (math_abs_ret > 0.017453292519943295 or u5.Label ~= u3.You) then
            u83(u3.You, v277, math_atan2_ret);
        end;

        u3.You.Position = UDim2.fromOffset(math_floor(v278.X + v279.X * AbsoluteSize.X + 0.5) - v277 // 2, math_floor(v278.Y + v279.Y * AbsoluteSize.Y + 0.5) - v277 // 2);
    end;

    local v281 = math_max(6, (math_floor(v274 * u1.TeamShare + 0.5)));
    local v282 = math_floor(13 * Scale + 0.5);
    local v283 = {};

    for _, child in u3.Content:GetChildren() do
        local v284 = child:IsA("TextLabel");

        if v284 then
            if child.Name == "TeamCursor" or (child.Name == "PlayerCursor" or child:FindFirstChild("PlayerName") == nil) then
                v284 = false;
            else
                v284 = child:FindFirstChild("Rotator") ~= nil;
            end;
        end;

        if v284 then
            v283[child] = true;
            local v285 = u3.Team[child];

            if not v285 then
                v285 = u106();
                u3.Team[child] = v285;
            end;

            local Visible = child.Visible;
            local Name = v285.Name;
            v285.Dot.Visible = Visible;
            Name.Visible = Visible;

            if Visible then
                local v286 = Players:FindFirstChild(child.Name);
                local v287 = v286 and (v286:IsA("Player") and v286.Character) and v286.Character:FindFirstChild("HumanoidRootPart");
                local v288 = v287 and MapRenderClient.WorldToUV(v287.Position) or Vector2.new(child.Position.X.Scale, child.Position.Y.Scale);

                if v285.Px ~= v281 then
                    v285.Px = v281;
                    v285.Dot.Size = UDim2.fromOffset(v281, v281);
                    local v289 = u103(v281);

                    if v289 then
                        v285.Dot.ImageContent = v289;
                    else
                        v285.Dot.BackgroundTransparency = 0;
                    end;
                end;

                local v290 = math_floor(v278.X + v288.X * AbsoluteSize.X + 0.5);
                local v291 = math_floor(v278.Y + v288.Y * AbsoluteSize.Y + 0.5);
                v285.Dot.Position = UDim2.fromOffset(v290 - v281 // 2, v291 - v281 // 2);
                v285.Name.Position = UDim2.fromOffset(v290, v291 + v281 - v281 // 2 + 1);
                v285.Name.TextSize = v282;
                local Text = child.PlayerName.Text;

                if Text == "" then
                    Text = child.Name;
                end;

                if v285.Name.Text ~= Text then
                    v285.Name.Text = Text;
                end;
            end;
        end;
    end;

    for i, v in u3.Team do
        if not v283[i] then
            v.Dot:Destroy();
            v.Name:Destroy();
            u3.Team[i] = nil;
        end;
    end;

    u178.Step(v273);
    u239.Step(v273);

    if u3.Ago.Visible then
        local v292 = u169();

        if u3.Ago.Text ~= v292 then
            u3.Ago.Text = v292;
        end;
    end;

    if u3.Bar.Visible then
        local v293 = u121();

        if u3.Status.Text ~= v293 then
            u3.Status.Text = v293;
        end;
    end;
end;

local function u296(p295: userdata) -- Line: 1346
    -- upvalues: MapUIStyle (copy)
    if p295:IsA("GuiObject") and p295:FindFirstChild("StyleScale") then
        MapUIStyle.Scaled(p295);
    end;
end;

function u2.Attach(u297: userdata) -- Line: 1352
    -- upvalues: u3 (ref), u5 (copy), MapUIStyle (copy), u1 (copy), u124 (ref), MapGamepad (copy), u7 (copy), u119 (copy), u113 (copy), MapRemotes (copy), u149 (copy), u152 (copy), u167 (copy), u296 (copy), u178 (copy), MapTools (copy), u239 (copy), u169 (copy), u27 (copy), u4 (copy), u25 (copy), u30 (copy), MapRenderClient (copy), LocalPlayer (copy), u126 (copy)
    if u3 and u3.Map == u297 then
        return;
    end;

    local Frame = u297:WaitForChild("Frame", 10);
    local v298;

    if Frame then
        v298 = Frame:WaitForChild("Map", 10);
    else
        v298 = Frame;
    end;

    local MapLookMarkers = u297:WaitForChild("MapLookMarkers", 10);
    local StatusBar = u297:WaitForChild("StatusBar", 10);

    if not (v298 and (MapLookMarkers and StatusBar)) then
        return;
    end;

    local BuildBlocks = v298:WaitForChild("BuildBlocks");
    u3 = {
        Map = u297,
        Frame = Frame,
        Content = v298,
        Aspect = v298:WaitForChild("MapLookAspect"),
        Ocean = v298:WaitForChild("Ocean"),
        Labels = v298:WaitForChild("MonumentLabels"),
        PlayerCursor = v298:WaitForChild("PlayerCursor"),
        Overlay = MapLookMarkers,
        You = MapLookMarkers:WaitForChild("You"),
        TeammateTemplate = MapLookMarkers:WaitForChild("TeammateTemplate"),
        TeammateNameTemplate = MapLookMarkers:WaitForChild("TeammateNameTemplate"),
        Team = {},
        ZoneLayer = BuildBlocks,
        ZoneBlockTemplate = BuildBlocks:WaitForChild("ZoneBlockTemplate"),
        ZoneShapeTemplate = BuildBlocks:WaitForChild("ZoneShapeTemplate"),
        ZoneImages = {},
        SpawnLayer = v298:WaitForChild("SpawnPads"),
        RadLayer = v298:WaitForChild("Radiation"),
        Bar = StatusBar,
        Status = StatusBar:WaitForChild("Status"),
        DeathMarker = v298:WaitForChild("DeathMarker")
    };
    u3.Ago = u3.DeathMarker:WaitForChild("Ago");
    u3.SpawnPadTemplate = u3.SpawnLayer:WaitForChild("SpawnPadTemplate");
    u3.RadDiscTemplate = u3.RadLayer:WaitForChild("RadDiscTemplate");
    u3.RadBlockTemplate = u3.RadLayer:WaitForChild("RadBlockTemplate");
    u3.RadLabelTemplate = u3.RadLayer:WaitForChild("RadLabelTemplate");
    u3.BagLayer = v298:WaitForChild("SleepingBags");
    u3.BagPinTemplate = u3.BagLayer:WaitForChild("BagPinTemplate");
    u3.BagList = u297:WaitForChild("BagList");
    u3.BagRowTemplate = u3.BagList:WaitForChild("BagRowTemplate");
    u3.ShopLayer = v298:WaitForChild("VendingMachines");
    u3.ShopPinTemplate = u3.ShopLayer:WaitForChild("ShopPinTemplate");
    u3.ShopClusterTemplate = u3.ShopLayer:WaitForChild("ShopClusterTemplate");
    u3.ShopList = u297:WaitForChild("ShopList");
    u3.ShopStrip = u3.ShopList:WaitForChild("Strip");
    u3.MachineTemplate = u3.ShopStrip:WaitForChild("MachineTemplate");
    u3.ShopOffers = u297:WaitForChild("ShopOffers");
    u3.OfferRowTemplate = u3.ShopOffers:WaitForChild("OfferRowTemplate");
    local u299 = u3;

    if u5.Fallback then
        u5.Fallback = false;
        u5.Px = 0;
    end;

    u5.Angle = (1 / 0);
    MapUIStyle.Backdrop(StatusBar, u1.BarBackdrop);
    MapUIStyle.Scaled(StatusBar);
    u3.Status:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1414
        -- upvalues: u124 (ref), u299 (copy)
        u124(u299.Status);
    end);
    u124(u3.Status);
    MapGamepad.OnPress(StatusBar.ZoomLock, function() -- Line: 1418
        -- upvalues: u7 (ref), u119 (ref), u113 (ref)
        u7.Locked = not u7.Locked;
        u119();
        u113();
    end);
    MapGamepad.OnPress(StatusBar.Zones, function() -- Line: 1423
        -- upvalues: u7 (ref), u119 (ref), MapRemotes (ref), u149 (ref)
        u7.Zones = not u7.Zones;
        u119();

        if u7.Zones and (u7.ZoneList == nil and not u7.ZoneAsking) then
            u7.ZoneAsking = true;
            task.spawn(function() -- Line: 1429
                -- upvalues: MapRemotes (ref), u7 (ref), u149 (ref)
                local success, result = pcall(MapRemotes.StaffZones.InvokeServer, MapRemotes.StaffZones);
                u7.ZoneAsking = false;

                if success and type(result) == "table" then
                    u7.ZoneList = result;
                    u149();
                end;
            end);
        end;
    end);
    MapGamepad.OnPress(StatusBar.Spawns, function() -- Line: 1439
        -- upvalues: u7 (ref), u119 (ref), MapRemotes (ref), u152 (ref)
        u7.Spawns = not u7.Spawns;
        u119();

        if u7.Spawns and (u7.SpawnList == nil and not u7.SpawnAsking) then
            u7.SpawnAsking = true;
            task.spawn(function() -- Line: 1445
                -- upvalues: MapRemotes (ref), u7 (ref), u152 (ref)
                local success, result = pcall(MapRemotes.StaffSpawns.InvokeServer, MapRemotes.StaffSpawns);
                u7.SpawnAsking = false;

                if success and (type(result) == "table" and #result > 0) then
                    u7.SpawnList = result;
                    u152();
                end;
            end);
        end;
    end);
    MapGamepad.OnPress(StatusBar.Radiation, function() -- Line: 1455
        -- upvalues: u7 (ref), u119 (ref), MapRemotes (ref), u167 (ref)
        u7.Radiation = not u7.Radiation;
        u119();

        if u7.Radiation and (u7.RadList == nil and not u7.RadAsking) then
            u7.RadAsking = true;
            task.spawn(function() -- Line: 1461
                -- upvalues: MapRemotes (ref), u7 (ref), u167 (ref), u119 (ref)
                local success, result = pcall(MapRemotes.StaffRadiation.InvokeServer, MapRemotes.StaffRadiation);
                u7.RadAsking = false;

                if success and (type(result) == "table" and (type(result.Zones) == "table" and #result.Zones > 0)) then
                    u7.RadList = result;
                    u167();
                    u119();
                end;
            end);
        end;
    end);

    for _, child in u3.Labels:GetChildren() do
        if child:IsA("GuiObject") and child:FindFirstChild("StyleScale") then
            MapUIStyle.Scaled(child);
        end;
    end;

    u3.Labels.ChildAdded:Connect(u296);

    for _, child in v298:GetChildren() do
        if child:IsA("GuiObject") and child:FindFirstChild("StyleScale") then
            MapUIStyle.Scaled(child);
        end;
    end;

    v298.ChildAdded:Connect(u296);
    u178.Pins = {};
    u178.Rows = {};
    u178.Open = nil;
    u178.Hover = nil;
    u178.Beds = nil;
    u178.Shown = false;
    MapTools.SetIcon(u3.BagPinTemplate.Delete.Glyph, "Close", 10);
    MapTools.SetIcon(u3.BagPinTemplate.Timer.Clock, "Timer", 12);
    MapTools.SetIcon(u3.BagRowTemplate.Timer.Clock, "Timer", 16);
    MapTools.SetIcon(u3.BagRowTemplate.Delete.Icon, "Clear", 18);
    MapTools.SetIcon(u3.BagList.Header.Close.Icon, "Close", 18);
    MapUIStyle.Backdrop(u3.BagList, {
        Behind = true,
        Outside = true,
        Even = true,
        SliceScale = 0.4,
        Transparency = 0.32,
        Colour = Color3.fromRGB(42, 42, 44)
    });
    MapUIStyle.Banner(u3.BagList.Header, {
        Transparency = 0.12,
        Bleed = 2,
        BleedX = 0
    });
    MapUIStyle.Scaled(u3.BagList);
    MapGamepad.OnPress(u3.BagList.Header.Close, u178.CloseList);
    u239.Pins = {};
    u239.Machines = {};
    u239.Rows = {};
    u239.Open = nil;
    u239.Showing = nil;
    u239.Sig = nil;
    u239.Shown = false;

    for _, v in { u3.ShopPinTemplate.Icon, u3.MachineTemplate.Icon, u3.ShopOffers.Header.Badge.Icon } do
        MapTools.SetIcon(v, "VendingMachines", 20);
    end;

    MapTools.SetIcon(u3.OfferRowTemplate.Arrow, "Arrow", 20);

    for _, v in { u3.ShopList, u3.ShopOffers } do
        MapTools.SetIcon(v.Header.Close.Icon, "Close", 18);
        MapUIStyle.Backdrop(v, {
            Behind = true,
            Outside = true,
            Even = true,
            SliceScale = 0.4,
            Transparency = 0.32,
            Colour = Color3.fromRGB(42, 42, 44)
        });
        MapUIStyle.Banner(v.Header, {
            Transparency = 0.12,
            Bleed = 2,
            BleedX = 0
        });
        MapUIStyle.Scaled(v);
    end;

    MapGamepad.OnPress(u3.ShopList.Header.Close, function() -- Line: 1505
        -- upvalues: u239 (ref)
        u239.CloseList();
        u239.CloseOffers();
    end);
    MapGamepad.OnPress(u3.ShopOffers.Header.Close, u239.CloseOffers);
    u297:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1510
        -- upvalues: u297 (copy), u178 (ref), u239 (ref)
        if not u297.Visible then
            u178.Unhover();
            u178.CloseList();
            u239.CloseList();
            u239.CloseOffers();
        end;
    end);
    local v300 = MapTools.DeathImage();

    if v300 then
        u3.DeathMarker.ImageContent = v300;
    end;

    local function v301() -- Line: 1524
        -- upvalues: u299 (copy), u169 (ref)
        u299.Ago.Text = u169();
        u299.Ago.Visible = true;
    end;

    local function v302() -- Line: 1528
        -- upvalues: u299 (copy)
        u299.Ago.Visible = false;
    end;

    u3.DeathMarker.MouseEnter:Connect(v301);
    u3.DeathMarker.MouseLeave:Connect(v302);
    MapGamepad.Register(u3.DeathMarker, {
        Enter = v301,
        Leave = v302
    });
    u297:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1534
        -- upvalues: u297 (copy), u299 (copy)
        if not u297.Visible then
            u299.Ago.Visible = false;
        end;
    end);
    u27();

    if not u4.Base then
        u25(u1.WaterFallback);
        u27();
    end;

    u30();
    local Header = MapRenderClient.Header;

    if Header then
        u3.Aspect.AspectRatio = Header.Width / Header.Height;
    end;

    u149();
    u152();
    u167();

    if u3 then
        local Bar = u3.Bar;
        local v303 = false;

        for _, v in u1.Staff do
            if LocalPlayer:GetAttribute(v) == true then
                v303 = true;
                break;
            end;
        end;

        if v303 then
            v303 = u3.Map:GetAttribute("Locked") ~= true;
        end;

        Bar.Visible = v303;
        u119();
        u113();
    end;

    u297:GetAttributeChangedSignal("Locked"):Connect(u126);
    u297.Destroying:Connect(function() -- Line: 1555
        -- upvalues: u3 (ref), u299 (copy), u178 (ref), u239 (ref)
        if u3 == u299 then
            for _, v in u299.ZoneImages do
                v:Destroy();
            end;

            table.clear(u178.Pins);
            table.clear(u178.Rows);
            u178.Open = nil;
            u178.Hover = nil;
            u178.Beds = nil;
            u178.Shown = false;
            table.clear(u239.Pins);
            table.clear(u239.Machines);
            table.clear(u239.Rows);
            u239.Open = nil;
            u239.Showing = nil;
            u239.Sig = nil;
            u239.Shown = false;
            u3 = nil;
        end;
    end);
end;

MapRenderClient.Started:Connect(function() -- Line: 1573
    -- upvalues: u4 (copy), u3 (ref), MapRenderClient (copy), u149 (copy), u152 (copy), u167 (copy)
    u4.Matched = false;

    if u3 then
        local Header = MapRenderClient.Header;

        if Header then
            u3.Aspect.AspectRatio = Header.Width / Header.Height;
        end;

        u149();
        u152();
        u167();
    end;
end);
local u304 = nil;
MapRenderClient.InfoChanged:Connect(function() -- Line: 1586
    -- upvalues: MapRenderClient (copy), u304 (ref), u7 (copy), u119 (copy), u30 (copy), u149 (copy), u152 (copy), u167 (copy)
    local Info = MapRenderClient.Info;

    if Info then
        Info = Info.Seed;
    end;

    if Info and (u304 and Info ~= u304) then
        u7.ZoneList = nil;
        u7.Zones = false;
        u7.SpawnList = nil;
        u7.Spawns = false;
        u7.RadList = nil;
        u7.Radiation = false;
        u119();
    end;

    u304 = Info or u304;
    u30();
    u149();
    u152();
    u167();
end);
MapRenderClient.TileDrawn:Connect(function(p305) -- Line: 1604
    -- upvalues: u30 (copy)
    if p305 == 1 then
        u30();
    end;
end);
MapRenderClient.Finished:Connect(u30);

for _, v in u1.Staff do
    LocalPlayer:GetAttributeChangedSignal(v):Connect(u126);
end;

u2.Pad = {
    ListOpen = function() -- Line: 1616, Name: ListOpen
        -- upvalues: u3 (ref)
        local v306;

        if u3 == nil then
            v306 = false;
        else
            v306 = u3.BagList.Visible or (u3.ShopList.Visible or u3.ShopOffers.Visible);
        end;

        return v306;
    end,

    CloseLists = function() -- Line: 1620, Name: CloseLists
        -- upvalues: u3 (ref), u178 (copy), u239 (copy)
        if not u3 then
            return false;
        end;

        local v307 = u3.BagList.Visible or (u3.ShopList.Visible or u3.ShopOffers.Visible);
        u178.CloseList();
        u239.CloseList();
        u239.CloseOffers();

        return v307;
    end
};
RunService:BindToRenderStep("MapLook", Enum.RenderPriority.Last.Value, function() -- Line: 1632
    -- upvalues: u294 (copy)
    pcall(u294);
end);

return u2;
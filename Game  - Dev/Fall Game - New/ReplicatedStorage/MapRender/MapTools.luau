-- [PATH] ReplicatedStorage / MapRender / MapTools @Type ModuleScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local GuiService = game:GetService("GuiService");
local AssetService = game:GetService("AssetService");
local ContentProvider = game:GetService("ContentProvider");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local MapRemotes = ReplicatedStorage:WaitForChild("MapRemotes");
local MapRenderClient = require(script.Parent:WaitForChild("MapRenderClient"));
local MapDrawing = require(script.Parent:WaitForChild("MapDrawing"));
local MapUIStyle = require(script.Parent:WaitForChild("MapUIStyle"));
local MapGamepad = require(script.Parent:WaitForChild("MapGamepad"));
local GuiUtil = require(Modules:WaitForChild("GuiUtil"));
local Fetch = MapRemotes:WaitForChild("Fetch");
local Save = MapRemotes:WaitForChild("Save");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local Color3_fromRGB_ret = Color3.fromRGB(33, 150, 243);
local Color3_fromRGB_ret2 = Color3.fromRGB(232, 64, 58);
local Color3_fromRGB_ret3 = Color3.fromRGB(74, 74, 74);
local Color3_fromRGB_ret4 = Color3.fromRGB(120, 120, 120);
local Color3_fromRGB_ret5 = Color3.fromRGB(98, 162, 86);
local Color3_fromRGB_ret6 = Color3.fromRGB(16, 16, 18);
local u1 = {
    Color3.fromRGB(250, 214, 50),
    Color3.fromRGB(33, 150, 243),
    Color3.fromRGB(96, 200, 80),
    Color3.fromRGB(230, 57, 53),
    Color3.fromRGB(170, 90, 230),
    Color3.fromRGB(40, 200, 190)
};
local u2 = {
    Behind = true,
    Outside = true,
    Even = true,
    SliceScale = 0.4,
    Transparency = 0.32,
    Colour = Color3.fromRGB(42, 42, 44)
};
local math_floor = math.floor;
local math_sqrt = math.sqrt;
local math_min = math.min;
local math_max = math.max;
local math_clamp = math.clamp;

local function _(p3, p4, p5, p6, p7, p8) -- Line: 112
    -- upvalues: math_clamp (copy), math_sqrt (copy)
    local v9 = p7 - p5;
    local v10 = p8 - p6;
    local v11 = v9 * v9 + v10 * v10;
    local v12 = v11 > 0 and (math_clamp(((p3 - p5) * v9 + (p4 - p6) * v10) / v11, 0, 1) or 0) or 0;
    local v13 = p3 - (p5 + v9 * v12);
    local v14 = p4 - (p6 + v10 * v12);

    return math_sqrt(v13 * v13 + v14 * v14);
end;

local function _(p15, p16, p17, p18, p19, p20, p21) -- Line: 120
    -- upvalues: math_max (copy), math_sqrt (copy), math_min (copy)
    local v22 = math.abs(p15 - p17) - (p19 - p21);
    local v23 = math.abs(p16 - p18) - (p20 - p21);
    local v24 = math_max(v22, 0);
    local v25 = math_max(v23, 0);

    return math_sqrt(v24 * v24 + v25 * v25) + math_min(math_max(v22, v23), 0) - p21;
end;

local function u126(p26, u27, u28) -- Line: 127
    -- upvalues: math_clamp (copy), math_sqrt (copy), math_max (copy), math_min (copy)
    local v29 = p26[1];

    if v29 == "seg" then
        local v30 = p26[2];
        local v31 = p26[3];
        local v32 = p26[4] - v30;
        local v33 = p26[5] - v31;
        local v34 = v32 * v32 + v33 * v33;
        local v35 = v34 > 0 and (math_clamp(((u27 - v30) * v32 + (u28 - v31) * v33) / v34, 0, 1) or 0) or 0;
        local v36 = u27 - (v30 + v32 * v35);
        local v37 = u28 - (v31 + v33 * v35);

        return math_sqrt(v36 * v36 + v37 * v37) - p26[6] / 2;
    end;

    if v29 == "segring" then
        local v38 = p26[2];
        local v39 = p26[3];
        local v40 = p26[4] - v38;
        local v41 = p26[5] - v39;
        local v42 = v40 * v40 + v41 * v41;
        local v43 = v42 > 0 and (math_clamp(((u27 - v38) * v40 + (u28 - v39) * v41) / v42, 0, 1) or 0) or 0;
        local v44 = u27 - (v38 + v40 * v43);
        local v45 = u28 - (v39 + v41 * v43);
        local v46 = math_sqrt(v44 * v44 + v45 * v45) - p26[6] / 2;

        return math.abs(v46) - p26[7] / 2;
    end;

    if v29 ~= "tri" then
        if v29 == "poly" then
            local v47 = p26[2];
            local v48 = #v47 // 2;
            local v49 = 0;
            local v50 = 0;

            for i = 1, v48 do
                v49 = v49 + v47[i * 2 - 1];
                v50 = v50 + v47[i * 2];
                local _ = i;
            end;

            local v51 = v49 / v48;
            local v52 = v50 / v48;
            local v53 = (-1 / 0);
            local v54 = (1 / 0);

            for i = 1, v48 do
                local v55 = i % v48 + 1;
                local v56 = v47[i * 2 - 1];
                local v57 = v47[i * 2];
                local v58 = v47[v55 * 2 - 1];
                local v59 = v47[v55 * 2];
                local v60 = v58 - v56;
                local v61 = v59 - v57;
                local v62 = math_sqrt(v60 * v60 + v61 * v61);
                local v63 = v61 / v62;
                local v64 = -v60 / v62;

                if (v51 - v56) * v63 + (v52 - v57) * v64 > 0 then
                    v63 = -v63;
                    v64 = -v64;
                end;

                v53 = math_max(v53, (u27 - v56) * v63 + (u28 - v57) * v64);
                local v65 = v58 - v56;
                local v66 = v59 - v57;
                local v67 = v65 * v65 + v66 * v66;
                local v68 = v67 > 0 and (math_clamp(((u27 - v56) * v65 + (u28 - v57) * v66) / v67, 0, 1) or 0) or 0;
                local v69 = u27 - (v56 + v65 * v68);
                local v70 = u28 - (v57 + v66 * v68);
                v54 = math_min(v54, (math_sqrt(v69 * v69 + v70 * v70)));
                local _ = i;
            end;

            if v53 > 0 then
                v53 = v54 or v53;
            end;

            return v53 - (p26.grow or 0);
        end;

        if v29 == "box" then
            local v71 = p26[4] - p26[2];
            local v72 = p26[5] - p26[3];
            local v73 = math_sqrt(v71 * v71 + v72 * v72);
            local v74 = v71 / v73;
            local v75 = v72 / v73;
            local v76 = u27 - p26[2];
            local v77 = u28 - p26[3];
            local v78 = math.abs(v76 * v74 + v77 * v75 - v73 / 2) - v73 / 2;
            local v79 = math.abs(-v76 * v75 + v77 * v74) - p26[6] / 2;
            local v80 = math_max(v78, 0);
            local v81 = math_max(v79, 0);

            return math_sqrt(v80 * v80 + v81 * v81) + math_min(math_max(v78, v79), 0);
        end;

        if v29 ~= "rect" then
            local v82 = u27 - p26[2];
            local v83 = u28 - p26[3];
            local v84 = math_sqrt(v82 * v82 + v83 * v83) - p26[4];

            if p26[5] then
                v84 = math.abs(v84) - p26[5] / 2 or v84;
            end;

            return v84;
        end;

        local v85 = p26[3];
        local v86 = p26[4];
        local v87 = p26[5];
        local v88 = p26[6];
        local v89 = math.abs(u27 - p26[2]) - (v86 - v88);
        local v90 = math.abs(u28 - v85) - (v87 - v88);
        local v91 = math_max(v89, 0);
        local v92 = math_max(v90, 0);
        local v93 = math_sqrt(v91 * v91 + v92 * v92) + math_min(math_max(v89, v90), 0) - v88;

        if p26[7] then
            v93 = math.abs(v93) - p26[7] / 2 or v93;
        end;

        return v93;
    end;

    local function _(p94, p95, p96, p97, p98, p99) -- Line: 134
        -- upvalues: math_sqrt (ref), u27 (copy), u28 (copy)
        local v100 = p96 - p94;
        local v101 = p97 - p95;
        local v102 = math_sqrt(v100 * v100 + v101 * v101);
        local v103 = v101 / v102;
        local v104 = -v100 / v102;

        if (p98 - p94) * v103 + (p99 - p95) * v104 > 0 then
            v103 = -v103;
            v104 = -v104;
        end;

        return (u27 - p94) * v103 + (u28 - p95) * v104;
    end;

    local v105 = p26[2];
    local v106 = p26[3];
    local v107 = p26[4];
    local v108 = p26[5];
    local v109 = p26[6];
    local v110 = p26[7];
    local v111 = v107 - v105;
    local v112 = v108 - v106;
    local v113 = math_sqrt(v111 * v111 + v112 * v112);
    local v114 = v112 / v113;
    local v115 = -v111 / v113;

    if (v109 - v105) * v114 + (v110 - v106) * v115 > 0 then
        v114 = -v114;
        v115 = -v115;
    end;

    local v116 = v109 - v107;
    local v117 = v110 - v108;
    local v118 = math_sqrt(v116 * v116 + v117 * v117);
    local v119 = v117 / v118;
    local v120 = -v116 / v118;

    if (v105 - v107) * v119 + (v106 - v108) * v120 > 0 then
        v119 = -v119;
        v120 = -v120;
    end;

    local v121 = v105 - v109;
    local v122 = v106 - v110;
    local v123 = math_sqrt(v121 * v121 + v122 * v122);
    local v124 = v122 / v123;
    local v125 = -v121 / v123;

    if (v107 - v109) * v124 + (v108 - v110) * v125 > 0 then
        v124 = -v124;
        v125 = -v125;
    end;

    return math_max((u27 - v105) * v114 + (u28 - v106) * v115, (u27 - v107) * v119 + (u28 - v108) * v120, (u27 - v109) * v124 + (u28 - v110) * v125) - (p26.grow or 0);
end;

local v127 = { 0.2, 0.25 };
local v128 = { 0.93, 0.33 };
local v129 = { 0.85, 0.62 };
local v130 = { 0.26, 0.64 };

local function _(p131, p132, p133) -- Line: 344
    return p131[1] + (p132[1] - p131[1]) * p133, p131[2] + (p132[2] - p131[2]) * p133;
end;

local v134 = {
    { "seg", 0.05, 0.12, 0.15, 0.16, 0.075 },
    {
        "seg",
        0.15,
        0.16,
        v127[1],
        v127[2],
        0.075
    },
    {
        "seg",
        v127[1],
        v127[2],
        v128[1],
        v128[2],
        0.075
    },
    {
        "seg",
        v128[1],
        v128[2],
        v129[1],
        v129[2],
        0.075
    },
    {
        "seg",
        v129[1],
        v129[2],
        v130[1],
        v130[2],
        0.075
    },
    {
        "seg",
        v130[1],
        v130[2],
        v127[1],
        v127[2],
        0.075
    },
    {
        "seg",
        v130[1],
        v130[2],
        0.23,
        0.79,
        0.075
    },
    { "seg", 0.23, 0.79, 0.84, 0.79, 0.075 },
    { "circle", 0.29, 0.88, 0.065, 0.06 },
    { "circle", 0.78, 0.88, 0.065, 0.06 }
};
local u135 = {
    Arrow = { { "seg", 0.16, 0.5, 0.66, 0.5, 0.13 }, { "tri", 0.56, 0.24, 0.56, 0.76, 0.88, 0.5 } },
    Timer = { { "circle", 0.5, 0.57, 0.3, 0.1 }, { "rect", 0.5, 0.13, 0.09, 0.05, 0.02 }, { "seg", 0.5, 0.17, 0.5, 0.27, 0.08 }, { "seg", 0.5, 0.57, 0.5, 0.4, 0.08 }, { "seg", 0.74, 0.27, 0.8, 0.21, 0.07 } },
    Grid = { { "rect", 0.5, 0.5, 0.36, 0.36, 0.07, 0.08 }, { "seg", 0.38, 0.16, 0.38, 0.84, 0.07 }, { "seg", 0.62, 0.16, 0.62, 0.84, 0.07 }, { "seg", 0.16, 0.38, 0.84, 0.38, 0.07 }, { "seg", 0.16, 0.62, 0.84, 0.62, 0.07 } },
    SleepingBags = { { "rect", 0.13, 0.53, 0.055, 0.29, 0.02 }, { "rect", 0.5, 0.665, 0.42, 0.05, 0.015 }, { "rect", 0.88, 0.74, 0.04, 0.12, 0.015 }, { "circle", 0.3, 0.48, 0.085 }, { "rect", 0.64, 0.5, 0.25, 0.09, 0.07 } },
    Follow = { { "circle", 0.5, 0.5, 0.36, 0.085 }, { "seg", 0.34, 0.6, 0.5, 0.39, 0.1 }, { "seg", 0.5, 0.39, 0.66, 0.6, 0.1 } },
    Pen = { { "rect", 0.5, 0.21, 0.19, 0.15, 0.04 }, {
            "seg",
            0.4,
            0.04,
            0.4,
            0.2,
            0.035,
            cut = true
        }, {
            "seg",
            0.5,
            0.04,
            0.5,
            0.15,
            0.035,
            cut = true
        }, {
            "seg",
            0.6,
            0.04,
            0.6,
            0.22,
            0.035,
            cut = true
        }, { "rect", 0.5, 0.4, 0.19, 0.03, 0.01 }, { "rect", 0.5, 0.48, 0.19, 0.03, 0.01 }, { "rect", 0.5, 0.545, 0.09, 0.04, 0.02 }, { "seg", 0.5, 0.6, 0.5, 0.86, 0.15 }, {
            "circle",
            0.5,
            0.83,
            0.035,
            cut = true
        } },
    Eraser = { { "segring", 0.33, 0.64, 0.66, 0.31, 0.3, 0.07 }, { "seg", 0.36, 0.42, 0.56, 0.62, 0.06 }, { "seg", 0.2, 0.86, 0.8, 0.86, 0.06 } },
    Clear = { { "rect", 0.5, 0.6, 0.2, 0.24, 0.04, 0.07 }, { "seg", 0.24, 0.32, 0.76, 0.32, 0.07 }, { "seg", 0.42, 0.23, 0.58, 0.23, 0.07 }, { "seg", 0.43, 0.48, 0.43, 0.72, 0.05 }, { "seg", 0.57, 0.48, 0.57, 0.72, 0.05 } },
    Marker = { { "circle", 0.5, 0.374, 0.27 }, { "tri", 0.267, 0.511, 0.733, 0.511, 0.5, 0.905 }, {
            "circle",
            0.5,
            0.374,
            0.108,
            cut = true
        } },
    Home = { {
            "poly",
            { 0.5, 0.15, 0.1, 0.47, 0.9, 0.47 },
            grow = 0.04
        }, { "rect", 0.5, 0.7, 0.36, 0.22, 0.045 }, {
            "rect",
            0.5,
            0.88,
            0.095,
            0.2,
            0.03,
            cut = true
        } },
    Ore = { {
            "poly",
            { 0.22, 0.17, 0.53, 0.1, 0.79, 0.14, 0.9, 0.37, 0.95, 0.61, 0.89, 0.76, 0.69, 0.86, 0.42, 0.89, 0.21, 0.85, 0.07, 0.72, 0.05, 0.62, 0.09, 0.4, 0.14, 0.27 },
            grow = 0.01
        }, {
            "seg",
            0.22,
            0.17,
            0.32,
            0.22,
            0.032,
            cut = true
        }, {
            "seg",
            0.32,
            0.22,
            0.28,
            0.52,
            0.032,
            cut = true
        }, {
            "seg",
            0.28,
            0.52,
            0.58,
            0.69,
            0.032,
            cut = true
        }, {
            "seg",
            0.58,
            0.69,
            0.87,
            0.58,
            0.032,
            cut = true
        }, {
            "seg",
            0.28,
            0.52,
            0.06,
            0.66,
            0.032,
            cut = true
        }, {
            "seg",
            0.58,
            0.69,
            0.5,
            0.88,
            0.032,
            cut = true
        } },
    Skull = { { "circle", 0.5, 0.42, 0.31 }, { "rect", 0.5, 0.72, 0.18, 0.13, 0.05 }, {
            "circle",
            0.38,
            0.44,
            0.085,
            cut = true
        }, {
            "circle",
            0.62,
            0.44,
            0.085,
            cut = true
        }, {
            "circle",
            0.5,
            0.6,
            0.04,
            cut = true
        }, {
            "seg",
            0.44,
            0.68,
            0.44,
            0.86,
            0.04,
            cut = true
        }, {
            "seg",
            0.56,
            0.68,
            0.56,
            0.86,
            0.04,
            cut = true
        } },
    Action = { { "circle", 0.5, 0.5, 0.27, 0.08 }, { "seg", 0.5, 0.06, 0.5, 0.3, 0.08 }, { "seg", 0.5, 0.7, 0.5, 0.94, 0.08 }, { "seg", 0.06, 0.5, 0.3, 0.5, 0.08 }, { "seg", 0.7, 0.5, 0.94, 0.5, 0.08 }, { "circle", 0.5, 0.5, 0.06 } },
    MonumentNames = { { "seg", 0.2, 0.22, 0.8, 0.22, 0.12 }, { "seg", 0.2, 0.22, 0.2, 0.32, 0.1 }, { "seg", 0.8, 0.22, 0.8, 0.32, 0.1 }, { "seg", 0.5, 0.22, 0.5, 0.8, 0.13 }, { "seg", 0.36, 0.82, 0.64, 0.82, 0.09 } },
    Close = { { "seg", 0.28, 0.28, 0.72, 0.72, 0.1 }, { "seg", 0.72, 0.28, 0.28, 0.72, 0.1 } },
    Check = { { "seg", 0.18, 0.52, 0.4, 0.74, 0.12 }, { "seg", 0.4, 0.74, 0.82, 0.3, 0.12 } }
};

local function u142(p136, u137) -- Line: 187
    local function _(p138) -- Line: 189
        -- upvalues: u137 (copy)
        return (p138 - 0.5) * u137 + 0.5;
    end;

    local v139 = {};

    for i, v in p136 do
        if v[1] == "seg" then
            v139[i] = {
                "seg",
                (v[2] - 0.5) * u137 + 0.5,
                (v[3] - 0.5) * u137 + 0.5,
                (v[4] - 0.5) * u137 + 0.5,
                (v[5] - 0.5) * u137 + 0.5,
                v[6] * u137
            };
        elseif v[1] == "segring" then
            v139[i] = {
                "segring",
                (v[2] - 0.5) * u137 + 0.5,
                (v[3] - 0.5) * u137 + 0.5,
                (v[4] - 0.5) * u137 + 0.5,
                (v[5] - 0.5) * u137 + 0.5,
                v[6] * u137,
                v[7] * u137
            };
        elseif v[1] == "rect" then
            local v140 = {};
            v140[1], v140[2], v140[3], v140[4], v140[5], v140[6], v140[7] = "rect", (v[2] - 0.5) * u137 + 0.5, (v[3] - 0.5) * u137 + 0.5, v[4] * u137, v[5] * u137, v[6] * u137, v[7] and v[7] * u137;
            v139[i] = v140;
        else
            local v141 = {};
            v141[1], v141[2], v141[3], v141[4], v141[5] = "circle", (v[2] - 0.5) * u137 + 0.5, (v[3] - 0.5) * u137 + 0.5, v[4] * u137, v[5] and v[5] * u137;
            v139[i] = v141;
        end;

        v139[i].cut = v.cut;
    end;

    return v139;
end;

local u143 = {
    [1] = "Marker",
    [2] = "Home",
    [3] = "Skull",
    [4] = "Bed",
    [6] = "Action",
    [7] = "Ore"
};

local function u165(u144: number, p145: any, p146: number?) -- Line: 207
    -- upvalues: AssetService (copy), u126 (copy), math_min (copy), math_max (copy), math_clamp (copy), math_floor (copy)
    local u147 = p146 or u144;
    local success, result = pcall(function() -- Line: 209
        -- upvalues: AssetService (ref), u144 (copy), u147 (copy)
        return AssetService:CreateEditableImage({
            Size = Vector2.new(u144, u147)
        });
    end);

    if not (success and result) then
        return nil;
    end;

    local buffer_create_ret = buffer.create(u144 * u147 * 4);

    for i = 0, u147 - 1 do
        local v148 = i;

        for i2 = 0, u144 - 1 do
            local v149 = (i2 + 0.5) / u144;
            local v150 = (v148 + 0.5) / u144;
            local v151 = i2;
            local v152 = 0;
            local v153 = 0;
            local v154 = 0;
            local v155 = 0;

            for _, v in p145 do
                local v156 = v;
                local v157 = (1 / 0);
                local v158 = (1 / 0);

                for _, v2 in v.Shapes do
                    if v2.cut then
                        v157 = math_min(v157, (u126(v2, v149, v150)));
                    else
                        v158 = math_min(v158, (u126(v2, v149, v150)));
                    end;
                end;

                local v159 = math_clamp(0.5 - math_max(v158, -v157) * u144, 0, 1) * (v156.Alpha or 1);

                if v159 > 0 then
                    local Colour = v156.Colour;
                    v152 = Colour.R * v159 + v152 * (1 - v159);
                    v153 = Colour.G * v159 + v153 * (1 - v159);
                    v154 = Colour.B * v159 + v154 * (1 - v159);
                    v155 = v159 + v155 * (1 - v159);
                end;
            end;

            if v155 > 0 then
                local v160 = (v148 * u144 + v151) * 4;
                local v161 = math_floor(v152 / v155 * 255 + 0.5);
                buffer.writeu8(buffer_create_ret, v160, v161);
                local v162 = math_floor(v153 / v155 * 255 + 0.5);
                buffer.writeu8(buffer_create_ret, v160 + 1, v162);
                local v163 = math_floor(v154 / v155 * 255 + 0.5);
                buffer.writeu8(buffer_create_ret, v160 + 2, v163);
                local v164 = math_floor(v155 * 255 + 0.5);
                buffer.writeu8(buffer_create_ret, v160 + 3, v164);
            end;
        end;
    end;

    result:WritePixelsBuffer(Vector2.zero, Vector2.new(u144, u147), buffer_create_ret);

    return Content.fromObject(result);
end;

local u166 = {
    [1] = "Marker",
    [2] = "Home",
    [3] = "Skull",
    [4] = "SleepingBags",
    [6] = "Action",
    [7] = "Ore"
};
local u167 = { 1, 2, 3, 4, 7, 6 };
local u168 = {
    Transparency = 0.12,
    Bleed = 2,
    BleedX = 0
};
local u169 = { {
        Key = "Grid",
        Name = "Grid"
    }, {
        Key = "SleepingBags",
        Name = "Sleeping Bags"
    }, {
        Key = "VendingMachines",
        Name = "Shop Machines"
    }, {
        Key = "MonumentNames",
        Name = "Monument Names"
    }, {
        Key = "Follow",
        Name = "Follow Player"
    } };

for _, v in { 0.3333333333333333, 0.6666666666666666 } do
    v134[#v134 + 1] = {
        "seg",
        v127[1] + (v128[1] - v127[1]) * v,
        v127[2] + (v128[2] - v127[2]) * v,
        v130[1] + (v129[1] - v130[1]) * v,
        v130[2] + (v129[2] - v130[2]) * v,
        0.055
    };
end;

v134[#v134 + 1] = {
    "seg",
    v127[1] + (v130[1] - v127[1]) * 0.5,
    v127[2] + (v130[2] - v127[2]) * 0.5,
    v128[1] + (v129[1] - v128[1]) * 0.5,
    v128[2] + (v129[2] - v128[2]) * 0.5,
    0.055
};
u135.VendingMachines = v134;
local v170 = { { "seg", 0.3, 0.38, 0.6, 0.38, 0.07 }, { "seg", 0.3, 0.38, 0.42, 0.26, 0.07 }, { "seg", 0.3, 0.38, 0.42, 0.5, 0.07 }, { "seg", 0.6, 0.74, 0.36, 0.74, 0.07 } };

for i = 1, 10 do
    local v171 = -1.5707963267948966 + 3.141592653589793 * (i - 1) / 10;
    local v172 = -1.5707963267948966 + 3.141592653589793 * i / 10;
    v170[#v170 + 1] = {
        "seg",
        math.cos(v171) * 0.18 + 0.6,
        math.sin(v171) * 0.18 + 0.56,
        math.cos(v172) * 0.18 + 0.6,
        math.sin(v172) * 0.18 + 0.56,
        0.07
    };
    local _ = i;
end;

u135.Undo = v170;
local v173 = {};

for i, v in v170 do
    v173[i] = {
        "seg",
        1 - v[2],
        v[3],
        1 - v[4],
        v[5],
        v[6]
    };
end;

u135.Redo = v173;
local u174 = {
    Tip = Vector2.new(0.26, 0.74),
    Body = { { "seg", 0.9, 0.1, 0.63, 0.37, 0.12 }, { "box", 0.64, 0.36, 0.48, 0.52, 0.3 } },
    Bristles = { { "box", 0.455, 0.545, 0.26, 0.74, 0.3 }, {
            "seg",
            0.26,
            0.74,
            0.34,
            0.66,
            0.035,
            cut = true
        } },
    Rubber = { { "box", 0.25, 0.75, 0.45, 0.55, 0.32 } },
    Sleeve = { { "box", 0.45, 0.55, 0.8, 0.2, 0.32 } }
};

local function u187(p175, p176) -- Line: 391
    -- upvalues: math_sqrt (copy)
    local v177 = {};

    for _, v in p175 do
        if not v.cut then
            local v178 = v[2];
            local v179 = v[3];
            local v180 = v[4];
            local v181 = v[5];

            if v[1] == "box" then
                local v182 = v180 - v178;
                local v183 = v181 - v179;
                local v184 = math_sqrt(v182 * v182 + v183 * v183);
                local v185 = v182 / v184 * p176 / 2;
                local v186 = v183 / v184 * p176 / 2;
                v178 = v178 - v185;
                v179 = v179 - v186;
                v180 = v180 + v185;
                v181 = v181 + v186;
            end;

            v177[#v177 + 1] = {
                v[1],
                v178,
                v179,
                v180,
                v181,
                v[6] + p176
            };
        end;
    end;

    return v177;
end;

local u188 = {};

local function _(p189: string, p190: any) -- Line: 409
    -- upvalues: u188 (copy)
    if u188[p189] == nil then
        u188[p189] = p190() or false;
    end;

    return u188[p189] or nil;
end;

local function _(u191: string, u192: number) -- Line: 417
    -- upvalues: u165 (copy), u135 (copy), u188 (copy)
    local v193 = u191 .. u192;

    local function v194() -- Line: 418
        -- upvalues: u165 (ref), u192 (copy), u135 (ref), u191 (copy)
        return u165(u192, {
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = u135[u191]
            }
        });
    end;

    if u188[v193] == nil then
        u188[v193] = v194() or false;
    end;

    return u188[v193] or nil;
end;

local function _(p195) -- Line: 430
    return Color3.new(p195.R * 0.65, p195.G * 0.65, p195.B * 0.65);
end;

local function _(u196: number) -- Line: 435
    -- upvalues: u1 (copy), u165 (copy), u188 (copy)
    local v197 = "Tear" .. u196;

    local function v200() -- Line: 436
        -- upvalues: u1 (ref), u196 (copy), u165 (ref)
        local v198 = u1[u196] or u1[1];
        local Color3_new_ret = Color3.new(v198.R * 0.65, v198.G * 0.65, v198.B * 0.65);
        local v199 = { "tri", 0.241, 0.512, 0.759, 0.512, 0.5, 0.95 };

        return u165(38, {
            {
                Colour = Color3_new_ret,
                Shapes = {
                    { "circle", 0.5, 0.36, 0.33999999999999997 },
                    {
                        "tri",
                        v199[2],
                        v199[3],
                        v199[4],
                        v199[5],
                        v199[6],
                        v199[7],
                        grow = 0.04
                    }
                }
            },
            {
                Colour = v198,
                Shapes = {
                    { "circle", 0.5, 0.36, 0.3 },
                    v199
                }
            },
            {
                Colour = Color3_new_ret,
                Shapes = { { "circle", 0.5, 0.36, 0.12 } }
            }
        });
    end;

    if u188[v197] == nil then
        u188[v197] = v200() or false;
    end;

    return u188[v197] or nil;
end;

local function _() -- Line: 449
    -- upvalues: u165 (copy), Color3_fromRGB_ret5 (copy), u142 (copy), u135 (copy), u188 (copy)
    local function v201() -- Line: 450
        -- upvalues: u165 (ref), Color3_fromRGB_ret5 (ref), u142 (ref), u135 (ref)
        return u165(24, {
            {
                Alpha = 0.92,
                Colour = Color3.fromRGB(28, 28, 28),
                Shapes = { { "circle", 0.5, 0.5, 0.46 } }
            },
            {
                Colour = Color3_fromRGB_ret5,
                Shapes = { { "circle", 0.5, 0.5, 0.42, 0.09 } }
            },
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = u142(u135.SleepingBags, 0.58)
            }
        });
    end;

    if u188.BagBadge == nil then
        u188.BagBadge = v201() or false;
    end;

    return u188.BagBadge or nil;
end;

local function _(u202: string) -- Line: 459
    -- upvalues: u165 (copy), Color3_fromRGB_ret6 (copy), u187 (copy), u174 (copy), u188 (copy)
    local v203 = "Cursor" .. u202;

    local function v205() -- Line: 460
        -- upvalues: u202 (copy), u165 (ref), Color3_fromRGB_ret6 (ref), u187 (ref), u174 (ref)
        if u202 == "Eraser" then
            return u165(36, {
                {
                    Colour = Color3_fromRGB_ret6,
                    Shapes = u187({ u174.Rubber[1], u174.Sleeve[1] }, 0.09)
                },
                {
                    Colour = Color3.fromRGB(236, 128, 146),
                    Shapes = u174.Rubber
                },
                {
                    Colour = Color3.fromRGB(205, 205, 210),
                    Shapes = u174.Sleeve
                },
                {
                    Colour = Color3_fromRGB_ret6,
                    Shapes = { { "seg", 0.337, 0.43700000000000006, 0.5630000000000001, 0.663, 0.03 } }
                }
            });
        end;

        local v204 = u174[u202];

        return u165(36, {
            {
                Colour = Color3_fromRGB_ret6,
                Shapes = u187(v204, 0.09)
            },
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = v204
            }
        });
    end;

    if u188[v203] == nil then
        u188[v203] = v205() or false;
    end;

    return u188[v203] or nil;
end;

local function _(p206: userdata, p207) -- Line: 478
    local Color3_new_ret = Color3.new(p207.R * 0.65, p207.G * 0.65, p207.B * 0.65);
    p206.BackgroundColor3 = p207;
    p206.BackgroundTransparency = 0;
    p206.Ring.Color = Color3_new_ret;
    local Icon = p206:FindFirstChild("Icon");

    if Icon then
        Icon.ImageColor3 = Color3_new_ret;
    end;
end;

local function _(p208: userdata) -- Line: 489
    -- upvalues: Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy)
    p208.BackgroundColor3 = Color3_fromRGB_ret3;
    p208.BackgroundTransparency = 0.1;
    p208.Ring.Color = Color3_fromRGB_ret4;
    local Icon = p208:FindFirstChild("Icon");

    if Icon then
        Icon.ImageColor3 = Color3_fromRGB_ret4;
    end;
end;

local u215 = {
    SetIcon = function(p209: userdata, u210: string, u211: number) -- Line: 423
        -- upvalues: u165 (copy), u135 (copy), u188 (copy)
        local v212 = u210 .. u211;

        local function v213() -- Line: 418
            -- upvalues: u165 (ref), u211 (copy), u135 (ref), u210 (copy)
            return u165(u211, {
                {
                    Colour = Color3.new(1, 1, 1),
                    Shapes = u135[u210]
                }
            });
        end;

        if u188[v212] == nil then
            u188[v212] = v213() or false;
        end;

        local v214 = u188[v212] or nil;

        if v214 then
            p209.ImageContent = v214;
        end;
    end
};
local u216 = nil;
local u217 = {
    Grid = true,
    SleepingBags = true,
    VendingMachines = true,
    MonumentNames = true,
    Follow = false
};
local u218 = MapDrawing.new(MapRenderClient);
MapRenderClient.Drawing = u218;
local u219 = {
    On = false,
    Colour = 3,
    Erasing = false,
    Stroking = false,
    Input = nil,
    Pad = false,
    Flashes = 0
};
local u220 = {};
local u221 = nil;
local u222 = {
    Icon = 1,
    Colour = 1
};
local u223 = {
    Down = false,
    Used = false
};
local u224 = {
    Right = nil,
    RightAt = 0,
    Left = nil
};
local u225 = {
    Last = nil,
    Chasing = false,
    Seen = false
};
local u226 = {
    Hidden = false,
    Shown = nil,
    Pad = nil
};
local u227 = {
    Last = nil,
    Travel = 0,
    Was = false,
    At = 0,
    Turn = {},
    Rng = Random.new()
};
local u228 = nil;
local u229 = {
    Rev = nil,
    Pending = nil,
    LastSent = 0,
    Mirror = {}
};

local function _() -- Line: 522
    -- upvalues: u228 (ref)
    u228 = os.clock() + 2;
end;

local function _(p230) -- Line: 529
    -- upvalues: u216 (ref), GuiService (copy)
    local v231;

    if u216.Gui.IgnoreGuiInset then
        v231 = Vector2.zero;
    else
        v231 = GuiService:GetGuiInset();
    end;

    return p230 - v231 + u216.Map.AbsolutePosition;
end;

local function _(p232: vector) -- Line: 534
    -- upvalues: GuiService (copy), u216 (ref)
    local v233 = Vector2.new(p232.X, p232.Y) + GuiService:GetGuiInset();
    local v234;

    if u216.Gui.IgnoreGuiInset then
        v234 = Vector2.zero;
    else
        v234 = GuiService:GetGuiInset();
    end;

    return v233 - v234 + u216.Map.AbsolutePosition;
end;

local function _() -- Line: 538
    -- upvalues: UserInputService (copy), u216 (ref), GuiService (copy)
    local MouseLocation = UserInputService:GetMouseLocation();
    local v235;

    if u216.Gui.IgnoreGuiInset then
        v235 = Vector2.zero;
    else
        v235 = GuiService:GetGuiInset();
    end;

    return MouseLocation - v235 + u216.Map.AbsolutePosition;
end;

local function _(p236: userdata, p237) -- Line: 542
    local v238 = p237 - p236.AbsolutePosition;
    local AbsoluteSize = p236.AbsoluteSize;
    local Visible = p236.Visible;

    if Visible then
        if v238.X >= 0 and (v238.Y >= 0 and v238.X <= AbsoluteSize.X) then
            Visible = v238.Y <= AbsoluteSize.Y;
        else
            Visible = false;
        end;
    end;

    return Visible;
end;

local function _(p239) -- Line: 549
    -- upvalues: u216 (ref)
    return (p239 - u216.Content.AbsolutePosition) / u216.Content.AbsoluteSize;
end;

local function _(p240) -- Line: 553
    local v241;

    if p240.X >= 0 and (p240.X <= 1 and p240.Y >= 0) then
        v241 = p240.Y <= 1;
    else
        v241 = false;
    end;

    return v241;
end;

local function _() -- Line: 557
    -- upvalues: u216 (ref)
    return u216.Map:GetAttribute("Locked") == true;
end;

local function u252(p242) -- Line: 562
    -- upvalues: u216 (ref)
    if u216.CloseMap.Visible then
        local CloseMap = u216.CloseMap;
        local v243 = p242 - CloseMap.AbsolutePosition;
        local AbsoluteSize = CloseMap.AbsoluteSize;
        local Visible = CloseMap.Visible;

        if Visible then
            if v243.X >= 0 and (v243.Y >= 0 and v243.X <= AbsoluteSize.X) then
                Visible = v243.Y <= AbsoluteSize.Y;
            else
                Visible = false;
            end;
        end;

        if Visible then
            return true;
        end;
    end;

    for _, v in { u216.DeathFooter, u216.DeathHeader } do
        if v.Visible and v.Parent.Visible then
            local v244 = p242 - v.AbsolutePosition;
            local AbsoluteSize = v.AbsoluteSize;
            local Visible = v.Visible;

            if Visible then
                if v244.X >= 0 and (v244.Y >= 0 and v244.X <= AbsoluteSize.X) then
                    Visible = v244.Y <= AbsoluteSize.Y;
                else
                    Visible = false;
                end;
            end;

            if Visible then
                return true;
            end;
        end;
    end;

    for _, v in u216.LookPanels do
        if v.Visible then
            local v245 = p242 - v.AbsolutePosition;
            local AbsoluteSize = v.AbsoluteSize;
            local Visible = v.Visible;

            if Visible then
                if v245.X >= 0 and (v245.Y >= 0 and v245.X <= AbsoluteSize.X) then
                    Visible = v245.Y <= AbsoluteSize.Y;
                else
                    Visible = false;
                end;
            end;

            if Visible then
                return true;
            end;
        end;
    end;

    for _, v in u216.PinLayers do
        for _, child in v:GetChildren() do
            if child:IsA("GuiButton") and child.Visible then
                local v246 = p242 - child.AbsolutePosition;
                local AbsoluteSize = child.AbsoluteSize;
                local Visible = child.Visible;

                if Visible then
                    if v246.X >= 0 and (v246.Y >= 0 and v246.X <= AbsoluteSize.X) then
                        Visible = v246.Y <= AbsoluteSize.Y;
                    else
                        Visible = false;
                    end;
                end;

                if Visible then
                    return true;
                end;
            end;
        end;
    end;

    if not u216.Tools.Visible then
        return false;
    end;

    local Controls = u216.Controls;
    local v247 = p242 - Controls.AbsolutePosition;
    local AbsoluteSize = Controls.AbsoluteSize;
    local Visible = Controls.Visible;

    if Visible then
        if v247.X >= 0 and (v247.Y >= 0 and v247.X <= AbsoluteSize.X) then
            Visible = v247.Y <= AbsoluteSize.Y;
        else
            Visible = false;
        end;
    end;

    if Visible then
        return true;
    end;

    if u216.Editor.Visible then
        local Editor = u216.Editor;
        local v248 = p242 - Editor.AbsolutePosition;
        local AbsoluteSize2 = Editor.AbsoluteSize;
        local Visible2 = Editor.Visible;

        if Visible2 then
            if v248.X >= 0 and (v248.Y >= 0 and v248.X <= AbsoluteSize2.X) then
                Visible2 = v248.Y <= AbsoluteSize2.Y;
            else
                Visible2 = false;
            end;
        end;

        if Visible2 then
            return true;
        end;

        local EditorBack = u216.EditorBack;
        local v249 = p242 - EditorBack.AbsolutePosition;
        local AbsoluteSize3 = EditorBack.AbsoluteSize;
        local Visible3 = EditorBack.Visible;

        if Visible3 then
            if v249.X >= 0 and (v249.Y >= 0 and v249.X <= AbsoluteSize3.X) then
                Visible3 = v249.Y <= AbsoluteSize3.Y;
            else
                Visible3 = false;
            end;
        end;

        if Visible3 then
            return true;
        end;
    end;

    for _, v in u216.Views do
        local Tab = v.Tab;
        local v250 = p242 - Tab.AbsolutePosition;
        local AbsoluteSize2 = Tab.AbsoluteSize;
        local Visible2 = Tab.Visible;

        if Visible2 then
            if v250.X >= 0 and (v250.Y >= 0 and v250.X <= AbsoluteSize2.X) then
                Visible2 = v250.Y <= AbsoluteSize2.Y;
            else
                Visible2 = false;
            end;
        end;

        if Visible2 then
            return true;
        end;

        local Pin = v.Pin;
        local v251 = p242 - Pin.AbsolutePosition;
        local AbsoluteSize3 = Pin.AbsoluteSize;
        local Visible3 = Pin.Visible;

        if Visible3 then
            if v251.X >= 0 and (v251.Y >= 0 and v251.X <= AbsoluteSize3.X) then
                Visible3 = v251.Y <= AbsoluteSize3.Y;
            else
                Visible3 = false;
            end;
        end;

        if Visible3 then
            return true;
        end;
    end;

    return false;
end;

local function _(p253) -- Line: 601
    -- upvalues: u216 (ref)
    local AbsoluteSize = u216.Map.AbsoluteSize;

    if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
        return nil;
    end;

    return (u216.Map.AbsolutePosition + AbsoluteSize / 2 - (u216.Content.AbsolutePosition + p253 * u216.Content.AbsoluteSize)) / AbsoluteSize;
end;

local function u257(p254) -- Line: 611
    -- upvalues: u216 (ref), GuiUtil (copy)
    local Frame = u216.Frame;
    local Position = Frame.Position;
    local v255, v256 = GuiUtil:ClampPosition(u216.Map, Position.X.Scale + p254.X, Position.Y.Scale + p254.Y, Frame.Size.X.Scale);

    if math.abs(v255 - Position.X.Scale) < 1e-6 and math.abs(v256 - Position.Y.Scale) < 1e-6 then
        return false;
    end;

    Frame.Position = UDim2.fromScale(v255, v256);

    return true;
end;

local function _(p258) -- Line: 622
    -- upvalues: u216 (ref), u257 (copy)
    local AbsoluteSize = u216.Map.AbsoluteSize;
    local v259;

    if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
        v259 = nil;
    else
        v259 = (u216.Map.AbsolutePosition + AbsoluteSize / 2 - (u216.Content.AbsolutePosition + p258 * u216.Content.AbsoluteSize)) / AbsoluteSize;
    end;

    if v259 then
        u257(v259);
    end;
end;

local function _() -- Line: 629
    -- upvalues: LocalPlayer (copy), MapRenderClient (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if Character then
        Character = MapRenderClient.WorldToUV(Character.Position);
    end;

    return Character;
end;

local function u264(p260: number) -- Line: 637
    -- upvalues: LocalPlayer (copy), MapRenderClient (copy), u225 (copy), u216 (ref), GuiUtil (copy), u219 (copy), u221 (ref), u257 (copy)
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("HumanoidRootPart");
    end;

    if Character then
        Character = MapRenderClient.WorldToUV(Character.Position);
    end;

    if not Character then
        return;
    end;

    local v261;

    if u225.Last == nil then
        v261 = false;
    else
        v261 = ((Character - u225.Last) * u216.Content.AbsoluteSize).Magnitude > 0.05;
    end;

    u225.Last = Character;

    if v261 then
        u225.Chasing = true;
    end;

    local ZoomInfo = GuiUtil:GetZoomInfo(u216.Map);

    if not u225.Chasing or (u219.Stroking or (u221 or ZoomInfo and (ZoomInfo.Held or ZoomInfo.Delta.Magnitude >= 0.01))) then
        return;
    end;

    local AbsoluteSize = u216.Map.AbsoluteSize;
    local v262;

    if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
        v262 = nil;
    else
        v262 = (u216.Map.AbsolutePosition + AbsoluteSize / 2 - (u216.Content.AbsolutePosition + Character * u216.Content.AbsoluteSize)) / AbsoluteSize;
    end;

    if not v262 then
        return;
    end;

    local Magnitude = (v262 * u216.Map.AbsoluteSize).Magnitude;

    if Magnitude < 0.5 then
        u257(v262);

        if not v261 then
            u225.Chasing = false;
        end;
    else
        local v263 = v262 * (1 - math.exp(p260 * -10));

        if (v263 * u216.Map.AbsoluteSize).Magnitude < 1 then
            v263 = v262 * math.min(1, 1 / Magnitude);
        end;

        if not u257(v263) then
            u225.Chasing = false;
        end;
    end;
end;

local function _(p265: number) -- Line: 675
    return string.rep(string.char(p265 % 26 + 65), p265 // 26 + 1);
end;

local function u267() -- Line: 679
    -- upvalues: u216 (ref)
    local GridCell = u216.GridCell;
    local v266;

    if GridCell == nil then
        v266 = false;
    else
        v266 = GridCell * u216.Content.AbsoluteSize.X >= 26;
    end;

    u216.GridNames.Visible = v266;
end;

local function u283() -- Line: 685
    -- upvalues: u216 (ref), MapRenderClient (copy), math_floor (copy)
    for _, v in { u216.GridLines, u216.GridNames } do
        for _, child in v:GetChildren() do
            if child ~= u216.LineTemplate and child ~= u216.NameTemplate then
                child:Destroy();
            end;
        end;
    end;

    u216.GridCell = nil;
    local Header = MapRenderClient.Header;
    local Info = MapRenderClient.Info;

    if Info then
        Info = Info.Grid;
    end;

    if not (Header and (type(Info) == "table" and (Info.Cell and (Info.Cols and Info.Rows)))) then
        local GridCell = u216.GridCell;
        local v268;

        if GridCell == nil then
            v268 = false;
        else
            v268 = GridCell * u216.Content.AbsoluteSize.X >= 26;
        end;

        u216.GridNames.Visible = v268;

        return;
    end;

    local v269 = Header.Width * Header.PixelSize;
    local v270 = Header.Height * Header.PixelSize;
    local v271 = Info.Cell / v269;
    local v272 = Info.Cell / v270;
    local v273 = (Info.CenterX - Info.Cols * Info.Cell / 2 - Header.OriginX) / v269;
    local v274 = (Info.CenterZ - Info.Rows * Info.Cell / 2 - Header.OriginZ) / v270;
    u216.GridCell = v271;

    local function _(p275: boolean, p276: number) -- Line: 708
        -- upvalues: u216 (ref)
        local v277 = u216.LineTemplate:Clone();
        v277.Name = "Line";

        if p275 then
            v277.AnchorPoint = Vector2.new(0.5, 0);
            v277.Position = UDim2.fromScale(p276, -5);
            v277.Size = UDim2.new(0, 1, 11, 0);
        else
            v277.AnchorPoint = Vector2.new(0, 0.5);
            v277.Position = UDim2.fromScale(-5, p276);
            v277.Size = UDim2.new(11, 0, 0, 1);
        end;

        v277.Visible = true;
        v277.Parent = u216.GridLines;
    end;

    for i = math.ceil((-5 - v273) / v271), math_floor((6 - v273) / v271) do
        local v278 = u216.LineTemplate:Clone();
        v278.Name = "Line";
        v278.AnchorPoint = Vector2.new(0.5, 0);
        v278.Position = UDim2.fromScale(v273 + i * v271, -5);
        v278.Size = UDim2.new(0, 1, 11, 0);
        v278.Visible = true;
        v278.Parent = u216.GridLines;
        local _ = i;
    end;

    for i = math.ceil((-5 - v274) / v272), math_floor((6 - v274) / v272) do
        local v279 = u216.LineTemplate:Clone();
        v279.Name = "Line";
        v279.AnchorPoint = Vector2.new(0, 0.5);
        v279.Position = UDim2.fromScale(-5, v274 + i * v272);
        v279.Size = UDim2.new(11, 0, 0, 1);
        v279.Visible = true;
        v279.Parent = u216.GridLines;
        local _ = i;
    end;

    for i = 0, Info.Cols - 1 do
        local string_rep_ret = string.rep(string.char(i % 26 + 65), i // 26 + 1);
        local v280 = i;

        for i2 = 0, Info.Rows - 1 do
            local v281 = u216.NameTemplate:Clone();
            v281.Name = string_rep_ret .. i2;
            v281.Text = string_rep_ret .. i2;
            v281.Position = UDim2.fromScale(v273 + (v280 + 0.06) * v271, v274 + (i2 + 0.05) * v272);
            v281.Size = UDim2.fromScale(v271 * 0.88, v272 * 0.14);
            v281.Visible = true;
            v281.Parent = u216.GridNames;
            local _ = i2;
        end;
    end;

    local GridCell = u216.GridCell;
    local v282;

    if GridCell == nil then
        v282 = false;
    else
        v282 = GridCell * u216.Content.AbsoluteSize.X >= 26;
    end;

    u216.GridNames.Visible = v282;
end;

local function _() -- Line: 746
    -- upvalues: u216 (ref)
    for i, v in u216.BagPins do
        v:Destroy();
        u216.BagPins[i] = nil;
    end;
end;

local function u287() -- Line: 758
    -- upvalues: u216 (ref), GuiService (copy), math_max (copy), MapUIStyle (copy), math_min (copy)
    local Y = u216.Map.AbsoluteSize.Y;
    local v284 = 8 + (not u216.Gui.IgnoreGuiInset and 0 or GuiService:GetGuiInset().Y);
    local CloseMap = u216.CloseMap;

    if CloseMap.Visible then
        v284 = math_max(v284, CloseMap.AbsolutePosition.Y + CloseMap.AbsoluteSize.Y - u216.Map.AbsolutePosition.Y + 8);
    end;

    local Scale = MapUIStyle.Scale;

    if Y > 0 then
        Scale = math_min(Scale, (math_max(0.15, (Y - v284 - 8) / 792)));
    end;

    u216.ControlsScale.Scale = Scale;
    u216.ListScale.Scale = Scale;
    local v285 = math_max(1, (math.floor(28 * Scale + 0.5)));

    for _, v in u216.Swatches do
        v.Size = UDim2.fromOffset(v285 / Scale, v285 / Scale);
    end;

    local v286 = math_max(v284, (Y - 792 * Scale) / 2) - Y / 2;
    u216.Controls.Position = UDim2.new(1, -16, 0.5, v286);
    u216.MarkerList.Position = UDim2.new(0, 24, 0.5, v286 + 8 * Scale);
end;

local function u292(u288: userdata, u289: string) -- Line: 782
    -- upvalues: u216 (ref), MapGamepad (copy)
    local function v290() -- Line: 783
        -- upvalues: u216 (ref), u289 (copy), u288 (copy)
        local Tooltip = u216.Tooltip;
        local Tools = u216.Tools;
        Tooltip.Text = u289;
        Tooltip.Position = UDim2.fromOffset(u216.Controls.AbsolutePosition.X - Tools.AbsolutePosition.X - 8, (u288.AbsolutePosition - Tools.AbsolutePosition).Y + u288.AbsoluteSize.Y / 2);
        Tooltip.Visible = true;
    end;

    local function v291() -- Line: 791
        -- upvalues: u216 (ref)
        u216.Tooltip.Visible = false;
    end;

    u288.MouseEnter:Connect(v290);
    u288.MouseLeave:Connect(v291);
    MapGamepad.Register(u288, {
        Enter = v290,
        Leave = v291
    });
end;

local function _(p293: userdata, p294: boolean, p295) -- Line: 799
    -- upvalues: Color3_fromRGB_ret (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy)
    if p294 then
        local v296 = p295 or Color3_fromRGB_ret;
        local Color3_new_ret = Color3.new(v296.R * 0.65, v296.G * 0.65, v296.B * 0.65);
        p293.BackgroundColor3 = v296;
        p293.BackgroundTransparency = 0;
        p293.Ring.Color = Color3_new_ret;
        local Icon = p293:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_new_ret;
        end;
    else
        p293.BackgroundColor3 = Color3_fromRGB_ret3;
        p293.BackgroundTransparency = 0.1;
        p293.Ring.Color = Color3_fromRGB_ret4;
        local Icon = p293:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_fromRGB_ret4;
        end;
    end;
end;

local function u301(p297: string) -- Line: 807
    -- upvalues: u216 (ref), u217 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy), LocalPlayer (copy), MapRenderClient (copy), u257 (copy)
    local v298 = u216.Toggles[p297];

    if u217[p297] then
        local v299 = Color3_fromRGB_ret;
        local Color3_new_ret = Color3.new(v299.R * 0.65, v299.G * 0.65, v299.B * 0.65);
        v298.BackgroundColor3 = v299;
        v298.BackgroundTransparency = 0;
        v298.Ring.Color = Color3_new_ret;
        local Icon = v298:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_new_ret;
        end;
    else
        v298.BackgroundColor3 = Color3_fromRGB_ret3;
        v298.BackgroundTransparency = 0.1;
        v298.Ring.Color = Color3_fromRGB_ret4;
        local Icon = v298:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_fromRGB_ret4;
        end;
    end;

    if p297 == "Grid" then
        u216.Grid.Visible = u217.Grid;

        return;
    end;

    if p297 == "SleepingBags" then
        for i, v in u216.BagPins do
            v:Destroy();
            u216.BagPins[i] = nil;
        end;

        return;
    end;

    if p297 == "VendingMachines" then
        for _, child in u216.Content:GetChildren() do
            if child.Name == "ShopMarker" and child:IsA("GuiObject") then
                child.Visible = u217.VendingMachines;
            end;
        end;

        return;
    end;

    if p297 == "MonumentNames" then
        local MonumentLabels = u216.Content:FindFirstChild("MonumentLabels");

        if MonumentLabels then
            MonumentLabels.Visible = u217.MonumentNames;
        end;
    elseif p297 == "Follow" and (u217.Follow and u216.Map.Visible) then
        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if Character then
            Character = MapRenderClient.WorldToUV(Character.Position);
        end;

        if Character then
            local AbsoluteSize = u216.Map.AbsoluteSize;
            local v300;

            if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
                v300 = nil;
            else
                v300 = (u216.Map.AbsolutePosition + AbsoluteSize / 2 - (u216.Content.AbsolutePosition + Character * u216.Content.AbsoluteSize)) / AbsoluteSize;
            end;

            if v300 then
                u257(v300);
            end;
        end;
    end;
end;

local function u305(p302: boolean) -- Line: 833
    -- upvalues: u216 (ref), MapUIStyle (copy), math_max (copy), TweenService (copy)
    local PenPill = u216.PenPill;
    local v303 = MapUIStyle.EffectiveScale(PenPill);
    local v304 = p302 and u216.PenList.AbsoluteContentSize.Y / math_max(v303, 0.01) + 8 + 8 or 62;

    if u216.PenTween then
        u216.PenTween:Cancel();
    end;

    u216.PenTween = TweenService:Create(PenPill, TweenInfo.new(p302 and 0.32 or 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(62, v304)
    });
    u216.PenTween:Play();
end;

local function u310() -- Line: 845
    -- upvalues: u216 (ref), u219 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy)
    for i, v in u216.Swatches do
        local v306 = not u219.Erasing and i == u219.Colour;
        local v307 = v:FindFirstChildOfClass("UIStroke");
        v307.Color = v306 and Color3.new(1, 1, 1) or Color3.fromRGB(25, 25, 25);
        v307.Thickness = v306 and 3 or 2;
        v307.Transparency = v306 and 0 or 0.3;
    end;

    local Pen = u216.PenButtons.Pen;

    if u219.On then
        local v308 = Color3_fromRGB_ret;
        local Color3_new_ret = Color3.new(v308.R * 0.65, v308.G * 0.65, v308.B * 0.65);
        Pen.BackgroundColor3 = v308;
        Pen.BackgroundTransparency = 0;
        Pen.Ring.Color = Color3_new_ret;
        local Icon = Pen:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_new_ret;
        end;
    else
        Pen.BackgroundColor3 = Color3_fromRGB_ret3;
        Pen.BackgroundTransparency = 0.1;
        Pen.Ring.Color = Color3_fromRGB_ret4;
        local Icon = Pen:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_fromRGB_ret4;
        end;
    end;

    local Eraser = u216.PenButtons.Eraser;

    if u219.Erasing then
        local v309 = Color3_fromRGB_ret;
        local Color3_new_ret = Color3.new(v309.R * 0.65, v309.G * 0.65, v309.B * 0.65);
        Eraser.BackgroundColor3 = v309;
        Eraser.BackgroundTransparency = 0;
        Eraser.Ring.Color = Color3_new_ret;
        local Icon = Eraser:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_new_ret;
        end;
    else
        Eraser.BackgroundColor3 = Color3_fromRGB_ret3;
        Eraser.BackgroundTransparency = 0.1;
        Eraser.Ring.Color = Color3_fromRGB_ret4;
        local Icon = Eraser:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_fromRGB_ret4;
        end;
    end;
end;

local function _() -- Line: 857
    -- upvalues: u219 (copy), u218 (copy), u228 (ref)
    if u219.Stroking then
        u219.Stroking = false;
        u219.Input = nil;
        u219.Pad = false;

        if u218:End() then
            u228 = os.clock() + 2;
        end;
    end;
end;

local function _(u311: userdata, p312) -- Line: 869
    -- upvalues: u219 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy)
    local v313 = u219;
    v313.Flashes = v313.Flashes + 1;
    local Flashes = u219.Flashes;
    local v314 = p312 or Color3_fromRGB_ret;
    local Color3_new_ret = Color3.new(v314.R * 0.65, v314.G * 0.65, v314.B * 0.65);
    u311.BackgroundColor3 = v314;
    u311.BackgroundTransparency = 0;
    u311.Ring.Color = Color3_new_ret;
    local Icon = u311:FindFirstChild("Icon");

    if Icon then
        Icon.ImageColor3 = Color3_new_ret;
    end;

    task.delay(0.18, function() -- Line: 873
        -- upvalues: u219 (ref), Flashes (copy), u311 (copy), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret4 (ref)
        if u219.Flashes == Flashes and u311.Parent then
            local v315 = u311;
            v315.BackgroundColor3 = Color3_fromRGB_ret3;
            v315.BackgroundTransparency = 0.1;
            v315.Ring.Color = Color3_fromRGB_ret4;
            local Icon2 = v315:FindFirstChild("Icon");

            if Icon2 then
                Icon2.ImageColor3 = Color3_fromRGB_ret4;
            end;
        end;
    end);
end;

local function _(p316: number) -- Line: 881
    -- upvalues: u166 (copy)
    return u166[p316] or "Marker";
end;

local function u318() -- Line: 885
    -- upvalues: u220 (copy)
    local v317 = {};

    for _, v in u220 do
        v317[#v317 + 1] = {
            N = v.Name,
            I = v.Icon,
            C = v.Colour,
            U = v.U,
            V = v.V
        };
    end;

    return v317;
end;

local function u320() -- Line: 894
    -- upvalues: MapRenderClient (copy), u220 (copy), PlayerGui (copy)
    local Header = MapRenderClient.Header;

    if not Header then
        return;
    end;

    local v319 = u220[#u220];
    PlayerGui:SetAttribute("PlayerMapPin", v319 and Vector2.new(Header.OriginX + v319.U * Header.Width * Header.PixelSize, Header.OriginZ + v319.V * Header.Height * Header.PixelSize) or nil);
end;

local function _() -- Line: 905
    -- upvalues: u228 (ref), u320 (copy)
    u228 = os.clock() + 2;
    u320();
end;

local function _() -- Line: 910
    -- upvalues: u216 (ref), u143 (copy), u222 (copy)
    local v321 = string.gsub(u216.NameBox.Text, "^%s+", ""):gsub("%s+$", "");

    if v321 == "" or not v321 then
        v321 = u143[u222.Icon];
    end;

    return v321;
end;

local function u342(p322) -- Line: 915
    -- upvalues: u216 (ref), u1 (copy), u165 (copy), u188 (copy), u166 (copy), u135 (copy)
    local v323 = u216 and u216.Views[p322];

    if not v323 then
        return;
    end;

    local v324 = u1[p322.Colour] or u1[1];
    local Pin = v323.Pin;
    local v325 = p322.Icon == 1;
    local v326;

    if v325 then
        v326 = Vector2.new(0.5, 0.95);
    else
        v326 = Vector2.new(0.5, 0.5);
    end;

    Pin.AnchorPoint = v326;

    if v325 then
        local Colour = p322.Colour;
        local v327 = "Tear" .. Colour;

        local function v330() -- Line: 436
            -- upvalues: u1 (ref), Colour (copy), u165 (ref)
            local v328 = u1[Colour] or u1[1];
            local Color3_new_ret = Color3.new(v328.R * 0.65, v328.G * 0.65, v328.B * 0.65);
            local v329 = { "tri", 0.241, 0.512, 0.759, 0.512, 0.5, 0.95 };

            return u165(38, {
                {
                    Colour = Color3_new_ret,
                    Shapes = {
                        { "circle", 0.5, 0.36, 0.33999999999999997 },
                        {
                            "tri",
                            v329[2],
                            v329[3],
                            v329[4],
                            v329[5],
                            v329[6],
                            v329[7],
                            grow = 0.04
                        }
                    }
                },
                {
                    Colour = v328,
                    Shapes = {
                        { "circle", 0.5, 0.36, 0.3 },
                        v329
                    }
                },
                {
                    Colour = Color3_new_ret,
                    Shapes = { { "circle", 0.5, 0.36, 0.12 } }
                }
            });
        end;

        if u188[v327] == nil then
            u188[v327] = v330() or false;
        end;

        local v331 = u188[v327] or nil;

        if v331 then
            Pin.ImageContent = v331;
        end;
    else
        local Icon = Pin.Badge.Icon;
        local u332 = u166[p322.Icon] or "Marker";
        local v333 = u332 .. 18;
        local u334 = 18;

        local function v335() -- Line: 418
            -- upvalues: u165 (ref), u334 (copy), u135 (ref), u332 (copy)
            return u165(u334, {
                {
                    Colour = Color3.new(1, 1, 1),
                    Shapes = u135[u332]
                }
            });
        end;

        if u188[v333] == nil then
            u188[v333] = v335() or false;
        end;

        local v336 = u188[v333] or nil;

        if v336 then
            Icon.ImageContent = v336;
        end;

        local Badge = Pin.Badge;
        local Color3_new_ret = Color3.new(v324.R * 0.65, v324.G * 0.65, v324.B * 0.65);
        Badge.BackgroundColor3 = v324;
        Badge.BackgroundTransparency = 0;
        Badge.Ring.Color = Color3_new_ret;
        local Icon2 = Badge:FindFirstChild("Icon");

        if Icon2 then
            Icon2.ImageColor3 = Color3_new_ret;
        end;
    end;

    Pin.ImageTransparency = v325 and 0 or 1;
    Pin.Badge.Visible = not v325;
    Pin.Tag.Position = UDim2.new(0.5, 0, 1, v325 and 2 or -2);
    Pin.Position = UDim2.fromScale(p322.U, p322.V);
    Pin.Tag.Text = p322.Name;
    local Icon = v323.Button.Icon;
    local u337 = u166[p322.Icon] or "Marker";
    local v338 = u337 .. 26;
    local u339 = 26;

    local function v340() -- Line: 418
        -- upvalues: u165 (ref), u339 (copy), u135 (ref), u337 (copy)
        return u165(u339, {
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = u135[u337]
            }
        });
    end;

    if u188[v338] == nil then
        u188[v338] = v340() or false;
    end;

    local v341 = u188[v338] or nil;

    if v341 then
        Icon.ImageContent = v341;
    end;

    local Button = v323.Button;
    local Color3_new_ret = Color3.new(v324.R * 0.65, v324.G * 0.65, v324.B * 0.65);
    Button.BackgroundColor3 = v324;
    Button.BackgroundTransparency = 0;
    Button.Ring.Color = Color3_new_ret;
    local Icon2 = Button:FindFirstChild("Icon");

    if Icon2 then
        Icon2.ImageColor3 = Color3_new_ret;
    end;

    v323.Tab.Label.Text = p322.Name;
end;

local function u347() -- Line: 943
    -- upvalues: u1 (copy), u222 (copy), u216 (ref), u167 (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy)
    local v343 = u1[u222.Colour];

    for i, v in u216.IconChoices do
        if u167[i] == u222.Icon then
            local Color3_new_ret = Color3.new(v343.R * 0.65, v343.G * 0.65, v343.B * 0.65);
            v.BackgroundColor3 = v343;
            v.BackgroundTransparency = 0;
            v.Ring.Color = Color3_new_ret;
            local Icon = v:FindFirstChild("Icon");

            if Icon then
                Icon.ImageColor3 = Color3_new_ret;
            end;
        else
            v.BackgroundColor3 = Color3_fromRGB_ret3;
            v.BackgroundTransparency = 0.1;
            v.Ring.Color = Color3_fromRGB_ret4;
            local Icon = v:FindFirstChild("Icon");

            if Icon then
                Icon.ImageColor3 = Color3_fromRGB_ret4;
            end;
        end;
    end;

    for i, v in u216.ColourChoices do
        local v344 = i == u222.Colour;
        local Ring = v.Ring;
        local v345 = v344 and Color3.new(1, 1, 1);

        if not v345 then
            local v346 = u1[i];
            v345 = Color3.new(v346.R * 0.65, v346.G * 0.65, v346.B * 0.65);
        end;

        Ring.Color = v345;
        v.Ring.Thickness = v344 and 3 or 2;
    end;
end;

local function _() -- Line: 960
    -- upvalues: u221 (ref), u222 (copy), u216 (ref), u143 (copy), u342 (copy), u228 (ref), u320 (copy)
    local v348 = u221;

    if not v348 then
        return;
    end;

    local Colour = u222.Colour;
    v348.Icon = u222.Icon;
    v348.Colour = Colour;
    local v349 = string.gsub(u216.NameBox.Text, "^%s+", ""):gsub("%s+$", "");

    if v349 == "" or not v349 then
        v349 = u143[u222.Icon];
    end;

    v348.Name = v349;
    u342(v348);
    u228 = os.clock() + 2;
    u320();
end;

local function _() -- Line: 971
    -- upvalues: u221 (ref), u216 (ref)
    u221 = nil;

    if u216 then
        u216.Editor.Visible = false;
        u216.NameBox:ReleaseFocus();
    end;
end;

local function u356(p350) -- Line: 980
    -- upvalues: u216 (ref), MapUIStyle (copy), math_max (copy), math_clamp (copy)
    if not u216.Views[p350] then
        return;
    end;

    local Tools = u216.Tools;
    local Editor = u216.Editor;
    local AbsoluteSize = Tools.AbsoluteSize;
    local v351 = Vector2.new(p350.U, p350.V) * u216.Content.AbsoluteSize + u216.Content.AbsolutePosition - Tools.AbsolutePosition;
    local v352 = MapUIStyle.EffectiveScale(Editor);
    local X = Editor.AbsoluteSize.X;
    local v353 = math_max(Editor.AbsoluteSize.Y, 240 * v352);
    local v354 = v351.X + 30 * v352;

    if v354 + X > AbsoluteSize.X - 94 * v352 then
        v354 = v351.X - 30 * v352 - X;
    end;

    local v355 = math_clamp(v351.Y - v353 / 2, 16, (math_max(16, AbsoluteSize.Y - v353 - 16)));
    Editor.Position = UDim2.fromOffset(math_max(16 + 78 * v352, v354), v355);
end;

local function _(p357) -- Line: 998
    -- upvalues: u221 (ref), u222 (copy), u216 (ref), u347 (copy), u356 (copy)
    u221 = nil;
    local Colour = p357.Colour;
    u222.Icon = p357.Icon;
    u222.Colour = Colour;
    u216.NameBox.Text = p357.Name;
    u221 = p357;
    u347();
    u216.Editor.Visible = true;
    u356(p357);
end;

local function u360(p358: any, p359: boolean) -- Line: 1008
    -- upvalues: TweenService (copy)
    p358.Open = p359;
    TweenService:Create(p358.Tab, TweenInfo.new(p359 and 0.28 or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset((p359 and 252 or 46) + 16, 62)
    }):Play();
end;

local u361 = nil;

local function u373(u362) -- Line: 1016
    -- upvalues: u216 (ref), MapUIStyle (copy), MapGamepad (copy), u221 (ref), u222 (copy), u347 (copy), u356 (copy), u361 (ref), u360 (copy), u257 (copy), u225 (copy), u165 (copy), u135 (copy), u188 (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy), u342 (copy)
    local v363 = u216.PinTemplate:Clone();
    v363.Name = "Marker";
    v363.Visible = true;
    MapUIStyle.Scaled(v363);
    v363.Parent = u216.PinLayer;
    local v364 = u216.RowTemplate:Clone();
    v364.Name = "Marker";
    v364.Visible = true;
    v364.Parent = u216.MarkerList;
    local u365 = {
        Open = false,
        Pin = v363,
        Row = v364,
        Button = v364.Button,
        Tab = v364.Tab
    };
    u216.Views[u362] = u365;
    MapGamepad.OnPress(v363, function() -- Line: 1028
        -- upvalues: u216 (ref), u362 (copy), u221 (ref), u222 (ref), u347 (ref), u356 (ref)
        if u216.Map:GetAttribute("Locked") ~= true then
            local v366 = u362;
            u221 = nil;
            local Colour = v366.Colour;
            u222.Icon = v366.Icon;
            u222.Colour = Colour;
            u216.NameBox.Text = v366.Name;
            u221 = v366;
            u347();
            u216.Editor.Visible = true;
            u356(v366);
        end;
    end, "Edit Marker");
    MapGamepad.Register(v363, {
        SecondHint = "Remove Marker",

        Second = function() -- Line: 1033, Name: Second
            -- upvalues: u361 (ref), u362 (copy)
            u361(u362);
        end
    });
    MapGamepad.OnPress(u365.Button, function() -- Line: 1036
        -- upvalues: u216 (ref), u365 (copy), u360 (ref)
        for _, v in u216.Views do
            if v ~= u365 and v.Open then
                u360(v, false);
            end;
        end;

        u360(u365, not u365.Open);
    end);
    MapGamepad.OnPress(u365.Tab.Label, function() -- Line: 1044
        -- upvalues: u362 (copy), u216 (ref), u257 (ref), u225 (ref)
        local Vector2_new_ret = Vector2.new(u362.U, u362.V);
        local AbsoluteSize = u216.Map.AbsoluteSize;
        local v367;

        if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            v367 = nil;
        else
            v367 = (u216.Map.AbsolutePosition + AbsoluteSize / 2 - (u216.Content.AbsolutePosition + Vector2_new_ret * u216.Content.AbsoluteSize)) / AbsoluteSize;
        end;

        if v367 then
            u257(v367);
        end;

        u225.Chasing = false;
    end);
    local Remove = u365.Tab:FindFirstChild("Remove");
    local Icon = Remove.Icon;
    local v368 = "Close" .. 16;
    local u369 = 16;
    local u370 = "Close";

    local function v371() -- Line: 418
        -- upvalues: u165 (ref), u369 (copy), u135 (ref), u370 (copy)
        return u165(u369, {
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = u135[u370]
            }
        });
    end;

    if u188[v368] == nil then
        u188[v368] = v371() or false;
    end;

    local v372 = u188[v368] or nil;

    if v372 then
        Icon.ImageContent = v372;
    end;

    Remove.BackgroundColor3 = Color3_fromRGB_ret3;
    Remove.BackgroundTransparency = 0.1;
    Remove.Ring.Color = Color3_fromRGB_ret4;
    local Icon2 = Remove:FindFirstChild("Icon");

    if Icon2 then
        Icon2.ImageColor3 = Color3_fromRGB_ret4;
    end;

    MapGamepad.OnPress(Remove, function() -- Line: 1051
        -- upvalues: u361 (ref), u362 (copy)
        u361(u362);
    end);
    u342(u362);
end;

local function _() -- Line: 1057
    -- upvalues: u220 (copy), u216 (ref)
    for i, v in u220 do
        local v374 = u216.Views[v];

        if v374 then
            v374.Row.LayoutOrder = i;
        end;
    end;

    u216.MarkerList.Visible = #u220 > 0;
end;

u361 = function(p375) -- Line: 1067
    -- upvalues: u220 (copy), u221 (ref), u216 (ref), u228 (ref), u320 (copy)
    local table_find_ret = table.find(u220, p375);

    if not table_find_ret then
        return;
    end;

    table.remove(u220, table_find_ret);

    if u221 == p375 then
        u221 = nil;

        if u216 then
            u216.Editor.Visible = false;
            u216.NameBox:ReleaseFocus();
        end;
    end;

    if u216 then
        local v376 = u216.Views[p375];

        if v376 then
            v376.Pin:Destroy();
            v376.Row:Destroy();
            u216.Views[p375] = nil;
        end;

        for i, v in u220 do
            local v377 = u216.Views[v];

            if v377 then
                v377.Row.LayoutOrder = i;
            end;
        end;

        u216.MarkerList.Visible = #u220 > 0;
    end;

    u228 = os.clock() + 2;
    u320();
end;

local function u385(p378: number, p379: number, p380: string, p381: number, p382: number) -- Line: 1089
    -- upvalues: u220 (copy), u166 (copy), u1 (copy), u216 (ref), u373 (copy)
    if #u220 >= 6 then
        return nil;
    end;

    local v383 = {
        Name = p380,
        Icon = u166[p381] and p381 and p381 or 1,
        Colour = u1[p382] and p382 and p382 or 1,
        U = p378,
        V = p379
    };
    u220[#u220 + 1] = v383;

    if u216 then
        u373(v383);

        for i, v in u220 do
            local v384 = u216.Views[v];

            if v384 then
                v384.Row.LayoutOrder = i;
            end;
        end;

        u216.MarkerList.Visible = #u220 > 0;
    end;

    return v383;
end;

local function u388() -- Line: 1103
    -- upvalues: u1 (copy), u220 (copy)
    for i = 1, #u1 do
        local v386 = i;
        local v387 = false;

        for _, v in u220 do
            if v.Colour == v386 then
                v387 = true;
                break;
            end;
        end;

        if not v387 then
            return v386;
        end;
    end;

    return 1;
end;

local function u393(p389) -- Line: 1119
    -- upvalues: u216 (ref), u252 (copy), u385 (copy), u220 (copy), u388 (copy), u221 (ref), u222 (copy), u347 (copy), u356 (copy), u228 (ref), u320 (copy)
    if u216.Map:GetAttribute("Locked") == true or u252(p389) then
        return;
    end;

    local v390 = (p389 - u216.Content.AbsolutePosition) / u216.Content.AbsoluteSize;
    local v391;

    if v390.X >= 0 and (v390.X <= 1 and v390.Y >= 0) then
        v391 = v390.Y <= 1;
    else
        v391 = false;
    end;

    if not v391 then
        return;
    end;

    local v392 = u385(v390.X, v390.Y, "Marker " .. #u220 + 1, 1, (u388()));

    if v392 then
        u221 = nil;
        local Colour = v392.Colour;
        u222.Icon = v392.Icon;
        u222.Colour = Colour;
        u216.NameBox.Text = v392.Name;
        u221 = v392;
        u347();
        u216.Editor.Visible = true;
        u356(v392);
        u228 = os.clock() + 2;
        u320();
    end;
end;

local function _() -- Line: 1135
    -- upvalues: LocalPlayer (copy)
    local PreferredInputController = LocalPlayer.PlayerScripts:FindFirstChild("PreferredInputController");

    if PreferredInputController then
        PreferredInputController = PreferredInputController:GetAttribute("PreferredInput");
    end;

    return PreferredInputController;
end;

local function u401() -- Line: 1141
    -- upvalues: u219 (copy), u216 (ref), u226 (copy), LocalPlayer (copy), UserInputService (copy), GuiService (copy), u252 (copy), MapDrawing (copy)
    local v394 = u219.Erasing and u216.EraserCursor or u216.PenCursor;
    local v395 = false;
    local Pad = u226.Pad;

    if u219.On and u216.Map.Visible and u216.Map:GetAttribute("Locked") ~= true then
        local v396, v397, v398, v399;

        if Pad then
            if not Pad then
                v396 = UserInputService:GetMouseLocation();

                if u216.Gui.IgnoreGuiInset then
                    v397 = Vector2.zero;
                else
                    v397 = GuiService:GetGuiInset();
                end;

                Pad = v396 - v397 + u216.Map.AbsolutePosition;
            end;

            v398 = (Pad - u216.Content.AbsolutePosition) / u216.Content.AbsoluteSize;

            if v398.X >= 0 and (v398.X <= 1 and v398.Y >= 0) then
                v395 = v398.Y <= 1;
            else
                v395 = false;
            end;

            if v395 then
                v395 = not u252(Pad);
            end;

            if v395 then
                v399 = Pad - u216.Tools.AbsolutePosition;
                v394.Position = UDim2.fromOffset(v399.X, v399.Y);

                if not u219.Erasing then
                    u216.Bristles.ImageColor3 = MapDrawing.Palette[u219.Colour];
                end;
            end;
        else
            local PreferredInputController = LocalPlayer.PlayerScripts:FindFirstChild("PreferredInputController");

            if PreferredInputController then
                PreferredInputController = PreferredInputController:GetAttribute("PreferredInput");
            end;

            if PreferredInputController == "KeyboardAndMouse" then
                if not Pad then
                    v396 = UserInputService:GetMouseLocation();

                    if u216.Gui.IgnoreGuiInset then
                        v397 = Vector2.zero;
                    else
                        v397 = GuiService:GetGuiInset();
                    end;

                    Pad = v396 - v397 + u216.Map.AbsolutePosition;
                end;

                v398 = (Pad - u216.Content.AbsolutePosition) / u216.Content.AbsoluteSize;

                if v398.X >= 0 and (v398.X <= 1 and v398.Y >= 0) then
                    v395 = v398.Y <= 1;
                else
                    v395 = false;
                end;

                if v395 then
                    v395 = not u252(Pad);
                end;

                if v395 then
                    v399 = Pad - u216.Tools.AbsolutePosition;
                    v394.Position = UDim2.fromOffset(v399.X, v399.Y);

                    if not u219.Erasing then
                        u216.Bristles.ImageColor3 = MapDrawing.Palette[u219.Colour];
                    end;
                end;
            end;
        end;
    end;

    local v400 = v395 and v394 and v394 or nil;

    if v400 ~= u226.Shown then
        if u226.Shown then
            u226.Shown.Visible = false;
        end;

        if v400 then
            v400.Visible = true;
        end;

        u226.Shown = v400;
    end;

    if v395 ~= u226.Hidden then
        u226.Hidden = v395;
        UserInputService.MouseIconEnabled = not v395 and UserInputService.MouseBehavior == Enum.MouseBehavior.Default;
    end;
end;

local function _() -- Line: 1173
    -- upvalues: u226 (copy), UserInputService (copy)
    if u226.Shown then
        u226.Shown.Visible = false;
        u226.Shown = nil;
    end;

    if u226.Hidden then
        u226.Hidden = false;
        UserInputService.MouseIconEnabled = UserInputService.MouseBehavior == Enum.MouseBehavior.Default;
    end;
end;

local function u407(p402: number, p403: number) -- Line: 1186
    -- upvalues: u216 (ref), u227 (copy)
    local Voices = u216.Voices;

    if #Voices == 0 then
        return;
    end;

    local v404 = u227.Rng:NextInteger(1, #Voices);
    local v405 = (u227.Turn[v404] or 0) % #Voices[v404] + 1;
    u227.Turn[v404] = v405;
    local v406 = Voices[v404][v405];
    v406.Volume = 0.11 * p402;
    v406.PlaybackSpeed = p403 * u227.Rng:NextNumber(0.96, 1.04);
    v406.TimePosition = 0;
    v406:Play();
end;

local function u414(p408: number) -- Line: 1201
    -- upvalues: u219 (copy), u227 (copy), u226 (copy), UserInputService (copy), u407 (copy), math_clamp (copy), math_min (copy)
    if not u219.Stroking then
        u227.Last = nil;
        u227.Travel = 0;
        u227.Was = false;

        return;
    end;

    local Input = u219.Input;
    local v409;

    if u219.Pad and u226.Pad then
        v409 = u226.Pad;
    elseif Input and Input.UserInputType == Enum.UserInputType.Touch then
        v409 = Vector2.new(Input.Position.X, Input.Position.Y);
    else
        v409 = UserInputService:GetMouseLocation();
    end;

    local v410 = u219.Erasing and 0.7 or 1;
    local v411 = u219.Erasing and 0.85 or 1;

    if not u227.Was then
        u227.Was = true;
        u227.Last = v409;
        u227.At = os.clock();
        u407(0.5 * v410, v411 * 1.05);

        return;
    end;

    local Magnitude = (v409 - u227.Last).Magnitude;
    u227.Last = v409;

    if Magnitude < 0.5 or p408 <= 0 then
        return;
    end;

    local v412 = math_clamp(Magnitude / p408 / 1100, 0, 1);
    local v413 = u227;
    v413.Travel = v413.Travel + Magnitude;
    local os_clock_ret = os.clock();

    if u227.Travel >= 18 and os_clock_ret - u227.At >= 0.035 then
        u227.Travel = 0;
        u227.At = os_clock_ret;
        u407((v412 * 0.55 + 0.45) * v410, v411 * (v412 * 0.2 + 0.95));
    end;

    u227.Travel = math_min(u227.Travel, 36);
end;

local function u417() -- Line: 1237
    -- upvalues: u225 (copy), u217 (copy), u216 (ref), GuiUtil (copy), math_clamp (copy), LocalPlayer (copy), MapRenderClient (copy), u257 (copy), u287 (copy)
    u225.Last = nil;
    u225.Chasing = false;

    if (u217.Follow or not u225.Seen) and u216.Map:GetAttribute("Locked") ~= true then
        local ZoomInfo = GuiUtil:GetZoomInfo(u216.Map);

        if ZoomInfo then
            local v415 = math_clamp(5, ZoomInfo.MinZoom or 5, ZoomInfo.MaxZoom or 5);
            ZoomInfo.Scale = v415;
            ZoomInfo.TargetScale = v415;
            ZoomInfo.ZoomAnchor = nil;
            u216.Frame.Size = UDim2.fromScale(v415, v415);
        end;

        local Character = LocalPlayer.Character;

        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart");
        end;

        if Character then
            Character = MapRenderClient.WorldToUV(Character.Position);
        end;

        if Character then
            local AbsoluteSize = u216.Map.AbsoluteSize;
            local v416;

            if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
                v416 = nil;
            else
                v416 = (u216.Map.AbsolutePosition + AbsoluteSize / 2 - (u216.Content.AbsolutePosition + Character * u216.Content.AbsoluteSize)) / AbsoluteSize;
            end;

            if v416 then
                u257(v416);
            end;

            u225.Seen = true;
        end;
    end;

    for i, v in u216.BagPins do
        v:Destroy();
        u216.BagPins[i] = nil;
    end;

    task.defer(u287);
end;

local function _() -- Line: 1259
    -- upvalues: u219 (copy), u218 (copy), u228 (ref), u310 (copy), u305 (copy), u221 (ref), u216 (ref), u224 (copy), u226 (copy), UserInputService (copy)
    if u219.Stroking then
        u219.Stroking = false;
        u219.Input = nil;
        u219.Pad = false;

        if u218:End() then
            u228 = os.clock() + 2;
        end;
    end;

    if u219.On or u219.Erasing then
        u219.On = false;
        u219.Erasing = false;
        u310();
        u305(false);
    end;

    u221 = nil;

    if u216 then
        u216.Editor.Visible = false;
        u216.NameBox:ReleaseFocus();
    end;

    u224.Right = nil;
    u224.Left = nil;
    u216.Tooltip.Visible = false;

    if u226.Shown then
        u226.Shown.Visible = false;
        u226.Shown = nil;
    end;

    if u226.Hidden then
        u226.Hidden = false;
        UserInputService.MouseIconEnabled = UserInputService.MouseBehavior == Enum.MouseBehavior.Default;
    end;
end;

local function u486() -- Line: 1274
    -- upvalues: u216 (ref), MapUIStyle (copy), u2 (copy), u168 (copy), u169 (copy), u165 (copy), u135 (copy), u188 (copy), u292 (copy), MapGamepad (copy), u217 (copy), u301 (copy), Color3_fromRGB_ret3 (copy), Color3_fromRGB_ret4 (copy), u219 (copy), u218 (copy), u228 (ref), u310 (copy), u305 (copy), Color3_fromRGB_ret (copy), Color3_fromRGB_ret2 (copy), Color3_fromRGB_ret6 (copy), u187 (copy), u174 (copy), u167 (copy), u166 (copy), u222 (copy), u347 (copy), u221 (ref), u143 (copy), u342 (copy), u320 (copy), u361 (ref), u220 (copy), u373 (copy), u283 (copy), u267 (copy), u287 (copy), ContentProvider (copy), u224 (copy), u226 (copy), UserInputService (copy), u417 (copy)
    local Tools = u216.Tools;

    for _, descendant in Tools:GetDescendants() do
        if descendant:IsA("UIScale") and (descendant.Name == "StyleScale" and (descendant.Parent ~= u216.Controls and descendant.Parent ~= u216.MarkerList)) then
            MapUIStyle.Scaled(descendant.Parent);
        end;
    end;

    MapUIStyle.Backdrop(u216.Editor, u2);
    MapUIStyle.Banner(u216.Editor.Header, u168);

    for _, v in u169 do
        local v418 = u216.Toggles[v.Key];
        local Icon = v418.Icon;
        local Key = v.Key;
        local v419 = Key .. 26;
        local u420 = 26;

        local function v421() -- Line: 418
            -- upvalues: u165 (ref), u420 (copy), u135 (ref), Key (copy)
            return u165(u420, {
                {
                    Colour = Color3.new(1, 1, 1),
                    Shapes = u135[Key]
                }
            });
        end;

        if u188[v419] == nil then
            u188[v419] = v421() or false;
        end;

        local v422 = u188[v419] or nil;

        if v422 then
            Icon.ImageContent = v422;
        end;

        u292(v418, v.Name);
        MapGamepad.OnPress(v418, function() -- Line: 1290
            -- upvalues: u217 (ref), v (copy), u301 (ref)
            u217[v.Key] = not u217[v.Key];
            u301(v.Key);
        end);
        u301(v.Key);
    end;

    local PenButtons = u216.PenButtons;

    for i, v in {
        Pen = "Draw",
        Eraser = "Eraser",
        Undo = "Undo",
        Redo = "Redo",
        Clear = "Clear Drawing"
    } do
        local Icon = PenButtons[i].Icon;
        local v423 = i .. 26;
        local u424 = 26;

        local function v425() -- Line: 418
            -- upvalues: u165 (ref), u424 (copy), u135 (ref), i (copy)
            return u165(u424, {
                {
                    Colour = Color3.new(1, 1, 1),
                    Shapes = u135[i]
                }
            });
        end;

        if u188[v423] == nil then
            u188[v423] = v425() or false;
        end;

        local v426 = u188[v423] or nil;

        if v426 then
            Icon.ImageContent = v426;
        end;

        u292(PenButtons[i], v);
        local v427 = PenButtons[i];
        v427.BackgroundColor3 = Color3_fromRGB_ret3;
        v427.BackgroundTransparency = 0.1;
        v427.Ring.Color = Color3_fromRGB_ret4;
        local Icon2 = v427:FindFirstChild("Icon");

        if Icon2 then
            Icon2.ImageColor3 = Color3_fromRGB_ret4;
        end;
    end;

    MapGamepad.OnPress(PenButtons.Pen, function() -- Line: 1304
        -- upvalues: u219 (ref), u218 (ref), u228 (ref), u310 (ref), u305 (ref)
        u219.On = not u219.On;

        if not u219.On and u219.Stroking then
            u219.Stroking = false;
            u219.Input = nil;
            u219.Pad = false;

            if u218:End() then
                u228 = os.clock() + 2;
            end;
        end;

        u310();
        u305(u219.On);
    end);
    MapGamepad.OnPress(PenButtons.Eraser, function() -- Line: 1312
        -- upvalues: u219 (ref), u310 (ref)
        u219.Erasing = not u219.Erasing;
        u310();
    end);
    MapGamepad.OnPress(PenButtons.Undo, function() -- Line: 1316
        -- upvalues: PenButtons (copy), u219 (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret4 (ref), u218 (ref), u228 (ref)
        local Undo = PenButtons.Undo;
        local v428 = u219;
        v428.Flashes = v428.Flashes + 1;
        local Flashes = u219.Flashes;
        local v429 = Color3_fromRGB_ret;
        local Color3_new_ret = Color3.new(v429.R * 0.65, v429.G * 0.65, v429.B * 0.65);
        Undo.BackgroundColor3 = v429;
        Undo.BackgroundTransparency = 0;
        Undo.Ring.Color = Color3_new_ret;
        local Icon = Undo:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_new_ret;
        end;

        task.delay(0.18, function() -- Line: 873
            -- upvalues: u219 (ref), Flashes (copy), Undo (copy), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret4 (ref)
            if u219.Flashes == Flashes and Undo.Parent then
                local v430 = Undo;
                v430.BackgroundColor3 = Color3_fromRGB_ret3;
                v430.BackgroundTransparency = 0.1;
                v430.Ring.Color = Color3_fromRGB_ret4;
                local Icon2 = v430:FindFirstChild("Icon");

                if Icon2 then
                    Icon2.ImageColor3 = Color3_fromRGB_ret4;
                end;
            end;
        end);

        if not u219.Stroking and u218:Undo() then
            u228 = os.clock() + 2;
        end;
    end);
    MapGamepad.OnPress(PenButtons.Redo, function() -- Line: 1322
        -- upvalues: PenButtons (copy), u219 (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret4 (ref), u218 (ref), u228 (ref)
        local Redo = PenButtons.Redo;
        local v431 = u219;
        v431.Flashes = v431.Flashes + 1;
        local Flashes = u219.Flashes;
        local v432 = Color3_fromRGB_ret;
        local Color3_new_ret = Color3.new(v432.R * 0.65, v432.G * 0.65, v432.B * 0.65);
        Redo.BackgroundColor3 = v432;
        Redo.BackgroundTransparency = 0;
        Redo.Ring.Color = Color3_new_ret;
        local Icon = Redo:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_new_ret;
        end;

        task.delay(0.18, function() -- Line: 873
            -- upvalues: u219 (ref), Flashes (copy), Redo (copy), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret4 (ref)
            if u219.Flashes == Flashes and Redo.Parent then
                local v433 = Redo;
                v433.BackgroundColor3 = Color3_fromRGB_ret3;
                v433.BackgroundTransparency = 0.1;
                v433.Ring.Color = Color3_fromRGB_ret4;
                local Icon2 = v433:FindFirstChild("Icon");

                if Icon2 then
                    Icon2.ImageColor3 = Color3_fromRGB_ret4;
                end;
            end;
        end);

        if not u219.Stroking and u218:Redo() then
            u228 = os.clock() + 2;
        end;
    end);
    MapGamepad.OnPress(PenButtons.Clear, function() -- Line: 1328
        -- upvalues: PenButtons (copy), Color3_fromRGB_ret2 (ref), u219 (ref), Color3_fromRGB_ret (ref), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret4 (ref), u218 (ref), u228 (ref)
        local Clear = PenButtons.Clear;
        local v434 = u219;
        v434.Flashes = v434.Flashes + 1;
        local Flashes = u219.Flashes;
        local v435 = Color3_fromRGB_ret2 or Color3_fromRGB_ret;
        local Color3_new_ret = Color3.new(v435.R * 0.65, v435.G * 0.65, v435.B * 0.65);
        Clear.BackgroundColor3 = v435;
        Clear.BackgroundTransparency = 0;
        Clear.Ring.Color = Color3_new_ret;
        local Icon = Clear:FindFirstChild("Icon");

        if Icon then
            Icon.ImageColor3 = Color3_new_ret;
        end;

        task.delay(0.18, function() -- Line: 873
            -- upvalues: u219 (ref), Flashes (copy), Clear (copy), Color3_fromRGB_ret3 (ref), Color3_fromRGB_ret4 (ref)
            if u219.Flashes == Flashes and Clear.Parent then
                local v436 = Clear;
                v436.BackgroundColor3 = Color3_fromRGB_ret3;
                v436.BackgroundTransparency = 0.1;
                v436.Ring.Color = Color3_fromRGB_ret4;
                local Icon2 = v436:FindFirstChild("Icon");

                if Icon2 then
                    Icon2.ImageColor3 = Color3_fromRGB_ret4;
                end;
            end;
        end);

        if u219.Stroking then
            u219.Stroking = false;
            u219.Input = nil;
            u219.Pad = false;

            if u218:End() then
                u228 = os.clock() + 2;
            end;
        end;

        u218:Clear();
        u228 = os.clock() + 2;
    end);

    for i, v in u216.Swatches do
        MapGamepad.OnPress(v, function() -- Line: 1335
            -- upvalues: u219 (ref), i (copy), u310 (ref)
            u219.Colour = i;
            u219.Erasing = false;
            u310();
        end);
    end;

    u310();
    task.defer(function() -- Line: 1342
        -- upvalues: u216 (ref), PenButtons (copy), u305 (ref), u219 (ref)
        if u216 and u216.PenPill == PenButtons.Pen.Parent then
            u305(u219.On);
        end;
    end);
    local u437 = "Body";

    local function v439() -- Line: 460
        -- upvalues: u437 (copy), u165 (ref), Color3_fromRGB_ret6 (ref), u187 (ref), u174 (ref)
        if u437 == "Eraser" then
            return u165(36, {
                {
                    Colour = Color3_fromRGB_ret6,
                    Shapes = u187({ u174.Rubber[1], u174.Sleeve[1] }, 0.09)
                },
                {
                    Colour = Color3.fromRGB(236, 128, 146),
                    Shapes = u174.Rubber
                },
                {
                    Colour = Color3.fromRGB(205, 205, 210),
                    Shapes = u174.Sleeve
                },
                {
                    Colour = Color3_fromRGB_ret6,
                    Shapes = { { "seg", 0.337, 0.43700000000000006, 0.5630000000000001, 0.663, 0.03 } }
                }
            });
        end;

        local v438 = u174[u437];

        return u165(36, {
            {
                Colour = Color3_fromRGB_ret6,
                Shapes = u187(v438, 0.09)
            },
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = v438
            }
        });
    end;

    if u188.CursorBody == nil then
        u188.CursorBody = v439() or false;
    end;

    local v440 = u188.CursorBody or nil;
    local u441 = "Bristles";

    local function v443() -- Line: 460
        -- upvalues: u441 (copy), u165 (ref), Color3_fromRGB_ret6 (ref), u187 (ref), u174 (ref)
        if u441 == "Eraser" then
            return u165(36, {
                {
                    Colour = Color3_fromRGB_ret6,
                    Shapes = u187({ u174.Rubber[1], u174.Sleeve[1] }, 0.09)
                },
                {
                    Colour = Color3.fromRGB(236, 128, 146),
                    Shapes = u174.Rubber
                },
                {
                    Colour = Color3.fromRGB(205, 205, 210),
                    Shapes = u174.Sleeve
                },
                {
                    Colour = Color3_fromRGB_ret6,
                    Shapes = { { "seg", 0.337, 0.43700000000000006, 0.5630000000000001, 0.663, 0.03 } }
                }
            });
        end;

        local v442 = u174[u441];

        return u165(36, {
            {
                Colour = Color3_fromRGB_ret6,
                Shapes = u187(v442, 0.09)
            },
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = v442
            }
        });
    end;

    if u188.CursorBristles == nil then
        u188.CursorBristles = v443() or false;
    end;

    local v444 = u188.CursorBristles or nil;
    local u445 = "Eraser";

    local function v447() -- Line: 460
        -- upvalues: u445 (copy), u165 (ref), Color3_fromRGB_ret6 (ref), u187 (ref), u174 (ref)
        if u445 == "Eraser" then
            return u165(36, {
                {
                    Colour = Color3_fromRGB_ret6,
                    Shapes = u187({ u174.Rubber[1], u174.Sleeve[1] }, 0.09)
                },
                {
                    Colour = Color3.fromRGB(236, 128, 146),
                    Shapes = u174.Rubber
                },
                {
                    Colour = Color3.fromRGB(205, 205, 210),
                    Shapes = u174.Sleeve
                },
                {
                    Colour = Color3_fromRGB_ret6,
                    Shapes = { { "seg", 0.337, 0.43700000000000006, 0.5630000000000001, 0.663, 0.03 } }
                }
            });
        end;

        local v446 = u174[u445];

        return u165(36, {
            {
                Colour = Color3_fromRGB_ret6,
                Shapes = u187(v446, 0.09)
            },
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = v446
            }
        });
    end;

    if u188.CursorEraser == nil then
        u188.CursorEraser = v447() or false;
    end;

    local v448 = u188.CursorEraser or nil;

    if v440 then
        u216.PenCursor.Body.ImageContent = v440;
    end;

    if v444 then
        u216.Bristles.ImageContent = v444;
    end;

    if v448 then
        u216.EraserCursor.ImageContent = v448;
    end;

    local Header = u216.Editor.Header;
    local Remove = Header:FindFirstChild("Remove");
    local Icon = Header.Icon;
    local v449 = "Marker" .. 22;
    local u450 = 22;
    local u451 = "Marker";

    local function v452() -- Line: 418
        -- upvalues: u165 (ref), u450 (copy), u135 (ref), u451 (copy)
        return u165(u450, {
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = u135[u451]
            }
        });
    end;

    if u188[v449] == nil then
        u188[v449] = v452() or false;
    end;

    local v453 = u188[v449] or nil;

    if v453 then
        Icon.ImageContent = v453;
    end;

    local Icon2 = Remove.Icon;
    local v454 = "Close" .. 20;
    local u455 = 20;
    local u456 = "Close";

    local function v457() -- Line: 418
        -- upvalues: u165 (ref), u455 (copy), u135 (ref), u456 (copy)
        return u165(u455, {
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = u135[u456]
            }
        });
    end;

    if u188[v454] == nil then
        u188[v454] = v457() or false;
    end;

    local v458 = u188[v454] or nil;

    if v458 then
        Icon2.ImageContent = v458;
    end;

    local Icon3 = u216.Editor.Apply.Icon;
    local v459 = "Check" .. 20;
    local u460 = 20;
    local u461 = "Check";

    local function v462() -- Line: 418
        -- upvalues: u165 (ref), u460 (copy), u135 (ref), u461 (copy)
        return u165(u460, {
            {
                Colour = Color3.new(1, 1, 1),
                Shapes = u135[u461]
            }
        });
    end;

    if u188[v459] == nil then
        u188[v459] = v462() or false;
    end;

    local v463 = u188[v459] or nil;

    if v463 then
        Icon3.ImageContent = v463;
    end;

    for i, v in u216.IconChoices do
        local Icon4 = v.Icon;
        local u464 = u166[u167[i]] or "Marker";
        local v465 = u464 .. 18;
        local u466 = 18;

        local function v467() -- Line: 418
            -- upvalues: u165 (ref), u466 (copy), u135 (ref), u464 (copy)
            return u165(u466, {
                {
                    Colour = Color3.new(1, 1, 1),
                    Shapes = u135[u464]
                }
            });
        end;

        if u188[v465] == nil then
            u188[v465] = v467() or false;
        end;

        local v468 = u188[v465] or nil;

        if v468 then
            Icon4.ImageContent = v468;
        end;

        MapGamepad.OnPress(v, function() -- Line: 1368
            -- upvalues: u222 (ref), u167 (ref), i (copy), u347 (ref), u221 (ref), u216 (ref), u143 (ref), u342 (ref), u228 (ref), u320 (ref)
            u222.Icon = u167[i];
            u347();
            local v469 = u221;

            if not v469 then
                return;
            end;

            local Colour = u222.Colour;
            v469.Icon = u222.Icon;
            v469.Colour = Colour;
            local v470 = string.gsub(u216.NameBox.Text, "^%s+", ""):gsub("%s+$", "");

            if v470 == "" or not v470 then
                v470 = u143[u222.Icon];
            end;

            v469.Name = v470;
            u342(v469);
            u228 = os.clock() + 2;
            u320();
        end);
    end;

    for i, v in u216.ColourChoices do
        MapGamepad.OnPress(v, function() -- Line: 1375
            -- upvalues: u222 (ref), i (copy), u347 (ref), u221 (ref), u216 (ref), u143 (ref), u342 (ref), u228 (ref), u320 (ref)
            u222.Colour = i;
            u347();
            local v471 = u221;

            if not v471 then
                return;
            end;

            local Colour = u222.Colour;
            v471.Icon = u222.Icon;
            v471.Colour = Colour;
            local v472 = string.gsub(u216.NameBox.Text, "^%s+", ""):gsub("%s+$", "");

            if v472 == "" or not v472 then
                v472 = u143[u222.Icon];
            end;

            v471.Name = v472;
            u342(v471);
            u228 = os.clock() + 2;
            u320();
        end);
    end;

    u216.NameBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1381
        -- upvalues: u216 (ref), u221 (ref), u143 (ref), u222 (ref), u342 (ref), u228 (ref), u320 (ref)
        local Text = u216.NameBox.Text;
        local utf8_len_ret = utf8.len(Text);

        if not utf8_len_ret or utf8_len_ret <= 24 then
            if u221 then
                local v473 = string.gsub(u216.NameBox.Text, "^%s+", ""):gsub("%s+$", "");

                if v473 == "" or not v473 then
                    v473 = u143[u222.Icon];
                end;

                if v473 ~= u221.Name then
                    local v474 = u221;

                    if not v474 then
                        return;
                    end;

                    local Colour = u222.Colour;
                    v474.Icon = u222.Icon;
                    v474.Colour = Colour;
                    local v475 = string.gsub(u216.NameBox.Text, "^%s+", ""):gsub("%s+$", "");

                    if v475 == "" or not v475 then
                        v475 = u143[u222.Icon];
                    end;

                    v474.Name = v475;
                    u342(v474);
                    u228 = os.clock() + 2;
                    u320();
                end;
            end;

            return;
        end;

        local NameBox = u216.NameBox;
        local v476 = utf8.offset(Text, 25) - 1;
        NameBox.Text = string.sub(Text, 1, v476);
    end);
    MapGamepad.OnPress(u216.Editor.Apply, function() -- Line: 1392
        -- upvalues: u221 (ref), u222 (ref), u216 (ref), u143 (ref), u342 (ref), u228 (ref), u320 (ref)
        local v477 = u221;

        if v477 then
            local Colour = u222.Colour;
            v477.Icon = u222.Icon;
            v477.Colour = Colour;
            local v478 = string.gsub(u216.NameBox.Text, "^%s+", ""):gsub("%s+$", "");

            if v478 == "" or not v478 then
                v478 = u143[u222.Icon];
            end;

            v477.Name = v478;
            u342(v477);
            u228 = os.clock() + 2;
            u320();
        end;

        u221 = nil;

        if u216 then
            u216.Editor.Visible = false;
            u216.NameBox:ReleaseFocus();
        end;
    end);
    MapGamepad.Register(u216.NameBox, {});
    MapGamepad.OnPress(Remove, function() -- Line: 1397
        -- upvalues: u221 (ref), u361 (ref)
        if u221 then
            u361(u221);
        end;
    end);

    for _, v in u220 do
        u373(v);
    end;

    for i, v in u220 do
        local v479 = u216.Views[v];

        if v479 then
            v479.Row.LayoutOrder = i;
        end;
    end;

    u216.MarkerList.Visible = #u220 > 0;
    u283();
    u216.Content:GetPropertyChangedSignal("AbsoluteSize"):Connect(u267);
    u216.Map:GetPropertyChangedSignal("AbsoluteSize"):Connect(u287);
    u216.CloseMap:GetPropertyChangedSignal("Visible"):Connect(u287);
    task.defer(u287);
    local v480 = {};

    for i = 1, 6 do
        local v481 = i;
        local v482 = {};

        for i2 = 1, 2 do
            local v483 = u216.PenSounds:FindFirstChild(string.format("PenStroke%d_%d", v481, i2));
            local v484;

            if v483 then
                v482[#v482 + 1] = v483;
                v484 = i2;
            else
                v484 = i2;
            end;
        end;

        if #v482 > 0 then
            v480[#v480 + 1] = v482;
        end;
    end;

    u216.Voices = v480;
    task.spawn(function() -- Line: 1427
        -- upvalues: ContentProvider (ref), u216 (ref)
        pcall(ContentProvider.PreloadAsync, ContentProvider, u216.PenSounds:GetChildren());
    end);
    local Map = u216.Map;
    Tools.Visible = u216.Map:GetAttribute("Locked") ~= true;
    Map:GetAttributeChangedSignal("Locked"):Connect(function() -- Line: 1434
        -- upvalues: Tools (copy), u216 (ref), u219 (ref), u218 (ref), u228 (ref), u310 (ref), u305 (ref), u221 (ref), u224 (ref), u226 (ref), UserInputService (ref)
        Tools.Visible = u216.Map:GetAttribute("Locked") ~= true;

        if u216.Map:GetAttribute("Locked") == true then
            if u219.Stroking then
                u219.Stroking = false;
                u219.Input = nil;
                u219.Pad = false;

                if u218:End() then
                    u228 = os.clock() + 2;
                end;
            end;

            if u219.On or u219.Erasing then
                u219.On = false;
                u219.Erasing = false;
                u310();
                u305(false);
            end;

            u221 = nil;

            if u216 then
                u216.Editor.Visible = false;
                u216.NameBox:ReleaseFocus();
            end;

            u224.Right = nil;
            u224.Left = nil;
            u216.Tooltip.Visible = false;

            if u226.Shown then
                u226.Shown.Visible = false;
                u226.Shown = nil;
            end;

            if u226.Hidden then
                u226.Hidden = false;
                UserInputService.MouseIconEnabled = UserInputService.MouseBehavior == Enum.MouseBehavior.Default;
            end;
        end;

        for i, v in u216.BagPins do
            v:Destroy();
            u216.BagPins[i] = nil;
        end;
    end);
    Map:GetPropertyChangedSignal("Visible"):Connect(function() -- Line: 1441
        -- upvalues: Map (copy), u417 (ref), u219 (ref), u218 (ref), u228 (ref), u310 (ref), u305 (ref), u221 (ref), u216 (ref), u224 (ref), u226 (ref), UserInputService (ref)
        if Map.Visible then
            u417();

            return;
        end;

        if u219.Stroking then
            u219.Stroking = false;
            u219.Input = nil;
            u219.Pad = false;

            if u218:End() then
                u228 = os.clock() + 2;
            end;
        end;

        if u219.On or u219.Erasing then
            u219.On = false;
            u219.Erasing = false;
            u310();
            u305(false);
        end;

        u221 = nil;

        if u216 then
            u216.Editor.Visible = false;
            u216.NameBox:ReleaseFocus();
        end;

        u224.Right = nil;
        u224.Left = nil;
        u216.Tooltip.Visible = false;

        if u226.Shown then
            u226.Shown.Visible = false;
            u226.Shown = nil;
        end;

        if u226.Hidden then
            u226.Hidden = false;
            UserInputService.MouseIconEnabled = UserInputService.MouseBehavior == Enum.MouseBehavior.Default;
        end;
    end);
    u216.Content.ChildAdded:Connect(function(u485) -- Line: 1449
        -- upvalues: u217 (ref)
        if u485.Name == "ShopMarker" and not u217.VendingMachines then
            task.defer(function() -- Line: 1451
                -- upvalues: u485 (copy), u217 (ref)
                if u485:IsA("GuiObject") then
                    u485.Visible = u217.VendingMachines;
                end;
            end);
        end;
    end);
    u320();

    if Map.Visible then
        u417();
    end;
end;

function u215.Attach(u487: userdata) -- Line: 1464
    -- upvalues: u216 (ref), u225 (copy), MapDrawing (copy), u219 (copy), u218 (copy), u228 (ref), u310 (copy), u305 (copy), u221 (ref), u224 (copy), u226 (copy), UserInputService (copy), u486 (copy), MapGamepad (copy), u215 (copy)
    if u216 and u216.Map == u487 then
        return;
    end;

    u225.Seen = false;
    local v488 = u487:FindFirstAncestorOfClass("ScreenGui");
    local MapTools = u487:WaitForChild("MapTools", 10);
    local Frame = u487:WaitForChild("Frame", 10);
    local v489;

    if Frame then
        v489 = Frame:WaitForChild("Map", 10);
    else
        v489 = Frame;
    end;

    if not (v488 and (MapTools and v489)) then
        return;
    end;

    local Grid = v489:WaitForChild("Grid");
    local Controls = MapTools:WaitForChild("Controls");
    local Toggles = Controls:WaitForChild("Toggles");
    local Pen = Controls:WaitForChild("Pen");
    local Palette = Pen:WaitForChild("Palette");
    local MarkerEditor = MapTools:WaitForChild("MarkerEditor");
    local MarkerList = MapTools:WaitForChild("MarkerList");
    local PenCursor = MapTools:WaitForChild("PenCursor");
    local NameRow = MarkerEditor:WaitForChild("NameRow");
    local v490 = {};

    for i = 1, #MapDrawing.Palette do
        v490[i] = Palette:WaitForChild("Colour" .. i);
        local _ = i;
    end;

    local function v492(p491: userdata) -- Line: 1489
        -- upvalues: MarkerEditor (copy)
        local Strip = MarkerEditor:WaitForChild(p491):WaitForChild("Cell"):WaitForChild("Strip");

        return {
            Strip:WaitForChild("Choice" .. 1),
            Strip:WaitForChild("Choice" .. 2),
            Strip:WaitForChild("Choice" .. 3),
            Strip:WaitForChild("Choice" .. 4),
            Strip:WaitForChild("Choice" .. 5),
            Strip:WaitForChild("Choice" .. 6)
        };
    end;

    local UserMarkers = v489:WaitForChild("UserMarkers");
    local SleepingBags = v489:WaitForChild("SleepingBags");

    if u216 then
        if u219.Stroking then
            u219.Stroking = false;
            u219.Input = nil;
            u219.Pad = false;

            if u218:End() then
                u228 = os.clock() + 2;
            end;
        end;

        if u219.On or u219.Erasing then
            u219.On = false;
            u219.Erasing = false;
            u310();
            u305(false);
        end;

        u221 = nil;

        if u216 then
            u216.Editor.Visible = false;
            u216.NameBox:ReleaseFocus();
        end;

        u224.Right = nil;
        u224.Left = nil;
        u216.Tooltip.Visible = false;

        if u226.Shown then
            u226.Shown.Visible = false;
            u226.Shown = nil;
        end;

        if u226.Hidden then
            u226.Hidden = false;
            UserInputService.MouseIconEnabled = UserInputService.MouseBehavior == Enum.MouseBehavior.Default;
        end;
    end;

    u216 = {
        Gui = v488,
        Map = u487,
        Frame = Frame,
        Content = v489,
        Tools = MapTools,
        CloseMap = v488:WaitForChild("CloseMap"),
        Grid = Grid,
        GridLines = Grid:WaitForChild("Lines"),
        GridNames = Grid:WaitForChild("Names"),
        LineTemplate = Grid.Lines:WaitForChild("LineTemplate"),
        NameTemplate = Grid.Names:WaitForChild("NameTemplate"),
        GridCell = nil,
        BagLayer = SleepingBags,
        BagTemplate = SleepingBags:WaitForChild("SleepingBagTemplate"),
        BagPins = {},
        PinLayer = UserMarkers,
        PinTemplate = UserMarkers:WaitForChild("UserMarkerTemplate"),
        Controls = Controls,
        ControlsScale = Controls:WaitForChild("StyleScale"),
        Toggles = {
            Grid = Toggles:WaitForChild("Grid"),
            SleepingBags = Toggles:WaitForChild("SleepingBags"),
            VendingMachines = Toggles:WaitForChild("VendingMachines"),
            MonumentNames = Toggles:WaitForChild("MonumentNames"),
            Follow = Toggles:WaitForChild("Follow")
        },
        PenPill = Pen,
        PenList = Pen:WaitForChild("List"),
        PenTween = nil,
        PenButtons = {
            Pen = Pen:WaitForChild("Pen"),
            Eraser = Pen:WaitForChild("Eraser"),
            Undo = Pen:WaitForChild("Undo"),
            Redo = Pen:WaitForChild("Redo"),
            Clear = Pen:WaitForChild("Clear")
        },
        Swatches = v490,
        MarkerList = MarkerList,
        ListScale = MarkerList:WaitForChild("StyleScale"),
        RowTemplate = MarkerList:WaitForChild("MarkerRowTemplate"),
        Views = {},
        Editor = MarkerEditor,
        EditorBack = MapTools:WaitForChild("MarkerEditorStyleBackdrop"),
        LookPanels = {
            u487:FindFirstChild("BagList"),
            u487:FindFirstChild("ShopList"),
            u487:FindFirstChild("ShopOffers"),
            u487:FindFirstChild("SeedLab")
        },
        DeathFooter = u487.Parent:WaitForChild("Death"):WaitForChild("Footer"),
        DeathHeader = u487.Parent.Death:WaitForChild("Header"),
        PinLayers = { SleepingBags, v489:FindFirstChild("VendingMachines") },
        NameBox = NameRow:WaitForChild("Cell"):WaitForChild("NameBox"),
        IconChoices = v492("IconRow"),
        ColourChoices = v492("ColourRow"),
        Tooltip = MapTools:WaitForChild("Tooltip"),
        PenCursor = PenCursor,
        Bristles = PenCursor:WaitForChild("Bristles"),
        EraserCursor = MapTools:WaitForChild("EraserCursor"),
        PenSounds = MapTools:WaitForChild("PenSounds"),
        Voices = {}
    };
    local u493 = false;

    local function v498() -- Line: 1566
        -- upvalues: u493 (ref), u487 (copy), Frame (copy)
        if u493 then
            return;
        end;

        local AbsolutePosition = u487.AbsolutePosition;
        local AbsoluteSize = u487.AbsoluteSize;

        if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            return;
        end;

        local Position = Frame.Position;
        local Size = Frame.Size;
        local AnchorPoint = Frame.AnchorPoint;
        local v494 = AbsolutePosition.X + Position.X.Scale * AbsoluteSize.X + Position.X.Offset - AnchorPoint.X * (Size.X.Scale * AbsoluteSize.X + Size.X.Offset);
        local v495 = AbsolutePosition.Y + Position.Y.Scale * AbsoluteSize.Y + Position.Y.Offset - AnchorPoint.Y * (Size.Y.Scale * AbsoluteSize.Y + Size.Y.Offset);
        local v496 = math.round(v494) - v494;
        local v497 = math.round(v495) - v495;

        if math.abs(v496) < 0.001 and math.abs(v497) < 0.001 then
            return;
        end;

        u493 = true;
        Frame.Position = UDim2.new(Position.X.Scale + v496 / AbsoluteSize.X, Position.X.Offset, Position.Y.Scale + v497 / AbsoluteSize.Y, Position.Y.Offset);
        u493 = false;
    end;

    Frame:GetPropertyChangedSignal("Position"):Connect(v498);
    Frame:GetPropertyChangedSignal("Size"):Connect(v498);
    u487:GetPropertyChangedSignal("AbsoluteSize"):Connect(v498);
    v498();
    u221 = nil;
    u486();
    MapGamepad.Attach(u487);
    u215.Leader.Refresh();
    u487.Destroying:Connect(function() -- Line: 1593
        -- upvalues: u216 (ref), u487 (copy), u219 (ref), u218 (ref), u228 (ref), u226 (ref), UserInputService (ref), u221 (ref)
        if u216 and u216.Map == u487 then
            if u219.Stroking then
                u219.Stroking = false;
                u219.Input = nil;
                u219.Pad = false;

                if u218:End() then
                    u228 = os.clock() + 2;
                end;
            end;

            if u226.Shown then
                u226.Shown.Visible = false;
                u226.Shown = nil;
            end;

            if u226.Hidden then
                u226.Hidden = false;
                UserInputService.MouseIconEnabled = UserInputService.MouseBehavior == Enum.MouseBehavior.Default;
            end;

            u221 = nil;
            u216 = nil;
        end;
    end);
end;

u215.Leader = {
    Name = nil,
    Markers = {},
    Pins = {},
    CompassPins = setmetatable({}, {
        __mode = "k"
    }),
    List = {}
};

function u215.Leader.Refresh() -- Line: 1609
    -- upvalues: u215 (copy), u216 (ref), u1 (copy), u165 (copy), u188 (copy), u166 (copy), u135 (copy), MapUIStyle (copy)
    local Leader = u215.Leader;

    for _, v in Leader.Pins do
        v:Destroy();
    end;

    table.clear(Leader.Pins);

    if not u216 then
        return;
    end;

    for _, v in Leader.Markers do
        local v499 = u216.PinTemplate:Clone();
        v499.Name = "LeaderMarker";
        v499.Visible = true;
        v499.Active = false;
        local v500 = u1[v.Colour] or u1[1];
        local v501 = v.Icon == 1;
        local v502;

        if v501 then
            v502 = Vector2.new(0.5, 0.95);
        else
            v502 = Vector2.new(0.5, 0.5);
        end;

        v499.AnchorPoint = v502;

        if v501 then
            local Colour = v.Colour;
            local v503 = "Tear" .. Colour;

            local function v506() -- Line: 436
                -- upvalues: u1 (ref), Colour (copy), u165 (ref)
                local v504 = u1[Colour] or u1[1];
                local Color3_new_ret = Color3.new(v504.R * 0.65, v504.G * 0.65, v504.B * 0.65);
                local v505 = { "tri", 0.241, 0.512, 0.759, 0.512, 0.5, 0.95 };

                return u165(38, {
                    {
                        Colour = Color3_new_ret,
                        Shapes = {
                            { "circle", 0.5, 0.36, 0.33999999999999997 },
                            {
                                "tri",
                                v505[2],
                                v505[3],
                                v505[4],
                                v505[5],
                                v505[6],
                                v505[7],
                                grow = 0.04
                            }
                        }
                    },
                    {
                        Colour = v504,
                        Shapes = {
                            { "circle", 0.5, 0.36, 0.3 },
                            v505
                        }
                    },
                    {
                        Colour = Color3_new_ret,
                        Shapes = { { "circle", 0.5, 0.36, 0.12 } }
                    }
                });
            end;

            if u188[v503] == nil then
                u188[v503] = v506() or false;
            end;

            local v507 = u188[v503] or nil;

            if v507 then
                v499.ImageContent = v507;
            end;
        else
            local Icon = v499.Badge.Icon;
            local u508 = u166[v.Icon] or "Marker";
            local v509 = u508 .. 18;
            local u510 = 18;

            local function v511() -- Line: 418
                -- upvalues: u165 (ref), u510 (copy), u135 (ref), u508 (copy)
                return u165(u510, {
                    {
                        Colour = Color3.new(1, 1, 1),
                        Shapes = u135[u508]
                    }
                });
            end;

            if u188[v509] == nil then
                u188[v509] = v511() or false;
            end;

            local v512 = u188[v509] or nil;

            if v512 then
                Icon.ImageContent = v512;
            end;

            local Badge = v499.Badge;
            local Color3_new_ret = Color3.new(v500.R * 0.65, v500.G * 0.65, v500.B * 0.65);
            Badge.BackgroundColor3 = v500;
            Badge.BackgroundTransparency = 0;
            Badge.Ring.Color = Color3_new_ret;
            local Icon2 = Badge:FindFirstChild("Icon");

            if Icon2 then
                Icon2.ImageColor3 = Color3_new_ret;
            end;
        end;

        v499.ImageTransparency = v501 and 0 or 1;
        v499.Badge.Visible = not v501;
        v499.Tag.Position = UDim2.new(0.5, 0, 1, v501 and 2 or -2);
        v499.Tag.Text = string.format("%s: %s", Leader.Name or "Leader", v.Name);
        v499.Position = UDim2.fromScale(v.U, v.V);
        MapUIStyle.Scaled(v499);
        v499.Parent = u216.PinLayer;
        table.insert(Leader.Pins, v499);
    end;
end;

function u215.CompassStep(p513: userdata, p514: vector, p515: number, p516: number) -- Line: 1649
    -- upvalues: MapRenderClient (copy), u215 (copy), u220 (copy), u1 (copy), u165 (copy), u188 (copy), u166 (copy), u135 (copy)
    local MarkerTemplate = p513:FindFirstChild("MarkerTemplate");
    local Header = MapRenderClient.Header;

    if not MarkerTemplate then
        return;
    end;

    local Leader = u215.Leader;
    local v517 = Leader.CompassPins[p513];

    if not v517 then
        v517 = {};
        Leader.CompassPins[p513] = v517;
    end;

    local List = Leader.List;
    table.clear(List);

    if Header then
        local v518 = Header.Width * Header.PixelSize;
        local v519 = Header.Height * Header.PixelSize;

        for _, v in u220 do
            List[#List + 1] = v;
        end;

        for _, v in Leader.Markers do
            List[#List + 1] = v;
        end;

        for i, v in List do
            local v520 = v517[i];

            if not v520 then
                v520 = {
                    Key = nil,
                    Frame = MarkerTemplate:Clone()
                };
                v520.Frame.Name = "Marker";
                v520.Frame.Parent = p513;
                v517[i] = v520;
            end;

            local v521 = p514.X - (Header.OriginX + v.U * v518);
            local v522 = p514.Z - (Header.OriginZ + v.V * v519);
            local v523 = false;
            local v524, v525;

            if v521 * v521 + v522 * v522 > 16 then
                local math_atan2_ret = math.atan2(v521, v522);
                local v526 = -math.deg(math_atan2_ret) - 90;

                if v526 < 0 then
                    v526 = v526 + 360;
                end;

                v524 = i;
                v525 = v;

                for i2 = 1, 3 do
                    local v527 = v526 + (i2 == 1 and 0 or (i2 == 2 and -360 or 360)) - p515;

                    if math.abs(v527) <= p516 then
                        v520.Frame.Position = UDim2.new(0.5 + v527 / (p516 * 2), 0, 0.02, 0);
                        v523 = true;
                        break;
                    end;

                    local _ = i2;
                end;
            else
                v524 = i;
                v525 = v;
            end;

            if v523 then
                local v528 = v525.Icon .. ":" .. v525.Colour;

                if v520.Key ~= v528 then
                    v520.Key = v528;
                    local v529 = v525.Icon == 1;
                    v520.Frame.Tear.Visible = v529;
                    v520.Frame.Badge.Visible = not v529;

                    if v529 then
                        local Colour = v525.Colour;
                        local v530 = "Tear" .. Colour;

                        local function v533() -- Line: 436
                            -- upvalues: u1 (ref), Colour (copy), u165 (ref)
                            local v531 = u1[Colour] or u1[1];
                            local Color3_new_ret = Color3.new(v531.R * 0.65, v531.G * 0.65, v531.B * 0.65);
                            local v532 = { "tri", 0.241, 0.512, 0.759, 0.512, 0.5, 0.95 };

                            return u165(38, {
                                {
                                    Colour = Color3_new_ret,
                                    Shapes = {
                                        { "circle", 0.5, 0.36, 0.33999999999999997 },
                                        {
                                            "tri",
                                            v532[2],
                                            v532[3],
                                            v532[4],
                                            v532[5],
                                            v532[6],
                                            v532[7],
                                            grow = 0.04
                                        }
                                    }
                                },
                                {
                                    Colour = v531,
                                    Shapes = {
                                        { "circle", 0.5, 0.36, 0.3 },
                                        v532
                                    }
                                },
                                {
                                    Colour = Color3_new_ret,
                                    Shapes = { { "circle", 0.5, 0.36, 0.12 } }
                                }
                            });
                        end;

                        if u188[v530] == nil then
                            u188[v530] = v533() or false;
                        end;

                        local v534 = u188[v530] or nil;

                        if v534 then
                            v520.Frame.Tear.ImageContent = v534;
                        end;
                    else
                        v520.Frame.Badge.BackgroundColor3 = u1[v525.Colour] or u1[1];
                        local u535 = u166[v525.Icon] or "Marker";
                        local v536 = u535 .. 18;
                        local u537 = 18;

                        local function v538() -- Line: 418
                            -- upvalues: u165 (ref), u537 (copy), u135 (ref), u535 (copy)
                            return u165(u537, {
                                {
                                    Colour = Color3.new(1, 1, 1),
                                    Shapes = u135[u535]
                                }
                            });
                        end;

                        if u188[v536] == nil then
                            u188[v536] = v538() or false;
                        end;

                        local v539 = u188[v536] or nil;

                        if v539 then
                            v520.Frame.Badge.Icon.ImageContent = v539;
                        end;
                    end;
                end;

                v520.Frame.ZIndex = v524 <= #u220 and 4 or 3;
            end;

            v520.Frame.Visible = v523;
        end;
    end;

    for i = #List + 1, #v517 do
        v517[i].Frame.Visible = false;
        local _ = i;
    end;
end;

task.spawn(function() -- Line: 1726
    -- upvalues: ReplicatedStorage (copy), u215 (copy)
    ReplicatedStorage:WaitForChild("ClientSignals"):WaitForChild("TeamMarkers").OnClientEvent:Connect(function(p540, p541) -- Line: 1727
        -- upvalues: u215 (ref)
        local Leader = u215.Leader;
        table.clear(Leader.Markers);

        if type(p540) == "table" then
            for _, v in p540 do
                if type(v) == "table" and (type(v.N) == "string" and (type(v.U) == "number" and type(v.V) == "number")) then
                    local Markers = Leader.Markers;
                    local v542 = {
                        Name = v.N,
                        Icon = tonumber(v.I) or 1,
                        Colour = tonumber(v.C) or 1,
                        U = math.clamp(v.U, 0, 1),
                        V = math.clamp(v.V, 0, 1)
                    };
                    table.insert(Markers, v542);
                end;
            end;
        end;

        Leader.Name = type(p541) == "string" and p541 and p541 or "Leader";
        Leader.Refresh();
    end);
end);
u215.Death = {
    Px = 52,
    H = 66,
    BadgeY = 0.4015,
    Image = nil,
    Fill = Color3.fromRGB(206, 46, 40),
    Bone = Color3.fromRGB(242, 234, 216)
};

function u215.DeathImage() -- Line: 1754
    -- upvalues: u215 (copy), math_sqrt (copy), u165 (copy)
    local Death = u215.Death;

    if Death.Image == nil then
        local v543 = (Death.H - 0.5) / Death.Px;

        local function v556(p544, p545, p546, p547, p548, p549, p550) -- Line: 1758
            -- upvalues: math_sqrt (ref)
            local v551 = p546 - p544;
            local v552 = p547 - p545;
            local v553 = math_sqrt(v551 * v551 + v552 * v552);
            local v554 = -v552 / v553 * p549 * 0.9;
            local v555 = v551 / v553 * p549 * 0.9;

            return {
                {
                    "seg",
                    p544,
                    p545,
                    p546,
                    p547,
                    p548 + 2 * p550
                },
                {
                    "circle",
                    p544 + v554,
                    p545 + v555,
                    p549 + p550
                },
                {
                    "circle",
                    p544 - v554,
                    p545 - v555,
                    p549 + p550
                },
                {
                    "circle",
                    p546 + v554,
                    p547 + v555,
                    p549 + p550
                },
                {
                    "circle",
                    p546 - v554,
                    p547 - v555,
                    p549 + p550
                }
            };
        end;

        local v557 = v556(0.31, 0.47, 0.69, 0.615, 0.05, 0.033, 0);

        for _, v in v556(0.69, 0.47, 0.31, 0.615, 0.05, 0.033, 0) do
            table.insert(v557, v);
        end;

        local function v559(p558) -- Line: 1773
            return {
                {
                    "circle",
                    0.5,
                    0.262,
                    0.135 + p558
                },
                {
                    "rect",
                    0.5,
                    0.375,
                    0.074 + p558,
                    0.06 + p558,
                    0.03
                }
            };
        end;

        local v560 = v559(0);
        table.insert(v560, {
            "circle",
            0.45,
            0.285,
            0.04,
            cut = true
        });
        table.insert(v560, {
            "circle",
            0.55,
            0.285,
            0.04,
            cut = true
        });
        table.insert(v560, {
            "tri",
            0.482,
            0.352,
            0.518,
            0.352,
            0.5,
            0.384,
            cut = true
        });
        Death.Image = u165(Death.Px, {
            {
                Colour = Death.Fill,
                Shapes = {
                    {
                        "rect",
                        0.5,
                        Death.BadgeY,
                        0.30500000000000005,
                        0.33499999999999996,
                        0.11
                    },
                    {
                        "tri",
                        0.365,
                        0.66,
                        0.635,
                        0.66,
                        0.5,
                        v543
                    }
                }
            },
            {
                Colour = Death.Bone,
                Shapes = v557
            },
            {
                Colour = Death.Fill,
                Shapes = v559(0.028)
            },
            {
                Colour = Death.Bone,
                Shapes = v560
            }
        }, Death.H) or false;
    end;

    return Death.Image or nil;
end;

function u215.Shown(p561: string) -- Line: 1799
    -- upvalues: u217 (copy)
    return u217[p561] == true;
end;

function u215.KeyDown() -- Line: 1803
    -- upvalues: u223 (copy)
    u223.Down = true;
    u223.Used = false;
end;

function u215.KeyUp() -- Line: 1808
    -- upvalues: u223 (copy), u219 (copy), u221 (ref)
    local Used = u223.Used;
    u223.Down = false;
    u223.Used = false;

    return Used or (u219.On or u219.Stroking or u221 ~= nil);
end;

function u215.BlocksPan(p562: userdata) -- Line: 1814
    -- upvalues: u216 (ref), u252 (copy), GuiService (copy), u219 (copy)
    if not (u216 and u216.Map.Visible) then
        return false;
    end;

    local UserInputType = p562.UserInputType;
    local Position = p562.Position;
    local v563 = Vector2.new(Position.X, Position.Y) + GuiService:GetGuiInset();
    local v564;

    if u216.Gui.IgnoreGuiInset then
        v564 = Vector2.zero;
    else
        v564 = GuiService:GetGuiInset();
    end;

    local v565 = u252(v563 - v564 + u216.Map.AbsolutePosition);

    if UserInputType == Enum.UserInputType.MouseWheel or UserInputType == Enum.UserInputType.MouseButton2 then
        return v565;
    end;

    if not v565 then
        v565 = u219.On;

        if v565 then
            local v566 = u216.Map:GetAttribute("Locked") == true;
            v565 = not v566;
        end;
    end;

    return v565;
end;

u215.Pad = {
    PenOn = function() -- Line: 1828, Name: PenOn
        -- upvalues: u219 (copy)
        return u219.On;
    end,

    Erasing = function() -- Line: 1831, Name: Erasing
        -- upvalues: u219 (copy)
        return u219.Erasing;
    end,

    Colour = function() -- Line: 1834, Name: Colour
        -- upvalues: u219 (copy)
        return u219.Colour;
    end,

    Editing = function() -- Line: 1837, Name: Editing
        -- upvalues: u221 (ref)
        return u221 ~= nil;
    end,

    CanPlace = function() -- Line: 1840, Name: CanPlace
        -- upvalues: u216 (ref), u220 (copy)
        local v567;

        if u216 == nil or #u220 >= 6 then
            v567 = false;
        else
            local v568 = u216.Map:GetAttribute("Locked") == true;
            v567 = not v568;
        end;

        return v567;
    end,

    Buttons = function() -- Line: 1843, Name: Buttons
        -- upvalues: u216 (ref)
        return u216 and u216.PenButtons;
    end,

    Swatches = function() -- Line: 1846, Name: Swatches
        -- upvalues: u216 (ref)
        return u216 and u216.Swatches;
    end,

    PlaceMarker = function(p569) -- Line: 1850, Name: PlaceMarker
        -- upvalues: u216 (ref), u220 (copy), u393 (copy)
        if not (u216 and u216.Map.Visible) then
            return false;
        end;

        u393(p569);

        return #u220 < #u220;
    end,

    Begin = function(p570) -- Line: 1859, Name: Begin
        -- upvalues: u216 (ref), u219 (copy), u252 (copy), u218 (copy), MapDrawing (copy)
        if not (u216 and (u216.Map.Visible and (u219.On and not u219.Stroking)) and (u216.Map:GetAttribute("Locked") ~= true and not u252(p570))) then
            return false;
        end;

        local v571 = (p570 - u216.Content.AbsolutePosition) / u216.Content.AbsoluteSize;
        local v572;

        if v571.X >= 0 and (v571.X <= 1 and v571.Y >= 0) then
            v572 = v571.Y <= 1;
        else
            v572 = false;
        end;

        if not v572 then
            return false;
        end;

        u219.Stroking = u218:Begin(v571.X, v571.Y, u219.Erasing and MapDrawing.Erase or u219.Colour);
        u219.Pad = u219.Stroking;

        return u219.Stroking;
    end,

    Extend = function(p573) -- Line: 1871, Name: Extend
        -- upvalues: u219 (copy), u216 (ref), u218 (copy)
        if u219.Stroking and (u219.Pad and u216) then
            local v574 = (p573 - u216.Content.AbsolutePosition) / u216.Content.AbsoluteSize;
            u218:Extend(v574.X, v574.Y);
        end;
    end,

    End = function() -- Line: 1877, Name: End
        -- upvalues: u219 (copy), u218 (copy), u228 (ref)
        if u219.Pad and u219.Stroking then
            u219.Stroking = false;
            u219.Input = nil;
            u219.Pad = false;

            if u218:End() then
                u228 = os.clock() + 2;
            end;
        end;
    end,

    CloseEditor = function() -- Line: 1883, Name: CloseEditor
        -- upvalues: u221 (ref), u222 (copy), u216 (ref), u143 (copy), u342 (copy), u228 (ref), u320 (copy)
        if not u221 then
            return false;
        end;

        local v575 = u221;

        if v575 then
            local Colour = u222.Colour;
            v575.Icon = u222.Icon;
            v575.Colour = Colour;
            local v576 = string.gsub(u216.NameBox.Text, "^%s+", ""):gsub("%s+$", "");

            if v576 == "" or not v576 then
                v576 = u143[u222.Icon];
            end;

            v575.Name = v576;
            u342(v575);
            u228 = os.clock() + 2;
            u320();
        end;

        u221 = nil;

        if u216 then
            u216.Editor.Visible = false;
            u216.NameBox:ReleaseFocus();
        end;

        return true;
    end,

    PanBy = function(p577) -- Line: 1892, Name: PanBy
        -- upvalues: u216 (ref), u225 (copy), u257 (copy)
        if not u216 then
            return;
        end;

        local AbsoluteSize = u216.Map.AbsoluteSize;

        if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
            return;
        end;

        u225.Chasing = false;
        u257(p577 / AbsoluteSize);
    end,

    Recentre = function() -- Line: 1903, Name: Recentre
        -- upvalues: u216 (ref), LocalPlayer (copy), MapRenderClient (copy), u257 (copy)
        local v578 = u216;

        if v578 then
            v578 = LocalPlayer.Character;

            if v578 then
                v578 = v578:FindFirstChild("HumanoidRootPart");
            end;

            if v578 then
                v578 = MapRenderClient.WorldToUV(v578.Position);
            end;
        end;

        if v578 then
            local AbsoluteSize = u216.Map.AbsoluteSize;
            local v579;

            if AbsoluteSize.X < 1 or AbsoluteSize.Y < 1 then
                v579 = nil;
            else
                v579 = (u216.Map.AbsolutePosition + AbsoluteSize / 2 - (u216.Content.AbsolutePosition + v578 * u216.Content.AbsoluteSize)) / AbsoluteSize;
            end;

            if v579 then
                u257(v579);
            end;
        end;
    end,

    SetPoint = function(p580) -- Line: 1910, Name: SetPoint
        -- upvalues: u226 (copy)
        u226.Pad = p580;
    end
};

local function _(p581: userdata) -- Line: 1916
    return p581.UserInputType == Enum.UserInputType.MouseButton1 and true or p581.UserInputType == Enum.UserInputType.Touch;
end;

UserInputService.InputBegan:Connect(function(p582) -- Line: 1921
    -- upvalues: u216 (ref), u223 (copy), GuiService (copy), u252 (copy), u224 (copy), u219 (copy), u218 (copy), MapDrawing (copy), u221 (ref)
    if not (u216 and u216.Map.Visible) then
        return;
    end;

    local UserInputType = p582.UserInputType;

    if u223.Down and (p582.UserInputType == Enum.UserInputType.MouseButton1 or p582.UserInputType == Enum.UserInputType.Touch or UserInputType == Enum.UserInputType.MouseButton2) then
        u223.Used = true;
    end;

    if u216.Map:GetAttribute("Locked") == true or p582.UserInputType ~= Enum.UserInputType.MouseButton1 and p582.UserInputType ~= Enum.UserInputType.Touch and UserInputType ~= Enum.UserInputType.MouseButton2 then
        return;
    end;

    local Position = p582.Position;
    local v583 = Vector2.new(Position.X, Position.Y) + GuiService:GetGuiInset();
    local v584;

    if u216.Gui.IgnoreGuiInset then
        v584 = Vector2.zero;
    else
        v584 = GuiService:GetGuiInset();
    end;

    local v585 = v583 - v584 + u216.Map.AbsolutePosition;

    if u252(v585) then
        return;
    end;

    if UserInputType ~= Enum.UserInputType.MouseButton2 then
        if u219.On then
            if not u219.Stroking then
                local v586 = (v585 - u216.Content.AbsolutePosition) / u216.Content.AbsoluteSize;
                local v587;

                if v586.X >= 0 and (v586.X <= 1 and v586.Y >= 0) then
                    v587 = v586.Y <= 1;
                else
                    v587 = false;
                end;

                if v587 then
                    u219.Stroking = u218:Begin(v586.X, v586.Y, u219.Erasing and MapDrawing.Erase or u219.Colour);

                    if not u219.Stroking then
                        p582 = nil;
                    end;

                    u219.Input = p582;

                    return;
                end;
            end;
        elseif u221 then
            u224.Left = v585;
        end;

        return;
    end;

    local os_clock_ret = os.clock();
    u224.Right = v585;
    u224.RightAt = os_clock_ret;
end);
UserInputService.InputChanged:Connect(function(p588) -- Line: 1954
    -- upvalues: u216 (ref), u219 (copy), GuiService (copy), u218 (copy)
    if not (u216 and u216.Map.Visible) then
        return;
    end;

    if u219.Stroking and (u219.Input and (p588 == u219.Input or p588.UserInputType == Enum.UserInputType.MouseMovement and u219.Input.UserInputType == Enum.UserInputType.MouseButton1)) then
        local Position = p588.Position;
        local v589 = Vector2.new(Position.X, Position.Y) + GuiService:GetGuiInset();
        local v590;

        if u216.Gui.IgnoreGuiInset then
            v590 = Vector2.zero;
        else
            v590 = GuiService:GetGuiInset();
        end;

        local v591 = (v589 - v590 + u216.Map.AbsolutePosition - u216.Content.AbsolutePosition) / u216.Content.AbsoluteSize;
        u218:Extend(v591.X, v591.Y);
    end;
end);
UserInputService.InputEnded:Connect(function(p592) -- Line: 1966
    -- upvalues: u216 (ref), u219 (copy), u218 (copy), u228 (ref), u224 (copy), GuiService (copy), u393 (copy), u221 (ref)
    if not u216 then
        return;
    end;

    local UserInputType = p592.UserInputType;

    if u219.Stroking and (u219.Input and (p592 == u219.Input or UserInputType == Enum.UserInputType.MouseButton1 and u219.Input.UserInputType == Enum.UserInputType.MouseButton1)) and u219.Stroking then
        u219.Stroking = false;
        u219.Input = nil;
        u219.Pad = false;

        if u218:End() then
            u228 = os.clock() + 2;
        end;
    end;

    if UserInputType == Enum.UserInputType.MouseButton2 and u224.Right then
        local Right = u224.Right;
        local v593 = os.clock() - u224.RightAt;
        u224.Right = nil;
        local Position = p592.Position;
        local v594 = Vector2.new(Position.X, Position.Y) + GuiService:GetGuiInset();
        local v595;

        if u216.Gui.IgnoreGuiInset then
            v595 = Vector2.zero;
        else
            v595 = GuiService:GetGuiInset();
        end;

        local v596 = v594 - v595 + u216.Map.AbsolutePosition;

        if u216.Map.Visible and (v593 <= 0.25 and (v596 - Right).Magnitude <= 5) then
            u393(v596);
        end;
    elseif (p592.UserInputType == Enum.UserInputType.MouseButton1 and true or p592.UserInputType == Enum.UserInputType.Touch) and u224.Left then
        local Left = u224.Left;
        u224.Left = nil;

        if u221 and u216.Map.Visible then
            local Position = p592.Position;
            local v597 = Vector2.new(Position.X, Position.Y) + GuiService:GetGuiInset();
            local v598;

            if u216.Gui.IgnoreGuiInset then
                v598 = Vector2.zero;
            else
                v598 = GuiService:GetGuiInset();
            end;

            if (v597 - v598 + u216.Map.AbsolutePosition - Left).Magnitude <= 5 then
                u221 = nil;

                if u216 then
                    u216.Editor.Visible = false;
                    u216.NameBox:ReleaseFocus();
                end;
            end;
        end;
    end;
end);
UserInputService.TouchLongPress:Connect(function(p599, p600) -- Line: 1992
    -- upvalues: u216 (ref), u219 (copy), u393 (copy), GuiService (copy)
    if p600 ~= Enum.UserInputState.Begin or not (u216 and (u216.Map.Visible and not u219.On)) or (u216.Map:GetAttribute("Locked") == true or #p599 ~= 1) then
        return;
    end;

    local v601 = p599[1];
    local Vector3_new_ret = Vector3.new(v601.X, v601.Y, 0);
    local v602 = Vector2.new(Vector3_new_ret.X, Vector3_new_ret.Y) + GuiService:GetGuiInset();
    local v603;

    if u216.Gui.IgnoreGuiInset then
        v603 = Vector2.zero;
    else
        v603 = GuiService:GetGuiInset();
    end;

    u393(v602 - v603 + u216.Map.AbsolutePosition);
end);
UserInputService.TouchPinch:Connect(function(p604, p605, p606, p607) -- Line: 2001
    -- upvalues: u219 (copy), u218 (copy), u228 (ref)
    if p607 == Enum.UserInputState.Begin and (u219.Stroking and u219.Stroking) then
        u219.Stroking = false;
        u219.Input = nil;
        u219.Pad = false;

        if u218:End() then
            u228 = os.clock() + 2;
        end;
    end;
end);
RunService.RenderStepped:Connect(function(p608) -- Line: 2008
    -- upvalues: u216 (ref), u226 (copy), UserInputService (copy), u217 (copy), u264 (copy), u401 (copy), u414 (copy)
    if not u216 then
        return;
    end;

    if not u216.Map.Visible then
        if u226.Hidden or u226.Shown then
            if u226.Shown then
                u226.Shown.Visible = false;
                u226.Shown = nil;
            end;

            if u226.Hidden then
                u226.Hidden = false;
                UserInputService.MouseIconEnabled = UserInputService.MouseBehavior == Enum.MouseBehavior.Default;
            end;
        end;

        return;
    end;

    if u217.Follow and u216.Map:GetAttribute("Locked") ~= true then
        u264(p608);
    end;

    u401();
    u414(p608);
end);
MapUIStyle.ScaleChanged:Connect(function() -- Line: 2026
    -- upvalues: u216 (ref), u287 (copy)
    task.defer(function() -- Line: 2027
        -- upvalues: u216 (ref), u287 (ref)
        if u216 then
            u287();
        end;
    end);
end);
local u609 = nil;
MapRenderClient.InfoChanged:Connect(function() -- Line: 2037
    -- upvalues: MapRenderClient (copy), u609 (ref), u219 (copy), u218 (copy), u228 (ref), u220 (copy), u361 (ref), u216 (ref), u283 (copy), u320 (copy)
    local Info = MapRenderClient.Info;

    if Info then
        Info = Info.Seed;
    end;

    if Info and (u609 and Info ~= u609) then
        if u219.Stroking then
            u219.Stroking = false;
            u219.Input = nil;
            u219.Pad = false;

            if u218:End() then
                u228 = os.clock() + 2;
            end;
        end;

        u218:Clear();

        for i = #u220, 1, -1 do
            u361(u220[i]);
            local _ = i;
        end;
    end;

    u609 = Info or u609;

    if u216 then
        u283();
    end;

    u320();
end);
task.spawn(function() -- Line: 2055
    -- upvalues: u216 (ref), u217 (copy)
    while true do
        repeat
            task.wait(1);
        until u216 and (u216.Map.Visible and u217.SleepingBags);

        for i, v in u216.BagPins do
            v:Destroy();
            u216.BagPins[i] = nil;
        end;
    end;
end);

local function u613(p610: number) -- Line: 2066
    -- upvalues: u218 (copy), u229 (copy), MapDrawing (copy), Save (copy), u318 (copy)
    local Strokes = u218.Strokes;
    local Mirror = u229.Mirror;
    local math_min_ret = math.min(#Strokes, #Mirror);
    local v611 = 0;

    while v611 < math_min_ret and Strokes[v611 + 1] == Mirror[v611 + 1] do
        v611 = v611 + 1;
    end;

    local v612;

    if v611 < #Strokes then
        v612 = MapDrawing.EncodeStrokes(Strokes, v611 + 1, #Strokes);
    else
        v612 = nil;
    end;

    local os_clock_ret = os.clock();
    u229.Pending = {
        Mirror = table.clone(Strokes),
        At = os_clock_ret
    };
    u229.LastSent = os_clock_ret;
    Save:FireServer(p610, {
        B = u229.Rev,
        K = v611,
        A = v612,
        M = u318()
    });
end;

Save.OnClientEvent:Connect(function(p614, p615) -- Line: 2080
    -- upvalues: u229 (copy), u228 (ref)
    local Pending = u229.Pending;

    if not Pending or type(p614) ~= "number" then
        return;
    end;

    u229.Pending = nil;
    u229.Rev = p614;

    if p615 == true then
        u229.Mirror = Pending.Mirror;

        return;
    end;

    u229.Mirror = {};
    u228 = os.clock() + 2;
end);
task.spawn(function() -- Line: 2096
    -- upvalues: MapRenderClient (copy), Fetch (copy), u220 (copy), u385 (copy), u320 (copy), u218 (copy), u219 (copy), u229 (copy), u228 (ref), u613 (copy)
    while not (MapRenderClient.Info and MapRenderClient.Info.Seed) do
        task.wait(1);
    end;

    local v616 = false;
    local v617 = nil;
    local v618 = nil;
    local v619 = nil;
    local v620 = nil;

    for i = 1, 10 do
        v616, v617, v620, v618, v619 = pcall(Fetch.InvokeServer, Fetch);

        if v616 and type(v619) == "number" then
            break;
        end;

        task.wait(3);
        local _ = i;
    end;

    local Info = MapRenderClient.Info;

    if v616 and (Info and v617 == Info.Seed) then
        if type(v618) == "table" and #u220 == 0 then
            for _, v in v618 do
                if type(v) == "table" and (type(v.N) == "string" and (type(v.U) == "number" and type(v.V) == "number")) then
                    u385(v.U, v.V, v.N, tonumber(v.I) or 1, tonumber(v.C) or 1);
                end;
            end;

            u320();
        end;

        if type(v620) == "string" and (#u218.Strokes == 0 and not u219.Stroking) then
            local v621, v622, v623 = pcall(u218.Decode, u218, v620);

            if v621 and (v622 and type(v623) == "number") then
                u229.Mirror = table.move(u218.Strokes, 1, v623, 1, {});
            end;
        end;
    end;

    u229.Rev = (not v616 or type(v619) ~= "number") and 0 or v619;

    while true do
        task.wait(0.5);
        local Info2 = MapRenderClient.Info;
        local os_clock_ret = os.clock();

        if u229.Pending and os_clock_ret - u229.Pending.At > 8 then
            u229.Pending = nil;
            u228 = u228 or os_clock_ret;
        end;

        if u228 and (u228 <= os_clock_ret and not (u229.Pending or (os_clock_ret - u229.LastSent < 2 or (u219.Stroking or not (Info2 and Info2.Seed))))) then
            u228 = nil;
            u613(Info2.Seed);
        end;
    end;
end);

return u215;
-- [PATH] ReplicatedStorage / MapRender / MapDrawing @Type ModuleScript


local EncodingService = game:GetService("EncodingService");
local buffer_readu8 = buffer.readu8;
local buffer_writeu8 = buffer.writeu8;
local buffer_readu16 = buffer.readu16;
local buffer_writeu16 = buffer.writeu16;
local math_floor = math.floor;
local math_sqrt = math.sqrt;
local math_min = math.min;
local math_max = math.max;
local u1 = {};
u1.__index = u1;
u1.Palette = {
    Color3.fromRGB(20, 20, 22),
    Color3.fromRGB(245, 245, 245),
    Color3.fromRGB(230, 57, 53),
    Color3.fromRGB(245, 140, 40),
    Color3.fromRGB(250, 214, 50),
    Color3.fromRGB(96, 200, 80),
    Color3.fromRGB(40, 190, 200),
    Color3.fromRGB(45, 110, 230),
    Color3.fromRGB(150, 80, 220),
    Color3.fromRGB(240, 105, 180),
    Color3.fromRGB(140, 90, 50),
    Color3.fromRGB(128, 128, 128)
};
u1.Erase = 255;
u1.Radius = 0.7;
u1.MinRadius = 1;
u1.EraseRadius = 5;
u1.MinStep = 1;
u1.MaxPoints = 40000;
u1.UndoLimit = 25;
u1.Version = 1;

function u1.new(p2) -- Line: 62
    -- upvalues: u1 (copy)
    local u3 = setmetatable({
        Undoable = 0,
        Points = 0,
        Current = nil,
        Client = p2,
        Strokes = {},
        Undone = {}
    }, u1);
    p2.TileDrawn:Connect(function(p4) -- Line: 72
        -- upvalues: u3 (copy)
        u3:_reinkTiles({ p4 });
    end);

    return u3;
end;

function u1._surface(p5) -- Line: 80
    local Client = p5.Client;
    local Header = Client.Header;

    if not Header or #Client.Pages == 0 then
        return nil;
    end;

    local Scale = Client.Scale;
    local PageSize = Client.PageSize;

    return math.ceil(Header.Width / Scale), PageSize, math.ceil(Header.Width / (PageSize * Scale)), Scale;
end;

function u1._tilesIn(p6: table, p7: number, p8: number, p9: number, p10: number) -- Line: 93
    -- upvalues: math_floor (copy), math_max (copy), math_min (copy)
    local Header = p6.Client.Header;
    local v11 = Header.TileSize / p6.Client.Scale;
    local v12 = {};

    for i = math_max(0, (math_floor(p8 / v11))), math_min(Header.TilesY - 1, (math_floor(p10 / v11))) do
        local v13 = i;

        for i2 = math_max(0, (math_floor(p7 / v11))), math_min(Header.TilesX - 1, (math_floor(p9 / v11))) do
            v12[#v12 + 1] = v13 * Header.TilesX + i2 + 1;
            local _ = i2;
        end;
    end;

    return v12;
end;

function u1._tileRect(p14: table, p15: number) -- Line: 107
    -- upvalues: math_min (copy)
    local Header = p14.Client.Header;
    local Scale = p14.Client.Scale;
    local v16 = Header.TileSize / Scale;
    local v17 = (p15 - 1) % Header.TilesX;
    local v18 = (p15 - 1) // Header.TilesX;
    local math_ceil_ret = math.ceil(Header.Width / Scale);

    return v17 * v16, v18 * v16, math_min((v17 + 1) * v16, math_ceil_ret) - 1, math_min((v18 + 1) * v16, (math.ceil(Header.Height / Scale))) - 1;
end;

function u1._stamp(p19: table, p20: number, p21: number, p22: number, p23: number, p24: number, p25: number, p26: any) -- Line: 121
    -- upvalues: math_min (copy), math_floor (copy), math_max (copy)
    local v27, v28, v29 = p19:_surface();

    if not v27 then
        return;
    end;

    local v30 = p24 + 1;
    local v31 = math_max(0, (math_floor(math_min(p20, p22) - v30)));
    local v32 = math_max(0, (math_floor(math_min(p21, p23) - v30)));
    local v33 = math_min(v27 - 1, math_floor(math_max(p20, p22) + v30) + 1);
    local v34 = math_min(v27 - 1, math_floor(math_max(p21, p23) + v30) + 1);

    if p26 then
        v31 = math_max(v31, p26[1]);
        v32 = math_max(v32, p26[2]);
        v33 = math_min(v33, p26[3]);
        v34 = math_min(v34, p26[4]);
    end;

    if v33 < v31 or v34 < v32 then
        return;
    end;

    local Pages = p19.Client.Pages;

    for i = v32 // v28, v34 // v28 do
        local v35 = i;

        for i2 = v31 // v28, v33 // v28 do
            local v36 = Pages[v35 * v29 + i2 + 1];
            local v37;

            if v36 then
                local v38 = i2 * v28;
                local v39 = v35 * v28;
                p19:_stampPage(v36.Image, v38, v39, math_max(v31, v38), math_max(v32, v39), math_min(v33, v38 + v28 - 1), math_min(v34, v39 + v28 - 1), p20, p21, p22, p23, p24, p25);
                v37 = i2;
            else
                v37 = i2;
            end;
        end;
    end;
end;

function u1._stampPage(p40: table, p41: any, p42: number, p43: number, p44: number, p45: number, p46: number, p47: number, p48: number, p49: number, p50: number, p51: number, p52: number, p53: number) -- Line: 153
    -- upvalues: math_min (copy), u1 (copy), math_sqrt (copy), math_floor (copy), buffer_readu8 (copy), buffer_writeu8 (copy)
    local Size = p41.Size;
    local v54 = math_min(p46, p42 + Size.X - 1);
    local v55 = math_min(p47, p43 + Size.Y - 1);

    if v54 < p44 or v55 < p45 then
        return;
    end;

    local v56 = v54 - p44 + 1;
    local v57 = v55 - p45 + 1;
    local Vector2_new_ret = Vector2.new(p44 - p42, p45 - p43);
    local Vector2_new_ret2 = Vector2.new(v56, v57);
    local v58 = p41:ReadPixelsBuffer(Vector2_new_ret, Vector2_new_ret2);
    local v59 = p50 - p48;
    local v60 = p51 - p49;
    local v61 = v59 * v59 + v60 * v60;
    local v62 = p53 == u1.Erase;
    local v63, v64, v65;

    if v62 then
        v63 = 0;
        v64 = 0;
        v65 = 0;
    else
        local v66 = u1.Palette[p53] or u1.Palette[1];
        v63 = v66.R * 255;
        v64 = v66.G * 255;
        v65 = v66.B * 255;
    end;

    local Client = p40.Client;
    local v67 = v62 and (Client.Header.TileSize / Client.Scale or 0) or 0;
    local TilesX = Client.Header.TilesX;
    local v68 = nil;
    local v69 = nil;
    local v70 = 0;
    local v71 = 0;
    local v72 = 0;
    local v73 = 0;

    for i = 0, v57 - 1 do
        local v74 = p45 + i + 0.5;
        local v75 = i;

        for i2 = 0, v56 - 1 do
            local v76 = p44 + i2 + 0.5;
            local v77;

            if v61 > 0 then
                local v78 = ((v76 - p48) * v59 + (v74 - p49) * v60) / v61;
                v77 = v78 < 0 and 0 or (v78 > 1 and 1 or v78);
            else
                v77 = 0;
            end;

            local v79 = v76 - p48 - v59 * v77;
            local v80 = v74 - p49 - v60 * v77;
            local v81 = p52 + 0.5 - math_sqrt(v79 * v79 + v80 * v80);
            local v82;

            if v81 > 0 then
                local v83 = v81 > 1 and 1 or v81;
                local v84 = (v75 * v56 + i2) * 4;
                local v85, v86, v87, v88;

                if v62 then
                    local v89 = p44 + i2;
                    local v90 = p45 + v75;
                    v85 = math_floor(v90 / v67) * TilesX + math_floor(v89 / v67) + 1;

                    if v85 == v68 then
                        v85 = v68;
                    else
                        v69, v72, v71, v73, v70 = Client.TileOriginal(v85);
                    end;

                    if v69 and (v90 - v70 < v71 and v89 - v73 < v72) then
                        local v91 = ((v90 - v70) * v72 + (v89 - v73)) * 4;
                        v86 = buffer_readu8(v69, v91);
                        v87 = buffer_readu8(v69, v91 + 1);
                        v88 = buffer_readu8(v69, v91 + 2);
                    else
                        v86 = buffer_readu8(v58, v84);
                        v87 = buffer_readu8(v58, v84 + 1);
                        v88 = buffer_readu8(v58, v84 + 2);
                    end;
                else
                    v86 = v63;
                    v85 = v68;
                    v88 = v65;
                    v87 = v64;
                end;

                buffer_writeu8(v58, v84, (math_floor(buffer_readu8(v58, v84) + (v86 - buffer_readu8(v58, v84)) * v83 + 0.5)));
                buffer_writeu8(v58, v84 + 1, (math_floor(buffer_readu8(v58, v84 + 1) + (v87 - buffer_readu8(v58, v84 + 1)) * v83 + 0.5)));
                buffer_writeu8(v58, v84 + 2, (math_floor(buffer_readu8(v58, v84 + 2) + (v88 - buffer_readu8(v58, v84 + 2)) * v83 + 0.5)));
                v82 = i2;
                v68 = v85;
            else
                v82 = i2;
            end;
        end;
    end;

    p41:WritePixelsBuffer(Vector2_new_ret, Vector2_new_ret2, v58);
end;

local function radiusOf(p92, p93) -- Line: 216
    -- upvalues: u1 (copy), math_max (copy)
    return math_max(p92.R * p93 / 2048, u1.MinRadius);
end;

function u1._bounds(p94, p95) -- Line: 221
    -- upvalues: math_min (copy), math_max (copy), u1 (copy)
    local v96 = p94:_surface();
    local P = p95.P;
    local v97 = (1 / 0);
    local v98 = (-1 / 0);
    local v99 = (1 / 0);
    local v100 = (-1 / 0);

    for i = 1, #P, 2 do
        v97 = math_min(v97, P[i]);
        v98 = math_max(v98, P[i]);
        v99 = math_min(v99, P[i + 1]);
        v100 = math_max(v100, P[i + 1]);
        local _ = i;
    end;

    local v101 = v96 / 65535;
    local v102 = math_max(p95.R * v96 / 2048, u1.MinRadius) + 2;

    return v97 * v101 - v102, v99 * v101 - v102, v98 * v101 + v102, v100 * v101 + v102;
end;

function u1._ink(p103, p104) -- Line: 235
    -- upvalues: u1 (copy), math_max (copy)
    local v105 = p103:_surface();

    if not v105 then
        return;
    end;

    local v106 = v105 / 65535;
    local v107 = 0;

    for _, v in p103.Strokes do
        local v108, v109, v110, v111 = p103:_bounds(v);

        if not (p104 and (v110 < p104[1] or (v111 < p104[2] or (p104[3] < v108 or p104[4] < v109)))) then
            local P = v.P;
            local v112 = math_max(v.R * v105 / 2048, u1.MinRadius);

            if #P == 2 then
                p103:_stamp(P[1] * v106, P[2] * v106, P[1] * v106, P[2] * v106, v112, v.C, p104);
            end;

            local v113 = v;

            for i = 3, #P, 2 do
                p103:_stamp(P[i - 2] * v106, P[i - 1] * v106, P[i] * v106, P[i + 1] * v106, v112, v113.C, p104);
                v107 = v107 + 1;
                local v114;

                if v107 % 400 == 0 then
                    task.wait();
                    v114 = i;
                else
                    v114 = i;
                end;
            end;
        end;
    end;
end;

function u1._reinkTiles(p115: table, p116: table) -- Line: 262
    if #p115.Strokes == 0 or not p115:_surface() then
        return;
    end;

    for _, v in p116 do
        local v117, v118, v119, v120 = p115:_tileRect(v);
        p115:_ink({
            v117,
            v118,
            v119,
            v120
        });
    end;
end;

function u1._restore(p121: table, p122: number, p123: number, p124: number, p125: number) -- Line: 273
    if not p121:_surface() then
        return;
    end;

    local v126 = p121:_tilesIn(p122, p123, p124, p125);

    for _, v in v126 do
        p121.Client.RestoreTile(v);
    end;

    p121:_reinkTiles(v126);
end;

function u1.Begin(p127: table, p128: number, p129: number, p130: number) -- Line: 286
    -- upvalues: u1 (copy), math_floor (copy), math_max (copy)
    local v131 = p127:_surface();

    if not v131 or p127.Points >= u1.MaxPoints then
        return false;
    end;

    local v132 = p130 == u1.Erase and u1.EraseRadius or u1.Radius;
    local v133 = math_floor(math.clamp(p128, 0, 1) * 65535 + 0.5);
    local v134 = math_floor(math.clamp(p129, 0, 1) * 65535 + 0.5);
    local v135 = {
        C = p130,
        R = v132,
        P = { v133, v134 }
    };
    p127.Current = v135;
    p127.Points = p127.Points + 1;
    local v136 = v133 / 65535 * v131;
    local v137 = v134 / 65535 * v131;
    p127:_stamp(v136, v137, v136, v137, math_max(v135.R * v131 / 2048, u1.MinRadius), p130);

    return true;
end;

function u1.Extend(p138: table, p139: number, p140: number) -- Line: 302
    -- upvalues: u1 (copy), math_floor (copy), math_max (copy)
    local Current = p138.Current;
    local v141 = p138:_surface();

    if not (Current and (v141 and p138.Points < u1.MaxPoints)) then
        return;
    end;

    local P = Current.P;
    local v142 = P[#P - 1];
    local v143 = P[#P];
    local v144 = math_floor(math.clamp(p139, 0, 1) * 65535 + 0.5);
    local v145 = math_floor(math.clamp(p140, 0, 1) * 65535 + 0.5);
    local v146 = u1.MinStep / 2048 * 65535;
    local v147 = v144 - v142;
    local v148 = v145 - v143;

    if v147 * v147 + v148 * v148 < v146 * v146 then
        return;
    end;

    P[#P + 1] = v144;
    P[#P + 1] = v145;
    p138.Points = p138.Points + 1;
    local v149 = v141 / 65535;
    p138:_stamp(v142 * v149, v143 * v149, v144 * v149, v145 * v149, math_max(Current.R * v141 / 2048, u1.MinRadius), Current.C);
end;

function u1.End(p150) -- Line: 324
    -- upvalues: u1 (copy), math_min (copy)
    local Current = p150.Current;
    p150.Current = nil;

    if not Current then
        return false;
    end;

    p150.Strokes[#p150.Strokes + 1] = Current;
    table.clear(p150.Undone);
    p150.Undoable = math_min(p150.Undoable + 1, u1.UndoLimit);

    return true;
end;

function u1.Undo(p151) -- Line: 338
    if #p151.Strokes == 0 or p151.Undoable <= 0 then
        return false;
    end;

    p151.Undoable = p151.Undoable - 1;
    local table_remove_ret = table.remove(p151.Strokes);
    p151.Undone[#p151.Undone + 1] = table_remove_ret;
    p151.Points = p151.Points - #table_remove_ret.P // 2;

    if p151:_surface() then
        p151:_restore(p151:_bounds(table_remove_ret));
    end;

    return true;
end;

function u1.Redo(p152) -- Line: 354
    -- upvalues: u1 (copy), math_min (copy), math_max (copy)
    local v153 = p152.Undone[#p152.Undone];

    if not v153 or p152.Points + #v153.P // 2 > u1.MaxPoints then
        return false;
    end;

    table.remove(p152.Undone);
    p152.Strokes[#p152.Strokes + 1] = v153;
    p152.Points = p152.Points + #v153.P // 2;
    p152.Undoable = math_min(p152.Undoable + 1, u1.UndoLimit);
    local v154 = p152:_surface();

    if v154 then
        local v155 = v154 / 65535;
        local P = v153.P;
        local v156 = math_max(v153.R * v154 / 2048, u1.MinRadius);

        if #P == 2 then
            p152:_stamp(P[1] * v155, P[2] * v155, P[1] * v155, P[2] * v155, v156, v153.C);
        end;

        for i = 3, #P, 2 do
            p152:_stamp(P[i - 2] * v155, P[i - 1] * v155, P[i] * v155, P[i + 1] * v155, v156, v153.C);
            local _ = i;
        end;
    end;

    return true;
end;

function u1.Clear(p157) -- Line: 379
    local Strokes = p157.Strokes;
    p157.Strokes = {};
    p157.Points = 0;
    p157.Current = nil;
    table.clear(p157.Undone);
    p157.Undoable = 0;

    if p157:_surface() then
        for _, v in Strokes do
            p157:_restore(p157:_bounds(v));
        end;
    end;
end;

function u1.Encode(p158) -- Line: 396
    -- upvalues: buffer_writeu8 (copy), math_min (copy), buffer_writeu16 (copy), math_floor (copy), EncodingService (copy)
    local v159 = 3;

    for _, v in p158.Strokes do
        v159 = v159 + (#v.P * 2 + 4);
    end;

    local buffer_create_ret = buffer.create(v159);
    buffer_writeu8(buffer_create_ret, 0, 1);
    buffer_writeu16(buffer_create_ret, 1, (math_min(#p158.Strokes, 65535)));
    local v160 = 3;

    for i, v in p158.Strokes do
        if i > 65535 then
            break;
        end;

        buffer_writeu8(buffer_create_ret, v160, v.C);
        local v161 = math_floor(v.R * 16 + 0.5);
        buffer_writeu8(buffer_create_ret, v160 + 1, (math.clamp(v161, 1, 255)));
        buffer_writeu16(buffer_create_ret, v160 + 2, #v.P // 2);
        v160 = v160 + 4;

        for _, v2 in v.P do
            buffer_writeu16(buffer_create_ret, v160, v2);
            v160 = v160 + 2;
        end;
    end;

    return buffer.tostring(EncodingService:Base64Encode(buffer_create_ret));
end;

function u1.Decode(p162: table, u163: string) -- Line: 424
    -- upvalues: EncodingService (copy), buffer_readu8 (copy), buffer_readu16 (copy), u1 (copy)
    local success, result = pcall(function() -- Line: 425
        -- upvalues: EncodingService (ref), u163 (copy)
        return EncodingService:Base64Decode(buffer.fromstring(u163));
    end);

    if not (success and (buffer.len(result) >= 3 and buffer_readu8(result, 0) == 1)) then
        return false;
    end;

    local buffer_len_ret = buffer.len(result);
    local v164 = 3;
    local v165 = {};
    local v166 = 0;

    for i = 1, buffer_readu16(result, 1) do
        if buffer_len_ret < v164 + 4 then
            return false;
        end;

        local v167 = buffer_readu8(result, v164);
        local v168 = buffer_readu8(result, v164 + 1) / 16;
        local v169 = buffer_readu16(result, v164 + 2);
        v164 = v164 + 4;

        if buffer_len_ret < v164 + v169 * 4 then
            return false;
        end;

        local table_create_ret = table.create(v169 * 2);
        local _ = i;

        for i2 = 1, v169 * 2 do
            table_create_ret[i2] = buffer_readu16(result, v164);
            v164 = v164 + 2;
            local _ = i2;
        end;

        if v169 > 0 and (v167 == u1.Erase or u1.Palette[v167]) then
            v165[#v165 + 1] = {
                C = v167,
                R = v168,
                P = table_create_ret
            };
            v166 = v166 + v169;
        end;
    end;

    p162.Strokes = v165;
    p162.Points = v166;
    p162.Current = nil;
    table.clear(p162.Undone);
    p162.Undoable = 0;
    p162:_ink(nil);

    return true, #v165;
end;

function u1.EncodeStrokes(p170: any, p171: number, p172: number) -- Line: 466
    -- upvalues: buffer_writeu8 (copy), math_floor (copy), buffer_writeu16 (copy)
    local v173 = 0;

    for i = p171, p172 do
        v173 = v173 + (#p170[i].P * 2 + 4);
        local _ = i;
    end;

    local buffer_create_ret = buffer.create(v173);
    local v174 = 0;

    for i = p171, p172 do
        local v175 = p170[i];
        buffer_writeu8(buffer_create_ret, v174, v175.C);
        local v176 = math_floor(v175.R * 16 + 0.5);
        buffer_writeu8(buffer_create_ret, v174 + 1, (math.clamp(v176, 1, 255)));
        buffer_writeu16(buffer_create_ret, v174 + 2, #v175.P // 2);
        v174 = v174 + 4;
        local _ = i;

        for _, v in v175.P do
            buffer_writeu16(buffer_create_ret, v174, v);
            v174 = v174 + 2;
        end;
    end;

    return buffer_create_ret;
end;

function u1.CheckStrokes(p177: buffer, p178: number) -- Line: 493
    -- upvalues: u1 (copy), buffer_readu8 (copy), buffer_readu16 (copy)
    local buffer_len_ret = buffer.len(p177);
    local v179 = #u1.Palette;
    local v180 = 0;
    local v181 = 0;
    local v182 = {};
    local v183 = {};

    while v180 < buffer_len_ret do
        if buffer_len_ret < v180 + 4 then
            return nil;
        end;

        local v184 = buffer_readu8(p177, v180);
        local v185 = buffer_readu8(p177, v180 + 1);
        local v186 = buffer_readu16(p177, v180 + 2);

        if v186 == 0 or (v185 == 0 or v184 ~= u1.Erase and (v184 < 1 or v184 > v179)) then
            return nil;
        end;

        v181 = v181 + v186;

        if p178 < v181 then
            return nil;
        end;

        v180 = v180 + (v186 * 4 + 4);

        if buffer_len_ret < v180 then
            return nil;
        end;

        v182[#v182 + 1] = v180;
        v183[#v183 + 1] = v186;
    end;

    return v182, v183;
end;

return u1;
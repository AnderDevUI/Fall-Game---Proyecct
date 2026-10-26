-- [PATH] ReplicatedStorage / MapRender / MapImageCodec @Type ModuleScript


local u1 = {
    Magic = "MRD1",
    FormatVersion = 3
};
local buffer_readu8 = buffer.readu8;
local buffer_writeu8 = buffer.writeu8;
local buffer_readi16 = buffer.readi16;
local buffer_writei16 = buffer.writei16;

function u1.TileRect(p2, p3) -- Line: 64
    local TileSize = p2.TileSize;
    local v4 = (p3 - 1) % p2.TilesX * TileSize;
    local v5 = (p3 - 1) // p2.TilesX * TileSize;

    return v4, v5, math.min(TileSize, p2.Width - v4), math.min(TileSize, p2.Height - v5);
end;

function u1.MakeHeader(p6, p7, p8, p9, p10, p11, p12) -- Line: 74
    -- upvalues: u1 (copy)
    local v13 = p9 or {};

    return {
        Width = p6,
        Height = p7,
        TileSize = p8,
        TilesX = math.ceil(p6 / p8),
        TilesY = math.ceil(p7 / p8),
        Quantize = v13.Quantize or 1,
        LumaTolerance = v13.LumaTolerance or 0,
        ChromaScale = v13.ChromaScale or 1,
        ChromaTolerance = v13.ChromaTolerance or 0,
        OriginX = p10,
        OriginZ = p11,
        PixelSize = p12,
        FormatVersion = u1.FormatVersion
    };
end;

local function isExact(p14) -- Line: 88
    local v15;

    if p14.LumaTolerance == 0 and p14.ChromaScale == 1 then
        v15 = p14.ChromaTolerance == 0;
    else
        v15 = false;
    end;

    return v15;
end;

local function med(p16, p17, p18) -- Line: 94
    if p16 <= p18 and p17 <= p18 then
        if p16 < p17 then
            p17 = p16 or p17;
        end;

        return p17;
    end;

    if p18 > p16 or p18 > p17 then
        return p16 + p17 - p18;
    end;

    if p17 < p16 then
        p17 = p16 or p17;
    end;

    return p17;
end;

local function toSteps(p19, p20, p21) -- Line: 104
    if p19 >= 0 then
        return (p19 + p20) // p21;
    end;

    return -((-p19 + p20) // p21);
end;

local function fromByte(p22) -- Line: 111
    if p22 >= 128 then
        p22 = p22 - 256 or p22;
    end;

    return p22;
end;

local function activity(p23, p24, p25, p26) -- Line: 117
    local v27 = p23 - p25;

    if v27 < 0 then
        v27 = -v27;
    end;

    local v28 = p24 - p25;

    if v28 < 0 then
        v28 = -v28;
    end;

    local v29 = p26 - p24;

    if v29 < 0 then
        v29 = -v29;
    end;

    return v27 + v28 + v29;
end;

local function encodeExact(p30, p31, p32, p33, p34, p35, p36) -- Line: 130
    -- upvalues: buffer_readu8 (copy), buffer_writeu8 (copy)
    local v37 = p34 * p35;
    local buffer_create_ret = buffer.create(v37 * 3);

    for i = 0, p35 - 1 do
        local v38 = ((p33 + i) * p31 + p32) * 4;
        local v39 = i * p34;
        local _ = i;

        for i2 = 0, p34 - 1 do
            local v40 = buffer_readu8(p30, v38);
            local v41 = buffer_readu8(p30, v38 + 1);
            local v42 = buffer_readu8(p30, v38 + 2);

            if p36 > 1 then
                v40 = v40 // p36;
                v41 = v41 // p36;
                v42 = v42 // p36;
            end;

            buffer_writeu8(buffer_create_ret, v39, v41);
            buffer_writeu8(buffer_create_ret, v37 + v39, (v40 - v41 + 128) % 256);
            buffer_writeu8(buffer_create_ret, 2 * v37 + v39, (v42 - v41 + 128) % 256);
            v38 = v38 + 4;
            v39 = v39 + 1;
            local _ = i2;
        end;
    end;

    for i = 0, 2 do
        local v43 = i * v37;
        local v44 = i == 0 and 0 or 128;
        local _ = i;

        for i2 = p35 - 1, 0, -1 do
            local v45 = v43 + i2 * p34;
            local v46 = i2;

            for i3 = p34 - 1, 0, -1 do
                local v47 = v45 + i3;
                local v48;

                if v46 == 0 then
                    v48 = i3 == 0 and v44 and v44 or buffer_readu8(buffer_create_ret, v47 - 1);
                elseif i3 == 0 then
                    v48 = buffer_readu8(buffer_create_ret, v47 - p34);
                else
                    local v49 = buffer_readu8(buffer_create_ret, v47 - 1);
                    v48 = buffer_readu8(buffer_create_ret, v47 - p34);
                    local v50 = buffer_readu8(buffer_create_ret, v47 - p34 - 1);

                    if v49 <= v50 and v48 <= v50 then
                        if v49 < v48 then
                            v48 = v49 or v48;
                        end;
                    elseif v50 <= v49 and v50 <= v48 then
                        if v48 < v49 then
                            v48 = v49 or v48;
                        end;
                    else
                        v48 = v49 + v48 - v50;
                    end;
                end;

                buffer_writeu8(buffer_create_ret, v47, (buffer_readu8(buffer_create_ret, v47) - v48) % 256);
                local _ = i3;
            end;
        end;
    end;

    return buffer_create_ret;
end;

local function decodeExact(p51, p52, p53, p54, p55) -- Line: 172
    -- upvalues: buffer_readu8 (copy), buffer_writeu8 (copy)
    local v56 = p52 * p53;

    for i = 0, 2 do
        local v57 = i * v56;
        local v58 = i == 0 and 0 or 128;
        local _ = i;

        for i2 = 0, p53 - 1 do
            local v59 = v57 + i2 * p52;
            local v60 = i2;

            for i3 = 0, p52 - 1 do
                local v61 = v59 + i3;
                local v62;

                if v60 == 0 then
                    v62 = i3 == 0 and v58 and v58 or buffer_readu8(p51, v61 - 1);
                elseif i3 == 0 then
                    v62 = buffer_readu8(p51, v61 - p52);
                else
                    local v63 = buffer_readu8(p51, v61 - 1);
                    v62 = buffer_readu8(p51, v61 - p52);
                    local v64 = buffer_readu8(p51, v61 - p52 - 1);

                    if v63 <= v64 and v62 <= v64 then
                        if v63 < v62 then
                            v62 = v63 or v62;
                        end;
                    elseif v64 <= v63 and v64 <= v62 then
                        if v62 < v63 then
                            v62 = v63 or v62;
                        end;
                    else
                        v62 = v63 + v62 - v64;
                    end;
                end;

                buffer_writeu8(p51, v61, (buffer_readu8(p51, v61) + v62) % 256);
                local _ = i3;
            end;
        end;
    end;

    local v65 = p54 // 2;

    for i = 0, v56 - 1 do
        local v66 = buffer_readu8(p51, i);
        local v67 = (buffer_readu8(p51, v56 + i) + v66 - 128) % 256;
        local v68 = (buffer_readu8(p51, 2 * v56 + i) + v66 - 128) % 256;

        if p54 > 1 then
            v67 = math.min(255, v67 * p54 + v65);
            v66 = math.min(255, v66 * p54 + v65);
            v68 = math.min(255, v68 * p54 + v65);
        end;

        local v69 = i * 4;
        buffer_writeu8(p55, v69, v67);
        buffer_writeu8(p55, v69 + 1, v66);
        buffer_writeu8(p55, v69 + 2, v68);
        buffer_writeu8(p55, v69 + 3, 255);
        local _ = i;
    end;

    return p55;
end;

local function encodeChroma(p70, p71, p72, p73, p74, p75, p76) -- Line: 217
    -- upvalues: buffer_readi16 (copy), buffer_writeu8 (copy), buffer_writei16 (copy)
    local _ = 2 * p73 + 1;

    for i = 0, p72 - 1 do
        local v77 = i;

        for i2 = 0, p71 - 1 do
            local v78 = v77 * p71 + i2;
            local v79 = 0;
            local v80;

            if v77 == 0 then
                v80 = i2 == 0 and 0 or buffer_readi16(p76, (v78 - 1) * 2);
            elseif i2 == 0 then
                v80 = buffer_readi16(p76, (v78 - p71) * 2);
            else
                local v81 = buffer_readi16(p76, (v78 - 1) * 2);
                local v82 = buffer_readi16(p76, (v78 - p71) * 2);
                local v83 = buffer_readi16(p76, (v78 - p71 - 1) * 2);
                local v84;

                if i2 < p71 - 1 then
                    v84 = buffer_readi16(p76, (v78 - p71 + 1) * 2) or v82;
                else
                    v84 = v82;
                end;

                if v81 <= v83 and v82 <= v83 then
                    v80 = v81 < v82 and v81 and v81 or v82;
                elseif v83 <= v81 and v83 <= v82 then
                    v80 = v82 < v81 and v81 and v81 or v82;
                else
                    v80 = v81 + v82 - v83;
                end;

                local v85 = v81 - v83;

                if v85 < 0 then
                    v85 = -v85;
                end;

                local v86 = v82 - v83;

                if v86 < 0 then
                    v86 = -v86;
                end;

                local v87 = v84 - v82;

                if v87 < 0 then
                    v87 = -v87;
                end;

                if v85 + v86 + v87 > 3 then
                    v79 = p73;
                end;
            end;

            local v88 = buffer_readi16(p70, v78 * 2);
            local v89 = v79 == 0 and v88 - v80;

            if not v89 then
                local v90 = v88 - v80;
                local v91 = v79 * 2 + 1;

                if v90 >= 0 then
                    v89 = (v90 + v79) // v91;
                else
                    v89 = -((-v90 + v79) // v91);
                end;
            end;

            local v92;

            if v89 > 127 or v89 < -127 then
                buffer_writeu8(p74, p75, 128);
                buffer_writei16(p74, p75 + 1, v88);
                buffer_writei16(p76, v78 * 2, v88);
                p75 = p75 + 3;
                v92 = i2;
            else
                buffer_writeu8(p74, p75, v89 % 256);
                buffer_writei16(p76, v78 * 2, (math.clamp(v80 + v89 * (v79 * 2 + 1), -255, 255)));
                p75 = p75 + 1;
                v92 = i2;
            end;
        end;
    end;

    return p75;
end;

local function decodeChroma(p93, p94, p95, p96, p97, p98) -- Line: 252
    -- upvalues: buffer_readi16 (copy), buffer_readu8 (copy), buffer_writei16 (copy)
    for i = 0, p96 - 1 do
        local v99 = i;

        for i2 = 0, p95 - 1 do
            local v100 = v99 * p95 + i2;
            local v101 = 0;
            local v102;

            if v99 == 0 then
                v102 = i2 == 0 and 0 or buffer_readi16(p98, (v100 - 1) * 2);
            elseif i2 == 0 then
                v102 = buffer_readi16(p98, (v100 - p95) * 2);
            else
                local v103 = buffer_readi16(p98, (v100 - 1) * 2);
                local v104 = buffer_readi16(p98, (v100 - p95) * 2);
                local v105 = buffer_readi16(p98, (v100 - p95 - 1) * 2);
                local v106;

                if i2 < p95 - 1 then
                    v106 = buffer_readi16(p98, (v100 - p95 + 1) * 2) or v104;
                else
                    v106 = v104;
                end;

                if v103 <= v105 and v104 <= v105 then
                    v102 = v103 < v104 and v103 and v103 or v104;
                elseif v105 <= v103 and v105 <= v104 then
                    v102 = v104 < v103 and v103 and v103 or v104;
                else
                    v102 = v103 + v104 - v105;
                end;

                local v107 = v103 - v105;

                if v107 < 0 then
                    v107 = -v107;
                end;

                local v108 = v104 - v105;

                if v108 < 0 then
                    v108 = -v108;
                end;

                local v109 = v106 - v104;

                if v109 < 0 then
                    v109 = -v109;
                end;

                if v107 + v108 + v109 > 3 then
                    v101 = p97;
                end;
            end;

            local v110 = buffer_readu8(p93, p94);
            local v111;

            if v110 == 128 then
                buffer_writei16(p98, v100 * 2, (buffer_readi16(p93, p94 + 1)));
                p94 = p94 + 3;
                v111 = i2;
            else
                if v110 >= 128 then
                    v110 = v110 - 256 or v110;
                end;

                buffer_writei16(p98, v100 * 2, (math.clamp(v102 + v110 * (v101 * 2 + 1), -255, 255)));
                p94 = p94 + 1;
                v111 = i2;
            end;
        end;
    end;

    return p94;
end;

local function encodeNear(p112, p113, p114, p115, p116, p117, p118) -- Line: 282
    -- upvalues: buffer_readu8 (copy), buffer_writeu8 (copy), buffer_writei16 (copy), encodeChroma (copy)
    local v119 = p116 * p117;
    local ChromaScale = p118.ChromaScale;
    local math_ceil_ret = math.ceil(p116 / ChromaScale);
    local math_ceil_ret2 = math.ceil(p117 / ChromaScale);
    local v120 = math_ceil_ret * math_ceil_ret2;
    local buffer_create_ret = buffer.create(v119 + v120 * 6);
    local LumaTolerance = p118.LumaTolerance;
    local buffer_create_ret2 = buffer.create(v119);

    for i = 0, p117 - 1 do
        local v121 = ((p115 + i) * p113 + p114) * 4 + 1;
        local v122 = i;

        for i2 = 0, p116 - 1 do
            local v123 = v122 * p116 + i2;
            local v124 = 0;
            local v125;

            if v122 == 0 then
                v125 = i2 == 0 and 0 or buffer_readu8(buffer_create_ret2, v123 - 1);
            elseif i2 == 0 then
                v125 = buffer_readu8(buffer_create_ret2, v123 - p116);
            else
                local v126 = buffer_readu8(buffer_create_ret2, v123 - 1);
                local v127 = buffer_readu8(buffer_create_ret2, v123 - p116);
                local v128 = buffer_readu8(buffer_create_ret2, v123 - p116 - 1);
                local v129;

                if i2 < p116 - 1 then
                    v129 = buffer_readu8(buffer_create_ret2, v123 - p116 + 1) or v127;
                else
                    v129 = v127;
                end;

                if v126 <= v128 and v127 <= v128 then
                    v125 = v126 < v127 and v126 and v126 or v127;
                elseif v128 <= v126 and v128 <= v127 then
                    v125 = v127 < v126 and v126 and v126 or v127;
                else
                    v125 = v126 + v127 - v128;
                end;

                local v130 = v126 - v128;

                if v130 < 0 then
                    v130 = -v130;
                end;

                local v131 = v127 - v128;

                if v131 < 0 then
                    v131 = -v131;
                end;

                local v132 = v129 - v127;

                if v132 < 0 then
                    v132 = -v132;
                end;

                if v130 + v131 + v132 > 3 then
                    v124 = LumaTolerance;
                end;
            end;

            local v133 = buffer_readu8(p112, v121);

            if v124 == 0 then
                buffer_writeu8(buffer_create_ret2, v123, v133);
                buffer_writeu8(buffer_create_ret, v123, (v133 - v125) % 256);
            else
                local v134 = v133 - v125;
                local v135 = v124 * 2 + 1;
                local v136;

                if v134 >= 0 then
                    v136 = (v134 + v124) // v135;
                else
                    v136 = -((-v134 + v124) // v135);
                end;

                buffer_writeu8(buffer_create_ret2, v123, (math.clamp(v125 + v136 * (v124 * 2 + 1), 0, 255)));
                buffer_writeu8(buffer_create_ret, v123, v136 % 256);
            end;

            v121 = v121 + 4;
            local _ = i2;
        end;
    end;

    local buffer_create_ret3 = buffer.create(v120 * 2);
    local buffer_create_ret4 = buffer.create(v120 * 2);

    for i = 0, 2, 2 do
        local v137 = i;

        for i2 = 0, math_ceil_ret2 - 1 do
            local v138 = i2 * ChromaScale;
            local v139 = math.min(p117, i2 * ChromaScale + ChromaScale) - 1;
            local v140 = i2;

            for i3 = 0, math_ceil_ret - 1 do
                local v141 = i3 * ChromaScale;
                local v142 = math.min(p116, i3 * ChromaScale + ChromaScale) - 1;
                local v143 = 0;
                local v144 = 0;

                for i4 = v138, v139 do
                    local v145 = ((p115 + i4) * p113 + p114 + v141) * 4 + v137;
                    local v146 = i4 * p116 + v141;
                    local _ = i4;

                    for i5 = v141, v142 do
                        v144 = v144 + (buffer_readu8(p112, v145) - buffer_readu8(buffer_create_ret2, v146));
                        v143 = v143 + 1;
                        v145 = v145 + 4;
                        v146 = v146 + 1;
                        local _ = i5;
                    end;
                end;

                buffer_writei16(buffer_create_ret3, (v140 * math_ceil_ret + i3) * 2, (math.floor(v144 / v143 + 0.5)));
            end;
        end;

        v119 = encodeChroma(buffer_create_ret3, math_ceil_ret, math_ceil_ret2, p118.ChromaTolerance, buffer_create_ret, v119, buffer_create_ret4);
    end;

    local buffer_create_ret5 = buffer.create(v119);
    buffer.copy(buffer_create_ret5, 0, buffer_create_ret, 0, v119);

    return buffer_create_ret5;
end;

local function decodeNear(p147, p148, p149, p150, p151) -- Line: 351
    -- upvalues: buffer_readu8 (copy), buffer_writeu8 (copy), decodeChroma (copy), buffer_readi16 (copy)
    local ChromaScale = p150.ChromaScale;
    local math_ceil_ret = math.ceil(p148 / ChromaScale);
    local math_ceil_ret2 = math.ceil(p149 / ChromaScale);
    local v152 = math_ceil_ret * math_ceil_ret2;
    local LumaTolerance = p150.LumaTolerance;
    local v153 = p148 * 4;

    for i = 0, p149 - 1 do
        local v154 = i;

        for i2 = 0, p148 - 1 do
            local v155 = v154 * p148 + i2;
            local v156 = v155 * 4 + 1;
            local v157 = 0;
            local v158;

            if v154 == 0 then
                v158 = i2 == 0 and 0 or buffer_readu8(p151, v156 - 4);
            elseif i2 == 0 then
                v158 = buffer_readu8(p151, v156 - v153);
            else
                local v159 = buffer_readu8(p151, v156 - 4);
                local v160 = buffer_readu8(p151, v156 - v153);
                local v161 = buffer_readu8(p151, v156 - v153 - 4);
                local v162;

                if i2 < p148 - 1 then
                    v162 = buffer_readu8(p151, v156 - v153 + 4) or v160;
                else
                    v162 = v160;
                end;

                if v159 <= v161 and v160 <= v161 then
                    v158 = v159 < v160 and v159 and v159 or v160;
                elseif v161 <= v159 and v161 <= v160 then
                    v158 = v160 < v159 and v159 and v159 or v160;
                else
                    v158 = v159 + v160 - v161;
                end;

                local v163 = v159 - v161;

                if v163 < 0 then
                    v163 = -v163;
                end;

                local v164 = v160 - v161;

                if v164 < 0 then
                    v164 = -v164;
                end;

                local v165 = v162 - v160;

                if v165 < 0 then
                    v165 = -v165;
                end;

                if v163 + v164 + v165 > 3 then
                    v157 = LumaTolerance;
                end;
            end;

            local v166 = buffer_readu8(p147, v155);
            local v167;

            if v157 == 0 then
                buffer_writeu8(p151, v156, (v158 + v166) % 256);
                v167 = i2;
            else
                if v166 >= 128 then
                    v166 = v166 - 256 or v166;
                end;

                buffer_writeu8(p151, v156, (math.clamp(v158 + v166 * (v157 * 2 + 1), 0, 255)));
                v167 = i2;
            end;
        end;
    end;

    local buffer_create_ret = buffer.create(v152 * 2);
    local buffer_create_ret2 = buffer.create(v152 * 2);
    decodeChroma(p147, decodeChroma(p147, p148 * p149, math_ceil_ret, math_ceil_ret2, p150.ChromaTolerance, buffer_create_ret), math_ceil_ret, math_ceil_ret2, p150.ChromaTolerance, buffer_create_ret2);

    for i = 0, p149 - 1 do
        local v168 = i // ChromaScale * math_ceil_ret;
        local v169 = i;

        for i2 = 0, p148 - 1 do
            local v170 = (v169 * p148 + i2) * 4;
            local v171 = (v168 + i2 // ChromaScale) * 2;
            local v172 = buffer_readu8(p151, v170 + 1);
            local v173 = v172 + buffer_readi16(buffer_create_ret, v171);
            buffer_writeu8(p151, v170, (math.clamp(v173, 0, 255)));
            local v174 = v172 + buffer_readi16(buffer_create_ret2, v171);
            buffer_writeu8(p151, v170 + 2, (math.clamp(v174, 0, 255)));
            buffer_writeu8(p151, v170 + 3, 255);
            local _ = i2;
        end;
    end;

    return p151;
end;

function u1.EncodeTile(p175, p176, p177, p178, p179, p180, p181) -- Line: 405
    -- upvalues: encodeExact (copy), encodeNear (copy)
    local v182;

    if p181.LumaTolerance == 0 and p181.ChromaScale == 1 then
        v182 = p181.ChromaTolerance == 0;
    else
        v182 = false;
    end;

    if v182 then
        return encodeExact(p175, p176, p177, p178, p179, p180, p181.Quantize or 1);
    end;

    return encodeNear(p175, p176, p177, p178, p179, p180, p181);
end;

function u1.DecodeTile(p183, p184, p185, p186, p187) -- Line: 415
    -- upvalues: decodeExact (copy), decodeNear (copy)
    local v188 = p187 or buffer.create(p184 * p185 * 4);
    local v189;

    if p186.LumaTolerance == 0 and p186.ChromaScale == 1 then
        v189 = p186.ChromaTolerance == 0;
    else
        v189 = false;
    end;

    if v189 then
        return decodeExact(p183, p184, p185, p186.Quantize or 1, v188);
    end;

    return decodeNear(p183, p184, p185, p186, v188);
end;

function u1.Pack(p190, p191) -- Line: 424
    -- upvalues: u1 (copy), buffer_writeu8 (copy)
    local v192 = p190.TilesX * p190.TilesY;
    local v193 = 44 + v192 * 4;

    for i = 1, v192 do
        v193 = v193 + buffer.len(p191[i]);
        local _ = i;
    end;

    local buffer_create_ret = buffer.create(v193);
    buffer.writestring(buffer_create_ret, 0, u1.Magic);
    buffer_writeu8(buffer_create_ret, 4, u1.FormatVersion);
    buffer_writeu8(buffer_create_ret, 5, p190.Quantize);
    buffer.writeu16(buffer_create_ret, 6, p190.Width);
    buffer.writeu16(buffer_create_ret, 8, p190.Height);
    buffer.writeu16(buffer_create_ret, 10, p190.TileSize);
    buffer.writeu16(buffer_create_ret, 12, p190.TilesX);
    buffer.writeu16(buffer_create_ret, 14, p190.TilesY);
    buffer.writef64(buffer_create_ret, 16, p190.OriginX);
    buffer.writef64(buffer_create_ret, 24, p190.OriginZ);
    buffer.writef64(buffer_create_ret, 32, p190.PixelSize);
    buffer_writeu8(buffer_create_ret, 40, p190.LumaTolerance);
    buffer_writeu8(buffer_create_ret, 41, p190.ChromaScale);
    buffer_writeu8(buffer_create_ret, 42, p190.ChromaTolerance);
    local v194 = 44 + v192 * 4;

    for i = 1, v192 do
        local buffer_len_ret = buffer.len(p191[i]);
        buffer.writeu32(buffer_create_ret, (i - 1) * 4 + 44, buffer_len_ret);
        buffer.copy(buffer_create_ret, v194, p191[i], 0, buffer_len_ret);
        v194 = v194 + buffer_len_ret;
        local _ = i;
    end;

    return buffer_create_ret;
end;

function u1.Unpack(p195) -- Line: 457
    -- upvalues: u1 (copy), buffer_readu8 (copy)
    if typeof(p195) ~= "buffer" or buffer.len(p195) < 44 then
        return nil, "payload too short";
    end;

    if buffer.readstring(p195, 0, 4) ~= u1.Magic then
        return nil, "bad magic";
    end;

    if buffer_readu8(p195, 4) ~= u1.FormatVersion then
        return nil, "format version " .. buffer_readu8(p195, 4);
    end;

    local MakeHeader = u1.MakeHeader;
    local buffer_readu16_ret = buffer.readu16(p195, 6);
    local buffer_readu16_ret2 = buffer.readu16(p195, 8);
    local buffer_readu16_ret3 = buffer.readu16(p195, 10);
    local v196 = {
        Quantize = buffer_readu8(p195, 5),
        LumaTolerance = buffer_readu8(p195, 40)
    };
    local v197 = buffer_readu8(p195, 41);
    v196.ChromaScale = math.max(1, v197);
    v196.ChromaTolerance = buffer_readu8(p195, 42);
    local v198 = MakeHeader(buffer_readu16_ret, buffer_readu16_ret2, buffer_readu16_ret3, v196, buffer.readf64(p195, 16), buffer.readf64(p195, 24), (buffer.readf64(p195, 32)));
    local v199 = v198.TilesX * v198.TilesY;
    local v200 = 44 + v199 * 4;

    if buffer.len(p195) < v200 then
        return nil, "truncated tile table";
    end;

    local table_create_ret = table.create(v199);

    for i = 1, v199 do
        local buffer_readu32_ret = buffer.readu32(p195, (i - 1) * 4 + 44);

        if v200 + buffer_readu32_ret > buffer.len(p195) then
            return nil, "truncated tile " .. i;
        end;

        local buffer_create_ret = buffer.create(buffer_readu32_ret);
        buffer.copy(buffer_create_ret, 0, p195, v200, buffer_readu32_ret);
        table_create_ret[i] = buffer_create_ret;
        v200 = v200 + buffer_readu32_ret;
        local _ = i;
    end;

    return v198, table_create_ret;
end;

function u1.WorldToUV(p201, p202, p203) -- Line: 496
    local PixelSize = p201.PixelSize;

    return (p202 - p201.OriginX) / (p201.Width * PixelSize), (p203 - p201.OriginZ) / (p201.Height * PixelSize);
end;

return u1;
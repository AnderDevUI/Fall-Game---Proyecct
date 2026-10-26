-- [PATH] ReplicatedStorage / Modules / NumberUtil @Type ModuleScript


local v5 = {
    Lerp = function(p1, p2, p3, p4) -- Line: 12, Name: Lerp
        return p2 * (1 - p4) + p3 * p4;
    end
};
local u6 = { { 604800, "Weeks" }, { 86400, "Days" }, { 3600, "Hours" }, { 60, "Minutes" }, { 1, "Seconds" } };

function v5.FormatTime(p7: table, p8: number, p9: string, p10: string, p11: boolean?, p12: number) -- Line: 23
    -- upvalues: u6 (copy)
    local v13 = {};
    local v14 = 0;
    local v15 = false;
    local v16 = false;

    for i, v in pairs(u6) do
        if v[2] == p9 or v16 then
            local math_floor_ret = math.floor(p8 / v[1]);
            local v17 = u6[i - 1];
            v15 = v17 and v17[2] == p10 and true or v15;

            if not v15 then
                local v18 = {
                    Formatted = (math_floor_ret <= 9 and v16 and "0" or "") .. math_floor_ret .. (p11 and (v[2]:sub(1, 1):lower() or ":") or ":"),
                    Raw = math_floor_ret
                };
                table.insert(v13, v18);
                v14 = v14 == 0 and (math_floor_ret > 0 and (#v13 or 0) or 0) or v14;
            end;

            p8 = p8 - math_floor_ret * v[1];
            v16 = true;
        end;
    end;

    if p12 then
        v14 = math.min(v14 == 0 and (1 / 0) or v14, #v13 - (p12 - 1));
    end;

    local v19 = "";

    for i, v in pairs(v13) do
        local Formatted = v.Formatted;
        local _ = v.Raw;

        if not p12 or i >= v14 then
            v19 = v19 .. Formatted;
        end;
    end;

    return v19:sub(1, v19:len() - (p11 and 0 or 1));
end;

function v5.MultUDim2ByNum(p20, p21, p22) -- Line: 60
    return UDim2.new(p21.X.Scale * p22, p21.X.Offset * p22, p21.Y.Scale * p22, p21.Y.Offset * p22);
end;

function v5.MultColor3ByNum(p23, p24, p25) -- Line: 64
    return Color3.new(p24.R * p25, p24.G * p25, p24.B * p25);
end;

function v5.NumberToInteger(p26, p27) -- Line: 68
    local math_floor_ret = math.floor(p27);

    if p27 == math_floor_ret and p27 then
        math_floor_ret = p27;
    elseif math.random(1, 10000) <= math.ceil((p27 - math_floor_ret) * 10000) then
        math_floor_ret = math.ceil(p27) or math_floor_ret;
    end;

    return math_floor_ret;
end;

function v5.FormatNumber(p28, p29) -- Line: 73
    local string_match_ret, v30, v31 = string.match(p29, "^([^%d]*%d)(%d*)(.-)$");

    return string_match_ret .. v30:reverse():gsub("(%d%d%d)", "%1,"):reverse() .. v31;
end;

function v5.RoundNumber(p32, p33, p34, p35) -- Line: 78
    local v36 = p34 or 3;

    return math[p35 and "round" or "floor"](p33 * 10 ^ v36) / 10 ^ v36;
end;

function v5.IsWithin(p37, p38, p39, p40) -- Line: 83
    local v41 = (p38.X - p39.X) ^ 2 + (p38.Y - p39.Y) ^ 2 + (typeof(p38) == "Vector3" and ((p38.Z - p39.Z) ^ 2 or 0) or 0);

    return v41 <= p40 ^ 2, v41;
end;

function v5.BytesToKB(p42, p43) -- Line: 88
    return p42:FormatNumber(p42:RoundNumber(p43 / 1024, 3));
end;

return v5;
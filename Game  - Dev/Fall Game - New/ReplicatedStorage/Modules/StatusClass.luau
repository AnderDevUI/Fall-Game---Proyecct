-- [PATH] ReplicatedStorage / Modules / StatusClass @Type ModuleScript


local u1 = {
    BCAccess = {
        Priority = 1
    },
    BCDenied = {
        Priority = 1
    },
    InCombat = {
        Priority = 2
    },
    Safezone = {
        Priority = 3
    },
    Recipes = {
        Priority = 4
    },
    Craft = {
        Priority = 5
    },
    Decay = {
        Priority = 6
    },
    Bleed = {
        Priority = 7
    },
    Radiation = {
        Priority = 8,
        Max = 499
    },
    Wet = {
        Priority = 9
    },
    Temperature = {
        Priority = 10
    },
    Comfort = {
        Priority = 12
    },
    Drowning = {
        Priority = 13
    },
    Health_Buff = {
        Priority = 14
    },
    Node_Buff = {
        Priority = 15
    },
    Wood_Buff = {
        Priority = 16
    },
    Caps_Buff = {
        Priority = 17
    },
    Regen_Buff = {
        Priority = 18
    }
};
local u2 = {};
u2.__index = u2;

function u2.new() -- Line: 78
    -- upvalues: u2 (copy)
    local v3 = setmetatable({}, u2);
    v3.StatusEffects = {};
    v3.Pickups = {};

    return v3;
end;

function u2.GetStatusEffects(p4) -- Line: 88
    return p4.StatusEffects;
end;

function u2.GetPickups(p5) -- Line: 92
    return p5.Pickups;
end;

function u2.RemovePickup(p6, p7) -- Line: 96
    for i, v in pairs(p6:GetPickups()) do
        if v[1] == p7 then
            table.remove(p6:GetPickups(), i);
        end;
    end;
end;

function u2.GetPickupAmount(p8, p9) -- Line: 104
    for _, v in pairs(p8:GetPickups()) do
        if v[1] == p9 then
            return v[2];
        end;
    end;
end;

function u2.GetStatsPickupTableCombined(p10) -- Line: 112
    local v11 = {};

    for _, v in pairs(p10.StatusEffects) do
        if v[1] == "Temperature" and (v[2] < 5 or v[2] > 25) or (v[1] ~= "Temperature" and (v[2] and (typeof(v[2]) ~= "table" and (v[2] > 0 or v[2] == -1))) or typeof(v[2]) == "table" and (v[2][2] ~= nil and v[2][2] > 0)) then
            table.insert(v11, v);
        end;
    end;

    for _, v in pairs(p10.Pickups) do
        if v[2] and (v[2] > 0 or v[2] == -1) then
            table.insert(v11, v);
        end;
    end;

    return v11;
end;

function u2.GetIndexOfStat(p12, p13) -- Line: 134
    for i, v in pairs(p12:GetStatusEffects()) do
        if v[1] == p13 then
            return i;
        end;
    end;
end;

function u2.GetStatValueFromIndex(p14, p15) -- Line: 142
    local StatusEffects = p14:GetStatusEffects();

    if StatusEffects[p15] == nil then
        return StatusEffects[p15][2];
    end;
end;

function u2.GetStatValueFromName(p16, p17) -- Line: 148
    if string.find(p17, "Pickup") or string.find(p17, "Drop") then
        for _, v in pairs(p16:GetPickups()) do
            if p17 == v[1] then
                return v[2];
            end;
        end;
    end;

    return p16:GetStatValueFromIndex(p16:GetIndexOfStat(p17));
end;

function u2.OrderStats(p18) -- Line: 159
    -- upvalues: u1 (copy)
    table.sort(p18.StatusEffects, function(p19, p20) -- Line: 160
        -- upvalues: u1 (ref)
        local v21 = u1[p19[1]];
        local v22 = u1[p20[1]];

        if v21 or v22 then
            return v21.Priority < v22.Priority;
        end;
    end);
end;

function u2.InsertStat(p23, p24, p25) -- Line: 170
    if not (string.find(p24, "Pickup") or string.find(p24, "Drop")) then
        if p23:GetIndexOfStat(p24) == nil then
            local v26 = #p23:GetStatusEffects();
            p23:GetStatusEffects()[v26 + 1] = { p24, p25, tick() };
        else
            p23:UpdateStat(p24, p25, tick());
        end;

        p23:OrderStats();

        return;
    end;

    local v27 = false;

    for _, v in pairs(p23.Pickups) do
        if v[1] == p24 then
            v[2] = v[2] + p25;
            v[3] = tick();
            v27 = true;
        end;
    end;

    if not v27 then
        local Pickups = p23.Pickups;
        local v28 = { p24, p25, tick() };
        table.insert(Pickups, v28);
    end;
end;

function u2.RemoveStat(p29, p30) -- Line: 198
    for i, v in pairs(p29:GetStatusEffects()) do
        if v[1] == p30 then
            table.remove(p29:GetStatusEffects(), i);
        end;
    end;

    p29:OrderStats();
end;

function u2.UpdateStat(p31, p32, p33) -- Line: 207
    -- upvalues: u1 (copy)
    for _, v in pairs(p31:GetStatusEffects()) do
        if v[1] == p32 then
            if u1.Max ~= nil then
                p33 = math.clamp(p33, 0, u1.Max);
            end;

            v[2] = p33;
            v[3] = tick();
        end;
    end;

    p31:OrderStats();
end;

function u2.CompareServerTable(p34, p35) -- Line: 221
    for i, v in pairs(p35) do
        if i ~= "HQueue" and (i ~= "Health" and (i ~= "Hunger" and i ~= "Thirst")) then
            local v36 = v;
            local v37 = i;
            local v38 = false;

            for i2, v2 in pairs(p34:GetStatusEffects()) do
                if v2[1] == v37 then
                    v38 = i2;
                    break;
                end;
            end;

            if v38 then
                p34:GetStatusEffects()[v38][2] = v36;
            else
                p34:InsertStat(v37, v36);
            end;
        end;
    end;

    p34:OrderStats();
end;

return u2;
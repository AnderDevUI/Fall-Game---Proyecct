-- [PATH] ReplicatedStorage / Modules / ArenaSettings @Type ModuleScript


local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local Items = require(Modules:WaitForChild("Items"));
local u1 = {};
local v2 = {
    [219] = true
};
local u3 = {
    MinTimeLimit = 30,
    MaxTimeLimit = 600,
    MaxAttachmentCount = 10,
    MaxEquipmentCount = 10000,
    Attachments = {}
};
local u4 = {
    Public = "boolean",
    AutoStart = "boolean",
    HealthRegen = "boolean",
    Downing = "boolean",
    AutoRotate = "boolean",
    TimeLimit = "number",
    SplitTeams = "boolean",
    Loadouts = "table"
};
local u5 = { "Red", "Blue" };
local u6 = {
    Weapon = "number",
    Armor = "number",
    Attachments = "table",
    Ammo = "table",
    Equipment = "table"
};

for i, v in { "Sight", "Muzzle", "Barrel", "Magazine" } do
    u1[v] = i;
end;

for i, v in Items do
    if type(v) == "table" and (v.Type == "Attachment" and (not v2[i] and u1[v.AttachmentType])) then
        table.insert(u3.Attachments, i);
    end;
end;

table.sort(u3.Attachments, function(p7, p8) -- Line: 79
    -- upvalues: u1 (copy), Items (copy)
    local v9 = u1[Items[p7].AttachmentType];
    local v10 = u1[Items[p8].AttachmentType];

    if v9 == v10 then
        return p7 < p8;
    end;

    return v9 < v10;
end);
u3.AmmoByType = {};
u3.AmmoTypeOrder = { "Rifle", "Pistol", "Shell", "Arrow", "Rocket", "40mm", "Nail", "Pumpkin" };
u3.BlacklistedAmmo = {
    [318] = true,
    [100] = true
};
u3.DefaultAmmo = {
    Rifle = 4,
    Pistol = 36,
    Shell = 138,
    Arrow = 126,
    Rocket = 99,
    Nail = 93,
    Pumpkin = 285,
    ["40mm"] = 312
};
u3.AmmoAmounts = {
    Rifle = 999,
    Pistol = 999,
    Shell = 500,
    Arrow = 500,
    Rocket = 60,
    Nail = 999,
    Pumpkin = 100,
    ["40mm"] = 60
};

for i, v in Items do
    if not (type(v) ~= "table" or not (v.AmmoType and (v.Type == "Ammo" or v.Type == "ConsumableAmmoArmor")) or u3.BlacklistedAmmo[i]) then
        local v11 = u3.AmmoByType[v.AmmoType];

        if not v11 then
            v11 = {};
            u3.AmmoByType[v.AmmoType] = v11;
        end;

        table.insert(v11, i);
    end;
end;

for i, v in u3.AmmoByType do
    local u12 = u3.DefaultAmmo[i];
    table.sort(v, function(p13, p14) -- Line: 134
        -- upvalues: u12 (copy)
        if p13 == u12 == (p14 == u12) then
            return p13 < p14;
        end;

        return p13 == u12;
    end);
end;

u3.Equipment = { 212, 136, 319, 33, 2, 208, 101, 197 };
u3.EquipmentMax = {
    [212] = 50,
    [136] = 40,
    [319] = 100,
    [33] = 200,
    [2] = 30,
    [208] = 20,
    [101] = 20,
    [197] = 20
};
u3.HealingItems = {
    [2] = true,
    [136] = true,
    [319] = true
};
local u15 = {};
local u16 = {};
local u17 = {};

for _, v in u3.AmmoByType do
    for _, v3 in v do
        u15[tostring(v3)] = true;
    end;
end;

for _, v in u3.Attachments do
    u16[tostring(v)] = true;
end;

for _, v in u3.Equipment do
    u17[tostring(v)] = true;
end;

local function _(p18: any, p19: number, p20: number) -- Line: 188
    local v21;

    if type(p18) == "number" and (p18 == p18 and (p18 % 1 == 0 and p19 <= p18)) then
        v21 = p18 <= p20;
    else
        v21 = false;
    end;

    return v21;
end;

local function u24(p22: table, p23: table) -- Line: 192
    for i, v in p22 do
        if type(i) ~= "string" or p23[i] ~= type(v) then
            return false;
        end;
    end;

    for i, v in p23 do
        if type(p22[i]) ~= v then
            return false;
        end;
    end;

    return true;
end;

local function u27(p25: table, p26: table) -- Line: 202
    for i, v in p25 do
        if type(i) ~= "string" or (not p26[i] or v ~= true) then
            return false;
        end;
    end;

    return true;
end;

local function u32(p28: table, p29: table, p30: number) -- Line: 209
    for i, v in p28 do
        if type(i) ~= "string" or not p29[i] then
            return false;
        end;

        local v31;

        if type(v) == "number" and (v == v and (v % 1 == 0 and v >= 1)) then
            v31 = v <= p30;
        else
            v31 = false;
        end;

        if not v31 then
            return false;
        end;
    end;

    return true;
end;

function u3.GetEquipmentMax(p33: number, p34: number) -- Line: 217
    -- upvalues: u3 (copy), Items (copy)
    local v35 = u3.EquipmentMax[p33];

    if v35 then
        return v35;
    end;

    local v36 = Items[p33];

    return math.floor((v36 and v36.MaxStack or 1) * p34 * 2);
end;

function u3.GetAttachmentMax(p37: number, p38: table) -- Line: 227
    -- upvalues: Items (copy)
    local v39 = Items[p37];

    if v39 then
        v39 = v39.AttachmentType;
    end;

    local v40 = 0;

    for _, v in p38 do
        local v41 = Items[v];

        if v41 and (v41.Attachments and table.find(v41.Attachments, v39)) then
            v40 = v40 + 1;
        end;
    end;

    return v40;
end;

u3.DefaultAttachments = {
    ["7"] = 1
};

function u3.GetAmmoTypeRank(p42: string) -- Line: 246
    -- upvalues: u3 (copy)
    return table.find(u3.AmmoTypeOrder, p42) or #u3.AmmoTypeOrder + 1;
end;

function u3.GetKitAmmo(p43: table) -- Line: 252
    -- upvalues: Items (copy), u3 (copy)
    local v44 = {};
    local v45 = {};

    for _, v in p43 do
        local v46 = Items[v];

        if v46 then
            v46 = v46.AmmoType;
        end;

        if v46 and not v44[v46] then
            v44[v46] = true;
            table.insert(v45, v46);
        end;
    end;

    table.sort(v45, function(p47, p48) -- Line: 261
        -- upvalues: u3 (ref)
        local AmmoTypeRank = u3.GetAmmoTypeRank(p47);
        local AmmoTypeRank2 = u3.GetAmmoTypeRank(p48);

        if AmmoTypeRank == AmmoTypeRank2 then
            return p47 < p48;
        end;

        return AmmoTypeRank < AmmoTypeRank2;
    end);
    local v49 = {};

    for _, v in v45 do
        for _, v3 in u3.AmmoByType[v] or {} do
            table.insert(v49, v3);
        end;
    end;

    return v49;
end;

function u3.GetKitAmmoChoices(p50: table) -- Line: 279
    -- upvalues: u3 (copy), Items (copy)
    local v51 = {};

    for _, v in u3.GetKitAmmo(p50) do
        if #(u3.AmmoByType[Items[v].AmmoType] or {}) > 1 then
            table.insert(v51, v);
        end;
    end;

    return v51;
end;

function u3.GetGunsMissingAmmo(p52: table, p53: table) -- Line: 290
    -- upvalues: Items (copy), u3 (copy)
    local v54 = {};
    local v55 = {};

    for _, v in p53 do
        local v56 = Items[v];

        if v56 then
            v56 = v56.AmmoType;
        end;

        if v56 and not v54[v56] then
            v54[v56] = true;
            local v57 = v;
            local v58 = false;

            for _, v3 in u3.AmmoByType[v56] or {} do
                if p52.Ammo[tostring(v3)] then
                    v58 = true;
                    break;
                end;
            end;

            if not v58 then
                table.insert(v55, v57);
            end;
        end;
    end;

    return v55;
end;

function u3.RefreshAmmo(p59: table, p60: table) -- Line: 310
    -- upvalues: u3 (copy), Items (copy)
    local v61 = {};

    for _, v in u3.GetKitAmmo(p60) do
        v61[tostring(v)] = true;
    end;

    for i in p59.Ammo do
        if not v61[i] then
            p59.Ammo[i] = nil;
        end;
    end;

    for _, v in u3.GetGunsMissingAmmo(p59, p60) do
        local AmmoType = Items[v].AmmoType;
        local v62 = u3.DefaultAmmo[AmmoType] or (u3.AmmoByType[AmmoType] or {})[1];

        if v62 then
            p59.Ammo[tostring(v62)] = true;
        end;
    end;
end;

function u3.NewLoadout(p63: number, p64: number, p65: table?) -- Line: 327
    -- upvalues: u3 (copy)
    return {
        Weapon = p63,
        Armor = p64,
        Attachments = table.clone(u3.DefaultAttachments),
        Ammo = {},
        Equipment = p65 or {}
    };
end;

function u3.IsValid(p66: any, p67: number, p68: number) -- Line: 338
    -- upvalues: u24 (copy), u4 (copy), u3 (copy), u5 (copy), u6 (copy), u32 (copy), u16 (copy), u27 (copy), u15 (copy), u17 (copy)
    if type(p66) ~= "table" or not u24(p66, u4) then
        return false;
    end;

    local TimeLimit = p66.TimeLimit;

    if TimeLimit ~= 0 then
        local MinTimeLimit = u3.MinTimeLimit;
        local MaxTimeLimit = u3.MaxTimeLimit;
        local v69;

        if type(TimeLimit) == "number" and (TimeLimit == TimeLimit and (TimeLimit % 1 == 0 and MinTimeLimit <= TimeLimit)) then
            v69 = TimeLimit <= MaxTimeLimit;
        else
            v69 = false;
        end;

        if not v69 then
            return false;
        end;
    end;

    local Loadouts = p66.Loadouts;

    for i in Loadouts do
        if not table.find(u5, i) then
            return false;
        end;
    end;

    for _, v in u5 do
        local v70 = Loadouts[v];

        if type(v70) ~= "table" or not u24(v70, u6) then
            return false;
        end;

        local Weapon = v70.Weapon;
        local v71;

        if type(Weapon) == "number" and (Weapon == Weapon and (Weapon % 1 == 0 and Weapon >= 1)) then
            v71 = Weapon <= p67;
        else
            v71 = false;
        end;

        if not v71 then
            return false;
        end;

        local Armor = v70.Armor;
        local v72;

        if type(Armor) == "number" and (Armor == Armor and (Armor % 1 == 0 and Armor >= 1)) then
            v72 = Armor <= p68;
        else
            v72 = false;
        end;

        if not (v72 and (u32(v70.Attachments, u16, u3.MaxAttachmentCount) and (u27(v70.Ammo, u15) and u32(v70.Equipment, u17, u3.MaxEquipmentCount)))) then
            return false;
        end;
    end;

    return true;
end;

function u3.SanitizeLoadout(p73: table, p74: any, p75: number) -- Line: 360
    -- upvalues: u3 (copy)
    local v76 = p74(p73.Weapon);

    for i, v in p73.Attachments do
        local AttachmentMax = u3.GetAttachmentMax(tonumber(i), v76);
        local Attachments = p73.Attachments;
        local v77;

        if AttachmentMax > 0 then
            v77 = math.min(v, AttachmentMax);
        else
            v77 = nil;
        end;

        Attachments[i] = v77;
    end;

    for i, v in p73.Equipment do
        local Equipment = p73.Equipment;
        local GetEquipmentMax = u3.GetEquipmentMax;
        local v78 = tonumber(i);
        Equipment[i] = math.min(v, GetEquipmentMax(v78, p75));
    end;

    u3.RefreshAmmo(p73, v76);
end;

function u3.Sanitize(p79: table, p80: any, p81: number) -- Line: 373
    -- upvalues: u3 (copy)
    for _, v in p79.Loadouts do
        u3.SanitizeLoadout(v, p80, p81);
    end;
end;

function u3.Equals(p82, p83) -- Line: 380
    -- upvalues: u3 (copy)
    if type(p82) ~= "table" or type(p83) ~= "table" then
        return p82 == p83;
    end;

    for i, v in p82 do
        if not u3.Equals(v, p83[i]) then
            return false;
        end;
    end;

    for i in p83 do
        if p82[i] == nil then
            return false;
        end;
    end;

    return true;
end;

return u3;
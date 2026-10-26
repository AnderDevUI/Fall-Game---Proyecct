-- [PATH] ReplicatedStorage / Modules / SkinFilterState @Type ModuleScript


local u1 = {
    Search = "",
    Duplicates = "Show",
    SortDescending = false,
    WeaponSort = "Name",
    Hydrated = false,
    Rarities = {
        Exclusive = true,
        Mythical = true,
        Legendary = true,
        Epic = true,
        Rare = true,
        Common = true
    },
    HiddenWeapons = {},
    SortKeys = { "Rarity", "Skin" },
    RARITIES = { "Exclusive", "Mythical", "Legendary", "Epic", "Rare", "Common" },
    SORT_KEYS = { "Rarity", "Skin", "Weapon", "Newest", "Bundle" },
    DUPE_MODES = { "Show", "Hide", "Only" },
    WEAPON_SORTS = { "Name", "Count" },
    MAX_HIDDEN = 250
};
local u2 = nil;

function u1.EncodeRecord(p3: table) -- Line: 64
    return table.concat({
        "1",
        p3.RarityMask,
        p3.Dupes,
        table.concat(p3.Sort, ""),
        p3.Descending and "1" or "0",
        p3.WeaponSort,
        table.concat(p3.Hidden, ",")
    }, "|");
end;

function u1.Parse(p4: string?) -- Line: 79
    -- upvalues: u1 (copy)
    if type(p4) ~= "string" or (#p4 == 0 or #p4 > 512) then
        return nil;
    end;

    local string_split_ret = string.split(p4, "|");

    if #string_split_ret ~= 7 or string_split_ret[1] ~= "1" then
        return nil;
    end;

    local v5 = tonumber(string_split_ret[2]);
    local v6 = bit32.lshift(1, #u1.RARITIES) - 1;

    if not (v5 and (v5 % 1 == 0 and (v5 >= 0 and v6 >= v5))) then
        return nil;
    end;

    local v7 = tonumber(string_split_ret[3]);

    if not (v7 and (v7 % 1 == 0 and (v7 >= 1 and #u1.DUPE_MODES >= v7))) then
        return nil;
    end;

    if not string_split_ret[4]:match("^%d*$") or #string_split_ret[4] > #u1.SORT_KEYS then
        return nil;
    end;

    local v8 = {};
    local v9 = {};

    for i = 1, #string_split_ret[4] do
        local v10 = tonumber(string_split_ret[4]:sub(i, i));

        if not (v10 and (v10 >= 1 and (#u1.SORT_KEYS >= v10 and not v8[v10]))) then
            return nil;
        end;

        v8[v10] = true;
        table.insert(v9, v10);
        local _ = i;
    end;

    if string_split_ret[5] ~= "0" and string_split_ret[5] ~= "1" then
        return nil;
    end;

    local v11 = tonumber(string_split_ret[6]);

    if not (v11 and (v11 % 1 == 0 and (v11 >= 1 and #u1.WEAPON_SORTS >= v11))) then
        return nil;
    end;

    local v12 = {};
    local v13 = {};

    if string_split_ret[7] ~= "" then
        for _, v in string.split(string_split_ret[7], ",") do
            local v14 = tonumber(v);

            if not (v14 and (v14 % 1 == 0 and (v14 >= 1 and (v14 <= 100000 and not v13[v14])))) then
                return nil;
            end;

            if #v12 >= 250 then
                return nil;
            end;

            v13[v14] = true;
            table.insert(v12, v14);
        end;

        table.sort(v12);
    end;

    return {
        RarityMask = v5,
        Dupes = v7,
        Sort = v9,
        Descending = string_split_ret[5] == "1",
        WeaponSort = v11,
        Hidden = v12
    };
end;

function u1.Sanitize(p15: string?, p16: any?) -- Line: 133
    -- upvalues: u1 (copy), u2 (ref)
    local v17 = u1.Parse(p15);

    if not v17 then
        return nil, false;
    end;

    if p16 then
        local v18 = {};

        for _, v in v17.Hidden do
            if p16(v) then
                table.insert(v18, v);
            end;
        end;

        v17.Hidden = v18;
    end;

    local v19 = u1.EncodeRecord(v17);

    if v19 == u2 then
        return nil, true;
    end;

    return v19, true;
end;

function u1.Encode(p20: table?) -- Line: 152
    -- upvalues: u1 (copy), u2 (ref)
    local v21 = 0;

    for i, v in u1.RARITIES do
        if u1.Rarities[v] then
            local bit32_lshift_ret = bit32.lshift(1, i - 1);
            v21 = bit32.bor(v21, bit32_lshift_ret);
        end;
    end;

    local v22 = {};

    for _, v in u1.SortKeys do
        local table_find_ret = table.find(u1.SORT_KEYS, v);

        if table_find_ret then
            table.insert(v22, table_find_ret);
        end;
    end;

    local v23 = {};

    for i in u1.HiddenWeapons do
        local v24;

        if p20 then
            v24 = p20[i];
        else
            v24 = p20;
        end;

        if v24 and #v23 < 250 then
            table.insert(v23, v24);
        end;
    end;

    table.sort(v23);
    local v25 = u1.EncodeRecord({
        RarityMask = v21,
        Dupes = table.find(u1.DUPE_MODES, u1.Duplicates) or 1,
        Sort = v22,
        Descending = u1.SortDescending == true,
        WeaponSort = table.find(u1.WEAPON_SORTS, u1.WeaponSort) or 1,
        Hidden = v23
    });

    if v25 == u2 then
        return nil;
    end;

    return v25;
end;

u2 = u1.Encode();
u1.DEFAULT_ENCODED = u2;

function u1.Apply(p26: string?, p27: table?) -- Line: 196
    -- upvalues: u1 (copy)
    local v28 = u1.Parse(p26);

    if not v28 then
        return false;
    end;

    for i, v in u1.RARITIES do
        local Rarities = u1.Rarities;
        local RarityMask = v28.RarityMask;
        local bit32_lshift_ret = bit32.lshift(1, i - 1);
        Rarities[v] = bit32.band(RarityMask, bit32_lshift_ret) ~= 0;
    end;

    u1.Duplicates = u1.DUPE_MODES[v28.Dupes];
    table.clear(u1.SortKeys);

    for _, v in v28.Sort do
        table.insert(u1.SortKeys, u1.SORT_KEYS[v]);
    end;

    u1.SortDescending = v28.Descending;
    u1.WeaponSort = u1.WEAPON_SORTS[v28.WeaponSort];
    table.clear(u1.HiddenWeapons);

    for _, v in v28.Hidden do
        local v29;

        if p27 then
            v29 = p27[v];
        else
            v29 = p27;
        end;

        if v29 then
            u1.HiddenWeapons[v29] = true;
        end;
    end;

    return true;
end;

return u1;
-- [PATH] ReplicatedStorage / Modules / ItemClass @Type ModuleScript


local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local Items = require(Modules:WaitForChild("Items"));
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11) -- Line: 22
    -- upvalues: u1 (copy), Items (copy)
    local v12;

    if type(p2) == "table" then
        v12 = setmetatable(p2, u1);

        if p3 then
            p3(v12);
        end;

        if v12.Ammo then
            if p3 then
                p3(v12.Ammo);
            end;

            v12.Ammo = u1.new(v12.Ammo, p3);
        end;

        local v13 = {};

        if v12.Attachments then
            for _, v in pairs(v12.Attachments) do
                if type(v) == "table" then
                    if p3 then
                        p3(v);
                    end;

                    local v14 = u1.new(v, p3);
                    table.insert(v13, v14);
                end;
            end;

            v12.Attachments = v13;
        end;

        local Container = v12.Container;

        if Container then
            local table_create_ret = table.create(Items[p2.ID].SlotSize, 0);

            for i, v in pairs(Container) do
                local v15 = type(v) == "table";

                if p3 and v15 then
                    p3(v);
                end;

                local v16;

                if v15 then
                    v16 = u1.new(v, p3);
                else
                    v16 = v;
                end;

                table_create_ret[tonumber(i)] = type(v16) == "string" and 0 or v16;
            end;

            v12.Container = table_create_ret;

            return v12;
        end;
    else
        local v17 = Items[p2];
        local MaxDurability = v17.MaxDurability;
        local v18 = tonumber(p5);

        if not p11 and v17.SlotSize then
            p11 = table.create(v17.SlotSize, 0);
        end;

        if type(p7) == "table" then
            p7 = u1.new(p7);
        end;

        if not p8 then
            p8 = v17.Attachments and {};
        end;

        if p8 then
            for i, v in p8 do
                if type(v) == "table" then
                    p8[i] = u1.new(v);
                end;
            end;
        end;

        if p11 then
            for i, v in p11 do
                if type(v) == "table" then
                    p11[i] = u1.new(v);
                end;
            end;
        end;

        local v19 = {
            ID = p2,
            Amount = p3,
            Skin = p4 or "Default",
            Durability = type(p5) == "string" and (v18 and MaxDurability) and MaxDurability * v18 or (p5 or (MaxDurability or 0)),
            Repair = p6 or 0,
            Ammo = p7,
            Attachments = p8,
            CookTimes = p9,
            Owner = p10,
            Container = p11
        };
        v12 = setmetatable(v19, u1);
    end;

    return v12;
end;

function u1.SetAmount(p20, p21) -- Line: 106
    p20.Amount = p21;
end;

function u1.ChangeAmount(p22, p23, p24, p25, p26) -- Line: 110
    -- upvalues: Items (copy)
    local MaxStack = Items[p22.ID].MaxStack;
    local v27 = p22.Amount + p23;
    local v28 = p25 and (1 / 0) or math.round(MaxStack * ((MaxStack ~= 1 or p26) and p24 and p24 or 1));
    p22.Amount = math.clamp(v27, 0, v28);
end;

function u1.AddAttachment(p29, p30) -- Line: 115
    table.insert(p29.Attachments, p30);
end;

function u1.RemoveAttachment(p31, p32) -- Line: 119
    local Attachments = p31.Attachments;

    if type(p32) ~= "table" then
        local v33 = Attachments[p32];
        table.remove(Attachments, p32);

        return v33;
    end;

    for i, v in pairs(Attachments) do
        if v == p32 then
            table.remove(Attachments, i);

            return;
        end;
    end;
end;

function u1.GetComponents(p34, p35) -- Line: 135
    local v36 = {
        p34.ID,
        p34.Amount,
        p34.Skin,
        p34.Durability,
        p34.Repair,
        p34.Ammo,
        p34.Attachments,
        p34.CookTimes,
        p34.Owner,
        p34.Container
    };

    return unpack(v36, 1, p35 or #v36);
end;

function u1.AttachmentStats(p37, p38) -- Line: 140
    -- upvalues: Items (copy)
    local v39 = {};

    for _, v in pairs(p37.Attachments or {}) do
        local v40 = Items[v.ID];

        if v40 and v40.MaxDurability == nil or v.Durability > 0 then
            local AttachmentStats = v40.AttachmentStats;

            if AttachmentStats then
                local AimForRecoilMult = AttachmentStats.AimForRecoilMult;

                if not AttachmentStats.Toggle or v.On then
                    for i, v2 in pairs(AttachmentStats) do
                        if i ~= "RecoilMult" or (not AimForRecoilMult or p38) then
                            local v41 = v39[i];
                            local v42;

                            if v41 and type(v41) == "number" then
                                v42 = v41 + v2 or v2;
                            else
                                v42 = v2;
                            end;

                            v39[i] = v42;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return v39;
end;

function u1.GetMaxAmmo(p43) -- Line: 161
    -- upvalues: Items (copy)
    local v44 = Items[p43.ID];

    if v44 then
        v44 = v44.BaseMaxAmmo;
    end;

    if v44 then
        local v45 = v44 * (1 + (p43:AttachmentStats().MaxAmmoMult or 0));

        return math.round(v45);
    end;
end;

function u1.HasAttachment(p46, p47) -- Line: 169
    for _, v in pairs(p46.Attachments or {}) do
        if v.ID == p47 then
            return v;
        end;
    end;
end;

function u1.GetAttachments(p48) -- Line: 176
    local v49 = {};

    for _, v in pairs(p48.Attachments or {}) do
        if type(v) == "table" and v ~= 0 then
            local ID = v.ID;

            if ID and ID ~= 0 then
                table.insert(v49, ID);
            end;
        end;
    end;

    return v49;
end;

function u1.HasItems(p50) -- Line: 187
    local Container = p50.Container;

    if Container then
        for _, v in Container do
            if type(v) == "table" and v.Amount > 0 then
                return true;
            end;
        end;

        return false;
    end;
end;

function u1.IsToolbar(p51) -- Line: 196
    -- upvalues: Items (copy)
    local v52 = Items[p51.ID];

    return (v52.Type == "Gun" or (v52.Type == "Tool" or (v52.Type:find("Consumable") ~= nil or v52.Type == "Bench"))) and true or v52.Type == "Lock";
end;

return u1;
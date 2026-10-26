-- [PATH] ReplicatedStorage / Modules / ArmorModule @Type ModuleScript


local u1 = {
    All = { "Helmet", "Face", "Hat", "Chestplate", "Wetsuit", "Shirt", "Kilt", "Pants", "Boots", "Gloves" },
    Helmet = { "Face", "Hat", "All" },
    Hat = { "Helmet", "All" },
    Face = { "Helmet", "All" },
    Chestplate = { "All" },
    Wetsuit = { "Shirt", "Pants", "All" },
    Shirt = { "All", "Wetsuit" },
    Kilt = { "All" },
    Pants = { "All", "Wetsuit" },
    Boots = { "All" },
    Gloves = { "All" }
};
local u2 = {
    ["Steel Helmet"] = {
        ["Phantom Rider"] = true
    }
};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
game:GetService("RunService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Armors = ReplicatedStorage:WaitForChild("Armors");
local Sleeves = ReplicatedStorage:WaitForChild("Sleeves");
local WeldModule = require(Modules:WaitForChild("WeldModule"));
local Items = require(Modules:WaitForChild("Items"));
local LocalPlayer = Players.LocalPlayer;

return {
    UpdateArmors = function(p3, p4, p5, p6) -- Line: 51, Name: UpdateArmors
        -- upvalues: Items (copy), LocalPlayer (copy), Sleeves (copy), u2 (copy), Armors (copy), WeldModule (copy)
        if not (p4 and p4.Parent) then
            return;
        end;

        local v7 = {};

        for _, child in pairs(p4:GetChildren()) do
            local Name = child.Name;

            if child:IsA("Model") and Name:sub(1, 6) == "Armor_" then
                local string_find_ret = string.find(Name, "/");

                if string_find_ret then
                    local v8 = tonumber(Name:sub(7, string_find_ret - 1));

                    if v8 then
                        local v9 = Name:sub(string_find_ret + 1);
                        local v10 = v7[v8];

                        if not v10 then
                            v10 = {
                                Skin = v9,
                                Models = {}
                            };
                            v7[v8] = v10;
                        end;

                        table.insert(v10.Models, child);
                    end;
                end;
            end;
        end;

        local Armors2 = p3:GetArmors(p5);
        local v11 = false;

        for i, v in pairs(v7) do
            local Skin = v.Skin;
            local v12 = v;
            local v13 = i;
            local v14 = false;

            for _, v2 in pairs(Armors2) do
                if v2.ID == v13 and v2.Skin == Skin then
                    v2.Found = true;
                    v14 = true;
                    break;
                end;
            end;

            if not v14 then
                v11 = true;

                for _, v2 in pairs(v12.Models) do
                    v2:Destroy();
                end;
            end;
        end;

        local v15 = {};
        local v16 = false;
        local v17 = {};
        local v18 = {};
        local v19 = false;
        local v20 = false;

        for _, v in pairs(Armors2) do
            local ID = v.ID;
            local Skin = v.Skin;
            local v21 = Items[ID];

            if v21 then
                local ArmorType = v21.ArmorType;
                local Name = v21.Name;
                local v22, v23, v24, v25, v26, v27, v28, v29;

                if LocalPlayer then
                    local v30 = Sleeves:FindFirstChild(Name);

                    if v30 and v30:FindFirstChild(Skin) then
                        if ArmorType == "Chestplate" then
                            v22 = v;

                            for i = #v17, 1, -1 do
                                local v31;

                                if v18[i] == "Shirt" then
                                    table.remove(v17, i);
                                    table.remove(v18, i);
                                    v31 = i;
                                else
                                    v31 = i;
                                end;
                            end;

                            v16 = true;
                            table.insert(v17, Name .. "/" .. Skin);
                            table.insert(v18, ArmorType);
                            v19 = v21.HideHair and true or v19;

                            if u2[Name] then
                                v20 = u2[Name][Skin] ~= nil;
                            end;

                            v23 = v21.Attribute;

                            if p6 and (v23 and not table.find(v15, v23)) then
                                table.insert(v15, "Armor_" .. v23);
                            end;

                            v24 = v22.Attachments;

                            if v24 then
                                for _, v2 in v24 do
                                    v25 = Items[v2.ID];

                                    if v25 then
                                        v26 = v25.Attribute;

                                        if p6 and (v26 and not table.find(v15, v26)) then
                                            table.insert(v15, "Armor_" .. v26);
                                        end;
                                    end;
                                end;
                            end;

                            if v22.Found then
                                v22.Found = nil;
                            else
                                v11 = true;
                                v27 = Armors:FindFirstChild(Name);

                                if v27 then
                                    v28 = v27:FindFirstChild(Skin);

                                    if v28 then
                                        v29 = WeldModule:FullyWeldModels(v28:Clone(), p4, true);

                                        for _, v2 in pairs(v29) do
                                            v2.Name = "Armor_" .. ID .. "/" .. Skin;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        if ArmorType ~= "Shirt" or not v16 then
                            v22 = v;
                            table.insert(v17, Name .. "/" .. Skin);
                            table.insert(v18, ArmorType);
                            v19 = v21.HideHair and true or v19;

                            if u2[Name] then
                                v20 = u2[Name][Skin] ~= nil;
                            end;

                            v23 = v21.Attribute;

                            if p6 and (v23 and not table.find(v15, v23)) then
                                table.insert(v15, "Armor_" .. v23);
                            end;

                            v24 = v22.Attachments;

                            if v24 then
                                for _, v2 in v24 do
                                    v25 = Items[v2.ID];

                                    if v25 then
                                        v26 = v25.Attribute;

                                        if p6 and (v26 and not table.find(v15, v26)) then
                                            table.insert(v15, "Armor_" .. v26);
                                        end;
                                    end;
                                end;
                            end;

                            if v22.Found then
                                v22.Found = nil;
                            else
                                v11 = true;
                                v27 = Armors:FindFirstChild(Name);

                                if v27 then
                                    v28 = v27:FindFirstChild(Skin);

                                    if v28 then
                                        v29 = WeldModule:FullyWeldModels(v28:Clone(), p4, true);

                                        for _, v2 in pairs(v29) do
                                            v2.Name = "Armor_" .. ID .. "/" .. Skin;
                                        end;
                                    end;
                                end;
                            end;
                        end;

                        v22 = v;
                    else
                        v22 = v;
                    end;
                else
                    v22 = v;
                end;

                v19 = v21.HideHair and true or v19;

                if u2[Name] then
                    v20 = u2[Name][Skin] ~= nil;
                end;

                v23 = v21.Attribute;

                if p6 and (v23 and not table.find(v15, v23)) then
                    table.insert(v15, "Armor_" .. v23);
                end;

                v24 = v22.Attachments;

                if v24 then
                    for _, v2 in v24 do
                        v25 = Items[v2.ID];

                        if v25 then
                            v26 = v25.Attribute;

                            if p6 and (v26 and not table.find(v15, v26)) then
                                table.insert(v15, "Armor_" .. v26);
                            end;
                        end;
                    end;
                end;

                if v22.Found then
                    v22.Found = nil;
                else
                    v11 = true;
                    v27 = Armors:FindFirstChild(Name);

                    if v27 then
                        v28 = v27:FindFirstChild(Skin);

                        if v28 then
                            v29 = WeldModule:FullyWeldModels(v28:Clone(), p4, true);

                            for _, v2 in pairs(v29) do
                                v2.Name = "Armor_" .. ID .. "/" .. Skin;
                            end;
                        end;
                    end;
                end;
            end;
        end;

        for _, child in pairs(p4:GetChildren()) do
            if child.Name == "Hair" and child:IsA("Model") then
                local HairPart = child:FindFirstChild("HairPart");

                if HairPart then
                    HairPart.Transparency = v19 and 1 or 0;
                end;
            end;
        end;

        if p4.Name ~= "Rig" then
            local Head = p4:FindFirstChild("Head");

            if Head then
                Head.Transparency = v20 and 0.99 or 0;

                for _, child in Head:GetChildren() do
                    if child:IsA("Decal") then
                        child.Transparency = v20 and 1 or 0;
                    end;
                end;
            end;
        end;

        if LocalPlayer then
            LocalPlayer:SetAttribute("ArmorSleeves", table.concat(v17, "^"));
        end;

        if p6 then
            for i, v in pairs(p6:GetAttributes()) do
                if i:sub(1, 6) == "Armor_" then
                    local v32 = v and table.find(v15, i);

                    if v32 then
                        table.remove(v15, v32);
                    else
                        p6:SetAttribute(i, nil);
                    end;
                end;
            end;

            for _, v in pairs(v15) do
                p6:SetAttribute(v, true);
            end;
        end;

        return v11;
    end,

    GetArmors = function(p33: table, p34: any, p35: string?, p36: string?) -- Line: 208, Name: GetArmors
        -- upvalues: Items (copy)
        if not p34 then
            return;
        end;

        local v37 = {};
        local v38 = {};

        for i, v in pairs(p34) do
            if v and (v ~= 0 and v.Amount > 0) then
                local v39 = Items[v.ID];

                if v39 ~= nil and (not v39.MaxDurability or (v.Durability or 0) > 0) then
                    local Resistances = v39.Resistances;
                    local v40, v41, v42;

                    if p35 then
                        if Resistances then
                            local v43 = Resistances[p35];

                            if v43 then
                                v40 = i;
                                v41 = v;
                                local v44 = false;

                                for _, v2 in pairs(type(v43) == "table" and v43 and v43 or { v43 }) do
                                    if v2 > 0 then
                                        v44 = true;
                                        break;
                                    end;
                                end;

                                if v44 then
                                    v42 = v39.Attribute;

                                    if not (p36 and (v42 == nil or not v42:find(p36))) then
                                        table.insert(v37, v41);
                                        table.insert(v38, v40);
                                    end;
                                end;
                            end;
                        end;
                    else
                        v40 = i;
                        v41 = v;
                        v42 = v39.Attribute;

                        if not (p36 and (v42 == nil or not v42:find(p36))) then
                            table.insert(v37, v41);
                            table.insert(v38, v40);
                        end;
                    end;
                end;
            end;
        end;

        return v37, v38;
    end,

    GetArmorTypes = function(p45) -- Line: 237, Name: GetArmorTypes
        -- upvalues: u1 (copy)
        return u1;
    end
};
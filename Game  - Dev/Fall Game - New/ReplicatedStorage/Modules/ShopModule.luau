-- [PATH] ReplicatedStorage / Modules / ShopModule @Type ModuleScript


local os_time_ret = os.time({
    year = 2026,
    month = 10,
    day = 23,
    hour = 19
});
local u1 = {};
local v2 = {
    Weekly1 = {
        Price = 299,
        Item = "Baseball Cap/Quack",
        Type = "Skin",
        EndOffer = os_time_ret
    },
    Weekly2 = {
        Type = "Skin",
        Price = 749,
        Item = "Hard Hat/Slurpee",
        EndOffer = os_time_ret
    },
    Weekly3 = {
        Type = "Skin",
        Price = 1999,
        Item = "Wooden Double Door/Decoy",
        EndOffer = os_time_ret
    },
    Weekly4 = {
        Type = "Skin",
        Price = 1999,
        Item = "Salvaged SMG/Evil Easter",
        EndOffer = os_time_ret
    },
    Weekly5 = {
        Type = "Skin",
        Price = 4699,
        Item = "Garage Door/Cryo",
        EndOffer = os_time_ret
    },
    RaritySells = {
        Type = "Sell",
        MaxQuickSellBatch = 200,
        Amounts = {
            Common = 20,
            Rare = 40,
            Epic = 100,
            Legendary = 250,
            Exclusive = 250,
            Mythical = 900
        }
    },
    OnlyCommon = {
        Type = "Crate",
        Items = { { 100, "Common" } }
    },
    FallenCrate1 = {
        Name = "Apex Case",
        Image = "rbxassetid://126414915690535",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Salvaged M14/High Tide", "Military USP/Cherry Blossom", "Salvaged SMG/Game Buddy", "Garage Door/Cryo", "Steel Helmet/OBEY" } }, { 6, { "Salvaged AK47/Gingerbread", "Salvaged Sniper/Radioactive", "Salvaged Pump Action/Gold Ripple", "Salvaged Pipe Rifle/Skyline", "Metal Door/Demon", "Hazmat Suit/Specialist", "Flannel Jacket/Snow White" } }, { 23, { "Military PKM/Digital Red", "Military MP7/Whiteout", "Boulder/Bubblegum", "Metal Double Door/Nightwave", "Furnace/Banana", "Flannel Jacket/Biker" } }, { 68.2, { "Military M39/Turkey", "Military MP7/Zap", "Crossbow/Emerald", "Iron Shard Hatchet/Leather", "Wooden Double Door/Rainbow", "Steel Helmet/Cardboard", "Hoodie/Red", "Balaclava/Monkey" } } }
    },
    FallenCrate2 = {
        Name = "Pulse Case",
        Image = "rbxassetid://78525178691599",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Salvaged AK47/Cyber Hunter", "Nail Gun/Magma", "Storage Cabinet/Monster", "Rug/Kraken", "Steel Chestplate/OBEY" } }, { 6, { "Military M4A1/Toy", "Salvaged Break Action/HotDog", "Salvaged M14/Jingle Bell", "Salvaged Sniper/Radioactive", "Steel Axe/Lava", "Garage Door/Witch", "Small Storage Box/Monster" } }, { 23, { "Salvaged AK74u/Pink Ripple", "Military MP7/Digital Tiger", "Machete/Foam", "Wooden Double Door/Barn Doors", "Rug/Chinese Dragon", "Boss Helmet/Boris Sky" } }, { 68.2, { "Salvaged Python/Shockwave", "Military Barrett/Molten", "Military USP/Bright Water", "Boulder/Mosaic", "Wooden Door/Cardboard", "Balaclava/Jolly", "Hoodie/Wool", "Boots/Black" } } }
    },
    FallenCrate3 = {
        Name = "Reaper Case",
        Image = "rbxassetid://102998480152025",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Salvaged AK74u/Comic", "Salvaged RPG/Blast", "Blast Furnace/Robot", "Furnace/Penguin", "Boss Helmet/Boris Abibas" } }, { 6, { "Salvaged AK47/Fade", "Salvaged Pipe Rifle/Surge", "Salvaged P250/Splat", "Salvaged SMG/Evil Easter", "Boulder/Voxel", "Steel Leggings/OBEY", "Wetsuit/Pink" } }, { 23, { "Military Barrett/Mystra", "Military AA12/Red Tiger", "Stone Hatchet/Slime", "Wooden Double Door/Cherry Blossom", "Bed/Pixel", "Salvaged Metal Door/Graffiti" } }, { 68.2, { "Military MP7/Zap", "Salvaged Python/Shockwave", "Salvaged M14/Frog14", "Hammer/Building Blocks", "Wooden Door/Wise", "Balaclava/Frankenstein", "Hoodie/Green", "Pants/Khaki" } } }
    },
    FallenCrate4 = {
        Name = "Nexus Case",
        Image = "rbxassetid://90979475738190",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Salvaged M14/Glitch", "Salvaged AK47/Ghillie", "Hammer/Toy", "Metal Double Door/Hells Gate", "Boss Chestplate/Boris Abibas" } }, { 6, { "Military M4A1/Syntax", "Military MP7/Animeaster", "Salvaged Skorpion/Superior", "Salvaged P250/Drift", "Furnace/Pumpkin", "Hoodie/Bee", "Pants/Bee" } }, { 23, { "Salvaged SMG/Red Urban", "Salvaged Python/Canvas", "Wooden Door/Pot of Gold", "Sleeping Bag/Prismatic", "Large Storage Box/Festive", "Hard Hat/Slurpee" } }, { 68.2, { "Salvaged RPG/Festive", "Military MP7/Zap", "Boulder/Wrapped", "Metal Door/Bayou", "Small Storage Box/Comic", "Steel Helmet/Bomo", "Collared Shirt/Flannel", "Military Gloves/Arctic" } } }
    },
    FallenCrate5 = {
        Name = "Deadman Case",
        Image = "rbxassetid://99684886843429",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Military M4A1/Monster", "Crossbow/Toy", "Furnace/Blue Steel", "Steel Helmet/Fear", "Military Gloves/Grim" } }, { 6, { "Salvaged SMG/Checkmate", "Salvaged AK47/Anodized", "Crossbow/Crossbones", "Salvaged P250/Splat", "Wooden Door/Christmas Tree", "Boots/Abibas", "Wetsuit/Frog" } }, { 23, { "Salvaged Skorpion/Rusty", "Military MP7/Dark Matter", "Stone Hatchet/Shark", "Leather Poncho/Pilgrim", "Baseball Cap/Pilgrim", "Balaclava/Skull" } }, { 68.2, { "Military Barrett/Molten", "Military MP7/Grunge", "Boulder/Sushi", "Iron Shard Pickaxe/Leather", "Metal Door/Pixel", "Salvaged Helmet/Kill to Survive", "Hoodie/Night", "Leather Gloves/Noir" } } }
    },
    FallenCrate6 = {
        Name = "Hazard Case",
        Image = "rbxassetid://132046549891064",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Salvaged AK47/Blue Gem", "Military Barrett/Surge", "Steel Axe/Fire Axe", "Furnace/Gorilla", "Flannel Jacket/Abibas" } }, { 6, { "Crossbow/Candy Whale", "Military MP7/Fade", "Military USP/Crimson Scale", "Salvaged Python/Blue Prey", "Boulder/Pumpkin", "Rug/Jolly Rogers", "Military Backpack/Digital Red" } }, { 23, { "Salvaged SMG/Knight", "Military AA12/Zombie", "Steel Pickaxe/Cross", "Small Storage Box/Burger", "Metal Door/Comic", "Boss Helmet/Boris Carbon" } }, { 68.2, { "Salvaged SMG/Fire and Ice", "Wooden Bow/Blue Fissure", "Military M39/Turkey", "Machete/Rainbow", "Wooden Door/Cardboard", "Hoodie/Purple", "Balaclava/Digital", "Boots/Forest Camo" } } }
    },
    FallenCrate7 = {
        Name = "Sakura Case",
        Image = "rbxassetid://128457494865882",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Military M4A1/Cherry Blossom", "Salvaged M14/Candy Dragon", "Salvaged Skorpion/Pegasus", "Metal Door/Angry Bunny", "Hoodie/Abibas" } }, { 6, { "Military AA12/Monster", "Salvaged AK47/North Pole", "Salvaged AK74u/Flarette", "Salvaged Pump Action/Red Tiger", "Steel Shovel/Heart of Spades", "Garage Door/King of the street", "Hoodie/Valentine" } }, { 23, { "Salvaged Break Action/Boom", "Salvaged Python/Hyper", "Large Storage Box/Egg Sketch", "Bed/Pixel", "Pants/Forest Camo", "Boots/Valentine" } }, { 68.2, { "Salvaged RPG/Festive", "Salvaged Shotgun/Camo", "Salvaged SMG/Fire and Ice", "Boulder/ERROR 404", "Wooden Double Door/Rainbow", "Salvaged Helmet/Cardboard", "Baseball Cap/Quack", "Balaclava/Frankenstein" } } }
    },
    FallenCrate8 = {
        Name = "Lunch Case",
        Image = "rbxassetid://74813021118585",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Salvaged Sniper/Valentine", "Salvaged AK47/Gold Sky", "Crossbow/HotDog", "Sleeping Bag/UwU", "Military Backpack/Abibas" } }, { 6, { "Military M4A1/Spring Lily", "Military USP/Azure", "Salvaged AK74u/Clover", "Salvaged Skorpion/Cyber Revenge", "Garage Door/Surprise Meow", "Wooden Door/Summer Time", "Baseball Cap/Propeller" } }, { 23, { "Salvaged AK74u/Zombie", "Salvaged P250/Blue Gem", "Furnace/Glyphs", "Steel Door/Duck", "Large Storage Box/Canvas", "Hoodie/Forest Camo" } }, { 68.2, { "Military MP7/Solitare", "Salvaged M14/Huntsman", "Steel Axe/Ruby", "Iron Shard Pickaxe/Leather", "Furnace/Chinese New Year", "Salvaged Helmet/Cardboard", "Balaclava/Jester", "Military Gloves/Arctic" } } }
    },
    FallenCrate9 = {
        Name = "Vortex Case",
        Image = "rbxassetid://124807053113001",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Military M39/Medusa", "Military M4A1/Medusa", "Boulder/Chocolate", "Wooden Door/Beware", "Hazmat Suit/Digital Red" } }, { 6, { "Salvaged Python/Saku", "Salvaged Skorpion/Superior", "Salvaged SMG/Digital Candy", "Salvaged AK74u/Flarette", "Steel Double Door/Red Lotus", "Large Storage Box/Ouja", "Pants/Abibas" } }, { 23, { "Salvaged AK47/Anodized Blue", "Salvaged Pipe Rifle/Frost", "Furnace/Banana", "Sleeping Bag/Santa", "Flannel Jacket/Biker", "Pants/Valentine" } }, { 68.2, { "Salvaged Break Action/Surf", "Crossbow/Emerald", "Iron Shard Hatchet/Leather", "Hammer/Building Blocks", "Small Storage Box/Medical", "Balaclava/Digital", "Hoodie/Wool", "Leather Gloves/Noir" } } }
    },
    FallenCrate10 = {
        Name = "Horizon Case",
        Image = "rbxassetid://104151675925988",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Salvaged AK47/Vaporwave", "Salvaged Double Barrel/HotDog", "Boulder/Pixskull", "Large Storage Box/Game Buddy", "Steel Helmet/Hockey" } }, { 6, { "Salvaged P250/Sketch", "Salvaged SMG/Digital Candy", "Military MP7/Wave", "Crossbow/Rose", "Stone Hatchet/Molten", "Stone Pickaxe/Molten", "Hazmat Suit/Spark" } }, { 23, { "Salvaged Python/Smudge", "Military PKM/Digital Red", "Sleeping Bag/Cucumber John", "Rug/Chinese Dragon", "Garage Door/Blob", "Collared Shirt/Business" } }, { 68.2, { "Salvaged M14/Huntsman", "Salvaged Break Action/Easter Wood", "Military Barrett/Molten", "Boulder/Mosaic", "Metal Door/Pixel", "Balaclava/Jester", "Hoodie/Night", "Shorts/Beach Day" } } }
    },
    FallenCrate11 = {
        Name = "Volt Case",
        Image = "rbxassetid://73292515107922",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Salvaged M14/Arcane", "Military PKM/Anime Sketch", "Storage Cabinet/Hades", "Furnace/Sweet Gingerbread", "Hazmat Suit/Blue Fissure" } }, { 6, { "Salvaged Pump Action/Cyber", "Salvaged AK47/Anodized Red", "Salvaged Skorpion/Cyber Revenge", "Salvaged AK74u/Splash", "Boulder/Fish Tank", "Steel Double Door/Vaporwave", "Flannel Jacket/Snow White" } }, { 23, { "Military MP7/Pink Plasm", "Salvaged P250/Festive", "Garage Door/King Raid", "Sleeping Bag/Voxel", "Rug/Christmas Knit", "Salvaged Helmet/Digital Snow" } }, { 68.2, { "Salvaged RPG/Festive", "Salvaged Python/Inferno", "Iron Shard Pickaxe/Leather", "Steel Axe/Ruby", "Metal Door/Bayou", "Salvaged Gloves/Digital Snow", "Leather Poncho/Viva", "Hoodie/Purple" } } }
    },
    FallenCrate12 = {
        Name = "Industrial Case",
        Image = "rbxassetid://135982179426585",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Military PKM/Anime Waifu", "Salvaged Python/Pink Canvas", "Iron Shard Hatchet/Sawblade", "Metal Door/Industrial", "Hazmat Suit/Digital Camo" } }, { 6, { "Salvaged AK74u/Nebula", "Salvaged Pipe Rifle/Skyline", "Wooden Bow/Sweet Gingerbread", "Salvaged SMG/Checkmate", "Steel Pickaxe/Ice Pick", "Storage Cabinet/Gift Wrap", "Furnace/Burger" } }, { 23, { "Salvaged P250/Egg Sketch", "Salvaged M14/Paintball", "Small Storage Box/Gremlin", "Sleeping Bag/Shark", "Salvaged Chestplate/Digital Snow", "Salvaged Leggings/Digital Snow" } }, { 68.2, { "Salvaged Break Action/Surf", "Military MP7/Grunge", "Salvaged Shotgun/Camo", "Boulder/Wrapped", "Metal Double Door/Pixel", "Salvaged Gloves/Digital Snow", "Steel Helmet/Cardboard", "Baseball Cap/Quack" } } }
    },
    FallenCrate13 = {
        Name = "Steampunk Case",
        Image = "rbxassetid://117031760122805",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Salvaged M14/Anime Bloss", "Salvaged Shotgun/HotDog", "Lighter/Lantern", "Blast Furnace/Steampunk", "Hazmat Suit/Classified" } }, { 6, { "Military PKM/Resistance", "Salvaged Skorpion/Surge", "Military Barrett/Leprechaun", "Salvaged SMG/Joker", "Mining Drill/Brick", "Metal Double Door/Tropical", "Metal Door/PLZ NO RAID" } }, { 23, { "Salvaged SMG/Splat", "Salvaged Break Action/Splat", "Iron Shard Hatchet/Fade", "Iron Shard Pickaxe/Fade", "Sleeping Bag/Chocolate", "Electric Furnace/ICBM" } }, { 68.2, { "Military USP/Bright Water", "Military MP7/Solitare", "Salvaged Python/Shockwave", "Boulder/Sushi", "Small Storage Box/Comic", "Salvaged Helmet/Kill to Survive", "Balaclava/Jolly", "Hoodie/Green" } } }
    },
    FallenCrate14 = {
        Name = "Impact Case",
        Image = "rbxassetid://99501499206433",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Military PKM/Turbo", "Nail Gun/Wintrane", "Salvaged Skorpion/Comic", "Boulder/Moai", "Steel Double Door/Elven Gate" } }, { 6, { "Salvaged RPG/Boomstick", "Salvaged AK74u/Splash", "Salvaged Pump Action/Joe Skeleton", "Military USP/Fade", "Steel Axe/Lava", "Garage Door/Grand Prix", "Cloth Pants/Ninja" } }, { 23, { "Salvaged AK47/Anodized Blue", "Salvaged SMG/Inferno", "Steel Pickaxe/Molten", "Boulder/Jack-O-Lantern", "Sleeping Bag/Spooky", "Cloth Handwraps/Ninja" } }, { 68.2, { "Salvaged Python/Inferno", "Salvaged M14/Frog14", "Military M39/Turkey", "Machete/Rainbow", "Wooden Door/Wise", "Leather Poncho/Viva", "Shorts/Beach Day", "Balaclava/Monkey" } } }
    },
    FallenCrate15 = {
        Name = "Cupid Case",
        Image = "rbxassetid://96354834120275",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Military M4A1/Phantom", "Military Barrett/Fade", "Stone Hatchet/Love Trip", "Stone Pickaxe/Love Trip", "Hoodie/Puffer" } }, { 6, { "Salvaged P250/Fade", "Salvaged M14/Splat", "Crossbow/Chief", "Large Storage Box/Coffin", "Sleeping Bag/Big Pillow", "Salvaged Metal Door/Visions", "Cloth Shirt/Ninja" } }, { 23, { "Military AA12/Zombie", "Salvaged SMG/Inferno", "Wooden Door/Pixel", "Large Storage Box/Forged", "Salvaged Chestplate/Burnout", "Cloth Footwraps/Ninja" } }, { 68.2, { "Salvaged Python/Hazard", "Wooden Bow/Blue Fissure", "Hammer/ERROR 404", "Boulder/ERROR 404", "Small Storage Box/Medical", "Steel Helmet/Bomo", "Hoodie/Red", "Boots/Black" } } }
    },
    FallenCrate16 = {
        Name = "Redline Case",
        Image = "rbxassetid://93925020631310",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Salvaged AK47/Diablo", "Salvaged Shotgun/Banana", "Campfire/Skulls", "Steel Door/Galactic", "Hazmat Suit/Ghoul" } }, { 6, { "Salvaged AK74u/Beast", "Salvaged Pump Action/Flurry", "Nail Gun/Striker", "Salvaged Skorpion/Celestial", "Salvaged P250/Blue Terror", "Small Storage Box/Monster", "Cloth Headwrap/Ninja" } }, { 23, { "Military MP7/Whiteout", "Military AA12/Red Tiger", "Machete/Foam", "Boulder/Bubblegum", "Stone Hatchet/Candy Cane", "Sleeping Bag/Fruit" } }, { 68.2, { "Salvaged Python/Hazard", "Salvaged Break Action/Easter Wood", "Hammer/ERROR 404", "Metal Double Door/Pixel", "Furnace/Chinese New Year", "Collared Shirt/Flannel", "Pants/Khaki", "Boots/Forest Camo" } } }
    },
    FallenCrate17 = {
        Name = "Evergreen Case",
        Image = "rbxassetid://74998572898093",
        Type = "Crate",
        Price = 150,
        Items = { { 0.3, "Mythical" }, { 2.5, { "Military Barrett/Ghillie", "Steel Door/Elven Gate" } }, { 6, { "Wooden Double Door/Decoy", "Boss Helmet/Blackwidow", "Boss Chestplate/Blackwidow" } }, { 23, { "Military M4A1/Banana", "Steel Axe/Fade", "Steel Pickaxe/Fade", "Wetsuit/Lady Bug" } }, { 68.2, { "Salvaged AK47/Airframe", "Salvaged Skorpion/Surplus", "Sleeping Bag/Jungle", "Salvaged Backpack/Patchwork", "Collared Shirt/Woodland" } } }
    }
};
local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");

if Modules:GetAttribute("Split") then
    Modules = Modules:WaitForChild("Shared");
end;

local SkinsModule = require(Modules:WaitForChild("SkinsModule"));
local v3 = SkinsModule:FetchSkins();

local function GetCaseRollWeights(p4) -- Line: 1319
    local v5 = {};
    local v6 = 0;

    for i, v in ipairs(p4.Items) do
        local math_round_ret = math.round(v[1] * 100000 / 100);
        local math_max_ret = math.max(math_round_ret, 0);
        v5[i] = math_max_ret;
        v6 = v6 + math_max_ret;
    end;

    return v5, v6;
end;

local function BuildCaseSpinner(p7: string, p8: any) -- Line: 1332
    -- upvalues: GetCaseRollWeights (copy)
    local v9, v10 = GetCaseRollWeights(p8);

    if v10 ~= 100000 then
        warn((`[ShopModule] {p7}'s odds add up to {v10 * 100 / 100000}% instead of 100% - rolls past the total are refunded`));
    end;

    if v10 <= 0 then
        return {};
    end;

    local v11 = {};
    local v12 = 0;
    local v13 = {};

    for i, v in ipairs(v9) do
        local v14 = v * 1000 / v10;
        v11[i] = math.floor(v14);
        v12 = v12 + v11[i];
        table.insert(v13, { i, v14 - v11[i] });
    end;

    table.sort(v13, function(p15, p16) -- Line: 1345
        if p15[2] == p16[2] then
            return p15[1] < p16[1];
        end;

        return p15[2] > p16[2];
    end);

    for i = 1, 1000 - v12 do
        local v17 = v13[i][1];
        v11[v17] = v11[v17] + 1;
        local _ = i;
    end;

    for i, v in ipairs(v9) do
        if v > 0 and v11[i] <= 0 then
            local v18 = i;
            local v19 = nil;

            for i2, v4 in ipairs(v11) do
                if v4 > 1 and (not v19 or v11[v19] < v4) then
                    v19 = i2;
                end;
            end;

            if v19 then
                v11[v19] = v11[v19] - 1;
                v11[v18] = 1;
            end;
        end;
    end;

    local v20 = {};
    local v21 = {};

    for i in ipairs(v11) do
        v20[i] = 0;
    end;

    for i = 1, 1000 do
        local _ = i;
        local v22 = nil;

        for i2, v in ipairs(v11) do
            if v > 0 then
                v20[i2] = v20[i2] + v;

                if not v22 or v20[i2] > v20[v22] then
                    v22 = i2;
                end;
            end;
        end;

        v20[v22] = v20[v22] - 1000;
        table.insert(v21, v22);
    end;

    for i, v in ipairs(p8.Items) do
        local v23;

        if v11[i] > 0 then
            v23 = v11[i];
        else
            v23 = nil;
        end;

        v[3] = v23;
    end;

    return v21;
end;

local v24 = false;

for i, v in pairs(v2) do
    if v.Type == "Crate" then
        if string.match(i, "^FallenCrate%d+$") then
            table.insert(u1, i);
        end;

        local v25 = v;
        local v26 = i;

        for i2, v4 in pairs(v.Items) do
            local _ = v4[1];
            local v27 = v4[2];

            if type(v27) == "string" then
                local v28 = {};

                for _, v5 in pairs(v3[v27]) do
                    if not v5[4] then
                        table.insert(v28, v5[1] .. "/" .. v5[2]);
                    end;
                end;

                v4[2] = v28;
            else
                local v29 = i2;
                local v30 = nil;

                for i3, v5 in v27 do
                    local SkinInfo = SkinsModule:GetSkinInfo(v5);

                    if SkinInfo then
                        local Rarity = SkinInfo.Rarity;

                        if v30 then
                            if v30 ~= Rarity then
                                print((`[ShopModule] {v26} has a skin ({v5}) with a rarity ({Rarity}) not matching the others ({v30})`));
                            end;
                        else
                            v30 = Rarity;
                        end;
                    else
                        warn((`[ShopModule] Skin in crate {v26} under item index {v29} not found in SkinsModule ({v5}) ({i3})`));
                        v24 = true;
                    end;
                end;
            end;
        end;

        v25.Spinner = BuildCaseSpinner(v26, v25);
    end;
end;

if v24 then
    error("ShopModule failed to properly initialize. Check warnings above for more info.");
end;

function v2.GetCaseRollScale() -- Line: 1431
    return 100000;
end;

function v2.GetCaseIndexFromRoll(p31: any, p32: number) -- Line: 1437
    -- upvalues: GetCaseRollWeights (copy)
    local v33 = GetCaseRollWeights(p31);
    local v34 = 0;

    for i, v in ipairs(v33) do
        v34 = v34 + v;

        if p32 <= v34 then
            return i;
        end;
    end;

    return nil;
end;

table.sort(u1, function(p35, p36) -- Line: 1449
    return tonumber(string.match(p35, "%d+")) < tonumber(string.match(p36, "%d+"));
end);
v2.CapsBonuses = {
    [1685219094] = {
        Skin = nil,
        Cases = { 3 }
    },
    [1685219211] = {
        Skin = "Military PKM/Bling",
        Cases = {}
    },
    [1685219672] = {
        Skin = "Salvaged AK47/Bling",
        Cases = { 8 }
    },
    [3612251478] = {
        Skin = nil,
        Cases = { 10, 10 }
    }
};
v2.CapsBonusOrder = { 1685219094, 1685219211, 1685219672, 3612251478 };
local u37 = {};

local function getPermutation(p38: number) -- Line: 1471
    -- upvalues: u37 (copy), u1 (copy)
    local v39 = u37[p38];

    if v39 then
        return v39;
    end;

    local Random_new_ret = Random.new(p38);
    local table_clone_ret = table.clone(u1);

    for i = #table_clone_ret, 2, -1 do
        local v40 = Random_new_ret:NextInteger(1, i);
        local v41 = table_clone_ret[i];
        table_clone_ret[i] = table_clone_ret[v40];
        table_clone_ret[v40] = v41;
        local _ = i;
    end;

    u37[p38] = table_clone_ret;

    return table_clone_ret;
end;

local function caseAtSlot(p42: number) -- Line: 1486
    -- upvalues: u1 (copy), getPermutation (copy)
    local v43 = #u1;

    if v43 == 0 then
        return nil;
    end;

    return getPermutation((math.floor(p42 / v43)))[p42 % v43 + 1];
end;

local u44 = {};

function v2.GetCapsBonuses(p45: table, p46: number?) -- Line: 1496
    -- upvalues: u44 (copy), u1 (copy), getPermutation (copy)
    local v47 = p46 or os.time();
    local math_floor_ret = math.floor((v47 - 68400) / 86400);
    local v48 = u44[math_floor_ret];

    if v48 then
        return v48;
    end;

    local v49 = 0;

    for _, v in ipairs(p45.CapsBonusOrder) do
        local v50 = p45.CapsBonuses[v];
        v49 = v49 + (v50 and (v50.Cases and #v50.Cases) or 0);
    end;

    local u51 = math_floor_ret * v49;
    local u52 = {};

    local function nextCase() -- Line: 1511
        -- upvalues: u1 (ref), u51 (ref), getPermutation (ref), u52 (copy)
        for i = 1, #u1 + 1 do
            local v53 = u51;
            local v54 = #u1;
            local v55;

            if v54 == 0 then
                v55 = nil;
            else
                v55 = getPermutation((math.floor(v53 / v54)))[v53 % v54 + 1];
            end;

            u51 = u51 + 1;

            if v55 and not u52[v55] then
                u52[v55] = true;

                return v55;
            end;

            local _ = i;
        end;

        return nil;
    end;

    local v56 = {};

    for _, v in ipairs(p45.CapsBonusOrder) do
        local v57 = p45.CapsBonuses[v];

        if v57 then
            local v58 = {};

            for _, v4 in ipairs(v57.Cases or {}) do
                local v59 = nextCase();

                if v59 then
                    table.insert(v58, {
                        Case = v59,
                        Count = v4
                    });
                end;
            end;

            v56[v] = {
                Cases = v58,
                Skin = v57.Skin
            };
        end;
    end;

    u44[math_floor_ret] = v56;

    return v56;
end;

return v2;
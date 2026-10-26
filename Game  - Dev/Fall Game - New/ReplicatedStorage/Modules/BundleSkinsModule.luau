-- [PATH] ReplicatedStorage / Modules / BundleSkinsModule @Type ModuleScript


return {
    GetSkinsFromName = function(p1: string) -- Line: 3
        local v2 = {};

        if p1 == "Industrial" then
            table.insert(v2, "Large Storage Box/Industrial Guns");
            table.insert(v2, "Large Storage Box/Industrial Resources");
            table.insert(v2, "Large Storage Box/Industrial Medical");
            table.insert(v2, "Large Storage Box/Industrial Components");
            table.insert(v2, "Large Storage Box/Industrial Armor");

            return v2;
        end;

        if p1 == "Frosty" then
            table.insert(v2, "Steel Helmet/Frosty");
            table.insert(v2, "Steel Chestplate/Frosty");
            table.insert(v2, "Steel Leggings/Frosty");
            table.insert(v2, "Metal Door/Frosty");
            table.insert(v2, "Salvaged AK47/Frosty");
            table.insert(v2, "Boulder/Frosty");

            return v2;
        end;

        if p1 == "OH Deer" then
            table.insert(v2, "Steel Helmet/OH Deer");
            table.insert(v2, "Steel Chestplate/OH Deer");
            table.insert(v2, "Steel Leggings/OH Deer");
            table.insert(v2, "Salvaged Skorpion/Gingerbread");
            table.insert(v2, "Salvaged Pipe Rifle/Gingerbread");
            table.insert(v2, "Steel Door/Christmas Tree");

            return v2;
        end;

        if p1 == "Snow" then
            table.insert(v2, "Hazmat Suit/Snowman");
            table.insert(v2, "Wooden Door/Chocolate");
            table.insert(v2, "Steel Axe/Freeze");
            table.insert(v2, "Steel Pickaxe/Freeze");
            table.insert(v2, "Salvaged P250/Peppermint");

            return v2;
        end;

        if p1 == "Valentine" then
            table.insert(v2, "Salvaged Helmet/Cupid");
            table.insert(v2, "Salvaged Chestplate/Cupid");
            table.insert(v2, "Salvaged Leggings/Cupid");
            table.insert(v2, "Salvaged Gloves/Cupid");
            table.insert(v2, "Wooden Bow/Cupid");
            table.insert(v2, "Salvaged SMG/Valentine");
            table.insert(v2, "Stone Hatchet/Valentine");
            table.insert(v2, "Stone Pickaxe/Valentine");

            return v2;
        end;

        if p1 == "Woodland" then
            table.insert(v2, "Steel Helmet/Woodland");
            table.insert(v2, "Steel Chestplate/Woodland");
            table.insert(v2, "Steel Leggings/Woodland");
            table.insert(v2, "Hoodie/Woodland");
            table.insert(v2, "Pants/Woodland");
            table.insert(v2, "Boots/Woodland");
            table.insert(v2, "Military PKM/Woodland");

            return v2;
        end;

        if p1 == "Crimson Bunny" then
            table.insert(v2, "Balaclava/Crimson Bunny");
            table.insert(v2, "Wooden Chestplate/Crimson Bunny");
            table.insert(v2, "Wooden Helmet/Crimson Bunny");
            table.insert(v2, "Wooden Leggings/Crimson Bunny");
            table.insert(v2, "Machete/Crimson");
            table.insert(v2, "Salvaged Python/Crimson Glitched");
            table.insert(v2, "Wooden Bow/Crimson");

            return v2;
        end;

        if p1 == "Recycle" then
            table.insert(v2, "Mining Drill/Recycle");
            table.insert(v2, "Chainsaw/Recycle");

            return v2;
        end;

        if p1 == "Hot Rod" then
            table.insert(v2, "Steel Helmet/Hot Rod");
            table.insert(v2, "Steel Chestplate/Hot Rod");
            table.insert(v2, "Steel Leggings/Hot Rod");
            table.insert(v2, "Hoodie/Hot Rod");
            table.insert(v2, "Pants/Hot Rod");
            table.insert(v2, "Boots/Hot Rod");
            table.insert(v2, "Salvaged AK47/Hot Rod");

            return v2;
        end;

        if p1 == "Stellark" then
            table.insert(v2, "Salvaged AK74u/Stellark Dragon");
            table.insert(v2, "Hazmat Suit/Stellark");
            table.insert(v2, "Salvaged M14/Stellark");
            table.insert(v2, "Salvaged Python/Stellark");
            table.insert(v2, "Boulder/Stellark");

            return v2;
        end;

        if p1 == "Independence" then
            table.insert(v2, "Metal Door/Independence");
            table.insert(v2, "Salvaged Python/Independence");
            table.insert(v2, "Balaclava/Independence");
            table.insert(v2, "Baseball Cap/Independence");
            table.insert(v2, "Military M4A1/Independence");
            table.insert(v2, "Rug/Independence");

            return v2;
        end;

        if p1 == "Tempest" then
            table.insert(v2, "Salvaged SMG/Tempest");
            table.insert(v2, "Salvaged P250/Tempest");
            table.insert(v2, "Salvaged Helmet/Tempest");
            table.insert(v2, "Salvaged Chestplate/Tempest");
            table.insert(v2, "Salvaged Leggings/Tempest");
            table.insert(v2, "Salvaged Gloves/Tempest");

            return v2;
        end;

        if p1 == "Tyrant" then
            table.insert(v2, "Salvaged AK47/Tyrant");
            table.insert(v2, "Military MP7/Tyrant");
            table.insert(v2, "Steel Helmet/Tyrant");
            table.insert(v2, "Steel Chestplate/Tyrant");
            table.insert(v2, "Steel Leggings/Tyrant");
            table.insert(v2, "Hoodie/Tyrant");
            table.insert(v2, "Pants/Tyrant");
            table.insert(v2, "Storage Cabinet/Tyrant");
            table.insert(v2, "Steel Door/Tyrant");

            return v2;
        end;

        if p1 == "Correctional" then
            table.insert(v2, "Pants/Correctional");
            table.insert(v2, "Boots/Correctional");
            table.insert(v2, "Collared Shirt/Correctional");
            table.insert(v2, "Flannel Jacket/Correctional");
            table.insert(v2, "Leather Pants/Correctional");
            table.insert(v2, "Leather Shirt/Correctional");
            table.insert(v2, "Leather Boots/Correctional");
            table.insert(v2, "Leather Gloves/Correctional");

            return v2;
        end;

        if p1 == "Nutcracker" then
            table.insert(v2, "Military M4A1/Nutcracker");
            table.insert(v2, "Military Helmet/Nutcracker");
            table.insert(v2, "Military Chestplate/Nutcracker");
            table.insert(v2, "Military Leggings/Nutcracker");
            table.insert(v2, "Hoodie/Nutcracker");
            table.insert(v2, "Military Gloves/Nutcracker");
            table.insert(v2, "Pants/Nutcracker");
            table.insert(v2, "Boots/Nutcracker");

            return v2;
        end;

        if p1 == "Black Ice" then
            table.insert(v2, "Salvaged AK74u/Black Ice");
            table.insert(v2, "Salvaged SMG/Black Ice");
            table.insert(v2, "Salvaged Python/Black Ice");

            return v2;
        end;

        if p1 == "Tundra" then
            table.insert(v2, "Boss Helmet/Bruno Tundra");
            table.insert(v2, "Boss Chestplate/Bruno Tundra");
            table.insert(v2, "Military Leggings/Tundra");
            table.insert(v2, "Hoodie/Tundra");
            table.insert(v2, "Pants/Tundra");
            table.insert(v2, "Boots/Tundra");
            table.insert(v2, "Military Backpack/Tundra");
            table.insert(v2, "Salvaged AK74u/Tundra");

            return v2;
        end;

        if p1 == "Elite Bunny" then
            table.insert(v2, "Salvaged Helmet/Elite Bunny");
            table.insert(v2, "Salvaged Chestplate/Elite Bunny");
            table.insert(v2, "Salvaged Leggings/Elite Bunny");
            table.insert(v2, "Salvaged Backpack/Elite Bunny");
            table.insert(v2, "Hoodie/Elite Bunny");
            table.insert(v2, "Pants/Elite Bunny");
            table.insert(v2, "Boots/Elite Bunny");
            table.insert(v2, "Salvaged SMG/Elite Bunny");
            table.insert(v2, "Salvaged P250/Elite Bunny");
            table.insert(v2, "Metal Door/Elite Bunny");

            return v2;
        end;

        if p1 == "The Game" then
            table.insert(v2, "Hazmat Suit/Front");
            table.insert(v2, "Hazmat Suit/Guard");
            table.insert(v2, "Hoodie/Player");
            table.insert(v2, "Pants/Player");
            table.insert(v2, "Salvaged AK74u/MP5");

            return v2;
        end;

        if p1 == "Ducky" then
            table.insert(v2, "Hazmat Suit/Ducky");
            table.insert(v2, "Salvaged Backpack/Ducky");
            table.insert(v2, "Salvaged SMG/Ducky");
            table.insert(v2, "Salvaged Double Barrel/Ducky");
            table.insert(v2, "Boulder/Ducky");

            return v2;
        end;

        if p1 == "Rogue" then
            table.insert(v2, "Salvaged AK47/Rogue");
            table.insert(v2, "Steel Door/Rogue");
            table.insert(v2, "Steel Helmet/Rogue");
            table.insert(v2, "Steel Chestplate/Rogue");
            table.insert(v2, "Steel Leggings/Rogue");
            table.insert(v2, "Large Storage Box/Rogue");

            return v2;
        end;

        if p1 == "Pilot" then
            table.insert(v2, "Hoodie/Pilot");
            table.insert(v2, "Pants/Pilot");
            table.insert(v2, "Boots/Pilot");
            table.insert(v2, "Military Helmet/Pilot");
            table.insert(v2, "Military Chestplate/Pilot");
            table.insert(v2, "Military Gloves/Pilot");

            return v2;
        end;

        if p1 == "Phantom Rider" then
            table.insert(v2, "Steel Helmet/Phantom Rider");
            table.insert(v2, "Steel Chestplate/Phantom Rider");
            table.insert(v2, "Steel Leggings/Phantom Rider");
            table.insert(v2, "Salvaged AK47/Phantom Rider");
            table.insert(v2, "Salvaged AK74u/Phantom Rider");

            return v2;
        end;

        if p1 == "Cryo" then
            table.insert(v2, "Boss Helmet/Cryo");
            table.insert(v2, "Boss Chestplate/Cryo");
            table.insert(v2, "Military Leggings/Cryo");
            table.insert(v2, "Military M4A1/Cryo");
            table.insert(v2, "Military Barrett/Cryo");

            return v2;
        end;

        if p1 == "Oni" then
            table.insert(v2, "Steel Helmet/Oni");
            table.insert(v2, "Steel Chestplate/Oni");
            table.insert(v2, "Steel Leggings/Oni");
            table.insert(v2, "Salvaged AK47/Oni");
            table.insert(v2, "Machete/Oni");

            return v2;
        end;

        if p1 == "Medal" then
            table.insert(v2, "Military Helmet/Medal");
            table.insert(v2, "Military Chestplate/Medal");
            table.insert(v2, "Military Leggings/Medal");
            table.insert(v2, "Military Gloves/Medal");
            table.insert(v2, "Boots/Medal");
            table.insert(v2, "Salvaged AK47/Medal");
            table.insert(v2, "Salvaged Python/Medal");

            return v2;
        end;

        if p1 == "Tester" then
            table.insert(v2, "Boulder/Tester");

            return v2;
        end;

        if p1 == "VIP" then
            table.insert(v2, "Salvaged AK74u/VIP");
            table.insert(v2, "Steel Helmet/VIP");
            table.insert(v2, "Stone Hatchet/VIP");
            table.insert(v2, "Stone Pickaxe/VIP");

            return v2;
        end;

        if p1 == "WinterWrap" then
            table.insert(v2, "Base Cabinet/Winter Wrap");
            table.insert(v2, "Storage Cabinet/Winter Wrap");
            table.insert(v2, "Furnace/Winter Wrap");

            return v2;
        end;

        if p1 ~= "Neon" then
            if p1 == "Dune" then
                table.insert(v2, "Steel Helmet/Dune");
                table.insert(v2, "Steel Chestplate/Dune");
                table.insert(v2, "Steel Leggings/Dune");
                table.insert(v2, "Salvaged AK47/Dune");
            end;

            return v2;
        end;

        table.insert(v2, "Storage Cabinet/Neon Comps");
        table.insert(v2, "Storage Cabinet/Neon Ore");
        table.insert(v2, "Storage Cabinet/Neon Wood");
        table.insert(v2, "Storage Cabinet/Neon Guns");
        table.insert(v2, "Storage Cabinet/Neon Armor");
        table.insert(v2, "Storage Cabinet/Neon Meds");
        table.insert(v2, "Storage Cabinet/Neon Tools");
        table.insert(v2, "Storage Cabinet/Neon Boom");
        table.insert(v2, "Storage Cabinet/Neon Food");

        return v2;
    end
};
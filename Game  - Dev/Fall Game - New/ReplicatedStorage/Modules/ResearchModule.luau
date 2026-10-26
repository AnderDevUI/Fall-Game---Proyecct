-- [PATH] ReplicatedStorage / Modules / ResearchModule @Type ModuleScript


local u1 = {
    {
        Name = "Anvil",
        Tiers = { {}, { {
                    ID = 6,
                    Amount = 50
                }, {
                    ID = 82,
                    Amount = 1
                } }, { {
                    ID = 6,
                    Amount = 125
                } }, { {
                    ID = 6,
                    Amount = 175
                }, {
                    ID = 180,
                    Amount = 1
                } }, { {
                    ID = 6,
                    Amount = 400
                }, {
                    ID = 172,
                    Amount = 1
                }, {
                    ID = 45,
                    Amount = 100
                } }, { {
                    ID = 6,
                    Amount = 500
                }, {
                    ID = 173,
                    Amount = 1
                }, {
                    ID = 46,
                    Amount = 10
                } }, { {
                    ID = 6,
                    Amount = 750
                }, {
                    ID = 80,
                    Amount = 5
                } }, { {
                    ID = 6,
                    Amount = 750
                }, {
                    ID = 46,
                    Amount = 25
                } }, { {
                    ID = 6,
                    Amount = 1000
                }, {
                    ID = 174,
                    Amount = 1
                } } },
        Unlocks = {}
    },
    {
        Name = "Carpentry Table",
        Tiers = { {}, { {
                    ID = 6,
                    Amount = 100
                }, {
                    ID = 82,
                    Amount = 2
                } }, { {
                    ID = 6,
                    Amount = 150
                }, {
                    ID = 1,
                    Amount = 300
                } }, { {
                    ID = 6,
                    Amount = 250
                }, {
                    ID = 45,
                    Amount = 100
                } }, { {
                    ID = 6,
                    Amount = 400
                }, {
                    ID = 79,
                    Amount = 3
                } }, { {
                    ID = 6,
                    Amount = 300
                }, {
                    ID = 46,
                    Amount = 30
                } }, { {
                    ID = 6,
                    Amount = 800
                } } },
        Unlocks = {}
    },
    {
        Name = "Sewing Table",
        Tiers = { {}, { {
                    ID = 6,
                    Amount = 25
                }, {
                    ID = 1,
                    Amount = 100
                } }, { {
                    ID = 6,
                    Amount = 75
                }, {
                    ID = 84,
                    Amount = 2
                } }, { {
                    ID = 6,
                    Amount = 100
                }, {
                    ID = 45,
                    Amount = 200
                } }, { {
                    ID = 6,
                    Amount = 250
                }, {
                    ID = 87,
                    Amount = 3
                } }, { {
                    ID = 6,
                    Amount = 400
                }, {
                    ID = 85,
                    Amount = 2
                }, {
                    ID = 84,
                    Amount = 4
                } }, { {
                    ID = 6,
                    Amount = 1250
                }, {
                    ID = 46,
                    Amount = 25
                } } },
        Unlocks = {}
    },
    {
        Name = "Ammo Press",
        Tiers = { {}, { {
                    ID = 6,
                    Amount = 75
                }, {
                    ID = 179,
                    Amount = 3
                } }, { {
                    ID = 6,
                    Amount = 150
                }, {
                    ID = 45,
                    Amount = 100
                } }, { {
                    ID = 6,
                    Amount = 400
                }, {
                    ID = 46,
                    Amount = 20
                } }, { {
                    ID = 6,
                    Amount = 400
                }, {
                    ID = 65,
                    Amount = 250
                } }, { {
                    ID = 6,
                    Amount = 300
                } } },
        Unlocks = {}
    },
    {
        Name = "Chemistry Lab",
        Tiers = { {}, { {
                    ID = 6,
                    Amount = 125
                }, {
                    ID = 45,
                    Amount = 250
                } }, { {
                    ID = 6,
                    Amount = 450
                }, {
                    ID = 68,
                    Amount = 50
                } }, { {
                    ID = 6,
                    Amount = 1000
                }, {
                    ID = 46,
                    Amount = 25
                }, {
                    ID = 88,
                    Amount = 1
                } }, { {
                    ID = 6,
                    Amount = 500
                } } },
        Unlocks = {}
    },
    {
        Name = "Culinary Table",
        Tiers = { {}, { {
                    ID = 6,
                    Amount = 75
                } }, { {
                    ID = 6,
                    Amount = 125
                }, {
                    ID = 68,
                    Amount = 20
                } }, { {
                    ID = 6,
                    Amount = 200
                }, {
                    ID = 243,
                    Amount = 2
                } }, { {
                    ID = 6,
                    Amount = 300
                }, {
                    ID = 45,
                    Amount = 75
                } }, { {
                    ID = 6,
                    Amount = 400
                }, {
                    ID = 46,
                    Amount = 10
                } } },
        Unlocks = {}
    }
};
local u2 = {};
local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local RecipeModule = require(Modules:WaitForChild("RecipeModule"));
local v20 = {
    GetInfoFromName = function(p3: table, p4: string) -- Line: 403, Name: GetInfoFromName
        -- upvalues: u1 (copy)
        for i, v in pairs(u1) do
            if v.Name == p4 then
                return v, i;
            end;
        end;
    end,

    GetInfoFromIndex = function(p5: table, p6: number) -- Line: 410, Name: GetInfoFromIndex
        -- upvalues: u1 (copy)
        return u1[p6];
    end,

    CalculateUnlocks = function(p7) -- Line: 414, Name: CalculateUnlocks
        -- upvalues: RecipeModule (copy), u2 (copy)
        for _, v in pairs(RecipeModule:GetCraftingCategories()) do
            local v8 = RecipeModule:FetchRecipeList(v) or {};

            for _, v2 in pairs(v8) do
                local BenchNeeded = v2.BenchNeeded;

                if BenchNeeded then
                    u2[BenchNeeded] = true;
                    local TierNeeded = v2.TierNeeded;
                    local _ = v2.ID;
                    local InfoFromName = p7:GetInfoFromName(BenchNeeded);

                    if InfoFromName then
                        local Unlocks = InfoFromName.Unlocks;
                        local v9 = Unlocks[TierNeeded];

                        if not v9 then
                            v9 = {};
                            Unlocks[TierNeeded] = v9;
                        end;

                        if not table.find(v9, v2) then
                            table.insert(v9, v2);
                        end;
                    end;
                end;
            end;
        end;
    end,

    CalculateCraftTime = function(p10, p11, p12, p13) -- Line: 439, Name: CalculateCraftTime
        return p12 < p11 and 0.75 - 0.5 / math.max(p13 - 1, 1) * math.max(p11 - p12 - 1, 0) or 1;
    end,

    DebugGetCosts = function(p14) -- Line: 443, Name: DebugGetCosts
        -- upvalues: u1 (copy)
        local v15 = {};
        local v16 = 0;

        for _, v in pairs(u1) do
            v15[v.Name] = 0;
            local v17 = v;

            for _, v2 in pairs(v.Tiers) do
                for _, v3 in pairs(v2) do
                    if v3.ID == 6 then
                        local Name = v17.Name;
                        v15[Name] = v15[Name] + v3.Amount;
                        v16 = v16 + v3.Amount;
                    end;
                end;
            end;
        end;

        print(`TOTAL BOTTLE CAP COST OF {v16}`, v15);
    end,

    FetchResearchInfos = function(p18) -- Line: 459, Name: FetchResearchInfos
        -- upvalues: u1 (copy)
        return u1;
    end,

    FetchAllWorkbenches = function(p19) -- Line: 463, Name: FetchAllWorkbenches
        -- upvalues: u2 (copy)
        return u2;
    end
};
v20:CalculateUnlocks();

return v20;
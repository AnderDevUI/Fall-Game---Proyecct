-- [PATH] ReplicatedStorage / Modules / RecipeModule @Type ModuleScript


local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
require(Modules:WaitForChild("Items"));
local u1 = {};
local u2 = {};
local u3 = { "Weapons", "Tools", "Build", "Attire", "Ammo", "Resources", "Medical", "Other" };
local v55 = {
    CalculateTotalCost = function(p4: table, p5: any, p6: number?, p7: any, p8: table) -- Line: 28, Name: CalculateTotalCost
        local v9 = p6 or 1;
        local v10 = {};

        for _, v in pairs(p5.Costs or {}) do
            local ID = v.ID;

            if not (p8 and table.find(p8, ID)) then
                local Amount = v.Amount;

                if p7 and (type(p7) ~= "table" or not table.find(p7, ID)) then
                    local RecipesForItem = p4:GetRecipesForItem(ID);

                    if #RecipesForItem > 0 then
                        if #RecipesForItem > 1 then
                            warn("MULTIPLE RECIPES FOUND FOR ID OF " .. ID .. "; DEFAULTING TO FIRST", RecipesForItem[1]);
                        end;

                        local v11 = p4:CalculateTotalCost(RecipesForItem[1], v9, p7, p8);

                        for _, v2 in pairs(v11) do
                            p4:CombineCost(v10, v2.ID, v2.Amount, 1);
                        end;
                    else
                        p4:CombineCost(v10, ID, Amount, v9);
                    end;
                else
                    p4:CombineCost(v10, ID, Amount, v9);
                end;
            end;
        end;

        return v10;
    end,

    GetCostDifferences = function(p12: table, p13: any, p14: number, p15: number, p16: number?, p17: boolean?, p18: table) -- Line: 58, Name: GetCostDifferences
        local v19 = p16 or 1;
        local v20 = p12:CalculateTotalCost(p13, v19, p17, p18);
        local v21 = nil;

        for _, v in pairs(v20) do
            local v22 = 1 / v.Amount;

            if not v21 or v21 >= v22 then
                v21 = v22;
            end;
        end;

        if not v21 then
            error("RECIPE USED FOR REPAIRING RETURNED NO VALID COSTS", p13);
        end;

        local v23 = p14 + math.max(p15, v21);
        local math_min_ret = math.min(v23, 1);
        local v24 = p12:CalculateTotalCost(p13, p14 * v19, p17, p18);
        local v25 = p12:CalculateTotalCost(p13, math_min_ret * v19, p17, p18);
        local v26 = {};

        for _, v in pairs(v25) do
            local v27 = v;
            local v28 = 0;

            for _, v2 in pairs(v24) do
                if v2.ID == v27.ID then
                    v28 = v2.Amount;
                    break;
                end;
            end;

            local v29 = v27.Amount - v28;

            if v29 > 0 then
                v27.Amount = v29;
                table.insert(v26, v27);
            end;
        end;

        return v26, math_min_ret - p14;
    end,

    CombineCost = function(p30: table, p31: any, p32: number, p33: number, p34: number) -- Line: 94, Name: CombineCost
        local v35 = {};
        local v36 = false;

        for _, v in pairs(p31) do
            if v.ID == p32 then
                v35 = v;
                v36 = true;
                break;
            end;
        end;

        local v37 = (v35.Amount or 0) + p33 * p34;

        if v37 > 0 then
            v35.ID = p32;
            v35.Amount = v37;

            if not v36 then
                table.insert(p31, v35);
            end;

            return v35;
        end;
    end,

    GetRecipesForItem = function(p38, p39) -- Line: 115, Name: GetRecipesForItem
        -- upvalues: u2 (ref), u1 (copy)
        local v40 = u2[p39];

        if v40 then
            return v40;
        end;

        local v41 = {};

        for _, v in pairs(u1) do
            local v42 = v;

            for _, v2 in pairs(v.Recipes) do
                if v2.ID == p39 then
                    v2.Category = v42.Type;
                    table.insert(v41, v2);
                end;
            end;
        end;

        u2[p39] = v41;

        return v41;
    end,

    FetchRecipe = function(p43: table, p44: string, p45: any) -- Line: 132, Name: FetchRecipe
        local v46 = p43:FetchRecipeList(p44);

        if v46 then
            return p43:FindRecipe(v46, p45);
        end;
    end,

    FetchRecipeList = function(p47: table, p48: string) -- Line: 138, Name: FetchRecipeList
        -- upvalues: u1 (copy)
        for _, v in pairs(u1) do
            if v.Type == p48 then
                return v.Recipes;
            end;
        end;
    end,

    FindRecipe = function(p49, p50, p51) -- Line: 145, Name: FindRecipe
        for _, v in pairs(p50) do
            if v.ID == p51 then
                return v;
            end;
        end;
    end,

    RefreshCache = function(p52) -- Line: 152, Name: RefreshCache
        -- upvalues: u2 (ref)
        u2 = {};
    end,

    GetAllRecipes = function(p53) -- Line: 156, Name: GetAllRecipes
        -- upvalues: u1 (copy)
        return u1;
    end,

    GetCraftingCategories = function(p54) -- Line: 160, Name: GetCraftingCategories
        -- upvalues: u3 (copy)
        return u3;
    end
};

for _, child in pairs(script:GetChildren()) do
    for _, v in pairs(require(child)) do
        table.insert(u1, v);
    end;
end;

if script:GetAttribute("RandomizeRecipes") then
    local ItemRecipes = require(script:WaitForChild("ItemRecipes"));
    local v56 = {};

    for _, v in ipairs(ItemRecipes) do
        for _, v2 in ipairs(v.Recipes) do
            if v2.Costs then
                table.insert(v56, v2);
            end;
        end;
    end;

    local v57 = {};

    for i, v in ipairs(v56) do
        v57[i] = v.Costs;
    end;

    local v58 = tonumber(script:GetAttribute("RandomSeedRecipes")) or 0;
    Random.new(v58):Shuffle(v57);

    for i, v in ipairs(v56) do
        v.Costs = v57[i];
    end;

    warn((`[RecipeModule] RANDOMIZERECIPES ENABLED - shuffled Costs across {#v56} item recipes (seed {v58}) - DISABLE IF UNINTENDED`));
end;

return v55;
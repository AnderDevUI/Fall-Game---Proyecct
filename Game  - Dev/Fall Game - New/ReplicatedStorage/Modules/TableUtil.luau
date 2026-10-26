-- [PATH] ReplicatedStorage / Modules / TableUtil @Type ModuleScript


return {
    TableRandom = function(p1, p2, p3, p4) -- Line: 12, Name: TableRandom
        local v5 = p3 or 1;
        local v6 = 10 ^ (p4 or 2);

        return type(p2) == "number" and p2 * v5 or math.random(p2[1] * v5 * v6, p2[2] * v5 * v6) / v6;
    end,

    CloneTable = function(p7, p8, p9) -- Line: 19, Name: CloneTable
        local v10 = {};

        for i, v in pairs(p8) do
            local v11;

            if type(v) == "table" and not p9 then
                v11 = p7:CloneTable(v) or v;
            else
                v11 = v;
            end;

            v10[i] = v11;
        end;

        return v10;
    end,

    RandomizeTable = function(p12, p13, p14) -- Line: 27, Name: RandomizeTable
        local v15 = p14 and p13 and p13 or p12:CloneTable(p13);
        local v16 = {};

        for i = 1, #v15 do
            local math_random_ret = math.random(1, #v15);
            table.insert(v16, v15[math_random_ret]);
            table.remove(v15, math_random_ret);
            local _ = i;
        end;

        return v16;
    end,

    CompareTables = function(p17, p18, p19) -- Line: 38, Name: CompareTables
        if #p18 ~= #p19 then
            return false;
        end;

        for i, v in pairs(p18) do
            if v ~= p19[i] then
                return false;
            end;
        end;

        return true;
    end
};
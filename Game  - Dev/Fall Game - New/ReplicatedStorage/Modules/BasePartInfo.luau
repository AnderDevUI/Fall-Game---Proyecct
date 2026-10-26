-- [PATH] ReplicatedStorage / Modules / BasePartInfo @Type ModuleScript


local v2 = {
    Fetch = function(p1) -- Line: 11, Name: Fetch
        return {
            {
                Name = "Foundation",
                Description = "Every base starts from here."
            },
            {
                Name = "Triangle Foundation",
                Description = "Every base starts from here."
            },
            {
                Name = "Foundation Steps",
                Description = "For accessing tall foundations."
            },
            {
                Name = "Wall",
                Description = "Great for keeping people out."
            },
            {
                Name = "Half Wall",
                Description = "Half of a regular wall."
            },
            {
                Name = "Low Wall",
                Description = "Quarter of a regular wall."
            },
            {
                Name = "Wall Frame",
                Description = "Wall outline for placing stuff inside."
            },
            {
                Name = "Doorway",
                Description = "Perfect fit for doors and vending machines."
            },
            {
                Name = "Window",
                Description = "Perfect fit for window panels."
            },
            {
                Name = "Floor",
                Description = "Add more stories to your base."
            },
            {
                Name = "Triangle Floor",
                Description = "Add more stories to your base."
            },
            {
                Name = "Floor Frame",
                Description = "Floor outline for placing stuff inside."
            },
            {
                Name = "Triangle Floor Frame",
                Description = "Triangle Floor outline for placing stuff inside."
            },
            {
                Name = "L-Shaped Stairs",
                Description = "Set of stairs with a 90 degree turn."
            },
            {
                Name = "U-Shaped Stairs",
                Description = "Set of stairs with a 180 degree turn."
            },
            {
                Name = "Ramp",
                Description = "Easier navigation of vehicles onto Foundations."
            }
        };
    end
};
local u3 = v2:Fetch();

function v2.GetIndexFromName(p4: table, p5: string) -- Line: 81
    -- upvalues: u3 (copy)
    for i, v in pairs(u3) do
        if v.Name == p5 then
            return i;
        end;
    end;

    return "";
end;

function v2.GetNameFromIndex(p6: table, p7: userdata) -- Line: 89
    -- upvalues: u3 (copy)
    local v8 = u3[p7];

    if v8 then
        v8 = v8.Name;
    end;

    return v8;
end;

return v2;
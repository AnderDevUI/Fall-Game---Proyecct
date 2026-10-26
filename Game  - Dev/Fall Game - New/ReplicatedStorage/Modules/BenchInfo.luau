

local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("Debris");
local Players = game:GetService("Players");
game:GetService("StarterGui");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Benches = ReplicatedStorage:WaitForChild("Benches");
ReplicatedStorage:WaitForChild("Values");
local VFX = workspace:WaitForChild("VFX");
local v1 = game.PlaceId == 10228136016 and true or game.PlaceId == 16296634952;
local u2, u3;

if v1 then
    u2 = nil;
    u3 = nil;
else
    u2 = require(Modules:WaitForChild("RaycastUtil"));
    u3 = require(Modules:WaitForChild("ActiveBenchModule"));
end;

local _ = Players.LocalPlayer;
local u4 = nil;
local u5;

if v1 then
    u5 = nil;
else
    u5 = u2:FilterFunction("HitPlace");
end;

local function v14(p6, p7, p8, p9, p10) -- Line: 220
    -- upvalues: u4 (ref)
    local v11 = u4[p6];

    if v11 then
        local PlaceableAngles = v11.PlaceableAngles;
        local PlaceBlacklist = v11.PlaceBlacklist;
        local PlaceWhitelist = v11.PlaceWhitelist;
        local TerrainMaterialWhitelist = v11.TerrainMaterialWhitelist;
        local v12;

        if p7 == nil or (PlaceableAngles.Min > p8 or (p8 > PlaceableAngles.Max or (p9 == nil or (p9 ~= p7 or p9.Parent:GetAttribute("Open") ~= nil)))) then
            v12 = false;
        else
            v12 = p9.Parent.Parent:GetAttribute("Open") == nil;
        end;

        if v12 and (PlaceBlacklist or (PlaceWhitelist or TerrainMaterialWhitelist)) then
            local v13 = p9.Name == "Terrain";

            if v13 and (TerrainMaterialWhitelist and not (p10 and table.find(TerrainMaterialWhitelist, p10.Name))) then
                return false;
            end;

            local Parent = p9.Parent;

            if Parent:IsA("Model") and (Parent.Parent ~= game and (Parent.Parent:IsA("Model") and Parent.Name ~= "_Floor")) then
                Parent = Parent.Parent or Parent;
            end;

            if PlaceWhitelist and (v13 and not table.find(PlaceWhitelist, "Terrain") or v13 == false and not table.find(PlaceWhitelist, Parent.Name)) then
                return false;
            end;

            if PlaceBlacklist and (v13 and table.find(PlaceBlacklist, "Terrain") or v13 == false and table.find(PlaceBlacklist, Parent.Name)) then
                return false;
            end;
        end;

        return v12;
    end;
end;

local function v15() -- Line: 245
    return true;
end;

local function u24(p16, p17, p18) -- Line: 249
    -- upvalues: Benches (copy), VFX (copy)
    local PrimaryPart = p16.PrimaryPart;
    local v19 = Benches:FindFirstChild(p16.Name);

    if v19 and (v19:IsA("Model") and PrimaryPart) then
        local Main = v19:FindFirstChild("Main");
        local v20;

        if p18 then
            v20 = v19 or p16;
        else
            v20 = p16;
        end;

        local NonBaseCollisionParts = v20:FindFirstChild("NonBaseCollisionParts");

        if NonBaseCollisionParts and Main then
            if p17 then
                p17 = p17:FindFirstAncestor("Base");
            end;

            local OverlapParams_new_ret = OverlapParams.new();
            OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
            OverlapParams_new_ret.FilterDescendantsInstances = { VFX, p16 };

            for _, child in pairs(NonBaseCollisionParts:GetChildren()) do
                if child:IsA("BasePart") then
                    local v21;

                    if p18 then
                        v21 = child:Clone();
                        v21.Name = "CollisionPart";
                        v21.Transparency = 1;
                        v21.CanCollide = false;
                        v21.CanQuery = false;
                        v21.Parent = VFX;
                        v21.CFrame = PrimaryPart.CFrame * Main.CFrame:ToObjectSpace(child.CFrame);
                    else
                        v21 = nil;
                    end;

                    local PartsInPart = workspace:GetPartsInPart(v21 or child, OverlapParams_new_ret);

                    if v21 then
                        v21:Destroy();
                    end;

                    local v22 = child;

                    for _, v in pairs(PartsInPart) do
                        local v23 = v:FindFirstAncestor("Base");

                        if v23 and (v23 ~= p17 and not (p17 and (v23:GetAttribute("BaseId") == p17:GetAttribute("BaseId") and v22.Name == "CollisionNonFoundy"))) then
                            return false;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return true;
end;

local function u33(p25, p26, p27, p28, p29, p30) -- Line: 301
    -- upvalues: u24 (copy), u2 (ref), VFX (copy), u4 (ref), u5 (ref)
    if p26 and not u24(p25, p27) then
        return false;
    end;

    local RayParts = p25:FindFirstChild("RayParts");

    if RayParts then
        for _, child in pairs(RayParts:GetChildren()) do
            local CFrame2 = child.CFrame;
            local Size = child.Size;

            for i = -1, 1, 2 do
                local Position = (CFrame2 * CFrame.new(0, 0, -Size.Z / 2 * i)).Position;

                if u2:Raycast(Position, (CFrame2 * CFrame.new(0, 0, Size.Z / 2 * i)).Position - Position, "Whitelist", workspace.Terrain) then
                    return false;
                end;

                local _ = i;
            end;
        end;
    end;

    local OverlapParams_new_ret = OverlapParams.new();
    OverlapParams_new_ret.FilterType = Enum.RaycastFilterType.Exclude;
    OverlapParams_new_ret.FilterDescendantsInstances = { VFX };
    local BaseCollisionParts = p25:FindFirstChild("BaseCollisionParts");

    if BaseCollisionParts then
        for _, child in pairs(BaseCollisionParts:GetChildren()) do
            if child:IsA("BasePart") then
                local PartsInPart = workspace:GetPartsInPart(child, OverlapParams_new_ret);

                for _, v in pairs(PartsInPart) do
                    local Parent = v.Parent;

                    if Parent.Name == "CollisionParts" and v:FindFirstAncestor("Base") then
                        local v31 = u4[Parent.Parent.Name];

                        if v31 and v31.Type == "BasePart" then
                            return false;
                        end;
                    end;
                end;
            end;
        end;
    end;

    local CollisionParts = p25:FindFirstChild("CollisionParts");

    if CollisionParts then
        for _, child in pairs(CollisionParts:GetChildren()) do
            if child:IsA("BasePart") then
                local _ = child.CFrame;
                local _ = child.Size;
                local PartsInPart = workspace:GetPartsInPart(child, OverlapParams_new_ret);
                local v32 = child;

                for _, v in pairs(PartsInPart) do
                    if not (p29 ~= false and (p28 == "BasePart" or (p28 == "Door" or p29)) and v.Name == "BoulderPart" or (v.Name == "CollisionRug" and v32.Name ~= "CollisionRug" or (v32.Name == "CollisionIgnoreSame" and v.Name == "CollisionIgnoreSame" or (v32.Name == "CollisionFloorFrame" and v.Name == "CollisionLargeFurnace" or (v.Name == "CollisionFloorFrame" and v32.Name == "CollisionLargeFurnace" or (v.Parent and v.Parent.Name == "_Floor" or (u5(v) or v32.Name == "CollisionSameOnly" and v.Name ~= "CollisionSameOnly" or v.Name == "CollisionSameOnly" and v32.Name ~= "CollisionSameOnly"))))))) then
                        return false;
                    end;
                end;
            end;
        end;
    end;

    return true;
end;

local function v47(...) -- Line: 379
    -- upvalues: u2 (ref), VFX (copy), u5 (ref), u33 (copy)
    local v34 = { ... };
    local v35 = v34[1];

    if v34[5] == false and v34[6] then
        v34[5] = true;
    end;

    local v36 = 0;
    local v37 = 0;

    for _, child in pairs(v35:GetChildren()) do
        if child.Name == "Pole" then
            v36 = v36 + 1;
            local CFrame2 = child.CFrame;
            local Size = child.Size;
            local Position = (CFrame2 * CFrame.new(0, Size.Y / 2.4 + 0.3, 0)).Position;
            local v38 = { VFX };
            local v39 = u2:Raycast(Position, (CFrame2 * CFrame.new(0, -Size.Y / 2.1, 0)).Position - Position, "Blacklist", v38, false, u5, true);

            if v39 then
                if v39 ~= workspace.Terrain and (v39.Name ~= "BoulderPart" and (not v39.Parent or v39.Parent.Name ~= "_Floor")) then
                    return false;
                end;
            else
                local v40 = Position + Vector3.new(0, 199, 0);
                local v41 = Position - Vector3.new(0, 1, 0);
                local v42 = false;
                local v43 = nil;

                for i = 1, 3 do
                    local v44, v45 = u2:Raycast(v40, v41 - v40, "Whitelist", { workspace.Terrain }, false, nil, true);

                    if v44 ~= workspace.Terrain then
                        if i ~= 2 or not u2:Raycast(v45, v43 - v45, "Whitelist", { workspace.Terrain }, false, nil, true) then
                            local v46 = v40.Y - v45.Y;

                            if i > 1 then
                                v42 = v46 >= 10;
                            else
                                v42 = false;
                            end;
                        end;

                        break;
                    end;

                    v43 = v40;
                    v40 = v45 - Vector3.new(0, 0.01, 0);
                    local _ = i;
                end;

                if not v42 then
                    return false;
                end;

                v37 = v37 + 1;
            end;

            if not (v34[5] or (not v39 or v39.Name ~= "BoulderPart")) then
                v34[5] = true;
            end;
        end;
    end;

    if v36 <= v37 and v36 > 0 then
        return false;
    end;

    return u33(unpack(v34));
end;

local function v55(p48, p49) -- Line: 445
    local v50 = {};

    for i = 1, p48 do
        local v51, v52, v53, v54 = p49(i);
        table.insert(v50, {
            BenchNames = v52,
            Offset = v51,
            AttachmentIndex = v53,
            Unsnappable = v54
        });
        local _ = i;
    end;

    return v50;
end;

local function _(p56, p57) -- Line: 459
    local v58 = {};

    for i = 1, p56 do
        local v59, v60, v61 = p57(i);
        local _ = i;
        local v62 = {
            AttachmentIndex = v61,
            Rays = {}
        };

        for i2, v in pairs(v59) do
            table.insert(v62.Rays, {
                Offset = v,
                Length = v60[i2]
            });
        end;

        table.insert(v58, v62);
    end;

    return v58;
end;

local v63 = {
    SnapPoints = {
        {
            AttachmentIndex = 5,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(0, 5, 5)
        },
        {
            AttachmentIndex = 6,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 5, 5)
        },
        {
            AttachmentIndex = 7,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(0, 5, 5)
        },
        {
            AttachmentIndex = 8,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(0, 5, 5)
        },
        {
            AttachmentIndex = 4,
            BenchNames = { "Triangle Foundation", "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(-5, 0, 4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1)
        },
        {
            AttachmentIndex = 5,
            BenchNames = { "Triangle Foundation", "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(-5, 2.5, 0, 0, -1, 0, -0.5, 0, 0.866, -0.866, 0, -0.5)
        },
        {
            AttachmentIndex = 6,
            BenchNames = { "Triangle Foundation", "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(-5, -2.5, 0, 0, -1, 0, -0.5, 0, -0.866, 0.866, 0, -0.5)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window" },
            Offset = CFrame.new(0, 10, 0)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Half Wall" },
            Offset = CFrame.new(0, 7.5, 0)
        }
    },
    AttachmentChecks = {
        {
            MaxRange = 13,
            BenchNames = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame" },
            Checks = {
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, -4.3, 0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, -4.3, 0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, -4.3, -0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, -4.3, -0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                }
            }
        },
        {
            MaxRange = 13,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window", "Half Wall" },
            Checks = {
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(0, 4.8, 0) * CFrame.Angles(1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(0, -4.8, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 5,
                    Rays = {
                        {
                            Length = 0.2,
                            Offset = CFrame.new(-5.6, -2.5, 0.6) * CFrame.Angles(0, 0, 0)
                        },
                        {
                            Length = 0.2,
                            Offset = CFrame.new(-5.6, -2.5, -0.6) * CFrame.Angles(3.141592653589793, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 6,
                    Rays = {
                        {
                            Length = 0.2,
                            Offset = CFrame.new(-5.6, 2.5, 0.6) * CFrame.Angles(0, 0, 0)
                        },
                        {
                            Length = 0.2,
                            Offset = CFrame.new(-5.6, 2.5, -0.6) * CFrame.Angles(3.141592653589793, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 7,
                    Rays = {
                        {
                            Length = 0.2,
                            Offset = CFrame.new(5.6, -2.5, 0.6) * CFrame.Angles(0, 0, 0)
                        },
                        {
                            Length = 0.2,
                            Offset = CFrame.new(5.6, -2.5, -0.6) * CFrame.Angles(3.141592653589793, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 8,
                    Rays = {
                        {
                            Length = 0.2,
                            Offset = CFrame.new(5.6, 2.5, 0.6) * CFrame.Angles(0, 0, 0)
                        },
                        {
                            Length = 0.2,
                            Offset = CFrame.new(5.6, 2.5, -0.6) * CFrame.Angles(3.141592653589793, 0, 0)
                        }
                    }
                }
            }
        },
        {
            MaxRange = 9,
            BenchNames = { "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame" },
            Checks = {
                {
                    AttachmentIndex = 9,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, 4.3, 0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, 4.3, 0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 10,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, 4.3, -0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, 4.3, -0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 11,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, -0.7, 0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, -0.7, 0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 12,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, -0.7, -0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, -0.7, -0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        }
                    }
                }
            }
        }
    },
    StabilityInfo = {
        LossPerHeight = {
            Start = 0,
            PerStud = 1
        },
        Checks = { {
                Connections = { 4 },
                StabilityLoss = { 0 }
            }, {
                Connections = { 1, 2 },
                StabilityLoss = { 0, 0 },
                BenchNames = { "Foundation", "Triangle Foundation" }
            }, {
                Connections = { 1, 2 },
                StabilityLoss = { 20, 10 }
            }, {
                Connections = { 5, 6, 7, 8 },
                StabilityLoss = { 75, 60, 45, 40 }
            } }
    },
    NextConnections = { 1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12 }
};
local v64 = {
    SnapPoints = {
        {
            AttachmentIndex = 1,
            BenchNames = { "Floor", "Floor Frame" },
            Offset = CFrame.new(0, 0, 10)
        },
        {
            AttachmentIndex = 2,
            BenchNames = { "Floor", "Floor Frame" },
            Offset = CFrame.new(0, 0, -10)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Floor", "Floor Frame" },
            Offset = CFrame.new(10, 0, 0)
        },
        {
            AttachmentIndex = 4,
            BenchNames = { "Floor", "Floor Frame" },
            Offset = CFrame.new(-10, 0, 0)
        },
        {
            AttachmentIndex = 1,
            BenchNames = { "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(0, 0, 9.333, 0, -1, 0, 0, 0, 1, -1, 0, 0)
        },
        {
            AttachmentIndex = 2,
            BenchNames = { "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(0, 6.83, -2.497, 0, -1, 0, 0.5, 0, -0.866, 0.866, 0, 0.5)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(0, -6.83, -2.497, 0, -1, 0, 0.866, 0, -0.5, 0.5, 0, 0.866)
        },
        {
            AttachmentIndex = 9,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window" },
            Offset = CFrame.new(0, 5, 5)
        },
        {
            AttachmentIndex = 10,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window" },
            Offset = CFrame.new(0, 5, -5)
        },
        {
            AttachmentIndex = 9,
            BenchNames = { "Half Wall" },
            Offset = CFrame.new(0, 2.5, 5)
        },
        {
            AttachmentIndex = 10,
            BenchNames = { "Half Wall" },
            Offset = CFrame.new(0, 2.5, -5)
        }
    },
    AttachmentChecks = {
        {
            MaxRange = 11,
            BenchNames = { "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame" },
            Checks = {
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                }
            }
        },
        {
            MaxRange = 9,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window", "Half Wall", "Low Wall", "Wall Block" },
            Checks = {
                {
                    AttachmentIndex = 5,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(4, 0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-4, 0.6, -4.3)
                        }
                    }
                },
                {
                    AttachmentIndex = 6,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(4, 0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(-4, 0.6, -4.3)
                        }
                    }
                },
                {
                    AttachmentIndex = 7,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(4, 0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-4, 0.6, -4.3)
                        }
                    }
                },
                {
                    AttachmentIndex = 8,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(4, 0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(-4, 0.6, -4.3)
                        }
                    }
                },
                {
                    AttachmentIndex = 9,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(4, -0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-4, -0.6, -4.3)
                        }
                    }
                },
                {
                    AttachmentIndex = 10,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(4, -0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(-4, -0.6, -4.3)
                        }
                    }
                },
                {
                    AttachmentIndex = 11,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(4, -0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-4, -0.6, -4.3)
                        }
                    }
                },
                {
                    AttachmentIndex = 12,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(4, -0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(-4, -0.6, -4.3)
                        }
                    }
                }
            }
        }
    },
    StabilityInfo = {
        Checks = { {
                Connections = { 9, 10, 11, 12 },
                StabilityLoss = { 15, 8, 4, 0 }
            }, {
                Connections = { 1, 2, 3, 4 },
                StabilityLoss = { 75, 25, 10, 5 }
            } }
    },
    NextConnections = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 }
};
local v65 = {
    SnapPoints = {
        {
            AttachmentIndex = 1,
            BenchNames = { "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(0, 0, 8.666, 1, 0, 0, 0, -1, 0, 0, 0, -1)
        },
        {
            AttachmentIndex = 2,
            BenchNames = { "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(0, 3.748, -2.167, 1, 0, 0, 0, 0.5, 0.866, 0, -0.866, 0.5)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(0, -3.748, -2.167, 1, 0, 0, 0, 0.5, -0.866, 0, 0.866, 0.5)
        },
        {
            AttachmentIndex = 1,
            BenchNames = { "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 0, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1)
        },
        {
            AttachmentIndex = 2,
            BenchNames = { "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(0, 0, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(0, 0, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1)
        },
        {
            AttachmentIndex = 4,
            BenchNames = { "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(0, 0, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1)
        },
        {
            AttachmentIndex = 9,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window" },
            Offset = CFrame.new(0, 5, 4.333, 0, 1, 0, 1, 0, 0, 0, 0, -1) * CFrame.Angles(0, 0, 3.141592653589793)
        },
        {
            AttachmentIndex = 10,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window" },
            Offset = CFrame.new(0, 5, -4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1) * CFrame.Angles(0, 0, 3.141592653589793)
        },
        {
            AttachmentIndex = 9,
            BenchNames = { "Half Wall" },
            Offset = CFrame.new(0, 2.5, 4.333, 0, 1, 0, 1, 0, 0, 0, 0, -1) * CFrame.Angles(0, 0, 3.141592653589793)
        },
        {
            AttachmentIndex = 10,
            BenchNames = { "Half Wall" },
            Offset = CFrame.new(0, 2.5, -4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1) * CFrame.Angles(0, 0, 3.141592653589793)
        }
    },
    AttachmentChecks = {
        {
            MaxRange = 9,
            BenchNames = { "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame" },
            Checks = {
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, -4, -4.1)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, -4, -4.1)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(0, 5, -1.9)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(0, -2.6, -1.9)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(0, -5, -1.9)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(0, 2.6, -1.9)
                        }
                    }
                }
            }
        },
        {
            MaxRange = 9,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window", "Half Wall", "Low Wall", "Wall Block" },
            Checks = {
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0.6, 4, -3.6)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0.6, -4, -3.6)
                        }
                    }
                },
                {
                    AttachmentIndex = 5,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(-0.6, 5, -1.6)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(-0.6, -2.6, -1.6)
                        }
                    }
                },
                {
                    AttachmentIndex = 6,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(-0.6, -5, -1.6)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(-0.6, 2.6, -1.6)
                        }
                    }
                },
                {
                    AttachmentIndex = 7,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-0.6, 4, -3.6)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-0.6, -4, -3.6)
                        }
                    }
                },
                {
                    AttachmentIndex = 8,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(0.6, 5, -1.6)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(0.6, -2.6, -1.6)
                        }
                    }
                },
                {
                    AttachmentIndex = 9,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(0.6, -5, -1.6)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(0.6, 2.6, -1.6)
                        }
                    }
                }
            }
        }
    },
    StabilityInfo = {
        Checks = { {
                Connections = { 7, 8, 9 },
                StabilityLoss = { 12, 5, 0 }
            }, {
                Connections = { 1, 2, 3 },
                StabilityLoss = { 55, 16, 4 }
            } }
    },
    NextConnections = { 1, 2, 3, 4, 5, 6, 7, 8, 9 }
};
local v66 = {
    SnapPoints = {
        {
            AttachmentIndex = 9,
            BenchNames = { "Foundation" },
            Offset = CFrame.new(0, 5, 0)
        },
        {
            AttachmentIndex = 13,
            BenchNames = { "Floor" },
            Offset = CFrame.new(0, 5, 0)
        }
    },
    AttachmentChecks = {
        {
            MaxRange = 13,
            BenchNames = { "Foundation", "Floor" },
            Checks = {
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(0, -4.3, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                }
            }
        }
    },
    StabilityInfo = {
        Checks = { {
                Connections = { 1 },
                StabilityLoss = { 4 }
            } }
    },
    NextConnections = {}
};
local v67 = {
    {
        AttachmentIndex = 1,
        BenchNames = { "Small Planter Box" },
        Offset = CFrame.new(
            -3.04852295,
            -0.0426025391,
            0.180847168,
            0.000198172173,
            -0.999999166,
            -0.00133319281,
            0.0485480651,
            0.00134124164,
            -0.998820007,
            0.998820901,
            0.000133209614,
            0.0485482886
        )
    },
    {
        AttachmentIndex = 2,
        BenchNames = { "Small Planter Box" },
        Offset = CFrame.new(
            -0.0485839844,
            0.00329589844,
            0.178070068,
            0.000198172173,
            -0.999999166,
            -0.00133319281,
            0.0485480651,
            0.00134124164,
            -0.998820007,
            0.998820901,
            0.000133209614,
            0.0485482886
        )
    },
    {
        AttachmentIndex = 3,
        BenchNames = { "Small Planter Box" },
        Offset = CFrame.new(
            2.95129395,
            -0.0810546875,
            0.181518555,
            0.000198172173,
            -0.999999166,
            -0.00133319281,
            0.0485480651,
            0.00134124164,
            -0.998820007,
            0.998820901,
            0.000133209614,
            0.0485482886
        )
    },
    {
        AttachmentIndex = 1,
        BenchNames = { "Large Planter Box" },
        Offset = CFrame.new(
            -3.04980469,
            -0.346435547,
            -2.7623291,
            0.0000451527958,
            -0.999999166,
            -0.00134708302,
            -0.065404892,
            0.00134124537,
            -0.997857988,
            0.997858882,
            0.000133157082,
            -0.0654047728
        )
    },
    {
        AttachmentIndex = 2,
        BenchNames = { "Large Planter Box" },
        Offset = CFrame.new(
            -0.0495605469,
            -0.140869141,
            -2.74920654,
            0.0000451527958,
            -0.999999166,
            -0.00134708302,
            -0.065404892,
            0.00134124537,
            -0.997857988,
            0.997858882,
            0.000133157082,
            -0.0654047728
        )
    },
    {
        AttachmentIndex = 3,
        BenchNames = { "Large Planter Box" },
        Offset = CFrame.new(
            2.95007324,
            -0.304443359,
            -2.7598877,
            0.0000451901615,
            -0.999999225,
            -0.00134708313,
            -0.0654048994,
            0.00134124281,
            -0.997858107,
            0.997858882,
            0.000133202921,
            -0.0654047877
        )
    },
    {
        AttachmentIndex = 4,
        BenchNames = { "Large Planter Box" },
        Offset = CFrame.new(
            -3.04907227,
            -0.1640625,
            0.234375,
            0.0000451527958,
            -0.999999166,
            -0.00134708302,
            -0.065404892,
            0.00134124537,
            -0.997857988,
            0.997858882,
            0.000133157082,
            -0.0654047728
        )
    },
    {
        AttachmentIndex = 5,
        BenchNames = { "Large Planter Box" },
        Offset = CFrame.new(
            -0.0491943359,
            -0.138061523,
            0.235839844,
            0.0000451901615,
            -0.999999225,
            -0.00134708313,
            -0.0654048994,
            0.00134124281,
            -0.997858107,
            0.997858882,
            0.000133202921,
            -0.0654047877
        )
    },
    {
        AttachmentIndex = 6,
        BenchNames = { "Large Planter Box" },
        Offset = CFrame.new(
            2.95056152,
            -0.252197266,
            0.228271484,
            0.0000451901615,
            -0.999999225,
            -0.00134708313,
            -0.0654048994,
            0.00134124281,
            -0.997858107,
            0.997858882,
            0.000133202921,
            -0.0654047877
        )
    },
    {
        AttachmentIndex = 7,
        BenchNames = { "Large Planter Box" },
        Offset = CFrame.new(
            -3.04858398,
            -0.106323242,
            2.89944458,
            0.0000451527958,
            -0.999999166,
            -0.00134708302,
            -0.065404892,
            0.00134124537,
            -0.997857988,
            0.997858882,
            0.000133157082,
            -0.0654047728
        )
    },
    {
        AttachmentIndex = 8,
        BenchNames = { "Large Planter Box" },
        Offset = CFrame.new(
            -0.0487060547,
            -0.0705566406,
            2.90161133,
            0.0000451527958,
            -0.999999166,
            -0.00134708302,
            -0.065404892,
            0.00134124537,
            -0.997857988,
            0.997858882,
            0.000133157082,
            -0.0654047728
        )
    },
    {
        AttachmentIndex = 9,
        BenchNames = { "Large Planter Box" },
        Offset = CFrame.new(
            2.95080566,
            -0.274169922,
            2.88803101,
            0.0000451901615,
            -0.999999225,
            -0.00134708313,
            -0.0654048994,
            0.00134124281,
            -0.997858107,
            0.997858882,
            0.000133202921,
            -0.0654047877
        )
    }
};

local function _(u68) -- Line: 1310
    return {
        Type = "Container",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 3.5, 0),
        InteractDistance = 9,

        TypeArguments = function() -- Line: 1313, Name: TypeArguments
            -- upvalues: u68 (copy)
            return {
                UI = "Container30",
                ResizeDynamically = true,
                CombineItems = true,
                DestroyOnEmpty = true,
                ShuffleItems = true,
                Slots = table.create(30, "Output"),
                LootTable = { "Benches", u68 }
            };
        end
    };
end;

local v82 = {
    Campfire = {
        Type = "Campfire",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        DecayMultiplier = 3,
        PickupBehavior = false,
        DemolishTimerMult = (1 / 0),
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 2, 0),
        RayCheckLength = 0.5,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1336, Name: TypeArguments
            return {
                UI = "Campfire",
                IgnoreGatherMult = true,
                ResizeDynamically = false,
                CombineItems = true,
                FuelMult = 1,
                InputMult = 1,
                Comfort = 40,
                Heat = 6,
                Slots = { "FuelWood", "InputCampfire", "Output", "Output" },
                LootTable = { "Benches", "Campfire" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 0.4, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Cooking Pot"] = {
        Type = "Campfire",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = false,
        DemolishTimerMult = (1 / 0),
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 2, 0),
        RayCheckLength = 0.5,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1373, Name: TypeArguments
            return {
                UI = "Furnace",
                IgnoreGatherMult = true,
                ResizeDynamically = false,
                CombineItems = true,
                FuelMult = 1,
                InputMult = 0.5,
                Comfort = 50,
                Heat = 6,
                Slots = { "FuelWood", "InputCampfire", "InputCampfire", "Output", "Output", "Output" },
                LootTable = { "Benches", "Campfire" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 0.4, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33,
        Sounds = {
            Open = "PotOpen"
        }
    },
    Furnace = {
        Type = "Campfire",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 2, 0),
        RayCheckLength = 2.7,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1413, Name: TypeArguments
            return {
                UI = "Furnace",
                ResizeDynamically = false,
                FuelMult = 0.2,
                InputMult = 1,
                Comfort = 5,
                Heat = 3,
                Slots = { "FuelWood", "InputFurnace", "InputFurnace", "Output", "Output", "Output" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 2.5, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33,
        Sounds = {
            Open = "FurnaceOpen"
        }
    },
    ["Large Furnace"] = {
        Type = "Campfire",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 9,
        PlaceExtraDistance = 5,
        InteractDistance = 11,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1449, Name: TypeArguments
            return {
                UI = "LargeFurnace",
                ResizeDynamically = false,
                FuelMult = 0.2,
                InputMult = 0.8,
                Comfort = 10,
                Heat = 3,
                Slots = { "FuelWood", "FuelWood", "InputFurnace", "InputFurnace", "InputFurnace", "InputFurnace", "InputFurnace", "Output", "Output", "Output", "Output", "Output", "Output", "Output", "Output", "Output", "Output" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 8.8, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 20
        },
        PlaceWhitelist = { "Terrain", "_Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Blast Furnace"] = {
        Type = "Campfire",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 4.75,
        PlaceExtraDistance = 5,
        InteractDistance = 11,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1484, Name: TypeArguments
            return {
                UI = "BlastFurnace",
                ResizeDynamically = false,
                FuelMult = 0.15,
                InputMult = 0.9,
                Comfort = 5,
                Heat = 3,
                Slots = { "FuelWood", "InputFurnace", "InputFurnace", "InputFurnace", "InputFurnace", "Output", "Output", "Output", "Output", "Output" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 3.2, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 20
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Petroleum Refinery"] = {
        Type = "Campfire",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 4.7,
        PlaceExtraDistance = 2,
        InteractDistance = 8,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1519, Name: TypeArguments
            return {
                UI = "Refinery",
                ResizeDynamically = false,
                FuelMult = 0.15,
                InputMult = 1,
                Comfort = 5,
                Heat = 3,
                Slots = { "FuelWood", "InputPetroleum", "Output", "Output", "Output" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 4.55, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 30
        },
        PlaceWhitelist = { "Terrain", "_Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    Loom = {
        Type = "SmeltNoFuel",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        DecayMultiplier = 3,
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0.5, 0),
        RayCheckLength = 2.7,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1555, Name: TypeArguments
            return {
                UI = "Loom",
                ResizeDynamically = false,
                InputMult = 1,
                AutoTurnOn = true,
                Slots = { "InputLoom", "InputLoom", "Output", "Output", "Output" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 2.6, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Cow Pasture"] = {
        Type = "SmeltNoFuel",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = false,
        DemolishTimerMult = (1 / 0),
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0.5, 0),
        RayCheckLength = 3,
        FaceCamera = true,
        RotateOnSurface = true,
        PlaceExtraDistance = 2.5,
        InteractDistance = 10,

        TypeArguments = function() -- Line: 1588, Name: TypeArguments
            return {
                UI = "Feed",
                ResizeDynamically = false,
                InputMult = 1,
                AutoTurnOn = true,
                Slots = { "InputAnimal", "Output", "Output" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 2.7, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 25
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Chicken House"] = {
        Type = "SmeltNoFuel",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = false,
        DemolishTimerMult = (1 / 0),
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0.5, 0),
        RayCheckLength = 2.2,
        FaceCamera = true,
        RotateOnSurface = true,
        PlaceExtraDistance = 0.5,
        InteractDistance = 7,

        TypeArguments = function() -- Line: 1622, Name: TypeArguments
            return {
                UI = "Feed",
                ResizeDynamically = false,
                InputMult = 1,
                AutoTurnOn = true,
                Slots = { "InputAnimal", "Output", "Output" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 2, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 25
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Base Cabinet"] = {
        Type = "BaseCabinet",
        DecayType = "Never",
        DamageType = "Wood",
        MeleeResistance = 0.4,
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 3.4,
        FaceCamera = true,
        RotateOnSurface = true,
        MaxPerBase = 1,

        TypeArguments = function() -- Line: 1656, Name: TypeArguments
            return {
                UI = "Base Cabinet",
                ResizeDynamically = false,
                Slots = { "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "Resources", "BuildingTools", "BuildingTools" }
            };
        end,

        ClientFunction = function(p69) -- Line: 1663, Name: ClientFunction
            -- upvalues: u3 (ref)
            local ClientInfo = u3.GetClientInfo(p69);

            if type(ClientInfo) ~= "table" then
                return;
            end;

            if ClientInfo.Access then
                return "OPEN", 3;
            end;
        end,

        FireDamageMults = {
            ["Combustive Arrow"] = 7.5,
            ["Combustive Rocket"] = 2,
            Bullet = 2
        },
        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 3.2, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 5
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33,
        Sounds = {
            Open = "BoxOpen",
            OpenServer = "CabinetOpenServer"
        }
    },
    ["Clan Table"] = {
        Type = "ClanTable",
        DecayType = "Never",
        DamageType = "Wood",
        MeleeResistance = 0.4,
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 2, 0),
        RayCheckLength = 4,
        FaceCamera = true,
        RotateOnSurface = true,
        MaxPerBase = 1,

        TypeArguments = function() -- Line: 1703, Name: TypeArguments
            return {
                UI = "Clan Table",
                ResizeDynamically = false,
                Slots = {}
            };
        end,

        ClientFunction = function(p70) -- Line: 1710, Name: ClientFunction
            -- upvalues: u3 (ref)
            local ClientInfo = u3.GetClientInfo(p70);

            if type(ClientInfo) ~= "table" then
                return;
            end;

            if ClientInfo.Access then
                return "OPEN", 3;
            end;
        end,

        FireDamageMults = {
            ["Combustive Arrow"] = 7.5,
            ["Combustive Rocket"] = 2,
            Bullet = 2
        },
        Offset = CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 1.38, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    Anvil = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0.25, 0),
        RayCheckLength = 1.3,
        PlaceExtraDistance = 1,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1748, Name: TypeArguments
            return {
                UI = "CraftingStation",
                Slots = {}
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 1.5707963267948966, 0) * CFrame.new(0, 1.2, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Chemistry Lab"] = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0.5, 0),
        RayCheckLength = 2,
        PlaceExtraDistance = 1,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1777, Name: TypeArguments
            return {
                UI = "CraftingStation",
                Slots = {}
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 1.9, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Carpentry Table"] = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0.25, 0),
        RayCheckLength = 1.4,
        PlaceExtraDistance = 2,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1806, Name: TypeArguments
            return {
                UI = "CraftingStation",
                Slots = {}
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 1.3, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Sewing Table"] = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0.25, 0),
        RayCheckLength = 1.4,
        PlaceExtraDistance = 1,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1835, Name: TypeArguments
            return {
                UI = "CraftingStation",
                Slots = {}
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 1.3, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Ammo Press"] = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0.25, 0),
        RayCheckLength = 1,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1864, Name: TypeArguments
            return {
                UI = "CraftingStation",
                Slots = {}
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 0.9, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Culinary Table"] = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0.25, 0),
        RayCheckLength = 1.35,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1892, Name: TypeArguments
            return {
                UI = "CraftingStation",
                Slots = {}
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 1.25, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Sleeping Bag"] = {
        Type = "Bed",
        DecayType = "Never",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.35,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 1921, Name: TypeArguments
            return {
                Timer = 300
            };
        end,

        ClientFunction = function(p71) -- Line: 1926, Name: ClientFunction
            -- upvalues: u3 (ref)
            local ClientInfo = u3.GetClientInfo(p71);

            if type(ClientInfo) ~= "table" then
                return;
            end;

            if ClientInfo.Owned then
                return "RENAME BED", 2;
            end;
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.26, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    Bed = {
        Type = "Bed",
        DecayType = "Never",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 1.9,
        FaceCamera = true,
        RotateOnSurface = true,
        InteractDistance = 7,
        PlaceExtraDistance = 2,

        TypeArguments = function() -- Line: 1955, Name: TypeArguments
            return {
                Timer = 120
            };
        end,

        ClientFunction = function(p72) -- Line: 1960, Name: ClientFunction
            -- upvalues: u3 (ref)
            local ClientInfo = u3.GetClientInfo(p72);

            if type(ClientInfo) ~= "table" then
                return;
            end;

            if ClientInfo.Owned then
                return "RENAME BED", 2;
            end;
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 1.8, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Wool Plant Seed"] = {
        Type = "Plant",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.25,
        FaceCamera = true,
        RotateOnSurface = true,
        SnapOnly = nil,

        TypeArguments = function() -- Line: 1992, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.1, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain" },
        TerrainMaterialWhitelist = { "Grass", "LeafyGrass" },
        PlacingFunc = v14,
        SnappedPlacingFunc = v15,
        CollisionFunc = u33,
        SnapPoints = v67
    },
    ["Tomato Plant Seed"] = {
        Type = "Plant",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.25,
        FaceCamera = true,
        RotateOnSurface = true,
        SnapOnly = nil,

        TypeArguments = function() -- Line: 2019, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.1, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain" },
        TerrainMaterialWhitelist = { "Grass", "LeafyGrass" },
        PlacingFunc = v14,
        SnappedPlacingFunc = v15,
        CollisionFunc = u33,
        SnapPoints = v67
    },
    ["Corn Plant Seed"] = {
        Type = "Plant",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.25,
        FaceCamera = true,
        RotateOnSurface = true,
        SnapOnly = nil,

        TypeArguments = function() -- Line: 2046, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.1, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain" },
        TerrainMaterialWhitelist = { "Grass", "LeafyGrass" },
        PlacingFunc = v14,
        SnappedPlacingFunc = v15,
        CollisionFunc = u33,
        SnapPoints = v67
    },
    ["Lemon Plant Seed"] = {
        Type = "Plant",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.25,
        FaceCamera = true,
        RotateOnSurface = true,
        SnapOnly = nil,

        TypeArguments = function() -- Line: 2073, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.1, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain" },
        TerrainMaterialWhitelist = { "Grass", "LeafyGrass" },
        PlacingFunc = v14,
        SnappedPlacingFunc = v15,
        CollisionFunc = u33,
        SnapPoints = v67
    },
    ["Raspberry Plant Seed"] = {
        Type = "Plant",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.25,
        FaceCamera = true,
        RotateOnSurface = true,
        SnapOnly = nil,

        TypeArguments = function() -- Line: 2100, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.1, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain" },
        TerrainMaterialWhitelist = { "Grass", "LeafyGrass" },
        PlacingFunc = v14,
        SnappedPlacingFunc = v15,
        CollisionFunc = u33,
        SnapPoints = v67
    },
    ["Blueberry Plant Seed"] = {
        Type = "Plant",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.25,
        FaceCamera = true,
        RotateOnSurface = true,
        SnapOnly = nil,

        TypeArguments = function() -- Line: 2127, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.1, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain" },
        TerrainMaterialWhitelist = { "Grass", "LeafyGrass" },
        PlacingFunc = v14,
        SnappedPlacingFunc = v15,
        CollisionFunc = u33,
        SnapPoints = v67
    },
    ["Pumpkin Plant Seed"] = {
        Type = "Plant",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.25,
        FaceCamera = true,
        RotateOnSurface = true,
        SnapOnly = nil,

        TypeArguments = function() -- Line: 2154, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.1, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain" },
        TerrainMaterialWhitelist = { "Grass", "LeafyGrass" },
        PlacingFunc = v14,
        SnappedPlacingFunc = v15,
        CollisionFunc = u33,
        SnapPoints = v67
    },
    ["Small Planter Box"] = {
        Type = "Snapper",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.9,
        FaceCamera = true,
        RotateOnSurface = true,
        PlaceExtraDistance = 1,

        TypeArguments = function() -- Line: 2182, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.76, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Large Planter Box"] = {
        Type = "Snapper",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.9,
        FaceCamera = true,
        RotateOnSurface = true,
        PlaceExtraDistance = 3,
        InteractDistance = 8,

        TypeArguments = function() -- Line: 2208, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.76, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Small Storage Box"] = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 1.1,
        FaceCamera = true,
        RotateOnSurface = true,
        DurabilityDecrease = 0.25,

        TypeArguments = function() -- Line: 2235, Name: TypeArguments
            return {
                UI = "Container12",
                ResizeDynamically = false,
                Slots = table.create(12, "Default")
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.95, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33,
        Sounds = {
            Open = "BoxOpen"
        }
    },
    ["Large Storage Box"] = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 1.4,
        FaceCamera = true,
        RotateOnSurface = true,
        DurabilityDecrease = 0.25,
        InteractDistance = 8,
        PlaceExtraDistance = 1.5,

        TypeArguments = function() -- Line: 2268, Name: TypeArguments
            return {
                UI = "Container30",
                ResizeDynamically = false,
                Slots = table.create(30, "Default")
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 1.3, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33,
        Sounds = {
            Open = "BoxOpen"
        }
    },
    ["Armor Stand"] = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 2, 0),
        RayCheckLength = 1.4,
        FaceCamera = true,
        RotateOnSurface = true,
        DurabilityDecrease = 0.25,
        InteractDistance = 7,
        PlaceExtraDistance = 1,

        TypeArguments = function() -- Line: 2303, Name: TypeArguments
            return {
                UI = "ArmorStand",
                ResizeDynamically = false,
                OnePersonOnly = true,
                Slots = table.create(13, "Output")
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 1.25, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33,
        Sounds = {
            Open = "BoxOpen"
        }
    },
    ["Shop Machine"] = {
        Type = "Shop",
        InteractDistance = 9,
        DecayType = "Upkeep",
        DamageType = "Metal",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        FaceCamera = true,
        SnapOnly = true,

        TypeArguments = function(p73) -- Line: 2340, Name: TypeArguments
            return {
                UI = "Container30",
                ResizeDynamically = false,
                Slots = table.create(30, "Default")
            };
        end,

        ClientFunction = function(p74) -- Line: 2353, Name: ClientFunction
            -- upvalues: u3 (ref)
            local ClientInfo = u3.GetClientInfo(p74);

            if type(ClientInfo) ~= "table" then
                return;
            end;

            if not ClientInfo.CanEdit then
                return "SHOP", 1;
            end;
        end,

        Offset = CFrame.Angles(0, 3.141592653589793, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
        OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
        PlacingFunc = v15,
        CollisionFunc = u33,
        SnapPoints = {
            {
                AttachmentIndex = 13,
                BenchNames = { "Doorway" },
                Offset = CFrame.new(0.04, -1.2, 0.4)
            }
        },
        WallBlockOffset = CFrame.new(0, -2, 0),
        Sounds = {
            Open = "BoxOpen",
            Open2 = "ShopOpen"
        }
    },
    ["Wooden Boat"] = {
        Type = "Vehicle",
        InteractDistance = 12,
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = false,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),

        TypeArguments = function(p75) -- Line: 2388, Name: TypeArguments
            return {
                UI = "Boat",
                IgnoreGatherMult = true,
                ResizeDynamically = false,
                CombineItems = true,
                AutoTurnOn = true,
                ItemID = 274,
                Slots = { "FuelCrude", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip" },
                LootTable = { "Benches", "Wooden Boat" }
            };
        end,

        Sounds = {
            Open = "BoxOpen"
        }
    },
    ["Military Boat"] = {
        Type = "Vehicle",
        InteractDistance = 15,
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = false,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),

        TypeArguments = function(p76) -- Line: 2412, Name: TypeArguments
            return {
                UI = "BoatLarge",
                IgnoreGatherMult = true,
                ResizeDynamically = false,
                CombineItems = true,
                AutoTurnOn = true,
                ItemID = 272,
                Slots = { "FuelCrude", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip", "DefaultSkip" },
                LootTable = { "Benches", "Wooden Boat" }
            };
        end,

        Sounds = {
            Open = "BoxOpen"
        }
    },
    ["Salvaged Flycopter"] = {
        Type = "Vehicle",
        InteractDistance = 12,
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = false,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),

        TypeArguments = function(p77) -- Line: 2436, Name: TypeArguments
            return {
                UI = "OneSlot",
                IgnoreGatherMult = true,
                ResizeDynamically = false,
                CombineItems = true,
                AutoTurnOn = true,
                ItemID = 313,
                FuelMult = 0.16666666666666666,
                Slots = { "FuelCrude" },
                LootTable = { "Benches", "Salvaged Flycopter" }
            };
        end,

        Explosive = {
            Radius = 15,
            HumanoidMaxDamage = 200,
            SoftSideMult = 1,
            DamagePrefix = "",
            HumanoidOnly = true
        },
        Sounds = {
            Open = "BoxOpen"
        }
    },
    AttackHeli = {
        DamageType = "BenchWood",
        PickupBehavior = false,
        DecayType = "Never"
    },
    ["Diver Dave"] = {
        Type = "NPC",
        InteractDistance = 8,
        DecayType = "Never",
        DamageType = "BenchWood",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 1, 0),

        TypeArguments = function(p78) -- Line: 2481, Name: TypeArguments
            return {
                Cooldown = 20,
                Dialog = { {
                        Text = "Welcome to Dive With Dave! Would you like to purchase a Boat?",
                        Options = { {
                                Text = "Wooden Boat (COST: 150 Caps)",
                                Color = 1,
                                Success = 2,
                                Fail = 3,
                                Action = { 6, 150, "Wooden Boat" }
                            }, {
                                Text = "Military Boat (COST: 350 Caps)",
                                Color = 1,
                                Success = 2,
                                Fail = 3,
                                Action = { 6, 350, "Military Boat" }
                            }, {
                                Text = "No",
                                Color = 2,
                                Action = "Close"
                            } }
                    }, {
                        Text = "Awesome! Your new Boat will be to your dock on the left.",
                        Options = { {
                                Text = "Close",
                                Color = 2,
                                Action = "Close"
                            } }
                    }, {
                        Text = "I\'m sorry, but you\'re too poor to make the purchase.",
                        Options = { {
                                Text = "Close",
                                Color = 2,
                                Action = "Close"
                            } }
                    } },
                CooldownDialog = { {
                        Text = "Please wait before purchasing another Boat.",
                        Options = { {
                                Text = "Close",
                                Color = 2,
                                Action = "Close"
                            } }
                    } }
            };
        end
    },
    ["Pilot Pete"] = {
        Type = "NPC",
        InteractDistance = 8,
        DecayType = "Never",
        DamageType = "BenchWood",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 1, 0),

        TypeArguments = function(p79) -- Line: 2553, Name: TypeArguments
            return {
                Cooldown = 40,
                Dialog = { {
                        Text = "Hello there, what can I do for ya?",
                        Options = { {
                                Text = "Salvaged Flycopter (COST: 750 Caps)",
                                Color = 1,
                                Success = 2,
                                Fail = 3,
                                Action = { 6, 750, "Salvaged Flycopter" }
                            }, {
                                Text = "Leave",
                                Color = 2,
                                Action = "Close"
                            } }
                    }, {
                        Text = "It was a pleasure doing business with you!",
                        Options = { {
                                Text = "Close",
                                Color = 2,
                                Action = "Close"
                            } }
                    }, {
                        Text = "Hey man, you don\'t have enough Bottle Caps for this.",
                        Options = { {
                                Text = "Close",
                                Color = 2,
                                Action = "Close"
                            } }
                    } },
                CooldownDialog = { {
                        Text = "Please wait before purchasing another Vehicle.",
                        Options = { {
                                Text = "Close",
                                Color = 2,
                                Action = "Close"
                            } }
                    } }
            };
        end
    },
    ["Shotgun Turret"] = {
        Type = "Turret",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        MeleeResistance = 0.4,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 1.3,
        FaceCamera = true,
        RotateOnSurface = true,
        DurabilityDecrease = 0.25,
        InteractDistance = 7.5,
        PlaceExtraDistance = 1.5,

        TypeArguments = function() -- Line: 2619, Name: TypeArguments
            return {
                UI = "Container4",
                ResizeDynamically = false,
                Damage = 17,
                Bleed = 1,
                BulletRadius = 4,
                BulletRange = 14.25,
                BulletCount = 9,
                Cooldown = 0.45,
                Slots = { "Shotgun", "Shotgun" },
                DamageRange = { 9, 25 }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 1.21, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 180
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Wall", "Half Wall", "Doorway", "Window" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Auto Turret"] = {
        Type = "AutoTurret",
        RequiredPower = 8,
        ElectricityType = true,
        MaxPerBase = 5,
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        MeleeResistance = 0.4,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 3,
        FaceCamera = true,
        RotateOnSurface = true,
        DurabilityDecrease = 0.25,
        InteractDistance = 7.5,
        PlaceExtraDistance = 1.5,

        TypeArguments = function() -- Line: 2662, Name: TypeArguments
            return {
                UI = "AutoTurret",
                ResizeDynamically = false,
                PowerIn = 1,
                Damage = 27,
                Bleed = 2,
                BulletRadius = 24,
                BulletRange = 150,
                TargetRange = 100,
                Cooldown = 0.2,
                Slots = { "InputGun", "Ammo", "Ammo", "Ammo", "Ammo", "Ammo" },
                DamageRange = { 85, 150 }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.925, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 180
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Bear Trap"] = {
        Type = "Trap",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        DecayMultiplier = 2,
        PickupBehavior = true,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.25,
        FaceCamera = true,
        RotateOnSurface = true,
        PlaceExtraDistance = 1,

        TypeArguments = function() -- Line: 2714, Name: TypeArguments
            return {
                Damage = 75,
                Bleed = 12
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.15, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Terrain", "_Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Landmine Trap"] = {
        Type = "Trap",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        DecayMultiplier = 2,
        PickupBehavior = true,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.35,
        FaceCamera = true,
        RotateOnSurface = true,
        PlaceExtraDistance = 1,

        TypeArguments = function() -- Line: 2744, Name: TypeArguments
            return {
                Explosive = {
                    Radius = 3.5,
                    HumanoidMaxDamage = 120,
                    SoftSideMult = 1,
                    DamagePrefix = "",
                    HumanoidOnly = true,
                    ShakeStrength = 0.2,
                    Duration = 0.15,
                    SoundName = "Landmine"
                }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.24, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Terrain", "_Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    Rug = {
        Type = "Comfort",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        DecayMultiplier = 3,
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0.25, 0),
        RayCheckLength = 0.05,
        PlaceExtraDistance = 2,
        FaceCamera = true,
        RotateOnSurface = true,
        LenientCollision = true,

        TypeArguments = function() -- Line: 2782, Name: TypeArguments
            return {
                Comfort = 30
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 0.015, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 180
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Wall", "Half Wall", "Doorway", "Window" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    Wreath = {
        Type = "Comfort",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        DecayMultiplier = 3,
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0.25, 0),
        RayCheckLength = 0.05,
        PlaceExtraDistance = 2,
        InteractDistance = 8,
        FaceCamera = false,
        RotateOnSurface = true,
        LenientCollision = true,

        TypeArguments = function() -- Line: 2813, Name: TypeArguments
            return {
                Comfort = 22
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 0.015, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 180
        },
        PlaceWhitelist = { "Wall", "Half Wall", "Doorway", "Window" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Christmas Lights"] = {
        Type = "Misc",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        DecayMultiplier = 3,
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0.25, 0),
        RayCheckLength = 0.3,
        PlaceExtraDistance = 2,
        InteractDistance = 9,
        FaceCamera = false,
        RotateOnSurface = true,
        LenientCollision = true,

        TypeArguments = function() -- Line: 2843, Name: TypeArguments
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.18, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 180
        },
        PlaceWhitelist = { "Wall", "Half Wall", "Doorway", "Window" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    Fireplace = {
        Type = "Campfire",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DemolishTimerMult = (1 / 0),
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 2, 0),
        RayCheckLength = 4.6,
        FaceCamera = true,
        RotateOnSurface = true,
        PlaceExtraDistance = 3,
        InteractDistance = 10,

        TypeArguments = function() -- Line: 2871, Name: TypeArguments
            return {
                UI = "Furnace",
                IgnoreGatherMult = true,
                ResizeDynamically = false,
                CombineItems = true,
                FuelMult = 1,
                InputMult = 0.5,
                Comfort = 100,
                Heat = 6,
                Slots = { "FuelWood", "InputCampfire", "InputCampfire", "Output", "Output", "Output" },
                LootTable = { "Benches", "Campfire" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 4.48, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33,
        Sounds = {
            Open = "FurnaceOpen"
        }
    },
    ["Barrel Light"] = {
        Type = "Electricity",
        ElectricityType = true,
        ElectricityLight = true,
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, -0.1, 0),
        RayCheckLength = -1,
        PlaceExtraDistance = 1,
        InteractDistance = 8,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 2914, Name: TypeArguments
            return {
                PowerIn = 1,
                PowerOut = 1
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 0.9, 0) * CFrame.Angles(3.141592653589793, 0, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 179,
            Max = 180
        },
        PlaceWhitelist = { "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    Candle = {
        Type = "Toggle",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        DecayMultiplier = 3,
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 0.7,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 2950, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.49, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 2
        },
        PlaceBlacklist = { "Terrain", "Ladder", "Candle", "Metal Barricade", "Wooden Spikes", "Metal Spikes", "Wooden Boat", "Military Boat", "Salvaged Flycopter" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Jack-O-Lantern"] = {
        Type = "Toggle",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        DecayMultiplier = 3,
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 1.05,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 2975, Name: TypeArguments
            return {
                Comfort = 10
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 0.88, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Small Cobweb"] = {
        Type = "Misc",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0.25, 0),
        RayCheckLength = 0.05,
        PlaceExtraDistance = 1.5,
        FaceCamera = true,
        RotateOnSurface = true,
        LenientCollision = true,

        TypeArguments = function() -- Line: 3002, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 0.015, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 180
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Wall", "Half Wall", "Doorway", "Window" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Large Cobweb"] = {
        Type = "Misc",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0.25, 0),
        RayCheckLength = 0.05,
        PlaceExtraDistance = 1.5,
        FaceCamera = true,
        RotateOnSurface = true,
        LenientCollision = true,

        TypeArguments = function() -- Line: 3028, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 0.015, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 180
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Wall", "Half Wall", "Doorway", "Window" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    Scarecrow = {
        Type = "Scarecrow",
        DecayType = "Never",
        DamageType = "BenchWood",
        PickupBehavior = false,
        DemolishTimerMult = (1 / 0),
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 2.1,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 3054, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 2, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 20
        },
        PlaceWhitelist = { "Terrain", "_Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["%s\'s Trophy"] = {
        Type = "Trophy",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        DecayMultiplier = 3,
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 1, 0),
        RayCheckLength = 2.3,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 3079, Name: TypeArguments
            return {};
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 2.16, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 30
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Storage Cabinet"] = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 4.1,
        FaceCamera = true,
        RotateOnSurface = true,
        DurabilityDecrease = 0.25,
        InteractDistance = 8,
        PlaceExtraDistance = 2,

        TypeArguments = function() -- Line: 3105, Name: TypeArguments
            return {
                UI = "Container48",
                ResizeDynamically = false,
                Slots = table.create(48, "Default")
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 4, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33,
        Sounds = {
            Open = "CabinetOpen",
            OpenServer = "CabinetOpenServer"
        }
    },
    ["Christmas Tree"] = {
        Type = "ChristmasTree",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        MaxPerBase = 3,
        RayCheckLength = 5,
        FaceCamera = true,
        RotateOnSurface = true,
        DurabilityDecrease = 0.25,
        InteractDistance = 8,
        PlaceExtraDistance = 2,

        TypeArguments = function() -- Line: 3141, Name: TypeArguments
            return {
                UI = "ChristmasTree",
                ResizeDynamically = false,
                Slots = { "Ornament", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 4.6, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Repair Table"] = {
        Type = "Container",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        RayCheckLength = 2.45,
        FaceCamera = true,
        RotateOnSurface = true,
        DurabilityDecrease = 0.25,
        InteractDistance = 7,
        PlaceExtraDistance = 2,

        TypeArguments = function() -- Line: 3174, Name: TypeArguments
            return {
                UI = "RepairTable",
                ResizeDynamically = false,
                MaxStack = 1,
                OnePersonOnly = true,
                Slots = { "InputRepair" }
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 2.35, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 45
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["External Wooden Wall"] = {
        Type = "Damager",
        DecayType = "UnderBase",
        DamageType = "Wood",
        DecayMultiplier = 2,
        MeleeResistance = 0.4,
        PickupBehavior = false,
        DemolishTimerMult = 1,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        PlaceExtraDistance = 9,
        InteractDistance = 9,
        RayCheckLength = 7.75,
        FaceCamera = true,
        RotateOnSurface = true,
        LenientCollision = true,

        TypeArguments = function() -- Line: 3208, Name: TypeArguments
            return {
                Damage = 15,
                Bleed = 3,
                HitTick = 0.14
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 7.5, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Terrain", "_Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["External Wooden Gate"] = {
        Type = "Door",
        DecayType = "UnderBase",
        DamageType = "Wood",
        DecayMultiplier = 2,
        MeleeResistance = 0.4,
        PickupBehavior = false,
        DemolishTimerMult = 1,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        PlaceExtraDistance = 10,
        InteractDistance = 16,
        RayCheckLength = 7.75,
        FaceCamera = true,
        RotateOnSurface = true,
        LenientCollision = true,

        TypeArguments = function() -- Line: 3243, Name: TypeArguments
            return {
                MoveTime = 3,
                Logic = "OpenDoor",
                OpenDegrees = -89,
                ChangeCollideWhenMoving = false,
                Damage = 15,
                Bleed = 3,
                HitTick = 0.14,
                PowerIn = 1,

                MoveFunction = function(p80) -- Line: 3246, Name: MoveFunction
                    return p80 < 0.5 and 4 * p80 ^ 3 or 1 - (-2 * p80 + 2) ^ 3 / 2;
                end
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 7.5, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Terrain", "_Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["External Stone Wall"] = {
        Type = "Damager",
        DecayType = "UnderBase",
        DamageType = "Stone",
        DecayMultiplier = 2,
        MeleeResistance = 0.4,
        PickupBehavior = false,
        DemolishTimerMult = 1,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        PlaceExtraDistance = 9,
        InteractDistance = 9,
        RayCheckLength = 7.75,
        FaceCamera = true,
        RotateOnSurface = true,
        LenientCollision = true,

        TypeArguments = function() -- Line: 3287, Name: TypeArguments
            return {
                Damage = 15,
                Bleed = 3,
                HitTick = 0.14
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 7.5, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Terrain", "_Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["External Stone Gate"] = {
        Type = "Door",
        DecayType = "UnderBase",
        DamageType = "Stone",
        DecayMultiplier = 2,
        MeleeResistance = 0.4,
        PickupBehavior = false,
        DemolishTimerMult = 1,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        PlaceExtraDistance = 10,
        InteractDistance = 16,
        RayCheckLength = 13,
        FaceCamera = true,
        RotateOnSurface = true,
        LenientCollision = true,

        TypeArguments = function() -- Line: 3322, Name: TypeArguments
            return {
                MoveTime = 3,
                Logic = "OpenDoor",
                OpenDegrees = -89,
                ChangeCollideWhenMoving = false,
                Damage = 15,
                Bleed = 3,
                HitTick = 0.14,
                PowerIn = 1,

                MoveFunction = function(p81) -- Line: 3325, Name: MoveFunction
                    return p81 < 0.5 and 4 * p81 ^ 3 or 1 - (-2 * p81 + 2) ^ 3 / 2;
                end
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 11, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Terrain", "_Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    Ladder = {
        Type = "Misc",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DecayMultiplier = 2,
        DurabilityDecrease = 0.25,
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0.5, 0),
        RayCheckLength = 0.25,
        RayCheckVector = "RightVector",
        FaceCamera = false,
        RotateOnSurface = true,
        IgnoreBuildBlock = true,
        Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(0.15, 0, 0),
        UnsnappedOffset = CFrame.Angles(0, 0, 1.5707963267948966),
        RotateOffset = CFrame.new(),
        PlaceableAngles = {
            Min = 0,
            Max = 360
        },
        PlaceBlacklist = { "Terrain", "Ladder", "Candle", "Metal Barricade", "Wooden Spikes", "Metal Spikes", "Wooden Boat", "Military Boat", "Salvaged Flycopter" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Wooden Spikes"] = {
        Type = "Damager",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        PlaceExtraDistance = 9,
        InteractDistance = 9,
        RayCheckLength = 3.1,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 3392, Name: TypeArguments
            return {
                Damage = 8,
                Bleed = 1,
                HitTick = 0.19
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 2.9, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Metal Spikes"] = {
        Type = "Damager",
        DecayType = "UnderBase",
        DamageType = "Metal",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        PlaceExtraDistance = 9,
        InteractDistance = 9,
        RayCheckLength = 3.1,
        FaceCamera = true,
        RotateOnSurface = true,

        TypeArguments = function() -- Line: 3423, Name: TypeArguments
            return {
                Damage = 8,
                Bleed = 1,
                HitTick = 0.19
            };
        end,

        Offset = CFrame.Angles(-1.5707963267948966, -1.5707963267948966, 0) * CFrame.new(0, 2.9, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Metal Barricade"] = {
        Type = "Misc",
        DecayType = "UnderBase",
        DamageType = "Wood",
        PickupBehavior = "SelfHammerOnly",
        DisplayHealthOnly = true,
        GuiOffset = Vector3.new(0, 0, 0),
        MeleeResistance = 35,
        PlaceExtraDistance = 2,
        RayCheckLength = 3.7,
        FaceCamera = true,
        RotateOnSurface = true,
        IgnoreBuildBlock = "Monument",
        AllowedOnRoads = true,
        LenientCollision = true,
        DecayMultiplier = 3,
        DurabilityDecrease = 0.4,
        Offset = CFrame.Angles(-1.5707963267948966, 1.5707963267948966, 0) * CFrame.new(0, 3.4, 0),
        UnsnappedOffset = CFrame.new(),
        RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
        PlaceableAngles = {
            Min = 0,
            Max = 40
        },
        PlaceBlacklist = { "Ladder", "Candle", "Metal Barricade", "Wooden Spikes", "Metal Spikes", "Wooden Boat", "Military Boat", "Salvaged Flycopter" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Small Wooden Sign"] = {
        Type = "Sign",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 2, 0),
        RayCheckLength = -0.2,
        RayCheckVector = "RightVector",
        FaceCamera = false,
        RotateOnSurface = true,
        DurabilityDecrease = 0.25,
        InteractDistance = 7.5,
        PlaceExtraDistance = 1.5,
        LenientCollision = true,

        TypeArguments = function() -- Line: 3483, Name: TypeArguments
            return {
                MaxCharacters = 100
            };
        end,

        Offset = CFrame.Angles(3.141592653589793, 1.5707963267948966, 0) * CFrame.new(0, 0, 0),
        UnsnappedOffset = CFrame.Angles(0, 0, 1.5707963267948966),
        RotateOffset = CFrame.new(),
        PlaceableAngles = {
            Min = 89,
            Max = 91
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Wall", "Half Wall", "Low Wall", "Doorway", "Window", "Foundation" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Large Wooden Sign"] = {
        Type = "Sign",
        DecayType = "UnderBase",
        DamageType = "BenchWood",
        PickupBehavior = "HammerOnly",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 4, 0),
        RayCheckLength = -0.3,
        RayCheckVector = "RightVector",
        FaceCamera = false,
        RotateOnSurface = true,
        DurabilityDecrease = 0.25,
        InteractDistance = 8.5,
        PlaceExtraDistance = 2,
        LenientCollision = true,

        TypeArguments = function() -- Line: 3515, Name: TypeArguments
            return {
                MaxCharacters = 300
            };
        end,

        Offset = CFrame.Angles(3.141592653589793, 1.5707963267948966, 0) * CFrame.new(-0.1, 0, 0),
        UnsnappedOffset = CFrame.Angles(0, 0, 1.5707963267948966),
        RotateOffset = CFrame.new(),
        PlaceableAngles = {
            Min = 89,
            Max = 91
        },
        PlaceWhitelist = { "Foundation", "Triangle Foundation", "Wall", "Half Wall", "Low Wall", "Doorway", "Window", "Foundation" },
        PlacingFunc = v14,
        CollisionFunc = u33
    },
    ["Salvaged Backpack"] = {
        Type = "Container",
        DecayType = "Never",
        PickupBehavior = "Backpack",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        ArmorRightClickToBench = true,

        TypeArguments = function() -- Line: 3547, Name: TypeArguments
            return {
                UI = "Container12",
                ResizeDynamically = false,
                DestroyOnEmpty = false,
                Slots = table.create(12, "Default")
            };
        end,

        Sounds = {
            Open = "BagOpen"
        }
    },
    ["Military Backpack"] = {
        Type = "Container",
        DecayType = "Never",
        PickupBehavior = "Backpack",
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        ArmorRightClickToBench = true,

        TypeArguments = function() -- Line: 3567, Name: TypeArguments
            return {
                UI = "Container30",
                ResizeDynamically = false,
                DestroyOnEmpty = false,
                Slots = table.create(24, "Default")
            };
        end,

        Sounds = {
            Open = "BagOpen"
        }
    },
    ["Food Crate"] = {
        Type = "Container",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),

        TypeArguments = function() -- Line: 3587, Name: TypeArguments
            return {
                UI = "Container12",
                ResizeDynamically = true,
                CombineItems = true,
                DestroyOnEmpty = true,
                Slots = table.create(12, "Output"),
                LootTable = { "Benches", "Food Crate" }
            };
        end
    },
    ["Wooden Crate"] = {
        Type = "Container",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),

        TypeArguments = function() -- Line: 3604, Name: TypeArguments
            return {
                UI = "Container12",
                ResizeDynamically = true,
                CombineItems = true,
                DestroyOnEmpty = true,
                Slots = table.create(30, "Output"),
                LootTable = { "Benches", "Wooden Crate" }
            };
        end
    },
    ["Locked Wooden Crate"] = {
        Type = "LockedContainer",
        DamageType = "BenchBarrel",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),

        TypeArguments = function() -- Line: 3621, Name: TypeArguments
            return {
                UI = "Container30",
                ResizeDynamically = true,
                CombineItems = true,
                DestroyOnEmpty = true,
                Health = 15,
                Slots = table.create(30, "Output"),
                LootTable = { "Benches", "Locked Wooden Crate" }
            };
        end
    },
    ["Locked Metal Crate"] = {
        Type = "LockedContainer",
        DamageType = "BenchBarrel",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),

        TypeArguments = function() -- Line: 3640, Name: TypeArguments
            return {
                UI = "Container30",
                ResizeDynamically = true,
                CombineItems = true,
                DestroyOnEmpty = true,
                Health = 25,
                Slots = table.create(30, "Output"),
                LootTable = { "Benches", "Locked Metal Crate" }
            };
        end
    },
    ["Locked Steel Crate"] = {
        Type = "LockedContainer",
        DamageType = "BenchBarrel",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),

        TypeArguments = function() -- Line: 3659, Name: TypeArguments
            return {
                UI = "Container30",
                ResizeDynamically = true,
                CombineItems = true,
                DestroyOnEmpty = true,
                Health = 35,
                Slots = table.create(30, "Output"),
                LootTable = { "Benches", "Locked Steel Crate" }
            };
        end
    },
    ["Boris\'s Locker"] = {
        Type = "Container",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        InteractDistance = 9,

        TypeArguments = function() -- Line: 3678, Name: TypeArguments
            return {
                UI = "Container30",
                ResizeDynamically = true,
                CombineItems = true,
                DestroyOnEmpty = true,
                Slots = table.create(30, "Output"),
                LootTable = { "Benches", "Boris\'s Locker" }
            };
        end
    },
    ["Brutus Locker"] = {
        Type = "Container",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 0, 0),
        InteractDistance = 9,

        TypeArguments = function() -- Line: 3696, Name: TypeArguments
            return {
                UI = "Container30",
                ResizeDynamically = true,
                CombineItems = true,
                DestroyOnEmpty = true,
                Slots = table.create(30, "Output"),
                LootTable = { "Benches", "Brutus Locker" }
            };
        end
    },
    ["Care Package"] = {
        Type = "Container",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 3.5, 0),
        InteractDistance = 9,

        TypeArguments = function() -- Line: 3714, Name: TypeArguments
            return {
                UI = "Container30",
                ResizeDynamically = true,
                CombineItems = true,
                DestroyOnEmpty = true,
                ShuffleItems = true,
                Slots = table.create(30, "Output"),
                LootTable = { "Benches", "Care Package" }
            };
        end
    },
    ["Timed Crate"] = {
        Type = "Container",
        DecayType = "Never",
        PickupBehavior = false,
        DisplayHealthOnly = false,
        GuiOffset = Vector3.new(0, 3.5, 0),
        InteractDistance = 9,

        TypeArguments = function() -- Line: 3734, Name: TypeArguments
            return {
                UI = "Container30",
                ResizeDynamically = true,
                CombineItems = true,
                DestroyOnEmpty = true,
                ShuffleItems = true,
                Slots = table.create(30, "Output"),
                LootTable = { "Benches", "Timed Crate" }
            };
        end
    }
};
local v83 = {
    Type = "Container",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 3.5, 0),
    InteractDistance = 9
};
local u84 = "Locked Metal Crate";

function v83.TypeArguments() -- Line: 1313
    -- upvalues: u84 (copy)
    return {
        UI = "Container30",
        ResizeDynamically = true,
        CombineItems = true,
        DestroyOnEmpty = true,
        ShuffleItems = true,
        Slots = table.create(30, "Output"),
        LootTable = { "Benches", u84 }
    };
end;

v82["Easy Mission Crate"] = v83;
local v85 = {
    Type = "Container",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 3.5, 0),
    InteractDistance = 9
};
local u86 = "Locked Steel Crate";

function v85.TypeArguments() -- Line: 1313
    -- upvalues: u86 (copy)
    return {
        UI = "Container30",
        ResizeDynamically = true,
        CombineItems = true,
        DestroyOnEmpty = true,
        ShuffleItems = true,
        Slots = table.create(30, "Output"),
        LootTable = { "Benches", u86 }
    };
end;

v82["Medium Mission Crate"] = v85;
local v87 = {
    Type = "Container",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 3.5, 0),
    InteractDistance = 9
};
local u88 = "Timed Crate";

function v87.TypeArguments() -- Line: 1313
    -- upvalues: u88 (copy)
    return {
        UI = "Container30",
        ResizeDynamically = true,
        CombineItems = true,
        DestroyOnEmpty = true,
        ShuffleItems = true,
        Slots = table.create(30, "Output"),
        LootTable = { "Benches", u88 }
    };
end;

v82["Hard Mission Crate"] = v87;
local v89 = {
    Type = "Container",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 3.5, 0),
    InteractDistance = 9
};
local u90 = "Epic Mission Crate";

function v89.TypeArguments() -- Line: 1313
    -- upvalues: u90 (copy)
    return {
        UI = "Container30",
        ResizeDynamically = true,
        CombineItems = true,
        DestroyOnEmpty = true,
        ShuffleItems = true,
        Slots = table.create(30, "Output"),
        LootTable = { "Benches", u90 }
    };
end;

v82["Epic Mission Crate"] = v89;
v82["BTR Crate"] = {
    Type = "Container",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 3.5, 0),
    InteractDistance = 9,

    TypeArguments = function() -- Line: 3760, Name: TypeArguments
        return {
            UI = "Container30",
            ResizeDynamically = true,
            CombineItems = true,
            DestroyOnEmpty = true,
            ShuffleItems = true,
            Slots = table.create(30, "Output"),
            LootTable = { "Benches", "BTR Crate" }
        };
    end
};
v82["Heli Crate"] = {
    Type = "Container",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 3.5, 0),
    InteractDistance = 9,

    TypeArguments = function() -- Line: 3780, Name: TypeArguments
        return {
            UI = "Container30",
            ResizeDynamically = true,
            CombineItems = true,
            DestroyOnEmpty = true,
            ShuffleItems = true,
            Slots = table.create(30, "Output"),
            LootTable = { "Benches", "Heli Crate" }
        };
    end
};
v82["Oil Barrel"] = {
    Type = "Destroyable",
    DamageType = "BenchBarrel",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 3800, Name: TypeArguments
        return {
            Health = 20,
            LootTable = { "Benches", "Oil Barrel" }
        };
    end
};
v82["Trash Can"] = {
    Type = "Destroyable",
    DamageType = "BenchBarrel",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 3814, Name: TypeArguments
        return {
            LootTable = { "Benches", "Trash Can" },
            Health = 15 + math.random(0, 1) * 5
        };
    end
};
v82["Small Gift"] = {
    Type = "Destroyable",
    DamageType = "BenchBarrel",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 3829, Name: TypeArguments
        return {
            LootTable = { "Benches", "Small Gift" },
            Health = 15 + math.random(0, 1) * 5
        };
    end
};
v82["Medium Gift"] = {
    Type = "Destroyable",
    DamageType = "BenchBarrel",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 3844, Name: TypeArguments
        return {
            LootTable = { "Benches", "Medium Gift" },
            Health = 20 + math.random(0, 1) * 5
        };
    end
};
v82["Large Gift"] = {
    Type = "Destroyable",
    DamageType = "BenchBarrel",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 3859, Name: TypeArguments
        return {
            LootTable = { "Benches", "Large Gift" },
            Health = 25 + math.random(0, 1) * 5
        };
    end
};
v82["Small Egg"] = {
    Type = "Destroyable",
    DamageType = "BenchBarrel",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 3874, Name: TypeArguments
        return {
            LootTable = { "Benches", "Small Gift" },
            Health = 15 + math.random(0, 1) * 5
        };
    end
};
v82["Medium Egg"] = {
    Type = "Destroyable",
    DamageType = "BenchBarrel",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 3889, Name: TypeArguments
        return {
            LootTable = { "Benches", "Medium Gift" },
            Health = 20 + math.random(0, 1) * 5
        };
    end
};
v82["Large Egg"] = {
    Type = "Destroyable",
    DamageType = "BenchBarrel",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 3904, Name: TypeArguments
        return {
            LootTable = { "Benches", "Large Gift" },
            Health = 25 + math.random(0, 1) * 5
        };
    end
};
v82["Fire Barrel"] = {
    Type = "Campfire",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 3, 0),

    TypeArguments = function() -- Line: 3919, Name: TypeArguments
        return {
            UI = "Campfire",
            IgnoreGatherMult = true,
            ResizeDynamically = false,
            CombineItems = true,
            FuelMult = 0.75,
            InputMult = 1,
            Heat = 6,
            Slots = { "FuelWood", "InputCampfire", "Output", "Output" },
            LootTable = { "Benches", "Campfire" }
        };
    end
};
v82.Shredder = {
    Type = "Shredder",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    InteractDistance = 8,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 3940, Name: TypeArguments
        return {
            UI = "Shredder",
            ResizeDynamically = false,
            OnePersonOnly = true,
            Slots = { "InputShredder", "InputShredder", "InputShredder", "InputShredder", "InputShredder", "Output", "Output", "Output", "Output", "Output" }
        };
    end
};
v82.Jukebox = {
    Type = "Jukebox",
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    DecayMultiplier = 2,
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0.25, 0),
    RayCheckLength = 2.7,
    PlaceExtraDistance = 1,
    FaceCamera = true,
    RotateOnSurface = true,
    BuildingPrivOnly = true,

    TypeArguments = function() -- Line: 3957, Name: TypeArguments
        return {
            UI = "Jukebox",
            Comfort = 30
        };
    end,

    Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 2.55, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlaceableAngles = {
        Min = 0,
        Max = 45
    },
    PlaceWhitelist = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82["Plinko Machine"] = {
    Type = "Container",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 1, 0),

    TypeArguments = function() -- Line: 3988, Name: TypeArguments
        return {
            UI = "Plinko",
            ResizeDynamically = false,
            LocalContainer = true,
            MaxStack = 1000,
            Slots = { "InputCaps", "InputCaps", "InputCaps", "InputCaps", "Output" }
        };
    end
};
v82["Power Cell Box"] = {
    Type = "PowerCell",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    InteractDistance = 7,
    GuiOffset = Vector3.new(0, 0, 0),

    TypeArguments = function() -- Line: 4005, Name: TypeArguments
        return {
            UI = "OneSlot",
            ResizeDynamically = false,
            MaxStack = 1,
            Slots = { "InputPowerCell" }
        };
    end
};
v82["Quarry Engine"] = {
    Type = "QuarryEngine",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    InteractDistance = 8,
    GuiOffset = Vector3.new(0, 1, 0),

    TypeArguments = function() -- Line: 4024, Name: TypeArguments
        return {};
    end
};
v82["Quarry Fuel Tank"] = {
    Type = "QuarryTank",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    InteractDistance = 8,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 4035, Name: TypeArguments
        return {
            UI = "OneSlot",
            ResizeDynamically = false,
            MaxStack = 10,
            Slots = { "FuelDiesel" }
        };
    end
};
v82["Quarry Output"] = {
    Type = "QuarryOutput",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    InteractDistance = 8,
    GuiOffset = Vector3.new(0, 0.5, 0),

    TypeArguments = function() -- Line: 4051, Name: TypeArguments
        return {
            UI = "Container48",
            ResizeDynamically = false,
            Slots = table.create(48, "Output")
        };
    end
};
v82["Power Button"] = {
    Type = "Button",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    InteractDistance = 7,
    GuiOffset = Vector3.new(0, 0, 0),

    TypeArguments = function() -- Line: 4067, Name: TypeArguments
        return {};
    end
};
v82["Door Button"] = {
    Type = "Button",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    InteractDistance = 7,
    GuiOffset = Vector3.new(0, 0, 0),

    TypeArguments = function() -- Line: 4079, Name: TypeArguments
        return {};
    end
};
v82["Body Bag"] = {
    Type = "Container",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    ArmorRightClickToBench = true,

    TypeArguments = function() -- Line: 4091, Name: TypeArguments
        return {
            UI = "BodyLoot",
            ResizeDynamically = false,
            DestroyOnEmpty = true,
            Slots = table.create(38, "Output")
        };
    end,

    Sounds = {
        Open = "BagOpen"
    }
};
v82.Sleeper = {
    Type = "Sleeper",
    DecayType = "Sleeper",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, -1.5, 0),

    TypeArguments = function() -- Line: 4111, Name: TypeArguments
        return {
            UI = "BodyLoot",
            Slots = { "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Default", "Output", "Output", "Output", "Output", "Output", "Output", "Output", "Output" }
        };
    end,

    Sounds = {
        Open = "BagOpen"
    }
};
v82.Contents = {
    Type = "Container",
    DecayType = "Never",
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    InteractDistance = 10,

    TypeArguments = function(p91) -- Line: 4128, Name: TypeArguments
        if not p91 then
            return {};
        end;

        local Attribute = p91:GetAttribute("BenchName");
        local v92, v93;

        if Attribute and (Attribute:find("Scav Body") or (Attribute == "Body of Bruno" or (Attribute == "Body of Boris" or (Attribute == "Body of Brutus" or Attribute:find("Zombie"))))) then
            v92 = { "AI", Attribute };
            v93 = true;
        else
            v92 = nil;
            v93 = false;
        end;

        return {
            UI = "Container48",
            DestroyOnEmpty = true,
            Slots = table.create(48, "Output"),
            LootTable = v92,
            ResizeDynamically = v93
        };
    end,

    Sounds = {
        Open = "BagOpen"
    }
};
v82.Door = {
    Type = "Door",
    DecayType = "Never",
    InteractDistance = 10,
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),

    TypeArguments = function() -- Line: 4157, Name: TypeArguments
        return {
            MoveTime = 0.5,
            Logic = "OpenDoor",
            OpenDegrees = -95,
            ChangeCollideWhenMoving = true,

            MoveFunction = function(p94) -- Line: 4160, Name: MoveFunction
                return 1 - (1 - p94) ^ 3;
            end
        };
    end
};
v82["Yellow Keycard Door"] = {
    Type = "Door",
    DecayType = "Never",
    InteractDistance = 0,
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),

    TypeArguments = function() -- Line: 4176, Name: TypeArguments
        return {
            MoveTime = 1,
            Logic = "OpenDoor",
            OpenDegrees = -95,
            ChangeCollideWhenMoving = true,

            MoveFunction = function(p95) -- Line: 4179, Name: MoveFunction
                return 1 - (1 - p95) ^ 3;
            end
        };
    end
};
v82["Purple Keycard Door"] = {
    Type = "Door",
    DecayType = "Never",
    InteractDistance = 0,
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),

    TypeArguments = function() -- Line: 4195, Name: TypeArguments
        return {
            MoveTime = 1,
            Logic = "OpenDoor",
            OpenDegrees = -95,
            ChangeCollideWhenMoving = true,

            MoveFunction = function(p96) -- Line: 4198, Name: MoveFunction
                return 1 - (1 - p96) ^ 3;
            end
        };
    end
};
v82["Pink Keycard Door"] = {
    Type = "Door",
    DecayType = "Never",
    InteractDistance = 0,
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),

    TypeArguments = function() -- Line: 4214, Name: TypeArguments
        return {
            MoveTime = 1,
            Logic = "OpenDoor",
            OpenDegrees = -95,
            ChangeCollideWhenMoving = true,

            MoveFunction = function(p97) -- Line: 4217, Name: MoveFunction
                return 1 - (1 - p97) ^ 3;
            end
        };
    end
};
v82["Red Keycard Door"] = {
    Type = "Door",
    DecayType = "Never",
    InteractDistance = 0,
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),

    TypeArguments = function() -- Line: 4233, Name: TypeArguments
        return {
            MoveTime = 1,
            Logic = "OpenDoor",
            OpenDegrees = -95,
            ChangeCollideWhenMoving = true,

            MoveFunction = function(p98) -- Line: 4236, Name: MoveFunction
                return 1 - (1 - p98) ^ 3;
            end
        };
    end
};
v82["Black Keycard Door"] = {
    Type = "Door",
    DecayType = "Never",
    InteractDistance = 0,
    PickupBehavior = false,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),

    TypeArguments = function() -- Line: 4252, Name: TypeArguments
        return {
            MoveTime = 1,
            Logic = "OpenDoor",
            OpenDegrees = -95,
            ChangeCollideWhenMoving = true,

            MoveFunction = function(p99) -- Line: 4255, Name: MoveFunction
                return 1 - (1 - p99) ^ 3;
            end
        };
    end
};
v82["Wooden Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Wood",
    MeleeResistance = 0.2,
    InteractDistance = 10,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4271, Name: TypeArguments
        return {
            MoveTime = 0.5,
            Logic = "OpenDoor",
            OpenDegrees = -95,
            ChangeCollideWhenMoving = true,
            PowerIn = 1,

            MoveFunction = function(p100) -- Line: 4274, Name: MoveFunction
                return 1 - (1 - p100) ^ 3;
            end
        };
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Doorway" },
            Offset = CFrame.new(0, -1.75, 0)
        }
    },
    WallBlockOffset = CFrame.new(0, -2, 0)
};
v82["Salvaged Metal Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    InteractDistance = 10,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4307, Name: TypeArguments
        return {
            MoveTime = 0.5,
            Logic = "OpenDoor",
            OpenDegrees = -95,
            ChangeCollideWhenMoving = true,
            PowerIn = 1,

            MoveFunction = function(p101) -- Line: 4310, Name: MoveFunction
                return 1 - (1 - p101) ^ 3;
            end
        };
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Doorway" },
            Offset = CFrame.new(0, -1.75, 0)
        }
    },
    WallBlockOffset = CFrame.new(0, -2, 0)
};
v82["Metal Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    InteractDistance = 10,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4344, Name: TypeArguments
        return {
            MoveTime = 0.5,
            Logic = "OpenDoor",
            OpenDegrees = -95,
            ChangeCollideWhenMoving = true,
            PowerIn = 1,

            MoveFunction = function(p102) -- Line: 4347, Name: MoveFunction
                return 1 - (1 - p102) ^ 3;
            end
        };
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Doorway" },
            Offset = CFrame.new(0, -1.75, 0)
        }
    },
    WallBlockOffset = CFrame.new(0, -2, 0)
};
v82["Steel Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    InteractDistance = 10,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4381, Name: TypeArguments
        return {
            MoveTime = 0.6,
            Logic = "OpenDoor",
            OpenDegrees = -95,
            ChangeCollideWhenMoving = true,
            PowerIn = 1,

            MoveFunction = function(p103) -- Line: 4384, Name: MoveFunction
                return 1 - (1 - p103) ^ 3;
            end
        };
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Doorway" },
            Offset = CFrame.new(0, -1.75, 0)
        }
    },
    WallBlockOffset = CFrame.new(0, -2, 0)
};
v82["Wooden Double Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Wood",
    MeleeResistance = 0.2,
    InteractDistance = 10,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4418, Name: TypeArguments
        return {
            MoveTime = 0.5,
            Logic = "OpenDoor",
            OpenDegrees = -89,
            ChangeCollideWhenMoving = true,
            PowerIn = 1,

            MoveFunction = function(p104) -- Line: 4421, Name: MoveFunction
                return 1 - (1 - p104) ^ 3;
            end
        };
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Wall Frame" },
            Offset = CFrame.new(0, 0, 0)
        }
    },
    WallBlockOffset = CFrame.new(0, -3.75, 0)
};
v82["Metal Double Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    InteractDistance = 10,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4455, Name: TypeArguments
        return {
            MoveTime = 0.5,
            Logic = "OpenDoor",
            OpenDegrees = -89,
            ChangeCollideWhenMoving = true,
            PowerIn = 1,

            MoveFunction = function(p105) -- Line: 4458, Name: MoveFunction
                return 1 - (1 - p105) ^ 3;
            end
        };
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Wall Frame" },
            Offset = CFrame.new(0, 0, 0)
        }
    },
    WallBlockOffset = CFrame.new(0, -3.75, 0)
};
v82["Steel Double Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    InteractDistance = 10,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4492, Name: TypeArguments
        return {
            MoveTime = 0.6,
            Logic = "OpenDoor",
            OpenDegrees = -89,
            ChangeCollideWhenMoving = true,
            PowerIn = 1,

            MoveFunction = function(p106) -- Line: 4495, Name: MoveFunction
                return 1 - (1 - p106) ^ 3;
            end
        };
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Wall Frame" },
            Offset = CFrame.new(0, 0, 0)
        }
    },
    WallBlockOffset = CFrame.new(0, -3.75, 0)
};
v82["Trap Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    InteractDistance = 10,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4529, Name: TypeArguments
        return {
            MoveTime = 1,
            Logic = "OpenHatch",
            Open = true,
            PowerIn = 1,

            MoveFunction = function(p107) -- Line: 4532, Name: MoveFunction
                return 1 - (1 - p107) ^ 3;
            end
        };
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Floor Frame" },
            Offset = CFrame.new(0, 0, 0)
        }
    }
};
v82["Triangle Trap Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    InteractDistance = 10,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = false,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4563, Name: TypeArguments
        return {
            MoveTime = 1,
            Logic = "OpenHatch",
            Open = true,
            PowerIn = 1,

            MoveFunction = function(p108) -- Line: 4566, Name: MoveFunction
                return 1 - (1 - p108) ^ 3;
            end
        };
    end,

    Offset = CFrame.Angles(0, 0, 1.5707963267948966),
    UnsnappedOffset = CFrame.Angles(0, 0, -1.5707963267948966),
    RotateOffset = CFrame.Angles(0, 2.0943951023931953, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 10,
            BenchNames = { "Triangle Floor Frame" },
            Offset = CFrame.new(0.02, 0, 1.45)
        }
    }
};
v82["Floor Grill"] = {
    Type = "Misc",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,
    LenientCollision = true,
    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Floor Frame" },
            Offset = CFrame.new(0, 0, 0)
        }
    }
};
v82["Garage Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    InteractDistance = 9,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4619, Name: TypeArguments
        return {
            MoveTime = 5,
            Logic = "OpenGarage",
            PowerIn = 1,

            MoveFunction = function(p109) -- Line: 4623, Name: MoveFunction
                return -(math.cos(3.141592653589793 * p109) - 1) / 2 * 8.672;
            end
        };
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Wall Frame" },
            Offset = CFrame.new(0, 0, 0)
        }
    },
    WallBlockOffset = CFrame.new(0, -3.75, 0)
};
v82["Jail Door"] = {
    Type = "Door",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    InteractDistance = 9,
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 4654, Name: TypeArguments
        return {
            MoveTime = 1,
            Logic = "OpenJail",
            PowerIn = 1,

            MoveFunction = function(p110) -- Line: 4657, Name: MoveFunction
                return 1 - (1 - p110) ^ 3;
            end
        };
    end,

    Offset = CFrame.Angles(0, 1.5707963267948966, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Wall Frame" },
            Offset = CFrame.new(0, 0, 0)
        }
    },
    WallBlockOffset = CFrame.new(0, -3.75, 0)
};
v82["Jail Wall"] = {
    Type = "Misc",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,
    LenientCollision = true,
    Offset = CFrame.Angles(0, 1.5707963267948966, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Wall Frame" },
            Offset = CFrame.new(0, 0, 0)
        }
    },
    WallBlockOffset = CFrame.new(0, -3.75, 0)
};
v82["Wooden Window Bars"] = {
    Type = "Misc",
    DecayType = "Upkeep",
    DamageType = "Wood",
    MeleeResistance = 0.4,
    PickupBehavior = "HammerOnly",
    DurabilityDecrease = 0.25,
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,
    LenientCollision = true,
    Offset = CFrame.new(0, 0.3, 0) * CFrame.Angles(0, 1.5707963267948966, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Window" },
            Offset = CFrame.new(0, 0, 0)
        }
    }
};
v82["Metal Window Bars"] = {
    Type = "Misc",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    PickupBehavior = "HammerOnly",
    DurabilityDecrease = 0.25,
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,
    LenientCollision = true,
    Offset = CFrame.new(0, 0.3, 0) * CFrame.Angles(0, 1.5707963267948966, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Window" },
            Offset = CFrame.new(0, 0, 0)
        }
    }
};
v82["Glass Window"] = {
    Type = "Misc",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    PickupBehavior = "HammerOnly",
    DurabilityDecrease = 0.25,
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,
    LenientCollision = true,
    Offset = CFrame.new(0, 0.3, 0) * CFrame.Angles(0, 1.5707963267948966, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Window" },
            Offset = CFrame.new(0, 0, 0)
        }
    }
};
v82["Steel Glass Window"] = {
    Type = "Misc",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    PickupBehavior = "HammerOnly",
    DurabilityDecrease = 0.25,
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,
    LenientCollision = true,
    Offset = CFrame.new(0, 0.3, 0) * CFrame.Angles(0, 1.5707963267948966, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 13,
            BenchNames = { "Window" },
            Offset = CFrame.new(0, 0, 0)
        }
    }
};
v82["Vertical Window Cover"] = {
    Type = "Misc",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    PickupBehavior = "HammerOnly",
    DurabilityDecrease = 0.25,
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,
    LenientCollision = true,
    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 14,
            BenchNames = { "Window" },
            Offset = CFrame.new(0, 0, 0)
        }
    }
};
v82["Horizontal Window Cover"] = {
    Type = "Misc",
    DecayType = "Upkeep",
    DamageType = "Metal",
    MeleeResistance = 0.4,
    PickupBehavior = "HammerOnly",
    DurabilityDecrease = 0.25,
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,
    LenientCollision = true,
    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    SnapPoints = {
        {
            AttachmentIndex = 14,
            BenchNames = { "Window" },
            Offset = CFrame.new(0, 0, 0)
        }
    }
};
v82["Wall Block"] = {
    Type = "BasePart",
    DecayType = "Never",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),

    TypeArguments = function() -- Line: 4855, Name: TypeArguments
        return {};
    end,

    AttachmentChecks = {
        {
            MaxRange = 13,
            BenchNames = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame" },
            Checks = {
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, -0.55, 0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, -0.55, 0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, -0.55, -0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, -0.55, -0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                }
            }
        },
        {
            MaxRange = 13,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window", "Half Wall" },
            Checks = {
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(0, -1.05, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                }
            }
        }
    },
    StabilityInfo = {
        Checks = { {
                Connections = { 3 },
                StabilityLoss = { 0 }
            }, {
                Connections = { 1, 2 },
                StabilityLoss = { 0, 0 }
            } }
    },
    NextConnections = {}
};
v82.BTR = {
    DecayType = "Never",
    DisplayHealthOnly = true,
    InteractDistance = 0,
    DamageType = "BenchVehicle",
    GuiOffset = Vector3.new()
};
v82["Small Battery"] = {
    Type = "Electricity",
    MaxPowerLevel = 1500,
    MaxPowerStore = 4,
    MaxPowerOut = 2,
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 2, 0),
    RayCheckLength = 1,
    FaceCamera = true,
    RotateOnSurface = true,

    TypeArguments = function() -- Line: 4933, Name: TypeArguments
        return {
            PowerIn = 2,
            PowerOut = 2,
            PowerLevel = 0
        };
    end,

    Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 0.82, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlaceableAngles = {
        Min = 0,
        Max = 45
    },
    PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82["Medium Battery"] = {
    Type = "Electricity",
    MaxPowerLevel = 3000,
    MaxPowerStore = 8,
    MaxPowerOut = 4,
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 2, 0),
    RayCheckLength = 3.8,
    FaceCamera = true,
    RotateOnSurface = true,
    PlaceExtraDistance = 2,
    InteractDistance = 8,

    TypeArguments = function() -- Line: 4969, Name: TypeArguments
        return {
            PowerIn = 3,
            PowerOut = 3,
            PowerLevel = 0
        };
    end,

    Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 3.61, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlaceableAngles = {
        Min = 0,
        Max = 45
    },
    PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82["Large Battery"] = {
    Type = "Electricity",
    MaxPowerLevel = 6000,
    MaxPowerStore = 8,
    MaxPowerOut = 4,
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 2, 0),
    RayCheckLength = 4.5,
    FaceCamera = true,
    RotateOnSurface = true,
    PlaceExtraDistance = 3,
    InteractDistance = 9,

    TypeArguments = function() -- Line: 5007, Name: TypeArguments
        return {
            PowerIn = 4,
            PowerOut = 4,
            PowerLevel = 0
        };
    end,

    Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 4.23, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlaceableAngles = {
        Min = 0,
        Max = 45
    },
    PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82["Solar Panel"] = {
    Type = "Electricity",
    PowerGenerated = 4,
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 2, 0),
    RayCheckLength = 1.25,
    FaceCamera = true,
    RotateOnSurface = true,
    PlaceExtraDistance = 2,
    InteractDistance = 8,

    TypeArguments = function() -- Line: 5045, Name: TypeArguments
        return {
            PowerOut = 4
        };
    end,

    Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 1.1, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlaceableAngles = {
        Min = 0,
        Max = 45
    },
    PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82["Crude Fuel Generator"] = {
    Type = "CrudeGenerator",
    PowerGenerated = 8,
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 2, 0),
    RayCheckLength = 2.5,
    FaceCamera = true,
    RotateOnSurface = true,

    TypeArguments = function() -- Line: 5079, Name: TypeArguments
        return {
            UI = "Generator",
            ResizeDynamically = false,
            CombineItems = true,
            AutoTurnOn = true,
            PowerOut = 4,
            Slots = { "FuelCrude" }
        };
    end,

    Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 2.3, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlaceableAngles = {
        Min = 0,
        Max = 45
    },
    PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82.Splitter = {
    Type = "Electricity",
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 1, 0),
    RayCheckLength = -0.2,
    RayCheckVector = "RightVector",
    FaceCamera = false,
    RotateOnSurface = true,
    PlaceExtraDistance = 1.5,

    TypeArguments = function() -- Line: 5117, Name: TypeArguments
        return {
            PowerIn = 4,
            PowerOut = 4
        };
    end,

    Offset = CFrame.Angles(3.141592653589793, 1.5707963267948966, 0) * CFrame.new(0, 0, 0),
    UnsnappedOffset = CFrame.Angles(0, 0, 1.5707963267948966),
    RotateOffset = CFrame.new(),
    PlaceableAngles = {
        Min = 89,
        Max = 91
    },
    PlaceWhitelist = { "Foundation", "Triangle Foundation", "Wall", "Half Wall", "Low Wall", "Doorway", "Window" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82.Button = {
    Type = "Button",
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 1, 0),
    RayCheckLength = -0.2,
    RayCheckVector = "RightVector",
    FaceCamera = false,
    RotateOnSurface = true,
    PlaceExtraDistance = 1.5,

    TypeArguments = function() -- Line: 5151, Name: TypeArguments
        return {
            PowerIn = 2,
            PowerOut = 2,
            PressLength = 4.5
        };
    end,

    Offset = CFrame.Angles(3.141592653589793, 1.5707963267948966, 0) * CFrame.new(0, 0, 0),
    UnsnappedOffset = CFrame.Angles(0, 0, 1.5707963267948966),
    RotateOffset = CFrame.new(),
    PlaceableAngles = {
        Min = 89,
        Max = 91
    },
    PlaceWhitelist = { "Foundation", "Triangle Foundation", "Wall", "Half Wall", "Low Wall", "Doorway", "Window" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82.Switch = {
    Type = "Switch",
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 1, 0),
    RayCheckLength = -0.2,
    RayCheckVector = "RightVector",
    FaceCamera = false,
    RotateOnSurface = true,
    PlaceExtraDistance = 1.5,

    TypeArguments = function() -- Line: 5186, Name: TypeArguments
        return {
            PowerIn = 2,
            PowerOut = 2
        };
    end,

    Offset = CFrame.Angles(3.141592653589793, 1.5707963267948966, 0) * CFrame.new(0, 0, 0),
    UnsnappedOffset = CFrame.Angles(0, 0, 1.5707963267948966),
    RotateOffset = CFrame.new(),
    PlaceableAngles = {
        Min = 89,
        Max = 91
    },
    PlaceWhitelist = { "Foundation", "Triangle Foundation", "Wall", "Half Wall", "Low Wall", "Doorway", "Window" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82["Electric Furnace"] = {
    Type = "Electricity",
    RequiredPower = 3,
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DurabilityDecrease = 0.25,
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 2, 0),
    RayCheckLength = 2.25,
    FaceCamera = true,
    RotateOnSurface = true,

    TypeArguments = function() -- Line: 5220, Name: TypeArguments
        return {
            UI = "ElectricFurnace",
            ResizeDynamically = false,
            InputMult = 0.75,
            Comfort = 1,
            Heat = 1,
            AutoTurnOn = true,
            PowerIn = 1,
            Slots = { "InputFurnace", "InputFurnace", "Output", "Output", "Output" }
        };
    end,

    Offset = CFrame.Angles(-1.5707963267948966, 3.141592653589793, 0) * CFrame.new(0, 2.1, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlaceableAngles = {
        Min = 0,
        Max = 45
    },
    PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
    PlacingFunc = v14,
    CollisionFunc = u33,
    Sounds = {
        Open = "FurnaceOpen"
    }
};
v82["Electric Heater"] = {
    Type = "Electricity",
    ElectricityType = true,
    RequiredPower = 2,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 1, 0),
    RayCheckLength = -1.5,
    RayCheckVector = "RightVector",
    FaceCamera = false,
    RotateOnSurface = true,

    TypeArguments = function() -- Line: 5276, Name: TypeArguments
        return {
            PowerIn = 1,
            Comfort = 10,
            Heat = 10
        };
    end,

    Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.Angles(3.141592653589793, 0, 0) * CFrame.new(-0.51, 0, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlaceableAngles = {
        Min = 89,
        Max = 91
    },
    PlaceWhitelist = { "Foundation", "Triangle Foundation", "Wall", "Half Wall", "Low Wall", "Doorway", "Window" },
    PlacingFunc = v14,
    CollisionFunc = u33,
    Sounds = {
        Open = "FurnaceOpen"
    }
};
v82.Windmill = {
    Type = "Electricity",
    PowerGenerated = 12,
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 2, 0),
    RayCheckLength = 4.2,
    FaceCamera = true,
    RotateOnSurface = true,
    PlaceExtraDistance = 6,
    InteractDistance = 11,

    TypeArguments = function() -- Line: 5314, Name: TypeArguments
        return {
            PowerOut = 4
        };
    end,

    Offset = CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 1.85, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlaceableAngles = {
        Min = 0,
        Max = 45
    },
    PlaceWhitelist = { "Terrain", "_Floor", "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "U-Shaped Stairs", "L-Shaped Stairs" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82["Water Turbine"] = {
    Type = "Electricity",
    PowerGenerated = 24,
    ElectricityType = true,
    DecayType = "UnderBase",
    DamageType = "BenchWood",
    PickupBehavior = "HammerOnly",
    DisplayHealthOnly = false,
    GuiOffset = Vector3.new(0, 2, 0),
    RayCheckLength = 8,
    FaceCamera = true,
    RotateOnSurface = true,
    PlaceExtraDistance = 6,
    InteractDistance = 16,

    TypeArguments = function() -- Line: 5349, Name: TypeArguments
        return {
            PowerOut = 12
        };
    end,

    Offset = CFrame.Angles(-1.5707963267948966, 0, 0) * CFrame.new(0, 8, 0),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlaceableAngles = {
        Min = -15,
        Max = 15
    },
    PlaceWhitelist = { "Terrain" },
    PlacingFunc = v14,
    CollisionFunc = u33
};
v82.Foundation = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Top",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = false,
    LenientCollision = false,

    TypeArguments = function() -- Line: 5386, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = v47,
    NonBaseCollisionFunc = u24,
    SnapPoints = {
        v55(5, function(p111) -- Line: 5406
            return CFrame.new(0, (p111 - 3) * 5, 10), { "Foundation" }, 1;
        end),
        v55(5, function(p112) -- Line: 5410
            return CFrame.new(0, (p112 - 3) * 5, -10), { "Foundation" }, 2;
        end),
        v55(5, function(p113) -- Line: 5414
            return CFrame.new(10, (p113 - 3) * 5, 0), { "Foundation" }, 3;
        end),
        v55(5, function(p114) -- Line: 5418
            return CFrame.new(-10, (p114 - 3) * 5, 0), { "Foundation" }, 4;
        end),
        v55(5, function(p115) -- Line: 5424
            return CFrame.new((p115 - 3) * 5, 0, 9.333, 0, -1, 0, 0, 0, 1, -1, 0, 0), { "Triangle Foundation" }, 1;
        end),
        v55(5, function(p116) -- Line: 5428
            return CFrame.new((p116 - 3) * 5, 6.83, -2.497, 0, -1, 0, 0.5, 0, -0.866, 0.866, 0, 0.5), { "Triangle Foundation" }, 2;
        end),
        v55(5, function(p117) -- Line: 5432
            return CFrame.new((p117 - 3) * 5, -6.83, -2.497, 0, -1, 0, 0.866, 0, -0.5, 0.5, 0, 0.866), { "Triangle Foundation" }, 3;
        end),
        {
            AttachmentIndex = 1,
            BenchNames = { "Foundation Steps" },
            Offset = CFrame.new(0, -2.5, -10)
        }
    },
    AttachmentChecks = {
        {
            MaxRange = 11,
            BenchNames = { "Foundation", "Triangle Foundation", "Foundation Steps" },
            Checks = {
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(4, -10, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-4, -10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(4, -10, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(-4, -10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(4, -10, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-4, -10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(4, -10, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(-4, -10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(4, 10, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-4, 10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(4, 10, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(-4, 10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(4, 10, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-4, 10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(4, 10, -4.4)
                        },
                        {
                            Length = 0.7,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(-4, 10, -4.4)
                        }
                    }
                }
            }
        },
        {
            MaxRange = 9,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window", "Half Wall", "Low Wall", "Wall Block" },
            Checks = {
                {
                    AttachmentIndex = 5,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(4, 0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-4, 0.6, -4.3)
                        }
                    }
                },
                {
                    AttachmentIndex = 6,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(4, 0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(-4, 0.6, -4.3)
                        }
                    }
                },
                {
                    AttachmentIndex = 7,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(4, 0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-4, 0.6, -4.3)
                        }
                    }
                },
                {
                    AttachmentIndex = 8,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(4, 0.6, -4.3)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(-4, 0.6, -4.3)
                        }
                    }
                }
            }
        }
    },
    NextConnections = { 1, 2, 3, 4, 5, 6, 7, 8 }
};
v82["Triangle Foundation"] = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Top",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = false,
    LenientCollision = false,

    TypeArguments = function() -- Line: 5672, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.Angles(0, 3.141592653589793, -1.5707963267948966),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = v47,
    NonBaseCollisionFunc = u24,
    SnapPoints = {
        v55(5, function(p118) -- Line: 5692
            return CFrame.new((p118 - 3) * 5, 0, 8.666, 1, 0, 0, 0, -1, 0, 0, 0, -1), { "Triangle Foundation" }, 1;
        end),
        v55(5, function(p119) -- Line: 5696
            return CFrame.new((p119 - 3) * 5, 3.748, -2.167, 1, 0, 0, 0, 0.5, 0.866, 0, -0.866, 0.5), { "Triangle Foundation" }, 2;
        end),
        v55(5, function(p120) -- Line: 5700
            return CFrame.new((p120 - 3) * 5, -3.748, -2.167, 1, 0, 0, 0, 0.5, -0.866, 0, 0.866, 0.5), { "Triangle Foundation" }, 3;
        end),
        v55(5, function(p121) -- Line: 5706
            return CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, (p121 - 3) * 5, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1), { "Foundation" }, 1;
        end),
        v55(5, function(p122) -- Line: 5710
            return CFrame.Angles(0, 0, 0) * CFrame.new(0, (p122 - 3) * 5, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1), { "Foundation" }, 2;
        end),
        v55(5, function(p123) -- Line: 5714
            return CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(0, (p123 - 3) * 5, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1), { "Foundation" }, 3;
        end),
        v55(5, function(p124) -- Line: 5718
            return CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(0, (p124 - 3) * 5, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1), { "Foundation" }, 4;
        end),
        {
            AttachmentIndex = 1,
            BenchNames = { "Foundation Steps" },
            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(0, -2.5, -9.333, 0, 1, 0, -1, 0, 0, 0, 0, 1)
        }
    },
    AttachmentChecks = {
        {
            MaxRange = 9,
            BenchNames = { "Foundation", "Triangle Foundation", "Foundation Steps" },
            Checks = {
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, -4, -4.1)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, -4, -4.1)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(0, 5, -1.9)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(0, -2.6, -1.9)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(0, -5, -1.9)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(0, 2.6, -1.9)
                        }
                    }
                },
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-10, -4, -4.1)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-10, -4, -4.1)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(-10, 5, -1.9)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(-10, -2.6, -1.9)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(10, -5, -1.9)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(10, 2.6, -1.9)
                        }
                    }
                },
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(10, -4, -4.1)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(10, -4, -4.1)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(10, 5, -1.9)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(10, -2.6, -1.9)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(10, -5, -1.9)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(10, 2.6, -1.9)
                        }
                    }
                }
            }
        },
        {
            MaxRange = 9,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window", "Half Wall", "Low Wall", "Wall Block" },
            Checks = {
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0.6, 4, -3.6)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0.6, -4, -3.6)
                        }
                    }
                },
                {
                    AttachmentIndex = 5,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(-0.6, 5, -1.6)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(1.0471975511965976, 0, 0) * CFrame.new(-0.6, -2.6, -1.6)
                        }
                    }
                },
                {
                    AttachmentIndex = 6,
                    Rays = {
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(-0.6, -5, -1.6)
                        },
                        {
                            Length = 0.6,
                            Offset = CFrame.Angles(-1.0471975511965976, 0, 0) * CFrame.new(-0.6, 2.6, -1.6)
                        }
                    }
                }
            }
        }
    },
    NextConnections = { 1, 2, 3, 4, 5, 6 }
};
v82["Foundation Steps"] = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Top",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 5906, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = v47,
    NonBaseCollisionFunc = u24,
    SnapPoints = {
        {
            AttachmentIndex = 1,
            BenchNames = { "Foundation" },
            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, -2.5, -10)
        },
        {
            AttachmentIndex = 2,
            BenchNames = { "Foundation" },
            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(0, -2.5, -10)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Foundation" },
            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(0, -2.5, -10)
        },
        {
            AttachmentIndex = 4,
            BenchNames = { "Foundation" },
            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(0, -2.5, -10)
        },
        {
            AttachmentIndex = 1,
            BenchNames = { "Triangle Foundation" },
            Offset = CFrame.new(2.5, 0, 9.333, 0, -1, 0, 0, 0, 1, -1, 0, 0) * CFrame.Angles(0, 1.5707963267948966, 0)
        },
        {
            AttachmentIndex = 2,
            BenchNames = { "Triangle Foundation" },
            Offset = CFrame.new(2.5, 6.83, -2.497, 0, -1, 0, 0.5, 0, -0.866, 0.866, 0, 0.5)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Triangle Foundation" },
            Offset = CFrame.new(2.5, -6.83, -2.497, 0, -1, 0, 0.866, 0, -0.5, 0.5, 0, 0.866) * CFrame.Angles(0, 1.5707963267948966, 0)
        },
        {
            AttachmentIndex = 1,
            BenchNames = { "Foundation Steps" },
            Offset = CFrame.new(0, -5, -10)
        },
        {
            AttachmentIndex = 2,
            BenchNames = { "Foundation Steps" },
            Offset = CFrame.new(0, 5, 10)
        }
    },
    AttachmentChecks = {
        {
            MaxRange = 11,
            BenchNames = { "Foundation", "Triangle Foundation", "Foundation Steps" },
            Checks = {
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(4, 0, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-4, 0, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(4, -10, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(-4, -10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(4, -10, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-4, -10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(4, -10, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(-4, -10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(4, -10, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-4, -10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(4, 10, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(-4, 10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(4, 10, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(-4, 10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(4, 10, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(-4, 10, -4.4)
                        }
                    }
                },
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(4, 10, -4.4)
                        },
                        {
                            Length = 1.2,
                            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-4, 10, -4.4)
                        }
                    }
                }
            }
        }
    },
    StabilityInfo = {
        Checks = { {
                Connections = { 2 },
                StabilityLoss = { 0 }
            } }
    },
    NextConnections = { 1, 2, 3, 4 }
};
v82.Wall = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Front",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6154, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    NonBaseCollisionFunc = u24,
    SnapPoints = v63.SnapPoints,
    AttachmentChecks = v63.AttachmentChecks,
    StabilityInfo = v63.StabilityInfo,
    NextConnections = v63.NextConnections,
    WallBlockOffset = CFrame.new(0, -3.75, 0)
};
v82["Wall Frame"] = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6180, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = u33,
    NonBaseCollisionFunc = u24,
    SnapPoints = v63.SnapPoints,
    AttachmentChecks = v63.AttachmentChecks,
    StabilityInfo = v63.StabilityInfo,
    NextConnections = v63.NextConnections,
    WallBlockOffset = CFrame.new(0, -3.75, 0)
};
v82.Doorway = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Front",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6204, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    NonBaseCollisionFunc = u24,
    SnapPoints = v63.SnapPoints,
    AttachmentChecks = v63.AttachmentChecks,
    StabilityInfo = v63.StabilityInfo,
    NextConnections = v63.NextConnections,
    RotateIgnores = { 13 },
    WallBlockOffset = CFrame.new(0, -3.75, 0)
};
v82.Window = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Front",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6231, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    NonBaseCollisionFunc = u24,
    SnapPoints = v63.SnapPoints,
    AttachmentChecks = v63.AttachmentChecks,
    StabilityInfo = v63.StabilityInfo,
    NextConnections = v63.NextConnections,
    RotateIgnores = { 13 },
    WallBlockOffset = CFrame.new(0, -3.75, 0)
};
v82["Half Wall"] = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Front",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6258, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    NonBaseCollisionFunc = u24,
    SnapPoints = {
        {
            AttachmentIndex = 5,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(0, 2.5, 5)
        },
        {
            AttachmentIndex = 6,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 2.5, 5)
        },
        {
            AttachmentIndex = 7,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(0, 2.5, 5)
        },
        {
            AttachmentIndex = 8,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(0, 2.5, 5)
        },
        {
            AttachmentIndex = 4,
            BenchNames = { "Triangle Foundation", "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(-2.5, 0, 4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1)
        },
        {
            AttachmentIndex = 5,
            BenchNames = { "Triangle Foundation", "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(-2.5, 2.5, 0, 0, -1, 0, -0.5, 0, 0.866, -0.866, 0, -0.5)
        },
        {
            AttachmentIndex = 6,
            BenchNames = { "Triangle Foundation", "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(-2.5, -2.5, 0, 0, -1, 0, -0.5, 0, -0.866, 0.866, 0, -0.5)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window" },
            Offset = CFrame.new(0, 7.5, 0)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Half Wall" },
            Offset = CFrame.new(0, 5, 0)
        }
    },
    AttachmentChecks = {
        {
            MaxRange = 13,
            BenchNames = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame" },
            Checks = {
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, -1.8, 0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, -1.8, 0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, -1.8, -0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, -1.8, -0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                }
            }
        },
        {
            MaxRange = 13,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window", "Half Wall" },
            Checks = {
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(0, 2.3, 0) * CFrame.Angles(1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 4,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(0, -2.3, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 5,
                    Rays = {
                        {
                            Length = 0.2,
                            Offset = CFrame.new(-5.6, 0, 0.6) * CFrame.Angles(0, 0, 0)
                        },
                        {
                            Length = 0.2,
                            Offset = CFrame.new(-5.6, 0, -0.6) * CFrame.Angles(3.141592653589793, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 6,
                    Rays = {
                        {
                            Length = 0.2,
                            Offset = CFrame.new(5.6, 0, 0.6) * CFrame.Angles(0, 0, 0)
                        },
                        {
                            Length = 0.2,
                            Offset = CFrame.new(5.6, 0, -0.6) * CFrame.Angles(3.141592653589793, 0, 0)
                        }
                    }
                }
            }
        },
        {
            MaxRange = 9,
            BenchNames = { "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame" },
            Checks = {
                {
                    AttachmentIndex = 7,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, 1.8, 0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, 1.8, 0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 8,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, 1.8, -0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, 1.8, -0.6) * CFrame.Angles(1.5707963267948966, 0, 0)
                        }
                    }
                }
            }
        }
    },
    StabilityInfo = {
        LossPerHeight = {
            Start = 0,
            PerStud = 1
        },
        Checks = { {
                Connections = { 4 },
                StabilityLoss = { 0 }
            }, {
                Connections = { 1, 2 },
                StabilityLoss = { 0, 0 },
                BenchNames = { "Foundation", "Triangle Foundation" }
            }, {
                Connections = { 1, 2 },
                StabilityLoss = { 20, 10 }
            }, {
                Connections = { 5, 6 },
                StabilityLoss = { 60, 40 }
            }, {
                Connections = { 7, 8 },
                StabilityLoss = { 40, 40 }
            } }
    },
    NextConnections = { 3, 5, 6, 7, 8 },
    WallBlockOffset = CFrame.new(0, -1.25, 0)
};
v82["Low Wall"] = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Front",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6478, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 3.141592653589793, 0),
    OffsetSnappedFacingAway = CFrame.Angles(0, 3.141592653589793, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    NonBaseCollisionFunc = u24,
    SnapPoints = {
        {
            AttachmentIndex = 5,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 0, 0) * CFrame.new(0, 1.25, 5)
        },
        {
            AttachmentIndex = 6,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.new(0, 1.25, 5)
        },
        {
            AttachmentIndex = 7,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, 1.5707963267948966, 0) * CFrame.new(0, 1.25, 5)
        },
        {
            AttachmentIndex = 8,
            BenchNames = { "Foundation", "Floor", "Floor Frame" },
            Offset = CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(0, 1.25, 5)
        },
        {
            AttachmentIndex = 4,
            BenchNames = { "Triangle Foundation", "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(-1.25, 0, 4.333, 0, -1, 0, 1, 0, 0, 0, 0, 1)
        },
        {
            AttachmentIndex = 5,
            BenchNames = { "Triangle Foundation", "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(-1.25, 2.5, 0, 0, -1, 0, -0.5, 0, 0.866, -0.866, 0, -0.5)
        },
        {
            AttachmentIndex = 6,
            BenchNames = { "Triangle Foundation", "Triangle Floor", "Triangle Floor Frame" },
            Offset = CFrame.new(-1.25, -2.5, 0, 0, -1, 0, -0.5, 0, -0.866, 0.866, 0, -0.5)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window" },
            Offset = CFrame.new(0, 6.25, 0)
        },
        {
            AttachmentIndex = 3,
            BenchNames = { "Half Wall" },
            Offset = CFrame.new(0, 3.75, 0)
        }
    },
    AttachmentChecks = {
        {
            MaxRange = 13,
            BenchNames = { "Foundation", "Triangle Foundation", "Floor", "Triangle Floor", "Floor Frame", "Triangle Floor Frame" },
            Checks = {
                {
                    AttachmentIndex = 1,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, -0.55, 0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, -0.55, 0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                },
                {
                    AttachmentIndex = 2,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(4, -0.55, -0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        },
                        {
                            Length = 0.4,
                            Offset = CFrame.new(-4, -0.55, -0.6) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                }
            }
        },
        {
            MaxRange = 13,
            BenchNames = { "Wall", "Wall Frame", "Doorway", "Window", "Half Wall" },
            Checks = {
                {
                    AttachmentIndex = 3,
                    Rays = {
                        {
                            Length = 0.4,
                            Offset = CFrame.new(0, -1.05, 0) * CFrame.Angles(-1.5707963267948966, 0, 0)
                        }
                    }
                }
            }
        }
    },
    StabilityInfo = {
        LossPerHeight = {
            Start = 0,
            PerStud = 1
        },
        Checks = { {
                Connections = { 3 },
                StabilityLoss = { 0 }
            }, {
                Connections = { 1, 2 },
                StabilityLoss = { 0, 0 },
                BenchNames = { "Foundation", "Triangle Foundation" }
            }, {
                Connections = { 1, 2 },
                StabilityLoss = { 5, 5 }
            } }
    },
    NextConnections = {},
    WallBlockOffset = CFrame.new(0, 0, 0)
};
v82.Floor = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Bottom",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    IgnoreBuildBlock = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6621, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = u33,
    NonBaseCollisionFunc = u24,
    SnapPoints = v64.SnapPoints,
    AttachmentChecks = v64.AttachmentChecks,
    StabilityInfo = v64.StabilityInfo,
    NextConnections = v64.NextConnections
};
v82["Floor Frame"] = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    IgnoreBuildBlock = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6646, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = u33,
    NonBaseCollisionFunc = u24,
    SnapPoints = v64.SnapPoints,
    AttachmentChecks = v64.AttachmentChecks,
    StabilityInfo = v64.StabilityInfo,
    NextConnections = v64.NextConnections
};
v82["Triangle Floor"] = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Bottom",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    IgnoreBuildBlock = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6670, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.Angles(0, 3.141592653589793, -1.5707963267948966),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = v47,
    NonBaseCollisionFunc = u24,
    SnapPoints = v65.SnapPoints,
    AttachmentChecks = v65.AttachmentChecks,
    StabilityInfo = v65.StabilityInfo,
    NextConnections = v65.NextConnections
};
v82["Triangle Floor Frame"] = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    IgnoreBuildBlock = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6695, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.Angles(0, 3.141592653589793, -1.5707963267948966),
    RotateOffset = CFrame.new(),
    PlacingFunc = v15,
    CollisionFunc = v47,
    NonBaseCollisionFunc = u24,
    SnapPoints = v65.SnapPoints,
    AttachmentChecks = v65.AttachmentChecks,
    StabilityInfo = v65.StabilityInfo,
    NextConnections = v65.NextConnections
};
v82["L-Shaped Stairs"] = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Top",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6719, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    NonBaseCollisionFunc = u24,
    SnapPoints = v66.SnapPoints,
    AttachmentChecks = v66.AttachmentChecks,
    StabilityInfo = v66.StabilityInfo,
    NextConnections = v66.NextConnections
};
v82["U-Shaped Stairs"] = {
    Type = "BasePart",
    DecayType = "Upkeep",
    DamageType = "Twig",
    InteractDistance = 12,
    SoftSide = "Top",
    DisplayHealthOnly = true,
    GuiOffset = Vector3.new(0, 0, 0),
    FaceCamera = true,
    SnapOnly = true,

    TypeArguments = function() -- Line: 6744, Name: TypeArguments
        return {};
    end,

    Offset = CFrame.new(),
    UnsnappedOffset = CFrame.new(),
    RotateOffset = CFrame.Angles(0, 1.5707963267948966, 0),
    PlacingFunc = v15,
    CollisionFunc = u33,
    NonBaseCollisionFunc = u24,
    SnapPoints = v66.SnapPoints,
    AttachmentChecks = v66.AttachmentChecks,
    StabilityInfo = v66.StabilityInfo,
    NextConnections = v66.NextConnections
};
u4 = v82;

for _, v in pairs(u4) do
    local SnapPoints = v.SnapPoints;

    if SnapPoints then
        local v125 = {};

        for _, v2 in pairs(SnapPoints) do
            for _, v3 in pairs(v2[1] and v2 and v2 or { v2 }) do
                table.insert(v125, v3);
            end;
        end;

        v.SnapPoints = v125;
    end;
end;

return u4;
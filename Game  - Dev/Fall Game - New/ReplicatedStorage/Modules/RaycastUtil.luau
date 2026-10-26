-- [PATH] ReplicatedStorage / Modules / RaycastUtil @Type ModuleScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local VFX = ReplicatedStorage:WaitForChild("VFX");
local VFX2 = workspace:WaitForChild("VFX");
local Animals = workspace:WaitForChild("Animals");
local Events = workspace:WaitForChild("Events");
local Values = ReplicatedStorage:WaitForChild("Values");
local LocalPlayer = Players.LocalPlayer;

return {
    FilterFunction = function(p1, u2) -- Line: 27, Name: FilterFunction
        -- upvalues: Animals (copy), Events (copy)
        return (u2 == "Hit" or (u2 == "HitIgnore" or (u2 == "HitMelee" or (u2 == "HitMeleeIgnore" or u2 == "HitNoMeleeMouse")))) and function(p3) -- Line: 28
            -- upvalues: Animals (ref), Events (ref), u2 (copy)
            local Parent = p3.Parent;

            if not Parent then
                return;
            end;

            if Parent.Parent:FindFirstChild("Humanoid") and not (Parent:IsDescendantOf(Animals) or Parent:IsDescendantOf(Events)) or (Parent.Parent.Name == "Attachments" and Parent.Parent:IsA("Folder") or (Parent.Name == "Jail Wall" or p3:FindFirstAncestor("Jail Door")) and u2 == "Hit") or p3.CollisionGroup == "Items" and (u2 == "Hit" and (Parent.Name == "Body Bag" or (Parent.Name == "Contents" or (Parent.Name == "Salvaged Backpack" or Parent.Name == "Military Backpack")))) then
                return Parent;
            end;

            if Parent:FindFirstChild("Humanoid") and (p3.Name == "HumanoidRootPart" or p3.Name == "CollisionPart") or not (p3.Transparency < 1 or u2 == "HitMelee" and (Parent.Name == "NodeSpark" or Parent.Name == "TreeX") or p3.CanCollide) or (p3.Name == "LeafPart" or (p3.CollisionGroup == "VehicleFake" or p3.Name == "CactusPart" and u2 == "Hit") or p3.Name == "SignPart" and not u2:find("Melee")) then
                return p3;
            end;
        end or (u2 == "HitPlace" and function(p4) -- Line: 36
            local Parent = p4.Parent;

            if Parent.Parent.Name == "Attachments" and Parent.Parent:IsA("Folder") then
                return Parent;
            end;

            if p4.Transparency >= 1 and (Parent.Name ~= "CollisionParts" and (p4.Name ~= "SpawnPart" and not p4.CanCollide)) or (Parent:FindFirstChild("CollisionParts") or Parent.Parent:FindFirstChild("CollisionParts") and Parent.Name ~= "CollisionParts" or (p4.Name == "LeafPart" or p4.CollisionGroup == "VehicleFake")) then
                return p4;
            end;

            if Parent:FindFirstChild("Humanoid") and (p4.Name ~= "HumanoidRootPart" and p4.Name ~= "CollisionPart") then
                return p4;
            end;

            if Parent.Parent:FindFirstChild("Humanoid") then
                return Parent;
            end;
        end or (u2 == "View" or (u2 == "ViewBench" or (u2 == "ViewExtra" or u2 == "ViewPlant"))) and function(p5) -- Line: 53
            -- upvalues: u2 (copy)
            local Parent = p5.Parent;
            local v6 = Parent:FindFirstChild("Humanoid") or Parent.Parent:FindFirstChild("Humanoid");

            if v6 and (u2 == "View" or (u2 == "ViewPlant" or v6.Parent.Name ~= "Sleeper")) and (u2 ~= "ViewBench" or v6.Parent.Name ~= "Contents") then
                return v6.Parent;
            end;

            if Parent.Parent.Name == "Attachments" and Parent.Parent:IsA("Folder") or (u2 == "ViewPlant" and (Parent.Name == "Floor Grill" or Parent.Name == "Barrel Light") or u2 == "ViewExtra" and (Parent.Name == "Wooden Boat" or (Parent.Name == "Military Boat" or Parent.Name == "Salvaged Flycopter"))) then
                return Parent;
            end;

            if ((u2 == "View" or u2 == "ViewPlant") and p5.Transparency >= 1 or u2 == "ViewBench" and p5.Transparency == 1) and not p5.CanCollide or (p5.Name == "LeafPart" or (u2 == "View" or u2 == "ViewExtra") and p5.CollisionGroup == "VehicleFake" or (p5.Name == "CactusPart" or p5.Name == "SignPart" or (u2 == "View" or u2 == "ViewPlant") and p5.CollisionGroup == "Items")) then
                return p5;
            end;

            if u2 == "ViewExtra" and (p5.CollisionGroup == "Items" or not p5.CanCollide) then
                return p5;
            end;

            if Parent and u2 == "ViewExtra" then
                local Parent2 = Parent.Parent;

                if Parent2 and Parent2.Name == "Salvaged Flycopter" then
                    return Parent2;
                end;
            end;
        end or (u2 == "PlacementDefault" and function(p7) -- Line: 70
            if not p7 then
                return;
            end;

            local Parent = p7.Parent;

            if not Parent then
                return;
            end;

            if p7.Name == "LeafPart" or p7.CollisionGroup == "VehicleFake" then
                return p7;
            end;

            if p7.Transparency == 1 and (p7.Position.Y == 478 or (p7.Position.Y == 578 or p7.Name == "RadiationPart")) or Parent.Parent.Name == "Attachments" and Parent.Parent:IsA("Folder") then
                return p7.Parent;
            end;

            if p7.Transparency == 1 and p7.Name == "BuildingPriv" then
                return p7;
            end;

            local v8 = Parent:FindFirstChild("Humanoid") or Parent.Parent:FindFirstChild("Humanoid");

            if v8 then
                return v8.Parent;
            end;
        end or (u2 == "BuildingPrivCheck" and function(p9) -- Line: 90
            local v10 = p9.Name == "BuildingPriv" and p9:FindFirstAncestor("Base");

            if v10 then
                local v11 = v10:FindFirstChild("Base Cabinet");

                if v11 and #v11:GetChildren() > 0 then
                    return;
                end;
            end;

            return p9;
        end or false)));
    end,

    MouseRaycast = function(p12, p13, p14, p15, p16, p17, p18) -- Line: 102, Name: MouseRaycast
        -- upvalues: LocalPlayer (ref)
        if not LocalPlayer then
            return;
        end;

        local v19 = {};

        for i = 1, 10 do
            local debug_info_ret = debug.info(i, "s");

            if not debug_info_ret then
                break;
            end;

            table.insert(v19, debug_info_ret);
            local _ = i;
        end;

        if v19[1] == "ReplicatedStorage.Modules.RaycastUtil" and (v19[2] == "ReplicatedStorage.Modules.VectorUtil" and (v19[3] == "[C]" and (v19[4] == v19[2] and (v19[6] == v19[2] and v19[9] == nil))) or v19[2] == `Workspace .{LocalPlayer.Name}.ViewmodelController` and (v19[3] == nil and #v19 == 2)) then
            local workspace_CurrentCamera = workspace.CurrentCamera;
            local v20 = workspace_CurrentCamera:ViewportPointToRay(workspace_CurrentCamera.ViewportSize.X * 0.5, workspace_CurrentCamera.ViewportSize.Y * 0.5);
            local v21, v22, v23, v24 = p12:Raycast(v20.Origin, v20.Direction * (p15 or 1024), p16 or "Blacklist", p14, p17, p13, p18);

            return v22, v21, v23, v24, nil, "sigma";
        end;

        if LocalPlayer then
            print("`");
        end;

        LocalPlayer = nil;
    end,

    GetBaseCabinetUnder = function(p25, p26, p27) -- Line: 129, Name: GetBaseCabinetUnder
        -- upvalues: VFX2 (copy), Animals (copy), LocalPlayer (ref)
        local u28 = { VFX2, Animals };
        local u29 = nil;
        local u30 = nil;
        local v31;

        while true do
            v31 = p25:Raycast(Vector3.new(p26.X, 225.6, p26.Z), Vector3.new(0, -0.2, 0), "Blacklist", u28, false, function(p32) -- Line: 133
                -- upvalues: u28 (copy), u29 (ref), u30 (ref)
                if p32.Name ~= "BuildingPriv" then
                    return p32;
                end;

                local v33 = p32:FindFirstAncestor("Base");

                if v33 and not table.find(u28, v33) then
                    table.insert(u28, v33);
                    local v34 = v33:FindFirstChild("Base Cabinet");
                    local v35 = v34 and v34:FindFirstChild("Base Cabinet");

                    if v35 then
                        if v35:GetAttribute("Monument") then
                            u29 = v35;

                            return;
                        end;

                        local Attribute = v35:GetAttribute("Placed");
                        local v36 = u30 and u30.Parent and u30:GetAttribute("Placed");

                        if not v36 or Attribute < v36 then
                            u30 = v35;
                        end;
                    end;
                end;
            end);

            if u29 and v31 then
                break;
            end;

            if p27 or not v31 then
                return u30;
            end;
        end;

        if not LocalPlayer then
            v31:SetAttribute("LastEnter", os.time());
        end;

        return u29, v31:GetAttribute("Safe");
    end,

    Raycast = function(p37: table, p38: any, p39: vector, p40: string, p41: table, p42: string?, p43: any, p44: boolean?, p45: number, p46: any) -- Line: 169, Name: Raycast
        -- upvalues: VFX (copy), VFX2 (copy), Debris (copy), Values (copy)
        local v47 = type(p41) == "table" and p41 and p41 or { p41 };
        local v48 = (p45 or 0) + 1;
        local RaycastParams_new_ret = RaycastParams.new();
        RaycastParams_new_ret.FilterType = Enum.RaycastFilterType[p40];
        RaycastParams_new_ret.FilterDescendantsInstances = v47;
        RaycastParams_new_ret.IgnoreWater = p44;
        local v49;

        if type(p38) == "table" then
            v49 = p38.Type == "Block";
        else
            v49 = false;
        end;

        local v50;

        if type(p38) == "table" then
            v50 = p38.Type == "Sphere";
        else
            v50 = false;
        end;

        local v51;

        if v49 then
            v51 = workspace:Blockcast(p38.CF, p38.Size, p39, RaycastParams_new_ret);
        elseif v50 then
            v51 = workspace:Spherecast(p38.Position, p38.Size, p39, RaycastParams_new_ret);
        else
            v51 = workspace:Raycast(p38, p39, RaycastParams_new_ret);
        end;

        local v52 = v49 and p38.CF.Position;

        if not v52 then
            if v50 then
                v52 = p38.Position or p38;
            else
                v52 = p38;
            end;
        end;

        local v53 = v52 + p39;
        local v54;

        if v51 == nil then
            v54 = v53;
        else
            v54 = v51.Position or v53;
        end;

        local v55 = nil;

        if p42 then
            local v56 = VFX:FindFirstChild(p42) or VFX:FindFirstChild("DefaultRay");

            if v56 then
                local Magnitude = (p38 - v54).Magnitude;
                v55 = v56:Clone();

                for _, child in pairs(v55:GetChildren()) do
                    if child:IsA("BasePart") then
                        local Size = child.Size;
                        child.Size = Vector3.new(Magnitude, Size.Y, Size.Z);
                    end;
                end;

                v55:SetPrimaryPartCFrame(CFrame.lookAt(p38, v54) * CFrame.Angles(0, -1.5707963267948966, 0) * CFrame.new(-Magnitude / 2, 0, 0));
                v55.Parent = VFX2;

                if v55.Name == "GreenRay" or v55.Name == "BlueRay" then
                    Debris:AddItem(v55, 5);
                end;
            end;
        end;

        if not v51 then
            return nil, v54, nil, nil, v55, p46;
        end;

        local Instance = v51.Instance;

        if p43 and type(p43) == "function" then
            local v57, v58 = p43(Instance);
            p46 = p46 or v58;

            if v57 then
                for _, v in pairs(type(v57) == "table" and v57 and v57 or { v57 }) do
                    table.insert(v47, v);
                end;

                local v59 = Values.Loading.Value and 50 or 250;

                if v48 < v59 then
                    if not (v49 or v50) then
                        local v60 = v54 - p39.Unit * 0.2;

                        return p37:Raycast(v60, v53 - v60, p40, v47, p42, p43, p44, v48, p46);
                    end;

                    local _ = p38.Size;
                    local v61 = v49 and p38.CF or CFrame.new(p38.Position);
                    local Distance = v51.Distance;
                    local v62, v63, v64 = v61:ToEulerAnglesXYZ();
                    local v65 = v52 + p39.Unit * math.max(Distance - 0.5, 0);
                    local v66 = CFrame.new(v65) * CFrame.Angles(v62, v63, v64);

                    if v49 then
                        p38.CF = v66;
                    elseif v50 then
                        p38.Position = v66.Position;
                    end;

                    return p37:Raycast(p38, v53 - v65, p40, v47, p42, p43, p44, v48, p46);
                end;

                warn((`[WARNING] RAYCAST RE-ENTRANCY EXCEEDED ({v59})`));
            end;
        end;

        return Instance, v54, v51.Normal, v51.Material, v55, p46;
    end,

    GetClosestPointFromRay = function(p67: table, p68: vector, p69: vector, p70: vector) -- Line: 257, Name: GetClosestPointFromRay
        local v71 = p69 - p68;
        local Magnitude = v71.Magnitude;
        local Unit = v71.Unit;
        local v72 = (p70 - p68):Dot(Unit);
        local v73 = (Magnitude <= 0.0001 or v72 <= 0) and 0 or math.clamp(v72, 0, Magnitude);

        return p68 + Unit * v73, v73, Magnitude;
    end,

    NormalToFace = function(p74, p75, p76) -- Line: 267, Name: NormalToFace
        for _, v in pairs(Enum.NormalId:GetEnumItems()) do
            if p76.CFrame:VectorToWorldSpace(Vector3.FromNormalId(v)):Dot(p75) > 0.999 then
                return v;
            end;
        end;
    end
};
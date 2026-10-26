-- [PATH] ReplicatedStorage / CharacterScripts / BuildController @Type LocalScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Benches = ReplicatedStorage:WaitForChild("Benches");
local Values = ReplicatedStorage:WaitForChild("Values");
local Bases = workspace:WaitForChild("Bases");
local VFX = workspace:WaitForChild("VFX");
local Benches2 = VFX:WaitForChild("Benches");
local LocalPlayer = Players.LocalPlayer;
local script_Parent = script.Parent;
local Humanoid = script_Parent:WaitForChild("Humanoid");
local workspace_CurrentCamera = workspace.CurrentCamera;
local InventoryController = script_Parent:WaitForChild("InventoryController");
local WheelController = script_Parent:WaitForChild("WheelController");
local CameraController = script_Parent:WaitForChild("CameraController");
local InteractController = script_Parent:WaitForChild("InteractController");
local EquipController = script_Parent:WaitForChild("EquipController");
local PreferredInputController = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PreferredInputController");

local function _() -- Line: 38
    -- upvalues: PreferredInputController (copy)
    local v1 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

    return v1;
end;

local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"));
local Items = require(Modules:WaitForChild("Items"));
local BenchInfo = require(Modules:WaitForChild("BenchInfo"));
local RecipeModule = require(Modules:WaitForChild("RecipeModule"));
local BasePartInfo = require(Modules:WaitForChild("BasePartInfo"));
local SettingsModule = require(Modules:WaitForChild("SettingsModule"));
local AssetContainer = require(Modules:WaitForChild("AssetContainer"));
local ActiveBenchModule = require(Modules:WaitForChild("ActiveBenchModule"));
local u2 = AssetContainer();
local EquipBench = script:WaitForChild("EquipBench");
local Build = ReplicatedStorage:WaitForChild("ClientSignals"):WaitForChild("Build");
local u3 = {
    Twig = { "Wood", "Stone", "Metal", "Steel" },
    Wood = { "Stone", "Metal", "Steel" },
    Stone = { "Metal", "Steel" },
    Metal = { "Steel" },
    Steel = {}
};
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = false;
local u13 = 0;
local CFrame_new_ret = CFrame.new();
local u14 = 0;
local u15 = "Foundation";
local u16 = nil;
local u17 = nil;
local u18 = {};
local u19 = nil;
local u20 = nil;
local u21 = {};
local u22 = false;
local u23 = true;
local u24 = 0;
local u25 = nil;
local u26 = {};
local u27 = false;

local function _(p28) -- Line: 97
    -- upvalues: InventoryController (copy)
    local v29 = InventoryController.Fetch:Invoke();

    if not v29 then
        return;
    end;

    local Toolbar = v29.Toolbar;

    if Toolbar then
        local v30 = Toolbar[p28 or script:GetAttribute("Equipped")];

        if v30 == nil then
            v30 = false;
        elseif v30 == 0 then
            v30 = false;
        end;

        return v30;
    end;
end;

local function u35() -- Line: 106
    -- upvalues: u12 (ref), u4 (ref), u10 (ref), InventoryController (copy), u11 (ref), u20 (ref), u9 (ref), u22 (ref), u21 (ref), u14 (ref), u24 (ref), u2 (copy), u15 (ref)
    if not (u12 and (u4 and (u4.Parent and u10))) then
        return;
    end;

    local v31 = InventoryController.Fetch:Invoke();
    local v32;

    if v31 then
        local Toolbar = v31.Toolbar;

        if Toolbar then
            v32 = Toolbar[script:GetAttribute("Equipped")];

            if v32 == nil then
                v32 = false;
            elseif v32 == 0 then
                v32 = false;
            end;
        else
            v32 = nil;
        end;
    else
        v32 = nil;
    end;

    if not (v32 and v32.ID) then
        return;
    end;

    if u11 == false then
        return;
    end;

    local v33;

    if v32.ID == 30 then
        v33 = u20 or "none";
    else
        v33 = u20 or (u9 or "none");
    end;

    local v34 = u22;

    if u21.Index and u14 % 2 == 1 then
        v34 = not v34;
    end;

    if v32.ID == 190 then
        u14 = u14 % 3 == 2 and 1 or (u14 % 3 == 1 and 2 or u14 % 3);
    end;

    if tick() - u24 < 0.05 then
        return;
    end;

    u24 = tick();
    u2("Fire", "\239\191\189\107\239\191\189\052\111\239\191\189\239\191\189\239\191\189\239\191\189\195\135\239\191\189\239\191\189\048\239\191\189\195\149\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189", "\076\239\191\189\195\184\194\172\101\239\191\189\195\174\239\191\189\239\191\189\239\191\189\195\155\239\191\189\239\191\189\239\191\189\095\239\191\189\082\081\239\191\189\085", v33, u4.PrimaryPart.CFrame, u14, u15, u21.Index or 0, v34);
end;

local function _(p36, p37, p38, p39) -- Line: 135
    -- upvalues: u18 (ref)
    local v40 = u18[p36];

    if not (v40 and v40[p38]) then
        if not v40 then
            v40 = {};
            u18[p36] = v40;
        end;

        v40[p38] = p37.CFrame * p39.Offset;

        return true;
    end;
end;

local u41 = {};

local function u62(p42) -- Line: 154
    -- upvalues: Humanoid (copy), script_Parent (copy), u19 (ref), u18 (ref), u41 (copy), u16 (ref), BenchInfo (copy), Bases (copy), NumberUtil (copy)
    if not (Humanoid and (Humanoid.Parent and (script_Parent and (script_Parent.Parent and script_Parent.PrimaryPart)))) then
        return;
    end;

    local Position = script_Parent.PrimaryPart.Position;
    u19 = Position;

    if not p42 then
        u18 = {};
    end;

    local v43 = u41[u16];

    if not v43 then
        local v44 = BenchInfo[u16];

        if not v44 then
            return;
        end;

        local SnapPoints = v44.SnapPoints;

        if not SnapPoints then
            return;
        end;

        v43 = {};

        for i, v in pairs(SnapPoints) do
            if not v.Unsnappable then
                local AttachmentIndex = v.AttachmentIndex;
                local v45 = v;
                local v46 = i;

                for _, v2 in pairs(v.BenchNames) do
                    local v47 = v43[v2];

                    if not v47 then
                        v47 = {};
                        v43[v2] = v47;
                    end;

                    local v48 = v47[AttachmentIndex];

                    if not v48 then
                        v48 = {};
                        v47[AttachmentIndex] = v48;
                    end;

                    table.insert(v48, {
                        Index = v46,
                        SnapTable = v45
                    });
                end;
            end;
        end;

        u41[u16] = v43;
    end;

    tick();
    local v49 = 0;
    local v50 = 0;

    for _, child in pairs(Bases:GetChildren()) do
        if child.Name ~= "Loners" and child.Parent then
            local v51 = child:FindFirstChild("Base Cabinet");
            local v52, v53, v54, v55, v56, v57, v58, v59, v60;

            if v51 then
                local v61 = v51:FindFirstChild("Base Cabinet");

                if v61 and not NumberUtil:IsWithin(v61:GetPivot().Position, Position, 750) then
                    v49 = v49 + 1;

                    if v49 % 120 == 0 then
                        task.wait();
                    end;
                else
                    v52 = child;

                    for i, v in pairs(v43) do
                        v53 = v52:FindFirstChild(i);

                        if v53 then
                            v54 = v;

                            for _, child2 in pairs(v53:GetChildren()) do
                                if child2.Parent then
                                    v55 = child2.PrimaryPart;

                                    if v55 then
                                        if NumberUtil:IsWithin(v55.CFrame.Position, Position, 100) then
                                            v56 = child2;

                                            for i2, v2 in pairs(v54) do
                                                v57 = v55:FindFirstChild("Connection" .. i2);

                                                if v57 and (v57.Value and v57.Value.Parent) then
                                                    v49 = v49 + 1;

                                                    if v49 % 120 == 0 then
                                                        task.wait();
                                                    end;
                                                else
                                                    for _, v3 in pairs(v2) do
                                                        v58 = v3.Index;
                                                        v59 = v3.SnapTable;
                                                        v60 = u18[v56];

                                                        if not (v60 and v60[v58]) then
                                                            if not v60 then
                                                                v60 = {};
                                                                u18[v56] = v60;
                                                            end;

                                                            v60[v58] = v55.CFrame * v59.Offset;
                                                        end;
                                                    end;
                                                end;
                                            end;
                                        end;

                                        v50 = v50 + 1;

                                        if v50 % 80 == 0 then
                                            task.wait();
                                        end;
                                    else
                                        v49 = v49 + 1;

                                        if v49 % 120 == 0 then
                                            task.wait();
                                        end;
                                    end;
                                end;
                            end;
                        else
                            v49 = v49 + 1;

                            if v49 % 120 == 0 then
                                task.wait();
                            end;
                        end;
                    end;
                end;
            else
                v52 = child;

                for i, v in pairs(v43) do
                    v53 = v52:FindFirstChild(i);

                    if v53 then
                        v54 = v;

                        for _, child2 in pairs(v53:GetChildren()) do
                            if child2.Parent then
                                v55 = child2.PrimaryPart;

                                if v55 then
                                    if NumberUtil:IsWithin(v55.CFrame.Position, Position, 100) then
                                        v56 = child2;

                                        for i2, v2 in pairs(v54) do
                                            v57 = v55:FindFirstChild("Connection" .. i2);

                                            if v57 and (v57.Value and v57.Value.Parent) then
                                                v49 = v49 + 1;

                                                if v49 % 120 == 0 then
                                                    task.wait();
                                                end;
                                            else
                                                for _, v3 in pairs(v2) do
                                                    v58 = v3.Index;
                                                    v59 = v3.SnapTable;
                                                    v60 = u18[v56];

                                                    if not (v60 and v60[v58]) then
                                                        if not v60 then
                                                            v60 = {};
                                                            u18[v56] = v60;
                                                        end;

                                                        v60[v58] = v55.CFrame * v59.Offset;
                                                    end;
                                                end;
                                            end;
                                        end;
                                    end;

                                    v50 = v50 + 1;

                                    if v50 % 80 == 0 then
                                        task.wait();
                                    end;
                                else
                                    v49 = v49 + 1;

                                    if v49 % 120 == 0 then
                                        task.wait();
                                    end;
                                end;
                            end;
                        end;
                    else
                        v49 = v49 + 1;

                        if v49 % 120 == 0 then
                            task.wait();
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local function u64(p63, ...) -- Line: 287
    -- upvalues: u25 (ref), u4 (ref), u27 (ref), u62 (copy)
    if u25 then
        coroutine.close(u25);
        u25 = nil;
    end;

    if not (u4 and u4.Parent) then
        u27 = true;

        return;
    end;

    u25 = coroutine.create(u62, ...);
    coroutine.resume(u25);
end;

local function u65() -- Line: 306
    -- upvalues: u10 (ref), u12 (ref), u6 (ref), u4 (ref), u5 (ref)
    u10 = nil;
    u12 = false;
    script:SetAttribute("Equipped", 0);
    script:SetAttribute("PlacingBlueprint", false);
    script:SetAttribute("CanRotate", false);

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    if u4 and u4.Parent then
        u4:Destroy();
        u4 = nil;
    end;

    if u5 and u5.Parent then
        u5:Destroy();
        u5 = nil;
    end;
end;

local function u119(p66) -- Line: 327
    -- upvalues: InventoryController (copy), Items (copy), u12 (ref), u4 (ref), u65 (copy), u15 (ref), Benches (copy), u10 (ref), BenchInfo (copy), u17 (ref), CFrame_new_ret (ref), u14 (ref), u7 (ref), u8 (ref), u9 (ref), u13 (ref), u20 (ref), u21 (ref), Benches2 (copy), u5 (ref), u16 (ref), u27 (ref), u64 (copy), u6 (ref), RunService (copy), script_Parent (copy), Humanoid (copy), CameraController (copy), workspace_CurrentCamera (copy), RaycastUtil (copy), VFX (copy), u18 (ref), NumberUtil (copy), u22 (ref), u23 (ref), u11 (ref), ActiveBenchModule (copy), u19 (ref)
    local v67 = InventoryController.Fetch:Invoke();
    local v68;

    if v67 then
        local Toolbar = v67.Toolbar;

        if Toolbar then
            v68 = Toolbar[p66 or script:GetAttribute("Equipped")];

            if v68 == nil then
                v68 = false;
            elseif v68 == 0 then
                v68 = false;
            end;
        else
            v68 = nil;
        end;
    else
        v68 = nil;
    end;

    local v69;

    if v68 then
        v69 = Items[v68.ID];
    else
        v69 = v68;
    end;

    local Attribute = script:GetAttribute("Equipped");

    if Attribute > 0 and (u4 and (Attribute ~= p66 or v69 and u4.Name ~= v69.Name)) then
        u65();
    end;

    if not v68 then
        return;
    end;

    local v70 = v68.ID == 30;
    local u71 = v70 and u15 or v69.Name;
    local v72 = Benches:FindFirstChild(u71);
    u10 = BenchInfo[u71];

    if not (u10 and v72) then
        return;
    end;

    script:SetAttribute("Equipped", p66);
    script:SetAttribute("PlacingBlueprint", v70);
    local v73 = script;
    local v74;

    if typeof(u10.RotateOffset) == "CFrame" then
        v74 = u10.RotateOffset ~= CFrame.new();
    else
        v74 = false;
    end;

    v73:SetAttribute("CanRotate", v74);

    if u17 ~= u71 or not u12 then
        CFrame_new_ret = CFrame.new();
        u14 = 0;
        u7 = nil;
        u8 = nil;
        u9 = nil;
        u13 = 0;
        u12 = false;
        u20 = nil;
        u21 = {};
    end;

    local v75 = v70 and v72 and v72 or (v72:FindFirstChild(v68.Skin) or v72:FindFirstChild("Default"));
    local u76 = v75:Clone();
    u76.Name = u71;
    u76.PrimaryPart = u76:FindFirstChild("Main");

    for _, descendant in pairs(u76:GetDescendants()) do
        if descendant and descendant.Parent then
            if descendant:IsA("BasePart") and descendant.Parent:IsA("Model") then
                descendant.Anchored = true;
                descendant.CanCollide = false;
                descendant.CastShadow = false;
                descendant.Color = script:GetAttribute("PlaceUnavailableColor");
                descendant.Material = Enum.Material.ForceField;

                if descendant:IsA("MeshPart") then
                    descendant.TextureID = "";
                end;
            elseif descendant:IsA("Highlight") or (descendant.Name == "NonBaseCollisionParts" or (descendant:IsA("Decal") or (descendant:IsA("Texture") or (descendant:IsA("SurfaceAppearance") or descendant.Name == "DetailDeleter")))) then
                descendant:Destroy();
            elseif descendant:IsA("Folder") then
                for _, child in pairs(descendant:GetChildren()) do
                    if child:IsA("BasePart") then
                        child.Transparency = 1;
                        child.CanCollide = false;
                        child.Anchored = true;
                    end;
                end;
            end;
        end;
    end;

    u76.Parent = Benches2;
    u4 = u76;
    u5 = v75:Clone();
    u5.Name = u71;
    u5.PrimaryPart = u5:FindFirstChild("Main");

    for _, child in pairs(u5:GetChildren()) do
        local v77;

        if child == u5.PrimaryPart then
            v77 = child;

            if v77:IsA("BasePart") then
                v77.Transparency = 1;
                v77.CanCollide = false;
            end;
        else
            if child.Name == "CollisionParts" or (child.Name == "RayParts" or (child.Name == "BaseCollisionParts" or child.Name == "NonBaseCollisionParts")) then
                v77 = child;

                for _, child2 in pairs(child:GetChildren()) do
                    if child2:IsA("BasePart") then
                        child2.Transparency = 1;
                        child2.CanCollide = false;
                        child2.Anchored = true;
                    end;
                end;

                if v77:IsA("BasePart") then
                    v77.Transparency = 1;
                    v77.CanCollide = false;
                end;
            end;

            if child.Name == "Pole" then
                v77 = child;

                if v77:IsA("BasePart") then
                    v77.Transparency = 1;
                    v77.CanCollide = false;
                end;
            end;

            child:Destroy();
        end;
    end;

    u5.Parent = Benches2;
    local SnapPoints = u10.SnapPoints;
    local SnapOnly = u10.SnapOnly;
    local v78 = u16;
    u16 = u71;

    if u27 or (u17 ~= u16 or not v78) then
        u64();
    end;

    u17 = u71;
    local OffsetSnappedFacingAway = u10.OffsetSnappedFacingAway;
    local MaxPerBase = u10.MaxPerBase;

    if u6 then
        u6:Disconnect();
    end;

    u6 = RunService.Heartbeat:Connect(function(p79) -- Line: 418
        -- upvalues: u4 (ref), u76 (copy), u5 (ref), script_Parent (ref), Humanoid (ref), u65 (ref), u13 (ref), CameraController (ref), workspace_CurrentCamera (ref), u10 (ref), RaycastUtil (ref), VFX (ref), SnapPoints (copy), SnapOnly (copy), u18 (ref), NumberUtil (ref), u20 (ref), u21 (ref), u8 (ref), CFrame_new_ret (ref), u22 (ref), OffsetSnappedFacingAway (copy), u23 (ref), u71 (copy), u12 (ref), u7 (ref), u9 (ref), MaxPerBase (copy), u11 (ref), ActiveBenchModule (ref), u19 (ref), u64 (ref)
        if u4 ~= u76 or not (u5 and (script_Parent and (script_Parent.PrimaryPart and (Humanoid and Humanoid.Health > 0)))) then
            u65();

            return;
        end;

        local v80 = tick() - u13 >= 0.1;
        local v81 = script_Parent.PrimaryPart.Position + Vector3.new(0, 1.5, 0);
        local v82 = CameraController:GetAttribute("ViewmodelCFrame") or workspace_CurrentCamera.CFrame;
        local v83 = u10.PlaceExtraDistance or 0;
        local v84, v85, v86, v87 = RaycastUtil:Raycast(v81, v82.LookVector * (8 + v83), "Blacklist", { script_Parent, VFX }, false, RaycastUtil:FilterFunction("View"), true);
        local v88 = v86 or Vector3.new(0, 1, 0);
        local math_acos_ret = math.acos(v88.Y);
        local math_deg_ret = math.deg(math_acos_ret);
        local v89 = nil;

        for i = 14, 8, -1.5 do
            if SnapPoints and SnapOnly ~= nil then
                v89 = CFrame.new((v82 * CFrame.new(0, 0, -(i + v83))).Position);
            elseif u10.RotateOnSurface then
                local CFrame_new_ret2 = CFrame.new(v85, v85 + Vector3.new(0, 1, 0));
                v89 = (((function(p90, p91, p92) -- Line: 435
                    local v93 = p90:Dot(p91);
                    local v94 = p90:Cross(p91);

                    if v93 < -0.99999 then
                        return CFrame.fromAxisAngle(p92, 3.141592653589793);
                    end;

                    return CFrame.new(0, 0, 0, v94.x, v94.y, v94.z, 1 + v93);
                end)(CFrame_new_ret2.UpVector, v88, Vector3.new(1, 0, 0)) * CFrame_new_ret2).Rotation + CFrame_new_ret2.Position) * CFrame.Angles(1.5707963267948966, 0, 0);
            else
                v89 = CFrame.new(v85, v85 + Vector3.new(0, 1, 0));
            end;

            if not (v80 and SnapPoints) then
                break;
            end;

            local v95 = nil;
            local v96 = nil;
            local v97 = nil;

            for i2, v in pairs(u18) do
                local v98 = i2;

                for i3, v2 in pairs(v) do
                    local v99, v100 = NumberUtil:IsWithin(v89.Position, v2.Position, 4);

                    if v99 then
                        local math_sqrt_ret = math.sqrt(v100);

                        if not v95 or v95 >= math_sqrt_ret then
                            v96 = v98;
                            v95 = math_sqrt_ret;
                            v97 = {
                                Index = i3,
                                Offset = v2
                            };
                        end;
                    end;
                end;
            end;

            if v96 then
                u20 = v96;
                u21 = v97;
                break;
            end;

            u20 = nil;
            u21 = {};

            if i == 8 and SnapOnly ~= nil then
                v89 = CFrame.new((v82 * CFrame.new(0, 0, -(14 + v83))).Position);
            end;
        end;

        local v101;

        if u20 and (u20.Parent and u21.Offset) then
            v89 = u21.Offset;
            v101 = true;
        else
            v101 = false;
        end;

        local v102 = v89 * u10.Offset;
        local v103, v104, v105 = (u10.FaceCamera and not v101 and CFrame.new(v102.Position, (Vector3.new(v81.X, v102.Position.Y, v81.Z))) or CFrame.new()):ToEulerAnglesXYZ();
        local v106 = v102 * (CFrame.Angles(v103, v104, v105) * ((SnapPoints ~= nil and not v101 or SnapPoints == nil and not v84) and u10.UnsnappedOffset or CFrame.new()));
        local v107 = u8;
        local v108 = CFrame_new_ret:Lerp(CFrame.new(), v101 and u10.RotateOffset == CFrame.Angles(0, 1.5707963267948966, 0) and 0.5 or 0);
        local v109 = v106 * v108;

        if not v107 then
            u22 = false;
            local v110;

            if v101 and (OffsetSnappedFacingAway and (v81 - v109.Position).Unit:Dot(v109.LookVector) < 0) then
                v110 = v109 * OffsetSnappedFacingAway;
                u22 = true;
            else
                v110 = v109;
            end;

            v107 = v110 * (v101 and v108 and v108 or CFrame.new());
        end;

        local CFrame2 = u5.PrimaryPart.CFrame;
        local v111 = false;
        u5:SetPrimaryPartCFrame(v107);

        if v80 then
            u23 = true;
            local shared_Beds = shared.Beds;

            if shared_Beds and u10.Type == "Bed" then
                for _, v in pairs(shared_Beds) do
                    local Vector3_new_ret = Vector3.new(v.Position.X, v107.Position.Y, v.Position.Z);

                    if NumberUtil:IsWithin(v107.Position, Vector3_new_ret, 150) then
                        u23 = false;
                        break;
                    end;
                end;
            end;

            local v112 = (v101 and u10.SnappedPlacingFunc or u10.PlacingFunc)(u71, v84, math_deg_ret, v84, v87);
            local v113;

            if u71 == "Foundation" or u71 == "Triangle Foundation" then
                v113 = not v101;
            else
                v113 = false;
            end;

            u13 = tick();
            local v114 = u10.CollisionFunc(u5, v113, nil, u10.Type, u10.LenientCollision, v101);
            u12 = v112 and v114;

            if u12 then
                u7 = v109;
                u9 = v84;
            end;

            if u12 == false and (u7 and (u9 and u9.Parent)) then
                if not u8 then
                    u13 = 0;
                end;

                u8 = u7;

                if not NumberUtil:IsWithin(u8.Position, v109.Position, 0.4) then
                    u7 = nil;
                    u9 = nil;
                    u8 = nil;
                end;
            end;

            if u8 then
                v111 = true;
                u5:SetPrimaryPartCFrame(v109);

                if v112 then
                    v112 = u10.CollisionFunc(u5, v113, nil, u10.Type, u10.LenientCollision, v101);
                end;

                if v112 then
                    u7 = v109;
                    u9 = v84;
                    u8 = nil;
                    u12 = true;
                elseif v114 then
                    u12 = true;
                    v109 = v107;
                else
                    v109 = v107;
                end;
            else
                v109 = v107;
            end;

            if SnapOnly and u12 then
                u12 = v101;
            end;

            local v115 = u12 and (MaxPerBase and (u9 and not v101)) and u9:FindFirstAncestor("Base");

            if v115 then
                local v116 = v115:FindFirstChild(u71);
                u12 = v116 == nil and true or #v116:GetChildren() < MaxPerBase;
            end;

            u11 = nil;

            if u12 then
                if u71 == "Base Cabinet" then
                    local v117 = { VFX };
                    u12 = RaycastUtil:Raycast(Vector3.new(v109.Position.X, 225.6, v109.Position.Z), Vector3.new(0, -0.2, 0), "Blacklist", v117, false, RaycastUtil:FilterFunction("BuildingPrivCheck")) == nil;
                else
                    local IgnoreBuildBlock = u10.IgnoreBuildBlock;
                    local BaseCabinetUnder, v118 = RaycastUtil:GetBaseCabinetUnder(v109.Position, IgnoreBuildBlock);

                    if BaseCabinetUnder and (BaseCabinetUnder:GetAttribute("Monument") and (IgnoreBuildBlock ~= "All" and (IgnoreBuildBlock ~= "Monument" or v118))) then
                        u11 = false;
                    elseif IgnoreBuildBlock and IgnoreBuildBlock ~= "Monument" then
                        u11 = nil;
                    else
                        local ClientInfo = ActiveBenchModule.GetClientInfo(BaseCabinetUnder);

                        if ClientInfo then
                            u11 = ClientInfo.Access;
                        end;
                    end;

                    u12 = u11 ~= false;
                end;
            end;
        else
            v109 = v107;
        end;

        u4:SetPrimaryPartCFrame(v109);

        for _, descendant in pairs(u4:GetDescendants()) do
            if descendant:IsA("BasePart") and descendant.Parent:IsA("Model") then
                descendant.Color = script:GetAttribute(u12 and ((u11 == false or not u23) and "PlaceBlockedColor" or "PlaceAvailableColor") or "PlaceUnavailableColor");
            end;
        end;

        if not v111 then
            u5:SetPrimaryPartCFrame(CFrame2);
        end;

        if u19 and not NumberUtil:IsWithin(v81, u19, 75) then
            u64();
        end;
    end);
end;

local function _() -- Line: 604
    -- upvalues: u10 (ref), CFrame_new_ret (ref), u14 (ref)
    if not u10 then
        return;
    end;

    CFrame_new_ret = CFrame_new_ret * u10.RotateOffset;
    u14 = u14 + 1;
end;

local function u141() -- Line: 612
    -- upvalues: InventoryController (copy), EquipController (copy), BasePartInfo (copy), u15 (ref), RecipeModule (copy), Values (copy), Items (copy), NumberUtil (copy), WheelController (copy), u119 (copy), InteractController (copy), BenchInfo (copy), RaycastUtil (copy), ActiveBenchModule (copy), u3 (copy), u2 (copy), u10 (ref), CFrame_new_ret (ref), u14 (ref)
    if InventoryController:GetAttribute("Open") then
        return;
    end;

    local Attribute = EquipController:GetAttribute("Equipped");
    local v120 = InventoryController.Fetch:Invoke();
    local v121;

    if v120 then
        local Toolbar = v120.Toolbar;

        if Toolbar then
            v121 = Toolbar[Attribute or script:GetAttribute("Equipped")];

            if v121 == nil then
                v121 = false;
            elseif v121 == 0 then
                v121 = false;
            end;
        else
            v121 = nil;
        end;
    else
        v121 = nil;
    end;

    if v121 then
        local v122 = InventoryController.Fetch:Invoke();
        local v123 = {};

        for _, v in pairs({ "Inventory", "Toolbar" }) do
            for _, v2 in pairs(v122[v]) do
                if v2 ~= 0 then
                    if not v123[v2.ID] then
                        v123[v2.ID] = 0;
                    end;

                    local ID = v2.ID;
                    v123[ID] = v123[ID] + v2.Amount;
                end;
            end;
        end;

        if v121.ID == 30 then
            local v124 = BasePartInfo:Fetch();

            for _, v in pairs(v124) do
                local v125 = v.Name:gsub(" ", "_"):gsub("-", "_");
                v.Image = script:GetAttribute("Build" .. v125);
                v.SelectFirst = u15 == v.Name;
                local v126 = RecipeModule:FetchRecipe("Twig", v.Name);

                if v126 then
                    if Values.UseBuildCosts.Value then
                        local v127 = v126.Costs[1];

                        if v127 then
                            local v128 = Items[v127.ID];
                            v.Selectable = (v123[v127.ID] or 0) >= v127.Amount;
                            v.Cost = NumberUtil:FormatNumber(v127.Amount) .. " " .. v128.Name .. " (" .. NumberUtil:FormatNumber(v123[v127.ID] or 0) .. " Left)";
                        end;
                    else
                        v.Selectable = true;
                    end;
                end;
            end;

            local v129 = WheelController.Open:Invoke(v124, "Blueprint", false);

            if not v129 then
                return;
            end;

            local v130 = v124[v129];

            if not v130 then
                return;
            end;

            u15 = v130.Name;
            u119(script:GetAttribute("Equipped"));

            return;
        end;

        if v121.ID == 31 then
            local v131 = InteractController.GetSelected:Invoke();

            if not (v131 and v131.Parent) then
                return;
            end;

            local Name = v131.Name;

            if Name == "Wall Block" then
                return;
            end;

            local v132 = BenchInfo[Name];
            local PrimaryPart = v131.PrimaryPart;

            if not (v132 and (PrimaryPart and v132.Type == "BasePart")) then
                return;
            end;

            local RotateOffset = v132.RotateOffset;
            local Value = Values.ServerTick.Value;
            local Attribute2 = v131:GetAttribute("DamageType");

            if Value - (v131:GetAttribute("LastDamaged") or 0) < 60 then
                return;
            end;

            local BaseCabinetUnder = RaycastUtil:GetBaseCabinetUnder(PrimaryPart.Position);

            if BaseCabinetUnder and BaseCabinetUnder:GetAttribute("Monument") then
                return;
            end;

            local ClientInfo = ActiveBenchModule.GetClientInfo(BaseCabinetUnder);

            if ClientInfo and ClientInfo.Access == false then
                return;
            end;

            local v133 = {
                {
                    Name = "Upgrade to Wood",
                    Description = "Cheap way to fortify your base. Vulnerable to fire attacks.",
                    Image = script:GetAttribute("HammerWoodIcon")
                },
                {
                    Name = "Upgrade to Stone",
                    Description = "Hard and durable. Stronger than Wood.",
                    Image = script:GetAttribute("HammerStoneIcon")
                },
                {
                    Name = "Upgrade to Metal",
                    Description = "Resistant to explosive attacks. Stronger than Stone.",
                    Image = script:GetAttribute("HammerMetalIcon")
                },
                {
                    Name = "Upgrade to Steel",
                    Description = "Expensive but resilient material. Stronger than Metal.",
                    Image = script:GetAttribute("HammerSteelIcon")
                },
                {
                    Name = "Rotate",
                    Description = "Flip any misplaced parts.",
                    Image = script:GetAttribute("HammerRotateIcon")
                },
                {
                    Name = "Demolish",
                    Description = "Get rid of selected base part.",
                    Image = script:GetAttribute("HammerDemolishIcon")
                }
            };

            for _, v in pairs(v133) do
                local Name2 = v.Name;

                if Name2:sub(1, 7) == "Upgrade" then
                    local v134 = Name2:sub(12);
                    local v135 = RecipeModule:FetchRecipe(v134, Name);
                    local v136;

                    if v135 and Values.UseBuildCosts.Value then
                        local v137 = v135.Costs[1];
                        local v138 = Items[v137.ID];
                        v.Cost = NumberUtil:FormatNumber(v137.Amount) .. " " .. v138.Name .. " (" .. NumberUtil:FormatNumber(v123[v137.ID] or 0) .. " Left)";
                        v136 = (v123[v137.ID] or 0) >= v137.Amount;
                    else
                        v136 = true;
                    end;

                    if table.find(u3[Attribute2 or "Twig"], v134) == nil then
                        v136 = false;
                    end;

                    v.Selectable = v136;
                else
                    local v139;

                    if Value - (v131:GetAttribute(Name2 == "Demolish" and "Placed" or "Upgraded") or Value - 0.01) < Values.DemolishTimer.Value then
                        v139 = Values.SimpleDemolish.Value or Name2 == "Demolish" and ClientInfo ~= nil and ClientInfo.Access;

                        if not v139 then
                            if Name2 == "Rotate" then
                                if RotateOffset then
                                    v139 = RotateOffset ~= CFrame.new();
                                else
                                    v139 = RotateOffset;
                                end;
                            else
                                v139 = false;
                            end;
                        end;
                    else
                        v139 = false;
                    end;

                    v.Selectable = v139;
                end;

                v.SelectFirst = false;
            end;

            local v140 = WheelController.Open:Invoke(v133, "Hammer", true);

            if not v140 then
                return;
            end;

            if not v133[v140] then
                return;
            end;

            u2("Fire", "\239\191\189\107\239\191\189\052\111\239\191\189\239\191\189\239\191\189\239\191\189\195\135\239\191\189\239\191\189\048\239\191\189\195\149\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189", "\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\046\239\191\189\115\239\191\189\239\191\189\239\191\189\095\239\191\189\194\179\108\195\153\239\191\189\081\056", v131 or "none", v140);
        end;
    else
        if not u10 then
            return;
        end;

        CFrame_new_ret = CFrame_new_ret * u10.RotateOffset;
        u14 = u14 + 1;
    end;
end;

local function _() -- Line: 734
    -- upvalues: WheelController (copy)
    WheelController.Close:Invoke("Blueprint");
    WheelController.Close:Invoke("Hammer");
end;

local function u143(u142) -- Line: 739
    -- upvalues: LocalPlayer (copy), u64 (copy)
    if not (u142 and (u142.Parent and u142:IsA("Model"))) then
        return;
    end;

    u142:GetPropertyChangedSignal("PrimaryPart"):Connect(function() -- Line: 742
        -- upvalues: u142 (copy), LocalPlayer (ref), u64 (ref)
        if not u142.PrimaryPart then
            return;
        end;

        local Attribute = LocalPlayer:GetAttribute("ArenaIndex");
        local Attribute2 = u142:GetAttribute("ArenaIndex");

        if Attribute ~= nil and (Attribute2 ~= nil and Attribute ~= Attribute2) then
            return;
        end;

        u64();
    end);

    if not u142.PrimaryPart then
        return;
    end;

    local Attribute = LocalPlayer:GetAttribute("ArenaIndex");
    local Attribute2 = u142:GetAttribute("ArenaIndex");

    if Attribute ~= nil and (Attribute2 ~= nil and Attribute ~= Attribute2) then
        return;
    end;

    u64();
end;

local function u145(p144) -- Line: 765
    -- upvalues: u26 (copy), u143 (copy)
    if not (p144:IsA("Folder") and u26[p144.Name]) then
        return;
    end;

    p144.ChildAdded:Connect(u143);

    for _, child in pairs(p144:GetChildren()) do
        u143(child);
    end;
end;

local function v147(p146) -- Line: 774
    -- upvalues: u145 (copy)
    if not p146:IsA("Folder") or p146.Name ~= "Base" then
        return;
    end;

    p146.ChildAdded:Connect(u145);

    for _, child in pairs(p146:GetChildren()) do
        u145(child);
    end;
end;

UserInputService.InputBegan:Connect(function(p148, p149) -- Line: 785
    -- upvalues: SettingsModule (copy), script_Parent (copy), UserInputService (copy), u10 (ref), PreferredInputController (copy), u35 (copy), CFrame_new_ret (ref), u14 (ref), InteractController (copy), u141 (copy), EquipController (copy), InventoryController (copy)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    local UserInputType = p148.UserInputType;

    if UserInputType == Enum.UserInputType.Gamepad1 then
        local TeamNavigationController = script_Parent:FindFirstChild("TeamNavigationController");

        if TeamNavigationController and TeamNavigationController:GetAttribute("MapOpen") then
            return;
        end;
    end;

    local FocusedTextBox = UserInputService:GetFocusedTextBox();

    if u10 then
        local v150 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

        if v150 and UserInputType == Enum.UserInputType.Gamepad1 then
            local Name = p148.KeyCode.Name;

            if Name == SettingsModule.GetSetting("Gamepad", "Place Building") then
                u35();

                return;
            end;

            if Name == SettingsModule.GetSetting("Gamepad", "Rotate Building") then
                if not u10 then
                    return;
                end;

                CFrame_new_ret = CFrame_new_ret * u10.RotateOffset;
                u14 = u14 + 1;

                return;
            end;

            if Name == SettingsModule.GetSetting("Gamepad", "Change Building") then
                if not InteractController.GetSelected:Invoke() then
                    u141();
                end;

                return;
            end;
        elseif UserInputType == Enum.UserInputType.Keyboard and not FocusedTextBox then
            local Name = p148.KeyCode.Name;

            if Name == SettingsModule.GetSetting("Controls", "Rotate Building") then
                if not u10 then
                    return;
                end;

                CFrame_new_ret = CFrame_new_ret * u10.RotateOffset;
                u14 = u14 + 1;

                return;
            end;

            if Name == SettingsModule.GetSetting("Controls", "Change Building") then
                if not InteractController.GetSelected:Invoke() then
                    u141();
                end;

                return;
            end;
        end;
    end;

    local v151 = PreferredInputController and PreferredInputController:GetAttribute("PreferredInput") == "Gamepad";

    if v151 and (UserInputType == Enum.UserInputType.Gamepad1 and p148.KeyCode.Name == "ButtonL2") then
        local Attribute = EquipController:GetAttribute("Equipped");
        local v152 = InventoryController.Fetch:Invoke();
        local v153;

        if v152 then
            local Toolbar = v152.Toolbar;

            if Toolbar then
                v153 = Toolbar[Attribute or script:GetAttribute("Equipped")];

                if v153 == nil then
                    v153 = false;
                elseif v153 == 0 then
                    v153 = false;
                end;
            else
                v153 = nil;
            end;
        else
            v153 = nil;
        end;

        if v153 and v153.ID == 31 then
            u141();

            return;
        end;
    end;

    if FocusedTextBox or p149 then
        return;
    end;

    if UserInputType == Enum.UserInputType.MouseButton1 then
        u35();

        return;
    end;

    if UserInputType == Enum.UserInputType.MouseButton2 and SettingsModule.GetSetting("Controls", "Change Building") == "MB2" then
        u141();

        return;
    end;

    if UserInputType == Enum.UserInputType.Keyboard and p148.KeyCode.Name == SettingsModule.GetSetting("Controls", "Change Building") then
        u141();
    end;
end);
UserInputService.InputEnded:Connect(function(p154, p155) -- Line: 841
    -- upvalues: SettingsModule (copy), WheelController (copy)
    local UserInputType = p154.UserInputType;

    if UserInputType ~= Enum.UserInputType.MouseButton2 or SettingsModule.GetSetting("Controls", "Change Building") ~= "MB2" then
        if UserInputType == Enum.UserInputType.Keyboard then
            if p154.KeyCode.Name == SettingsModule.GetSetting("Controls", "Change Building") then
                WheelController.Close:Invoke("Blueprint");
                WheelController.Close:Invoke("Hammer");

                return;
            end;
        elseif UserInputType == Enum.UserInputType.Gamepad1 and p154.KeyCode.Name == SettingsModule.GetSetting("Gamepad", "Change Building") then
            WheelController.Close:Invoke("Blueprint");
            WheelController.Close:Invoke("Hammer");
        end;

        return;
    end;

    WheelController.Close:Invoke("Blueprint");
    WheelController.Close:Invoke("Hammer");
end);
script:WaitForChild("MobileUse").Event:Connect(function(p156) -- Line: 859
    -- upvalues: SettingsModule (copy), u35 (copy)
    if not p156 then
        return;
    end;

    if SettingsModule.MainMenuOpen() then
        return;
    end;

    u35();
end);
script:WaitForChild("MobileChange").Event:Connect(function(p157) -- Line: 867
    -- upvalues: SettingsModule (copy), InteractController (copy), u141 (copy), WheelController (copy)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if p157 then
        if not InteractController.GetSelected:Invoke() then
            u141();
        end;
    elseif not WheelController:GetAttribute("Open") then
        WheelController.Close:Invoke("Blueprint");
        WheelController.Close:Invoke("Hammer");
    end;
end);
script:WaitForChild("MobileUpgrade").Event:Connect(function(p158) -- Line: 878
    -- upvalues: SettingsModule (copy), u141 (copy), WheelController (copy)
    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if p158 then
        u141();

        return;
    end;

    if not WheelController:GetAttribute("Open") then
        WheelController.Close:Invoke("Blueprint");
        WheelController.Close:Invoke("Hammer");
    end;
end);
script:WaitForChild("MobileRotate").Event:Connect(function(p159) -- Line: 888
    -- upvalues: SettingsModule (copy), u10 (ref), CFrame_new_ret (ref), u14 (ref)
    if not p159 then
        return;
    end;

    if SettingsModule.MainMenuOpen() then
        return;
    end;

    if not u10 then
        return;
    end;

    CFrame_new_ret = CFrame_new_ret * u10.RotateOffset;
    u14 = u14 + 1;
end);
Bases.ChildAdded:Connect(v147);

for _, child in pairs(Bases:GetChildren()) do
    v147(child);
end;

EquipBench.Event:Connect(function(...) -- Line: 900
    -- upvalues: u119 (copy), WheelController (copy), u15 (ref), u16 (ref), u65 (copy)
    local v160 = ({ ... })[1];

    if v160 and v160 > 0 then
        u119(...);

        return;
    end;

    WheelController.Close:Invoke("Blueprint");
    WheelController.Close:Invoke("Hammer");

    if u15 ~= u16 then
        u16 = nil;
    end;

    u65();
end);
Build.OnClientEvent:Connect(function(p161, ...) -- Line: 918
    -- upvalues: u64 (copy)
    local v162 = { ... };

    if p161 == "UpdateSnaps" then
        local _ = v162[1];
        local _ = v162[2];
        u64(true);
    end;
end);

for _, v in pairs(BenchInfo) do
    local SnapPoints = v.SnapPoints;

    if SnapPoints then
        for _, v2 in pairs(SnapPoints) do
            local BenchNames = v2.BenchNames;

            if BenchNames then
                for _, v3 in pairs(BenchNames) do
                    u26[v3] = true;
                end;
            end;
        end;
    end;
end;

Benches2:ClearAllChildren();
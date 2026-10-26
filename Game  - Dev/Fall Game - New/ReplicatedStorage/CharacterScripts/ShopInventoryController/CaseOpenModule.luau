-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / CaseOpenModule @Type ModuleScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UIConstants = require(script.Parent:WaitForChild("UIConstants"));
local FRAME_SHOP = UIConstants.FRAME_SHOP;
local FRAME_NAVBAR = UIConstants.FRAME_NAVBAR;
local CaseViewport = UIConstants.FRAME_MAIN:WaitForChild("CaseViewport");
local WorldModel = CaseViewport:WaitForChild("WorldModel");
local CaseRig = ReplicatedStorage:WaitForChild("CaseRig");
local CaseModels = ReplicatedStorage:WaitForChild("CaseModels");
local SHOP_CASESCROLL = UIConstants.SHOP_CASESCROLL;
local OpenSpinner = script.Parent:WaitForChild("NavBarUIModule"):WaitForChild("InventoryUIModule"):WaitForChild("OpenSpinner");
local v1 = WorldModel:FindFirstChild("CaseRig") or CaseRig:Clone();
v1.Parent = WorldModel;
local case = v1:WaitForChild("case");
local Model = case:WaitForChild("Model");
local AnimationController = case:WaitForChild("AnimationController");
local CameraPart = v1:WaitForChild("CameraReference"):WaitForChild("CameraPart");
local Sounds = v1:WaitForChild("Sounds");
local u2 = CaseViewport:FindFirstChildOfClass("Camera") or Instance.new("Camera");
u2.FieldOfView = 70;
u2.CFrame = CameraPart.CFrame;
u2.Parent = CaseViewport;
CaseViewport.CurrentCamera = u2;

local function PlayCaseSound(p3: string) -- Line: 45
    -- upvalues: Sounds (copy)
    if not p3 or p3 == "" then
        return;
    end;

    local v4 = {};

    for _, child in ipairs(Sounds:GetChildren()) do
        if child:IsA("Sound") and child.Name:sub(1, #p3) == p3 then
            table.insert(v4, child);
        end;
    end;

    if #v4 == 0 then
        return;
    end;

    v4[math.random(1, #v4)]:Play();
end;

local function getCaseModelName(p5: string) -- Line: 59
    -- upvalues: SHOP_CASESCROLL (copy)
    for _, child in ipairs(SHOP_CASESCROLL:GetChildren()) do
        if child:IsA("ImageButton") and child:GetAttribute("CaseName") == p5 then
            local Title = child:FindFirstChild("Title");

            if Title then
                Title = Title:FindFirstChild("ItemName");
            end;

            if Title then
                Title = Title.Text;
            end;

            if type(Title) == "string" and Title ~= "" then
                return Title:gsub("%s+Case$", "");
            end;

            return nil;
        end;
    end;

    return nil;
end;

local function applyCaseTextures(p6: string) -- Line: 73
    -- upvalues: getCaseModelName (copy), CaseModels (copy), Model (copy)
    local v7 = getCaseModelName(p6);

    if not v7 then
        warn("[CaseOpenModule] Cannot resolve model name for crate \'" .. tostring(p6) .. "\' - keeping current case textures.");

        return;
    end;

    local v8 = CaseModels:FindFirstChild(v7);

    if v8 then
        for _, child in ipairs(Model:GetChildren()) do
            if child:IsA("MeshPart") then
                local v9 = v8:FindFirstChild(child.Name);

                if v9 and v9:IsA("MeshPart") then
                    child.TextureID = v9.TextureID;
                end;
            end;
        end;

        return;
    end;

    warn("[CaseOpenModule] No CaseModels." .. v7 .. " for crate \'" .. tostring(p6) .. "\' - keeping current case textures.");
end;

local u10 = AnimationController:FindFirstChildOfClass("Animator") or Instance.new("Animator");
u10.Parent = AnimationController;
local Animations = case:WaitForChild("Animations");

local function loadAnim(p11: string) -- Line: 99
    -- upvalues: Animations (copy), u10 (copy)
    local v12 = Animations:WaitForChild(p11);

    if v12.AnimationId == "" then
        warn("[CaseOpenModule] " .. p11 .. ".AnimationId is empty - case animation will not play.");
    end;

    return u10:LoadAnimation(v12);
end;

local CaseDrop = Animations:WaitForChild("CaseDrop");

if CaseDrop.AnimationId == "" then
    warn("[CaseOpenModule] CaseDrop.AnimationId is empty - case animation will not play.");
end;

local u13 = u10:LoadAnimation(CaseDrop);
local CaseOpen = Animations:WaitForChild("CaseOpen");

if CaseOpen.AnimationId == "" then
    warn("[CaseOpenModule] CaseOpen.AnimationId is empty - case animation will not play.");
end;

local u14 = u10:LoadAnimation(CaseOpen);
local CaseIdle = Animations:WaitForChild("CaseIdle");

if CaseIdle.AnimationId == "" then
    warn("[CaseOpenModule] CaseIdle.AnimationId is empty - case animation will not play.");
end;

local u15 = u10:LoadAnimation(CaseIdle);
u13.Looped = false;
u14.Looped = false;
u15.Looped = true;
u13.KeyframeReached:Connect(PlayCaseSound);
u14.KeyframeReached:Connect(PlayCaseSound);
u15.KeyframeReached:Connect(PlayCaseSound);
local u16 = {};

for _, descendant in ipairs(Model:GetDescendants()) do
    if descendant:IsA("BasePart") then
        table.insert(u16, descendant);
    end;
end;

local function setCaseVisible(p17: boolean) -- Line: 125
    -- upvalues: u16 (copy)
    local v18 = p17 and 0 or 1;

    for _, v in ipairs(u16) do
        v.Transparency = v18;
    end;
end;

for _, v in ipairs(u16) do
    v.Transparency = 1;
end;

local function playAndWait(p19: userdata, p20: number?, p21: number?) -- Line: 134
    if p19 and (p19.Animation and p19.Animation.AnimationId ~= "") then
        p19:Play(p21, nil, p20 or 1);
        p19.Stopped:Wait();
    end;
end;

local u22 = false;

local function OpenCase(u23: string, u24: string, u25: number, u26: boolean) -- Line: 146
    -- upvalues: u22 (ref), FRAME_SHOP (copy), FRAME_NAVBAR (copy), u16 (copy), applyCaseTextures (copy), u15 (copy), u14 (copy), u13 (copy), u2 (copy), CameraPart (copy), CaseViewport (copy), setCaseVisible (copy), OpenSpinner (copy)
    if u22 then
        warn("[CaseOpenModule] OpenCase already running; dropping duplicate request");

        return;
    end;

    u22 = true;
    local u27 = false;
    local u28 = false;
    local success, result = pcall(function() -- Line: 156
        -- upvalues: u27 (ref), FRAME_SHOP (ref), u28 (ref), FRAME_NAVBAR (ref), u16 (ref), applyCaseTextures (ref), u24 (copy), u15 (ref), u14 (ref), u13 (ref), u2 (ref), CameraPart (ref), CaseViewport (ref), setCaseVisible (ref), OpenSpinner (ref), u23 (copy), u25 (copy), u26 (copy)
        u27 = FRAME_SHOP.Visible;
        FRAME_SHOP.Visible = false;
        u28 = FRAME_NAVBAR.Visible;
        FRAME_NAVBAR.Visible = false;

        for _, v in ipairs(u16) do
            v.Transparency = 1;
        end;

        applyCaseTextures(u24);
        u15:Stop(0);
        u14:Stop(0);
        u13:Stop(0);
        u2.CFrame = CameraPart.CFrame;
        CaseViewport.Visible = true;
        task.defer(setCaseVisible, true);
        local v29 = u13;

        if v29 and (v29.Animation and v29.Animation.AnimationId ~= "") then
            v29:Play(0, nil, 1.2);
            v29.Stopped:Wait();
        end;

        u14:Play(nil, nil, 1.2);
        u14.Stopped:Connect(function() -- Line: 178
            -- upvalues: u15 (ref)
            if u15.Animation and u15.Animation.AnimationId ~= "" then
                u15:Play();
            end;
        end);
        task.wait(1.5);
        OpenSpinner:Invoke(u23, u24, u25, u26);
        u15:Stop();

        for _, v in ipairs(u16) do
            v.Transparency = 1;
        end;

        CaseViewport.Visible = false;
        FRAME_SHOP.Visible = u27;
        FRAME_NAVBAR.Visible = u28;
    end);
    u22 = false;

    if not success then
        warn("[CaseOpenModule] OpenCase failed: " .. tostring(result));
        u15:Stop();

        for _, v in ipairs(u16) do
            v.Transparency = 1;
        end;

        CaseViewport.Visible = false;
        FRAME_SHOP.Visible = u27;
        FRAME_NAVBAR.Visible = u28;
    end;
end;

local OpenCase2 = script:WaitForChild("OpenCase");
OpenCase2.Event:Connect(OpenCase);
OpenCase2:SetAttribute("Ready", true);

return true;
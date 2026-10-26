-- [PATH] ReplicatedStorage / CharacterScripts / ElectricityController @Type LocalScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local TweenService = game:GetService("TweenService");
local SoundService = game:GetService("SoundService");
local LocalPlayer = Players.LocalPlayer;
local Character = LocalPlayer.Character;
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart");
local RootRigAttachment = HumanoidRootPart:WaitForChild("RootRigAttachment");
local Bases = workspace:WaitForChild("Bases");
local Value = ReplicatedStorage:WaitForChild("Values"):WaitForChild("ElectricBenchClientUpdateSeconds").Value;
local ClientSignals = ReplicatedStorage:WaitForChild("ClientSignals");
local UpdateBenchConnections = ClientSignals:WaitForChild("UpdateBenchConnections");
local UpdateBenchPower = ClientSignals:WaitForChild("UpdateBenchPower");
local TemplateWire = script:WaitForChild("TemplateWire");
local VFX = workspace:WaitForChild("VFX");
local Wires = VFX:WaitForChild("Wires");
local WireCutters = SoundService:WaitForChild("WireCutters");
local u1 = {
    Green = ColorSequence.new(Color3.fromRGB(63, 194, 46)),
    Red = ColorSequence.new(Color3.fromRGB(194, 40, 50)),
    Black = ColorSequence.new(Color3.fromRGB(40, 40, 40))
};
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Items = require(Modules:WaitForChild("Items"));
local BenchInfo = require(Modules:WaitForChild("BenchInfo"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local RaycastUtil = require(Modules:WaitForChild("RaycastUtil"));
local ActiveBenchModule = require(Modules:WaitForChild("ActiveBenchModule"));
local ViewmodelController = Character:WaitForChild("ViewmodelController");
local u2 = require(Modules:WaitForChild("AssetContainer"))();
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local WireCutterInfo = PlayerGui:WaitForChild("Main"):WaitForChild("WireCutterInfo");
local ConnectionsBillboardGui = PlayerGui:WaitForChild("ConnectionsBillboardGui");
local ButtonFrame = ConnectionsBillboardGui:WaitForChild("ButtonFrame");
local OpenBench = script:WaitForChild("OpenBench");
local EquipWires = script:WaitForChild("EquipWires");
local PlayVMAnimation = ViewmodelController:WaitForChild("PlayVMAnimation");
local u3 = os.clock() - Value;
shared.CachedElectricalBenchNames = {};
shared.CachedConnections = {};
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = {};
local u12 = nil;

for i, v in BenchInfo do
    local v13 = v.TypeArguments and v.TypeArguments();

    if v.Type == "Electricity" or (v.ElectricityType or v13 and v13.PowerIn ~= nil) then
        shared.CachedElectricalBenchNames[i] = true;
    end;
end;

local function u18(p14: any, p15: table) -- Line: 131
    -- upvalues: TemplateWire (copy), Wires (copy)
    local v16 = {};

    for i, v in p15 do
        if v == 0 then
            v16[i] = 0;
        elseif p14.Main and v.Main then
            if not p14.Main:FindFirstChild("WireAttachment") then
                local Attachment = Instance.new("Attachment");
                Attachment.Name = "WireAttachment";
                Attachment.Parent = p14.Main;
            end;

            if not v.Main:FindFirstChild("WireAttachment") then
                local Attachment = Instance.new("Attachment");
                Attachment.Name = "WireAttachment";
                Attachment.Parent = v.Main;
            end;

            local v17 = TemplateWire:Clone();
            v16[i] = v17;
            v17.Attachment0 = p14.Main.WireAttachment;
            v17.Attachment1 = v.Main.WireAttachment;
            v17.Enabled = script:GetAttribute("WiresEquipped");
            local WireDetail = v17:FindFirstChild("WireDetail");
            WireDetail.Attachment0 = p14.Main.WireAttachment;
            WireDetail.Attachment1 = v.Main.WireAttachment;
            WireDetail.Enabled = true;
            v17.Parent = Wires;
        else
            v16[i] = 0;
        end;
    end;

    return v16;
end;

local function u20(p19: boolean) -- Line: 175
    -- upvalues: Wires (copy)
    for _, child in Wires:GetChildren() do
        child.Enabled = p19;

        if child:FindFirstChild("WireDetail") then
            child.WireDetail.Enabled = p19;
        end;
    end;
end;

local function _() -- Line: 184
    -- upvalues: u5 (ref), u6 (ref)
    u5 = nil;
    u6 = nil;
    script:SetAttribute("Placing", false);
end;

local function u25(p21: userdata) -- Line: 190
    -- upvalues: Items (copy), WireCutterInfo (copy)
    local v22;

    if p21 then
        v22 = p21:GetAttribute("ID");
    else
        v22 = p21;
    end;

    local v23;

    if p21 then
        v23 = p21:GetAttribute("Skin");
    else
        v23 = p21;
    end;

    if v22 then
        v22 = Items[v22];
    end;

    if v22 then
        v22 = v22.Image[v23 or "Default"];
    end;

    local v24 = v22 ~= nil;
    WireCutterInfo.TopLabel.Text = v24 and "CREATING NEW CONNECTION FROM" or "[MOUSE1] ON ELECTRICITY BENCH TO SHOW CONNECTIONS";
    WireCutterInfo.ImageLabel.Image = v22 or "";
    WireCutterInfo.ImageLabel.Visible = v24;
    WireCutterInfo.ItemLabel.Text = p21 and p21.Name or "";
    WireCutterInfo.ItemLabel.Visible = v24;
    WireCutterInfo.BottomLabel.Visible = v24;
    WireCutterInfo.Visible = true;
end;

local function u26() -- Line: 205
    -- upvalues: Character (copy), HumanoidRootPart (copy), u11 (ref), Bases (copy), NumberUtil (copy)
    if not (Character and HumanoidRootPart) then
        return;
    end;

    u11 = {};

    for _, child in pairs(Bases:GetChildren()) do
        for _, child2 in child:GetChildren() do
            if shared.CachedElectricalBenchNames[child2.Name] then
                for _, child3 in pairs(child2:GetChildren()) do
                    if child3.Main and (child3.Main.Position and NumberUtil:IsWithin(child3.Main.Position, HumanoidRootPart.Position, 70)) then
                        table.insert(u11, child3);
                    end;
                end;
            end;
        end;
    end;
end;

local function u29(p27: string) -- Line: 224
    -- upvalues: WireCutterInfo (copy), TweenService (copy)
    local TweenInfo_new_ret = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
    local v28 = WireCutterInfo.Message:Clone();
    v28.Parent = WireCutterInfo;
    v28.Text = p27;
    TweenService:Create(v28, TweenInfo_new_ret, {
        TextTransparency = 0.3
    }):Play();
    task.wait(4);
    v28:Destroy();
end;

local function _() -- Line: 238
    -- upvalues: u12 (ref), u3 (ref), Value (copy), u26 (copy), u11 (ref), u2 (copy), u18 (copy), Wires (copy)
    if u12 then
        task.cancel(u12);
    end;

    u12 = task.defer(function() -- Line: 240
        -- upvalues: u3 (ref), Value (ref), u26 (ref), u11 (ref), u2 (ref), u18 (ref), Wires (ref)
        while true do
            while true do
                repeat
                    task.wait(0.25);
                until os.clock() - u3 > Value;

                u3 = os.clock();
                u26();

                if #u11 ~= 0 then
                    break;
                end;

                shared.CachedConnections = {};
            end;

            local v30 = {};
            local v31 = {};

            for _, v in u2("Fire", "\239\191\189\239\191\189\239\191\189\195\166\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\067\239\191\189\239\191\189\239\191\189\056\239\191\189\239\191\189\239\191\189\239\191\189\062", "\239\191\189\110\087\239\191\189\063\239\191\189\097\053\195\163\239\191\189\239\191\189\239\191\189\239\191\189\061\239\191\189\239\191\189\239\191\189\194\187\239\191\189\195\143", unpack(u11, 1, 300)) do
                local v32 = v[1];
                v30[v32] = {
                    PowerIn = v[2],
                    PowerOut = v[3]
                };
                local v33 = shared.CachedConnections[v32];

                if v33 and (v33.Wires and v33.PowerOut) then
                    local v34 = true;

                    if v33.PowerOut then
                        for i, v2 in v33.PowerOut do
                            if v30[v32].PowerOut[i] ~= v2 then
                                v34 = false;
                            end;
                        end;
                    end;

                    if v34 and v33.Wires then
                        v30[v32].Wires = v33.Wires;
                    else
                        v30[v32].Wires = u18(v32, v30[v32].PowerOut);
                    end;
                elseif v30[v32].PowerOut then
                    v30[v32].Wires = u18(v32, v30[v32].PowerOut);
                end;

                if v30[v32].Wires then
                    for _, v2 in v30[v32].Wires do
                        if v2 ~= 0 then
                            v31[v2] = true;
                        end;
                    end;
                end;
            end;

            shared.CachedConnections = v30;

            for _, child in Wires:GetChildren() do
                if not v31[child] then
                    child:Destroy();
                end;
            end;
        end;
    end);
end;

local function u35() -- Line: 318
    -- upvalues: u10 (ref)
    for _, v in pairs(u10) do
        v:Disconnect();
    end;

    u10 = {};
end;

local function u53() -- Line: 325
    -- upvalues: u10 (ref), u7 (ref), u8 (ref), u1 (copy), u5 (ref), u6 (ref), u2 (copy), u25 (copy), u35 (copy), ButtonFrame (copy), Items (copy)
    local function v46(u36: userdata) -- Line: 326
        -- upvalues: u10 (ref), u7 (ref), u8 (ref), u1 (ref), u5 (ref), u6 (ref), u2 (ref), u25 (ref)
        table.insert(u10, u36.MouseEnter:Connect(function() -- Line: 328
            -- upvalues: u36 (copy), u7 (ref), u8 (ref), u1 (ref)
            u36:FindFirstChild("Hover").Enabled = true;
            local v37 = u36.Name:find("In");
            local string_sub_ret = string.sub(u36.Name, -1);
            local v38 = tonumber(string_sub_ret);
            local v39 = shared.CachedConnections[u7];

            if not (v39 and (not v37 or v39.PowerIn) and (v37 or v39.PowerOut)) then
                return;
            end;

            if v37 then
                local v40 = v39.PowerIn[v38];

                if v40 ~= 0 then
                    local v41 = shared.CachedConnections[v40];

                    if not v41 then
                        return;
                    end;

                    local v42 = nil;

                    for i, v in v41.PowerOut do
                        if v == u7 then
                            v42 = i;
                            break;
                        end;
                    end;

                    if not v42 then
                        return;
                    end;

                    local v43 = v41.Wires and v41.Wires[v42];

                    if not v43 or v43 == 0 then
                        return;
                    end;

                    u8 = v43;
                    u8.Color = u1.Red;
                end;
            else
                local v44 = v39.Wires and v39.Wires[v38];

                if not v44 or v44 == 0 then
                    return;
                end;

                u8 = v44;
                u8.Color = u1.Green;
            end;
        end));
        table.insert(u10, u36.MouseLeave:Connect(function() -- Line: 362
            -- upvalues: u36 (copy), u8 (ref), u1 (ref)
            u36:FindFirstChild("Hover").Enabled = false;

            if u8 then
                u8.Color = u1.Black;
                u8 = nil;
            end;
        end));
        table.insert(u10, u36.MouseButton1Click:Connect(function() -- Line: 371
            -- upvalues: u5 (ref), u36 (copy), u6 (ref), u7 (ref), u2 (ref), u25 (ref)
            local string_sub_ret = string.sub(u36.Name, -1);
            u5 = tonumber(string_sub_ret);
            local string_sub_ret2 = string.sub(u36.Name, 1, -2);
            u6 = string_sub_ret2;
            local v45 = shared.CachedConnections[u7];

            if not (v45 and (v45[string_sub_ret2] and v45[string_sub_ret2][u5] ~= 0)) then
                script:SetAttribute("Placing", true);
                u25(u7);

                return;
            end;

            u2("Fire", "\239\191\189\239\191\189\239\191\189\195\166\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\067\239\191\189\239\191\189\239\191\189\056\239\191\189\239\191\189\239\191\189\239\191\189\062", "\239\191\189\239\191\189\195\172\083\095\194\186\068\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\067\239\191\189\239\191\189\239\191\189\239\191\189\194\174\106\239\191\189", u7, v45[string_sub_ret2][u5], u5, u6, true);
            u5 = nil;
            u6 = nil;
            script:SetAttribute("Placing", false);
        end));
    end;

    u35();

    for _, child in ButtonFrame:GetChildren() do
        for _, child2 in child:GetChildren() do
            if child2:IsA("ImageButton") and shared.CachedConnections[u7] then
                local v47 = child2.Name:find("PowerIn") and "PowerIn" or "PowerOut";
                local string_sub_ret = string.sub(child2.Name, -1);
                local v48 = tonumber(string_sub_ret);
                local v49 = shared.CachedConnections[u7][v47];

                if v49 and (not v49 or (v49 and #v49 or v49) >= v48) then
                    child2.Visible = true;

                    if v49[v48] ~= 0 then
                        local v50 = v49[v48];
                        local Attribute = v50:GetAttribute("ID");
                        local Attribute2 = v50:GetAttribute("Skin");

                        if Attribute then
                            Attribute = Items[Attribute];
                        end;

                        local v51;

                        if Attribute then
                            v51 = Attribute.Image[Attribute2 or "Default"];
                        else
                            v51 = Attribute;
                        end;

                        local v52 = v51 or Attribute.Image;

                        if not v52 then
                            warn("[ElectricityController] - Image not found for connection slot, bench found name : " .. v50.Name);
                        end;

                        child2.ImageLabel.Image = v52;
                    end;

                    child2.ImageLabel.Visible = v49[v48] ~= 0;
                    child2.TextLabel.Visible = v49[v48] == 0;
                    v46(child2);
                else
                    child2.Visible = false;
                end;
            end;
        end;
    end;
end;

local function _() -- Line: 438
    -- upvalues: u7 (ref), ConnectionsBillboardGui (copy), u53 (copy)
    if not u7 then
        return nil;
    end;

    ConnectionsBillboardGui.Adornee = u7:FindFirstChild("Main");
    u53();
end;

OpenBench.Event:Connect(function(p54: userdata) -- Line: 447
    -- upvalues: u7 (ref), HumanoidRootPart (copy), RaycastUtil (copy), ActiveBenchModule (copy), u29 (copy), u5 (ref), NumberUtil (copy), u2 (copy), u6 (ref), ConnectionsBillboardGui (copy), u25 (copy), u53 (copy)
    if not p54.Main then
        return;
    end;

    if u7 == p54 then
        return;
    end;

    if not HumanoidRootPart then
        return;
    end;

    local BaseCabinetUnder = RaycastUtil:GetBaseCabinetUnder(HumanoidRootPart.Position);
    local v55;

    if BaseCabinetUnder then
        local ClientInfo = ActiveBenchModule.GetClientInfo(BaseCabinetUnder);

        if type(ClientInfo) == "table" then
            v55 = not ClientInfo.Access;
        else
            v55 = false;
        end;
    else
        v55 = false;
    end;

    if v55 then
        u29("You are building blocked");

        return;
    end;

    if not (u7 and u5) then
        u7 = p54;

        if not u7 then
            return;
        end;

        ConnectionsBillboardGui.Adornee = u7:FindFirstChild("Main");
        u53();

        return;
    end;

    if not NumberUtil:IsWithin(HumanoidRootPart.Position, p54.Main.Position, 40) then
        return;
    end;

    u2("Fire", "\239\191\189\239\191\189\239\191\189\195\166\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\067\239\191\189\239\191\189\239\191\189\056\239\191\189\239\191\189\239\191\189\239\191\189\062", "\239\191\189\239\191\189\195\172\083\095\194\186\068\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\067\239\191\189\239\191\189\239\191\189\239\191\189\194\174\106\239\191\189", u7, p54, u5, u6);
    ConnectionsBillboardGui.Adornee = nil;
    u7 = nil;
    u5 = nil;
    u6 = nil;
    script:SetAttribute("Placing", false);
    u25();
end);
EquipWires.Event:Connect(function(p56: boolean) -- Line: 473
    -- upvalues: u25 (copy), u12 (ref), u3 (ref), Value (copy), u26 (copy), u11 (ref), u2 (copy), u18 (copy), Wires (copy), WireCutterInfo (copy), ConnectionsBillboardGui (copy), u7 (ref), u5 (ref)
    if p56 and not script:GetAttribute("WiresEquipped") then
        u25();

        if u12 then
            task.cancel(u12);
        end;

        u12 = task.defer(function() -- Line: 240
            -- upvalues: u3 (ref), Value (ref), u26 (ref), u11 (ref), u2 (ref), u18 (ref), Wires (ref)
            while true do
                while true do
                    repeat
                        task.wait(0.25);
                    until os.clock() - u3 > Value;

                    u3 = os.clock();
                    u26();

                    if #u11 ~= 0 then
                        break;
                    end;

                    shared.CachedConnections = {};
                end;

                local v57 = {};
                local v58 = {};

                for _, v in u2("Fire", "\239\191\189\239\191\189\239\191\189\195\166\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\239\191\189\067\239\191\189\239\191\189\239\191\189\056\239\191\189\239\191\189\239\191\189\239\191\189\062", "\239\191\189\110\087\239\191\189\063\239\191\189\097\053\195\163\239\191\189\239\191\189\239\191\189\239\191\189\061\239\191\189\239\191\189\239\191\189\194\187\239\191\189\195\143", unpack(u11, 1, 300)) do
                    local v59 = v[1];
                    v57[v59] = {
                        PowerIn = v[2],
                        PowerOut = v[3]
                    };
                    local v60 = shared.CachedConnections[v59];

                    if v60 and (v60.Wires and v60.PowerOut) then
                        local v61 = true;

                        if v60.PowerOut then
                            for i, v2 in v60.PowerOut do
                                if v57[v59].PowerOut[i] ~= v2 then
                                    v61 = false;
                                end;
                            end;
                        end;

                        if v61 and v60.Wires then
                            v57[v59].Wires = v60.Wires;
                        else
                            v57[v59].Wires = u18(v59, v57[v59].PowerOut);
                        end;
                    elseif v57[v59].PowerOut then
                        v57[v59].Wires = u18(v59, v57[v59].PowerOut);
                    end;

                    if v57[v59].Wires then
                        for _, v2 in v57[v59].Wires do
                            if v2 ~= 0 then
                                v58[v2] = true;
                            end;
                        end;
                    end;
                end;

                shared.CachedConnections = v57;

                for _, child in Wires:GetChildren() do
                    if not v58[child] then
                        child:Destroy();
                    end;
                end;
            end;
        end);
    end;

    script:SetAttribute("WiresEquipped", p56);
    WireCutterInfo.Visible = p56;

    if not p56 then
        if u12 then
            task.cancel(u12);
        end;

        ConnectionsBillboardGui.Adornee = nil;
        u7 = nil;
        u5 = nil;
    end;
end);
UserInputService.InputBegan:Connect(function(p62) -- Line: 488
    -- upvalues: u7 (ref), u5 (ref), ConnectionsBillboardGui (copy), u6 (ref), u25 (copy)
    if p62.UserInputType == Enum.UserInputType.MouseButton2 and (u7 or u5) then
        ConnectionsBillboardGui.Adornee = nil;
        u7 = nil;
        u5 = nil;
        u6 = nil;
        script:SetAttribute("Placing", false);
        u25();
    end;
end);
UpdateBenchConnections.OnClientEvent:Connect(function(p63, p64) -- Line: 501
    -- upvalues: HumanoidRootPart (copy), u29 (copy), NumberUtil (copy), u18 (copy), u7 (ref), ConnectionsBillboardGui (copy), u53 (copy)
    if not (p63 and HumanoidRootPart) then
        return;
    end;

    if typeof(p63) == "string" then
        u29(p63);

        return;
    end;

    if typeof(p63) == "table" or not (p63:FindFirstChild("Main") and NumberUtil:IsWithin(p63.Main.Position, HumanoidRootPart.Position, 40)) then
        return;
    end;

    local v65 = shared.CachedConnections[p63];

    if v65 then
        local Wires2 = v65.Wires;

        if Wires2 then
            for _, v in Wires2 do
                if v ~= 0 then
                    v:Destroy();
                end;
            end;
        end;

        local v66 = p64.PowerOut and u18(p63, p64.PowerOut);
        p64.Wires = v66;
        p64.PowerThroughput = v65.PowerThroughput;
        shared.CachedConnections[p63] = p64;
    end;

    if not u7 then
        return;
    end;

    ConnectionsBillboardGui.Adornee = u7:FindFirstChild("Main");
    u53();
end);
UpdateBenchPower.OnClientEvent:Connect(function(p67: table, p68: table) -- Line: 534
    for i, v in p67 do
        if shared.CachedConnections[v] then
            shared.CachedConnections[v].PowerThroughput = p68[i];
        end;
    end;
end);
script:GetAttributeChangedSignal("WiresEquipped"):Connect(function() -- Line: 546
    -- upvalues: u20 (copy)
    u20((script:GetAttribute("WiresEquipped")));
end);
script:GetAttributeChangedSignal("Placing"):Connect(function() -- Line: 551
    -- upvalues: WireCutterInfo (copy), PlayVMAnimation (copy), WireCutters (copy), u7 (ref), NumberUtil (copy), HumanoidRootPart (copy), u9 (ref), TemplateWire (copy), RootRigAttachment (copy), u6 (ref), u1 (copy), VFX (copy)
    local function _(p69: boolean) -- Line: 552
        -- upvalues: WireCutterInfo (ref)
        WireCutterInfo.DistanceLabel.Visible = p69;
        WireCutterInfo.DistanceDetailLabel.Visible = p69;
        WireCutterInfo.DistanceFailLabel.Visible = p69;
    end;

    local Attribute = script:GetAttribute("Placing");
    PlayVMAnimation:Fire("WireCutter");
    WireCutters:Play();

    if not Attribute then
        WireCutterInfo.DistanceLabel.Visible = false;
        WireCutterInfo.DistanceDetailLabel.Visible = false;
        WireCutterInfo.DistanceFailLabel.Visible = false;

        return;
    end;

    while script:GetAttribute("Placing") do
        if u7 and u7.Main then
            WireCutterInfo.DistanceLabel.Visible = true;
            WireCutterInfo.DistanceDetailLabel.Visible = true;
            WireCutterInfo.DistanceFailLabel.Visible = true;
            local v70 = NumberUtil:RoundNumber((HumanoidRootPart.Position - u7.Main.Position).Magnitude, 1);
            local v71 = v70 <= 40;
            WireCutterInfo.DistanceLabel.TextColor3 = WireCutterInfo.DistanceLabel:GetAttribute(v71 and "Green" or "Red");
            WireCutterInfo.DistanceLabel.Text = tostring(v70);
            WireCutterInfo.DistanceFailLabel.Visible = not v71;

            if not u9 then
                local v72 = TemplateWire:Clone();

                if not u7.Main:FindFirstChild("WireAttachment") then
                    local Attachment = Instance.new("Attachment");
                    Attachment.Name = "WireAttachment";
                    Attachment.Parent = u7.Main;
                end;

                v72.Attachment0 = u7.Main.WireAttachment;
                v72.Attachment1 = RootRigAttachment;
                v72.Color = u6 == "PowerIn" and u1.Red or u1.Green;
                v72.Parent = VFX;
                u9 = v72;
            end;

            u9.Enabled = v71;
            task.wait();
        else
            script:SetAttribute("Placing", false);
        end;
    end;

    WireCutterInfo.DistanceLabel.Visible = false;
    WireCutterInfo.DistanceDetailLabel.Visible = false;
    WireCutterInfo.DistanceFailLabel.Visible = false;

    if u9 then
        u9:Destroy();
    end;

    u9 = nil;
end);

local function v76(p73: userdata) -- Line: 107
    -- upvalues: u4 (copy)
    if not p73 then
        warn("[ElectricityController] - NewWindmill fired without a windmill model");

        return;
    end;

    local AnimationController = p73:FindFirstChild("AnimationController");
    local SpinAnimation = p73:FindFirstChild("SpinAnimation");

    if not (AnimationController and SpinAnimation) then
        warn("[ElectricityController] - No animation/controller found on windmill model ");

        return;
    end;

    if u4[p73] then
        return;
    end;

    u4[p73] = true;
    local v74 = AnimationController:LoadAnimation(SpinAnimation);
    local WaterCollision = p73:FindFirstChild("WaterCollision");

    if WaterCollision then
        local Position = WaterCollision.Position;
        local v75 = workspace.Terrain:ReadVoxels(Region3.new(Position, Position):ExpandToGrid(4), 4);
        print(v75);

        if v75 and (v75[1] and (v75[1][1] and v75[1][1][1] == Enum.Material.Water)) then
            v74:Play();
        end;
    else
        v74:Play();
    end;
end;

while true do
    task.wait(8);

    for _, child in pairs(Bases:GetChildren()) do
        for _, child2 in child:GetChildren() do
            if child2.Name == "Windmill" or child2.Name == "Water Turbine" then
                local v77 = child2;

                for _, child3 in pairs(child2:GetChildren()) do
                    if child3.Main and (child3.Main.Position and NumberUtil:IsWithin(child3.Main.Position, HumanoidRootPart.Position, 70)) then
                        v76(child3, v77.Name);
                        task.wait();
                    end;
                end;

                task.wait();
            end;
        end;

        task.wait();
    end;
end;
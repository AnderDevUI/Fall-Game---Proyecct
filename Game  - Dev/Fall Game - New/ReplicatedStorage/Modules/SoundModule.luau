-- [PATH] ReplicatedStorage / Modules / SoundModule @Type ModuleScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SoundService = game:GetService("SoundService");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local LocalSounds = ReplicatedStorage:WaitForChild("LocalSounds");
workspace:WaitForChild("VFX");
local Items = require(Modules:WaitForChild("Items"));
local NumberUtil = require(Modules:WaitForChild("NumberUtil"));
local BenchInfo = require(Modules:WaitForChild("BenchInfo"));
local _ = Players.LocalPlayer;
local workspace_CurrentCamera = workspace.CurrentCamera;
local SoundRemotes = ReplicatedStorage:WaitForChild("SoundRemotes");
local Footsteps = SoundRemotes:WaitForChild("Footsteps");
local Play = SoundRemotes:WaitForChild("Play");
local u1 = nil;
local u2 = {
    FootstepMaxVolumes = {
        Grass = 0.5,
        Metal = 0.5,
        Mud = 0.6,
        Rock = 0.5,
        Sand = 0.5,
        Wood = 0.5
    },
    CustomSoundSkins = {
        CyberPop = 1.15
    }
};

local function GetLocalCustomSound(p3, p4, p5) -- Line: 51
    -- upvalues: u2 (copy)
    local v6;

    if p4 and (u2.CustomSoundSkins[p4] and (p3 and p3.Parent)) then
        v6 = p3.Parent:FindFirstChild((`{p3.Name}_{p4}`));

        if v6 then
            if p5 then
                v6.PlaybackSpeed = p5;
            end;
        else
            v6 = p3;
        end;
    else
        v6 = p3;
    end;

    return v6;
end;

function u2.PlaySound(p7, p8, p9, p10, p11) -- Line: 65
    -- upvalues: u2 (copy), Play (copy)
    if p10 then
        p8.PlaybackSpeed = p10;
    end;

    local v12;

    if p11 and (u2.CustomSoundSkins[p11] and (p8 and p8.Parent)) then
        v12 = p8.Parent:FindFirstChild((`{p8.Name}_{p11}`));

        if v12 then
            if p10 then
                v12.PlaybackSpeed = p10;
            end;
        else
            v12 = p8;
        end;
    else
        v12 = p8;
    end;

    v12:Play();
    Play:FireServer(p8, "Play" .. (p9 and "Duplicate" or ""), p10);
end;

function u2.StopSound(p13, p14) -- Line: 74
    -- upvalues: Play (copy)
    p14:Stop();
    Play:FireServer(p14, "Stop");
end;

function u2.ChangeSoundSpeed(p15, p16, p17) -- Line: 79
    -- upvalues: Play (copy)
    p16.PlaybackSpeed = p17;
    Play:FireServer(p16, "ChangeSpeed", p17);
end;

function u2.ToggleFootstep(p18, p19, p20, p21) -- Line: 84
    -- upvalues: u2 (copy), Footsteps (copy)
    local PrimaryPart = p19.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    for _, child in pairs(PrimaryPart:GetChildren()) do
        local Name = child.Name;

        if Name:sub(1, 9) == "Footsteps" and child:IsA("Sound") then
            child.Volume = child == p20 and (u2.FootstepMaxVolumes[Name:sub(10)] or (p20:GetAttribute("MaxVolume") or 0)) or 0;
        end;
    end;

    if not p20 then
        Footsteps:FireServer(nil);

        return;
    end;

    if p21 then
        p20.PlaybackSpeed = p21;
    end;

    Footsteps:FireServer(p20.Name:sub(10), p21);
end;

function u2.PlayDuplicateSound(p22, p23, p24, p25, p26, p27) -- Line: 102
    -- upvalues: u1 (ref), u2 (copy)
    if not (p23 and p23.Parent) then
        if p24 and (p24.Parent and p25) then
            if not (u1 and u1.Parent) then
                u1 = workspace:FindFirstChild("CameraRoot");
            end;

            if not u1 then
                return;
            end;

            local Attachment = Instance.new("Attachment");
            Attachment.Parent = u1.PrimaryPart;
            Attachment.WorldCFrame = CFrame.new(p25);
            local u28 = p24:Clone();
            u28.Parent = Attachment;
            local Name = u28.Name;

            if Name:sub(Name:len() - 4) == "Shoot" and Name ~= "Shoot" then
                p22:ReverbSound(u28, 600, 1000);
            end;

            u28:Play();
            task.defer(function() -- Line: 121
                -- upvalues: Attachment (copy), u28 (copy)
                if not (Attachment and Attachment.Parent) then
                    return;
                end;

                if not u28.IsPlaying then
                    Attachment:Destroy();

                    return;
                end;

                u28.Ended:Wait();
                Attachment:Destroy();
            end);
        end;

        return;
    end;

    local Name = p23.Name;
    local v29;

    if Name:sub(Name:len() - 4) == "Shoot" then
        v29 = Name ~= "Shoot";
    else
        v29 = false;
    end;

    if p27 and (u2.CustomSoundSkins[p27] and (p23 and p23.Parent)) then
        p23 = p23.Parent:FindFirstChild((`{p23.Name}_{p27}`)) or p23;
    end;

    if v29 == false and not p23.IsPlaying then
        p23:Play();

        return;
    end;

    local u30 = p23:Clone();
    u30:Stop();
    u30.Parent = p23.Parent;

    if v29 then
        p22:ReverbSound(u30, 600, 1000);
    end;

    if u30.PlayOnRemove then
        u30:Destroy();

        return;
    end;

    u30:Play();
    task.defer(function() -- Line: 157
        -- upvalues: u30 (copy)
        if not (u30 and u30.Parent) then
            return;
        end;

        if not u30.IsPlaying then
            u30:Destroy();

            return;
        end;

        u30.Ended:Wait();
        u30:Destroy();
    end);
end;

function u2.ReverbSound(p31, p32, p33, p34) -- Line: 211
    -- upvalues: workspace_CurrentCamera (copy), NumberUtil (copy), SoundService (copy)
    local v35, v36 = NumberUtil:IsWithin(p32.Parent.Position, workspace_CurrentCamera.CFrame.Position, p33);

    if not v35 then
        p32.PlayOnRemove = false;
        p32.Volume = p32.Volume * 8;
        local v37 = (math.sqrt(v36) - p33) / (p34 - p33);
        local math_min_ret = math.min(v37, 1);
        local v38 = SoundService.GunshotReverb:Clone();
        local Chorus = v38.Chorus;
        Chorus.Mix = Chorus.Mix * math_min_ret;
        v38.Parent = p32;
        p32.SoundGroup = v38;
    end;
end;

function u2.PlayItemSound(p39: table, p40: any, p41: string) -- Line: 230
    -- upvalues: Items (copy), LocalSounds (copy), SoundService (copy)
    if not p40 then
        return;
    end;

    if type(p40) == "number" then
        p40 = Items[p40] or p40;
    end;

    if not p40 then
        return;
    end;

    local Sounds = p40.Sounds;

    if not Sounds then
        return;
    end;

    local v42 = Sounds[p41];

    if not v42 then
        return;
    end;

    local v43 = LocalSounds[v42];
    local PlaybackSpeed = v43.PlaybackSpeed;
    v43.PlaybackSpeed = v43.PlaybackSpeed + math.random(-20, 20) / 400;
    SoundService:PlayLocalSound(v43);
    v43.PlaybackSpeed = PlaybackSpeed;
end;

function u2.PlayBenchSound(p44: table, p45: string, p46: string, p47: string?) -- Line: 245
    -- upvalues: BenchInfo (copy), LocalSounds (copy), SoundService (copy)
    local v48 = BenchInfo[p45];

    if not v48 then
        return;
    end;

    local Sounds = v48.Sounds;

    if not Sounds then
        return;
    end;

    local v49 = Sounds[`{p46}{(not p47 or p47 == "Default") and "" or p47}`];

    if not v49 then
        return;
    end;

    local v50 = LocalSounds.BenchSounds[v49];
    local PlaybackSpeed = v50.PlaybackSpeed;
    v50.PlaybackSpeed = v50.PlaybackSpeed + math.random(-20, 20) / 400;
    SoundService:PlayLocalSound(v50);
    v50.PlaybackSpeed = PlaybackSpeed;
end;

return u2;
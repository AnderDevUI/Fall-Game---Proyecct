-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / NewSkinModule @Type ModuleScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Modules = ReplicatedStorage:WaitForChild("Modules");
local SkinsModule = require(Modules:WaitForChild("SkinsModule"));
local Update = ReplicatedStorage:WaitForChild("ShopRemotes"):WaitForChild("Update");
local UIConstants = require(script.Parent:WaitForChild("UIConstants"));
local PlayerDataModule = require(script.Parent:WaitForChild("PlayerDataModule"));

local function GetOwnedSkins() -- Line: 14
    -- upvalues: PlayerDataModule (copy)
    return PlayerDataModule.Skins or {};
end;

local u1 = {};
script.AncestryChanged:Connect(function() -- Line: 22
    -- upvalues: u1 (copy)
    if script:IsDescendantOf(game) then
        return;
    end;

    for _, v in u1 do
        v:Disconnect();
    end;

    table.clear(u1);
end);
u1[#u1 + 1] = Update.OnClientEvent:Connect(function(p2, ...) -- Line: 30
    -- upvalues: SkinsModule (copy), UIConstants (copy), PlayerDataModule (copy)
    if p2 == "ShowSkin" then
        local v3 = ...;
        local SkinInfo = SkinsModule:GetSkinInfo(v3);

        if not SkinInfo then
            return;
        end;

        local Container = UIConstants.FRAME_CRATESCROLLER.Main.ZoomEffect.Container;
        local v4 = Container:FindFirstChild("Template" .. SkinInfo.Rarity);

        if not v4 then
            return;
        end;

        local v5, v6 = unpack(string.split(v3, "/"));
        local v7 = v4:Clone();
        v7.AnchorPoint = Vector2.new(0.5, 0.5);
        v7.Position = UDim2.new(0.5, 0, -0.4, 0);
        v7.Size = UDim2.new(1, 0, 0.5, 0);
        local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
        UIAspectRatioConstraint.AspectRatio = v4.Size.X.Scale * Container.Size.X.Scale / (v4.Size.Y.Scale * Container.Size.Y.Scale);
        UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
        UIAspectRatioConstraint.Parent = v7;
        v7.ZIndex = 10;
        v7.Frame.ItemName.Text = v5;
        v7.Frame.SkinName.Text = v6;
        v7.Frame.ItemImage.Image = SkinInfo.Image;
        v7.Name = "ShowSkin";
        local v8 = 0;

        for _, v in PlayerDataModule.Skins or {} do
            if v == v3 then
                v8 = v8 + 1;

                if v8 > 1 then
                    break;
                end;
            end;
        end;

        v7.New.Visible = v8 <= 1;
        local v9 = script.NewSkin:Clone();
        v9.Parent = v7;
        v9.Visible = true;
        v7.Parent = UIConstants.FRAME_MAIN;
        v7.Visible = true;
        v7:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quart", 0.5, true);
        task.wait(3);
        v7:TweenPosition(UDim2.new(0.5, 0, -0.4, 0), "In", "Quart", 0.75, true);
        task.wait(0.75);
        v7:Destroy();
    end;
end);

return true;
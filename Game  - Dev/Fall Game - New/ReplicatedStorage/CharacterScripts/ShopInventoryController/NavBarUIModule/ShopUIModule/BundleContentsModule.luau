-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController / NavBarUIModule / ShopUIModule / BundleContentsModule @Type ModuleScript


local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UIConstants = require(script.Parent.Parent.Parent:WaitForChild("UIConstants"));
local Frame = UIConstants.FRAME_BUNDLECONTENTS.Frame;
local Modules = ReplicatedStorage:WaitForChild("Modules");
local Parent = script.Parent.Parent.Parent;
local BundleSkinsModule = require(Modules:WaitForChild("BundleSkinsModule"));
local SoundModule = require(Parent:WaitForChild("SoundModule"));
local SkinsModule = require(Modules:WaitForChild("SkinsModule"));
local u3 = {
    Open = function(p1: string) -- Line: 19
        -- upvalues: Frame (copy), BundleSkinsModule (copy), SkinsModule (copy), UIConstants (copy)
        for _, child in pairs(Frame:GetChildren()) do
            if child:IsA("ImageButton") and child.Name ~= "Template" then
                child:Destroy();
            end;
        end;

        local SkinsFromName = BundleSkinsModule.GetSkinsFromName(p1);

        if not SkinsFromName then
            return;
        end;

        local Template = Frame.Template;

        for i, v in pairs(SkinsFromName) do
            local v2 = Template:Clone();
            local Image = SkinsModule.CachedSkinRarities[v].Image;
            local string_split_ret = string.split(v, "/");
            v2.Frame.ItemImage.Image = Image;
            v2.Frame.ItemName.Text = string_split_ret[1];
            v2.Frame.SkinName.Text = string_split_ret[2];
            v2.LayoutOrder = i;
            v2.Name = i;
            v2.Parent = Frame;
            v2.Visible = true;
        end;

        UIConstants.FRAME_BUNDLECONTENTS.Visible = true;
    end,

    Close = function() -- Line: 45
        -- upvalues: UIConstants (copy)
        UIConstants.FRAME_BUNDLECONTENTS.Visible = false;
    end
};

if true then
    local Close = UIConstants.FRAME_BUNDLECONTENTS:WaitForChild("Close");
    Close.MouseButton1Click:Connect(function() -- Line: 51
        -- upvalues: SoundModule (copy), u3 (copy)
        SoundModule.PlaySound("Click");
        u3.Close();
    end);
    Close.MouseEnter:Connect(function() -- Line: 55
        -- upvalues: SoundModule (copy), Close (copy)
        SoundModule.PlaySound("Hover");
        Close.Detail.Frame.UIStroke.Color = Color3.new(1, 1, 1);
    end);
    Close.MouseLeave:Connect(function() -- Line: 59
        -- upvalues: Close (copy)
        Close.Detail.Frame.UIStroke.Color = Close.Detail.Frame.UIStroke:GetAttribute("ColorDefault");
    end);
end;

return u3;
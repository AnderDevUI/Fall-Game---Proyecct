-- [PATH] ReplicatedStorage / CharacterScripts / ShopInventoryController @Type LocalScript


local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local SoundModule = require(script:WaitForChild("SoundModule"));
local MobileModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MobileModule"));
local PreferredInputController = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PreferredInputController");
local v1;

while true do
    v1 = PlayerGui:FindFirstChild("Main");

    if v1 and v1:FindFirstChild("ShopInventoryFrame") then
        break;
    end;

    task.wait(0.1);
end;

local ShopInventoryFrame = v1.ShopInventoryFrame;
local Shop = ShopInventoryFrame:WaitForChild("Shop");
local NavBar = ShopInventoryFrame:WaitForChild("NavBar");
local ButtonList = NavBar:WaitForChild("ButtonList");
local Inventory = ShopInventoryFrame:WaitForChild("Inventory");
local BG = ShopInventoryFrame:WaitForChild("BG");
local Settings = ShopInventoryFrame:WaitForChild("Settings");
local UIConstants = require(script:WaitForChild("UIConstants"));

for i, v in pairs({
    PLAYER_GUI = PlayerGui,
    GUI_MAIN = v1,
    FRAME_MAIN = ShopInventoryFrame,
    FRAME_CONFIRM = ShopInventoryFrame:WaitForChild("ConfirmPrompt"),
    FRAME_NAVBAR = NavBar,
    NAV_BUTTONS = ButtonList,
    NAV_BUTTON_INVENTORY = ButtonList:WaitForChild("Inventory"),
    NAV_BUTTON_SHOP = ButtonList:WaitForChild("Shop"),
    NAV_BUTTON_SETTINGS = ButtonList:WaitForChild("Settings"),
    NAV_BUTTON_SHOP_ROTATER = ButtonList.Shop:WaitForChild("Limited"):WaitForChild("Frame"):WaitForChild("Rotate"),
    FRAME_INVENTORY = Inventory,
    SCROLLFRAME_SKINS = Inventory:WaitForChild("Skins"),
    SKINS_UIGRIDLAYOUT = Inventory.Skins:WaitForChild("UIGridLayout"),
    FRAME_SKINS_SELECTED = Inventory:WaitForChild("Selected"),
    FRAME_SHOP = Shop,
    SHOP_NAV = Shop:WaitForChild("ShopNav"),
    SHOP_CAPS = Shop:WaitForChild("Caps"),
    SHOP_CASE = Shop:WaitForChild("Case"),
    SHOP_CASESCROLL = Shop.Case:WaitForChild("CaseFrames"),
    SHOP_FEATURED = Shop:WaitForChild("Featured"),
    SHOP_BUYCAPS = Shop:WaitForChild("BuyCaps"),
    FRAME_BUNDLECONTENTS = Shop:WaitForChild("BundleContents"),
    SHOP_CASECONTENTS = Shop:WaitForChild("CaseContents"),
    FRAME_CRATESCROLLER = ShopInventoryFrame:WaitForChild("CrateScroller"),
    FRAME_CASECONTENTS = ShopInventoryFrame:WaitForChild("CaseContents"),
    FRAME_SETTINGS = Settings,
    SETTINGS_RESET = Settings:WaitForChild("Reset"),
    SETTINGS_CHANGEKEY = Settings:WaitForChild("ChangeHotkey"),
    SETTINGS_NAV = Settings:WaitForChild("NavBar"),
    MOBILE_TAB = Settings:WaitForChild("Mobile"),
    MOBILE_TAB_BUTTON = Settings.NavBar:WaitForChild("Mobile"),
    MOBILE_TAB_EDIT = Settings.Mobile:WaitForChild("EditButtons"),
    MOBILE_TAB_LIST = Settings.Mobile:WaitForChild("Frame"),
    MOBILE_EDITOR = ShopInventoryFrame:WaitForChild("MobileEditor")
}) do
    UIConstants[i] = v;
end;

require(script:WaitForChild("NavBarUIModule"):WaitForChild("SettingsUIModule"));
require(script:WaitForChild("PlayerDataModule"));
local NavBarUIModule = require(script:WaitForChild("NavBarUIModule"));
NavBarUIModule.Load();
require(script:WaitForChild("NewSkinModule"));
require(script:WaitForChild("CaseOpenModule"));
UIConstants.NAV_BUTTON_INVENTORY.MouseButton1Click:Connect(function() -- Line: 99
    -- upvalues: SoundModule (copy), NavBarUIModule (copy), UIConstants (copy)
    SoundModule.PlaySound("Click");
    NavBarUIModule.ChangeFrame(UIConstants.FRAME_INVENTORY);
end);
UIConstants.NAV_BUTTON_INVENTORY.MouseEnter:Connect(function() -- Line: 103
    -- upvalues: SoundModule (copy), NavBarUIModule (copy), UIConstants (copy)
    SoundModule.PlaySound("Hover");
    NavBarUIModule.Enter(UIConstants.NAV_BUTTON_INVENTORY);
end);
UIConstants.NAV_BUTTON_INVENTORY.MouseLeave:Connect(function() -- Line: 107
    -- upvalues: NavBarUIModule (copy), UIConstants (copy)
    NavBarUIModule.Leave(UIConstants.NAV_BUTTON_INVENTORY);
end);
UIConstants.NAV_BUTTON_SHOP.MouseButton1Click:Connect(function() -- Line: 111
    -- upvalues: SoundModule (copy), NavBarUIModule (copy), UIConstants (copy)
    SoundModule.PlaySound("Click");
    NavBarUIModule.ChangeFrame(UIConstants.FRAME_SHOP);
end);
UIConstants.NAV_BUTTON_SHOP.MouseEnter:Connect(function() -- Line: 115
    -- upvalues: SoundModule (copy), NavBarUIModule (copy), UIConstants (copy)
    SoundModule.PlaySound("Hover");
    NavBarUIModule.Enter(UIConstants.NAV_BUTTON_SHOP);
end);
UIConstants.NAV_BUTTON_SHOP.MouseLeave:Connect(function() -- Line: 119
    -- upvalues: NavBarUIModule (copy), UIConstants (copy)
    NavBarUIModule.Leave(UIConstants.NAV_BUTTON_SHOP);
end);
UIConstants.NAV_BUTTON_SETTINGS.MouseButton1Click:Connect(function() -- Line: 123
    -- upvalues: SoundModule (copy), NavBarUIModule (copy), UIConstants (copy)
    SoundModule.PlaySound("Click");
    NavBarUIModule.ChangeFrame(UIConstants.FRAME_SETTINGS);
end);
UIConstants.NAV_BUTTON_SETTINGS.MouseEnter:Connect(function() -- Line: 127
    -- upvalues: SoundModule (copy), NavBarUIModule (copy), UIConstants (copy)
    SoundModule.PlaySound("Hover");
    NavBarUIModule.Enter(UIConstants.NAV_BUTTON_SETTINGS);
end);
UIConstants.NAV_BUTTON_SETTINGS.MouseLeave:Connect(function() -- Line: 131
    -- upvalues: NavBarUIModule (copy), UIConstants (copy)
    NavBarUIModule.Leave(UIConstants.NAV_BUTTON_SETTINGS);
end);

local function Toggle(p2: boolean) -- Line: 136
    -- upvalues: ShopInventoryFrame (copy), BG (copy)
    ShopInventoryFrame.Visible = p2;
    BG.Visible = p2;
    script:SetAttribute("Open", p2);
end;

local MainMenu = PlayerGui:WaitForChild("MainMenu");
MainMenu:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 147
    -- upvalues: MainMenu (copy), ShopInventoryFrame (copy), BG (copy)
    local Enabled = MainMenu.Enabled;
    ShopInventoryFrame.Visible = Enabled;
    BG.Visible = Enabled;
    script:SetAttribute("Open", Enabled);
end);
local Enabled = MainMenu.Enabled;
ShopInventoryFrame.Visible = Enabled;
BG.Visible = Enabled;
script:SetAttribute("Open", Enabled);
local CloseMenu = ShopInventoryFrame:WaitForChild("CloseMenu");
local MobileMenu = PlayerGui:WaitForChild("MainMenu"):WaitForChild("MainMenuController"):WaitForChild("MobileMenu");
CloseMenu.Activated:Connect(function() -- Line: 161
    -- upvalues: SoundModule (copy), MobileMenu (copy)
    SoundModule.PlaySound("Click");
    MobileMenu:Fire(true);
end);
PreferredInputController:GetAttributeChangedSignal("PreferredInput"):Connect(function() -- Line: 158, Name: RefreshCloseMenu
    -- upvalues: CloseMenu (copy), MobileModule (copy)
    CloseMenu.Visible = MobileModule.IsTouch();
end);
CloseMenu.Visible = MobileModule.IsTouch();
NavBarUIModule.RestoreTab();
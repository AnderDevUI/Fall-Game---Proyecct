-- [PATH] ReplicatedStorage / CharacterScripts / JukeboxController @Type LocalScript


local ContentProvider = game:GetService("ContentProvider");

for _, v in {
    {
        id = "rbxassetid://15379813342",
        artist = "zensei _____",
        title = "kaleidoscope",
        secret = "2ef85a08d75924f785936022ae36aa1f732db0fdbb45667c3d0a14de0057370f",
        playlist = "EXPLORE"
    },
    {
        id = "rbxassetid://16495782602",
        artist = "Finding Mero & Scarr.",
        title = "itÕs not easy when youÕre alone",
        secret = "759e47feebd5cb09f3ed8f7cf0ff396ac2e3aadb2031e96e7dd001e473afb5be",
        playlist = "EXPLORE"
    },
    {
        id = "rbxassetid://15379812739",
        artist = "Woven",
        title = "Alma",
        secret = "6313450910515a8650e242b9f369ec3a911cc270ec6b3e1adaa8b4d8561ad8bb",
        playlist = "EXPLORE"
    },
    {
        id = "rbxassetid://15618407254",
        artist = "Aether",
        title = "Moonstone",
        secret = "a1859ddc24473313864334270d3c02671ab505ef3637373c191c7dc168a2133f",
        playlist = "EXPLORE"
    },
    {
        id = "rbxassetid://15379841115",
        artist = "zensei _____",
        title = "destination heartbreak",
        secret = "5136558447f8e4bddd8daa8d916862d2afa8a439755c5676522676b3af0b2e9e",
        playlist = "EXPLORE"
    },
    {
        id = "rbxassetid://15379849326",
        artist = "Seawayz",
        title = "Breathing Me In",
        secret = "9f0059e2affc8e988af49eb3b963b816d8415dc2784c4b7abd2ca8f8ff7667aa",
        playlist = "EXPLORE"
    },
    {
        id = "rbxassetid://17267490000",
        artist = "Scarr.",
        title = "Tender",
        secret = "33f77354fd13d5155e7364d40ecb1d8044e51bb8f4f61cb8cde3a5aaa19c6d13",
        playlist = "EXPLORE"
    },
    {
        id = "rbxassetid://15379827687",
        artist = "¯neheart & Kazukii",
        title = "restless",
        secret = "549b79960d7d64065cd3053788d1757929338f988d75683e53b8bd083beeb535",
        playlist = "EXPLORE"
    },
    {
        id = "rbxassetid://17267543208",
        artist = "A.M.R",
        title = "Little Stars",
        secret = "36911ae472de2e7d16d894eeab9ea29ad9e49b7fa8f2c1d2506701c7c15dbece",
        playlist = "EXPLORE"
    },
    {
        id = "rbxassetid://16495809984",
        artist = "JNATHYN & F.O.O.L",
        title = "Tension",
        secret = "73daf048c3549aaac1dcddb1cda6428c0fda8a1b1694d6d56e1d283f182acfc9",
        playlist = "AMBUSH"
    },
    {
        id = "rbxassetid://14985152596",
        artist = "SKYLER",
        title = "Fall",
        secret = "6cb4407cce2207f3bb3db608f3825579655cccfd63a7f39bac8ecf84c596c2f2",
        playlist = "AMBUSH"
    },
    {
        id = "rbxassetid://14985156758",
        artist = "Godlands",
        title = "Crashing",
        secret = "03a423e9fb9f9458effd3d3c32308dc5bd6e0839701c9b8b26053c96ae367030",
        playlist = "AMBUSH"
    },
    {
        id = "rbxassetid://16495778963",
        artist = "KUURO",
        title = "DAMAGE",
        secret = "3eb4527a728c46c5c9c7dcb5b1349fcfe926e510693e84bb641bec94fb18219b",
        playlist = "AMBUSH"
    },
    {
        id = "rbxassetid://16042280125",
        artist = "F.O.O.L & Waveshaper",
        title = "Encounter",
        secret = "5f9da8e5c251b906403c38882a7d09ee224dce5ba04ae59fedc35c3f3607883e",
        playlist = "AMBUSH"
    },
    {
        id = "rbxassetid://15618906235",
        artist = "Godlands",
        title = "SLEEPER",
        secret = "c340a0c6a189a2ddadde9f1828be4bd300ca395f51fbb98db70c5aa02fd0f77f",
        playlist = "AMBUSH"
    },
    {
        id = "rbxassetid://17267465365",
        artist = "SKYLER",
        title = "Hit My Line",
        secret = "292edf47acb316ee3b3732f3605a8a6bce1285a583f84a4b7aaa835aec2cf81f",
        playlist = "AMBUSH"
    },
    {
        id = "rbxassetid://17267580344",
        artist = "KUURO & SKUM",
        title = "Alive",
        secret = "1dbd2a09e0bf64d8e3374cb40d87b172bd663fbbbc519e120d2363545eddb7a6",
        playlist = "AMBUSH"
    },
    {
        id = "rbxassetid://16042281673",
        artist = "Kage & MASTERIA",
        title = "Lights Out",
        secret = "df0557a9baef90af4728384e8ecc1584b532927d83b74f360642a3a77aebc942",
        playlist = "AMBUSH"
    },
    {
        id = "rbxassetid://16495779985",
        artist = "SKYLER",
        title = "Overdrive",
        secret = "2b42daa081d868034685f7856e873e6d7debfb56290edf8ffc09b80fc5fe7c37",
        playlist = "AMBUSH"
    },
    {
        id = "rbxassetid://17267542361",
        artist = "YULA",
        title = "Journey To Ascendance",
        secret = "0f176d2b5fd30e21b6f662391f2f1b5081ee109f4b2b91249bf2b588d709b6f1",
        playlist = "ASCENDANCE"
    },
    {
        id = "rbxassetid://15618991567",
        artist = "Foxela",
        title = "fallen (Instrumental)",
        secret = "1cebb56fb899575c805d8a37e17e9a8d55b7831b0c1edacef13b09b57ccf3afe",
        playlist = "ASCENDANCE"
    },
    {
        id = "rbxassetid://15379807795",
        artist = "Sol Rising & Banaati",
        title = "Arise",
        secret = "d05225406821d7e13425b2604966332db8bca9798da4cdf6094c47a085b7d393",
        playlist = "ASCENDANCE"
    },
    {
        id = "rbxassetid://16495792511",
        artist = "Snavs",
        title = "High",
        secret = "d64a7e8038dbd171ce5adbab8873c8b6f78a22ad064924406d07da05fba83b04",
        playlist = "ASCENDANCE"
    },
    {
        id = "rbxassetid://16495818996",
        artist = "PYLOT & F.O.O.L",
        title = "The Law",
        secret = "bc54970b526cadc0fa66d3c97cbb4e93e962942ab9fc5e80ba9f65372df0eb63",
        playlist = "ASCENDANCE"
    },
    {
        id = "rbxassetid://17267560610",
        artist = "Forty Cats & Arentis",
        title = "Zen",
        secret = "8bf423e00289b1ba7a11567f01a012028e6036b0b46bc2193c20de459c264f69",
        playlist = "ASCENDANCE"
    },
    {
        id = "rbxassetid://17267461857",
        artist = "Bound to Divide",
        title = "Spirals",
        secret = "fa3cbf7ee7586e3098ddb5392363e079702b29defc1d6a3c460bafc2f0fe4960",
        playlist = "ASCENDANCE"
    },
    {
        id = "rbxassetid://17267575036",
        artist = "Direct & CloudNone",
        title = "Nectar",
        secret = "81d8f6806b0e5301b1ae8f25baaf4ec10558eb5855068674a46246de2c9ad302",
        playlist = "ASCENDANCE"
    },
    {
        id = "rbxassetid://17267585504",
        artist = "PROFF",
        title = "Nara",
        secret = "1f406ff08aa7865990744f5d6fee2fba7e86ba5da351ea118f382a9250349116",
        playlist = "ASCENDANCE"
    },
    {
        id = "rbxassetid://17267443085",
        artist = "ATTLAS",
        title = "A Game Of Fairies",
        secret = "83e3f4eeab34fbbcce410b8aab19b9ec479479053383762fdf01d9600d547639",
        playlist = "ASCENDANCE"
    }
} do
    ContentProvider:RegisterEncryptedAsset(v.id, v.secret);
end;

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer.PlayerGui;
local ClientSignals = ReplicatedStorage:WaitForChild("ClientSignals");
local Boombox = PlayerGui:WaitForChild("Boombox");
local v1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait();
shared.LastJukebox = nil;
local Toggle = v1:WaitForChild("InventoryController"):WaitForChild("Toggle");
ClientSignals.Radio.OnClientEvent:Connect(function(p2) -- Line: 63
    -- upvalues: Toggle (copy), Boombox (copy)
    shared.LastJukebox = p2;
    Toggle:Fire("Inventory");
    Boombox.Enabled = true;
end);
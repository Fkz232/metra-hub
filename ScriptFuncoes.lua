local AbaScripts = Window:CreateTab("Scripts", nil)
local SecaoPrincipal = AbaScripts:CreateSection("Principal")
local SecaoFuncoes = AbaScripts:CreateSection("Funções", true)

local BotaoInfiniteYield = AbaScripts:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
      loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'), true))()
   end,
})

local SliderVelocidade = AbaScripts:CreateSlider({
   Name = "Velocidade",
   Range = {0, 10000},
   Increment = 1,
   Suffix = "velocidade",
   CurrentValue = 16,
   Flag = "Slider1",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

local BotaoAimbot = AbaScripts:CreateButton({
   Name = "Aimbot",
   Callback = function()
      loadstring(game:HttpGet('https://pastebin.com/raw/5rwtLBN1'))()
   end,
})

local BotaoESP = AbaScripts:CreateButton({
   Name = "RGB ESP",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/Fkz232/Project-Metra/refs/heads/main/ESP%20RGB'))()
   end,
})

local BotaoVfly = AbaScripts:CreateButton({
   Name = "Vfly",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Vehicle%20Fly%20Gui'))()
   end,
})

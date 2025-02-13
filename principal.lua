local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    rconsoleprint("Falha ao carregar Rayfield!\n")
    return
end

rconsoleprint("Por Metraton\n")
rconsoleprint("Project Metra Carregado!")
rconsoleprint("NÃO FECHE ")

local Window = Rayfield:CreateWindow({
   Name = "Project Metra",
   LoadingTitle = "",
   LoadingSubtitle = "por Metraton",
   ConfigurationSaving = {
      Enabled = false,
   },
})

local AbaScripts = Window:CreateTab("Scripts", nil)
local AbaAbracos = Window:CreateTab("Abraços", nil)
local AbaDesastresNaturais = Window:CreateTab("Desastres Naturais", nil)

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

local SecaoAbracos = AbaAbracos:CreateSection("Abraços", true)

local BotaoAbraco1R6 = AbaAbracos:CreateButton({
   Name = "Abraços 1 R6",
   Callback = function()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Hug-Gui-R6-17818"))()
   end,
})

local BotaoAbraco2R6 = AbaAbracos:CreateButton({
   Name = "Abraços 2 R6",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/JSFKGBASDJKHIOAFHDGHIUODSGBJKLFGDKSB/fe/refs/heads/main/FEHUGG"))()
   end,
})

local SecaoDesastres = AbaDesastresNaturais:CreateSection("Funções", true)

local BotaoTroll1Player = AbaDesastresNaturais:CreateButton({
   Name = "Troll 1 Player",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/main/BringFlingPlayers"))("More Scripts: t.me/arceusxscripts")
   end,
})

local BotaoSuperRingV6 = AbaDesastresNaturais:CreateButton({
   Name = "Super Ring V6",
   Callback = function()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Super-ring-Parts-V6-28581"))()
   end,
})

rconsoleprint("Project Metra carregado com sucesso!\n")

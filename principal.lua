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
local AbaAnimacoes = Window:CreateTab("Animações", nil)
local AbaAbracos = Window:CreateTab("Abraços", nil)
local AbaDesastresNaturais = Window:CreateTab("Desastres Naturais", nil)
local AbaEmotes = Window:CreateTab("Emotes", nil)
local AbaGhostHub = Window:CreateTab("GhostHub", nil)
local AbaHitbox = Window:CreateTab("Hitbox", nil)

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

local BotaoPuloInfinito = AbaScripts:CreateButton({
   Name = "Pulo Infinito",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/Fkz232/Project-Metra/refs/heads/main/Infjump.lua'))()
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

local SecaoAnimacoes = AbaAnimacoes:CreateSection("Animações", true)

local BotaoSeraphicBlade = AbaAnimacoes:CreateButton({
   Name = "Seraphic Blade",
   Callback = function()
      loadstring(game:HttpGet('https://pastefy.app/59mJGQGe/raw'))()
   end,
})

local BotaoEnergize = AbaAnimacoes:CreateButton({
   Name = "Energize",
   Callback = function()
      loadstring(game:HttpGet(('https://pastebin.com/raw/PQfaN03z'),true))()
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

local SecaoEmotes = AbaEmotes:CreateSection("Emotes", true)

local BotaoEmotesR15 = AbaEmotes:CreateButton({
   Name = "Emotes R15",
   Callback = function()
      loadstring(game:HttpGetAsync("https://gist.githubusercontent.com/RedZenXYZ/3da6af1961efa275de6c3c2a6dbace03/raw/bb027f99cec0ea48ef9c5eabfb9116ddff20633d/FE%2520Emotes%2520Gui"))()
   end,
})

local SecaoGhostHub = AbaGhostHub:CreateSection("Funções", true)

local BotaoGhostHub = AbaGhostHub:CreateButton({
   Name = "GhostHub",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/GhostHub'))()
   end,
})

local SecaoHitbox = AbaHitbox:CreateSection("Hitbox", true)

local CaixaHitbox = AbaHitbox:CreateInput({
   Name = "Tamanho da Hitbox",
   PlaceholderText = "Digite um número",
   Numeric = true,
   Callback = function(Value)
      getgenv().HitboxSize = tonumber(Value) or 5
   end,
})

local BotaoAtivarHitbox = AbaHitbox:CreateButton({
   Name = "Ativar Hitbox",
   Callback = function()
      if not getgenv().HitboxSize then return end

      for _, player in pairs(game:GetService("Players"):GetPlayers()) do
         if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
               character.HumanoidRootPart.Size = Vector3.new(getgenv().HitboxSize, getgenv().HitboxSize, getgenv().HitboxSize)
               character.HumanoidRootPart.Transparency = 0.5
               character.HumanoidRootPart.Material = Enum.Material.ForceField

               if not character:FindFirstChild("HitboxHighlight") then
                  local highlight = Instance.new("Highlight")
                  highlight.Name = "HitboxHighlight"
                  highlight.Parent = character
                  highlight.Adornee = character
                  highlight.FillColor = Color3.fromRGB(255, 0, 0)
                  highlight.FillTransparency = 0.5
                  highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                  highlight.OutlineTransparency = 0
               end
            end
         end
      end
   end,
})

local BotaoHitboxRGB = AbaHitbox:CreateButton({
   Name = "Hitbox RGB",
   Callback = function()
      if not getgenv().HitboxSize then return end
      local colors = {Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 255)}
      local index = 1
      while true do
         for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
               local character = player.Character
               if character and character:FindFirstChild("HumanoidRootPart") then
                  local highlight = character:FindFirstChild("HitboxHighlight")
                  if highlight then
                     highlight.FillColor = colors[index]
                     index = index % #colors + 1
                  end
               end
            end
         end
         wait(0.5)
      end
   end,
})

rconsoleprint("Project Metra carregado com sucesso!\n")

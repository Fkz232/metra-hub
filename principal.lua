local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    warn("Falha ao carregar Rayfield!")
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

loadstring(game:HttpGet("https://raw.githubusercontent.com/seu-usuario/Project-Metra/main/principal/ScriptFuncoes.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/seu-usuario/Project-Metra/main/principal/AbacosFuncoes.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/seu-usuario/Project-Metra/main/principal/DesastresNaturaisFuncoes.lua"))()

local AbaDesastresNaturais = Window:CreateTab("Desastres Naturais", nil)

local BotaoTroll1Player = AbaDesastresNaturais:CreateButton({
   Name = "Troll 1 player",
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

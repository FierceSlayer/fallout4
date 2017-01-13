;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
Scriptname AutoLoot:Fragments:Terminals:TERM_dubhAutoLootMenuMain_010026E1 Extends Terminal Hidden

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
Int i = 0
While i < dubhAutoLootPerks.GetSize()
	Perk kPerk = dubhAutoLootPerks.GetAt(i) as Perk

	If Player.HasPerk(kPerk)
		Player.RemovePerk(kPerk)
	EndIf

	i += 1
EndWhile
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property Player Auto
Formlist Property dubhAutoLootPerks Auto

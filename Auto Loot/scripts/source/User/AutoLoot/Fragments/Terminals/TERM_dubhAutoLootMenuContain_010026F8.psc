;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
ScriptName AutoLoot:Fragments:Terminals:TERM_dubhAutoLootMenuContain_010026F8 Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
SetContainer(19)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
SetContainer(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
SetContainer(9)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
SetContainer(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_09
Function Fragment_Terminal_09(ObjectReference akTerminalRef)
;BEGIN CODE
SetContainer(23)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_11
Function Fragment_Terminal_11(ObjectReference akTerminalRef)
;BEGIN CODE
SetContainer(22)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Formlist Property dubhAutoLootGlobals Auto Const

Function SetContainer(Float afContainerID)
	Int i = 0
	While i < 10
		GlobalVariable kGlobal = dubhAutoLootGlobals.GetAt(i) as GlobalVariable
		kGlobal.SetValue(afContainerID)
		i += 1
	EndWhile
EndFunction
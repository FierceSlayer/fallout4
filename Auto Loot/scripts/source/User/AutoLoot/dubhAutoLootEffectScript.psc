ScriptName AutoLoot:dubhAutoLootEffectScript Extends ActiveMagicEffect

; -----------------------------------------------------------------------------
; VARIABLES
; -----------------------------------------------------------------------------

ObjectReference[] LootArray = None

; -----------------------------------------------------------------------------
; EVENTS
; -----------------------------------------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
	StartTimer(dubhAutoLootDelay.GetValueInt(), dubhAutoLootTimer)
EndEvent

Event OnTimer(Int aiTimerID)
	; do not run if the player no longer has the perk
	If Player.HasPerk(dubhAutoLootPerk)

		; do not run if the location cannot be auto looted
		If CanAutoLootLocation()

			If !Utility.IsInMenuMode() && Game.IsMovementControlsEnabled()
				LootArray = Player.FindAllReferencesOfType(dubhAutoLootFilter, dubhAutoLootRadius.GetValue())
				LootArray = FilterLootArray(LootArray)

				Log("OnTimer", "LootArray: " + LootArray)

				If (LootArray as Bool)
					If LootArray.Length > 0
						Int i = 0
						Bool bBreak = False
						While (i < LootArray.Length) && !bBreak

							If !Player.HasPerk(dubhAutoLootPerk) || Utility.IsInMenuMode() || !Game.IsMovementControlsEnabled()
								bBreak = True
							EndIf

							If !bBreak
								ObjectReference objLoot = LootArray[i]

								If objLoot != None
									; loot object if the item is not owned
									If (dubhAutoLootTheftAllowed.GetValue() == False) && (Player.WouldBeStealing(objLoot) == False)
										If LootObject(objLoot)
											If dubhAutoLootToggleDelayOnLoot.GetValue() == True
												Utility.Wait(dubhAutoLootDelay.GetValueInt())
											EndIf
										EndIf
									ElseIf dubhAutoLootTheftAllowed.GetValue() == True
										; remove ownership if option enabled
										If dubhAutoLootTheftAlarm.GetValue() == False
											objLoot.SetActorRefOwner(Player)
										EndIf

										; loot object if the item is owned or unowned
										If LootObject(objLoot)
											If dubhAutoLootToggleDelayOnLoot.GetValue() == True
												Utility.Wait(dubhAutoLootDelay.GetValueInt())
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf

							i += 1
						EndWhile
					EndIf
				EndIf

				LootArray.Clear()
			EndIf

		EndIf

		StartTimer(dubhAutoLootDelay.GetValueInt(), dubhAutoLootTimer)
	EndIf
EndEvent

; -----------------------------------------------------------------------------
; PROPERTIES
; -----------------------------------------------------------------------------

; Misc.
Int Property dubhAutoLootTimer Auto

; Globals
GlobalVariable Property dubhAutoLootContainer Auto
GlobalVariable Property dubhAutoLootDelay Auto
GlobalVariable Property dubhAutoLootPlayerOnly Auto
GlobalVariable Property dubhAutoLootRadius Auto
GlobalVariable Property dubhAutoLootTheftAllowed Auto
GlobalVariable Property dubhAutoLootTheftAlarm Auto
GlobalVariable Property dubhAutoLootTheftOnlyOwned Auto
GlobalVariable Property dubhAutoLootToggleDelayOnLoot Auto
GlobalVariable Property dubhAutoLootWorkshopLooting Auto

; Formlists
Formlist Property dubhAutoLootFilter Auto
Formlist Property dubhAutoLootLocations Auto
Formlist Property dubhAutoLootSettlements Auto

; Perk
Perk Property dubhAutoLootPerk Auto

; Actor
Actor Property Player Auto
Actor Property dubhAutoLootDummyActor Auto

; -----------------------------------------------------------------------------
; FUNCTIONS
; -----------------------------------------------------------------------------

; Log

Function Log(String asFunction = "", String asMessage = "") DebugOnly
	Debug.TraceSelf(Self, asFunction, asMessage)
EndFunction

; Filter Loot Array

ObjectReference[] Function FilterLootArray(ObjectReference[] akArray)
	ObjectReference[] kResult = new ObjectReference[0]

	If (akArray as Bool) && (akArray != None)
		Int i = 0
		While i < akArray.Length
			ObjectReference kItem = akArray[i]

			If kItem != None
				ObjectReference kContainer = kItem.GetContainer()

				If (kContainer == None) && (kContainer != Player)
					If kItem.Is3DLoaded() && !kItem.IsDisabled() && !kItem.IsDeleted() && !kItem.IsDestroyed() ; for flora
						If dubhAutoLootTheftOnlyOwned.GetValue() == False
								kResult.Add(kItem, 1)
						Else
							If Player.WouldBeStealing(kItem) == True
								kResult.Add(kItem, 1)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf

			i += 1
		EndWhile
	EndIf

	Return kResult
EndFunction

; Returns true if loot in location can be processed

Bool Function CanAutoLootLocation()
	If dubhAutoLootWorkshopLooting.GetValue() == False
		Form kLocation = Game.GetPlayer().GetCurrentLocation() as Form
		If dubhAutoLootLocations.HasForm(kLocation)
			Return False
		EndIf
	EndIf

	Return True
EndFunction

; Loot Object

Bool Function LootObject(ObjectReference objLoot)
	If (objLoot as Bool)
		; do not run if the player no longer has the perk
		If Player.HasPerk(dubhAutoLootPerk)
			Bool bPlayerOnly = dubhAutoLootPlayerOnly.GetValue() as Bool
			Int iContainer = dubhAutoLootContainer.GetValueInt() as Int

			; determine where to send loot
			ObjectReference kContainer = None
			If (iContainer == 0) || (bPlayerOnly == True)
				kContainer = Player
			Else
				kContainer = (dubhAutoLootSettlements.GetAt(iContainer) as WorkshopScript) as ObjectReference
			EndIf

			If kContainer != None
				; handle non-player object as container
				; force dubhAutoLootDummyActor to activate the objLoot reference
				If kContainer != Player
					If objLoot.Activate(dubhAutoLootDummyActor, False)
						dubhAutoLootDummyActor.RemoveAllItems(kContainer, dubhAutoLootTheftAlarm.GetValue())
						Return True
					EndIf
				; handle player object as container
				Else
					If objLoot.Activate(Player, False)
						Log("LootObject", "objLoot: " + objLoot)
						Return True
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	Return False
EndFunction
Scriptname IWAWQuest extends Quest  

; AppUtil

int Function GetVersion()
	return 20210621
EndFunction

Function Log(String msg)
	if (Config.debugLogFlag)
		debug.trace("[iwaw] " + msg)
	endif
EndFunction

int Function GetArousal(Actor act)
	return act.GetFactionRank(sla_Arousal)
EndFunction

;---------------------------------------------

iwant_widgets Property iWidgets Auto
IWAWConfig Property Config Auto

Event OnInit()
	self.Register()
EndEvent

Function Register()
	RegisterForModEvent("iWantWidgetsReset", "OniWantWidgetsReset")
	RegisterForModEvent("HookOrgasmEnd", "OnSexLabSexEnd")
	RegisterForModevent("sla_UpdateComplete", "OnArousalComputed")
EndFunction

Event OniWantWidgetsReset(String eventName, String strArg, Float numArg, Form sender)
	If eventName == "iWantWidgetsReset"
		iWidgets = sender As iwant_widgets
		; self.Rerender()
	EndIf
EndEvent

Event OnSexLabSexEnd(int tid, bool hasPlayer)
	if (hasPlayer)
		Utility.Wait(2.0)
		self.Rerender()
	endif
EndEvent

Event OnArousalComputed(string eventName, string argString, float argNum, form sender)
	Utility.Wait(1.0)
	self.Rerender()
EndEvent

Function InitWidget(bool rendering = false)
	if (WidgetID)
		iWidgets.destroy(WidgetID)
	endif

	Utility.Wait(3.0)
	self.Log("Init widget")
	WidgetID = iWidgets.loadLibraryWidget("arousal40")
	iWidgets.setPos(WidgetID, Config.horizontal, Config.vertical)
	iWidgets.setZoom(WidgetID, 80, 80)
	iWidgets.setVisible(WidgetID)
	
	if !(rendering)
		self.Rerender()
	endif
EndFunction

Function DestoryWidget()
	if (WidgetID)
		iWidgets.destroy(WidgetID)
	endif
EndFunction

Function Rerender()
	if !(WidgetID)
		self.InitWidget(true)
	endif
	
	int arousal = self.GetArousal(PlayerReference.GetActorRef())
	
	if (Config.colorChange)
		if (arousal < 36)
			iWidgets.setRGB(WidgetID, 255, 255, 255)
		elseif (arousal < 71)
			iWidgets.setRGB(WidgetID, 255, 255, 70)
		else
			iWidgets.setRGB(WidgetID, 255, 50, 90)
		endif
	endif
	
	int trans = 80
	
	if (Config.transChange)
		trans = arousal - 20
		if (trans < 0)
			trans = 0
		endif
	endif
	
	iWidgets.setTransparency(WidgetID, trans)
	
EndFunction


SexLabFramework Property SexLab  Auto
Faction Property sla_Arousal  Auto  

ReferenceAlias Property PlayerReference  Auto  
Int Property WidgetID Auto 

Scriptname IWAWConfig extends ski_configbase  

bool Property modEnabled = true Auto
bool Property debugLogFlag = false Auto

bool Property colorChange = true Auto
bool Property transChange = true Auto

int Property horizontal = 1245 Auto
int Property vertical = 560 Auto

int modEnabledID 
int debugLogFlagID

int configLoadID 
int configSaveID

int colorChangeID
int transChangeID

int horizontalID
int verticalID

bool mustRerender = false
string configFile = "../iWantArousalWidgets/config.json"

IWAWQuest Property IWAW Auto


int Function GetVersion()
	return IWAW.GetVersion()
EndFunction 


Event OnVersionUpdate(int a_version)
	if (CurrentVersion == 0) ; new game
		debug.notification(self.ModName + " [" + a_version + "] installed.")
	elseif (a_version != CurrentVersion)
		OnConfigInit()
		if (self.modEnabled)
			(IWantArousalWidgetsInit as IWAWInit).Reboot()
			debug.notification(self.ModName + " updated to [" + a_version + "], rebooted.")
		else
			debug.notification(self.ModName + " updated to [" + a_version + "], but still disabled.")
		endif
	endif
EndEvent


Event OnConfigInit()
	Pages = new string[1]
	Pages[0] = "$IWAWConfig"
EndEvent

Event OnPageReset(string page)
	if (page == "" || page == "$IWAWConfig")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		AddHeaderOption("$IWAWPosition")
		horizontalID = AddSliderOption("$IWAWHorizontal", horizontal)
		verticalID = AddSliderOption("$IWAWVertical", vertical)
		
		AddEmptyOption()
		
		AddHeaderOption("$IWAWChangeStyle")
		colorChangeID = AddToggleOption("$IWAWColorChange", colorChange)
		transChangeID = AddToggleOption("$IWAWTransChange", transChange)
		
		SetCursorPosition(1)
		
		AddHeaderOption("$IWAWProfile")
		configSaveID = AddTextOption("$IWAWConfigSave", "$IWAWDoIt")
		configLoadID = AddTextOption("$IWAWConfigLoad", "")
		
		AddHeaderOption("$IWAWEtc")
		modEnabledID = AddToggleOption("$IWAWModEnabled", modEnabled)
		debugLogFlagID = AddToggleOption("$IWAWDebugLogFlag", debugLogFlag)
	endif
EndEvent

Event OnOptionHighlight(int option)
	if (option == colorChangeID)
		SetInfoText("$IWAWColorChangeInfo")
	elseif (option == transChangeID)
		SetInfoText("$IWAWTransChangeInfo")
	elseif (option == configSaveID)
		SetInfoText("$IWAWConfigSaveInfo")
	elseif (option == configLoadID)
		SetInfoText("$IWAWConfigLoadInfo")
	endif
EndEvent

Event OnOptionSelect(int option)
	if (option == colorChangeID)
		colorChange = !colorChange
		SetToggleOptionValue(option, colorChange)
		mustRerender = true
	elseif (option == transChangeID)
		transChange = !transChange
		SetToggleOptionValue(option, transChange)
		mustRerender = true
	
	elseif (option == configSaveID)
		self.saveConfig()
		SetTextOptionValue(option, "$IWAWDone")
	elseif (option == configLoadID)
		self.loadConfig()
		SetTextOptionValue(option, "$IWAWDone")
	
	elseif	(option == modEnabledID)
		modEnabled = !modEnabled
		SetToggleOptionValue(option, modEnabled)
	elseif (option == debugLogFlagID)
		debugLogFlag = !debugLogFlag
		SetToggleOptionValue(option, debugLogFlag)
	endif
EndEvent

Event OnOptionSliderOpen(int option)
	if (option == verticalID)
		SetSliderDialogStartValue(vertical)
		SetSliderDialogDefaultValue(vertical)
	
		SetSliderDialogRange(0, 720)
		SetSliderDialogInterval(5)
	elseif (option == horizontalID)
		SetSliderDialogStartValue(horizontal)
		SetSliderDialogDefaultValue(horizontal)
	
		SetSliderDialogRange(0, 1280)
		SetSliderDialogInterval(5)
	endif
EndEvent

Event OnOptionSliderAccept(int option, float value)
	if (option == verticalID)
		vertical = value as int
		SetSliderOptionValue(option, vertical)
		mustRerender = true
	elseif (option == horizontalID)
		horizontal = value as int
		SetSliderOptionValue(option, horizontal)
		mustRerender = true
	endif
EndEvent

Event OnConfigClose()
	IWAWInit initiscript = IWantArousalWidgetsInit as IWAWInit
	
	if (modEnabled)
		initiscript.SmartBoot()
		mustRerender = true
	else
		initiscript.Shutdown()
		IWAW.DestoryWidget()
	endif
	
	if (mustRerender)
		mustRerender = false
		IWAW.InitWidget()
	endif
EndEvent

Function saveConfig()
	JsonUtil.SetIntValue(configFile, "modEnabled", modEnabled as int)
	JsonUtil.SetIntValue(configFile, "debugLogFlag", debugLogFlag as int)
	
	JsonUtil.SetIntValue(configFile, "colorChange", colorChange as int)
	JsonUtil.SetIntValue(configFile, "transChange", transChange as int)
	
	JsonUtil.SetIntValue(configFile, "horizontal", horizontal)
	JsonUtil.SetIntValue(configFile, "vertical", vertical)
	
	JsonUtil.Save(configFile)
EndFunction

Function loadConfig()
	modEnabled = JsonUtil.GetIntValue(configFile, "modEnabled")
	debugLogFlag = JsonUtil.GetIntValue(configFile, "debugLogFlag")
	
	colorChange = JsonUtil.GetIntValue(configFile, "colorChange")
	transChange = JsonUtil.GetIntValue(configFile, "transChange")
	
	horizontal = JsonUtil.GetIntValue(configFile, "horizontal")
	vertical = JsonUtil.GetIntValue(configFile, "vertical")
EndFunction


Quest Property IWantArousalWidgetsInit Auto

Scriptname IWAWInit extends Quest

Event OnInit()
	if !(IWAW.IsRunning())
		IWAW.Start()
	endif
	; self.Stop()
	; this is the initializer AND Quest Reload Manager
EndEvent

Function Reboot()
	self.Shutdown()
	IWAW.Start()
EndFunction

Function SmartBoot()
	if !(IWAW.IsRunning())
		IWAW.Start()
	endif
EndFunction

Function Shutdown()
	if (IWAW.IsRunning())
		IWAW.Stop()
	endif
EndFunction

Quest Property IWAW  Auto  

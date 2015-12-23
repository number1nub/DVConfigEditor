#SingleInstance, Force

global settings := new XML("settings", A_AppData "\TerraVici Drilling Solutions\DVConfigEditor\settings.xml")
	 , dvPath   := A_ScriptDir "\testing"


;~ ChartEdit()
;~ SelectConfig()
WindowEdit("TestFile_config")
;~ ConfigTreeDisplay("TestFile_config", "Tool Data")
return


#Include <ChartEdit>
#Include <Class DVConfig>
#Include <Class XML>
#Include <ConfigTreeDisplay>
#Include <DVConfigGUI>
#Include <Gui>
#Include <m>
#Include <SelectConfig>
#Include <sn>
#Include <ssn>
#Include <ssnTxt>
#Include <WindowEdit>
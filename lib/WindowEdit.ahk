WindowEdit(configName, win:="") {
	static cfg, CurTitle, ChartList, selTitle:="", title:="DataViewer Config Window Editor"
	
	;~ config := new XML("Windows", dvPath "\" RegExReplace(configName, "i)\.xml$") ".xml")
	
	cfg := new DVConfig(configName)
	
	Gui, WinEdit:Default
	Gui, Font, s10 bold, Arial	
	Gui, Add, Text, x5 y10 Section, Windows
	Gui, Font, norm
	Gui, Add, ListView, y+5 w300 h300 grid -hdr AltSubmit gWinList_Click, Windows
	Gui, Font, bold
	Gui, Add, GroupBox, x+5 ys w450 h330 Section, 
	Gui, Add, Text, xs+10 ys+20, Title
	Gui, Font, norm
	Gui, Add, Edit, y+5 w420 h30 -Multi vCurTitle hwndhCurTitle, %curTitle%
	Gui, Font, bold
	Gui, Add, Text, y+20, Charts
	Gui, Font, norm
	Gui, Add, ListBox, y+5 w420 h190 vChartList hwndhChartList, %chartList%
	Gui, Add, Button, xs+10 y+3 w75 h30 +Disabled, &Add
	Gui, Add, Button, x+3 w75 h30 gbtnChartEdit, &Edit
	Gui, Add, Button, x+3 w75 h30 +Disabled, &Remove
	Gui, Add, Button, x210 y345 w105 h35, &Save
	Gui, Add, Button, x320 y345 w105 h35, &Cancel
	
	for c, v in cfg.GetWindows()
		LV_Add("", v)
	
	Gui, Show,, %title%
	Return
	
	WinList_Click:
	if (A_GuiEvent != "Normal")
		return
	if (!LV_GetText(selTitle, LV_GetNext()))
		return
	ControlSetText, Edit1, %selTitle%
	cList := cfg.GetCharts(selTitle, 1)
	GuiControl,, ListBox1, |%cList%
	return
	
	btnChartEdit:
	Gui, Submit, Nohide
	if (!ChartList)
		return
	ChartEdit(cfg, selTitle, ChartList)
	return
	
	WinEditGuiClose:
	 ;#[TODO: Check unsaved changes]
	Gui, WinEdit:Destroy
	;~ return
	ExitApp
}
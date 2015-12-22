ChartEdit(config, win, chart) {
	static title:="DataViewer Configuration Editor - Chart Editor"
	
	cfg := IsObject(config) ? config : new DVConfig(configName)
	
	Gui, Charts:Default
	Gui, Font, s10 bold, Arial
	Gui, Margin, 5, 5
	Gui, Add, GroupBox, x12 y8 w592 h220 Section, Lines
	Gui, Font, norm
	Gui, Add, ListView, xs+15 ys+25 w567 h156, Line
	Gui, Add, Button, x320 y+2 w88 h26, &New
	Gui, Add, Button, x+5 w88 h26, &Edit...
	Gui, Add, Button, x+5 w88 h26, &Delete
	
	for c, v in cfg.GetLines(win, chart)
		LV_Add("", v)
	
	Gui, Font, bold
	Gui, Add, GroupBox, x10 y235 w595 h215 Section, Lines
	Gui, Font, norm
	Gui, Add, ListView, xs+15 ys+25 w567 h156, 
	Gui, Add, Button, x320 y+2 w88 h26, Ne&w
	Gui, Add, Button, x+5 w88 h26, Ed&it...
	Gui, Add, Button, x+5 w88 h26, De&lete
	
	Gui, Add, Button, x411 y+25w95 h30, &Save
	Gui, Add, Button, x+5 w95 h30, &Cancel
	
	Gui, Show, Center w616 h501, %title%
	Return
	
	ChartsGuiClose:
	Gui, Charts:Destroy
	return
}
SelectConfig(fTypesPath:="") {
	static filetypes, configList, title:="DataViewer Config Editor"
	
	filetypes := new XML("FileTypes", A_ScriptDir "\testing\dataviewer_filetypes.xml")
	
	Gui, Configs:Default
	Gui, Font, s12 bold, Arial
	Gui, Margin, 0, 0
	
	Gui, Add, Text, +BackgroundTrans, Available Configurations:
	Gui, Font, s10 norm
	Gui, Add, ListView, y+5 w450 h450 Grid NoSort vconfigList hwndhConfigList, Name|Delimiter|Header Row|Data Row
	Gui, Add, Button, y+0 wp hwndbtnAdd, &Add
	Gui, Add, Button, y+0 wp hwndbtnEdit, &Edit
	Gui, Add, Button, y+0 wp hwndbtnDelet, &Delete
	
	ftypes:=[]
	while cfg:=filetypes.sn("//Name").item(A_Index-1)
		i:=A_Index-1, LV_Add("", cfg.text, ssnTxt(filetypes, i, "Delimiter"), ssnTxt(filetypes, i,"ColumnRow"), ssnTxt(filetypes, i, "FirstDataRow"))
	LV_ModifyCol(1, "Auto")
	
	Gui, Show,, %title%
	return
	
	
	ButtonAdd:
	m("Under Construction")
	return
	
	
	ButtonEdit:
	if (!rw:=LV_GetNext()) {
		m("You must select an item!", "title:TheCloser Ignore Windows", "!")
		return
	}
	LV_GetText(editWin, rw)
	InputBox, newWin, Edit Ignore Window, Window title/class:,,, 140,,,,, %editWin%
	if (ErrorLevel || !newWin || Trim(newWin)=Trim(editWin))
		return
	LV_Modify(rw,, newWin)
	testConfig.ssn("//disablelist/win[text()='" editWin "']").text := newWin
	testConfig.save(1)
	ClassChange:=1
	return
	
	
	ButtonDelete:
	
	return
	
	
	ConfigsGuiClose:
	 ;#[TODO: Check unsaved changes]
	Gui, Configs:Destroy
	return
}
#SingleInstance, Force

global settings := new XML("settings", A_AppData "\TerraVici Drilling Solutions\DVConfigEditor\settings.xml")
	 , dvPath   := A_ScriptDir "\testing"


;~ ChartEdit()
;~ SelectConfig()
WindowEdit("TestFile_config")
;~ ConfigTreeDisplay("TestFile_config", "Tool Data")
return


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
Class DVConfig
{
	__New(fname) {
		tmpObj := new XML("Windows", fPath:=(dvPath "\" RegExReplace(fName, "i)\.xml$") ".xml"))
		if (!tmpObj.fileExists) {
			m("Invalid config file/path","!"), tmpObj:=""
			return this:=""
		}
		this.xml:=tmpObj, tmpObj:=""
		SplitPath, fPath,,,, nne
		this.File := fPath
		this.Name := nne
	}
	
	File[] {
		get {
			return this._file
		}
		set {
			return
		}
	}
	
	Name[] {
		get {
			return this._name
		}
		set {
			return
		}
	}
	
	GetWindows(list:="") {
		tmpObj:=[]
		while, win:=this.xml.sn("//Windows/Window").Item[A_Index-1], ea:=xml.ea(win)
			tmpObj.Push(ea.title)
		return (list ? this.ToList(tmpObj):tmpObj)
	}
	
	GetCharts(winTitle, list:="") {
		tmpObj := list ? "" : []
		while, chart:=this.xml.sn("//Window[@Title='" winTitle "']/Charts/Chart").Item[A_Index-1], ea:=xml.ea(chart)
			list ? (tmpObj.=(tmpObj ? "|":"") ea.name) : tmpObj.Push(ea.Name)
		return tmpObj
	}
	
	GetLines(winTitle, chartTitle, list:="") {
		tmpObj := list ? "" : []
		while, line:=this.xml.sn("//Window[@Title='" winTitle "']/Charts/Chart[@Name='" chartTitle "']/Y-Axis/Line/Name").Item[A_Index-1]
			list ? (tmpObj.=(tmpObj ? "|":"") line.text) : (tmpObj.Push(line.text))
		return tmpObj
	}
	
	ToList(obj, delim:="|") {
		for c, v in obj
			list .= (list ? delim:"") v
		return Trim(list, delim " `t")
	}
}
Class XML
{
	__New(param*) {
		root:=param.1, file:=param.2?param.2:root ".xml"
		temp:=ComObjCreate("MSXML2.DOMDocument"), temp.setProperty("SelectionLanguage","XPath")
		this.xml:=temp, this.fileExists:=false
		if (FileExist(file)) {
			FileRead, info, %file%
			if (!info) {
				this.xml := this.create(temp, root)
				FileDelete, %file%
			}
			else
				this.fileExists:=true, temp.loadxml(info), this.xml:=temp
		}
		else
			this.xml := this.Create(temp, root)
		this.file := file
	}
	
	__Get(x:="") {
		return this.xml.xml
	}
	
	Add(path, att:="", text:="", dup:=0, list:="") {
		p:="/",dup1:=this.ssn("//" path)?1:0,next:=this.ssn("//" path),last:=SubStr(path,InStr(path,"/",0,0)+1)
		if (!next.xml) {
			next := this.ssn("//*")
			Loop, Parse, path, /
				last:=A_LoopField, p.="/" last, next:=this.ssn(p)?this.ssn(p):next.appendchild(this.xml.createElement(last))
		}
		if (dup && dup1)
			next := next.parentnode.appendchild(this.xml.createElement(last))
		for a, b in att
			next.SetAttribute(a, b)
		for a, b in StrSplit(list, ",")
			next.SetAttribute(b, att[b])
		if (text)
			next.text := text
		return next
	}
	
	Create(doc, root) {
		return doc.AppendChild(this.xml.createElement(root)).parentnode
	}
	
	EA(path) {
		list:=[]
		if (nodes:=path.nodename)
			nodes := path.SelectNodes("@*")
		else if (path.text)
			nodes := this.sn("//*[text()='" path.text "']/@*")
		else if (!IsObject(path))
			nodes := this.sn(path "/@*")
		else
			for a, b in path
				nodes := this.sn("//*[@" a "='" b "']/@*")
		while, (n:=nodes.item(A_Index-1))
			list[n.nodename] := n.text
		return list
	}
	
	FF(info*) {
		doc := info.1.NodeName ? info.1 : this.xml
		if (info.1.NodeName)
			node:=info.2, find:=info.3
		else
			node:=info.1, find:=info.2
		if (InStr(find, "'"))
			return doc.selectSingleNode(node "[.=concat('" RegExReplace(find,"'","'," Chr(34) "'" Chr(34) ",'") "')]/..")
		else
			return doc.selectSingleNode(node "[.='" find "']/..")
	}
	
	Find(info) {
		if (info.att.1 && info.text) {
			MsgBox 4144,, You can only search by either the attribute or the text, not both
			return
		}
		search := info.path ? "//" info.path : "//*"
		for a, b in info.att
			search .= "[@" a "='" b "']"
		if (info.text)
			search .= "[text()='" info.text "']"
		return this.ssn(search)
	}
	
	Get(path, default:="") {
		return ((ptxt:=this.ssn(path).text) ? ptxt : default)
	}
	
	Lang(info) {
		info:=!info?"XPath":"XSLPattern", this.xml.temp.setProperty("SelectionLanguage", info)
	}
	
	Remove(rem) {
		if (!IsObject(rem))
			rem := this.ssn(rem)
		rem.parentNode.removeChild(rem)
	}
	
	Save(x*) {
		if (x.1=1)
			this.Transform()
		filename := this.file ? this.file : x.1.1
		SplitPath, filename,, fDir
		if (!FileExist(fDir))
			FileCreateDir, %fDir%
		file:=fileopen(filename, "rw", "Utf-8"), file.seek(0), file.write(this[]), file.length(file.position)
	}
	
	Search(node, find, return:="") {
		found:=this.xml.SelectNodes(node "[contains(.,'" RegExReplace(find,"&","')][contains(.,'") "')]")
		while,ff:=found.item(a_index-1)
			if (ff.text = find) {
				if (return)
					return ff.SelectSingleNode("../" return)
				return ff.SelectSingleNode("..")
			}
	}
	
	SN(node) {
		return this.xml.SelectNodes(node)
	}
	
	SSN(node) {
		return this.xml.SelectSingleNode(node)
	}
	
	Transform() {
		static
		if (!IsObject(xsl)) {
			xsl := ComObjCreate("MSXML2.DOMDocument")
			style=
			(
			<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
			<xsl:template match="@*|node()">
				<xsl:copy>
					<xsl:apply-templates select="@*|node()"/>
					<xsl:for-each select="@*">
						<xsl:text>
						</xsl:text>
					</xsl:for-each>
				</xsl:copy>
			</xsl:template>
			</xsl:stylesheet>
			)
			xsl.loadXML(style), style:=null
		}
		this.xml.transformNodeToObject(xsl, this.xml)
	}
	
	Under(under, node:="", att:="", text:="", list:="") {
		if (!node) {
			node:=under.node, att:=under.att, list:=under.list, under:=under.under
		}
		new := under.appendchild(this.xml.createElement(node))
		for a, b in att
			new.SetAttribute(a, b)
		for a, b in StrSplit(list, ",")
			new.SetAttribute(b, att[b])
		if (text)
			new.text := text
		return new
	}
	
	Unique(info) {
		if (info.check && info.text)
			return
		if (info.under) {
			if (info.check)
				find := info.under.selectSingleNode("*[@" info.check "='" info.att[info.check] "']")
			if (info.Text)
				find := this.ssn(info.under,"*[text()='" info.text "']")
			if (!find)
				find := this.under(info.under,info.path,info.att)
			for a, b in info.att
				find.SetAttribute(a, b)
		}
		else {
			if (info.check)
				find := this.ssn("//" info.path "[@" info.check "='" info.att[info.check] "']")
			else if (info.text)
				find := this.ssn("//" info.path "[text()='" info.text "']")
			if (!find)
				find := this.add({path:info.path,att:info.att,dup:1})
			for a, b in info.att
				find.SetAttribute(a,b)
		}
		if (info.text)
			find.text := info.text
		return find
	}
}
ConfigTreeDisplay(cfgName, winTitle:="") {
	static config
	
	config := new XML("Windows", dvPath "\" RegExReplace(cfgName, "i)\.xml$") ".xml")
	
	Gui, Tree:Default
	Gui, Add, TreeView, -lines -buttons h750
	
	while, ll:=config.sn("//*").item[A_Index-1], ea:=xml.ea(ll){
		info:="", (ll.nodeName="Window"?(win:=StrReplace(ea.Title," - TerraVici DataViewer")=StrReplace(winTitle," - TerraVici DataViewer")?1:0):null)
		if (!win && winTitle)
			continue
		for a, b in ea
			info.=": " b
		
		;Only add nodes relevant to config changes
		if (ll.nodeName != "Window" && ll.nodeName != "Chart" && ll.nodeName != "Line" && ll.ParentNode.nodeName != "Line")
			continue
		
		;Add item to TreeView & save its ID in its XML 'tv' attribute
		node:=ll,tv:=0
		while,node{
			node:=node.ParentNode
			if(tv:=xml.ea(node).tv)
				break
		}
		ll.SetAttribute("tv", tv:=TV_Add(ll.NodeName info, tv, "Expand"))
		
		;Add a sub-item for the line properties
		if (!ssn(ll, "descendant::*") && ll.text)
		;~ TV_Modify(tv,, "Line: " ll.text)
			TV_Add(ll.text, tv, "Expand")
	}
	
	Gui, Show,, Config Tree Display
	return
	
	TreeGuiClose:
	TreeGuiEscape:
	all := config.sn("//*[@tv]")
	while, aa:=all.item[A_Index-1]
		aa.RemoveAttribute("tv")
	Gui, 1:Destroy
	return
}
#NoEnv
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1

Gui Main:Default
Gui Add, Text, x10 y20 w70 h20, Windows
Gui Add, Text, x315 y20 w28 h16, Title
Gui Add, Edit, vwinTitle x315 y40 w424 h29
Gui Add, Text, x315 y80 w40 h16, Charts
Gui Add, Button, gChart_Action x677 y96 w65 h30, &Add
Gui Add, Button, x677 y127 w65 h30, &Edit
Gui Add, Button, x677 y158 w65 h30, &Remove
Gui Add, Button, x283 y600 w90 h35, &Save
Gui Add, Button, gGuiClose x377 y600 w90 h35, &Cancel
Gui Add, ListView, gLine_Click x14 y277 w280 h305, #|Data Column|Legend Name
Gui Add, GroupBox, x5 y253 w735 h340, Lines
Gui Add, Text, x303 y276 w110 h20, Column Name
Gui Add, Edit, vlineName x303 y296 w210 h25
Gui Add, Text, x303 y331 w200 h20, Custom Legend Text (optional)
Gui Add, Edit, vlineLegend x303 y351 w210 h25
Gui Add, Text, x303 y386 w110 h20, Series Type
Gui Add, Edit, vlineColor x303 y461 w210 h25
Gui Add, Text, x303 y441 w110 h20, Color
Gui Add, DropDownList, vlineType x303 y406 w210, Line|Scattered
Gui Add, GroupBox, x527 y275 w183 h122, Custom
Gui Add, Checkbox, vcbRAxis gCustom_Change x540 y306 w80 h20, Right Axis #:
Gui Add, Edit, vcbRAxisVal x625 y304 w75 h26
Gui Add, Checkbox, vcbSpecial1 gCustom_Change x540 y335 w80 h20, Track Series:
Gui Add, Edit, vcbSpecial1Val x625 y334 w75 h24
Gui Add, ListView, vchartList gChart_Click x315 y97 w360 h143, #|Name
Gui Add, ListView, vwinList gWin_Click x10 y40 w295 h200, #|Title
Gui Add, Checkbox, vcbStat gCustom_Change x540 y363 w80 h20,  Status Bit:
Gui Add, Edit, vcbStatVal x625 y362 w75 h24
Gui Show, w749 h702, DataViewer Config Editor
Return

MainGuiEscape:
MainGuiClose:
    ExitApp

; End of the GUI section


Win_Click:
return

Chart_Click:
return

Line_Click:
return


Chart_Action:
cmd := StrReplace(A_ThisLabel, "Button")
if (IsFunc(cmd))
	%cmd%()
else if (IsLabel(cmd))
	Goto, %cmd%
else
	MsgBox 4114,, Not yet implemented!
return

Custom_Change:
return


Gui()
Gui(fName:="") {
	static
	
	Gui, Main:Default
	
	Gui Font, Bold
	Gui Add, Text, x10 y20 w70 h20, Windows
	Gui Font
	Gui Font, Bold
	Gui Add, Text, x315 y20 w28 h16, Title
	Gui Font
	Gui Add, Edit, x315 y40 w420 h30, Directional Data - TerraVici DataViewer
	Gui Font, Bold
	Gui Add, Text, x315 y80 w40 h16, Charts
	Gui Font
	Gui Add, Button, x677 y96 w65 h30, &Add
	Gui Add, Button, x677 y127 w65 h30, &Edit
	Gui Add, Button, x677 y158 w65 h30, &Remove
	Gui Add, Button, x298 y660 w90 h35, &Save
	Gui Add, Button, x392 y660 w90 h35, &Cancel
	Gui Add, ListView, x20 y325 w280 h305, #|Data Column|Legend Name
	Gui Font, Bold
	Gui Add, GroupBox, x10 y300 w740 h360, Lines
	Gui Font
	Gui Font, Bold
	Gui Add, Text, x315 y325 w110 h20, Column Name
	Gui Font
	Gui Add, Edit, x315 y345 w210 h25, %name%
	Gui Font, Bold
	Gui Add, Text, x315 y380 w200 h20, Custom Legend Text (optional)
	Gui Font
	Gui Add, Edit, x315 y400 w210 h25, %legend%
	Gui Font, Bold
	Gui Add, Text, x315 y435 w110 h20, Series Type
	Gui Font
	Gui Add, Edit, x315 y510 w210 h25, %color%
	Gui Font, Bold
	Gui Add, Text, x315 y490 w110 h20, Color
	Gui Font
	Gui Add, DropDownList, x315 y455 w210, Line|Scattered
	Gui Font, Bold
	Gui Add, GroupBox, x534 y323 w207 h200, Custom
	Gui Font
	Gui Add, Checkbox, x546 y354 w80 h20, Right Axis #:
	Gui Add, Edit, x631 y352 w26 h24
	Gui Add, Checkbox, x546 y391 w80 h20, Track Series:
	Gui Add, Edit, x631 y390 w75 h24
	Gui Add, ListView, x315 y97 w360 h143, #|Name
	Gui Add, ListView, x10 y40 w295 h200, #|Title
	Gui Show, w757 h700, Window
	Return
	
	MainGuiEscape:
	MainGuiClose:
    ExitApp
}
m(info*) {
	static icons:={"x":16,"?":32,"!":48,"i":64}, btns:={c:1,oc:1,co:1,ari:2,iar:2,ria:2,rai:2,ync:3,nyc:3,cyn:3,cny:3,yn:4,ny:4,rc:5,cr:5}
	for c, v in info {
		if RegExMatch(v, "imS)^(?:btn:(?P<btn>c|\w{2,3})|(?:ico:)?(?P<ico>x|\?|\!|i)|title:(?P<title>.+)|def:(?P<def>\d+)|time:(?P<time>\d+(?:\.\d{1,2})?|\.\d{1,2}))$", m_) {
			mBtns:=m_btn?1:mBtns, title:=m_title?m_title:title, timeout:=m_time?m_time:timeout
			opt += m_btn?btns[m_btn]:m_ico?icons[m_ico]:m_def?(m_def-1)*256:0
		}
		else
			txt .= (txt ? "`n":"") v
	}
	MsgBox, % (opt+262144), %title%, %txt%, %timeout%
	IfMsgBox, OK
		return (mBtns ? "OK":"")
	else IfMsgBox, Yes
		return "YES"
	else IfMsgBox, No
		return "NO"
	else IfMsgBox, Cancel
		return "CANCEL"
	else IfMsgBox, Retry
		return "RETRY"
}
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
sn(node, path) {
	return node.selectNodes(path)
}
ssn(node, path) {
	return node.selectSingleNode(path)
}
ssnTxt(ftypes, node, prop) {
	return ftypes.ssn("//FileType[" node "]/" prop).text
}
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
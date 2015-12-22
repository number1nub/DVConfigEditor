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
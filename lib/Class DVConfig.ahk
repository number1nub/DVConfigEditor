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
		this._file := fPath
		this._name := nne
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
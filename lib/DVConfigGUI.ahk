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


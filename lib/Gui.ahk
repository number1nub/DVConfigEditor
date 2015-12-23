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
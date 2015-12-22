ssnTxt(ftypes, node, prop) {
	return ftypes.ssn("//FileType[" node "]/" prop).text
}
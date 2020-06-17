********************************************************************************
* file: srk_programs.do

* description: loads programs used frequently
********************************************************************************

*===============================================================================
* texinit: a suite of programs that set up tex files for you
*===============================================================================

ssc install texdoc, replace

cap program drop texinit_gr
program define texinit_gr
syntax , filename(str)

texdoc init `"`filename'"', replace force
	tex \documentclass[12pt, letterpaper]{article}
	tex \usepackage[utf8]{inputenc}
	tex \usepackage[english]{babel}
	tex \usepackage[final]{pdfpages}
	tex \usepackage{rotating}
	tex \usepackage{pdflscape}
	tex \pagenumbering{gobble}
	tex \begin{document}
	tex \begin{landscape}
texdoc close
end 

cap program drop texinit_doc
program define texinit_doc
syntax , filename(str)

texdoc init `"`filename'"', replace force
	tex \documentclass[12pt, letterpaper]{article}
	tex \usepackage[utf8]{inputenc}
	tex \usepackage[english]{babel}
	tex \usepackage{blindtext}
	tex \usepackage{amsmath, amssymb, dsfont, amsthm, mathtools, mathrsfs, bbm}
	tex \usepackage{indentfirst}
	tex \usepackage{enumitem}
	tex \usepackage{hyperref}
	tex \usepackage[retainorgcmds]{IEEEtrantools}
	tex \usepackage{outlines}
	tex \usepackage{framed}
	tex \usepackage{titlesec}
	tex \usepackage{sgame}
	tex \usepackage{graphicx}
	tex \usepackage[margin=1in]{geometry}
	tex \setlength\parindent{0pt}
	tex \usepackage{tgpagella}
	tex \usepackage[authoryear]{natbib}
	tex \usepackage{setspace}
	tex \usepackage{csquotes}
	tex \usepackage{booktabs}
	tex \usepackage{tikz}
	tex \usepackage[labelfont=bf]{caption}
	tex \usepackage{mathabx}
	tex \usepackage[final]{pdfpages} %Includepdf
	tex \usepackage{verbatim}
texdoc close

end 

*===============================================================================
* texend: a suite of programs that set up tex files for you
*===============================================================================

cap program drop texend_gr
program define texend_gr
syntax , filename(str)

texdoc init `"`filename'"', append force
	tex \end{landscape}
	tex \end{document}
texdoc close

end 

cap program drop texend_doc
program define texend_doc
syntax , filename(str)

texdoc init `"`filename'"', append force
	tex \end{document}
texdoc close

end 

*===============================================================================
* texinclude: include a single line of text quickly
*===============================================================================

cap program drop texinclude
program def texinclude
syntax anything(name=texstr everything), filename(str) 

texdoc init `"`filename'"', append force
	tex `texstr'
texdoc close

end

*===============================================================================
* texfig: include a figure quickly
*===============================================================================

cap program drop texfig
program def texfig
syntax, texfile(str) graphpath(str) [grtitle(str)]

if `"`grtitle'"' ~= "" {
	loc caption_line tex \caption{`grtitle'}
}

texdoc init `"`texfile'"', append force
	tex \begin{figure}[h!]
	`caption_line'
	tex \includegraphics[width=\textwidth]{`graphpath'}
	tex \end{figure}
texdoc close

end

*===============================================================================
* texstat: a program to output a single number for main body text
*===============================================================================

cap program drop texstat
program define texstat
syntax , filename(str) num(num)

texdoc init `"`filename'"', replace force
	tex `num'
texdoc close

end 

*===============================================================================
* texcompile: a program to compile the tex file for you
*===============================================================================

cap program drop texcompile
program define texcompile
syntax , location(str) filename(str)

local current_dir `c(pwd)'

cap confirm file `"`location'/`filename'"'
	if _rc ~=0 {
		di as error "The tex file does not exist!"
		break
	}

cd `"`location'"'
!pdflatex -synctex=1 -interaction=nonstopmode "`filename'" -no-shell-escape
cd "`current_dir'"

end 

*===============================================================================
* timestamp_dir: a program to make a time-stamped directory of results
*===============================================================================

cap program drop timestamp_dir
program def timestamp_dir, rclass
syntax, subpath(str)

loc month: word 2 of `c(current_date)'
loc day: word 1 of `c(current_date)'
loc year: word 3 of `c(current_date)'

loc ts_folder = "`month'" + "`day'" + "`year'" + "_archive"

cap mkdir `"`subpath'/`ts_folder'"'

return local ts_dir `"`subpath'/`ts_folder'"'

end



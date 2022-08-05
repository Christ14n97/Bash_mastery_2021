
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:////home/christian97/Documents/msc_biochemistry/csbr_course/ex_13/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (locus_CSF1PO_struct.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 27/08/21 at 09:00:39", "locus_CSF1PO_struct.xml#27_08_21at09_00_39"))
	insDoc(aux1, gLnk("R", "Settings", "locus_CSF1PO_struct.xml#27_08_21at09_00_39_run_information"))
		aux2 = insFld(aux1, gFld("Genetic structure (samp=pop)", "locus_CSF1PO_struct.xml#27_08_21at09_00_39_pop_gen_struct"))
		insDoc(aux2, gLnk("R", "AMOVA", "locus_CSF1PO_struct.xml#27_08_21at09_00_39_pop_amova"))

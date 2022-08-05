
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:////home/christian97/Documents/msc_biochemistry/csbr_course/ex_08/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (locus_D7S820.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 25/08/21 at 23:18:50", "locus_D7S820.xml#25_08_21at23_18_50"))
	insDoc(aux1, gLnk("R", "Settings", "locus_D7S820.xml#25_08_21at23_18_50_run_information"))
		aux2 = insFld(aux1, gFld("Genetic structure (samp=pop)", "locus_D7S820.xml#25_08_21at23_18_50_pop_gen_struct"))
		insDoc(aux2, gLnk("R", "Pairwise distances", "locus_D7S820.xml#25_08_21at23_18_50_pop_pairw_diff"))


USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:////home/christian97/Documents/msc_biochemistry/csbr_course/ex_03/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (locus_D3S1358.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 24/08/21 at 11:11:44", "locus_D3S1358.xml#24_08_21at11_11_44"))
	insDoc(aux1, gLnk("R", "Settings", "locus_D3S1358.xml#24_08_21at11_11_44_run_information"))
		aux2 = insFld(aux1, gFld("Genetic structure (samp=pop)", "locus_D3S1358.xml#24_08_21at11_11_44_pop_gen_struct"))
		insDoc(aux2, gLnk("R", "Pairwise distances", "locus_D3S1358.xml#24_08_21at11_11_44_pop_pairw_diff"))

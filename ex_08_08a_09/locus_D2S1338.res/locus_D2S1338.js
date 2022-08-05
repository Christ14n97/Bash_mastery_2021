
USETEXTLINKS = 1
STARTALLOPEN = 0
WRAPTEXT = 1
PRESERVESTATE = 0
HIGHLIGHT = 1
ICONPATH = 'file:////home/christian97/Documents/msc_biochemistry/csbr_course/ex_08/'    //change if the gif's folder is a subfolder, for example: 'images/'

foldersTree = gFld("<i>ARLEQUIN RESULTS (locus_D2S1338.arp)</i>", "")
insDoc(foldersTree, gLnk("R", "Arlequin log file", "Arlequin_log.txt"))
	aux1 = insFld(foldersTree, gFld("Run of 25/08/21 at 23:18:51", "locus_D2S1338.xml#25_08_21at23_18_51"))
	insDoc(aux1, gLnk("R", "Settings", "locus_D2S1338.xml#25_08_21at23_18_51_run_information"))
		aux2 = insFld(aux1, gFld("Genetic structure (samp=pop)", "locus_D2S1338.xml#25_08_21at23_18_51_pop_gen_struct"))
		insDoc(aux2, gLnk("R", "Pairwise distances", "locus_D2S1338.xml#25_08_21at23_18_51_pop_pairw_diff"))

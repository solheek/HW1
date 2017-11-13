#
#	print $1, $2/1000"M", $3, $4, $5, $6;
#}

function trans(val){
	
	if(NR>1){
		if (val>=1048576){
			val=val/(1024^2);
			val=sprintf("%.fG", val);
		}
		else if (val>=1024){
			val=val/1024;
			val=sprintf("%.fM", val);
		}
		else
			val=val"K";
		return val;
	}
}

{
	if(NR ==1)
		printf "Filesystem               Size  Used Avail Use% Mounted on\n";
	else	
		printf "%-24s %-5s %-4s %-5s %-4s %s\n", $1, trans($2), trans($3), trans($4), $5, $6;
}

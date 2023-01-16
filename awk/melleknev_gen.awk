#
# mell�knevek ragoz�si csoportba sorol�sa
# 
BEGIN { 
    while ((getline var < "melleknev_a.1") > 0) { a_kotohangzo[var]=1; }
    while ((getline var < "melleknev_e.1") > 0) { e_kotohangzo[var]=1; }
    while ((getline var < "melleknev_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "melleknev_magas.1") > 0) { magas[var]=1; }
    while ((getline var < "melleknev_ing.1") > 0) { ingadozo[var]=1; }
    while ((getline var < "melleknev_jaje.1") > 0) { jaje[var]=1; }
    while ((getline var < "melleknev_ae.1") > 0) { ae[var]=1; }
    while ((getline var < "melleknev_jajeae.1") > 0) { jajeae[var]=1; }
    while ((getline var < "melleknev_oe.1") > 0) { oe[var]=1; }
    while ((getline var < "fonev_s.1") > 0) { fn_s[var]=1; }
}

function a_koto(szo,kapcsolo) {
    if (a_kotohangzo[szo]==1) { 
        return "";
    } else if (e_kotohangzo[szo]==1) {
	return "/N";
    } else {
        return kapcsolo;
    }
}

function jaje_e(st,j,nemj) {
if (jaje[st]==1) {return j;} else {
if (ae[st]==1) {return nemj;} else {
if (jajeae[st]==1) {return j nemj; } else {
if (match(st,"[chjmsxyvz]$")!=0) { return nemj;}
  else {return j;}  
}}}}

# -ka, -ke kicsiny�t�k�pz�:
# a sz� nem �sszetett, �s legal�bb k�t sz�tag�
function ka(s) {
    if (!osszetett[$1] && $1~/[a�e�i�o���u���A�E�I�O���U���].*[a�e�i�o���u���]/) return s
    return ""
}

/[a�o�u�]$/ { print "[adj]" $1 "/A���/F/U/�/Q" }
/[����]$/ { print "[adj]" $1 "/C���/H/W/�/R" }
/[e�i�]$/ { if (mely[$1]==1) {print "[adj]" $1 "/A���/F/U/�/Q"; next } 
    else {print "[adj]" $1 "/B���/G/V/�/R"; next } }

(magas[$1]!=1 && (/[a�o�u�][-bcdfghjklmnpqrstvwxyz]+$/ ||
/^.*[u�o�a�][bcdfghjklmnpqrstvwxyz]*i[bcdfghjklmnpqrstvwxyz]+$/)) {
    s = fn_s[$1]?"�":"m�"
    print "[adj]" $1 "/��/F/U/�" s a_koto($1,"/K�") jaje_e($1,"/Q","/S/s") ka("k"); next }

/[i�e�a][-bcdfghjklmnpqrstvwxyz]+$/ {
  s = fn_s[$1]?"�":"n�"
  s2 = fn_s[$1]?"�":"m�"
  if (mely[$1]==1) {print "[adj]" $1 "/��/F/U/�" s2 a_koto($1,"/K�") jaje_e($1,"/Q","/S/s") ka("k")} 
  else { 
     if (ingadozo[$1]==1) { 
        print "[adj]" $1 "/��/F/U/�" s2 a_koto($1,"/K�") jaje_e($1,"/Q","/S/s") "/��/G/V/�" s a_koto($1,"/L") jaje_e($1,"/R","/T/t") ka("kl") }
     else { print "[adj]" $1 "/��/G/V/�" s a_koto($1,"/L") jaje_e($1,"/R","/T/t") ka("l")}
  }
}

/[����][bcdfghjklmnprstvxyz]+$/ { 
  print "[adj]" $1 "/����/G/V/�/N" a_koto($1,"/M") jaje_e($1,"/R","/T/t") ka("l"); 
}

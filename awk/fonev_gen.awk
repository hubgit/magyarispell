#
# f�nevek ragoz�si csoportba sorol�sa
#
# k�ls� v�ltoz�: tulaj_e (tulajdonnevek eset�n kikapcs. sz��sszet�tel)
# ha tulaj_e==1)
# tulaj_geo_e: �tamerikai k�l�n (a f�ldrajzi nevekn�l a 119. szab�ly
# nincs elfogadva)
#
# ketchup ingadoz�sa bedr�tozva
#

BEGIN { 
    while ((getline var < "fonev_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "fonev_magas.1") > 0) { magas[var]=1; }
    while ((getline var < "fonev_magas2.1") > 0) { magas2[var]=1; }
    while ((getline var < "fonev_ing.1") > 0) { ingadozo[var]=1; }
    while ((getline var < "fonev_jaje.1") > 0) { jaje[var]=1; }
    while ((getline var < "fonev_ae.1") > 0) { ae[var]=1; }
    while ((getline var < "fonev_jajeae.1") > 0) { jajeae[var]=1; }
    while ((getline var < "fonev_oe.1") > 0) { oe[var]=1; }
    while ((getline var < "fonev_kulon.1") > 0) { kulonszo[var]=1; }
    while ((getline var < "fonev_eleje.1") > 0) { elejeszo[var]=1; }
    while ((getline var < "fonev_vege.1") > 0) { vegeszo[var]=1; }
    while ((getline var < "fonev_osszetett.1") > 0) { osszetett[var]=1; }
    while ((getline var < "fonev_a.1") > 0) { a[var]=1; }
    while ((getline var < "fonev_y_i.1") > 0) { y_i[var]=1; }
    while ((getline var < "fonev_y_j.1") > 0) { y_j[var]=1; }
    while ((getline var < "fonev_s.1") > 0) { fn_s[var]=1; }
    while ((getline var < "tobbtagu.1") > 0) { tobbtagu[var]=1; }
    while ((getline var < "fonev_igekoto.1") > 0) { igekoto[var]=1; }
}
function jaje_e(st,j,nemj) {
if (jaje[st]==1 || y_i[st]) {return j;} else {
if (ae[st]==1) {return nemj;} else {
if (jajeae[st]==1) {return j nemj; } else {
if (match(st,"[cghjmsxyvz]$")) { return nemj;}
  else {return j;}  
}}}}

# kulon �s igekoto
function kulon(st) {
    igekot = (igekoto[st]==1) ? "/X" : ""
    if (tulaj_e==1) return "/," igekot;
    if (vegeszo[st]==1) {
	return "/x/c" igekot
    } else if (elejeszo[st]==1) {
	return "/v/c" igekot
    } else if (kulonszo[st]!=1) {
	return "/Y/c" igekot
    } else {
	return "/c" igekot
    }
    return igekot
}

# ajakkerek�t�ses magas csoportok (improdukt�v -es (k�nyves), produkt�v -�s (t�k�s))

function _s(kotojeles_s) {
    return (tobbtagu[$1] ? kotojeles_s: "")
}

function os(s1, s2) {
    if (oe[$1]==1) return s2;
    return s1;
}

# -j�, -j�

function ju(s1, s2) {
    if (tulaj_e==1) return s1
    if (osszetett[$1] == 1) return s2
    return s1 s2
}

function tulaj(s, s2, s3, s4) {
    if (tulaj_geo_e==1) return "/q" s2
    if (tulaj_e==1) return "/q" s3
    if ($1~/^[^aeuio��������]*[aeuio��������]$/) s="" # ti->tiz
    if (osszetett[$1]==1) return s "y" s3
    return s s4
}

# -ka, -ke kicsiny�t�k�pz�:
# a sz� nem �sszetett, �s legal�bb k�t sz�tag�
function ka(s) {
    if (!osszetett[$1] && $1~/[a�e�i�o���u���A�E�I�O���U���].*[a�e�i�o���u���]/) return s
    return ""
}

magas2[$1]==1 && !/u$/  { # We�resh�z, Wordh�z
    print $1 "/W/�/�/j" (y_i[$1]?"�B��":"�M��") tulaj("/�", "�", "���", "���") jaje_e($1,"/R","/T/t") kulon($1) ju("�","�") ka("l") _s("�")
    next
}

( /[a�o�u�]$/ || /agrave;$/ || /ugrave;$/ )  && magas2[$1] != 1 {
    print $1 "/�/A/U/Q/�/�/i/�/�" tulaj("/�", "�", "ǿ�", "���") kulon($1) ju("�","�") _s("�")
}
/[����]$/ || /oslash;$/ || magas2[$1] == 1 { 
    print $1 "/�/C/W/R/�/�/j/�/�" tulaj("/�", "�", "�" os("��","��"), "���") kulon($1) ju("�","�") _s("�")
}
/[e�i��]$/ { 
    if (ingadozo[$1]==1) {
	print $1 "/�/A/U/B/V/L/Q/R/�/�/�/�/i/j/�/�/�" tulaj("/�/�", "��", "ǿ��", "�貳����") kulon($1) ju("�","�") ju("�","�") _s("�")
    } else {
        if (mely[$1]==1) {
	    print $1 "/�/A/U/Q/�/�/i/�/�" tulaj("/�", "�", "ǿ�", "���") kulon($1) ju("�","�") _s("�")
	} else {
	    print $1 "/�/B/V/R/�/�/j/�/�" tulaj("/�", "�", "���", "���") kulon($1) ju("�","�") _s("�")
	}
    }
}

$1=="ketchup" { # [kecsap]-[kecs�p]
		s = fn_s[$1]?"m�":"m�"
	    print $1 "/U/�/�/i" (a[$1]?"$s�" s:(y_i[$1]?"�A��":(y_j[$1]?"�K�" s:"�K�" s))) tulaj("/�", "�", "ǿ�", "���") jaje_e($1,"/Q","/S/s") kulon($1) ju("�","�") ka("k") \
            "/W/�/�/j" (y_i[$1]?"�B��":"�M��") tulaj("/�", "�", "���", "���") jaje_e($1,"/R","/T/t") kulon($1) ju("�","�") ka("l")
            next
}
/[a�o�u�A�O�U�]['bcdfghjklmnpqrstvwxyz����������������������������������������]+$/ { 
    if (ingadozo[$1]==1) {
	s = fn_s[$1]?"n�":"n�"
	s2 = fn_s[$1]?"m�":"m�"
	print $1 "/U/V/�/�/�/�/i/j" (y_i[$1]?"�AB���":"��KL��" s s2)  tulaj("/�/�", "��", "ǿ����", "������") jaje_e($1,"/Q/R","/T/t") kulon($1) ju("�","�") ju("�","�") ka("kl") _s("��")
	next
    }
    if (magas[$1]==1) {
		s = fn_s[$1]?"n�":"n�"
	    print $1 "/V/�/�/j" (y_i[$1]?"�B��": "�Ln�" s) tulaj("/�", "�", "���", "���") jaje_e($1,"/R","/T/t") kulon($1) ju("�","�") ka("l") _s("�")
    } else {
		s = fn_s[$1]?"m�":"m�"
	    print $1 "/U/�/�/i" (a[$1]?"$s�" s:(y_i[$1]?"�A��":(y_j[$1]?"�K�" s:"�K�" s))) tulaj("/�", "�", "ǿ�", "���") jaje_e($1,"/Q","/S/s") kulon($1) ju("�","�") ka("k") _s("�")
    }
}
/[i�e�I�E�Y�]['bcdfghjklmnpqrstvwxyz����������������������������������������]+$/  || /Babe&0219;$/ { 
	s = fn_s[$1]?"n�":"n�"
	s2 = fn_s[$1]?"m�":"m�"
    if (ingadozo[$1]==1) {
		print $1 "/U/V/�/�/�/�/i/j" (y_i[$1]?"�AB���":"��KL��" s s2)  tulaj("/�/�", "��", "ǿ����", "������") jaje_e($1,"/Q/R","/T/t") kulon($1) ju("�","�") ju("�","�") ka("kl") _s("��")
    } else {
	if (mely[$1]==1) {
	    print $1 "/U/�/�/i" (y_i[$1]?"�A��":"�K�" s2) tulaj("/�", "�", "ǿ�", "���") jaje_e($1,"/Q","/S/s") kulon($1) ju("�","�") ka("k") _s("�")
	} else { 
	    print $1 "/V/�/�/j" (y_i[$1]?"�B��":"�L�" s) tulaj("/�", "�", "���", "���") jaje_e($1,"/R","/T/t") kulon($1) ju("�","�") ka("l") _s("�")
	}
    }
}
/[��������]['bcdfghjklmnpqrstvxywz����������������������������������������]+$/ { 
    if (oe[$1]==1) {
	print $1 "/V/N/�/�/j" "�L���" tulaj("/�", "�", "���", "���") jaje_e($1,"/R","/T/t") kulon($1) ju("�","�") ka("l") _s("�")
    } else {
	print $1 "/W/�/�/j" (y_i[$1]?"�B��":"�M���") tulaj("/�", "�", "���", "���") jaje_e($1,"/R","/T/t") kulon($1) ju("�","�") ka("l") _s("�")
    }
}
/[-]$/ {
    print $1 "/v/c"
}

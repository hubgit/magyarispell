#
# mell�knevekb�l -s�g/-s�g f�n�vk�pz�s alakok el��ll�t�sa
#
BEGIN {
    while ((getline var < "melleknev_mely.1") > 0) { mely[var]=1; }
    while ((getline var < "melleknev_osszetett.1") > 0) { osszetett[var]=1; }
}
{ossz=""}
osszetett[$1]==1{ossz="y"}
/ss$/ || /rs$/ || /lcs$/ { next }
(/[a�o�u�][bcdfghjklmnpqrstvwxyz]*$/ ||
/^[bcdfghjklmnpqrstvwxyz]*�[bcdfghjklmnpqrstvwxyz]*$/ ||
/^.*[u�o�a�][bcdfghjklmnpqrstvwxyz]*i[bcdfghjklmnpqrstvwxyz]*$/) && ! /^$/ &&
($1 != "fair") && ($1 != "unfair") && ($1 != "�tvitt" && $1 != "�r") {
    print "[adj]" $1 "/�" ossz; next; }
! /^[ 	]*$/ { if (mely[$1]==1) { print "[adj]" $1 "/�" ossz }
    else { print "[adj]" $1 "/�" ossz; }
}

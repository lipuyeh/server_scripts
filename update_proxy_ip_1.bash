# test on ubuntu 18.04 
update=$1
if [ "$update" == "" ]; then
    echo "no update target"
    exit
elif [ "$update" = "ppp1" ]; then
    export changeppp="dsl-ppp1"
    export changeifname="theppp1"
    export tablename="ppp1_table"
elif [ "$update" == "ppp0" ]; then
    export changeppp="dsl-ppp0"
    export changeifname="theppp0"
    export tablename="ppp0_table"
else 
    echo $update is wrong; exit
fi

date
/sbin/ifconfig theppp0
ppp0result=$?
/sbin/ifconfig theppp1
ppp1result=$?
/sbin/ifconfig theppp2
ppp2result=$?
/sbin/ifconfig theppp3
ppp3result=$?
echo $ppp0result, $ppp1result, $ppp2result
if [ $ppp0result != 0 ] && [ $update = "ppp0" ]; then
    export changeppp="dsl-ppp2"
    export changeifname="theppp2"
    export tablename="ppp0_table"
    export ifname="theppp0"
    export noton="dsl-ppp0"
    echo "ppp0"
fi
if [ $ppp1result != 0 ]  && [ $update = "ppp1" ]; then
    export changeppp="dsl-ppp3"
    export changeifname="theppp3"
    export tablename="ppp1_table"
    export ifname="theppp1"
    export noton="dsl-ppp1"
    echo "ppp1"
fi
if [ $ppp2result != 0 ] && [ $update = "ppp0" ] ; then
    export ifname="theppp2"
    export noton="dsl-ppp2"
    echo "ppp2"
fi
if [ $ppp3result != 0 ] && [ $update = "ppp1" ] ; then
    export ifname="theppp3"
    export noton="dsl-ppp3"
    echo "ppp3"
fi


if [ "$noton" = "" ]; then
    echo "no not on"
    exit
fi

echo $changeppp, $noton, $ifname, $changeifname, $tablename
    /usr/bin/pon $noton;
    sleep 20
    for i in {1..60}; do
        echo "check $noton"
        sleep 2;
        /sbin/ifconfig $ifname
        result=$?
        if [[ $result -eq 0 ]]; then
            echo break
            break
        fi
        echo $result
    done

/sbin/ip route del default dev $changeifname table $tablename
/sbin/ip route add default dev $ifname table $tablename
/usr/bin/poff $changeppp
/sbin/ifconfig $ifname | grep "inet "



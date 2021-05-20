# test on ubuntu 18.04 

date
/sbin/ifconfig ppp0
result=$?
echo $result
if [ $result = 0 ]; then
    echo "ppp0"
    /usr/bin/poff dsl_ppp1;
    sleep 1;
    /usr/bin/pon dsl_ppp1;
    /sbin/ifconfig | grep ppp1
    result=$?
    for i in {1..60}; do
        echo "wait ppp1"
        sleep 2;
        /sbin/ifconfig ppp1
        result=$?
        if [[ $result -eq 0 ]]; then
            echo break
            break
        fi
        echo $result
    done
    /sbin/ip route del default dev ppp0 table ppp0_table
    /sbin/ip route add default dev ppp1 table ppp0_table
    /usr/bin/poff dsl_ppp0
    /sbin/ifconfig ppp1 | grep inet
else
    echo "no ppp0"
    /usr/bin/poff dsl_ppp0;
    sleep 1;
    /usr/bin/pon dsl_ppp0;
    /sbin/ifconfig | grep ppp0
    result=$?
    for i in {1..60}; do
        echo "wait ppp0"
        sleep 2;
        /sbin/ifconfig ppp0
        result=$?
        if [[ $result -eq 0 ]]; then
            echo break
            break
        fi
        echo $result
    done
    /sbin/ip route del default dev ppp1 table ppp0_table
    /sbin/ip route add default dev ppp0 table ppp0_table
    /usr/bin/poff dsl_ppp1
    /sbin/ifconfig ppp0 | grep inet
fi

#!/bin/zsh


icons=("Ñ" "Î" "¨" "¹" "ê" "í" "È")

getInt() {

    net=`ip a | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'`
    echo -ne "\x0A${icons[1]}\x01 ${net}"
	

}

getCPU() {
    cpu="$(eval $(awk '/^cpu /{print "previdle="$5";prevtotal="$2+$3+$4+$5}' /proc/stat);sleep 0.4;eval $(awk '/^cpu /{print "idle="$5";total="$2+$3+$4+$5}' /proc/stat);intervaltotal=$((total-${prevtotal:-0}));echo -ne "$((100*((intervaltotal)-($idle-${previdle:-0}))/(intervaltotal)))")"    
    echo -ne "\x0A${icons[0]}\x01${cpu}%"
}
awk '/Mem:/ {print $7}' <(free -m)
getMEM() {
    mem="$(awk '/Mem:/ {print $3}' <(free -m))"
    echo -ne "\x0A${icons[1]}\x01 ${mem}MB"
}

getHDDroot() {
    #hdd="$(df | awk '/dev\/sda3/ {print $5}') $(df | awk '/dev\/sda4/ {print $5}')"
    hdd="$(df -Ph /dev/sda1 | awk '$3 ~ /[0-9]+/ {print $4}')"
    echo -ne "\x0A${icons[2]}\x01 ${hdd}"
}

getHDDdata() {
    #hdd="$(df | awk '/dev\/sda3/ {print $5}') $(df | awk '/dev\/sda4/ {print $5}')"
    hdd="$(df -Ph /dev/sda4 | awk '$3 ~ /[0-9]+/ {print $4}')"
    echo -ne "\x0A${icons[2]}\x01 ${hdd}"
}

getUpdates() {
    upd="$(pacman -Qu | wc -l)"
    echo -ne "\x0A${icons[3]}\x01 ${upd} updates"
}

getMusic() {
    msc="$(ncmpcpp --now-playing '{%a - %t}|{%f}')"
    if [ ! $msc ]; then
        echo -ne "\x0A${icons[4]}\x01 no music"
    else
        echo -ne "\x0A${icons[4]}\x01 ${msc}" 
    fi
}

getVolume() {
    vol="$(amixer get PCM | awk '/Front Left:/ {print $5}' | tr -dc '0-9')"
    echo -ne "\x0A${icons[5]}\x01 ${vol}%"
}

getTime() {
    tme="$(date '+ %H:%M')"
    echo -ne "\x0A${icons[6]}\x01 ${tme}"
}

while true; do
    xsetroot -name "$(getCPU) $(getMEM) $(getHDDroot) $(getHDDdata) $(getMusic) $(getVolume) $(getInt) $(getTime)"
    sleep 2
done

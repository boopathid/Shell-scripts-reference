for i in $(esxcli vsan storage list | grep -B1 'Is SSD: true' | awk '/naa/{print $3}') ;
do
    cat > /tmp/new.txt <<EOF
		hi there 
	EOF

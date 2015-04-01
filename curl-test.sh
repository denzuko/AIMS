ims_host=${ims_host:-"localhost"}
ims_port=${ims_port:-"9292"}
ims_protocol=${ims_protocol:-"http"}

data="`cat - << EOL
{
	'inventory': [{
		'client':	'TechnologySpa',
		'name':		"$(hostname)",
		'location':	'Dallas HQ',
		'internal_ip':	"$(ip a l dev eth0 | awk '/inet / { print $2 }')",
		'external_ip':	'0.0.0.0',
		'vlan':		'0',
		'fqdn':		"$(hostname -f)",
		'details':	'dwights@tspa.com development node'
	}]
}
EOL`"

open(){
	curl -vv -sLk \
	     -H "Accept: application/json" -vv -sLk \
	     -H "Content-Type: application/json" \
	     $ims_protocol://$ims_host:$ims_port/$*
}


new() {
	open asset -X POST -H 'Content-Type: application/inventory+json;version=1 application/asset' --data "$data"
}

delete() {
	open asset/$1 -X DELETE
}

get() {
	open asset/$1 -X GET -H 'Content-Type: application/json' 
}

new

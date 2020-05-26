module github.com/glauth/glauth

go 1.13

require (
	github.com/BurntSushi/toml v0.3.1
	github.com/GeertJohan/yubigo v0.0.0-20190917122436-175bc097e60e
	github.com/docopt/docopt-go v0.0.0-20180111231733-ee0de3bc6815
	github.com/fsnotify/fsnotify v1.4.9
	github.com/glauth/glauth/pkg/gologgingr v0.0.0-00010101000000-000000000000
	github.com/go-logr/logr v0.1.0
	github.com/jinzhu/copier v0.0.0-20190924061706-b57f9002281a
	github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e // indirect
	github.com/nmcclain/asn1-ber v0.0.0-20170104154839-2661553a0484 // indirect
	github.com/nmcclain/ldap v0.0.0-20191021200707-3b3b69a7e9e3
	github.com/op/go-logging v0.0.0-20160315200505-970db520ece7
	github.com/pquerna/otp v1.2.0
	github.com/yaegashi/msgraph.go v0.1.2
	golang.org/x/sys v0.0.0-20200523222454-059865788121 // indirect
	gopkg.in/amz.v1 v1.0.0-20150111123259-ad23e96a31d2
	gopkg.in/check.v1 v1.0.0-20200227125254-8fa46927fb4f // indirect
)

replace github.com/glauth/glauth/pkg/gologgingr => ./pkg/gologgingr

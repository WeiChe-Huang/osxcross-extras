pushd "${0%/*}" &>/dev/null
 
if [ -z "${OC_SYSROOT}" ]; then
  OSXCROSS_CONF="../target/bin/osxcross-conf"
else
  OSXCROSS_CONF="${OC_SYSROOT}/bin/osxcross-conf"
fi

[ -f $OSXCROSS_CONF ] || { OSXCROSS_CONF=$(which osxcross-conf 2>/dev/null) || exit 1; }

$OSXCROSS_CONF || exit 1

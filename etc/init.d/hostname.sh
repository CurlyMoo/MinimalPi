#! /bin/sh

PATH=/sbin:/bin

. /lib/init/vars.sh
. /lib/lsb/init-functions

do_start () {
	[ -f /etc/hostname ] && HOSTNAME="$(cat /etc/hostname)"

	# Keep current name if /etc/hostname is missing.
	[ -z "$HOSTNAME" ] && HOSTNAME="$(hostname)"

	# And set it to 'localhost' if no setting was found
	[ -z "$HOSTNAME" ] && HOSTNAME=localhost

	[ "$VERBOSE" != no ] && log_action_begin_msg "Setting hostname to '$HOSTNAME'"
	hostname "$HOSTNAME"
	ES=$?
	[ "$VERBOSE" != no ] && log_action_end_msg $ES
	exit $ES
}

do_status () {
	HOSTNAME=$(hostname)
	if [ "$HOSTNAME" ] ; then
		return 0
	else
		return 4
	fi
}

case "$1" in
  start|"")
	do_start
	;;
  restart|reload|force-reload)
	echo "Error: argument '$1' not supported" >&2
	exit 3
	;;
  stop)
	# No-op
	;;
  status)
	do_status
	exit $?
	;;
  *)
	echo "Usage: hostname.sh [start|stop]" >&2
	exit 3
	;;
esac

:

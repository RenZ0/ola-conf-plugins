#!/bin/bash
# GPL-RenZO-2012

# current user
cd ~/.ola

# debian olad user
#cd /home/olad/.ola

conf_list='
ola-artnet.conf
ola-dummy.conf
ola-e131.conf
ola-espnet.conf
ola-ftdidmx.conf
ola-opendmx.conf
ola-pathport.conf
ola-sandnet.conf
ola-shownet.conf
ola-stageprofi.conf
ola-usbdmx.conf
ola-usbserial.conf
'

if [ $# != 2 ]
then
	echo '---'
	echo 'settings path is:'
		 pwd
	echo '---'
	echo 'options:'
	echo 'show/status/enable/disable all/pattern'
	echo ''
	echo 'for example: show all, status all,'
	echo 'show e131, disable net, enable artnet,'
	echo 'disable all, enable ftdi, show ftdi'
	echo 'disable dmx, enable usb, status usb...'
	echo ''
	echo 'special options:'
	echo 'artnet abc (toggle always_broadcast)'
	echo 'tri raw    (toggle tri_use_raw_rdm)'
	echo '---'
else
	# if all, we set conf to match all
	if [ $2 = 'all' ]
	then
		exp='conf'
	else
		exp=$2
	fi

	# check if exists
	a_conf_list=`for filetry in $conf_list
					do
						if [ -f $filetry ]
						then
							echo $filetry
						fi
					done`

	# matching results
	b_conf_list=`ls $a_conf_list | grep $exp`

	# for each file found
	for file in $b_conf_list
	do

		#SHOW
		if [ $1 = 'show' ]
		then
			echo --- $file ---
			cat $file
			echo ---
		fi

		#STATUS
		if [ $1 = 'status' ]
		then
			echo --- $file ---
			# if enabled present, show the line
			if [ `cat $file | grep 'enabled' | wc -l` != 0 ]
			then
				cat $file | grep 'enabled'
			else
				echo 'status missing'
			fi
		fi

		#ENABLE/DISABLE
		if [ $1 = 'enable' ] || [ $1 = 'disable' ]
		then
			# if enabled present, change the line, else add the line
			if [ `cat $file | grep 'enabled' | wc -l` != 0 ]
			then
				if [ $1 = 'enable' ]
				then
					sed "s/enabled = false/enabled = true/" $file > $file.tmp && mv $file.tmp $file
					echo activate $file
				else
					sed "s/enabled = true/enabled = false/" $file > $file.tmp && mv $file.tmp $file
					echo deactivate $file
				fi
			else
				if [ $1 = 'enable' ]
				then
					echo 'enabled = true' >> $file
				else
					echo 'enabled = false' >> $file
				fi
					echo status added to $file
			fi
		fi

	done

	#ARTNET
	if [ $1 = 'artnet' ] && [ $2 = 'abc' ]
	then
		onefile='ola-artnet.conf'
		if [ -f $onefile ]
		then
			# if always_broadcast = false, set true and vice versa
			if [ `cat $onefile | grep 'always_broadcast = false' | wc -l` != 0 ]
			then
				sed "s/always_broadcast = false/always_broadcast = true/" $onefile > $onefile.tmp && mv $onefile.tmp $onefile
			else
				sed "s/always_broadcast = true/always_broadcast = false/" $onefile > $onefile.tmp && mv $onefile.tmp $onefile
			fi

			echo --- $onefile ---
			cat $onefile | grep 'always_broadcast'
		else
			echo $onefile missing
		fi
	fi

	#TRI
	if [ $1 = 'tri' ] && [ $2 = 'raw' ]
	then
		onefile='ola-usbserial.conf'
		if [ -f $onefile ]
		then
			# if tri_use_raw_rdm = false, set true and vice versa
			if [ `cat $onefile | grep 'tri_use_raw_rdm = false' | wc -l` != 0 ]
			then
				sed "s/tri_use_raw_rdm = false/tri_use_raw_rdm = true/" $onefile > $onefile.tmp && mv $onefile.tmp $onefile
			else
				sed "s/tri_use_raw_rdm = true/tri_use_raw_rdm = false/" $onefile > $onefile.tmp && mv $onefile.tmp $onefile
			fi

			echo --- $onefile ---
			cat $onefile | grep 'tri_use_raw_rdm'
		else
			echo $onefile missing
		fi
	fi
fi

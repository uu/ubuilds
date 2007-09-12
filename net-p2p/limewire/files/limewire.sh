#!/bin/bash

CP="MessagesBundles.jar:clink.jar:cocoaFoundation.jar:daap.jar:foxtrot.jar:httpcore-nio.jar:httpcore.jar:id3v2.jar:jcraft.jar:jdic.jar:jl011.jar:jmdns.jar:jdic_stub.jar:mp3sp14.jar:MRJAdapter.jar:themes.jar:tritonus.jar:vorbis.jar:jdic_stub.jar"
CP="${CP}:$(java-config -p limewire,asm-3,cglib-2.2,commons-httpclient-3,commons-logging,commons-net,commons-pool,guice,icu4j,log4j,jgoodies-looks-1.2,jmdns)"

#OPTS="-Xms64m -Xmx128m -Djava.net.preferIPV6Addresses=false -ea -Djava.net.preferIPv4stack=true"

cd /usr/share/limewire

echo "${CP}"

java -cp "${CP}" "com.limegroup.gnutella.gui.Main"

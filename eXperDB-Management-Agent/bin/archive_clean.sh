#!/bin/bash

Archive_Cleanup(){
	pg_archivecleanup -d $PGALOG `cat $PGALOG/archive.flag | cut -f 1 -d'.'`
	rm -rf $PGALOG/archive.flag
}


Archive_Cleanup

/* *************************    *******************************
 * Data 용량
 ******************************************************** */
function fn_gData(v) {  
	
	var use = v.slice(0,-1);

	var data = {
		    id: 'pg_data',
		    value: use,
		    min: 0,
		    max: 100,
		    symbol: '%',
		    pointer: true,
		    gaugeWidthScale: 1.0,
		    customSectors: [{
		      color: '#ff0000',
		      lo: 90,
		      hi: 100
		    }, {
		      color: '#00ff00',
		      lo: 0,
		      hi: 90
		    }],
		    counter: true
			  };
	
	var pg_data = new JustGage(data);

}

/* ********************************************************
 * 백업 용량
 ******************************************************** */
function fn_gBackup(fullSize, backupSize) {
	
		var fSize = 0;
		var bSize =0;

		if(fullSize.slice(-1) == "M"){
			fSize = fullSize.slice(0,-1)*1024;
		}else if(fullSize.slice(-1) == "G"){
			fSize = fullSize.slice(0,-1)*1024*1024;
		}else if(fullSize.slice(-1) == "T"){
			fSize = fullSize.slice(0,-1)*1024*1024*1024;
		}
		
		
		if(backupSize.slice(-1) == "M"){
			bSize=backupSize.slice(0,-1)*1024;
		}else if(backupSize.slice(-1) == "G"){
			bSize=backupSize.slice(0,-1)*1024*1024;
		}else if(backupSize.slice(-1) == "T"){
			bSize=backupSize.slice(0,-1)*1024*1024*1024;
		}
		
		var bak_v = bSize/fSize*100;
		if (isNaN(bak_v) ) {
			bak_v = 0;
		}

	var backup = {
		    id: 'pg_backup',
		    value: bak_v,
		    min: 0,
		    max: 100,
		    symbol: '%',
		    pointer: true,
		    gaugeWidthScale: 1.0,
		    customSectors: [{
		      color: '#ff0000',
		      lo: 30,
		      hi: 100
		    }, {
		      color: '#00ff00',
		      lo: 0,
		      hi: 30
		    }],
		    counter: true
			  };

	var pg_backup = new JustGage(backup);
}

/* ********************************************************
 * pg_wal 로그 용량
 ******************************************************** */
function fn_gWal(walCnt, segmentCnt) {
	var cnt = walCnt/segmentCnt*100;
	if (isNaN(cnt) ) {
		cnt = 0;
	}

	var wal = {
			
		    id: 'pg_wal',
		    value: cnt,
		    min: 0,
		    max: 200,
		    symbol: '%',
		    pointer: true,
		    gaugeWidthScale: 1.0,
		    customSectors: [{
		      color: '#ff0000',
		      lo: 150,
		      hi: 500
		    }, {
		      color: '#00ff00',
		      lo: 0,
		      hi: 200
		    }],
		    counter: true

		   /* id: 'pg_wal',
		    value: v*979,
		    min: 0,
		    max: 1000000000000,
		    humanFriendly: true,
		    reverse: true,
		    gaugeWidthScale: 1.0,
		    customSectors: [{
		      color: "#00ff00",
		      lo: 0,
		      hi: 50000000
		    },{
			      color: "#ff6b00",
			      lo: 5000000,
			      hi: 8000000000
			    },{
				      color: "#ff0000",
				      lo: 8000000000,
				      hi: 1000000000000
				    }],
		    counter: true*/
			  };
	
	var pg_wal = new JustGage(wal);

}





/* ********************************************************
 * 아카이브로그 
 ******************************************************** */
function fn_gArc(v) {

	var arc = {
			  id: 'pg_arc',
			    value: v*1000,
			    min: 0,
			    max: 10000000000,
			    humanFriendly: true,
			    reverse: true,
			    gaugeWidthScale: 1.0,
			    customSectors: [ {
				      color: "#24d9fd",
				      lo: 0,
				      hi: 10000000000
				    }],
			    counter: true
			  };
	
	var pg_arc = new JustGage(arc);

}





/* ********************************************************
 * LOG 용량 
 ******************************************************** */
function fn_gLog(v) {


	var log = {
			  id: 'pg_log',
			    value: v*1000,
			    min: 0,
			    max: 10000000000,
			    humanFriendly: true,
			    reverse: true,
			    gaugeWidthScale: 1.0,
			    customSectors: [ {
			      color: "#24d9fd",
			      lo: 0,
			      hi: 10000000000
			    }],
			    counter: true
			  };
	
	var pg_log = new JustGage(log);

}


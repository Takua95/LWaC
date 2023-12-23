
windowDev DEVICE
windowRes	RESOURCE
windowQue	QUEUE ENTRIES=256, SIZE=27

windowMsg RECORD
name	CHAR 8
func CHAR 4
item NUM  5
horz NUM  5
vert	NUM  5
	     RECORDEND

windowDef INIT "WINDOW=W1, TITLE=Main Menu, SIZE=750:450"
panelDef	INIT	"PANEL=P1,SIZE=750:450":
			",H=017,V=018,FONT=(12),CTEXT=Lone Wolf and Cub:703,FONT=(9)":
			",H=416,V=388,PUSHBUTTON=99:Exit:80:24":
			",H=248,V=388,PUSHBUTTON=98:Player Editor:80:24":
			",H=080,V=388,PUSHBUTTON=97:Tile Editor:80:24"

	PREP windowDev,windowDef
	PREP windowRes,panelDef
	LINK windowDev,windowQue
	LINK windowRes,windowQue
	CHANGE windowRes,"ITEMON"
	CHANGE windowRes,"FOCUSON"
	SHOW windowRes,windowDev

	LOOP
		WAIT windowQue
		GET windowQue;windowMsg
		SWITCH windowMsg.func
			CASE "CLOS"
				STOP
			CASE "PUSH"
				SWITCH windowMsg.item
					CASE 99
						STOP
					CASE 98
						CHAIN "PlayerEditor"
					CASE 97
						CHAIN "TileEditor"
				ENDSWITCH
		ENDSWITCH
	REPEAT

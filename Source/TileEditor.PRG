
	INC TILE_INFO

tileInfoFile IFILE KEY=5,FIX=225,UNCOMP
tileInfoKey  DIM 5

windowDev	DEVICE
windowRes	RESOURCE
windowQue	QUEUE ENTRIES=100,SIZE=137

windowMsg RECORD
name      CHAR 8
func      CHAR 4
item      NUM  5
horz 	NUM  5
vert		NUM  5
data	  	CHAR 40
	     RECORDEND

windowDef INIT "WINDOW=Win1, TITLE=Tile Editor, SIZE=380:650, FIXSIZE, STATUSBAR"
panelDef	INIT	"PANEL=Pan1,SIZE=380:650":
			",H=000,V=030,FONT=(BOLD,ITALIC,16),CTEXT=Tile Editor:380":
			",H=000,V=060,FONT=(PLAIN,10),CTEXT=Ver. 6.46:380":
			",H=116,V=103,FONT=(PLAIN,13),RTEXT=Tile ID":
			",H=120,V=100,FEDIT=200:99999::60":
			",H=116,V=153,RTEXT=Tile Name":
			",H=120,V=150,LEDIT=201::200:20":
			",H=116,V=203,RTEXT=Description":
			",H=120,V=200,MLEDITVS=202::217:100:200":
			",H=050,V=600,PUSHBUTTON=97:Read:80:24":
			",H=150,V=600,PUSHBUTTON=98:Write:80:24":
			",H=250,V=600,PUSHBUTTON=99:Menu:80:24"

	PREP windowDev,windowDef
	PREP windowRes,panelDef
	LINK windowDev,windowQue
	LINK windowRes,windowQue
	CHANGE windowRes,"ITEMON"
	CHANGE windowRes,"FOCUSON"
	SHOW windowRes,windowDev

	CHANGE windowRes,"GRAYALL"
	CHANGE windowRes,"AVAILABLE99"
	CHANGE windowRes,"AVAILABLE98"
	CHANGE windowRes,"AVAILABLE97"
	CHANGE windowRes,"AVAILABLE200"
	CHANGE windowRes,"FOCUS200"

	TRAP FileError IF IO
	OPEN tileInfoFile,"tileInfoFile"
	TRAPCLR IO

	LOOP
		WAIT windowQue
		GET windowQue;windowMsg
		SWITCH windowMsg.func
			CASE "CLOS"
				CHAIN "MainMenu"
			CASE "FOCL"
				SWITCH windowMsg.item
					CASE 200
						CALL LookupTile
				ENDSWITCH
			CASE "PUSH"
				SWITCH windowMsg.item
					CASE 99
						CHAIN "MainMenu"
					CASE 98
						CALL WriteTile
					CASE 97
						CALL LookupTile
				ENDSWITCH
		ENDSWITCH
	REPEAT

LookupTile

	CHANGE windowRes,"GRAY201"
	CHANGE windowRes,"GRAY202"

	CHANGE windowRes,"ERASE201"
	CHANGE windowRes,"ERASE202"

	CLEAR tileId,tileName,desc

	QUERY windowRes,"STATUS200";tileInfoKey
	IF (tileInfoKey = "00000")
		RETURN
	ENDIF

	READ tileInfoFile,tileInfoKey;;
	IF OVER
		CALL okdialog WITH "Record not found - Create new record?","Create","Cancel"
		IF OVER

		ELSE
			RETURN
		ENDIF
	ELSE
		INC TILE_INFO_READ
	ENDIF

	CHANGE windowRes,"TEXT200";tileId
	CHANGE windowRes,"TEXT201";tileName
	CHANGE windowRes,"TEXT202";desc

	CHANGE windowRes,"AVAILABLE200"
	CHANGE windowRes,"AVAILABLE201"
	CHANGE windowRes,"AVAILABLE202"

	RETURN

WriteTile

	QUERY windowRes,"STATUS200";tileId
	QUERY windowRes,"STATUS201";tileName
	QUERY windowRes,"STATUS202";desc


	READ tileInfoFile,tileInfoKey;;
	IF OVER
		CALL msgdialog WITH "Info Written","Continue"
		INC TILE_INFO_WRITE
	ELSE
		CALL msgdialog WITH "Info Updated","Continue"
		INC TILE_INFO_UPDATE
	ENDIF

	RETURN

FileError

	BEEP
	PREP tileInfoFile,"tileInfoFile"
	MOVE "00000",tileInfoKey,tileId
	CLEAR tileName,desc
	INC TILE_INFO_WRITE

	RETURN

	INC Dialogs

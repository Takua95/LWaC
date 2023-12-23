
	INC PlayerInfo

playerInfoFile IFILE KEY=5,FIX=272,UNCOMP
playerInfoKey 	DIM 5

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

windowDef INIT "WINDOW=W1, TITLE=Player Editor, SIZE=380:650, FIXSIZE, STATUSBAR"
panelDef	INIT	"PANEL=P1,SIZE=380:650":
			",H=000,V=030,FONT=(BOLD,ITALIC,16),CTEXT=Player Editor:380":
			",H=000,V=060,FONT=(PLAIN,10),CTEXT=Ver. 6.46:380":
			",H=116,V=103,FONT=(PLAIN,13),RTEXT=Player ID":
			",H=120,V=100,FEDIT=200:99999::60":
			",H=116,V=153,RTEXT=First Name":
			",H=120,V=150,LEDIT=201::200:20":
			",H=116,V=203,RTEXT=Last Name":
			",H=120,V=200,LEDIT=202::200:20":
			",H=116,V=253,RTEXT=Age":
			",H=120,V=250,FEDIT=203:999::40":
			",H=116,V=303,RTEXT=Health":
			",H=120,V=300,FEDIT=204:99::30":
			",H=116,V=353,RTEXT=Description":
			",H=120,V=350,MLEDITVS=205::217:100:200":
			",H=116,V=473,RTEXT=Hostility":
			",H=120,V=470,FEDIT=206:99::30":
			",H=116,V=523,RTEXT=Clan":
			",H=120,V=520,LEDIT=207::200:20":
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
	OPEN playerInfoFile,"playerInfoFile"
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
						CALL LookupPlayer
				ENDSWITCH
			CASE "PUSH"
				SWITCH windowMsg.item
					CASE 99
						CHAIN "MainMenu"
					CASE 98
						CALL WritePlayer
					CASE 97
						CALL LookupPlayer
				ENDSWITCH
		ENDSWITCH
	REPEAT

LookupPlayer

	CHANGE windowRes,"GRAY201"
	CHANGE windowRes,"GRAY202"
	CHANGE windowRes,"GRAY203"
	CHANGE windowRes,"GRAY204"
	CHANGE windowRes,"GRAY205"
	CHANGE windowRes,"GRAY206"
	CHANGE windowRes,"GRAY207"

	CHANGE windowRes,"ERASE201"
	CHANGE windowRes,"ERASE202"
	CHANGE windowRes,"ERASE203"
	CHANGE windowRes,"ERASE204"
	CHANGE windowRes,"ERASE205"
	CHANGE windowRes,"ERASE206"
	CHANGE windowRes,"ERASE207"

	CLEAR entityId,firstName,familyName,age,health,desc,hostility,clan

	QUERY windowRes,"STATUS200";playerInfoKey
	IF (playerInfoKey = "00000")
		RETURN
	ENDIF

	READ playerInfoFile,playerInfoKey;;
	IF OVER
		CALL okdialog WITH "Record not found - Create new record?","Create","Cancel"
		IF OVER
			
		ELSE
			RETURN
		ENDIF
	ELSE
		INC PlayerInfoRead
	ENDIF

	CHANGE windowRes,"TEXT200";entityId
	CHANGE windowRes,"TEXT201";firstName
	CHANGE windowRes,"TEXT202";familyName
	CHANGE windowRes,"TEXT203";age
	CHANGE windowRes,"TEXT204";health
	CHANGE windowRes,"TEXT205";desc
	CHANGE windowRes,"TEXT206";hostility
	CHANGE windowRes,"TEXT207";clan

	CHANGE windowRes,"AVAILABLE200"
	CHANGE windowRes,"AVAILABLE201"
	CHANGE windowRes,"AVAILABLE202"
	CHANGE windowRes,"AVAILABLE203"
	CHANGE windowRes,"AVAILABLE204"
	CHANGE windowRes,"AVAILABLE205"
	CHANGE windowRes,"AVAILABLE206"
	CHANGE windowRes,"AVAILABLE207"

	RETURN

WritePlayer

	QUERY windowRes,"STATUS200";entityId
	QUERY windowRes,"STATUS201";firstName
	QUERY windowRes,"STATUS202";familyName
	QUERY windowRes,"STATUS203";age
	QUERY windowRes,"STATUS204";health
	QUERY windowRes,"STATUS205";desc
	QUERY windowRes,"STATUS206";hostility
	QUERY windowRes,"STATUS207";clan


	READ playerInfoFile,playerInfoKey;;
	IF OVER
		CALL msgdialog WITH "Info Written","Continue"
		INC PlayerInfoWrite
	ELSE
		CALL msgdialog WITH "Info Updated","Continue"
		INC PlayerInfoUpdate
	ENDIF

	RETURN

FileError

	BEEP
	PREP playerInfoFile,"playerInfoFile"
	MOVE "00000",playerInfoKey,entityId
	CLEAR firstName,familyName,age,health,desc,hostility,clan
	INC PlayerInfoWrite

	RETURN

	INC Dialogs

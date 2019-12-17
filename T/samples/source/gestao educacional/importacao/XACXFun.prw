#include "TbiConn.ch"
#include "protheus.ch"
Static aTopTables
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACGetF   บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria uma janela para selecao de arquivos a importar e       บฑฑ
ฑฑบ          ณimporta os arquivos selecionados para seus respectivos      บฑฑ
ฑฑบ          ณarquivos de trabalho.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xACGetF( aFiles, aDriver, cLogFile, lOver, lProcedure, cPerg, cMarca )
Local aRet		:= {}
Local aCampos	:= {}
Local aStru		:= {}
Local aFile		:= {}
Local cFiles	:= ''
Local lEnd		:= .F.
Local nOpcA		:= 0
Local i
Local oDlg
Local oMark
Local oDriver

Default aDriver	:= {}
Default lOver	:= .F.
Default lProcedure := .F.
Default cPerg	:= ""

if cMarca == nil
	cMarca := GetMark()
endif

if Empty( aDriver )
	aDriver	:= {"Arquivo Texto"}
endif

AjustaSX()

Pergunte("XACMIG",.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de trabalho para os arquivos a serem selecionadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aAdd( aStru, { 'T_OK'    , 'C', 002, 0 } )
aAdd( aStru, { 'T_DRIVER', 'C', 013, 0 } )
aAdd( aStru, { 'T_DESC'  , 'C', 030, 0 } )
aAdd( aStru, { 'T_PATH'  , 'C', 255, 0 } )
aAdd( aStru, { 'T_OBRIG' , 'C', 001, 0 } )
aAdd( aStru, { 'T_ORDER' , 'C', 255, 0 } )
aAdd( aStru, { 'T_ITEM'  , 'N', 005, 0 } )

cFiles	:= CriaTrab( aStru, .T. )
dbUseArea( .T.,, cFiles, 'T_Files', .T. )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de trabalho para as tabelas no Topณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if Select( "TOP_FILES" ) == 0
	dbUseArea( .T., "TopConn", "TOP_FILES", "TOP_FILES", .T. )
endif

if aTopTables == nil .or. Empty( aTopTables )
	Processa( {|| xACLoadTop() } )
endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPreenche o arquivo de trabalho com os arquivos a serem selecionadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
for i := 1 to len( aFiles )
	RecLock( "T_Files", .T. )
	T_Files->T_DESC		:= aFiles[i][1]
	T_Files->T_DRIVER	:= aDriver[len(aDriver)]
	T_Files->T_PATH		:= aFiles[i][2]
	T_Files->T_OBRIG	:= if( aFiles[i][5], 'S', 'N' )
	T_Files->T_ORDER	:= aFiles[i][6]
	T_Files->T_ITEM		:= i
	if "TOP"$Upper(T_Files->T_DRIVER)
		T_Files->T_OK		:= if( aScan( aTopTables, aFiles[i][2] ) > 0 .or. aFiles[i][5], cMarca, '' )
	else
		T_Files->T_OK		:= if( File( aFiles[i][2] ) .or. aFiles[i][5], cMarca, '' )
	endif

	T_Files->( msUnlock() )
next i

T_Files->( dbGoTop() )

aAdd( aCampos, { 'T_OK'		,, ' '			, '' } )
aAdd( aCampos, { 'T_DRIVER'	,, 'Driver'		, '@S13' } )
aAdd( aCampos, { 'T_DESC'	,, 'Tํtulo'		, '@S30' } )
aAdd( aCampos, { 'T_PATH'	,, 'Arquivo'	, '@S30' } )

define msDialog oDlg title 'Importa็ใo de Arquivos' from 00,00 to 400,600 pixel

@ 015,003 say 'Arquivos a Importar' size 060,07 of oDlg pixel

oMark := MsSelect():New( "T_Files", "T_OK",, aCampos,, cMarca, { 025, 003, 185, 297 } ,,, )
oMark:oBrowse:Refresh()
oMark:bAval               := { || ( xACGetFMk( cMarca, aDriver ), oMark:oBrowse:Refresh() ) }
oMark:oBrowse:lHasMark    := .T.
oMark:oBrowse:lCanAllMark := .F.

if lOver
	@ 190, 005 CheckBox oOver var lOver prompt 'Sobrescrever dados existentes' size 085,08 of oDlg pixel
endif

activate msDialog oDlg center on init EnchoiceBar(oDlg, { || if( xACGetFOk( cMarca, aDriver ), ( nOpcA := 1, oDlg:End() ), nOpcA:=0 ) }, { || oDlg:End() })

if nOpca == 1
	aDrv	:= {}
	aOk		:= {}
	for i := 1 to len( aFiles )
		T_Files->( dbGoTo( i ) )
		aAdd( aDrv, T_Files->T_DRIVER )
		aAdd( aOk , T_Files->T_OK )
		aFiles[i,2] := T_Files->T_PATH
	next i
	
	Processa( { |lEnd| aRet := U_xACGetR( @lEnd, aFiles, cMarca, aDriver, lProcedure, aDrv, aOk, .F. ) }, 'Pr้-importa็ใo em andamento...',, .T. )
	
	if lEnd	// Se for cancelado pelo operador...
		aRet := {}
	endif
endif

T_Files->( dbCloseArea() )

FErase( cFiles + GetDBExtension() )

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACGetR   บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria a tabela temporaria e appenda o arquivo texto na mesma.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxACGetF                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xACGetR( lEnd, aFiles, cMarca, aDriver, lProcedure, aDrv, aOk, lRobo )
Local aRet		:= {}
Local cQuery
Local i,j
Local lOracle	 := "ORACLE"$Upper(TCGetDB())
Local lGravaLog := .F.
Local cWhere

if !lRobo
	ProcRegua( len( aFiles ) )
endif

/*
	T_Files->T_DESC		:= aFiles[i][1]
	T_Files->T_DRIVER	:= aDriver[len(aDriver)]
	T_Files->T_PATH		:= aFiles[i][2]
	T_Files->T_OBRIG	:= if( aFiles[i][5], 'S', 'N' )
	T_Files->T_ORDER	:= aFiles[i][6]
*/
for i := 1 to len( aFiles )
	if lEnd
		exit
	endif
	
	if !lRobo
		IncProc( 'Lendo "'+Alltrim(aFiles[i,1])+'"...' )
	endif

	if aOk[i] <> cMarca
		loop
	endif
	
	aAdd( aRet, { aFiles[i,4], '', Alltrim(aDrv[i]), 0 } )
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSo cria o Arquivo de Trabalho fisicamente se o Driver for ARQUIVO TEXTO, caso contrario, apenas pega um nome de arquivo temporarioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	if Alltrim( aDrv[i] ) == Alltrim( aDriver[1] )	// TXT

		aRet[len(aRet),2]	:= CriaTrab( aFiles[i,3], .T. )
		dbUseArea( .T., "DBFCDX", aRet[len(aRet),2], aRet[len(aRet),1], .T. )
		dbSelectArea( aRet[len(aRet),1] )
		cPath := aFiles[i,2]
		append from &(Alltrim(cPath)) SDF
		aRet[len(aRet),4]	:= RecCount()

	elseif Alltrim( aDrv[i] ) == Alltrim( aDriver[2] )	// DBF

		aRet[len(aRet),2]	:= Alltrim( aFiles[i,2] )
		dbUseArea( .T., "DBFCDX", aRet[len(aRet),2], aRet[len(aRet),1], .T. )
		dbSelectArea( aRet[len(aRet),1] )
		aRet[len(aRet),4]	:= RecCount()

	else	// TOP

		if lOracle .and. !lGravaLog .and. lProcedure
			// Controle de status das threads.
			if !TCCanOpen( "IMP_STATUS" )
				TCSQLExec( "create table IMP_STATUS ( TIPO Char(2), THRD Integer, MINREC Integer, MAXREC Integer, LASTREC Integer, HORA date )" )
				TCSQLExec( "create index IMP_STATUS1 into IMP_STATUS ( TIPO, THRD )" )
			endif
			
			if !TCCanOpen( "IMP_LOG32" )
				TCSQLExec( "create table IMP_LOG32 ( MSG_LOG varchar2(500) )" )
			endif

			if !TCCanOpen( "IMP_LOG37" )
				TCSQLExec( "create table IMP_LOG37 ( MSG_LOG varchar2(500) )" )
			endif

			if !TCCanOpen( "IMP_LOG38" )
				TCSQLExec( "create table IMP_LOG38 ( MSG_LOG varchar2(500) )" )
			endif
			
			cProced := "create or replace procedure grava_log "
			cProced += Chr(10) + "( "
			cProced += Chr(10) + " cTabela in Char, "
			cProced += Chr(10) + " cMsgErr in Char "
			cProced += Chr(10) + ") is "
			cProced += Chr(10) + "begin "
			cProced += Chr(10) + " if cTabela = '32' then "
			cProced += Chr(10) + "   insert into IMP_LOG32 ( MSG_LOG ) values ( cMsgErr ); "
			cProced += Chr(10) + " elsif cTabela = '37' then "
			cProced += Chr(10) + "   insert into IMP_LOG37 ( MSG_LOG ) values ( cMsgErr ); "
			cProced += Chr(10) + " elsif cTabela = '38' then "
			cProced += Chr(10) + "   insert into IMP_LOG38 ( MSG_LOG ) values ( cMsgErr ); "
			cProced += Chr(10) + " end if; "
			cProced += Chr(10) + " commit; "
			cProced += Chr(10) + "end grava_log; "
			
			lGravaLog := .T.
		endif

		aRet[len(aRet),2]	:= Alltrim( aFiles[i,2] )
		if lOracle .and. lProcedure
			cQuery := ChangeQuery( "Select distinct ' ' as NADA From "+RetSQLName("JA3") )
			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), aRet[len(aRet),1], .T. )

			cQuery := ChangeQuery( "Select Max(R_E_C_N_O_) as RCount From "+Alltrim( aFiles[i,2] ) )
		else
			cWhere := ""
			if len(aFiles[i]) > 6 .and. ValType( aFiles[i,7] ) == "B"
				cWhere := Eval( aFiles[i,7] )
			endif
			
			if Empty( aFiles[i,6] )
				cQuery := ChangeQuery( "Select * From "+Alltrim( aFiles[i,2] )+" QRY "+if( !Empty( cWhere ), " where "+cWhere, "" ) )
			else
				cQuery := ChangeQuery( "Select * From "+Alltrim( aFiles[i,2] )+" QRY "+if( !Empty( cWhere ), " where "+cWhere, "" )+" Order By "+Alltrim( aFiles[i,6] ) )
			endif

			// DEBUG
			AcaLog( 'xDebug.log', 'Query do arquivo '+Alltrim(aFiles[i,2])+Chr(13)+Chr(10)+cQuery+Chr(13)+Chr(10)+Chr(13)+Chr(10) )

			dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), aRet[len(aRet),1], .T. )
			
			for j := 1 to len( aFiles[i,3] )
				if aFiles[i,3,j,2]$"DN"
					TCSetField( aRet[len(aRet),1], aFiles[i,3,j,1], aFiles[i,3,j,2], aFiles[i,3,j,3], aFiles[i,3,j,4] )
				endif
			next j

			cQuery := ChangeQuery( "Select Count(*) as RCount From ("+cQuery+")" )
		endif
	
		// Conta quantos registros existem no arquivo		
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), "TRBCount", .T. )
		TCSetField( "TRBCount", "RCount", "N", 14, 0 )
		aRet[len(aRet),4]	:= TRBCount->RCount
		TRBCount->( dbCloseArea() )
	endif

next i

Return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACGetFMk บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSeleciona o item do MarkBrowse e permite alterar a          บฑฑ
ฑฑบ          ณlocalizacao do arquivo texto.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxACGetF                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xACGetFMk( cMarca, aDriver )
Local cPath		:= T_Files->T_PATH
Local lImport	:= T_Files->T_OK == cMarca .or. T_Files->T_OBRIG == 'S'
Local nOpcA		:= 0
Local cDriver	:= T_Files->T_DRIVER
Local oDlgMk, oImport, oPath, oBtBrw, oBtOk, oBtCan, oDriver

define msDialog oDlgMk title Alltrim( T_Files->T_DESC ) from 00,00 to 060,500 pixel

define sButton oBtOk  from 003,218 type 1 action (nOpcA := 1, oDlgMk:End()) enable of oDlgMk pixel
define sButton oBtCan from 018,218 type 2 action (nOpcA := 0, oDlgMk:End()) enable of oDlgMk pixel

@ 005, 005 CheckBox oImport var lImport prompt 'Importar este arquivo' size 060,08 of oDlgMk pixel when ( T_Files->T_OBRIG <> 'S' )
@ 005, 120 Say "Driver:" size 030,07 of oDlgMk pixel
@ 004, 140 ComboBox oDriver var cDriver items aDriver size 70,08 of oDlgMk pixel

define sButton oBtBrw from 018,004 type 4 action ( cPath := if( cDriver <> aDriver[3] ,cGetFile(cPath), U_xACGetTop() ), oPath:Refresh() ) enable of oDlgMk pixel

@ 020, 035 msGet oPath var cPath size 175,08 of oDlgMk pixel

activate msdialog oDlgMk center

if nOpcA == 1
	RecLock( "T_Files", .F. )
	T_Files->T_PATH		:= PadR( cPath, len( T_Files->T_PATH ) )
	T_Files->T_DRIVER	:= cDriver
	T_Files->T_OK		:= if( lImport, cMarca, '' )
	T_Files->( msUnlock() )
endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACGetFOk บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida se os arquivos selecionados existem.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxACGetF                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xACGetFOk( cMarca, aDriver )
Local lRet	:= .T.
Local nPos	:= T_Files->( Recno() )
Local lTop

T_Files->( dbGoTop() )

while lRet .and. T_Files->( !eof() )
	lTop := "TOP"$Upper( T_Files->T_DRIVER )
	if T_Files->T_OK == cMarca .and. !lTop .and. !File( T_Files->T_PATH )
		lRet := .F.
		Aviso( 'Arquivo Invแlido', 'Nใo foi possํvel encontrar o arquivo "'+Alltrim( T_Files->T_PATH )+'". ', {'Ok'} )
	elseif T_Files->T_OK == cMarca .and. lTop .and. aScan( aTopTables, RTrim( T_Files->T_PATH ) ) == 0
		lRet := .F.
		Aviso( 'Tabela Invแlida', 'Nใo foi possํvel encontrar a tabela "'+Alltrim( T_Files->T_PATH )+'" no banco de dados. ', {'Ok'} )
	endif
	T_Files->( dbSkip() )
end

T_Files->( dbGoTo( nPos ) )

Return lRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACChkInt บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica a integridade de uma tabela, checando se existe    บฑฑ
ฑฑบ          ณchave duplicada ou campos obrigatorios nao preenchidos.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xACChkInt( cAlias, cChave, lOrdena, aValids, cLogFile, lEnd, nRecs )
Local lRet		:= .T.
Local i			:= 0
Local cBusca	:= ""
Local cIDX		:= CriaTrab( NIL, .F. )
Local nVld

Default nRecs := 0

Private lRobo := .F.

if Type( "nOpc" ) == "N"
	lRobo := nOpc <> 0
endif


if lOrdena
	if !lRobo
		MsgRun( 'Ordenando arquivo...',, {|| IndRegua( cAlias, cIDX, cChave ) } )
	else
		IndRegua( cAlias, cIDX, cChave )
	endif
endif

if !lRobo
	ProcRegua( Max( nRecs, ( cAlias )->( RecCount() ) ) )
endif
( cAlias )->( dbGoTop() )

while ( cAlias )->( !eof() ) .and. !lEnd

	i++
	if !lRobo
		IncProc( "Verificando linha "+Alltrim(Str(i,14,0))+" de "+Alltrim( Str( nRecs, 14, 0 ) )+"." )
	endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRealiza as validacoes pre-definidasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	for nVld := 1 to len( aValids )
		if lEnd
			exit
		endif
		if ( cAlias )->( !Eval( &("{ || "+aValids[nVld, 1]+" }") ) )
			lRet := .F.
			AcaLog( cLogFile, '  Inconsist๊ncia na chave '+cChave+' = '+( cAlias )->( &cChave )+': '+aValids[nVld, 2] )
		endif
	next nVld

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica chaves duplicadasณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cBusca	:= ( cAlias )->( &cChave )
	nReg	:= ( cAlias )->( Recno() )
	
	( cAlias )->( dbSkip() )
	
	if ( cAlias )->( &cChave ) == cBusca
		
		lRet := .F.
		
		// Continua verificando duplicidades da mesma chave...
		while ( cAlias )->( !eof() ) .and. ( cAlias )->( &cChave ) == cBusca .and. !lEnd
			i++
			if !lRobo
				IncProc( "Verificando linha "+Alltrim(Str(i,14,0))+" de "+Alltrim( Str( nRecs, 14, 0 ) )+"." )
			endif

			AcaLog( cLogFile, '  Inconsist๊ncia na chave '+cChave+' = '+( cAlias )->( &cChave )+': Chave duplicada.' )
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณRealiza as validacoes pre-definidasณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			for nVld := 1 to len( aValids )
				if lEnd
					exit
				endif
				if ( cAlias )->( !Eval( &("{ || "+aValids[nVld, 1]+" }") ) )
					lRet := .F.
					AcaLog( cLogFile, '  Inconsist๊ncia na chave '+cChave+' = '+( cAlias )->( &cChave )+': '+aValids[nVld, 2] )
				endif
			next nVld
			
			( cAlias )->( dbSkip() )
		end
	endif
end

if lEnd
	lRet := .F.
	AcaLog( cLogFile, '! Opera็ใo cancelada pelo operador.' )
endif

if lOrdena
	FErase( cIDX + OrdBagExt() )
endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACChkCGC บAutor  ณRafael Rodrigues    บ Data ณ  09/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica a validade do CNPJ/CPF sem exibir mensagem de erro บฑฑ
ฑฑบ          ณcaso o CNPJ/CPF seja invalido.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xACChkCGC( cCGC )
Local nTam, nCnt, i, j, nSum, nDIG
Local cCPF := ""
Local cDVC := ""
Local cDIG := ""
Local lRet := .F.

nTam := Len( AllTrim( cCGC ) )

cDVC := SubStr( cCGC, 13, 02 )
cCGC := SubStr( cCGC, 01, 12 )

for j := 12 to 13
	nCnt := 1
	nSum := 0
	for i := j to 1 Step -1
		nCnt++
		if nCnt > 9
			nCnt := 2
		endif
		nSum += ( val( substr( cCGC,i,1) ) * nCnt )
	next i
	nDIG := if( ( nSum % 11 ) < 2, 0, 11 - ( nSum % 11 ) )
	cCGC := cCGC + STR( nDIG, 1 )
	cDIG := cDIG + STR( nDIG, 1 )
next j

lRet := cDIG == cDVC

if !lRet
	if nTam < 14
		cDVC := SubStr( cCGC, 10, 2 )
		cCPF := SubStr( cCGC, 01, 9 )
		cDIG := ""

		for j := 10 to 11
			nCnt := j
			nSum := 0
			for i:= 1 to len( trim( cCPF ) )
				nSum += ( Val( SubStr( cCPF, i, 1 ) ) * nCnt )
				nCnt--
			next i
			nDIG := if( ( nSum % 11 ) < 2, 0, 11 - ( nSum % 11 ) )
			cCPF := cCPF + STR( nDIG, 1 )
			cDIG := cDIG + STR( nDIG, 1 )
		next j

		lRet := cDIG == cDVC
	endif
endif

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACIsHora บAutor  ณRafael Rodrigues    บ Data ณ  17/12/02   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica se o horario passado como parametro eh valido.     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xACIsHora( cHorario, lEmpty )
Local lRet	:= .T.
Local cHora	:= Subs( cHorario, 1, 2 )
Local cMin	:= Subs( cHorario, 4, 2 )                  
Default lEmpty := .F.

lRet := lRet .and. Subs( cHorario, 3, 1 ) == ':'
lRet := lRet .and. ( cHora == StrZero( Val( cHora ), 2 ) .or. if( lEmpty, cHora == Space(2), .F. ) )
lRet := lRet .and. ( cMin == StrZero( Val( cMin ), 2 ) .or. if( lEmpty, cMin == Space(2), .F. ) )
lRet := lRet .and. Val( cHora ) <= 23
lRet := lRet .and. Val( cMin ) <= 59

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACGetTop บAutor  ณRafael Rodrigues    บ Data ณ 19/JAN/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPermite ao usuario selecionar tabelas do bando de dados via บฑฑ
ฑฑบ          ณTop.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xACGetTop( cChave )
Local cRet	:= ""
Local aTabelas 	:= {}
Local oDlgF3, oList, oChave, oBtn
Local aCpoBrw	:= {}
Local nOpcB		:= 0

Default cChave	:= ""

cChave := PadR( cChave, 255 )

aAdd( aCpoBrw, { "TABELA",, "Tabela", "" } )

define msDialog oDlgF3 title "Sele็ใo de Tabelas" from 00,00 to 300,400 pixel

@ 03,03 LISTBOX oList Fields HEADER "Tabela" SIZE 166,127 NOSCROLL OF oDlgF3 PIXEL

oList:SetArray(aTopTables)
oList:bLine := { || { aTopTables[oList:nAt] } }
oList:blDblClick := { || nOpcB := oList:nAt, oDlgF3:End() }

@ 137,004 say "Localizar:" size 40,08 of oDlgF3 pixel
@ 137,042 get oChave var cChave size 125,08 of oDlgF3 pixel valid ( oList:nAt := Max( 1, aScan( aTopTables, RTrim( cChave ) ) ), oList:Refresh(), .T. )
define sbutton oBtOk     from 003,170 type 1 enable action ( nOpcB := oList:nAt, oDlgF3:End() ) of oDlgF3 pixel
define sbutton oBtCancel from 017,170 type 2 enable action ( nOpcB := 0, oDlgF3:End() ) of oDlgF3 pixel

activate msdialog oDlgF3 center

if nOpcB > 0
	cRet := PadR( aTopTables[nOpcB], len( T_Files->T_PATH ) )
endif

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACLoadTopบAutor  ณRafael Rodrigues    บ Data ณ 19/JAN/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLe as tabelas do Top e armazena na matriz aTopTables        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGestao Educacional                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function xACLoadTop()
Local i := 6000

aTopTables := {}

TOP_FILES->( dbGoTop() )

ProcRegua( i )

while TOP_FILES->( !eof() )	
	IncProc( "Carregando tabela "+Alltrim( TOP_FILES->FNAMF1 ) )
	aAdd( aTopTables, Alltrim( TOP_FILES->FNAMF1 ) )
	TOP_FILES->( dbSkip() )
end

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxSetSize  บAutor  ณRafael Rodrigues    บ Data ณ 29/Out/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta os tamanhos dos campos da estrutura de acordo com as บฑฑ
ฑฑบ          ณconfiguracoes do SX3.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณGenerico                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xSetSize( aStru )
Local aTemp := aClone( aStru )
Local i

SX3->( dbSetOrder(2) )

for i := 1 to len( aTemp )
	if SX3->( dbSeek( aTemp[i,1] ) )
		aTemp[i,3] := SX3->X3_TAMANHO
		aTemp[i,4] := SX3->X3_DECIMAL
	endif
next i

Return aClone( aTemp )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACRobo   บAutor  ณRafael Rodrigues    บ Data ณ 01/Dez/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRobot para importacao sequencial de varios processos        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณMigracao de bases                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xACRobo()
Local cMarca	:= GetMark()
Local aProcs	:= {}
Local lEnd		:= .F.
Local nOpcA		:= 0
Local i
Local oDlgRobo
Local oEnable   := LoadBitmap( GetResources(), "LBOK" )//Figuras para cancelamento do item
Local oDisable  := LoadBitmap( GetResources(), "LBNO" )//Figuras para cancelamento do item
Local aButtons := {	{ 'PROJETPMS', { || Pergunte("XACMIG",.T.) }, "Parโmetros" } }
Local xPar01, xPar02, xPar03, xPar04

AjustaSX()

aAdd( aProcs, { .F., "XAC10400", "Disciplinas"						, {}, {} } )
aAdd( aProcs, { .F., "XAC10800", "Cursos"	  						, {}, {} } )
aAdd( aProcs, { .F., "XAC10900", "Grades curriculares dos cursos"	, {}, {"XAC10800"} } )
aAdd( aProcs, { .F., "XAC12000", "Cursos vigentes"					, {}, {"XAC10900","XAC10800"} } )
aAdd( aProcs, { .F., "XAC12200", "Disciplinas dos cursos vigentes"	, {}, {"XAC10900","XAC10800","XAC12000"} } )
aAdd( aProcs, { .F., "XAC12300", "Avalia็๕es"						, {}, {"XAC12000","XAC10900","XAC10800"} } )
aAdd( aProcs, { .F., "XAC12400", "Cursos vigentes x salas"			, {}, {"XAC12000","XAC10900","XAC10800"} } )
aAdd( aProcs, { .F., "XAC12600", "Cursos vigentes x financeiro"		, {}, {"XAC12000","XAC10900","XAC10800"} } )
aAdd( aProcs, { .F., "XAC12900", "Grades de aulas"					, {}, {"XAC12400","XAC12000","XAC10900","XAC10800"} } )
aAdd( aProcs, { .F., "XAC13100", "Alunos"							, {}, {} } )
aAdd( aProcs, { .F., "XAC13200", "Matrํculas dos alunos"			, {}, {"XAC13100","XAC12900","XAC12400","XAC12000","XAC10900","XAC10800"} } )
aAdd( aProcs, { .F., "XAC13700", "Alunos x faltas"					, {}, {"XAC13200","XAC13100","XAC12900","XAC12400","XAC12000","XAC10900","XAC10800"} } )
aAdd( aProcs, { .F., "XAC13800", "Alunos x notas"					, {}, {"XAC13200","XAC13100","XAC12900","XAC12400","XAC12000","XAC10900","XAC10800"} } )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria o arquivo de trabalho para as tabelas no Topณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if Select( "TOP_FILES" ) == 0
	dbUseArea( .T., "TopConn", "TOP_FILES", "TOP_FILES", .T. )
endif

if aTopTables == nil .or. Empty( aTopTables )
	Processa( {|| xACLoadTop() } )
endif

define msDialog oDlgRobo title 'Importa็ใo seqüencial de processos' from 00,00 to 300,500 pixel

@ 015,003 say 'Processos a Importar' size 060,07 of oDlgRobo pixel
@ 025,003 listbox oListBox fields HEADER "","Processo" size 244,122 of oDlgRobo pixel

oListBox:SetArray(aProcs)
oListBox:bLine      := { || { if( aProcs[oListBox:nAt,1], oEnable, oDisable ), aProcs[oListBox:nAt,3] } }
oListBox:blDblClick := { || ( if( aProcs[oListBox:nAt,1], ( aEval( aProcs[oListBox:nAt,4], {|x| (x[1])->( dbCloseArea()) } ), aProcs[oListBox:nAt,4] := {} ) ,aProcs[oListBox:nAt,4] := Eval( &("{|| U_"+aProcs[oListBox:nAt,2]+"(1) }") ) ), aProcs[oListBox:nAt,1] := !Empty(aProcs[oListBox:nAt,4]), oListBox:Refresh() ) }

activate msDialog oDlgRobo center on init EnchoiceBar(oDlgRobo, { || nOpcA := 1, oDlgRobo:End() }, { || oDlgRobo:End() },,aButtons)

if nOpcA == 1
	if Aviso( "Agendamento", "Deseja agendar a importa็เo para mais tarde ou executar agora?", {"Agendar","Imediato"} ) == 1
		xPar01 := mv_par01
		xPar02 := mv_par02
		xPar03 := mv_par03
		xPar04 := mv_par04
		if !Pergunte("XACAGE",.T.)
			MsgStop("Agendamento cancelado. Processo nใo serแ iniciado!")
			Return
		else
			lEnd := .F.
			Processa( {|lEnd| Schecule( @lEnd, mv_par01, mv_par02 ) }, "Agendamento de migra็ใo...",,.T. )
			if lEnd
				MsgStop("Agendamento cancelado. Processo nใo serแ iniciado!")
				Return
			endif
		endif
		mv_par01 := xPar01
		mv_par02 := xPar02
		mv_par03 := xPar03
		mv_par04 := xPar04
	endif
	lEnd := .F.
	Processa( {|lEnd| DoProcess( aProcs, @lEnd ) },"Importa็เo",,.T. )
endif

Aviso( "Concluido!","O processamento foi concluํdo. Verifique os arquivos de log.", {"Ok"} )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDoProcess บAutor  ณRafael Rodrigues    บ Data ณ 20/Dez/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonitora os prcessos em andamento.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxACRobo                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DoProcess( aProcs, lEnd )
Local i,j,k		:= 0
Local lOk
Local aRunning	:= {}
Local aConclu	:= {}
Local lRet
Local aTables	:= {}

// Prepara todas as tabelas J para iniciarem no environment das threads
SX2->( dbSetOrder(1) )
SX2->( dbSeek( "J" ) )
while SX2->( !eof() .and. Left( X2_CHAVE, 1 ) == "J" )
	aAdd( aTables, SX2->X2_CHAVE )
	SX2->( dbSkip() )
end

// Seleciona os processos que nao serao importados
aEval( aProcs, {|x| if( !x[1], aAdd( aConClu, x[2] ), nil ) } )

ProcRegua( 10000 )

while !lEnd .and. !KillApp() .and. Len( aConclu ) < Len( aProcs )
	
	// Verifica processos a iniciar
	for i := 1 to len( aProcs )
		IncProc( "Verificando processos em andamento"+Repl( ".", mod(k++,4) ) )
	
		// Se o processo foi selecionado e ainda nใo estiver rodando...
		if aProcs[i,1] .and. aScan( aRunning, {|x| x[1] == aProcs[i,2] } ) == 0
		
			// Verifica pre-requisitos
			lOk := .T.
			for j := 1 to len( aProcs[i,5] )	
				lOk := lOk .and. aScan( aConclu, aProcs[i,5,j] ) > 0
			next j

			// Se pre-requisitos ok, inicia o processo
			if lOk
				aAdd( aRunning, { aProcs[i,2], CriaTrab(,.F.), aProcs[i,4] } )
				StartJob( "U_xACStart", GetEnvServer(), .F., { SM0->M0_CODIGO, SM0->M0_CODFIL, aRunning[len(aRunning)], aTables } )
			endif
		endif
	next i
	
	// Verifica processos em andamento para identificar finalizados
	for i := 1 to len( aRunning )
	
		// Verifica se o processo ainda nao foi concluido
		if aScan( aConclu, aRunning[i,1] ) == 0
		
			// Verifica se o arquivo OK estแ disponivel.
			if File( aRunning[i,2]+".ok" )
				FErase( aRunning[i,2]+".ok" )
				aAdd( aConclu, aRunning[i,1] )
			endif
		endif
	next i

	// Aguarda 10 segundos
	for i := 1 to 10
		if !lEnd .and. !KillApp()
			IncProc( "Verificando processos em andamento"+Repl( ".", mod(k++,4) ) )
			Sleep( 1000 )
		endif
	next i
	k := 0
end

Return Len( aConclu ) == Len( aProcs )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxACStart  บAutor  ณRafael Rodrigues    บ Data ณ 20/Dez/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonitora os prcessos em andamento.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDoProcess                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function xACStart( aDados )
Local nHdl

RpcSetEnv( aDados[1], aDados[2],,,,, aDados[4] )

nHdl := msFCreate( aDados[3,2] )

Eval( &( "{ || U_"+aDados[3,1]+"(2, aDados[3,3]) }" )  )

FClose( nHdl )
Ferase( aDados[3,2] )
AcaLog( aDados[3,2]+".ok", aDados[3,1]+" - Processamento concluido" )

RPCClearEnv()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXACXFUN   บAutor  ณMicrosiga           บ Data ณ  12/21/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function xOpen( aTables, aFiles, aDriver, lProcedure )
Local cMarca := "ok"
Local i
Local aOk := {}
Local aDrv := {}

// aFiles
// 1 - desc
// 2 - path
// 3 - struct
// 4 - alias
// 5 - obrigat
// 6 - order
// 7 - where

// aTables
// 1 - alias
// 2 - path
// 3 - driver
// 4 - reccount
for i := 1 to len( aFiles )
	if aScan( aTables, {|x| x[1] == aFiles[i,4] } ) > 0
		aAdd( aOk, cMarca )
		aAdd( aDrv, aTables[i,3] )
	else
		aAdd( aOk, "  " )
		aAdd( aDrv, aDriver[1] )
	endif
next i
		
U_xACGetR( .F., aFiles, cMarca, aDriver, lProcedure, aDrv, aOk, .T. )

Return
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX  บAutor  ณRafael Rodrigues    บ Data ณ 01/Dez/2004 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria o grupo de perguntas dos programas de importacao       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณxACXFUN                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX()
Local aPerg := {}
Local i

aAdd( aPerg, {"Curso Inicial      ?","C",06,0,"G","","","","","","JAF"} )
aAdd( aPerg, {"Curso Final        ?","C",06,0,"G","","","","","","JAF"} )
aAdd( aPerg, {"Unidade Inicial    ?","C",06,0,"G","","","","","","JA3"} )
aAdd( aPerg, {"Unidade Final      ?","C",06,0,"G","","","","","","JA3"} )

for i := 1 to len( aPerg )
	if SX1->( !dbSeek( "XACMIG"+StrZero(i,2) ) )
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := "XACMIG"
		SX1->X1_ORDEM   := StrZero(i,2)
		SX1->X1_PERGUNT := aPerg[i,1]
		SX1->X1_VARIAVL := "mv_ch"+if( i < 10, Str(i,1), Chr(55+i) )
		SX1->X1_TIPO    := aPerg[i,2]
		SX1->X1_TAMANHO := aPerg[i,3]
		SX1->X1_DECIMAL := aPerg[i,4]
		SX1->X1_GSC     := aPerg[i,5]
		SX1->X1_VAR01   := "mv_par"+StrZero(i,2)
		SX1->X1_DEF01   := aPerg[i,6]
		SX1->X1_DEF02   := aPerg[i,7]
		SX1->X1_DEF03   := aPerg[i,8]
		SX1->X1_DEF04   := aPerg[i,9]
		SX1->X1_DEF05   := aPerg[i,10]
		SX1->X1_F3      := aPerg[i,11]
		SX1->( msUnlock() )
	endif
next i

// Perguntas de agendamento
aPerg := {}
aAdd( aPerg, {"Data para execu็ใo ?","D",08,0,"G","","","","","",""} )
aAdd( aPerg, {"Hora para execu็ใo ?","C",05,0,"G","","","","","",""} )

for i := 1 to len( aPerg )
	if SX1->( !dbSeek( "XACAGE"+StrZero(i,2) ) )
		RecLock("SX1",.T.)
		SX1->X1_GRUPO   := "XACAGE"
		SX1->X1_ORDEM   := StrZero(i,2)
		SX1->X1_PERGUNT := aPerg[i,1]
		SX1->X1_VARIAVL := "mv_ch"+if( i < 10, Str(i,1), Chr(55+i) )
		SX1->X1_TIPO    := aPerg[i,2]
		SX1->X1_TAMANHO := aPerg[i,3]
		SX1->X1_DECIMAL := aPerg[i,4]
		SX1->X1_GSC     := aPerg[i,5]
		SX1->X1_VAR01   := "mv_par"+StrZero(i,2)
		SX1->X1_DEF01   := aPerg[i,6]
		SX1->X1_DEF02   := aPerg[i,7]
		SX1->X1_DEF03   := aPerg[i,8]
		SX1->X1_DEF04   := aPerg[i,9]
		SX1->X1_DEF05   := aPerg[i,10]
		SX1->X1_F3      := aPerg[i,11]
		SX1->( msUnlock() )
	endif
next i

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXACXFUN   บAutor  ณMicrosiga           บ Data ณ  01/27/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Schecule( lEnd, dData, cHora )

ProcRegua( 10000 )

while Date() < dData .or. cHora < Time()	
	IncProc( "Agendado para as "+cHora+" horas de "+dtoc(dData)+"." )
	Sleep( 1000 )
end

Return
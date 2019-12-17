#Include 'Protheus.ch'
/*/{Protheus.doc}	VLDUSER
Verifica se Usuariotem permissão para alterar o campo C5_ZZSTAT

@author				Gerson Schiavo
@since				05/04/2016
/*/

User Function VLDUSER()

Local lRet:= .t.                  

dbSelectArea("ZZU")
if !dbSeek(xFilial("ZZU")+__CUSERID)
	lRet:= .f.
endif

Return(lRet) 
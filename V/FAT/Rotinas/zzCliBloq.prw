#include 'topconn.ch'
#Include 'rwmake.ch'

/*
==================================================================================================================================
 zzCliBloq, Function
==================================================================================================================================
 Criação   	: Aug 16, 2016 - André Zingra de Lima.
 Nome      	: zzCliBloq
 Tipo      	: Function
 Descrição 	: ExecBlock para validar o credito do cliente no momento do elaboração de PV ou Orçamento
 Parâmetros	: _cTable = Tabela trabalhada
 Retorno   	: nenhum
 Observ.   	: Rotina desenvolvida para exibir a msg de restrição no financeiro.
 Config.	: Criar os gatilhos para executar o ExecBlock nos campos: 
 			: C5_CLIENTE = if(existblock("zzCliBloq"),u_zzCliBloq("SC5"), "")    
 			: CJ_CLIENTE = if(existblock("zzCliBloq"),u_zzCliBloq("SCJ"), "")    
---------------------------------------------------------------------------------------------------------------------------------- 
*/                                   
User Function zzCliBloq(_cTable)
	// Salva areas abertas
	Local _aArea    := GetArea()
	Local _aAreaSA1 := SA1->(GetArea())
	Local _aAreaSC5 := SC5->(GetArea())
	Local _aAreaSCJ	:= SCJ->(GetArea())
	Local _lYesNo	:= .F.
	Local cCliente	:= Space(06)

	dbSelectArea("SA1")
	dbSetOrder(1)

	If _cTable == "SCJ"          
		cCliente := M->CJ_CLIENTE
		dbSeek(xFilial("SA1")+M->CJ_CLIENTE+M->CJ_LOJA)
		
	Elseif _cTable == "SC5"
	
		cCliente := M->C5_CLIENTE
		dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI)
	Endif
	
	If Found()
		If SA1->A1_RISCO$"E" .OR. SA1->A1_LC == 0  .OR. SA1->A1_VENCLC<=DDATABASE
			
			_lYesNo := MsgBox("Este cliente está BLOQUEADO pelo Financeiro!!! Continua????", "Confirma","YESNO")
			
			If _lYesNo	== .T.
				If _cTable == "SCJ"
					M->CJ_ZZFINAN  := "S" 	&& Grava a posição do financeiro no momento
					
				Elseif _cTable == "SC5"
					M->C5_ZZFINAN  := "S" 	&& Grava a posição do financeiro no momento
				Endif
            
			Else
				cCliente  := "" 		&& Limpa o campo codigo			
			Endif
			
		Else	&& Grava que o cliente não estava bloqueado
		 
			If _cTable == "SCJ"
				M->CJ_ZZFINAN  := "N" 	&& Grava a posição do financeiro no momento
					
			Elseif _cTable == "SC5"	
				M->C5_ZZFINAN  := "N" 	&& Grava a posição do financeiro no momento
			Endif

		Endif		
	Endif
	 
	// Restaura Areas Abertas
	RestArea (_aAreaSC5)
	RestArea (_aAreaSCJ)
	RestArea (_aAreaSA1)
	RestArea (_aArea)
Return(cCliente)	

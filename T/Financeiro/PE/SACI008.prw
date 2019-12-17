#include "Protheus.ch"
                  

User Function SACI008()
Local aVetor   := {}   
Local cNumProx := "" 
Local dDataVenc 
Local cNum     := GetMv("ZZ_NUMCAUC")
Local cPref    := GetMv("ZZ_PREFCAU") 
Local cNat     := GetMv("ZZ_NATCAUC") 
Local cCliente := SE1->E1_CLIENTE 
Local cLoja    := SE1->E1_LOJA
Private lMsErroAuto := .F.

if cMotBx $ "CAUCAO"
	if Perg()
		dDataVenc := MV_PAR01
		Begin Transaction 
			
			
			aVetor  := {	{"E1_PREFIXO" ,cPref           ,Nil},;
							{"E1_NUM"	  ,cNum            ,Nil},;
							{"E1_PARCELA" ,"01"            ,Nil},;
							{"E1_TIPO"	  ,"DP "           ,Nil},;
							{"E1_NATUREZ" ,cNat            ,Nil},;
				          	{"E1_CLIENTE" ,cCliente        ,Nil},;
			             	{"E1_LOJA"	  ,cLoja           ,Nil},;
			             	{"E1_LA"	  ,"S"             ,Nil},;
				          	{"E1_EMISSAO" ,dDataBase       ,Nil},;
					       	{"E1_VENCTO"  ,dDataVenc       ,Nil},;
					       	{"E1_VENCREA" ,dDataVenc       ,Nil},;
					       	{"E1_VALOR"	  ,nValRec         ,Nil }}
			
			MSExecAuto({|x,y| Fina040(x,y)},aVetor,3) //Inclusao
			       
			
			If lMsErroAuto
			   MostraErro()
			   DisarmTransaction()
			Else
				cNumProx := Soma1(cNum)
				PutMv("ZZ_NUMCAUC",cNumProx)
			Endif
		end Transaction 
	endIf	
endif	

Return                       


Static Function Perg()
	Local aParamBox := {}
	Local lRet  	 := .T.                        
	
	AADD(aParamBox,{1,"Informe a data do Vencimento do titulo " 		 	,CTOD("//")    ,	"",				" ",	"",		"",	80,	.F.	})

   lRet := ParamBox(aParamBox,"Titulo Cau��o",NIL,,,,,,,"SACI008",.T.,.T.)   
return lRet   

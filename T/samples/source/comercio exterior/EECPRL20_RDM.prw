//Revis�o - Alcir Alves - 05-12-05 - desconsiderar dados do ECC para eventos de cambio que n�o dependem do mesmo
//Revis�o - Alcir Alves - 06-12-05 - inclus�o de filtros por EEQ_TP_CON
//Revis�o - Henrique V. Ranieri - 19/06/06 - FINIMP, novos campos do SIGAEFF

#INCLUDE "EECRDM.CH"  
#INCLUDE "EECPRL20.CH"                    

/*
Programa  : EECPRL20_RDM.
Objetivo  : Relat�rio de Controle de Cambiais
Autor     : Jo�o Pedro Macimiano Trabbold
Data/Hora : 04/08/04; 10:38 
Obs       : 
*/

/*
Funcao      : EECPRL20().
Parametros  : Nenhum.
Retorno     : .f.
Objetivos   : Impress�o do Relat�rio de Controle de Cambiais
Autor       : Jo�o Pedro Macimiano Trabbold.
Data/Hora   : 04/08/04; 10:38 
*/
*-----------------------*
User Function EECPRL20()
*-----------------------*   
Local nValFob := 0, nValCom := 0 ,lAppend := .t.  
Local cProcAtual := "", cProcPast := ""
Local   aOrd   := SaveOrd({"EEQ","EC6","EF3","EEC","SA1","SA2","SA6"})
//Alcir Alves - 05-12-05
Private lTPCONExt:=(EEQ->(fieldpos("EEQ_TP_CON"))>0)
Private oCbTpCon,cTpCon 
Private aTpCon:={"*Todos","1-Exportacao","2-Importacao","3-Recebimento","4-Remessa"}
//
Private lRet   := .t. ,lApaga:= .f., lFlag:=.f. , lCalc := .f. 
Private cArqRpt:="rel20.rpt",;
		  cTitRpt:= STR0001 //"Controle de Cambiais"
Private aArqs,;
        cNomDbfC := "CAMBIALC",;
        aCamposC := {{"SEQREL"     ,"C",08,0 },;
                     {"FILIAL"     ,"C",2,0 },;
                     {"PERIODO"    ,"C",25,0 },;
                     {"IMPORTADOR" ,"C",AvSx3("A1_NOME",AV_TAMANHO),0 },;    
                     {"FORNECEDOR" ,"C",AvSx3("A2_NOME",AV_TAMANHO),0 },;
                     {"MOEDA"      ,"C",AvSx3("EEC_MOEDA",AV_TAMANHO)+2,0 },;
                     {"TITULOS"    ,"C",25,0 },;
                     {"VINC_FIN"   ,"C",5 ,0 }}
                     
Private cNomDbfD := "CAMBIALD",;
        aCamposD := {{"SEQREL"     ,"C", 8,0},;
                     {"EEQ_PREEMB" ,"C",AvSx3("EEQ_PREEMB",AV_TAMANHO),0 },;   
                     {"EEQ_IMPORT" ,"C",AvSx3("A1_NREDUZ" ,AV_TAMANHO),0 },;
                     {"EEQ_MOEDA"  ,"C",AvSx3("EEC_MOEDA" ,AV_TAMANHO),0 },;
                     {"A6_NREDUZ"  ,"C",AvSx3("A6_NREDUZ" ,AV_TAMANHO),0 },;
                     {"EEQ_RFBC"   ,"C",AvSx3("EEQ_RFBC"  ,AV_TAMANHO),0 },;
                     {"EEQ_VLCAMB" ,"C",AvSx3("EEQ_VL"    ,AV_TAMANHO)+7,0 },;
                     {"EEQ_VLCOMS" ,"C",AVSX3("EEC_VALCOM",AV_TAMANHO)+7,0 },;
                     {"EEC_DTCONH" ,"C",AvSx3("EEC_DTCONH",AV_TAMANHO),0 },;
                     {"EEQ_VCT"    ,"C",AvSx3("EEQ_VCT"   ,AV_TAMANHO),0 },;
                     {"SALDO"      ,"C",AvSx3("EEQ_VL"    ,AV_TAMANHO)+7,0 },;
 							{"EEQ_DTCE"   ,"C",AvSx3("EEQ_DTCE"  ,AV_TAMANHO),0 },;   
 							{"DIASATRASO" ,"C",10,0 },; 
                     {"VALORJUROS" ,"C",AvSx3("EF3_VL_MOE",AV_TAMANHO)+7,0 },;   
                     {"EEQ_FORN"   ,"C",AvSx3("A2_NREDUZ" ,AV_TAMANHO),0 },;                               
                     {"EEC_CONDPA" ,"C",AvSx3("EEC_CONDPA",AV_TAMANHO),0 },;
                     {"EEC_DIASPA" ,"C",AvSx3("EEC_DIASPA",AV_TAMANHO),0 },;
                     {"EF3_CONTRA" ,"C",AvSx3("EF3_CONTRA",AV_TAMANHO),0 },;  
                     {"TP_CON","C",18,0 },;
                     {"FLAG","C",1,0 }}
                                          
Private dDtIni     := AVCTOD("  /  /  ")
Private dDtFim     := AVCTOD("  /  /  ")  
Private aFinanc    := {STR0002,STR0003,STR0004} //{"Ambos","Sim","N�o"}
Private cFinanc    := ""   
Private cImport    := Space(AVSX3("A1_COD"   ,AV_TAMANHO)) 
Private cFornece   := Space(AVSX3("A2_COD"   ,AV_TAMANHO))   
Private cForn      := ""
Private cImp       := ""
Private cMoeda     := Space(AVSX3("EEQ_MOEDA",AV_TAMANHO))  
Private lProc      := .f.
Private aTitulos   := {STR0005,STR0006}  //{"A Receber","A Pagar"}
Private cTitulos   := ""     
Private cAlias     := ""
Private lTrat      := .t. , lTratCom:= .t.   
Private nPos, nInd:=0     
Private nRec:=0      
Private nVlCamb :=0, dVencto := AVCTOD("  /  /  ")  

//HVR - Novos campos do FinImp
Private lEFFTpMod := EF1->( FieldPos("EF1_TPMODU") ) > 0 .AND. EF1->( FieldPos("EF1_SEQCNT") ) > 0 .AND.;
                     EF2->( FieldPos("EF2_TPMODU") ) > 0 .AND. EF2->( FieldPos("EF2_SEQCNT") ) > 0 .AND.;
                     EF3->( FieldPos("EF3_TPMODU") ) > 0 .AND. EF3->( FieldPos("EF3_SEQCNT") ) > 0 .AND.;
                     EF4->( FieldPos("EF4_TPMODU") ) > 0 .AND. EF4->( FieldPos("EF4_SEQCNT") ) > 0 .AND.;
                     EF6->( FieldPos("EF6_SEQCNT") ) > 0 .AND. EF3->( FieldPos("EF3_ORIGEM") ) > 0 .and.;
                     EF3->( FieldPos("EF3_ROF"   ) ) > 0

    


BEGIN SEQUENCE     
   lTrat    := EECFlags("FRESEGCOM")  // vari�vel que verifica os novos tratamentos de frete, seguro e comiss�o 
   lTratCom := EECFlags("COMISSAO")   // vari�vel que verifica os novos tratamentos de frete, seguro e comiss�o 
   aARQS := {} 
   AADD(aARQS,{cNOMDBFC,aCAMPOSC,"CAP","SEQREL"})
   AADD(aARQS,{cNOMDBFD,aCAMPOSD,"DET","SEQREL"})

   IF ! TelaGets()
      lRet := .F.
      Break  
   Endif     
   
   aRetCrw := CrwNewFile(aARQS)
   lApaga:= .t.
      
   cSEQREL :=GetSXENum("SY0","Y0_SEQREL")
   CONFIRMSX8()   

   CAP->(DBAPPEND())
   CAP->SEQREL := cSEQREL                                                       
   CAP->FILIAL:=cfilant
   //testa o filtro de data de vencimento do cambio que aparecer� no cabe�alho do relat�rio
   if empty(dDtIni)
      if !empty(dDtFim) //somente Data final preenchida
         CAP->PERIODO := STR0007 + DTOC(dDtFim)  //"at�"
      else //nenhuma data preenchida       
         CAP->PERIODO := STR0008 //"Todos"
      endif
   else
      if !empty(dDtFim)
         if dDtIni == dDtFim//DtIni e DtFim iguais
            CAP->PERIODO := DTOC(dDtFim)
         else //DtIni e DtFim <>
            CAP->PERIODO := STR0009 + DTOC(dDtIni) + STR0010 + DTOC(dDtFim) //"De " + DTOC(dDtIni) + " a " + DTOC(dDtFim)
         endif
      else//somente data inicial preenchida
         CAP->PERIODO :=  STR0011 + DTOC(dDtIni) //"Ap�s "
      endif
   endif     
    
   //testa o filtro de importador que aparecer� no cabe�alho do relat�rio
   if !empty(cImport)  
      SA1->(DBSEEK(xFilial("SA1")+cImport))
      CAP->IMPORTADOR := SA1->A1_NOME 
   else
      CAP->IMPORTADOR := STR0008 //"Todos"
   endif  
   
   //testa o filtro de Fornecedor que aparecer� no cabe�alho do relat�rio
   if !empty(cFornece)  
      SA2->(DBSEEK(xFilial("SA2")+cFornece))
      CAP->FORNECEDOR := SA2->A2_NOME 
   else
      CAP->FORNECEDOR := STR0008 //"Todos"
   endif
   if !empty(cFornece)
      CAP->MOEDA    := cMoeda 
   Else                
      CAP->MOEDA    := STR0012 //"Todas"  
   Endif
   CAP->VINC_FIN := cFinanc 
   CAP->TITULOS  := " - " + cTitulos
     
   #IFDEF TOP
      IF TCSRVTYPE() <> "AS/400"
         cCmd := MontaQuery() 
         cCmd := ChangeQuery(cCmd)
         dbUseArea(.T., "TOPCONN", TCGENQRY(,,cCmd), "QRY", .F., .T.) 
         cAlias:="QRY" 
      ELSE
         cAlias:="EEQ"
         EEQ->(DBSETORDER(1))         
         EEQ->(DBSEEK(xFilial("EEQ")))
      ENDIF
   #ELSE
      cAlias:="EEQ"
      EEQ->(DBSETORDER(1))         
      EEQ->(DBSEEK(xFilial("EEQ")))   
   #ENDIF  
      
      While (cAlias)->(!EOF()) .AND. xFilial("EEQ") == (cAlias)->EEQ_FILIAL
         //Alcir Alves - 05-12-05 - considera apena tipo 1 - Exporta��o
         //if lTPCONExt
         //   if (cAlias)->EEQ_TP_CON<>"1" .and. (cAlias)->EEQ_TP_CON<>"2" 
         //     (cAlias)->(DBSKIP())
         //      loop
         //   ENDIF
         //endif
         //
         EEC->(DbSetOrder(1))//filtros: Receita - importador, despesa - fornecedor(sem os novos tratamentos de frete, seguro, comiss�o)
         EEC->(DBSEEK(xFilial("EEC")+(cAlias)->EEQ_PREEMB))
         if !lTPCONExt .and. EEC->(eof())
            (cAlias)->(DbSkip())
            Loop 
         endif
         
         if lTPCONExt 
            if cTpCon==aTpCon[2] //"1-C�mbio de Exporta��o"
              IF (cAlias)->EEQ_TP_CON<>"1"
                 (cAlias)->(DbSkip())
                 Loop 
              ENDIF
            elseif cTpCon==aTpCon[3] //"2-C�mbio de Importa��o"
              IF (cAlias)->EEQ_TP_CON<>"2"
                 (cAlias)->(DbSkip())
                 Loop 
              ENDIF
            elseif cTpCon==aTpCon[4] //"3-Recebimento"
              IF (cAlias)->EEQ_TP_CON<>"3"
                 (cAlias)->(DbSkip())
                 Loop 
              ENDIF
            elseif cTpCon==aTpCon[5] //"4-Remessa"
              IF (cAlias)->EEQ_TP_CON<>"4"
                 (cAlias)->(DbSkip())
                 Loop 
              ENDIF
            endif
         endif
         
         If lTrat .OR. EEC->(EOF()) 
            EC6->(DbSetOrder(1)) //filtros: Receita - importador, despesa - fornecedor
            if EC6->(DbSeek(xFilial("EC6")+"EXPORT"+(cAlias)->EEQ_EVENT))  
               if EC6->EC6_RECDES == "1" .AND. (cTitulos == STR0006 .Or. If(!Empty(cImport),(cAlias)->EEQ_IMPORT <> cImport,.f.)) //"A Pagar"
                  (cAlias)->(DbSkip())
                  Loop 
               endif
               if EC6->EC6_RECDES == "2" .AND. (cTitulos == STR0005 .Or. If(!Empty(cFornece),(cAlias)->EEQ_FORN <> cFornece,.f.)) //"A Receber"
                  (cAlias)->(DbSkip())
                  Loop     
               endif
            endif   
         Else
            EC6->(DbSetOrder(1))
            if EC6->(DbSeek(xFilial("EC6")+"EXPORT"+(cAlias)->EEQ_EVENT))  
               if EC6->EC6_RECDES == "1" .AND. (cTitulos == STR0006 .Or. If(!Empty(cImport),EEC->EEC_IMPORT <> cImport,.f.)) //"A Pagar"
                  (cAlias)->(DbSkip())
                  Loop 
               endif
               if EC6->EC6_RECDES == "2" .AND. (cTitulos == STR0005 .Or. If(!Empty(cFornece),EEC->EEC_FORN <> cFornece,.f.)) //"A Receber"
                  (cAlias)->(DbSkip())
                  Loop     
               endif
            endif
         EndIf     
         //filtro: Vinculados a financiamento??
         if cFinanc <> STR0002 //"Ambos"  
            EF3->(DbSetOrder(3))
            if EF3->(DbSeek(xFilial("EF3")+IF(lEFFTpMod, IF((cAlias)->EEQ_TP_CON $ ("2/4"),"I","E"),"")+(cAlias)->EEQ_NRINVO+(cAlias)->EEQ_PARC)) //HVR
               if cFinanc == STR0004 //"N�o" 
                  (cAlias)->(DBSkip())
                  loop
               endif
            else
               if cFinanc == STR0003 //"Sim" 
                  (cAlias)->(DBSkip())
                  loop
               endif 
            endif
         endif   
         //Alcir Alves - 05-12-05 - por causa dos novos tipos de cambio TP_CON 1,2,3 e 4 ser� necess�rio for�ar
         //a valida��o manual para top e codebase
         If !FiltrosDBF()  // filtros para ambiente codebase
            loop
         Endif         
         
         /*
         #IFDEF TOP
            IF TCSRVTYPE() = "AS/400"      
               If !FiltrosDBF()  // filtros para ambiente codebase
                  loop
               Endif
            Endif
         #ELSE
            If !FiltrosDBF()  // filtros para ambiente codebase
               loop
            EndIf
         #ENDIF
         */
         cProcAtual := (cAlias)->EEQ_PREEMB         
         //Grava��o dos detalhes       
         DET->(DbAppend())   
         IF lTPCONExt //HVR
            if !empty((cAlias)->EEQ_TP_CON)
               if val((cAlias)->EEQ_TP_CON)<=(len(aTpCon)-1)
                  DET->TP_CON:=aTpCon[(val((cAlias)->EEQ_TP_CON)+1)]
               else
                  DET->TP_CON:="-"
               endif
            else
               DET->TP_CON:="-"
            endif
         ELSE
            DET->TP_CON:="-"
         ENDIF
         lFlag := !lFlag  
         If(lFlag, DET->FLAG := "X", DET->FLAG := "Y") //zebrado do relat�rio   
         DET->SEQREL     := cSEQREL 
         DET->EEQ_PREEMB := (cAlias)->EEQ_PREEMB
         SA6->(DbSetOrder(1))
         SA6->(DbSeek(xFilial("SA6")+(cAlias)->EEQ_BANC))
         DET->A6_NREDUZ  := SA6->A6_NREDUZ  //nome reduzido do banco
         DET->EEQ_RFBC   := LOWER((cAlias)->EEQ_RFBC) //refer�ncia banc�ria
         
         If Empty((cAlias)->EEQ_ORIGEM)  //c�lculo do valor cambial - in�cio
            If cAlias == "EEQ"
               nRec := (cAlias)->(RecNo())
            Else   
               EEQ->(DbGoTop())
               EEQ->(DbSetOrder(1))
               EEQ->(DbSeek(xFilial("EEQ")+(cAlias)->EEQ_PREEMB+(cAlias)->EEQ_PARC))
            Endif
            CalcCamb(.t.)
            If(cAlias == "EEQ",(cAlias)->(DbGoTo(nRec)),) 
         Endif
         if Empty((cAlias)->EEQ_PGT)  //n�o pago       
            DET->SALDO   := Alltrim(TRANSFORM((cAlias)->EEQ_VL,  AVSX3("EEQ_VL",  AV_PICTURE)))  
            If lCalc
               DET->EEQ_VLCAMB := Alltrim(TRANSFORM((cAlias)->EEQ_VL, AVSX3("EEQ_VL",  AV_PICTURE)))     
            Else
               DET->EEQ_VLCAMB := Alltrim(TRANSFORM(nVlCamb, AVSX3("EEQ_VL",  AV_PICTURE)))    
            Endif   
         Else      //pago
            DET->SALDO := "0"
            DET->EEQ_VLCAMB := Alltrim(TRANSFORM((cAlias)->EEQ_VL, AVSX3("EEQ_VL",  AV_PICTURE)))
         Endif  //c�lculo do valor cambial - fim 
         
         EEQ->(DbSetOrder(1))    
         lCalc := .f.
    
         #IFDEF TOP
            If TCSRVTYPE() <> "AS/400" 
               dVencto  := AVCTOD(SUBSTR((cAlias)->EEQ_VCT,7,2)+"/"+SUBSTR((cAlias)->EEQ_VCT,5,2)+"/"+SUBSTR((cAlias)->EEQ_VCT,3,2))
            Else
               dVencto  := (cAlias)->EEQ_VCT
            Endif  
         #ELSE
            dVencto :=  (cAlias)->EEQ_VCT  
         #ENDIF   
         If dDatabase > dVencto .and. Empty((cAlias)->EEQ_PGT) // c�lculo dos dias de atraso
            DET->DIASATRASO := AllTrim(Str(dDatabase - dVencto))+ If(dDatabase - dVencto <> 1,STR0013,STR0014) //" dias"," dia"
         Else
            DET->DIASATRASO := "-"
         Endif
         
         EEC->(DbSetOrder(1))
         EEC->(DbSeek(xFilial("EEC")+(cAlias)->EEQ_PREEMB))
         //c�culo do valor da comiss�o
         IF !EEC->(EOF())
            If lTrat //com tratamentos de frete, seguro e comiss�o, h� uma comiss�o pra cada parcela     
               nValcom := (cAlias)->EEQ_AREMET + (cAlias)->EEQ_ADEDUZ + (cAlias)->EEQ_CGRAFI 
               DET->EEQ_VLCOMS := Alltrim(Transform(nValcom,AVSX3("EEC_VALCOM",AV_PICTURE)))
            Else  //sem tratamentos de frete, de seguro e comiss�o
               If cProcAtual <> cProcPast //a cada mudanca de PREEMB, h� o c�lculo da comiss�o
                  If lTratCom  
                     DET->EEQ_VLCOMS := Alltrim(Transform(EEC->EEC_VALCOM,AVSX3("EEC_VALCOM",AV_PICTURE))) 
                  Else
                     nValFOB := (EEC->EEC_TOTPED+EEC->EEC_DESCON)-(EEC->EEC_FRPREV+EEC->EEC_FRPCOM+EEC->EEC_SEGPRE+EEC->EEC_DESPIN+AvGetCpo("EEC->EEC_DESP1")+AvGetCpo("EEC->EEC_DESP2"))
                     nValCom := (if(EEC->EEC_TIPCVL=="1",(EEC->EEC_VALCOM*nValFOB)/100,EEC->EEC_VALCOM))
                     DET->EEQ_VLCOMS := Alltrim(Transform(nValcom,AVSX3("EEC_VALCOM",AV_PICTURE)))   
                  Endif
               Endif
            Endif
            DET->EEC_CONDPA  :=  EEC->EEC_CONDPA  //condi��o de pagamento
            DET->EEC_DIASPA  :=  ALLTRIM(STR(EEC->EEC_DIASPA)) //dias da condi��o de pagamento
         else
            DET->EEQ_VLCOMS := Alltrim(Transform(0,AVSX3("EEC_VALCOM",AV_PICTURE)))   
            DET->EEC_CONDPA  :=  "-"
            DET->EEC_DIASPA  :=  "-"
         ENDIF
    
         #IFDEF TOP
            If TCSRVTYPE() = "AS/400"
               If EEC->(EOF()) .OR. Empty(EEC->EEC_DTCONH)          //datas
                  DET->EEC_DTCONH  := "-"
               Else
                  DET->EEC_DTCONH  := TRANSFORM(DTOC(EEC->EEC_DTCONH) ,AVSX3("EEC_DTCONH" ,AV_PICTURE))  
               EndIf 
               
               If Empty(EEQ->EEQ_DTCE)
                  DET->EEQ_DTCE  := "-"
               Else   
                  DET->EEQ_DTCE := TRANSFORM(DTOC((cAlias)->EEQ_DTCE),AVSX3("EEQ_DTCE",AV_PICTURE))
               EndIf 
               
               If Empty(EEQ->EEQ_VCT)
                  DET->EEQ_VCT  := "-"
               Else
                  DET->EEQ_VCT  := TRANSFORM(DTOC((cAlias)->EEQ_VCT) ,AVSX3("EEQ_VCT" ,AV_PICTURE))  
               EndIf  
            Else    
               if EEC->(EOF()) .OR. Empty(EEC->EEC_DTCONH)
                  DET->EEC_DTCONH  := "-"
               else
                  DET->EEC_DTCONH:= TRANSFORM(DTOC(EEC->EEC_DTCONH) ,AVSX3("EEC_DTCONH" ,AV_PICTURE))
               endif 
               
               if Empty((cAlias)->EEQ_DTCE)
                  DET->EEQ_DTCE  := "-"
               else
                  DET->EEQ_DTCE := SUBSTR((cAlias)->EEQ_DTCE,7,2)+"/"+SUBSTR((cAlias)->EEQ_DTCE,5,2)+"/"+SUBSTR((cAlias)->EEQ_DTCE,3,2)
               endif 
               
               if Empty((cAlias)->EEQ_VCT)
                  DET->EEQ_VCT  := "-"
               else
                  DET->EEQ_VCT  := SUBSTR((cAlias)->EEQ_VCT,7,2)+"/"+SUBSTR((cAlias)->EEQ_VCT,5,2)+"/"+SUBSTR((cAlias)->EEQ_VCT,3,2)
               endif 
               
            endif
         #ELSE 
            
            If EEC->(EOF()) .OR. EEC->(EOF())
               DET->EEC_DTCONH  := "-"
            Else
               DET->EEC_DTCONH  := TRANSFORM(DTOC(EEC->EEC_DTCONH) ,AVSX3("EEC_DTCONH" ,AV_PICTURE))  
            EndIf 
            
            If Empty(EEQ->EEQ_DTCE)
               DET->EEQ_DTCE  := "-"
            Else   
               DET->EEQ_DTCE := TRANSFORM(DTOC((cAlias)->EEQ_DTCE),AVSX3("EEQ_DTCE",AV_PICTURE))
            EndIf 
              
            If Empty(EEQ->EEQ_VCT)
               DET->EEQ_VCT  := "-"
            Else
               DET->EEQ_VCT  := TRANSFORM(DTOC((cAlias)->EEQ_VCT) ,AVSX3("EEQ_VCT" ,AV_PICTURE))  
            EndIf
             
         #ENDIF         
         EEC->(DbSetOrder(1))
         EEC->(DbSeek(xFilial("EEC")+(cAlias)->EEQ_PREEMB))
         If lTrat .or. EEC->(EOF())
               DET->EEQ_MOEDA  := (cAlias)->EEQ_MOEDA 
            
               SA1->(DbSetOrder(1))
            
               If SA1->(DbSeek(xFilial("SA1")+(cAlias)->EEQ_IMPORT)) 
                  DET->EEQ_IMPORT := SA1->A1_NREDUZ
               Endif
               SA2->(DbSetOrder(1))
               If SA2->(DbSeek(xFilial("SA2")+(cAlias)->EEQ_FORN))
                  DET->EEQ_FORN   := SA2->A2_NREDUZ
               Endif
         Else 
               DET->EEQ_MOEDA  := EEC->EEC_MOEDA           
            
               SA1->(DbSetOrder(1))
               SA1->(DbSeek(xFilial("SA1")+EEC->EEC_IMPORT)) 
               DET->EEQ_IMPORT := SA1->A1_NREDUZ
            
               SA2->(DbSetOrder(1))
               SA2->(DbSeek(xFilial("SA2")+EEC->EEC_FORN))
               DET->EEQ_FORN   := SA2->A2_NREDUZ    
         Endif 
         
         // impress�o dos contratos de financiamento para cada parcela 
         EF3->(DbSetOrder(3))
         if EF3->(DbSeek(xFilial("EF3")+IF(lEFFTpMod, IF((cAlias)->EEQ_TP_CON $ ("2/4"),"I","E"),"")+(cAlias)->EEQ_NRINVO+(cAlias)->EEQ_PARC+"600")) //HVR
            lAppend := .f.
            While !EF3->(EOF()) .And. xFilial("EF3") == EF3->EF3_FILIAL .And. IF(lEFFTpMod, IF((cAlias)->EEQ_TP_CON $ ("2/4"),"I","E") = EF3->EF3_TPMODU, .T.) .And. (cAlias)->EEQ_PARC == EF3->EF3_PARC .And. (cAlias)->EEQ_NRINVO == EF3->EF3_INVOIC .and. EF3->EF3_CODEVE == "600"
               If lAppend 
                  DET->(DBAppend())
                  DET->SEQREL   := cSEQREL
                  If(lFlag, DET->FLAG := "X", DET->FLAG := "Y") 
               Endif
               DET->EF3_CONTRA := EF3->EF3_CONTRA   
               nRecEF3 := EF3->(RecNo())  
               nJuros  := 0
               if EF3->(DbSeek(xFilial("EF3")+IF(lEFFTpMod, IF((cAlias)->EEQ_TP_CON $ ("2/4"),"I","E"),"")+(cAlias)->EEQ_NRINVO+(cAlias)->EEQ_PARC+"520"))//c�lculo dos juros //HVR
                  While !EF3->(EOF()) .And. xFilial("EF3") == EF3->EF3_FILIAL .And. IF(lEFFTpMod, IF((cAlias)->EEQ_TP_CON $ ("2/4"),"I","E") = EF3->EF3_TPMODU, .T.) .And. (cAlias)->EEQ_PARC == EF3->EF3_PARC .And. (cAlias)->EEQ_NRINVO == EF3->EF3_INVOIC .and. EF3->EF3_CODEVE == "520"   
                     If DET->EF3_CONTRA == EF3->EF3_CONTRA
                        nJuros += EF3->EF3_VL_MOE 
                     Endif
                     EF3->(DbSkip())
                  Enddo
                  DET->VALORJUROS :=Transform(nJuros,AvSx3("EF3_VL_MOE",AV_PICTURE))
               Else
                  DET->VALORJUROS := "-" 
               Endif 
               EF3->(DbGoto(nRecEF3))
               EF3->(DbSkip())
               lAppend := .t.
            EndDo 
         Endif  
         nJuros := 0
         lProc := .t.    
         cProcPast := cProcAtual
         (cAlias)->(DBSkip())
      Enddo   
   
   if lProc = .f.
      msginfo(STR0015,STR0016)//("Intervalo sem dados para impress�o.","Aviso!")
      lRet := .f.
      break
   endif
   
END SEQUENCE 

   IF ( lRet )
      CrwPreview(aRetCrw,cArqRpt,cTitRpt,cSeqRel)
   ELSEIF lApaga
      // Fecha e apaga os arquivos temporarios
      CrwCloseFile(aRetCrw,.T.)
   ENDIF     
   if cAlias == "QRY"
      QRY->(DbCloseArea()) 
   endif
   RestOrd(aOrd) 
      
Return (.f.) 

/*
Funcao      : TelaGets().
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Tela com op��es de filtros para os embarques.
Autor       : Jo�o Pedro Macimiano Trabbold.
Data/Hora   : 04/08/04; 10:50
*/
*-----------------------------*
Static Function TelaGets() 
*-----------------------------* 
Local lRet  := .f.
Local nOpc  := 0   	
Local bOk, bCancel
Private oCbxTit, oGetForn, oGetImp, oForn, oImp, oGetLoja, cLoja

Begin Sequence

   DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 9,0 TO 27.51,34 OF oMainWnd
      
      @ 11,3 to 140,133 PIXEL 
      @ 13,1 to 138,135 PIXEL   
      @ 11,1 to 140,135 PIXEL   

      @ 22,8  SAY STR0017 PIXEL //"Dt. Venc. :" 
      @ 20,38 MSGET dDtIni SIZE 40,8 PIXEL   
      
      @ 22,78 SAY STR0007 PIXEL //"At� "
      @ 20,88 MSGET dDtFim SIZE 40,8 PIXEL  
           
      @ 35,8  SAY STR0018 PIXEL //"T�tulos :"
      //TComboBox():New(65,60,bSETGET(cTitulos),aTitulos,40,8,oDlg,,,,,,.T.)      
      @ 33,38 COMBOBOX oCbxTit VAR cTitulos ITEMS aTitulos  SIZE 40,8 ON CHANGE (fChange()) OF oDlg PIXEL  
            
      @ 48,8  SAY STR0019 PIXEL //"Fornecedor:" 
      @ 46,38 MSGET oGetForn VAR cFornece F3 "YA2" Valid (Empty(cFornece) .or. ExistCPO("SA2")) SIZE 40,8 ON CHANGE (TrazDesc("FORN")) OF oDlg PIXEL  
      
      @ 61,8  SAY STR0020 PIXEL //"Descri��o :"     
      @ 59,38 MSGET oForn VAR cForn SIZE 90,9 OF oDlg PIXEL   
      oForn:Disable() 
      cForn:=Space(20) 
           
      @ 74,8  SAY STR0021 PIXEL //"Importador :" 
      @ 72,38 MSGET oGetImp VAR cImport F3 "EA1" Valid (Empty(cImport) .or. ExistCPO("SA1")) SIZE 40,8 ON CHANGE (TrazDesc("IMP")) OF oDlg PIXEL   
      
      @ 87,8  SAY STR0020 PIXEL //"Descri��o :" 
      @ 85,38 MSGET oImp VAR cImp SIZE 90,9 OF oDlg PIXEL 
      oImp:Disable()
      cImp:=Space(20) 
      
      @ 100,8  SAY STR0022 PIXEL //"Vinc. Fin.?" 
      TComboBox():New(98,38,bSETGET(cFinanc),aFinanc,40,8,oDlg,,,,,,.T.)  
       
      @ 113,8  SAY STR0023 PIXEL //"Moeda: "
      @ 111,38 MSGET cMoeda PICTURE "@!" F3 "SYF" Valid (Empty(cMoeda) .or. ExistCPO("SYF")) SIZE 40,8 OF oDlg PIXEL 

      if lTPCONExt      
          @ 126,8  SAY AVSX3("EEQ_TP_CON",5) PIXEL //"Tipo de contrato "
          @ 124,41 COMBOBOX oCbTpCon VAR cTpCon ITEMS aTpCon SIZE 65,8 OF oDlg PIXEL  
      else
          cTpCon:=aTpCon[2]
      endif
      fChange()
           
      bOk     := {|| If(ConfereDt(),(nOpc:=1, oDlg:End()),nOpc:=0)}
      bCancel := {|| oDlg:End() }
						
   ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,bOk,bCancel) CENTERED

   IF nOpc == 1                                                    
      lRet := .t.
   Else
      lRet := .f.
   Endif 

End Sequence

Return lRet    

/*
Funcao      : fChange().
Parametros  : Nenhum.
Retorno     : nil
Objetivos   : Enable/Disable dos campos de Fornecedor e Importador, de acordo com o tipo de titulo(A Receber ou a Pagar)
Autor       : Jo�o Pedro Macimiano Trabbold.
Data/Hora   : 23/08/04; 13:20
*/ 

*------------------------*
Static Function fChange()
*------------------------*  

Begin Sequence 
 
   if cTitulos == STR0006 //"A Pagar" 
      oGetForn:Enable() 
      cFornece:= Space(AVSX3("A2_COD",AV_TAMANHO))  
      cForn:= Space(90)    
      oGetImp:Disable() 
      cImport:= "" 
      cImp:= ""
      oGetImp:Refresh() 
      oImp:Refresh()             
   endif
   
   if cTitulos == STR0005 //"A Receber" 
      oGetImp:Enable() 
      cImport := Space(AVSX3("A1_COD",AV_TAMANHO))
      cImp:= Space(90) 
      cFornece:= ""
      cForn:= ""
      oGetForn:Disable()
      oGetForn:Refresh()
      oForn:Refresh()      
   endif 
   
end sequence
return nil      

/*
Funcao      : TrazDesc().
Parametros  : cTipo : define se � a descri��o do importador ou do fornecedor
Retorno     : NIL
Objetivos   : Traz descri��o do Fornecedor e Importador na tela de filtros
Autor       : Jo�o Pedro Macimiano Trabbold.
Data/Hora   : 20/08/04; 13:20
*/ 
*------------------------------*
Static Function TrazDesc(cTipo)
*------------------------------*
Begin Sequence   
   If cTipo == "FORN"
      SA2->(DbSetOrder(1))
      SA2->(DBSeek(xFilial("SA2")+cFornece))
      cForn := SA2->A2_NOME
   else
      SA1->(DbSetOrder(1))
      SA1->(DBSeek(xFilial("SA1")+cImport))
      cImp := SA1->A1_NOME
   endif  
end sequence
return nil    

/*
Funcao      : ConfereDt().
Parametros  : Nenhum.
Retorno     : .t./.f.
Objetivos   : Confere se as datas digitadas na tela de filtro s�o v�lidas.
Autor       : Jo�o Pedro Macimiano Trabbold.
Data/Hora   : 04/08/04; 13:27
*/
*-----------------------------------*
Static Function ConfereDt()
*-----------------------------------*
Local lRet := .f.

Begin Sequence      
   
   if !empty(dDtIni) .And. !empty(dDtFim) .And. dDtIni > dDtFim 
      MsgInfo(STR0024,STR0016) //("Data Final n�o pode ser menor que a inicial.","Aviso!")
   Else
      lRet := .t.
   Endif   
        
End Sequence
      
Return lRet           
/*
Funcao      : MontaQuery().
Parametros  : Nenhum.
Retorno     : cQry
Objetivos   : Monta a query para Serv. TOP
Autor       : Jo�o Pedro Macimiano Trabbold.
Data/Hora   : 13/09/04; 9:00
*/ 
#IFDEF TOP
*-----------------------------------*
Static Function Montaquery()
*-----------------------------------*
Local cQry := ""
Begin Sequence   
   if !lTPCONExt
      cQry := "Select EEQ_FILIAL, EEQ_DTCE, EEQ_PREEMB, EEQ_VL, EEQ_TX, EEQ_EQVL, "
      //Alcir Alves - 05-12-05 - considera apena tipo 1 - Exporta��o
      //if lTPCONExt
      //    cQry += " EEQ_TP_CON,"
      //endif

      //HVR
      If lEFFTpMod
         cQry += " EEQ_TP_CON,"
      endif

      cQry += " EEQ_BANC, EEQ_RFBC, EEQ_NROP, EEQ_OBS, EEQ_VCT, EEQ_PGT, EEQ_EVENT, EEQ_NRINVO, EEQ_PARC, " 
      cQry += " EEQ_ORIGEM, EEC_DTCONH, EEC_CONDPA, EEC_DIASPA, "
      If lTrat 
         cQry += " EEQ_IMPORT, EEQ_FORN, EEQ_MOEDA, EEC_IMPORT, EEC_FORN, EEC_MOEDA, " 
         cQry += " EEQ_AREMET, EEQ_ADEDUZ, EEQ_CGRAFI "
      Else
         cQry += " EEC_IMPORT, EEC_FORN, EEC_MOEDA "
      EndIf  
      cQry += "From " + RetSqlName("EEC") + " EEC, " + RetSqlName("EEQ") + " EEQ "
      cQry += "Where EEQ.D_E_L_E_T_ <> '*' and EEC.D_E_L_E_T_ <> '*' and EEQ_FILIAL = '" + xFilial("EEQ")+"'" 
      //Alcir Alves - 05-12-05 - considera apena tipo 1 - Exporta��o e 2 Importa��o
      //if lTPCONExt
      //    cQRY += " and (EEQ_TP_CON='1' or EEQ_TP_CON='2')"
      //endif
      //
      cQry += " and EEC_FILIAL = '" + xFilial("EEC") + "' and EEC_PREEMB = EEQ_PREEMB "
      if !empty(dDtIni)
         cQry += " and EEQ_VCT >= '" + DtoS(dDtIni) + "'"
      endif          
      if !empty(dDtFim)
         cQry += " and EEQ_VCT <= '" + DtoS(dDtFim) + "'"
      endif      
      If lTrat
         if !Empty(cMoeda) 
            cQry += " and EEQ_MOEDA = '" + cMoeda + "'"	    
         endif
         if cTitulos == STR0006 .And. !Empty(cFornece) //"A Pagar"
            cQry += " and EEQ_FORN = '" + cFornece  + "'"  
         elseif cTitulos == STR0005 .And. !Empty(cImport) //"A Receber"   
            cQry += " and EEQ_IMPORT = '" + cImport + "'" 
         endif  
      Else
         if !Empty(cMoeda) 
            cQry += " and EEC_MOEDA = '" + cMoeda + "'"	    
         endif
         if cTitulos == STR0006 .And. !Empty(cFornece) //"A Pagar"
            cQry += " and EEC_FORN = '" + cFornece  + "'"   
         elseif cTitulos == STR0005 .And. !Empty(cImport) //"A Receber"
            cQry += " and EEC_IMPORT = '" + cImport + "'"
         endif  
      EndIf       
   else //caso EEQ_TP_CON exista
      cQry := "Select EEQ_FILIAL, EEQ_DTCE, EEQ_PREEMB, EEQ_VL, EEQ_TX, EEQ_EQVL,"
      
      //HVR
      //If lEFFTpMod
         cQry += " EEQ_TP_CON,"
      //endif
      
      cQry += " EEQ_BANC, EEQ_RFBC, EEQ_NROP, EEQ_OBS, EEQ_VCT, EEQ_PGT, EEQ_EVENT, EEQ_NRINVO, EEQ_PARC " 
      If lTrat 
         cQry += ",EEQ_IMPORT, EEQ_FORN, EEQ_MOEDA " 
         cQry += ",EEQ_AREMET, EEQ_ADEDUZ, EEQ_CGRAFI "
      EndIf  
      cQry += ",EEQ_ORIGEM "
      cQry += "From "+ RetSqlName("EEQ") + " EEQ "
      cQry += "Where EEQ.D_E_L_E_T_ <> '*' and EEQ_FILIAL = '" + xFilial("EEQ")+"'" 
      if !empty(dDtIni)
         cQry += " and EEQ_VCT >= '" + DtoS(dDtIni) + "'"
      endif          
      if !empty(dDtFim)
         cQry += " and EEQ_VCT <= '" + DtoS(dDtFim) + "'"
      endif      
      If lTrat
         if !Empty(cMoeda) 
            cQry += " and EEQ_MOEDA = '" + cMoeda + "'"	    
         endif
         if cTitulos == STR0006 .And. !Empty(cFornece) //"A Pagar"
            cQry += " and EEQ_FORN = '" + cFornece  + "'"  
         elseif cTitulos == STR0005 .And. !Empty(cImport) //"A Receber"   
            cQry += " and EEQ_IMPORT = '" + cImport + "'" 
         endif  
      EndIf       
   endif
   cQry += " Order By EEQ_PREEMB, EEQ_PARC "     
End Sequence

Return cQry  
#ENDIF                 
/*
Funcao      : FiltrosDBF().
Parametros  : Nenhum.
Retorno     : .T./.F.
Objetivos   : Filtros para ambiente CodeBase
Autor       : Jo�o Pedro Macimiano Trabbold.
Data/Hora   : 26/08/04; 16:50
*/

*-----------------------------------*
Static Function FiltrosDBF()
*-----------------------------------*
Local lRet := .t.

Begin Sequence   

// Testa as condicoes para o filtro pela dt inicial de vencimento de cambio.
if !Empty(dDtIni) .And. EEQ->EEQ_VCT < dDtIni        
   EEQ->(DbSkip())
   lRet := .f.  
EndIf
   
// Testa as condicoes para o filtro pela dt final de vencimento de cambio.
if !Empty(dDtFim) .And. EEQ->EEQ_VCT > dDtFim        
   EEQ->(DbSkip())
   lRet := .f. 
EndIf 
             
If lTrat     
   // Testa as condicoes para o filtro pelo fornecedor.        
   If !Empty(cFornece) .And. cTitulos == STR0006 .And. EEQ->EEQ_FORN <> cFornece //"A Pagar"
      EEQ->(DbSkip())
      lRet := .f. 
   EndIf 
   // Testa as condicoes para o filtro pelo importador. 
   If !Empty(cImport) .And. cTitulos == STR0005 .And. EEQ->EEQ_IMPORT <> cImport //"A Receber"
      EEQ->(DbSkip())
      lRet := .f. 
   EndIf      
     
   // Testa as condicoes para o filtro pela moeda.       
   If !Empty(cMoeda) .And. EEQ->EEQ_MOEDA <> cMoeda
      EEQ->(DbSkip())
      lRet := .f. 
   EndIf    
   
Else
   EEC->(DbSetOrder(1))
   EEC->(DbSeek(xFilial("EEC")+EEQ->EEQ_PREEMB))
   // Testa as condicoes para o filtro pelo fornecedor.                
   IF !EEC->(EOF())
      If !Empty(cFornece) .And. cTitulos == STR0006 .And. EEC->EEC_FORN <> cFornece //"A Pagar"
         EEQ->(DbSkip())
         lRet := .f. 
      EndIf 
      
      // Testa as condicoes para o filtro pelo Importador.       
      If !Empty(cImport) .And. cTitulos == STR0005 .And. EEC->EEC_IMPORT <> cImport //"A Receber"
         EEQ->(DbSkip())
         lRet := .f. 
      EndIf                                                            
      // Testa as condicoes para o filtro pela moeda.       
      If !Empty(cMoeda) .And. EEC->EEC_MOEDA <> cMoeda
         EEQ->(DbSkip())
         lRet := .f. 
      EndIf   
   ELSE
      If !Empty(cFornece) .And. cTitulos == STR0006 .And. EEQ->EEQ_TP_CON <> "4" //"A Pagar"
         EEQ->(DbSkip())
         lRet := .f. 
      EndIf 
      // Testa as condicoes para o filtro pelo Importador.       
      If !Empty(cImport) .And. cTitulos == STR0005 .And. EEC->EEC_IMPORT <> "3" //"A Receber"
         EEQ->(DbSkip())
         lRet := .f. 
      EndIf                                                            
      // Testa as condicoes para o filtro pela moeda.       
      If !Empty(cMoeda) .And. EEQ->EEQ_MOEDA <> cMoeda
         EEQ->(DbSkip())
         lRet := .f. 
      EndIf      
   ENDIF
   
EndIf    
           
End Sequence
      
Return lRet              

/*
Funcao      : CalcCamb().
Parametros  : lFirst : Define se � a primeira chamada da fun��o
Retorno     : .T./.F.
Objetivos   : Fun��o recursiva para c�lculo do valor cambial
Autor       : Jo�o Pedro Macimiano Trabbold.
Data/Hora   : 13/09/04; 16:50   
Obs.        : cuidado ao dar manuten��o a esta fun��o, pois esta � recursiva
*/

*-----------------------------------*
Static Function CalcCamb(lFirst)
*-----------------------------------* 
local   nRecNo := 0 , cParc := "" , lFound := .t. 
Default lFirst := .f.  
 
Begin Sequence
   If lFirst
      EEQ->(DbSetOrder(3))  
      nVlCamb := 0
   Endif                     	
   cParc   := EEQ->EEQ_PARC   //poss�vel parcela pai
   cPreemb := EEQ->EEQ_PREEMB  
   
   If EEQ->(DbSeek(xFilial("EEQ")+cPreemb+cParc)) //se achar alguma parcela que tenha como origem a poss�vel parcela pai, ent�o possui parcela filha
      nRecNo := EEQ->(RecNo())
      If lFirst .and. Empty(Posicione("EEQ",1,xFilial("EEQ")+cPreemb+cParc,"EEQ_PGT")) 
         nVlCamb := Posicione("EEQ",1,xFilial("EEQ")+cPreemb+cParc,"EEQ_VL")
      Endif 
      EEQ->(DbSetOrder(3))
      EEQ->(DbGoto(nRecNo)) 
      lFound := .t. 
      While xFilial("EEQ") == EEQ->EEQ_FILIAL .and. EEQ->EEQ_PREEMB == cPreemb .and. EEQ->EEQ_ORIGEM == cParc
         If Empty(EEQ->EEQ_PGT)             //procura parcelas irm�s da parcela filha
            nVlCamb += EEQ->EEQ_VL
         Endif
         nRecNo  := EEQ->(RecNo())
         CalcCamb()
         EEQ->(DbGoTo(nRecNo))
         EEQ->(DbSkip())
      Enddo  
   Else
      lFound := .f.
      If lFirst 
         nVlCamb := Posicione("EEQ",1,xFilial("EEQ")+cPreemb+cParc,"EEQ_VL")
      Endif      
   Endif
   If !lFound .and. lFirst
      lCalc  := .t.  
   Endif 
End Sequence
Return nil

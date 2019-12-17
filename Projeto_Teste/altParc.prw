#Include "PROTHEUS.CH"
#Include "TopConn.ch"

User Function altParc()
                Private cCadastro    := "Parcela"
                Private cAliasSWB    := "SWB"
                Private aRotina      := {}
                Private aCores                  := {}
                                                                                       
                aAdd(aRotina,{"Pesquisar"  ,"AxPesqui",0,1})                                  
                aAdd(aRotina,{"Visualizar" ,"AxVisual",0,2})                                  
                aAdd(aRotina,{"Nro. Série" ,"U_Parc()",0,3})
                
                // Abre a Tabela e posiciona no primeiro registro                              
                dbSelectArea(cAliasSWB)                                                         
                dbSetOrder(1)                                                                  
                dbGoTop() 
                                                                                                 
                mBrowse(6,1,22,75,cAliasSWB,,,,,,aCores)

Return


User Function Parc()

                Local oButton1
                Local oButton2
                Local oGet1
                Local cGet1 := SWB->WB_NUMDUP
                Local oGet2
                Local cGet2 := SWB->WB_PARCELA
                Local oGet3
                //Local cGet3 := POSICIONE("SA2",1,xFilial("SA2")+SW2->W2_FORN+W2_FORLOJ,"A2_NOME")
                Local oGroup1
                Local oSay1
                Local oSay2
                Local oSay3

                Public oDlg
                
                If !empty(RETFIELD("SD1",19,xFilial("SD1")+SW2->W2_PO_SIGA, "D1_PEDIDO"))
                               MsgStop("Pedido fechado, impossivel informar Nro. de Série!!!")
                               Return
                EndIf
                  
                  
                DEFINE MSDIALOG oDlg TITLE "Numero de Série" FROM 000, 000  TO 500, 700 COLORS 0, 16777215 PIXEL
                  
                @ 004, 004 GROUP oGroup1 TO 228, 350 PROMPT " Itens Cambio " OF oDlg COLOR 0, 16777215 PIXEL
                @ 012, 009 SAY                  oSay1 PROMPT "tit"                 SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
                @ 020, 009 MSGET oGet1 VAR cGet1                    SIZE 060, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
                @ 012, 077 SAY                  oSay2 PROMPT "par" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
                @ 020, 077 MSGET oGet2 VAR cGet2                    SIZE 039, 010 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
                @ 012, 126 SAY   oSay3 PROMPT "Fornec            SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
                @ 020, 126 MSGET oGet2 VAR oGet2                    SIZE 212, 010 WHEN .F. PICTURE "@S30" OF oDlg COLORS 0, 16777215 PIXEL
                fMSNewGe1(cGet1)
                @ 231, 270 BUTTON oButton1 PROMPT "Gravar" SIZE 037, 012 ACTION({SaveNum(cGet1),oDlg:end()}) OF oDlg PIXEL
                @ 231, 312 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 ACTION(oDlg:end()) OF oDlg PIXEL
                
                ACTIVATE MSDIALOG oDlg CENTERED
  
Return



Static Function fMSNewGe1(cPedido)
                Local nX
                Local aHeaderEx              := {}
                Local aColsEx                     := {}      
                Local aFieldFind               := {}
                Local aFieldFill   := {}
                Local aFields                      := {"NOUSER"}
                Local aAlterFields            := {"WB_NUMDUP"}
                Public oMSNewGe1
                
                // Get fields from SZ3
                aEval(ApBuildHeader("SWB", Nil), {|x| Aadd(aFields, x[2])})
                

                aAdd(aFieldFind,{"WB_NUMDUP"})                       
                aAdd(aFieldFind,{"WB_PARCELA"})                            
                //aAdd(aFieldFind,{"W3_QTDE"})                              
                //aAdd(aFieldFind,{"W3_DT_ENTR"})                       
                //aAdd(aFieldFind,{"W3_POSICAO"})                       
                
                // Define field properties
                dbSelectArea("SX3")
                SX3->(DbSetOrder(2))
                               
                
                For nX := 1 to Len(aFieldFind)
                  If SX3->(DbSeek(aFieldFind[nX]))
                   
                                Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,,;
                                  SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
                  Endif
                Next nX
                
                // Define field values
                dbSelectArea("SWB")
                dbSetorder(1)
                If dbSeek(xFilial("SWB")+cNumDup)
                               While !SW3->(eof()) .and. SWB->WB_NUMDUP == cNumDup  //.and.  Alltrim(SWB->WB_PARCELA)==""
                                                                                                                                                                                      
                                               //aadd(aColsEx,{SWB->WB_NUMDUP,alltrim(SWB->WB_PARCELA),SW3->W3_QTDE,SW3->W3_DT_ENTR,SW3->W3_ZZNRSER,.F.})                           
												aadd(aColsEx,{SWB->WB_NUMDUP,.F.})  
                                               SWB->(dbSkip())
                               EndDo
                Else
                               aadd(aColsEx,{space(4),.F.})
                EndIf
                  
                oMSNewGe1 := MsNewGetDados():New( 062, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
                
Return .T. 



Static Function SaveNum(cNumDup)

                For nI := 1 to len(oMSNewGe1:aCols)
                               dbSelectArea(SWB)
                               dbSetOrder(1)
                               dbGoTop()
                               If dbSeek(xFilial("SWB")+cNumDup+oMSNewGe1:aCols[nI,1]+oMSNewGe1:aCols[nI,2])
                                  
                                               If !oMSNewGe1:aCols[nI,Len(oMSNewGe1:aHeader)+1]
                                               
                                                               RecLock("SWB",.F.)
                                                                              SWB->WB_PARCELA  := oMSNewGe1:aCols[nI,5]
                                                               MsUnlock()
                                               EndIf

                               EndIf
                Next
                
                MsgAlert("Parcela alterada!!!")
                
Return

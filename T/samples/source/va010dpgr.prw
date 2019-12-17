/*       
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � VA010DPGR� Autor �  Emilton              � Data � 28/11/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava automaticamente o VO5                                ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION VA010DPGR()
*********************

SetPrvt("aVetValid,cChaInt,nOpc_,nReg_")
 

//��������������������������������������������������������������Ŀ
//� GRAVA O VO5 A PARTIR DO VV1 AUTOMATICAMENTE   O              �
//����������������������������������������������������������������


cChaInt := ParamIxb[1]
nOpc_   := ParamIxb[2]
nReg_   := ParamIxb[3]

If FG_SEEK("VO5","VV1->VV1_CHAINT",1,.f.)

   Do Case
      Case nOpc_ == 4  // Alteracao
      
           RecLock("VO5",.f.)
           
           VO5->VO5_FILIAL := xFilial("VO5")
           VO5->VO5_CHAINT := VV1->VV1_CHAINT
           VO5->VO5_TIPOPE := VV1->VV1_TIPOPE
           VO5->VO5_GRASEV := VV1->VV1_GRASEV
           VO5->VO5_DATVEN := VV1->VV1_DATVEN
           VO5->VO5_PRIREV := VV1->VV1_PRIREV
           VO5->VO5_VEIACO := VV1->VV1_VEIACO
           MsUnlock()

      Case nOpc_ == 5  // Exclusao

           aAdd(aVetValid, {"VF3",3,VO5->VO5_CHAINT , Nil } )
           aAdd(aVetValid, {"VF4",1,VO5->VO5_CHAINT , Nil } )
           aAdd(aVetValid, {"VS1",2,VO5->VO5_CHAINT , Nil } )
           aAdd(aVetValid, {"VFB",8,VO5->VO5_CHAINT , Nil } )
           aAdd(aVetValid, {"VO1",4,VO5->VO5_CHAINT , Nil } )

           If FG_DELETA( aVetValid )
              AxDeleta("VO5",nReg,nOpc_)
           EndIf
 
   EndCase

Else

   Do Case
      Case nOpc_ == 3  // Inclusao
      
           RecLock("VO5",.t.)
           VO5->VO5_FILIAL := xFilial("VO5")
           VO5->VO5_CHAINT := VV1->VV1_CHAINT
           VO5->VO5_TIPOPE := VV1->VV1_TIPOPE
           VO5->VO5_GRASEV := VV1->VV1_GRASEV
           VO5->VO5_DATVEN := VV1->VV1_DATVEN
           VO5->VO5_PRIREV := VV1->VV1_PRIREV
           VO5->VO5_VEIACO := VV1->VV1_VEIACO
           MsUnlock()

      Case nOpc_ == 5  // Exclusao

           aAdd(aVetValid, {"VF3",3,VO5->VO5_CHAINT , Nil } )
           aAdd(aVetValid, {"VF4",1,VO5->VO5_CHAINT , Nil } )
           aAdd(aVetValid, {"VS1",2,VO5->VO5_CHAINT , Nil } )
           aAdd(aVetValid, {"VFB",8,VO5->VO5_CHAINT , Nil } )
           aAdd(aVetValid, {"VO1",4,VO5->VO5_CHAINT , Nil } )

           If FG_DELETA( aVetValid )
              AxDeleta("VO5",nReg,nOpc_)
           EndIf
 
   EndCase

EndIf

//��������������������������������������������������������������Ŀ
//� ACERTA O GRUPO DE TRIBUTACAO PARA USADO E NOVO               �
//����������������������������������������������������������������

if VV1->VV1_ESTVEI = "1"  //veiculo usado

   if VV1->VV1_GRTRIB # "   "

      dbSelectArea("VV1")
      reclock("VV1",.f.) 
      VV1->VV1_GRTRIB:="   "
      msunlock()

	   dbSelectArea("SB1")
	   dbgotop(1)                                                                         
   	if dbseek(xfilial("SB1")+VV1->VV1_CHAINT+space(9))
         dbSelectArea("SB1")
	      reclock("SB1",.f.) 
   	   SB1->B1_GRTRIB:=VV1->VV1_GRTRIB
        	msunlock()
      endif
      
   endif
   
else                 //VEICULO NOVO

   if VV1->VV1_GRTRIB # "001"

      dbSelectArea("VV1")
      reclock("VV1",.f.) 
      VV1->VV1_GRTRIB:="001"
      msunlock()

      dbSelectArea("SB1")
      dbgotop(1)                                                                         
      if dbseek(xfilial("SB1")+VV1->VV1_CHAINT+space(9))
         dbSelectArea("SB1")
         reclock("SB1",.f.) 
         SB1->B1_GRTRIB:=VV1->VV1_GRTRIB
         msunlock()
      endif
   
   endif
   
endif


//��������������������������������������������������������������Ŀ
//� ACERTA O VV1_VV1_ESTVEI QUANTO A NOVO OU USADO               �
//����������������������������������������������������������������

if SM0->M0_CODIGO $ "05/17/23" 

   if VV1->VV1_LOCPAD = "VN"                         
   
      dbSelectArea("VV1")
      reclock("VV1",.f.) 
      VV1->VV1_ESTVEI:="0"  //NOVO
      msunlock()
   else
      dbSelectArea("VV1")
      reclock("VV1",.f.) 
      VV1->VV1_ESTVEI:="1" //USADO
      msunlock()
   endif   

elseif empty(VV1->VV1_ESTVEI)
   dbSelectArea("VV1")
   reclock("VV1",.f.) 
   VV1->VV1_ESTVEI:="0" //NOVO
   msunlock()
endif

Return .t.

#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#include "AVERAGE.CH"
User Function Eicpo01e()        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao .  �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("LABRE,")

   If !ChkFile("SB2",.F.)
      E_Msg("Nao foi possivel abrir Arquivo  SB2",1000,.T.)
      lAbre:=.F.
   Endif
// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99




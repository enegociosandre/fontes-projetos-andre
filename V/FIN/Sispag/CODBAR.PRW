#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

User Function codbar()        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CRETORNO,")

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � RPCODBAR � Autor � Patricia P. Santos    � Data � 08/11/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Converte Cod. Barras p/ Linha Digitavel e o contrario      낢�
굇�          � Desenvolvido para ROYALPLAS- Gatilho                       낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿌lteacao  � Alterado em 20/09/00 para validar novo padrao de Codigo de 낢�
굇�          � Barras da FEBRABAN de 01/09/00 - Vitor Luis Fattori        낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
/*/

_cRetorno := ""

// Tem linha digitavel e nao tem codigo de barras
If EMPTY(M->E2_CODBAR) .and. !EMPTY(M->E2_IPTE)    // Preenche cod. barras
   // Cod. Barras nao tem digitos verificadores
   IF LEN(ALLTRIM(M->E2_IPTE))==47
      _cRetorno := Substr(M->E2_IPTE,1,4) + ;             // BANCO + MOEDA
      Substr(M->E2_IPTE,33,1) + ;                      // DV GERAL
      Substr(M->E2_IPTE,34,4) + ;                       // FATOR VENCIMENTO
      StrZero(Val(Alltrim(Substr(M->E2_IPTE,38,10))),10) + ; // VALOR
      Substr(M->E2_IPTE,5,5) + ;                              // CAMPO LIVRE
      Substr(M->E2_IPTE,11,10) + ;
      Substr(M->E2_IPTE,22,10)
    ELSE
      _cRetorno := Substr(M->E2_IPTE,1,4) + ;             // BANCO + MOEDA
      Substr(M->E2_IPTE,33,1) + ;                      // DV GERAL
      StrZero(Val(Alltrim(Substr(M->E2_IPTE,34,14))),14) + ; // VALOR
      Substr(M->E2_IPTE,5,5) + ;                              // CAMPO LIVRE
      Substr(M->E2_IPTE,11,10) + ;
      Substr(M->E2_IPTE,22,10)
    ENDIF
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 13/06/01 ==> __Return(_cRetorno)
Return(_cRetorno)        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01


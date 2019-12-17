#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

User Function codbar()        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_CRETORNO,")

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RPCODBAR ³ Autor ³ Patricia P. Santos    ³ Data ³ 08/11/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Converte Cod. Barras p/ Linha Digitavel e o contrario      ³±±
±±³          ³ Desenvolvido para ROYALPLAS- Gatilho                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alteacao  ³ Alterado em 20/09/00 para validar novo padrao de Codigo de ³±±
±±³          ³ Barras da FEBRABAN de 01/09/00 - Vitor Luis Fattori        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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


%{
    #include <iostream>
    #include <fstream>

    #define TK_VAR_TYPE     001

    #define TK_FOR_LOOP     002
    #define TK_WHILE_LOOP   003

    #define TK_OP_PAREN     004
    #define TK_CL_PAREN     005

    #define TK_OP_BRACK     006
    #define TK_CL_BRACK     007

    #define TK_OP_CURLY     010
    #define TK_CL_CURLY     011

    #define TK_IF_STATE     012
    #define TK_ELSE_STATE   013
    
    #define TK_RETURN       014
    #define TK_KEYWORD      015
    #define TK_INCLUDE      016
    #define TK_INCLUDES     017

    #define TK_DO_LOOP      020

    #define TK_IDENTIFIER   021
%}

INCLUDES    "#include"[ \t]*"<"[a-zA-Z0-9./]*">"
INCLUDE     "#include"[ \t]*\"[a-zA-Z0-9./]*\"      
ML_COMMENT  "/*"([^*]|\*+[^*/])*\*+"/"
COMMENT     "//".*
VAR_TYPE    "int"|"double"|"float"|"char"|"void"
VAR_NAME    [a-zA-Z_][a-zA-Z0-9]*

%%

[ \t\n\f\r\v]       {   /*ignore whitespaces*/  }
{COMMENT}           {   /*ignore any comments*/ }
{ML_COMMENT}        {   /*ignore any comments*/ }
{VAR_TYPE}          {   return TK_VAR_TYPE;     }
[\*&]?{VAR_NAME}    {   return TK_IDENTIFIER;   } /* references and de-references*/
{INCLUDES}          {   return TK_INCLUDES;     }
{INCLUDE}           {   return TK_INCLUDE;      }
"for"               {   return TK_FOR_LOOP;     }
"while"             {   return TK_WHILE_LOOP;   }
"do"                {   return TK_DO_LOOP;      }
"{"                 {   return TK_OP_CURLY;     }
"}"                 {   return TK_CL_CURLY;     }
"("                 {   return TK_OP_PAREN;     }
")"                 {   return TK_CL_PAREN;     }
"["                 {   return TK_OP_BRACK;     }
"]"                 {   return TK_CL_BRACK;     }
"if"                {   return TK_IF_STATE;     }
"return"            {   return TK_RETURN;       }
"else"              {   return TK_ELSE_STATE;   }
.                   {   /*ignore random chars*/ }


%%

int yywrap(){
    return 1;
}

int main(){
    std::ofstream file;
    file.open("tokens.txt");

    if (!file)
        return 0;
    
    int token = 0;
    while (token = yylex()){
        file << token;
    }
    file.close();
    return 0;
}
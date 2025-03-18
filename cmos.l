%{
    #include <fstream>
    #include <iomanip>

    #define TK_VAR_TYPE     1

    #define TK_FOR_LOOP     2
    #define TK_WHILE_LOOP   3

    #define TK_OP_PAREN     4
    #define TK_CL_PAREN     5

    #define TK_OP_BRACK     6
    #define TK_CL_BRACK     7

    #define TK_OP_CURLY     8
    #define TK_CL_CURLY     9

    #define TK_IF_STATE     10
    #define TK_ELSE_STATE   11
    
    #define TK_RETURN       12
    #define TK_KEYWORD      13
    #define TK_INCLUDE_H    14
    #define TK_INCLUDES     15

    #define TK_DO_LOOP      16

    #define TK_IDENTIFIER   17
%}

INCLUDES    "#include"[ \t]*"<"[a-zA-Z0-9./]*">"
INCLUDE_H   "#include"[ \t]*\"[a-zA-Z0-9./]*\"      
ML_COMMENT  "/*"([^*]|\*+[^*/])*\*+"/"
COMMENT     "//".*
VAR_TYPE    "int"|"double"|"float"|"char"|"void"
VAR_NAME    [a-zA-Z_][a-zA-Z0-9]*

%%

[ \t\n\f\r\v]       {   /*ignore whitespaces*/  }
{COMMENT}           {   /*ignore any comments*/ }
{ML_COMMENT}        {   /*ignore any comments*/ }
{VAR_TYPE}          {   return TK_VAR_TYPE;     }
{INCLUDES}          {   return TK_INCLUDES;     }
{INCLUDE_H}           {   return TK_INCLUDE_H;      }
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
"else"              {   return TK_ELSE_STATE;   }
"return"            {   return TK_RETURN;       }
[\*&]?{VAR_NAME}    {   return TK_IDENTIFIER;   } /* references and de-references*/
.                   {   /*ignore random chars*/ }

%%

int yywrap(){
    return 1;
}

int main() {
    std::ofstream scannerOutput;
    std::ofstream visualOutput;
    scannerOutput.open("scanner_out.txt");
    visualOutput.open("visual_output.txt");

    if (!scannerOutput || !visualOutput){
        return -1;
    }

    int token = 0;

    // Read tokens from input file and write to output file
    while ((token = yylex())) {
        scannerOutput << std::setw(3) << token;
        visualOutput << std::setw(3) << token << " /* " << yytext << " */\n";
    }

    scannerOutput.close();
    visualOutput.close();
}
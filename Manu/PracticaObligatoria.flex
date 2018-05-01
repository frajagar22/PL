package PracticaObligatoria;

%%

%unicode
//%standalone

%class Lexer
%line
%column
%cup


%{

	int firstPositionAvailable = 0;
	String errorsArray[] = new String[100];
	boolean errorFound;
	String errorFoundString = "Lexer doesn't have found errors";
	StringBuilder cache;
	int lineError;
	int columnError;
	String literal = "";

	boolean getZzAtEOF() {
        return zzAtEOF;
    }
%}

%eof{
	
	if(errorFound){
		for (int i = 0; i<firstPositionAvailable; i++) {
			System.out.println(errorsArray[i]);
		}
	}
	else{
		System.out.println("Lexer doesn't have found errors");
	}

%eof}



BeginningOfComment = "/*"
BeginningOfOctal = "0"{Digits}+
BeginningOfLiteral = "\'"

%xstate CURRENTLITERAL
%xstate CURRENTCOMMENT

LineTerminator = \n
Digits = [0-9]
Letters = [a-zA-Z]
Symbols = ("$"|"_")
Sign = ("+"|"-")?



HexInt = "0x"{Sign}({Digits}|[A-F])+
HexFloat = {HexInt}"."({Digits}|[A-F])+
OctInt = "0"{Sign}([0-7])+
OctFloat = {OctInt}"."([0-7])+
DecInt = {Sign}{Digits}+
DecFloat = {DecInt}"."{Digits}+

Identifier = ({Letters}|"$")({Letters}|{Symbols}|{Digits})*



Comment = {MultiLineComment}|{SingleLineComment}

MultiLineComment = "/*"~"*/"
SingleLineComment = "//".*{LineTerminator}?


%%

[\r\n \n]|[ \t\n]+  {}
"(" {return new java_cup.runtime.Symbol(sym.parOpen, new token(yytext(), yycolumn, yyline));}
")" {return new java_cup.runtime.Symbol(sym.parClose, new token(yytext(), yycolumn, yyline));}
"{" {return new java_cup.runtime.Symbol(sym.keyOpen, new token(yytext(), yycolumn, yyline));}
"}" {return new java_cup.runtime.Symbol(sym.keyClose, new token(yytext(), yycolumn, yyline));}
"," {return new java_cup.runtime.Symbol(sym.comma, new token(yytext(), yycolumn, yyline));}
"void" {return new java_cup.runtime.Symbol(sym.tvoid, new token(yytext(), yycolumn, yyline));}
"int" {return new java_cup.runtime.Symbol(sym.tint, new token(yytext(), yycolumn, yyline));}
"float" {return new java_cup.runtime.Symbol(sym.tfloat, new token(yytext(), yycolumn, yyline));}
";" {return new java_cup.runtime.Symbol(sym.pointComma, new token(yytext(), yycolumn, yyline));}
"=" {return new java_cup.runtime.Symbol(sym.equalComp, new token(yytext(), yycolumn, yyline));}
"return" {return new java_cup.runtime.Symbol(sym.ret, new token(yytext(), yycolumn, yyline));}
"+" {return new java_cup.runtime.Symbol(sym.opSum, new token(yytext(), yycolumn, yyline));}
"-" {return new java_cup.runtime.Symbol(sym.opSub, new token(yytext(), yycolumn, yyline));}
"*" {return new java_cup.runtime.Symbol(sym.opMul, new token(yytext(), yycolumn, yyline));}
"/" {return new java_cup.runtime.Symbol(sym.opDiv, new token(yytext(), yycolumn, yyline));}
"%" {return new java_cup.runtime.Symbol(sym.opMod, new token(yytext(), yycolumn, yyline));}
"if" {return new java_cup.runtime.Symbol(sym.condIf, new token(yytext(), yycolumn, yyline));}
"then" {return new java_cup.runtime.Symbol(sym.condThen, new token(yytext(), yycolumn, yyline));}
"else" {return new java_cup.runtime.Symbol(sym.condElse, new token(yytext(), yycolumn, yyline));}
"for" {return new java_cup.runtime.Symbol(sym.loopFor, new token(yytext(), yycolumn, yyline));}
"while" {return new java_cup.runtime.Symbol(sym.loopWhile, new token(yytext(), yycolumn, yyline));}
"do" {return new java_cup.runtime.Symbol(sym.loopDo, new token(yytext(), yycolumn, yyline));}
"until" {return new java_cup.runtime.Symbol(sym.loopUntil, new token(yytext(), yycolumn, yyline));}
"not" {return new java_cup.runtime.Symbol(sym.opNot, new token(yytext(), yycolumn, yyline));}
"or" {return new java_cup.runtime.Symbol(sym.opOr, new token(yytext(), yycolumn, yyline));}
"and" {return new java_cup.runtime.Symbol(sym.opAnd, new token(yytext(), yycolumn, yyline));}
"==" {return new java_cup.runtime.Symbol(sym.equalDouble, new token(yytext(), yycolumn, yyline));}
"<" {return new java_cup.runtime.Symbol(sym.less, new token(yytext(), yycolumn, yyline));}
">" {return new java_cup.runtime.Symbol(sym.more, new token(yytext(), yycolumn, yyline));}
"<=" {return new java_cup.runtime.Symbol(sym.lessEqual, new token(yytext(), yycolumn, yyline));}
">=" {return new java_cup.runtime.Symbol(sym.moreEqual, new token(yytext(), yycolumn, yyline));}
"struct" {return new java_cup.runtime.Symbol(sym.structure, new token(yytext(), yycolumn, yyline));}
"." {return new java_cup.runtime.Symbol(sym.point, new token(yytext(), yycolumn, yyline));}
"[" {return new java_cup.runtime.Symbol(sym.matrixOpen, new token(yytext(), yycolumn, yyline));}
"]" {return new java_cup.runtime.Symbol(sym.matrixClose, new token(yytext(), yycolumn, yyline));}






{HexInt} {return new java_cup.runtime.Symbol(sym.constint, new token(yytext(), yycolumn, yyline));}
{HexFloat} {return new java_cup.runtime.Symbol(sym.constfloat, new token(yytext(), yycolumn, yyline));}
{OctInt} {return new java_cup.runtime.Symbol(sym.constint, new token(yytext(), yycolumn, yyline));}

{BeginningOfOctal} {
	lineError=yyline+1;
	columnError=yycolumn+1;
	errorsArray[firstPositionAvailable]="Expected octal format, integer suposed "+"Line:"+lineError+" Column: "+columnError;
	firstPositionAvailable+=1;
	errorFound = true;
}

{OctFloat} {return new java_cup.runtime.Symbol(sym.constfloat, new token(yytext(), yycolumn, yyline));}
{DecInt} {return new java_cup.runtime.Symbol(sym.constint, new token(yytext(), yycolumn, yyline));}
{DecFloat} {return new java_cup.runtime.Symbol(sym.constfloat, new token(yytext(), yycolumn, yyline));}
{Identifier} {return new java_cup.runtime.Symbol(sym.ident, new token(yytext(), yycolumn, yyline));}




{Comment} {}

{BeginningOfLiteral} {
	lineError=yyline+1;
	columnError=yycolumn+1;
	errorFound = true;
	errorsArray[firstPositionAvailable]="Expected end of literal "+"Line:"+lineError+" Column: "+columnError;
	firstPositionAvailable+=1;
	literal = "\'";
	yybegin(CURRENTLITERAL);
}





<CURRENTLITERAL> {
	"\'" {
		errorFound = false;
		
		yybegin(YYINITIAL);
		return new java_cup.runtime.Symbol(sym.constlit, new token(literal+"\'", yycolumn, yyline));
	}
	
	"\\\'"|. {
		literal +=yytext();
		yybegin(CURRENTLITERAL);
	}

}




{BeginningOfComment} {
	lineError=yyline+1;
	columnError=yycolumn+1;
	errorFound = true;
	errorsArray[firstPositionAvailable]="Expected end of comment "+"Line:"+lineError+" Column: "+columnError;
	firstPositionAvailable+=1;
	yybegin(CURRENTCOMMENT);
}

<CURRENTCOMMENT> {
	"*/" {
		errorFound = false;
		yybegin(YYINITIAL);
	}
	
	.|{LineTerminator} {
		yybegin(CURRENTCOMMENT);
	}

}





import java_cup.runtime.*;
%%
%class AnalizadorLexico
%cup
%unicode
%xstate COMILLAS
%xstate COMENTARIOS


Decimal= [+-]?[0-9]+
Octal= "0"[+-]?[0-7]+
Hexadecimal= "0x"[+-]?[0-9A-F]+
Identificadores=[a-z$][a-zA-Z0-9_$]*

%%
"#define"			{return new java_cup.runtime.Symbol(sym.definir);}
"void"				{return new java_cup.runtime.Symbol(sym.vacio);}
"int"				{return new java_cup.runtime.Symbol(sym.entero);}
"float"				{return new java_cup.runtime.Symbol(sym.flotante);}
"return"			{return new java_cup.runtime.Symbol(sym.devolver);}
"("				{return new java_cup.runtime.Symbol(sym.abrirParentesis);}
")"				{return new java_cup.runtime.Symbol(sym.cerrarParentesis);}
"{"				{return new java_cup.runtime.Symbol(sym.abrirLlave);}
"}"				{return new java_cup.runtime.Symbol(sym.cerrarLlave);}
","				{return new java_cup.runtime.Symbol(sym.coma);}
";"				{return new java_cup.runtime.Symbol(sym.puntoyComa);}
"="				{return new java_cup.runtime.Symbol(sym.igual);}
"*"				{return new java_cup.runtime.Symbol(sym.multiplicacion);}
"/"				{return new java_cup.runtime.Symbol(sym.division);}
"%"				{return new java_cup.runtime.Symbol(sym.modulo);}
"+"				{return new java_cup.runtime.Symbol(sym.mas);}
"-"				{return new java_cup.runtime.Symbol(sym.menos);}
{Identificadores}		{return new java_cup.runtime.Symbol(sym.identificador);}
{Decimal}			{ return new java_cup.runtime.Symbol(sym.constint);}
{Decimal}"."[0-9]+		{ return new java_cup.runtime.Symbol(sym.constfloat);}
{Octal}				{ return new java_cup.runtime.Symbol(sym.constint);}
{Octal}"."[0-7]+		{ return new java_cup.runtime.Symbol(sym.constfloat);}
{Hexadecimal}			{ return new java_cup.runtime.Symbol(sym.constint);}
{Hexadecimal}"."[0-9A-F]+	{ return new java_cup.runtime.Symbol(sym.constfloat);}
"'"				{yybegin(COMILLAS);}
"/*"				{yybegin(COMENTARIOS);}
"\n"|"\t"|" "|"\r"	{;}
"//"[^\n]*"\n"		{;}
[^]				{System.out.print("Error");}



<COMILLAS> ([^']|"\\'")+"'"	{yybegin(YYINITIAL); return new  java_cup.runtime.Symbol(sym.constlit);}
<COMILLAS> ([^']|"\\'")*	{System.out.print("Error"); yybegin(YYINITIAL);}


<COMENTARIOS>	([^*]|"*"[^/])*"*"+"/"	{yybegin(YYINITIAL);}
<COMENTARIOS>	([^*]|"*"[^/])*"*"*	{System.out.print("Error"); yybegin(YYINITIAL);}



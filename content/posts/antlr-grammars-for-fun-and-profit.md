---
title: "Antlr Grammars for Fun and Profit"
date: 2010-11-24T23:10:35-04:00
draft: true
tags:
  - ANTLR
  - AST
  - Compiler
  - Grammar
  - Lexer
  - Parser
---

Recently at work I had to work on files in our legacy system. Those files, being part of a proprietary product, are unknown to any editor or pretty printer that you can find. And most of them are not formatted nicely, if at all. Being a lazy developer I really love eclipse's code formatting features, because, hey, it takes away a lot of tedious and annoying formatting. Also, I think properly formatted files are easier to understand, maintain and fix. In fact, as I recently tweeted, I go as far as saying that I'm not particularly good in spotting problems, I just format everything which helps me to understand better.

But back to the actual problem: I had a lot of these files to look through and no tool to help me format them. So my first approach was to simply hack together a simple Java app (Yes, Java. Not Perl. Just felt like it. ;) , doing some String manipulation and indent it. However I quickly realized that my simple formatter was thrown off by multiple elements in on line. The basic format is something like this:

```
# comment
\group {
    \optionOne "value"
    \optionTwo 3.1415
    \subgroup { ... }
}
```

Nothing to fancy. However my simple app was thrown off by something like this:

```
\group { \anotherGroup { ...
```
So I realized, yes, that's easy. I just need to tokenize the input stream, and when I'm at that, I can actually check for syntactically correct input. Then I remembered from my compiler classes in university that building lexers and parsers was not fun. Interesting, but just not fun. Then I remembered reading about [ANLTR](http://www.antlr.org/). A tool that builds lexers and parsers from a grammar. Something I always wanted to use but never found a reason to. And formatting these files, just gave me a really good reason dive in.

## Lexers and Parsers in a Nutshell

If you are not familiar with the terms Lexers and Parsers, here's a quick rundown. Both terms are usually closely associated with compilers, because they solve a big part of the problems a compiler has to solve. A lexer, short for Lexical Analyser, is a program that splits an input stream based on certain rules into smaller chunks, called tokens. They are usually implemented using a regular language ([Chomsky 3](https://en.wikipedia.org/wiki/Chomsky_hierarchy) to be precise) and can "recognize" simple constructs. For example, a hypothetical lexer for Java might read the following input:

```
int i;
i = 1 + 2;
```

and produce the following tokens (in this notation that I just made up - please note that the tokens are UPPERCASE):

```
[ INT ] [ WHITESPACE] [ IDENTIFIER('i') ] [ SEMICOLON ] [ NEWLINE ] [ IDENTIFIER('i') ] [ WHITESPACE ] [ ASSIGNMENT ] ...
```
Notice how every "piece" get's its own token. Comparing the tokens and the original input, it is obvious that  working with tokens is already so much easier that working with the raw text. So, now that we have tokens, what does the parser actually do? In very generic terms, the parser takes the tokens and "understands" the token stream. Or at least, he'll try to. Most parsers spend most of their lives trying to understand input and then failing because of some syntactic error. For example, you forgot a bracket in your program, or a semicolon. Take the slightly modified code from the first sample:

```
inmt i
i = 1  2;
```
Wow. Lot's of input that doesn't make sense, right? "_The word `inmt` is not a valid type identifier!_" you say! "_And the semicolons! Where are they?_" The experienced and weathered developer will scream in disgust: "_This is invalid input_"! And this is where the parser comes in. A parser has a formal description of what the incoming token stream should look like. This formal description is called a grammar. A grammar is usually described in forms of "productions" which look like this very simplified sample (another notation I made up but heavily influenced by [EBNF](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form)):

```
assignment -> IDENTIFIER ASSIGN expression;
expression -> IDENTIFIER | addition | multiplication;
addition -> VALUE + VALUE;
...
```
So, these productions map a generic concept to a more concrete concept. When the parser starts, it will match the first rule against the input, and slowly working it's way down to the most precise rules he can find (or not, if the input doesn't match the grammar). By consulting the grammar, the parser always knows what the input can contain. Usually the parser takes every production that matches and puts all of the input into a tree, the so called AST (Abstract Syntax Tree), a tree like representation of the input. For our initial sample, the (simplified) AST could look like this:

```
           .- variable(i)
          /
program -|                  .- variable(i)
          \                /
           `- assignment -|                .- NUMERAL(1)
                           \              /
                            `- addition -|
                                          \
                                           `- NUMERAL(2)
```

So, from this (simplified) AST you can see the structure of the program, right away. It is almost the pure essence of the meaning of the input code. Quite a useful and flexible mechanism. After the parser finished parsing the input tree and assuming the input was correct according to the grammar, the parser spits out a complete AST for the input. And with the AST, you can do a lot of fun and awesome things. To close the circle to my introduction, you can easily output a nicely formatted version of the input file without having to worry you might break the file. It can act as a verifier, testing whether you forgot some important input (semicolons, brackets, single or double quotes come to mind) or even translate it into something different.

So now you should have a really basic understanding of what a lexer and a parser does. There's a lot more to this highly interesting field. I can recommend the ANTLR Reference Guide or any of the dragon books about compilers (For some reason compiler books almost always have a dragon on them. Some say, it is because of the inherent complexity of compilers... which is probably true).

## ANTLR
Back to my formatter/verifier for proprietary input. ANLTR takes off a lot of work from the developer because it will generate a complete lexer and parser (LL(*) parser to be precise) from a grammar for you. So all I had to do was to write a grammar for the proprietary format. Of course I don't want to keep that from you:

```
grammar MyGrammar;

options {
    language=Java;
    output=AST;
    ASTLabelType=CommonTree;
}

WS	:	( ' ' |'\t' |'\r' )+ { $channel=HIDDEN; };
NL	:	'\r'? '\n' { $channel=HIDDEN; };
DIGITS	:	'0'..'9'+;
EXTRACHARS :	( '/' | '\\' | '_' | '.' | ':' | '-' | '|' | '<' | '>' );
CHARS	:	('a'..'z' | 'A'..'Z')+;
STRING	:	'"' (CHARS | EXTRACHARS | DIGITS | WS)* '"';

GROUPSTART :	'{';
GROUPEND:	'}';

dialog	:	entry* EOF;
entry	:	comment | option;
option	:	'/' (DIGITS | CHARS)+ (ident | group);
ident	:	STRING | DIGITS;
group	:	GROUPSTART entry* GROUPEND;
comment	:	'#' (CHARS | DIGITS | EXTRACHARS )*;
```

In total it's a 33 lines with generous white space, a few comments and extra options I removed here. There's a few extra lines to load the input, and a single class that outputs a formatted file based on the generated AST. Everything else has been generated by ANTLR.

And suddenly I could verify and format ALL of our files using this tool. Awesome, isn't it?

## Final Thoughts

The learning curve for an approach like this is steep. Grammars are nothing that you can pick up over night, it will require some effort to understand them and the pitfalls you can encounter (left recursive grammars, ambiguous grammars, etc etc) but the payoffs are enormous. Instead of manually formatting and manually counting opening and closing brackets in every file that I open, I can now run a simple one-liner that'll find all files and verify them for me:

```
$ find ./ -iname '*.xxx' -exec verifier {} \;
```

Done. All files. We have a few hundred of those, so there's some significant time savings in this little project. Also, developers are more willing to work with them now, as this little tool will always tell them if they screwed up the syntax or not.

All in all, I found this little exercise quite transforming. I was somewhat scared of parsers and compilers, just because it's hard to build them in a good way. But now, given the power of ANTLR and the grammar driven approach, I start to see new solutions for a lot of problems.

Therefore my advice: go and learn about grammars and play with ANTLR. It can make your life so much easier.


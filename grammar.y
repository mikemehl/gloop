
%%

program: statement
statement: expression 
expression: term '+' expression | term
term: number
number: digit | digit number
digit: '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9'
%%

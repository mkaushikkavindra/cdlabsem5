# Experiment 6 – Arithmetic Expression Evaluation using Lex and Yacc

## Aim

To design and implement an **arithmetic expression calculator using Lex and Yacc**, where Lex identifies numbers and operators and Yacc parses the expression according to the grammar and evaluates the result.

## Objective

* Use **Lex/Flex** for lexical analysis.
* Use **Yacc/Bison** for syntax analysis and evaluation.
* Recognize numerical values and arithmetic operators.
* Handle operator precedence and associativity.
* Support parentheses and unary minus.
* Display the calculated result.

## Files

| File            | Purpose                           |
| --------------- | --------------------------------- |
| `cal.l`         | Lex/Flex source file              |
| `cal.y`         | Yacc/Bison grammar and evaluation |
| `lex.yy(5).c`   | Generated Lex scanner             |
| `cal.tab.c`     | Generated Yacc parser             |
| `cal.tab.h`     | Generated parser header           |
| `calc.exe`      | Executable                        |
| `output(5).txt` | Sample output                     |

The Lex source defines a `DIGIT` pattern for numbers, converts matched numbers using `atof()`, and returns them as the `NUM` token. 

---

## Description

This experiment implements a **simple arithmetic calculator using Lex and Yacc**.

The user enters an arithmetic expression such as:

```text
3/3
```

The input passes through two stages:

```text
Arithmetic Expression
        ↓
      Lex
        ↓
   Tokens
        ↓
      Yacc
        ↓
 Grammar + Evaluation
        ↓
      Answer
```

For the supplied test, the program produces:

```text
Enter the expression:3/3
Answer: 1
```



---

## 1. Lex/Flex

The `cal.l` file is responsible for recognizing the input.

### Number Recognition

The pattern:

```text
DIGIT   [0-9]+
```

recognizes one or more digits.

When a number is found:

```c
yylval = atof(yytext);
return NUM;
```

The text matched by Lex is converted into a floating-point value and passed to Yacc as the `NUM` token. 

### Whitespace

Spaces and tabs are ignored:

```text
[ \t]
```

### Newline

A newline is returned to Yacc:

```c
\n { return '\n'; }
```

### Other Characters

Operators and parentheses are returned directly:

```c
. { return yytext[0]; }
```

Therefore symbols such as:

```text
+  -  *  /  (  )
```

are passed to the parser.

---

# 2. Yacc/Bison

The `cal.y` file contains the grammar and the actual arithmetic calculations.

The parser uses:

```c
#define YYSTYPE double
```

so arithmetic values are stored as `double`. 

The generated parser recognizes:

* `NUM`
* `+`
* `-`
* `*`
* `/`
* `(`
* `)`
* `UMINUS`
* newline

These are reflected in the generated Bison parser/header.

---

## 3. Operator Precedence

The grammar defines:

```yacc
%left '+' '-'
%left '*' '/'
%right UMINUS
```

This establishes the order in which operations are evaluated.

### Precedence

```text
Highest
   ↓
Unary minus
   ↓
* and /
   ↓
+ and -
   ↓
Lowest
```

For example:

```text
2 + 3 * 4
```

is evaluated as:

```text
2 + (3 * 4)
```

giving:

```text
14
```

rather than:

```text
(2 + 3) * 4
```

---

# 4. Grammar

The main expression grammar is:

```yacc
E
    : E '+' E
    | E '-' E
    | E '*' E
    | E '/' E
    | '(' E ')'
    | '-' E %prec UMINUS
    | NUM
    ;
```

The generated parser contains **9 grammar rules** and **19 parser states** for this calculator grammar.

---

## 5. How Each Rule Works

### Addition

```yacc
E '+' E { $$ = $1 + $3; }
```

Example:

```text
5 + 3
```

Result:

```text
8
```

### Subtraction

```yacc
E '-' E { $$ = $1 - $3; }
```

Example:

```text
5 - 3
```

Result:

```text
2
```

### Multiplication

```yacc
E '*' E { $$ = $1 * $3; }
```

Example:

```text
5 * 3
```

Result:

```text
15
```

### Division

```yacc
E '/' E { $$ = $1 / $3; }
```

Example:

```text
6 / 3
```

Result:

```text
2
```

### Parentheses

```yacc
'(' E ')' { $$ = $2; }
```

This allows expressions such as:

```text
(2 + 3) * 4
```

### Unary Minus

```yacc
'-' E %prec UMINUS { $$ = -$2; }
```

This allows:

```text
-5
```

or:

```text
-(2 + 3)
```

---

# 6. Meaning of `$1`, `$2`, `$3` and `$$`

This is an important Yacc concept.

For:

```yacc
E '+' E
```

there are three symbols:

```text
$1       $2       $3
 E        +        E
```

`$$` represents the value of the entire expression.

Therefore:

```c
$$ = $1 + $3;
```

means:

```text
result = left expression + right expression
```

For:

```text
3 + 4
```

the parser effectively calculates:

```text
$1 = 3
$3 = 4

$$ = 3 + 4
   = 7
```

---

# 7. Working Example

Input:

```text
3/3
```

### Step 1 – Lex

Lex recognizes:

```text
3    → NUM
/    → '/'
3    → NUM
\n   → newline
```

So Yacc receives approximately:

```text
NUM / NUM '\n'
```

### Step 2 – Yacc

The parser matches:

```text
E → E / E
```

### Step 3 – Semantic Action

The rule performs:

```c
$$ = $1 / $3;
```

Therefore:

```text
$$ = 3 / 3
   = 1
```

### Step 4 – Output

The `Statement` rule prints:

```c
printf("Answer: %g\n", $1);
```

Result:

```text
Answer: 1
```

This matches the supplied execution output. 

---

# 8. Complete Working Flow

```text
             User
              │
              ↓
       3 + 4 * 2
              │
              ↓
        ┌──────────┐
        │   Lex    │
        │  Scanner │
        └────┬─────┘
             │
             ↓
       NUM + NUM * NUM
             │
             ↓
        ┌──────────┐
        │   Yacc   │
        │  Parser   │
        └────┬─────┘
             │
             ↓
     Apply precedence
             │
             ↓
        3 + (4 * 2)
             │
             ↓
            11
             │
             ↓
       Answer: 11
```

---

# 9. Compilation

### Generate the Yacc parser

```bash
bison -d cal.y
```

This produces:

```text
cal.tab.c
cal.tab.h
```

The supplied `cal.tab.h` defines the `NUM` and `UMINUS` tokens. 

### Generate the Lex scanner

```bash
flex cal.l
```

This produces:

```text
lex.yy.c
```

### Compile

```bash
gcc cal.tab.c lex.yy.c -o calc
```

### Run

Linux:

```bash
./calc
```

Windows:

```bash
calc.exe
```

---

# 10. Sample Inputs

### Addition

```text
5+3
```

Output:

```text
Answer: 8
```

### Multiplication and precedence

```text
2+3*4
```

Output:

```text
Answer: 14
```

### Parentheses

```text
(2+3)*4
```

Output:

```text
Answer: 20
```

### Unary minus

```text
-5+10
```

Output:

```text
Answer: 5
```

### Division

```text
3/3
```

Output:

```text
Answer: 1
```

The last case is the actual supplied test output. 

---

# Result

The Lex and Yacc based arithmetic calculator was successfully implemented. It accepts arithmetic expressions containing **numbers, addition, subtraction, multiplication, division, parentheses, and unary minus**, evaluates them according to the specified precedence, and displays the result.

## Conclusion

Thus, **Experiment 6 – Arithmetic Expression Evaluation using Lex and Yacc** was successfully completed. The experiment demonstrates how **Lex performs tokenization** while **Yacc performs parsing and semantic evaluation** of arithmetic expressions.

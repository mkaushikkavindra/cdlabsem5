# Experiment 5 – Validation of C Control Structures using Lex and Yacc

## Aim

To design and implement a **Lex and Yacc program to recognize and validate C control structure syntax**.

## Objective

* Use **Lex/Flex** to identify keywords, identifiers, numbers, operators, and symbols.
* Use **Yacc/Bison** to define grammar rules for C control structures.
* Validate structures such as `if`, `else`, `for`, `while`, and `switch-case`.
* Display whether the given control structure has valid syntax.

## Software Requirements

* Lex/Flex
* Yacc/Bison
* GCC Compiler
* C Programming Environment

## Files

| File            | Description                 |
| --------------- | --------------------------- |
| `control.l`     | Lex/Flex source file        |
| `control.y`     | Yacc/Bison grammar file     |
| `lex.yy(4).c`   | Generated Lex/Flex C file   |
| `control.tab.c` | Generated Yacc/Bison parser |
| `control.tab.h` | Generated header file       |
| `control.exe`   | Compiled executable         |
| `output(4).txt` | Sample execution output     |

---

## Description

This experiment uses **Lex/Flex and Yacc/Bison** to validate the syntax of C control structures.

The basic working flow is:

```text
C Control Structure
        ↓
     Lex/Flex
        ↓
      Tokens
        ↓
     Yacc/Bison
        ↓
   Grammar Checking
        ↓
   ┌────┴────┐
   ↓         ↓
 Valid      Invalid
```

Lex identifies the individual components of the input, while Yacc checks whether those components occur in a valid order according to the grammar.

---

## Lex/Flex

The `control.l` file performs lexical analysis.

It recognizes C control-structure keywords including:

```text
if
else
for
while
switch
case
default
```

It also recognizes:

* Identifiers
* Numbers
* `{ }`
* `( )`
* `:`
* `;`
* Relational operators
* Assignment operator

The generated scanner returns tokens such as `IF`, `ELSE`, `FOR`, `WHILE`, `SWITCH`, `CASE`, `DEFAULT`, `ID`, and `NUM`. 

---

## Yacc/Bison

The `control.y` file defines the grammar for the control structures.

The generated parser contains grammar components for:

```text
program
stmt_list
stmt
block
if_stmt
while_stmt
for_stmt
switch_stmt
case_list
cond
relop
```



The generated parser contains **26 grammar rules** and **69 parser states**. 

---

## Tokens

The parser recognizes the following major tokens:

| Token       | Meaning           |
| ----------- | ----------------- |
| `IF`        | `if` keyword      |
| `ELSE`      | `else` keyword    |
| `FOR`       | `for` keyword     |
| `WHILE`     | `while` keyword   |
| `SWITCH`    | `switch` keyword  |
| `CASE`      | `case` keyword    |
| `DEFAULT`   | `default` keyword |
| `ID`        | Identifier        |
| `NUM`       | Number            |
| `LBRACE`    | `{`               |
| `RBRACE`    | `}`               |
| `LPAREN`    | `(`               |
| `RPAREN`    | `)`               |
| `COLON`     | `:`               |
| `SEMICOLON` | `;`               |
| `EQ`        | `==`              |
| `LE`        | `<=`              |
| `GE`        | `>=`              |
| `LT`        | `<`               |
| `GT`        | `>`               |
| `ASSIGN`    | `=`               |

These tokens are defined in the generated Bison header. 

---

## Control Structures Supported

The grammar provides separate non-terminals for several C control structures:

```text
if_stmt
while_stmt
for_stmt
switch_stmt
```

It also includes `case_list` for handling `switch-case` structures. 

### 1. If Statement

Example:

```c
if(x) {}
```

The parser checks the `if` keyword, condition, parentheses, and block structure.

### 2. While Loop

Example:

```c
while(x) {}
```

### 3. For Loop

Example:

```c
for(x=1;x<10;x=x+1) {}
```

### 4. Switch Statement

Example:

```c
switch(x){
case 1:{}
default:{}
}
```

---

## Sample Execution

The provided output uses:

```text
Enter a C control structure syntax:
switch(x){case 1:{} default:{}}
Valid control structure syntax.
```



This demonstrates that the given `switch-case` structure successfully matches the grammar.

---

## Working Example

Consider:

```c
switch(x){case 1:{} default:{}}
```

### Step 1 – Lexical Analysis

Lex breaks the input into tokens approximately as:

```text
SWITCH
LPAREN
ID
RPAREN
LBRACE
CASE
NUM
COLON
LBRACE
RBRACE
DEFAULT
COLON
LBRACE
RBRACE
RBRACE
```

### Step 2 – Syntax Analysis

Yacc receives these tokens and attempts to match them with:

```text
switch_stmt
      ↓
   case_list
      ↓
 case + default
```

### Step 3 – Result

Since the structure satisfies the grammar:

```text
Valid control structure syntax.
```

---

## Error Handling

The parser's `yyerror()` function prints:

```text
Invalid control structure syntax.
```

when a syntax error occurs. If parsing succeeds, the main function prints:

```text
Valid control structure syntax.
```



Therefore:

```text
Valid syntax   → Valid control structure syntax.
Invalid syntax → Invalid control structure syntax.
```

---

## Lex vs Yacc

| Lex/Flex                               | Yacc/Bison                |
| -------------------------------------- | ------------------------- |
| Performs lexical analysis              | Performs syntax analysis  |
| Recognizes keywords and symbols        | Checks grammar            |
| Generates tokens                       | Processes tokens          |
| Recognizes `if`, `for`, `switch`, etc. | Validates their structure |
| Generates `lex.yy.c`                   | Generates `control.tab.c` |

In simple terms:

```text
Lex  → "What is each word/symbol?"
Yacc → "Is their arrangement valid?"
```

---

## Compilation and Execution

### Step 1 – Generate Parser

```bash
bison -d control.y
```

This generates:

```text
control.tab.c
control.tab.h
```

### Step 2 – Generate Scanner

```bash
flex control.l
```

This generates:

```text
lex.yy.c
```

### Step 3 – Compile

```bash
gcc control.tab.c lex.yy.c -o control
```

### Step 4 – Run

Linux:

```bash
./control
```

Windows:

```bash
control.exe
```

---

## Execution Flow

```text
Input C Control Structure
          ↓
       Flex
          ↓
   Lexical Tokens
          ↓
       Bison
          ↓
   Grammar Analysis
          ↓
      yyparse()
          ↓
   ┌──────┴──────┐
   ↓             ↓
 Accepted       Error
   ↓             ↓
Valid          Invalid
```

---

## Result

The Lex and Yacc program successfully validates C control structure syntax.

The provided test:

```c
switch(x){case 1:{} default:{}}
```

was successfully accepted and produced:

```text
Valid control structure syntax.
```



## Conclusion

Thus, a **C control structure syntax validator using Lex/Flex and Yacc/Bison** was successfully implemented. Lex identifies the keywords, identifiers, numbers, operators, and punctuation, while Yacc verifies whether their arrangement conforms to the defined grammar.

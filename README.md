# CS4501 – Compiler Design Lab

## Overview

This repository contains the implementation of **10 Compiler Design laboratory experiments** using **FLEX (LEX)** and **BISON (YACC)**.

The experiments progress from basic lexical analysis and pattern recognition to parsing, intermediate-code generation, optimization, and finally backend code generation for 8086 assembly.

The overall progression is:

```text
Lexical Analysis
      ↓
Token Recognition
      ↓
Pattern / Variable / Expression Validation
      ↓
Syntax Analysis
      ↓
Intermediate Code Generation (TAC)
      ↓
Code Optimization
      ↓
Backend Code Generation
      ↓
8086 Assembly
```

---

## Experiments

| No. | Experiment | Main Concept | Tool |
|---:|---|---|---|
| 1 | Lexical Analyzer with Symbol Table | Tokens, identifiers, constants, comments, operators, symbol table | FLEX |
| 2 | Lexical Analyzer using LEX | Keywords, identifiers, numbers, operators, delimiters, headers | FLEX |
| 3 | Arithmetic Expression Validation | Grammar-based expression recognition | FLEX + BISON |
| 4 | Variable Name Validation | Valid variable-name grammar | FLEX + BISON |
| 5 | C Control Structure Validation | `if`, `else`, `for`, `while`, `switch-case` | FLEX + BISON |
| 6 | Calculator | Arithmetic expression evaluation and precedence | FLEX + BISON |
| 7 | Three Address Code Generation | Intermediate representation using temporaries | FLEX + BISON |
| 8 | Type Checking | Symbol table and type compatibility | FLEX + BISON |
| 9 | Code Optimization | Constant folding, algebraic simplification, strength reduction | FLEX + BISON |
| 10 | Backend Code Generation | TAC to 8086 assembly | FLEX + BISON |

The experiment sequence and compiler-design focus are based on the supplied CS4501 Compiler Design laboratory manual. fileciteturn20file6turn20file11turn20file5

---

# Experiment 1 – Lexical Analyzer with Symbol Table

### Aim

Develop a lexical analyzer using FLEX to recognize tokens such as:

- Identifiers
- Constants
- Comments
- Operators

and create a **symbol table** while recognizing identifiers.

### Key Concepts

- Lexical analysis
- Regular expressions
- Token recognition
- Identifier lookup
- Symbol table
- `insert()` and `lookup()` functions

### Example

Input:

```c
int a = 10;
b = a + 5;
```

The lexer identifies identifiers, constants, operators, and comments and stores recognized identifiers in the symbol table.

### Main File

```text
symtab.l
```

### Compilation

```bash
flex symtab.l
gcc lex.yy.c -o symtab -lfl
./symtab input.c
```

The supplied laboratory implementation uses a symbol table array and avoids duplicate insertion through `lookup()`. fileciteturn19file6

---

# Experiment 2 – Lexical Analyzer using LEX

### Aim

Implement a lexical analyzer using FLEX to identify different components of C source code.

### Tokens Recognized

- Preprocessor directives
- Header files
- Keywords
- Identifiers
- Numbers
- Operators
- Delimiters

### Example

```c
#include <stdio.h>

int a = 10;
```

The lexer categorizes each recognized component.

### Main File

```text
lexer.l
```

### Compilation

```bash
flex lexer.l
gcc lex.yy.c -o lexer -lfl
./lexer input.c
```

This experiment demonstrates how regular expressions can be used to convert source-code characters into meaningful lexical categories. fileciteturn19file7

---

# Experiment 3 – Arithmetic Expression Validation

### Aim

Recognize and validate arithmetic expressions using FLEX and BISON.

### Operators Supported

```text
+
-
*
/
```

The grammar also handles:

- Unary minus
- Parentheses
- Identifiers
- Digits

### Valid Example

```text
a+b*c-d/e
```

### Invalid Example

```text
a=b
```

The parser accepts an expression when it matches the defined grammar and reports an error otherwise. fileciteturn20file12

### Main Files

```text
art_expr.l
art_expr.y
```

### Compilation

```bash
flex art_expr.l
bison -d art_expr.y
gcc lex.yy.c art_expr.tab.c -o art_expr -lfl
./art_expr
```

---

# Experiment 4 – Variable Name Validation

### Aim

Recognize a valid variable name that starts with a letter and is followed by any number of letters or digits.

### Valid

```text
add
add1
var123
```

### Invalid

```text
1add
```

The grammar follows the basic rule:

```text
variable → letter (letter | digit)*
```

### Main Files

```text
valvar.l
valvar.y
```

### Compilation

```bash
flex valvar.l
bison -d valvar.y
gcc lex.yy.c valvar.tab.c -o valvar -lfl
./valvar
```

The supplied experiment verifies `add` and `add1` as valid and `1add` as invalid. fileciteturn20file11

---

# Experiment 5 – C Control Structure Validation

### Aim

Recognize valid C control-structure syntax using FLEX and BISON.

### Structures Covered

- `if`
- `if-else`
- `while`
- `for`
- `switch-case`
- `default`

### Example

```c
if (x < 5) { y = 10; }
```

Expected result:

```text
Valid control structure syntax.
```

The BISON grammar contains separate productions for `if_stmt`, `while_stmt`, `for_stmt`, `switch_stmt`, `case_list`, and conditions. fileciteturn20file10

### Main Files

```text
control.l
control.y
```

### Compilation

```bash
flex control.l
bison -d control.y
gcc lex.yy.c control.tab.c -o control -lfl
./control
```

---

# Experiment 6 – Calculator using LEX and YACC

### Aim

Implement a calculator using FLEX and BISON.

### Operations

```text
+
-
*
/
```

The grammar uses operator precedence and associativity so that multiplication and division are evaluated before addition and subtraction.

### Example

Input:

```text
2+2
```

Output:

```text
Answer: 4
```

The calculator grammar defines `E + E`, `E - E`, `E * E`, and `E / E` rules and uses precedence declarations. fileciteturn20file0

### Main Files

```text
cal.l
cal.y
```

### Compilation

```bash
flex cal.l
bison -d cal.y
gcc lex.yy.c cal.tab.c -o calc -lfl
./calc
```

---

# Experiment 7 – Three Address Code Generation

### Aim

Generate **Three Address Code (TAC)** for a simple arithmetic expression.

### Example

Input:

```text
a = b + c * d
```

The expression is broken into intermediate operations using temporary variables:

```text
t1 = c * d
t2 = b + t1
a = t2
```

### Key Concepts

- Intermediate representation
- Temporary variables
- Operator precedence
- Syntax-directed translation
- TAC

### Main Files

```text
tac.l
tac.y
```

### Compilation

```bash
flex tac.l
bison -d tac.y
gcc tac.tab.c lex.yy.c -o tac -lfl
./tac
```

The laboratory manual specifies maintaining a temporary-variable counter such as `t1`, `t2`, etc., while generating TAC during parsing. fileciteturn20file7

---

# Experiment 8 – Type Checking

### Aim

Implement type checking using FLEX and BISON.

The experiment recognizes declarations and assignments and uses a **symbol table** to associate variables with their data types.

### Types

```text
int
float
```

### Example

```c
int a;
int b;
int c;

a = b * c;
```

Conceptually, the symbol table contains:

```text
a → int
b → int
c → int
```

The expression is checked for type compatibility.

### Key Concepts

- Semantic analysis
- Symbol table
- Type lookup
- Type compatibility
- Type mismatch detection

### Main Files

```text
typecheck.l
typecheck.y
```

### Compilation

```bash
flex typecheck.l
bison -d typecheck.y
gcc lex.yy.c typecheck.tab.c -o typecheck -lfl
./typecheck
```

---

# Experiment 9 – Code Optimization

### Aim

Implement simple code optimization techniques using FLEX and BISON.

The experiment operates on arithmetic Three Address Code-style statements.

### Optimization Techniques

#### 1. Constant Folding

Evaluate constant expressions at compile time.

```text
a = 2 + 4;
```

becomes:

```text
a = 6
```

#### 2. Algebraic Simplification

Remove unnecessary operations using algebraic identities.

```text
b = d * 1;
```

becomes:

```text
b = d
```

#### 3. Strength Reduction

Replace an operation with a simpler equivalent operation.

```text
c = s * 2;
```

becomes:

```text
c = s + s
```

These three techniques are explicitly specified in the laboratory manual and demonstrated by the supplied output. fileciteturn20file3

### Main Files

```text
optimize.l
optimize.y
```

### Compilation

```bash
flex optimize.l
bison -d optimize.y
gcc lex.yy.c optimize.tab.c -o optimize -lfl
./optimize
```

---

# Experiment 10 – Backend Code Generation

### Aim

Implement the **backend of a compiler** that takes Three Address Code as input and produces equivalent **8086 assembly language code**.

### Input

Example TAC:

```text
t1 = a + b;
t2 = t1 - c;
t3 = t2 * d;
t4 = t3 / e;
x = t4;
```

### Generated Assembly

The supplied implementation generates instructions such as:

```asm
MOV AX, a
ADD AX, b
MOV t1, AX

MOV AX, t1
SUB AX, c
MOV t2, AX

MOV AX, t2
MUL d
MOV t3, AX

MOV AX, t3
MOV DX, 0
MOV BX, e
DIV BX
MOV t4, AX

MOV AX, t4
MOV x, AX
```

This demonstrates the final compiler stage in the repository: translating intermediate code into 8086-style assembly instructions. fileciteturn16file0turn20file5

### Main Files

```text
backend.l
backend.y
```

### Compilation

```bash
flex backend.l
bison -d backend.y
gcc lex.yy.c backend.tab.c -o backend -lfl
./backend
```

---

# Compiler Design Concepts Covered

Across the 10 experiments, the repository demonstrates the major stages and supporting concepts of a simple compiler.

```text
                 SOURCE PROGRAM
                       │
                       ↓
              ┌─────────────────┐
              │ Lexical Analysis│
              └────────┬────────┘
                       │
                       ↓
                    Tokens
                       │
                       ↓
              ┌─────────────────┐
              │ Syntax Analysis │
              │   FLEX+BISON    │
              └────────┬────────┘
                       │
                       ↓
              Valid Structure
                       │
                       ↓
              Semantic Analysis
                       │
                       ↓
                 Type Checking
                       │
                       ↓
              Intermediate Code
                       │
                       ↓
                     TAC
                       │
                       ↓
                Optimization
                       │
                       ↓
                Optimized TAC
                       │
                       ↓
                   Backend
                       │
                       ↓
               8086 Assembly
```

---

# FLEX and BISON

## FLEX

FLEX is used primarily for **lexical analysis**.

It reads characters and groups them into tokens using regular expressions.

Typical patterns include:

```text
[a-zA-Z_][a-zA-Z0-9_]*
[0-9]+
```

FLEX generates a C scanner, usually:

```text
lex.yy.c
```

---

## BISON

BISON is used primarily for **syntax analysis** and for performing actions associated with grammar productions.

It receives tokens from FLEX and checks them against grammar rules.

BISON generates files such as:

```text
program.tab.c
program.tab.h
```

---

# How FLEX and BISON Work Together

```text
Input
  │
  ↓
FLEX
  │
  │ identifies tokens
  ↓
Token Stream
  │
  ↓
BISON
  │
  │ applies grammar
  ↓
Parse / Semantic Action
  │
  ↓
Result
```

A simple way to remember it:

> **FLEX answers: "What is this?"**

> **BISON answers: "Is this arranged correctly?"**

---

# Common Compilation Workflow

Most FLEX/BISON experiments follow this workflow:

### 1. Create the FLEX file

```text
program.l
```

### 2. Create the BISON file

```text
program.y
```

### 3. Generate the BISON parser

```bash
bison -d program.y
```

### 4. Generate the FLEX scanner

```bash
flex program.l
```

### 5. Compile

```bash
gcc lex.yy.c program.tab.c -o program -lfl
```

### 6. Execute

```bash
./program
```

For Experiment 1 and Experiment 2, which are FLEX-only lexical-analysis programs, BISON is not required.

---

# Repository Structure

The repository is organized with each experiment in its own subfolder.

A typical structure is:

```text
Compiler-Design-Lab/
│
├── README.md
│
├── Experiment-1/
│   ├── source files
│   ├── generated files
│   └── output
│
├── Experiment-2/
│   ├── source files
│   ├── generated files
│   └── output
│
├── Experiment-3/
│   └── ...
│
├── Experiment-4/
│   └── ...
│
├── Experiment-5/
│   └── ...
│
├── Experiment-6/
│   └── ...
│
├── Experiment-7/
│   └── ...
│
├── Experiment-8/
│   └── ...
│
├── Experiment-9/
│   └── ...
│
└── Experiment-10/
    └── ...
```

Each experiment folder contains its respective FLEX/BISON source, generated parser/scanner files, executable/output files, and experiment-specific documentation where applicable.

---

# Technologies Used

- **FLEX / LEX** – Lexical analysis
- **BISON / YACC** – Syntax analysis and grammar processing
- **C** – Implementation language
- **GCC** – C compiler
- **8086 Assembly** – Target representation in Experiment 10

---

# Learning Outcomes

After completing these experiments, the following compiler-design concepts are demonstrated:

- Regular expressions and lexical analysis
- Tokenization
- Identifier recognition
- Symbol tables
- Syntax validation
- Context-free grammars
- FLEX and BISON integration
- Operator precedence and associativity
- Arithmetic expression evaluation
- Semantic actions
- Type checking
- Intermediate representation
- Three Address Code
- Temporary variables
- Code optimization
- Constant folding
- Algebraic simplification
- Strength reduction
- Backend code generation
- 8086 assembly instructions

---

# From Experiment 1 to Experiment 10

The experiments can be viewed as a progressive compiler-building journey:

| Stage | Experiment | What is learned |
|---|---|---|
| 1 | Lexical Analyzer + Symbol Table | Recognize tokens and maintain symbols |
| 2 | Lexical Analyzer | Classify C source-code tokens |
| 3 | Expression Validation | Validate arithmetic grammar |
| 4 | Variable Validation | Validate identifier structure |
| 5 | Control Structures | Validate C control-flow syntax |
| 6 | Calculator | Parse and evaluate expressions |
| 7 | TAC Generation | Convert expressions into intermediate code |
| 8 | Type Checking | Perform basic semantic analysis |
| 9 | Optimization | Improve intermediate code |
| 10 | Backend | Convert TAC into assembly |

This makes the repository more than a collection of individual programs: together, the experiments demonstrate a simplified **compiler pipeline from source-level syntax to target-level code**.

---

# Result

All 10 Compiler Design laboratory experiments were implemented using FLEX/BISON-based techniques as specified by the laboratory work. The experiments progress from lexical analysis and grammar validation through semantic analysis, intermediate-code generation, optimization, and backend code generation.

## Conclusion

This repository provides a practical implementation of fundamental **Compiler Design concepts**, demonstrating how a compiler can progressively transform source-level constructs into intermediate representations and finally into target assembly code.

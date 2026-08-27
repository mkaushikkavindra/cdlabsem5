# Experiment 7 – Three Address Code Generation using Lex and Yacc

## Aim

To design and implement a **Three Address Code (TAC) generator using Lex and Yacc**, which takes an arithmetic assignment expression as input and generates equivalent intermediate code using temporary variables.

## Objective

* Use **Lex/Flex** for lexical analysis.
* Use **Yacc/Bison** for syntax analysis.
* Recognize identifiers, numbers, operators, and assignment symbols.
* Parse arithmetic expressions.
* Generate **Three Address Code (TAC)** using temporary variables.
* Demonstrate how a complex expression can be broken into simple instructions.

---

## Files

| File            | Purpose                               |
| --------------- | ------------------------------------- |
| `tac.l`         | Lex/Flex source file                  |
| `tac.y`         | Yacc/Bison grammar and TAC generation |
| `lex.yy(6).c`   | Generated Lex scanner                 |
| `tac.tab.c`     | Generated Yacc parser                 |
| `tac.tab.h`     | Generated parser header               |
| `tac.exe`       | Executable                            |
| `output(6).txt` | Sample output                         |

The generated Bison header defines the two main tokens used by the parser: `ID` for identifiers and `NUM` for numbers. 

---

# 1. What is Three Address Code?

**Three Address Code (TAC)** is an intermediate representation used by compilers.

The basic idea is to break a complicated expression into **small instructions**, where each instruction performs one operation.

For example:

```text
a = b + c * d
```

Instead of handling the entire expression at once, TAC breaks it into:

```text
t1 = c * d
t2 = b + t1
a = t2
```

Here:

* `t1` → temporary variable
* `t2` → another temporary variable
* `c * d` → performed first
* `b + t1` → performed next
* `a = t2` → final assignment

This is exactly the transformation demonstrated by the supplied program output. 

---

# 2. Basic Structure of TAC

A typical TAC instruction has at most three addresses:

```text
x = y op z
```

For example:

```text
t1 = c * d
```

contains:

```text
t1     =     c     *     d
 ↑            ↑          ↑
result      operand    operand
```

Other common forms include:

```text
x = y + z
x = y - z
x = y * z
x = y / z
x = y
```

---

# 3. Overall Working

The experiment uses **Lex + Yacc**.

```text
             Input
               │
               ↓
        ┌─────────────┐
        │    Lex      │
        │   Scanner   │
        └──────┬──────┘
               │
               ↓
             Tokens
               │
               ↓
        ┌─────────────┐
        │    Yacc     │
        │   Parser    │
        └──────┬──────┘
               │
               ↓
       Expression Grammar
               │
               ↓
       Generate Temporaries
               │
               ↓
        Three Address Code
```

---

# 4. Lex/Flex

The `tac.l` file performs lexical analysis.

Its job is to identify different types of input symbols.

The scanner recognizes:

* Identifiers
* Numbers
* Operators
* Assignment operator
* Parentheses
* Whitespace/newlines

The generated scanner returns `ID` for identifiers and `NUM` for numbers. For both, it stores a copy of the matched text in `yylval.str`. 

### Example

For:

```text
a=b+c*d
```

Lex conceptually produces:

```text
ID  =  ID  +  ID  *  ID
```

More specifically:

```text
a    → ID
=    → '='
b    → ID
+    → '+'
c    → ID
*    → '*'
d    → ID
```

---

# 5. Yacc/Bison

The `tac.y` file performs syntax analysis and generates the TAC.

The parser uses:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
```

and maintains:

```c
int tempCount = 1;
char temp[20];
```

The `tempCount` variable is used to generate temporary variable names such as:

```text
t1
t2
t3
...
```

The generated Bison parser contains the terminals:

```text
ID
NUM
+
-
*
/
=
(
)
```

and the non-terminals:

```text
stmt
expr
```



---

# 6. Why Temporary Variables Are Needed

Consider:

```text
a = b + c * d
```

There are two operations:

```text
c * d
b + result
```

The result of the first operation needs to be stored somewhere.

So the compiler creates:

```text
t1 = c * d
```

Then:

```text
t2 = b + t1
```

Finally:

```text
a = t2
```

Thus, temporary variables allow the compiler to represent complex expressions as a sequence of simple operations.

---

# 7. Operator Precedence

The expression:

```text
b + c * d
```

must be interpreted as:

```text
b + (c * d)
```

and **not**:

```text
(b + c) * d
```

Therefore multiplication has higher precedence than addition.

The generated parser has separate grammar rules for:

```text
+
-
*
/
```

as well as parentheses, allowing arithmetic expressions to be decomposed into TAC instructions. 

---

# 8. Example: Step-by-Step

Input:

```text
a=b+c*d
```

### Step 1 – Lexical Analysis

Lex identifies:

```text
a → ID
= → '='
b → ID
+ → '+'
c → ID
* → '*'
d → ID
```

---

### Step 2 – Parsing

Yacc sees the expression:

```text
b + c * d
```

Because `*` has higher precedence:

```text
b + (c * d)
```

is formed.

---

### Step 3 – Generate First Temporary

Evaluate:

```text
c * d
```

Generate:

```text
t1 = c * d
```

---

### Step 4 – Generate Second Temporary

Now the expression becomes:

```text
b + t1
```

Generate:

```text
t2 = b + t1
```

---

### Step 5 – Assignment

Finally:

```text
a = t2
```

---

## Final TAC

```text
t1 = c * d
t2 = b + t1
a = t2
```

This is the actual output produced by the supplied experiment. 

---

# 9. Complete Working Flow

For:

```text
a=b+c*d
```

the complete process can be visualized as:

```text
Input
  │
  ↓
a = b + c * d
  │
  ↓
Lexical Analysis
  │
  ↓
ID = ID + ID * ID
  │
  ↓
Syntax Analysis
  │
  ↓
b + (c * d)
  │
  ↓
Generate TAC
  │
  ├── c * d → t1
  │
  ├── b + t1 → t2
  │
  └── a = t2
  │
  ↓
t1 = c * d
t2 = b + t1
a = t2
```

---

# 10. Important Terms

### Identifier (`ID`)

A variable name such as:

```text
a
b
total
x
```

### Number (`NUM`)

A numeric constant such as:

```text
10
25
100
```

### Operator

Arithmetic symbols:

```text
+
-
*
/
```

### Temporary Variable

A compiler-generated variable used to store intermediate results:

```text
t1
t2
t3
```

### Three Address Code

An intermediate representation where each instruction performs a simple operation, such as:

```text
t1 = c * d
```

---

# 11. Compilation

### Generate the Yacc parser

```bash
bison -d tac.y
```

This generates:

```text
tac.tab.c
tac.tab.h
```

### Generate the Lex scanner

```bash
flex tac.l
```

This generates:

```text
lex.yy.c
```

### Compile

```bash
gcc tac.tab.c lex.yy.c -o tac
```

### Run

Linux:

```bash
./tac
```

Windows:

```bash
tac.exe
```

---

# 12. Sample Input and Output

### Input

```text
Enter the expression: a=b+c*d
```

### Output

```text
t1 = c * d
t2 = b + t1
a = t2
```

The supplied `output(6).txt` contains this exact result. 

---

# Result

The **Three Address Code generator using Lex and Yacc** was successfully implemented. The program accepts an arithmetic assignment expression, parses it, creates temporary variables for intermediate results, and produces the corresponding Three Address Code.

## Conclusion

Thus, **Experiment 7 – Three Address Code Generation using Lex and Yacc** was successfully completed. The experiment demonstrates how a compiler can transform a high-level arithmetic expression into a sequence of simple **intermediate code instructions** using temporary variables.

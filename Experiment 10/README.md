# Experiment 10 – Backend Code Generation using Lex and Yacc

---

## 1. Aim

To implement a **backend code generator using Lex and Yacc** that converts **Three Address Code (TAC)** into corresponding **assembly language instructions**.

In simple words:

```text
Three Address Code
        ↓
   Lex + Yacc
        ↓
Assembly Code
```

---

# 2. What is a Backend?

Remember the compiler pipeline:

```text
Source Code
    ↓
Lexical Analysis
    ↓
Syntax Analysis
    ↓
Semantic Analysis
    ↓
Intermediate Code
    ↓
Optimization
    ↓
       BACKEND
    ↓
Target / Assembly Code
```

The **backend** is the part of the compiler that takes intermediate representation such as TAC and converts it into code for a target machine.

So this experiment is basically:

> **TAC → Assembly**

---

# 3. What Exactly Are We Building?

The project contains:

| File            | Purpose                             |
| --------------- | ----------------------------------- |
| `backend.l`     | Lex/Flex lexical analyzer           |
| `backend.y`     | Yacc/Bison parser + code generation |
| `backend.tab.h` | Generated token definitions         |
| `backend.tab.c` | Generated parser                    |
| `lex.yy.c`      | Generated scanner                   |
| `backend.exe`   | Executable                          |
| `output.txt`    | Sample execution                    |

The generated Bison header shows that the main named token is `ID`, while the grammar also handles `+`, `-`, `*`, `/`, `=`, and `;`. 

---

# 4. First Understand TAC

Suppose we want to calculate:

```text
x = (a + b - c) * d / e
```

A compiler may represent this as TAC:

```text
t1 = a + b
t2 = t1 - c
t3 = t2 * d
t4 = t3 / e
x = t4
```

This is much easier for a compiler backend to process because every operation is simple.

The Experiment 10 input represents these operations in a form such as:

```text
MOV AX, a
ADD AX, b
MOV t1, AX
```



---

# 5. What is Assembly Code?

Assembly language is a low-level representation of instructions that operate directly on CPU registers and memory.

For example:

```text
MOV AX, a
```

means:

> Put the value of `a` into register `AX`.

And:

```text
ADD AX, b
```

means:

> Add `b` to whatever is currently in `AX`.

So:

```text
MOV AX, a
ADD AX, b
```

essentially performs:

```text
AX = a + b
```

---

# 6. Important Registers in This Experiment

Your output uses three registers:

### AX

Main arithmetic register.

It is used for:

```text
MOV
ADD
SUB
MUL
DIV
```

### BX

Used as another register, particularly for division.

For example:

```text
MOV BX, e
DIV BX
```

### DX

Used with division.

Before division, the program generates:

```text
MOV DX, 0
```

Your sample output explicitly contains these instructions. 

---

# 7. The Main Idea

The backend sees an operation and generates the corresponding assembly instruction.

Think of it like a translator:

| TAC operation | Assembly                                                               |
| ------------- | ---------------------------------------------------------------------- |
| `t1 = a + b`  | `MOV AX, a`<br>`ADD AX, b`<br>`MOV t1, AX`                             |
| `t2 = t1 - c` | `MOV AX, t1`<br>`SUB AX, c`<br>`MOV t2, AX`                            |
| `t3 = t2 * d` | `MOV AX, t2`<br>`MUL d`<br>`MOV t3, AX`                                |
| `t4 = t3 / e` | `MOV AX, t3`<br>`MOV DX, 0`<br>`MOV BX, e`<br>`DIV BX`<br>`MOV t4, AX` |
| `x = t4`      | `MOV AX, t4`<br>`MOV x, AX`                                            |

That is exactly what your sample demonstrates. 

---

# 8. Let's Understand the Complete Example

The uploaded output is:

```text
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



Let's understand **every line**.

---

# 9. First Operation: Addition

The first block is:

```text
MOV AX, a
ADD AX, b
MOV t1, AX
```

### Step 1

```text
MOV AX, a
```

Means:

```text
AX = a
```

### Step 2

```text
ADD AX, b
```

Means:

```text
AX = AX + b
```

Since AX already contains `a`:

```text
AX = a + b
```

### Step 3

```text
MOV t1, AX
```

Stores the result:

```text
t1 = a + b
```

So the whole block:

```text
MOV AX, a
ADD AX, b
MOV t1, AX
```

means:

```text
t1 = a + b
```

---

# 10. Second Operation: Subtraction

Next:

```text
MOV AX, t1
SUB AX, c
MOV t2, AX
```

### Step 1

```text
MOV AX, t1
```

```text
AX = t1
```

### Step 2

```text
SUB AX, c
```

```text
AX = AX - c
```

Therefore:

```text
AX = t1 - c
```

### Step 3

```text
MOV t2, AX
```

Therefore:

```text
t2 = t1 - c
```

So the entire block represents:

```text
t2 = t1 - c
```

---

# 11. Third Operation: Multiplication

Next:

```text
MOV AX, t2
MUL d
MOV t3, AX
```

### Step 1

```text
MOV AX, t2
```

```text
AX = t2
```

### Step 2

```text
MUL d
```

means multiplication with `d`.

Conceptually:

```text
AX = t2 × d
```

### Step 3

```text
MOV t3, AX
```

Therefore:

```text
t3 = t2 × d
```

---

# 12. Fourth Operation: Division

This is the most interesting part:

```text
MOV AX, t3
MOV DX, 0
MOV BX, e
DIV BX
MOV t4, AX
```

Let's go slowly.

### Step 1

```text
MOV AX, t3
```

```text
AX = t3
```

### Step 2

```text
MOV DX, 0
```

The code clears `DX` before division.

```text
DX = 0
```

### Step 3

```text
MOV BX, e
```

```text
BX = e
```

### Step 4

```text
DIV BX
```

The division uses the value in `BX` as the divisor.

The relevant conceptual operation here is:

```text
t3 / e
```

### Step 5

```text
MOV t4, AX
```

The quotient is taken from `AX` and stored in `t4`.

So:

```text
t4 = t3 / e
```

The exact division sequence is present in the supplied output. 

---

# 13. Final Assignment

Finally:

```text
MOV AX, t4
MOV x, AX
```

This simply transfers the final value.

First:

```text
AX = t4
```

Then:

```text
x = AX
```

Therefore:

```text
x = t4
```

---

# 14. Overall Mathematical Meaning

If we combine everything:

### First

```text
t1 = a + b
```

### Second

```text
t2 = t1 - c
```

### Third

```text
t3 = t2 * d
```

### Fourth

```text
t4 = t3 / e
```

### Finally

```text
x = t4
```

Therefore the final mathematical expression is:

```text
x = ((a + b) - c) * d / e
```

That's the easiest way to understand the entire experiment.

---

# 15. Where Does Lex Come In?

`backend.l` is responsible for recognizing pieces of the input.

The generated scanner shows a rule that recognizes identifiers and returns the `ID` token. 

For example:

```text
MOV AX, a
```

Lex can identify:

```text
MOV
AX
a
```

Similarly:

```text
ADD AX, b
```

becomes recognizable pieces such as:

```text
ADD
AX
b
```

Lex's job is essentially:

> **"What are these words/symbols?"**

---

# 16. Where Does Yacc Come In?

Yacc receives those tokens and determines their structure.

For example:

```text
MOV AX, a
ADD AX, b
MOV t1, AX
```

is treated as a valid sequence of backend instructions.

The Bison-generated parser contains grammar symbols including:

```text
stmt_list
stmt
expr
```

and terminals for:

```text
ID
+
-
*
/
=
;
```



Yacc's job is:

> **"Do these tokens form a valid instruction/statement?"**

---

# 17. Lex + Yacc Together

Think of them as two workers:

```text
             Input
               │
               ↓
        ┌──────────────┐
        │     LEX      │
        │ Tokenization │
        └──────┬───────┘
               │
             Tokens
               │
               ↓
        ┌──────────────┐
        │     YACC     │
        │   Parsing    │
        └──────┬───────┘
               │
               ↓
       Code Generation
               │
               ↓
       Assembly Output
```

---

# 18. What Does `backend.y` Actually Do?

This is the most important file conceptually.

`backend.y` contains:

1. C declarations
2. Grammar rules
3. Semantic actions
4. Code-generation logic

The generated parser confirms that it was produced from `backend.y` using **Bison 3.8.2**. 

So:

```text
backend.l
    ↓
tokens

backend.y
    ↓
parse tokens
    ↓
generate assembly
```

---

# 19. Experiment 9 vs Experiment 10

This distinction is **very important**.

### Experiment 9

```text
TAC
 ↓
Optimization
 ↓
Optimized TAC
```

Example:

```text
a = 2 + 4
```

becomes:

```text
a = 6
```

---

### Experiment 10

```text
TAC
 ↓
Backend
 ↓
Assembly
```

Example:

```text
t1 = a + b
```

becomes approximately:

```text
MOV AX, a
ADD AX, b
MOV t1, AX
```

So:

> **Experiment 9 improves the intermediate code. Experiment 10 translates intermediate code into target/assembly code.**

---

# 20. Complete Compiler Picture

Now you can connect Experiments 1–10 much more easily:

```text
        SOURCE PROGRAM
              │
              ↓
        Lexical Analysis
              │
              ↓
        Syntax Analysis
              │
              ↓
       Semantic Analysis
              │
              ↓
       Intermediate Code
              │
              ↓
       Code Optimization
              │
              ↓
       Backend / Code Generation
              │
              ↓
       Assembly / Target Code
```

Experiment 10 is sitting near the **end of the compiler pipeline**.

---

# 21. Compilation Commands

For this project, the typical sequence is:

### Step 1 — Generate parser

```bash
bison -d backend.y
```

This generates:

```text
backend.tab.c
backend.tab.h
```

### Step 2 — Generate scanner

```bash
flex backend.l
```

This generates:

```text
lex.yy.c
```

### Step 3 — Compile

```bash
gcc backend.tab.c lex.yy.c -o backend
```

### Step 4 — Run

```bash
./backend
```

On Windows:

```bash
backend.exe
```

---

# 22. One-Line Explanation of Each Component

| Component    | Simple meaning                            |
| ------------ | ----------------------------------------- |
| **TAC**      | Intermediate code                         |
| **Lex**      | Breaks input into tokens                  |
| **Yacc**     | Checks structure/grammar                  |
| **Backend**  | Converts intermediate code to target code |
| **Assembly** | Low-level target representation           |
| **AX**       | Main arithmetic register here             |
| **BX**       | Used as divisor register                  |
| **DX**       | Used during division                      |
| **MOV**      | Move/copy data                            |
| **ADD**      | Addition                                  |
| **SUB**      | Subtraction                               |
| **MUL**      | Multiplication                            |
| **DIV**      | Division                                  |

---

# 23. Viva-Friendly Explanation ⭐

If your examiner asks:

### **What is the aim of Experiment 10?**

> To implement a backend code generator using Lex and Yacc that converts Three Address Code into assembly language instructions.

### **What is backend?**

> Backend is the compiler phase that converts intermediate representation into target machine or assembly code.

### **What is the input?**

> Three Address Code statements.

### **What is the output?**

> Assembly-like instructions using registers such as AX, BX and DX.

### **What does Lex do?**

> Lex performs lexical analysis and identifies tokens such as identifiers and operators.

### **What does Yacc do?**

> Yacc parses the tokens according to grammar rules and performs the code-generation actions.

### **Why is AX used?**

> AX is used as the main arithmetic register for operations such as addition, subtraction, multiplication and division in this implementation.

### **Why is BX used for division?**

> The generated code loads the divisor into BX and then uses `DIV BX`.

### **Why is DX set to zero?**

> The generated division sequence clears DX before performing the division.

### **What is the difference between Experiment 9 and 10?**

> Experiment 9 performs code optimization, whereas Experiment 10 performs backend code generation from TAC to assembly.

---

# 24. The Entire Experiment in One Example

Remember just this:

```text
TAC:

t1 = a + b
t2 = t1 - c
t3 = t2 * d
t4 = t3 / e
x  = t4
```

↓

**Backend**

↓

```text
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

# Experiment 9 – Code Optimization using Lex and Yacc

## Aim

To implement a **code optimization technique using Lex and Yacc** for optimizing Three Address Code (TAC) expressions using:

1. **Constant Folding**
2. **Algebraic Simplification**
3. **Strength Reduction**

The given program accepts Three Address Code statements and produces an optimized version. The sample output demonstrates all three techniques. 

---

## Objective

* Use **Lex/Flex** for lexical analysis.
* Use **Yacc/Bison** for parsing expressions.
* Accept Three Address Code statements.
* Identify arithmetic expressions.
* Apply simple compiler optimization techniques.
* Generate optimized expressions instead of unnecessarily complex ones.

---

# 1. What is Code Optimization?

**Code optimization** means modifying a program or intermediate code so that it performs the same operation more efficiently.

For example:

```text
a = 2 + 4
```

There is no need for the compiler to calculate `2 + 4` every time the program runs.

It can directly become:

```text
a = 6
```

So:

```text
Before:  a = 2 + 4
After:   a = 6
```

This is called **Constant Folding**.

---

# 2. What is Three Address Code?

Three Address Code, or **TAC**, is an intermediate representation commonly used by compilers.

A TAC statement generally has the form:

```text
x = y op z
```

where:

* `x` → result
* `y` → first operand
* `z` → second operand
* `op` → arithmetic operator

For example:

```text
a = b + c
```

Here:

```text
a → result
b → operand 1
+ → operator
c → operand 2
```

The Experiment 9 program takes such statements as input. Its prompt is:

```text
Enter Three Address Code statements (Ctrl+D to stop):
```



---

# 3. What Does This Experiment Build?

Think of the program as a small **compiler optimizer**:

```text
        Three Address Code
                │
                ↓
             Lex/Flex
                │
                ↓
              Tokens
                │
                ↓
            Yacc/Bison
                │
                ↓
             Expression
                │
                ↓
        Optimization Rules
          /       |       \
         /        |        \
 Constant     Algebraic    Strength
 Folding     Simplification Reduction
          \       |       /
           \      |      /
             Optimized TAC
```

---

# 4. Lex/Flex

The file `optimize.l` performs lexical analysis.

The generated scanner recognizes:

| Input         | Token |
| ------------- | ----- |
| Variable name | `ID`  |
| Number        | `NUM` |
| `=`           | `=`   |
| `+`           | `+`   |
| `-`           | `-`   |
| `*`           | `*`   |
| `/`           | `/`   |
| `;`           | `;`   |

The generated Bison header confirms that `ID` and `NUM` are the main named tokens used by this optimizer. 

For example:

```text
a = 2 + 4;
```

Lex breaks it into approximately:

```text
ID  =  NUM  +  NUM  ;
```

---

# 5. Yacc/Bison

The Yacc file `optimize.y` contains the grammar and optimization actions.

The parser has grammar components such as:

```text
stmt_list
stmt
expr
```

and recognizes:

```text
ID
NUM
+
-
*
/
=
;
```

The generated parser shows the expression rules for addition, subtraction, multiplication and division.

---

# 6. Basic Grammar

Conceptually, the grammar works like this:

```text
stmt
    → ID = expr ;

expr
    → NUM
    → ID
    → expr + expr
    → expr - expr
    → expr * expr
    → expr / expr
```

So an input such as:

```text
a = 2 + 4;
```

is recognized as:

```text
ID = expr ;
       │
       └── expr + expr
```

The semantic actions then determine whether the expression can be optimized.

---

# 7. Optimization Technique 1 – Constant Folding

### Meaning

**Constant Folding** evaluates an expression at compile time when both operands are constants.

Example:

```text
a = 2 + 4;
```

Both `2` and `4` are constants.

Therefore:

```text
2 + 4 = 6
```

The optimizer produces:

```text
a = 6
```

The program explicitly prints:

```text
// Constant Folding: 2 + 4 -> 6
```

followed by:

```text
a = 6
```



---

### Another Example

```text
a = 8 - 3;
```

becomes:

```text
a = 5;
```

Similarly:

```text
a = 4 * 5;
```

becomes:

```text
a = 20;
```

and:

```text
a = 20 / 4;
```

becomes:

```text
a = 5;
```

The supplied parser implements constant folding for `+`, `-`, `*`, and `/`. 

---

# 8. Optimization Technique 2 – Algebraic Simplification

**Algebraic Simplification** uses mathematical identities to simplify expressions.

For example:

```text
x + 0 = x
```

Therefore:

```text
a = x + 0;
```

can become:

```text
a = x;
```

Another example:

```text
x * 1 = x
```

Therefore:

```text
b = d * 1;
```

becomes:

```text
b = d;
```

The program specifically implements the rule:

```text
x * 1 → x
```

and its sample output demonstrates:

```text
// Algebraic Simplification: x * 1 -> x
b = d
```



---

## Rules Implemented

### Addition

```text
x + 0 → x
0 + x → x
```

### Subtraction

```text
x - 0 → x
```

### Multiplication

```text
x * 1 → x
```

### Division

```text
x / 1 → x
```

These rules are implemented directly in the generated parser's semantic actions.

---

# 9. Optimization Technique 3 – Strength Reduction

**Strength Reduction** replaces an expensive or more complex operation with an equivalent simpler operation.

In this experiment, the implemented example is:

```text
x * 2 → x + x
```

For example:

```text
c = s * 2;
```

becomes:

```text
c = s + s;
```

The program reports:

```text
// Strength Reduction: x * 2 -> x + x
c = s + s
```



---

# 10. Why is `x * 2` Changed to `x + x`?

Consider:

```text
x * 2
```

The optimizer can represent the same mathematical result as:

```text
x + x
```

So:

```text
x * 2
```

↓

```text
x + x
```

This is the particular **strength reduction rule implemented in this experiment**. 

---

# 11. Complete Example

Suppose the input is:

```text
a = 2 + 4;
b = d * 1;
c = s * 2;
```

### Statement 1

```text
a = 2 + 4;
```

Both operands are constants.

```text
2 + 4 → 6
```

Output:

```text
// Constant Folding: 2 + 4 -> 6
a = 6
```

### Statement 2

```text
b = d * 1;
```

Apply:

```text
x * 1 → x
```

Output:

```text
// Algebraic Simplification: x * 1 -> x
b = d
```

### Statement 3

```text
c = s * 2;
```

Apply:

```text
x * 2 → x + x
```

Output:

```text
// Strength Reduction: x * 2 -> x + x
c = s + s
```

This matches the supplied experiment output. 

---

# 12. Step-by-Step Working

For:

```text
c = s * 2;
```

### Step 1 – Lexical Analysis

Lex recognizes:

```text
ID → =
ID → *
NUM → ;
```

### Step 2 – Parsing

Yacc recognizes:

```text
stmt → ID = expr ;
```

and:

```text
expr → expr * expr
```

### Step 3 – Check Optimization Rule

The right operand is:

```text
2
```

The optimizer checks:

```text
Is right operand 1?
No.

Is right operand 2?
Yes.
```

### Step 4 – Apply Strength Reduction

```text
s * 2
```

becomes:

```text
s + s
```

### Step 5 – Generate Result

```text
c = s + s
```

---

# 13. How the Optimizer Decides What to Do

The basic logic is:

```text
             Expression
                  │
                  ↓
       Are both operands numbers?
             /          \
           YES           NO
            │             │
            ↓             ↓
      Constant Folding   Check
                          algebraic
                          rules
                            │
                  ┌─────────┴─────────┐
                  ↓                   ↓
             x * 1 → x           x * 2 → x+x
                  │                   │
                  └─────────┬─────────┘
                            ↓
                     Optimized result
```

---

# 14. Important Terms

### Code Optimization

Improving code so that it performs more efficiently while preserving its intended result.

### Three Address Code

An intermediate representation where instructions generally contain at most three addresses/operands.

### Constant

A fixed numeric value such as:

```text
2
4
10
```

### Constant Folding

Evaluating constant expressions during compilation.

```text
2 + 4 → 6
```

### Algebraic Simplification

Using mathematical identities to remove unnecessary operations.

```text
x * 1 → x
```

### Strength Reduction

Replacing an operation with an equivalent simpler operation.

```text
x * 2 → x + x
```

### Lex/Flex

Converts input characters into tokens.

### Yacc/Bison

Parses those tokens according to grammar rules and performs the optimization actions.

---

# 15. Files Used

| File             | Purpose                                 |
| ---------------- | --------------------------------------- |
| `optimize.l`     | Lex/Flex source                         |
| `optimize.y`     | Yacc/Bison grammar + optimization logic |
| `optimize.tab.h` | Generated token definitions             |
| `optimize.tab.c` | Generated parser                        |
| `lex.yy(8).c`    | Generated Lex scanner                   |
| `optimize.exe`   | Executable                              |
| `output(8).txt`  | Sample output                           |

The generated header defines `ID` and `NUM`, while the parser handles the arithmetic operators and assignment symbols.

---

# 16. Compilation

### Step 1 – Generate the parser

```bash
bison -d optimize.y
```

Generates:

```text
optimize.tab.c
optimize.tab.h
```

### Step 2 – Generate the scanner

```bash
flex optimize.l
```

Generates:

```text
lex.yy.c
```

### Step 3 – Compile

```bash
gcc optimize.tab.c lex.yy.c -o optimize
```

### Step 4 – Run

Linux:

```bash
./optimize
```

Windows:

```bash
optimize.exe
```

The supplied executable is designed to prompt for TAC statements and terminate input with `Ctrl+D`. 

---

# 17. Sample Output

The supplied output is:

```text
Enter Three Address Code statements (Ctrl+D to stop):

// Constant Folding: 2 + 4 -> 6
a = 6

// Algebraic Simplification: x * 1 -> x
b = d

// Strength Reduction: x * 2 -> x + x
c = s + s
```



---

# 18. Overall Flow

```text
Input TAC
   │
   ↓
Lexical Analysis
   │
   ↓
Tokens
   │
   ↓
Syntax Analysis using Yacc
   │
   ↓
Identify Expression
   │
   ├───────────────┐
   ↓               ↓
Constants?      Variables?
   │               │
   ↓               ↓
Constant       Check algebraic/
Folding        strength rules
   │               │
   └───────┬───────┘
           ↓
    Optimized Expression
           │
           ↓
      Optimized TAC
```

---

# Result

The **Three Address Code optimizer using Lex and Yacc** was successfully implemented. The program accepts arithmetic TAC statements and applies **Constant Folding, Algebraic Simplification, and Strength Reduction** to produce optimized expressions. The supplied execution successfully demonstrates all three optimization techniques. 

## Conclusion

Thus, **Experiment 9 – Code Optimization using Lex and Yacc** was successfully completed. The experiment demonstrates how a compiler can optimize intermediate code by evaluating constants early, removing unnecessary algebraic operations, and replacing certain operations with simpler equivalent forms.

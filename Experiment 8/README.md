# Experiment 8 – Type Checking using Lex and Yacc

## Aim

To implement a **type checking system using Lex and Yacc** that identifies variable declarations, stores their data types in a symbol table, and checks whether the types used in expressions and assignments are compatible.

---

## Objective

* Use **Lex/Flex** for lexical analysis.
* Use **Yacc/Bison** for syntax analysis.
* Recognize `int` and `float` data types.
* Recognize identifiers and numbers.
* Maintain a **symbol table** containing variable names and their types.
* Check the types of variables involved in expressions.
* Detect type mismatches during assignments.

The Bison-generated header confirms that the program uses the tokens `ID`, `NUM`, `INT`, and `FLOAT`. 

---

# 1. What is Type Checking?

**Type checking** is the process of checking whether the data types used in a program are valid and compatible.

For example:

```c
int a;
int b;

a = b;
```

This is valid because both sides are `int`.

But:

```c
int a;
float b;

a = b;
```

in this experiment, the assignment can be identified as a type mismatch because `a` is `int` while `b` is `float`.

---

# 2. What Does This Experiment Build?

The program is essentially a small **type checker**.

It accepts declarations and expressions such as:

```text
int a;
int b;
int c;
a=b*c;
```

and checks the types involved.

For the supplied test, the output is:

```text
No type mismatch in expression: a = ...
```



---

# 3. Overall Working

```text
             Source Input
                  │
                  ↓
          ┌──────────────┐
          │     Lex      │
          │   Scanner    │
          └──────┬───────┘
                 │
                 ↓
               Tokens
                 │
                 ↓
          ┌──────────────┐
          │     Yacc     │
          │    Parser    │
          └──────┬───────┘
                 │
                 ↓
        Store declarations
                 │
                 ↓
          Symbol Table
                 │
                 ↓
        Check expression types
                 │
                 ↓
        Type Match / Mismatch
```

---

# 4. Lex/Flex

The `typecheck.l` file performs lexical analysis.

It recognizes the following important tokens:

| Input         | Token   |
| ------------- | ------- |
| `int`         | `INT`   |
| `float`       | `FLOAT` |
| variable name | `ID`    |
| number        | `NUM`   |
| `=`           | `=`     |
| `+`           | `+`     |
| `-`           | `-`     |
| `*`           | `*`     |
| `/`           | `/`     |
| `;`           | `;`     |

The generated scanner explicitly returns `INT` for `int` and `FLOAT` for `float`, while identifiers and numbers are returned as `ID` and `NUM`. 

### Example

For:

```text
int a;
```

Lex produces approximately:

```text
INT → ID → ;
```

For:

```text
a=b*c;
```

it produces:

```text
ID → = → ID → * → ID → ;
```

---

# 5. Yacc/Bison

The `typecheck.y` file contains the grammar and the type-checking logic.

The generated parser has these major grammar components:

```text
program
stmts
stmt
decl
assign
expr
```

It also handles:

```text
ID
NUM
INT
FLOAT
;
=
+
-
*
/
```



So the parser can distinguish between:

```text
int a;
```

and:

```text
a = b * c;
```

---

# 6. Symbol Table

One of the most important parts of this experiment is the **symbol table**.

The program defines:

```c
struct sym
{
    char name[20];
    char type[10];
} table[50];
```

So every symbol table entry contains:

```text
Variable Name
      +
   Data Type
```

For example:

| Name | Type    |
| ---- | ------- |
| `a`  | `int`   |
| `b`  | `int`   |
| `c`  | `float` |

The table can store up to 50 entries in the supplied implementation. 

---

# 7. `insert()` Function

The program uses:

```c
void insert(char *name,char *type)
```

to add a variable and its type to the symbol table.

Conceptually:

```text
insert("a", "int")
```

creates:

```text
a → int
```

Similarly:

```text
insert("b", "float")
```

creates:

```text
b → float
```

The implementation copies the name and type into the symbol table and increments the entry count. 

---

# 8. `typeOf()` Function

The program also defines:

```c
char *typeOf(char *name)
```

Its job is to search the symbol table and find the type of a variable.

For example, if the table contains:

```text
a → int
b → float
```

then:

```text
typeOf("a")
```

returns:

```text
int
```

and:

```text
typeOf("b")
```

returns:

```text
float
```

If the variable is not found, the function returns:

```text
undefined
```



---

# 9. Why Do We Need a Symbol Table?

Consider:

```text
int a;
float b;

a = b;
```

When the parser encounters:

```text
a = b;
```

it needs to know:

```text
What type is a?
What type is b?
```

The symbol table provides that information:

```text
a → int
b → float
```

The type checker can then compare:

```text
int  ≠  float
```

and report a mismatch.

Without the symbol table, the compiler would not know what type each identifier represents.

---

# 10. Expression Type Checking

Suppose we have:

```text
int a;
int b;
int c;

a = b * c;
```

The symbol table becomes:

```text
a → int
b → int
c → int
```

Now consider:

```text
b * c
```

Both operands are:

```text
int
```

Therefore the expression is compatible with:

```text
a → int
```

The supplied experiment uses exactly this type of input. 

---

# 11. Step-by-Step Example

### Input

```text
int a;
int b;
int c;
a=b*c;
```

### Step 1 – Read Declaration

```text
int a;
```

Store:

```text
a → int
```

### Step 2 – Read Declaration

```text
int b;
```

Store:

```text
b → int
```

### Step 3 – Read Declaration

```text
int c;
```

Store:

```text
c → int
```

The symbol table is now:

| Variable | Type  |
| -------- | ----- |
| `a`      | `int` |
| `b`      | `int` |
| `c`      | `int` |

### Step 4 – Read Assignment

```text
a=b*c;
```

The parser identifies:

```text
left side  → a
right side → b * c
```

### Step 5 – Find Types

```text
a → int
b → int
c → int
```

Therefore:

```text
b * c → int
```

and:

```text
a → int
```

### Step 6 – Compare

```text
int == int
```

So the expression is valid.

### Output

```text
No type mismatch in expression: a = ...
```



---

# 12. Example of a Type Mismatch

Consider:

```text
int a;
float b;

a=b;
```

Symbol table:

```text
a → int
b → float
```

Assignment:

```text
a = b
```

Comparison:

```text
int ≠ float
```

Therefore the program can identify a **type mismatch**.

The important idea is:

```text
Left-hand-side type
        ↓
      COMPARE
        ↑
Right-hand-side type
```

---

# 13. Lex + Yacc Interaction

The complete interaction is:

```text
Source Program
      │
      ↓
     Lex
      │
      │ returns tokens
      ↓
     Yacc
      │
      ├── Parses declarations
      │
      ├── Inserts variables into symbol table
      │
      ├── Parses assignments
      │
      ├── Looks up variable types
      │
      └── Checks compatibility
      │
      ↓
   Result
```

So:

**Lex tells Yacc what each word/symbol is.**

**Yacc determines what the complete statement means and performs the type checking.**

---

# 14. Important Terms

### Type

The kind of data stored by a variable.

Examples:

```text
int
float
```

### Identifier

A variable name:

```text
a
b
total
```

### Symbol Table

A data structure that stores information about identifiers.

In this experiment:

```text
name → type
```

### Type Checking

Checking whether operations and assignments use compatible types.

### Type Mismatch

When incompatible types are used together.

Example:

```text
int ← float
```

### Lex

Breaks the source program into tokens.

### Yacc/Bison

Uses the tokens to parse the program according to grammar rules and perform the associated semantic actions.

---

# 15. Files Used

| File              | Purpose                            |
| ----------------- | ---------------------------------- |
| `typecheck.l`     | Lex/Flex source                    |
| `typecheck.y`     | Yacc/Bison grammar + type checking |
| `typecheck.tab.h` | Generated token definitions        |
| `typecheck.tab.c` | Generated parser                   |
| `lex.yy(7).c`     | Generated Lex scanner              |
| `typecheck.exe`   | Executable                         |
| `output(7).txt`   | Sample output                      |

The generated header shows the token definitions `ID`, `NUM`, `INT`, and `FLOAT`. 

---

# 16. Compilation

### Step 1 – Generate Yacc parser

```bash
bison -d typecheck.y
```

This generates:

```text
typecheck.tab.c
typecheck.tab.h
```

### Step 2 – Generate Lex scanner

```bash
flex typecheck.l
```

This generates:

```text
lex.yy.c
```

### Step 3 – Compile

```bash
gcc typecheck.tab.c lex.yy.c -o typecheck
```

### Step 4 – Run

Linux:

```bash
./typecheck
```

Windows:

```bash
typecheck.exe
```

---

# 17. Complete Working Example

```text
Input
  │
  ├── int a;
  │       ↓
  │     a → int
  │
  ├── int b;
  │       ↓
  │     b → int
  │
  ├── int c;
  │       ↓
  │     c → int
  │
  └── a = b * c;
          │
          ↓
       b → int
       c → int
          │
          ↓
       b*c → int
          │
          ↓
       a → int
          │
          ↓
     int == int
          │
          ↓
       VALID
```

---

# Result

The **type checking system using Lex and Yacc** was successfully implemented. The program recognizes declarations and expressions, maintains a symbol table containing variable names and their types, and checks expressions and assignments for type compatibility.

## Conclusion

Thus, **Experiment 8 – Type Checking using Lex and Yacc** was successfully completed. The experiment demonstrates a basic **semantic analysis** phase of a compiler, where the parser uses information from a **symbol table** to determine whether expressions and assignments are type-compatible.


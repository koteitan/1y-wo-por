[← Back](README.md) | [English](02-well-founded.md) | [Japanese](../02-well-founded.md)

# Well-founded relations and well-founded recursion

Prerequisites

| Note | Terms used here |
|---|---|
| [01 Ordinals and ω₁](01-ordinals.md) | ordinal, infinite descending sequence, $`\lt`$ is well-founded |

This note explains three things: well-founded relations, well-founded recursion, and termination by decreasing labels. The definition of the relation $`R`$ ([07](07-relation-r.md)) has the form of §4 and §5. The outline of the whole proof ([06](06-combinatorial-layer.md)) has the form of §6.

## 1. Well-founded relations

**Definition (well-founded).** A relation $`\prec`$ on a set $`X`$ is **well-founded** if every nonempty subset $`S`$ of $`X`$ has a $`\prec`$-minimal element, that is, some $`x \in S`$ such that no $`y \in S`$ has $`y \prec x`$.

Being well-founded is equivalent to having no infinite descending sequence $`x_0 \succ x_1 \succ x_2 \succ \cdots`$ (the backward direction uses a weak form of the axiom of choice).

**Definition in Lean.** Lean uses `Acc` (accessibility).

- `Acc r x` holds if `Acc r y` holds for every $`y`$ with $`r\,y\,x`$. It is defined inductively.
- `WellFounded r` says that `Acc r x` holds for every $`x`$.

`Acc r x` means "every sequence that follows $`r`$ backwards from $`x`$ stops".

| Relation | Well-founded? | Lean |
|---|---|---|
| $`\lt`$ on $`\mathbb N`$ | yes | `wellFounded_lt` |
| $`\lt`$ on ordinals | yes | `Ordinal.lt_wf` |
| $`\lt`$ on $`\mathbb Z`$ | no | |
| lexicographic order on 1-Y expressions | no | `ZeroY.exprLt_not_wellFounded` |

The last row. In the lexicographic order of expressions a proper prefix is smaller, and otherwise the first differing entry decides. So there is an infinite descending sequence (`ZeroY.descendingValues`).

```math
(1,2) \gt (1,1,2) \gt (1,1,1,2) \gt (1,1,1,1,2) \gt \cdots
```

A 1-Y expansion lowers the lexicographic order (`OneY.Numeric.exprLt_of_step`). Still, the lexicographic order alone does not give termination. That is why labels are used (§6).

## 2. Well-founded induction

**Theorem (well-founded induction).** Let $`\prec`$ be well-founded and let a property $`P`$ satisfy

```math
\forall x\ \Bigl(\bigl(\forall y \prec x\ \ P(y)\bigr) \implies P(x)\Bigr)
```

Then $`P(x)`$ holds for every $`x`$.

**Proof.** Suppose the set of $`x`$ where $`P`$ fails is nonempty. Take a minimal element $`x`$. For $`y \prec x`$, $`P(y)`$ holds. By the assumption $`P(x)`$ holds, a contradiction. $`\square`$

In Lean it is `WellFounded.induction`. The theorem `top_abs` of [09 Discharging the obligations](09-obligations.md) uses it with the lexicographic order on $`\mathbb N \times \mathrm{Ord}`$.

## 3. Lexicographic products

**Definition (lexicographic product).** For $`(A, \lt_A)`$ and $`(B, \lt_B)`$, the **lexicographic order** on $`A \times B`$ is

```math
(a, b) \prec (a', b') \iff a \lt_A a' \ \lor\ (a = a' \land b \lt_B b')
```

**Theorem.** If $`\lt_A`$ and $`\lt_B`$ are well-founded, so is the lexicographic order.

**Proof.** Do well-founded induction on $`b`$ inside well-founded induction on $`a`$. A pair below $`(a, b)`$ either has $`a' \lt_A a`$ (accessible by the outer induction hypothesis) or has the same $`a`$ and $`b' \lt_B b`$ (accessible by the inner induction hypothesis). $`\square`$

**Example.** In $`\mathbb N \times \mathbb N`$, the pairs below $`(1, 0)`$ are $`(0, 0), (0, 1), (0, 2), \ldots`$, infinitely many. Still every descending sequence is finite. For example $`(1,0) \succ (0, 100) \succ (0, 99) \succ \cdots \succ (0, 0)`$ stops after 102 terms.

In Lean these are `Prod.Lex` and `WellFounded.prod_lex`. For triples, use it twice.

```math
(b', k', \eta') \lhd (b, k, \eta) \iff b' \lt b\ \lor\ \bigl(b' = b \land (k', \eta') \prec (k, \eta)\bigr)
```

Here $`(k', \eta') \prec (k, \eta)`$ is the lexicographic order on $`\mathbb N \times \mathrm{Ord}`$. This is the order of the recursion keys of the relation $`R`$. In Lean it is `Por.Idx := Ord × ℕ × Ord`, `Por.ilt`, `Por.ilt_wf` ([Por/Relation.lean](../../Por/Relation.lean)).

## 4. Well-founded recursion

**Theorem (well-founded recursion).** Let $`\prec`$ be a well-founded relation on $`T`$. Suppose a rule $`G`$ takes $`t \in T`$ and "the values at keys smaller than $`t`$" and returns the value at $`t`$. Then there is exactly one function $`F`$ with

```math
F(t) = G\bigl(t,\ F{\restriction}\{t' \mid t' \prec t\}\bigr)
```

**Example (Ackermann function).** Use the lexicographic order on $`\mathbb N \times \mathbb N`$ as the key order.

```math
\begin{aligned}
A(0, n) &= n + 1, \cr
A(m+1, 0) &= A(m, 1), \cr
A(m+1, n+1) &= A\bigl(m,\ A(m+1, n)\bigr).
\end{aligned}
```

The keys called on the right, $`(m, 1)`$, $`(m+1, n)`$ and $`(m, \cdot)`$, are all lexicographically smaller than the key on the left. So well-founded recursion defines $`A`$.

**The form in Lean.** `WellFounded.fix` takes the rule $`G`$ with this type.

```lean
G : (t : T) → ((t' : T) → r t' t → V) → V
```

The second argument (call it `IH`) takes a key `t'` together with a proof that `t'` is smaller. Without the proof it cannot be called. The defining equation is `WellFounded.fix_eq`.

## 5. Guarded recursion

In the definition of $`R`$, which keys are read depends on the values of variables inside a formula. Before writing the definition we cannot say that the keys read are smaller. So we proceed as follows.

1. Write each value to be read as $`\exists h : (\text{the key is smaller}),\ \mathrm{IH}(\text{key}, h)`$. We call the condition a **guard**. Where the key is not smaller, this expression is false.
2. Get the defining equation `fix_eq`. At this stage the right side carries the guards.
3. Show that the guard is always true wherever the right side actually reads a value. Then the equation without guards follows.

In [07 The relation R](07-relation-r.md), step 1 is `stepF`, step 2 is `RF_eq`, and step 3 is `elem_stage` and `R_iff`.

**A small example.** On $`\mathbb N`$ consider a definition of the form $`F(n) := 1 + \sum_{i \lt n,\ i \in S_n} F(i)`$, where $`S_n`$ is a given set for each $`n`$ that may contain numbers $`\ge n`$. Written with the guard, $`F(n) := 1 + \sum_{i \in S_n,\ i \lt n} F(i)`$, it is defined by well-founded recursion. If $`S_n \subseteq \{0, \ldots, n-1\}`$ is shown separately, the equation without the guard, $`F(n) = 1 + \sum_{i \in S_n} F(i)`$, holds.

## 6. Termination by labels

We show that a one-step relation $`\to`$ on a set $`X`$ of states is well-founded, using labels from a well-founded order $`(L, \lt)`$.

**Theorem (`wellFounded_of_lowerable_labels`).** Suppose a relation $`\mathrm{valid}(s, a)`$ between states and labels satisfies:

- every state $`s`$ has a label $`a`$ with $`\mathrm{valid}(s, a)`$;
- if $`\mathrm{valid}(s, a)`$ and $`s \to t`$, then $`\mathrm{valid}(t, b)`$ for some $`b \lt a`$.

Then $`\to`$ is well-founded. That is, there is no infinite sequence $`s_0 \to s_1 \to s_2 \to \cdots`$.

**Proof.** By well-founded induction on $`a`$, show "if $`\mathrm{valid}(s, a)`$ then $`s`$ is accessible" (`accessible_of_lowerable_labels`). If $`s \to t`$, then $`t`$ has a label $`b \lt a`$, so $`t`$ is accessible by the induction hypothesis. $`\square`$

The important point is that a state need not have a unique label. We only use "some label can be attached" and "after one step, a smaller label can be attached".

The 1-Y proof uses it as follows ([06](06-combinatorial-layer.md)).

| General form | 1-Y |
|---|---|
| state | expression $`s`$ (`ZeroY.Expr`) |
| $`s \to t`$ | nontrivial one-step expansion `ZeroY.ExpansionStep expand t s` |
| label | ordinal |
| $`\mathrm{valid}(s, a)`$ | the diagram of $`s`$ has a representation whose last label is $`a`$ (`LastRepresentation`) |

In Lean the actual proof is `expansion_accessible_of_lastRepresentation`, which writes the same induction directly.

## 7. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "The relation R" | well-founded recursion on the lexicographic order of keys $`(b, k, \eta)`$ |
| [notes/01-design.md](../../notes/01-design.md) §3.1, §3.4, §4.1 (Japanese) | order of triples, recursion, proof of `R_iff` |
| [Por/Relation.lean](../../Por/Relation.lean) | §3–§5 (`ilt_wf`, `stepF`, `RF`, `RF_eq`, `elem_stage`) |
| [Por/Chain.lean](../../Por/Chain.lean) | §2 (the induction in `top_abs`) |
| `OneY/RootIndexed/ExpansionWellFounded.lean` | §6 (induction on the last label) |

## 8. Lean correspondence

| Concept | Lean | File |
|---|---|---|
| accessibility | `Acc` | Lean core |
| well-founded | `WellFounded` | Lean core |
| well-founded induction | `WellFounded.induction` | same |
| lexicographic product | `Prod.Lex`, `WellFounded.prod_lex` | same |
| well-founded recursion and its equation | `WellFounded.fix`, `WellFounded.fix_eq` | same |
| keys and their order | `Idx`, `ilt`, `ilt_wf` | [Por/Relation.lean](../../Por/Relation.lean) |
| one guarded step | `stepF` | same |
| removing the guards | `elem_stage`, `R_iff` | same |
| lexicographic order of expressions is not well-founded | `ZeroY.exprLt_not_wellFounded` | [ZeroY/Syntax.lean](../../ZeroY/Syntax.lean) |
| termination by labels | `wellFounded_of_lowerable_labels`, `accessible_of_lowerable_labels` | [OneY/RootIndexed/Representation.lean](../../OneY/RootIndexed/Representation.lean) |
| the 1-Y induction | `expansion_accessible_of_lastRepresentation` | [OneY/RootIndexed/ExpansionWellFounded.lean](../../OneY/RootIndexed/ExpansionWellFounded.lean) |

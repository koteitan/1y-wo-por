[← Back](README.md) | [English](02-well-founded.md) | [Japanese](../02-well-founded.md)

# Well-founded relations and well-founded recursion

Prerequisites

| Note | Terms used here |
|---|---|
| [01 Ordinals and ω₁](01-ordinals.md) | ordinal, $`\mathrm{Ord}`$, infinite descending sequence, $`\lt`$ is well-founded |

This note explains three things: well-founded relations, well-founded recursion, and termination by a decreasing value in a well-founded order. The definition of the relation $`R`$ ([07](07-relation-r.md)) has the form of §4 and §5. The whole proof ([06](06-combinatorial-layer.md)) has the form of §6.

## 1. Well-founded relations

**Definition (well-founded).** A relation $`\prec`$ on a set $`X`$ is **well-founded** if every nonempty subset $`S`$ of $`X`$ has a $`\prec`$-minimal element, that is, some $`x \in S`$ such that no $`y \in S`$ has $`y \prec x`$.

Being well-founded is equivalent to having no infinite descending sequence $`x_0 \succ x_1 \succ x_2 \succ \cdots`$. The direction "no infinite descending sequence implies well-founded" uses a weak form of the axiom of choice (dependent choice).

**Definition (accessible).** $`x`$ is **accessible** if every $`y`$ with $`y \prec x`$ is accessible. This is an inductive definition: the set of accessible elements is the least set closed under this condition.

That $`x`$ is accessible means "every sequence that follows $`\prec`$ backwards from $`x`$ stops". $`\prec`$ is well-founded if and only if every $`x`$ is accessible.

| Relation | Well-founded? |
|---|---|
| $`\lt`$ on $`\mathbb N`$ | yes |
| $`\lt`$ on ordinals | yes |
| $`\lt`$ on $`\mathbb Z`$ | no |
| lexicographic order on 1-Y expressions | no |

The last row. A 1-Y expression is a finite sequence of positive integers, defined in [05](05-1y-mountain.md) §1. In the lexicographic order of expressions a proper prefix is smaller, and otherwise the first differing entry decides. So there is an infinite descending sequence.

```math
(1,2) \gt (1,1,2) \gt (1,1,1,2) \gt (1,1,1,1,2) \gt \cdots
```

A 1-Y expansion lowers the lexicographic order ([05](05-1y-mountain.md) §7). Still, the lexicographic order alone does not give termination. That is why the method of §6 is used.

## 2. Well-founded induction

**Theorem (well-founded induction).** Let $`\prec`$ be well-founded and let a property $`P`$ satisfy

```math
\forall x\ \Bigl(\bigl(\forall y \prec x\ \ P(y)\bigr) \implies P(x)\Bigr)
```

Then $`P(x)`$ holds for every $`x`$.

**Proof.** Suppose the set of $`x`$ where $`P`$ fails is nonempty. Take a minimal element $`x`$. For $`y \prec x`$, $`P(y)`$ holds. By the assumption $`P(x)`$ holds, a contradiction. $`\square`$

The theorem of [09 Discharging the obligations](09-obligations.md) §4.1 uses it with the lexicographic order on $`\mathbb N \times \mathrm{Ord}`$.

## 3. Lexicographic products

**Definition (lexicographic product).** For $`(A, \lt_A)`$ and $`(B, \lt_B)`$, the **lexicographic order** on $`A \times B`$ is

```math
(a, b) \prec (a', b') \iff a \lt_A a' \ \lor\ (a = a' \land b \lt_B b')
```

**Theorem.** If $`\lt_A`$ and $`\lt_B`$ are well-founded, so is the lexicographic order.

**Proof.** Do well-founded induction on $`b`$ inside well-founded induction on $`a`$. A pair below $`(a, b)`$ either has $`a' \lt_A a`$ (accessible by the outer induction hypothesis) or has the same $`a`$ and $`b' \lt_B b`$ (accessible by the inner induction hypothesis). $`\square`$

**Example.** In $`\mathbb N \times \mathbb N`$, the pairs below $`(1, 0)`$ are $`(0, 0), (0, 1), (0, 2), \ldots`$, infinitely many. Still every descending sequence is finite. For example $`(1,0) \succ (0, 100) \succ (0, 99) \succ \cdots \succ (0, 0)`$ stops after 102 terms.

For triples, use this theorem twice.

```math
(b', k', \eta') \lhd (b, k, \eta) \iff b' \lt b\ \lor\ \bigl(b' = b \land (k', \eta') \prec (k, \eta)\bigr)
```

Here $`(k', \eta') \prec (k, \eta)`$ is the lexicographic order on $`\mathbb N \times \mathrm{Ord}`$. This is the order of the keys (defined in §4) $`(b, k, \eta) \in \mathrm{Ord} \times \mathbb N \times \mathrm{Ord}`$ used in the well-founded recursion that defines the relation $`R`$ (defined in [07](07-relation-r.md)). By the theorem above, $`\lhd`$ is well-founded.

## 4. Well-founded recursion

**Theorem (well-founded recursion).** Let $`\prec`$ be a well-founded relation on $`T`$. In well-founded recursion the elements of $`T`$ are called **keys**. Suppose a rule $`G`$ takes $`t \in T`$ and "the values at keys smaller than $`t`$" and returns the value at $`t`$. Then there is exactly one function $`F`$ with

```math
F(t) = G\bigl(t,\ F{\restriction}\{t' \mid t' \prec t\}\bigr)
```

Here $`F{\restriction}X`$ is the function $`F`$ with its domain restricted to the set $`X`$.

**Example (Ackermann function).** Use the lexicographic order on $`\mathbb N \times \mathbb N`$ as the key order.

```math
\begin{aligned}
A(0, n) &= n + 1, \cr
A(m+1, 0) &= A(m, 1), \cr
A(m+1, n+1) &= A\bigl(m,\ A(m+1, n)\bigr).
\end{aligned}
```

The keys called on the right, $`(m, 1)`$, $`(m+1, n)`$ and $`(m, \cdot)`$, are all lexicographically smaller than the key on the left. So well-founded recursion defines $`A`$.

The rule $`G`$ may read only the values $`F(t')`$ at keys $`t'`$ with $`t' \prec t`$.

## 5. Guarded recursion

In the definition of $`R`$ ([07](07-relation-r.md)), which keys are read depends on the values of variables inside a formula (defined in [03](03-sigma1-elementary.md) §2). Before writing the definition we cannot say that the keys read are smaller. So we proceed as follows.

1. Wherever the value at a key $`t'`$ is read, write "$`t' \prec t \land F(t')`$". We call the first condition $`t' \prec t`$ a **guard**. Where the key is not smaller, this expression is false.
2. By the theorem of §4, get the defining equation $`F(t) = G(t, F{\restriction}\{t' \mid t' \prec t\})`$. At this stage the right side still contains the guards.
3. Show that the guard is always true wherever the right side actually reads a value. Then the equation without guards follows.

In [07 The relation R](07-relation-r.md), step 1 is the stage interpretations of §5, step 2 is the guarded equation of §5, and step 3 is the lemma and the theorem of §6.

**A small example.** On $`\mathbb N`$ consider a definition of the form $`F(n) := 1 + \sum_{i \in S_n} F(i)`$, where $`S_n`$ is a given finite set for each $`n`$ that may contain numbers $`\ge n`$. So as it stands, this is not a well-founded recursion. Written with the guard, $`F(n) := 1 + \sum_{i \in S_n,\ i \lt n} F(i)`$, it is defined by well-founded recursion. If $`S_n \subseteq \{0, \ldots, n-1\}`$ is shown separately, the equation without the guard, $`F(n) = 1 + \sum_{i \in S_n} F(i)`$, holds.

## 6. Termination by labels

Consider a binary relation $`\to`$ on a set $`X`$ (write $`s \to t`$ when $`s, t \in X`$ are in this relation). In 1-Y, $`s \to t`$ becomes the relation "$`t`$ is an expansion of $`s`$" ([06](06-combinatorial-layer.md) §6). We show that $`\to`$ is well-founded, using a well-founded order $`(L, \lt)`$. The elements of $`L`$ are called **labels**.

**Theorem (termination by labels).** Suppose a relation $`\mathrm{valid}(s, a)`$ between elements of $`X`$ and labels ($`s \in X`$, $`a \in L`$) satisfies:

- every $`s \in X`$ has a label $`a`$ with $`\mathrm{valid}(s, a)`$;
- if $`\mathrm{valid}(s, a)`$ and $`s \to t`$, then $`\mathrm{valid}(t, b)`$ for some $`b \lt a`$.

Then $`\to`$ is well-founded. That is, there is no infinite sequence $`s_0 \to s_1 \to s_2 \to \cdots`$.

**Proof.** By well-founded induction on $`a`$, show "if $`\mathrm{valid}(s, a)`$ then $`s`$ is accessible". If $`s \to t`$, then $`t`$ has a label $`b \lt a`$, so $`t`$ is accessible by the induction hypothesis. $`\square`$

The important point is that an element of $`X`$ need not have a unique label. We only use "every $`s`$ can be given some label" and "if $`s \to t`$, then $`t`$ can be given a smaller label".

How the 1-Y proof uses it is described in [06](06-combinatorial-layer.md) §6.

## 7. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "The relation R" | well-founded recursion on the lexicographic order of keys $`(b, k, \eta)`$ |
| [notes/01-design.md](../../notes/01-design.md) §3.1, §3.4, §4.1 (Japanese) | order of triples (§3), guarded recursion (§4, §5), proof of the defining equation of $`R`$ |

[← Back](README.md) | [English](03-sigma1-elementary.md) | [Japanese](../03-sigma1-elementary.md)

# Structures and Σ₁-elementary substructures

Prerequisites

| Note | Terms used here |
|---|---|
| [01 Ordinals and ω₁](01-ordinals.md) | ordinal, limit ordinal, $`\{x \mid x \lt \gamma\}`$ |

This note explains the model-theoretic terms used in the definition of the relation $`R`$: first-order structures, $`\Sigma_1`$ formulas, $`\Sigma_1`$-elementary substructures and the Tarski–Vaught test. The second half (§7, §8) explains how Lean represents them.

## 1. Languages and structures

**Definition (language).** A **language** is a collection of relation symbols, each with a fixed number of arguments (its arity). This repository uses no function symbols and no constant symbols.

**Definition (structure).** A **structure** $`\mathfrak A`$ for a language $`L`$ consists of a set $`A`$ (the domain, possibly empty) and an interpretation $`P^{\mathfrak A} \subseteq A^n`$ of each symbol $`P`$ of arity $`n`$.

| Language | Structure | Domain |
|---|---|---|
| $`\{\lt\}`$ | $`(\omega; \lt)`$ | natural numbers |
| $`\{\lt\}`$ | $`(\gamma; \lt)`$ | $`\{x \mid x \lt \gamma\}`$ |
| $`\{\lt, E\}`$ ($`E`$ binary) | $`(\omega; \lt, E)`$, $`E(x, y) :\iff y = x + 1`$ | natural numbers |

Every structure in this repository has a domain of the form $`\{x \mid x \lt \gamma\}`$. We call $`\gamma`$ the **height** of the structure.

## 2. Formulas and Σ₁ formulas

**Definition (formula).** Formulas are built as follows.

- **Atomic formulas**: $`P(x_1, \ldots, x_n)`$ ($`P`$ a symbol of arity $`n`$, $`x_i`$ variables).
- Formulas combined with $`\neg, \land, \lor, \to`$.
- Formulas with $`\exists x`$ or $`\forall x`$ in front.

**Definition (quantifier-free formula).** A formula that contains no quantifier $`\exists`$ or $`\forall`$.

**Definition (Σ₁ formula).** A formula of the form

```math
\exists y_1 \cdots \exists y_b\ \psi(\vec p, y_1, \ldots, y_b)
```

with $`\psi`$ quantifier-free, that is, only existential quantifiers in front, is a **$`\Sigma_1`$ formula**. $`\vec p`$ are free variables; later elements of the domain (**parameters**) are put in their place.

| Formula | Kind |
|---|---|
| $`p \lt q`$ | quantifier-free (also $`\Sigma_1`$, with $`b = 0`$) |
| $`\exists y\ (p \lt y)`$ | $`\Sigma_1`$ |
| $`\exists y\ \exists z\ (p \lt y \land y \lt z \land E(y, z))`$ | $`\Sigma_1`$ |
| $`\forall y\ (y \lt p \lor p \lt y \lor y = p)`$ | not $`\Sigma_1`$ |

**Definition (satisfaction).** For a structure $`\mathfrak A`$ and parameters $`\vec p \in A`$, $`\mathfrak A \models \varphi(\vec p)`$ means "$`\varphi`$ is true in $`\mathfrak A`$ at $`\vec p`$". A quantifier $`\exists y`$ ranges over the domain $`A`$.

Example: $`(\omega; \lt) \models \exists y\ (3 \lt y)`$ is true. $`(4; \lt) \models \exists y\ (3 \lt y)`$ is false, because the domain of $`(4; \lt)`$ is $`\{0, 1, 2, 3\}`$.

## 3. Atomic diagrams

**Definition (atomic diagram).** The **atomic diagram** of a tuple $`v_0, \ldots, v_{n-1}`$ is the table of truth values of all atomic formulas applied to them.

The truth value of a quantifier-free formula depends only on the atomic diagram. So a quantifier-free $`\psi`$ can be rewritten as "the atomic diagram lies in a set $`D`$".

```math
\psi(v_0, \ldots, v_{n-1}) \iff \mathrm{diag}(v_0, \ldots, v_{n-1}) \in D
```

**Example.** Take the language $`\{\lt\}`$ and $`n = 2`$. The atomic diagram is the 4 bits $`[v_0 \lt v_0], [v_0 \lt v_1], [v_1 \lt v_0], [v_1 \lt v_1]`$.

| Tuple | Atomic diagram |
|---|---|
| $`(2, 5)`$ | $`(0, 1, 0, 0)`$ |
| $`(5, 2)`$ | $`(0, 0, 1, 0)`$ |
| $`(3, 3)`$ | $`(0, 0, 0, 0)`$ |

$`\psi := (v_0 \lt v_1)`$ is $`D = \{d \mid \text{the second bit of } d \text{ is } 1\}`$.

- With finitely many symbols there are only finitely many atomic diagrams of $`n`$ points, so $`D`$ is a finite set.
- If $`\lt`$ is a linear order, equality is determined by the $`\lt`$ bits: $`v_a = v_b \iff \neg(v_a \lt v_b) \land \neg(v_b \lt v_a)`$. No equality symbol is needed.

## 4. Substructures and upward preservation

**Definition (substructure).** $`\mathfrak A`$ is a **substructure** of $`\mathfrak B`$ if $`A \subseteq B`$ and each symbol is interpreted by the restriction, that is, $`P^{\mathfrak A}(\vec a) \iff P^{\mathfrak B}(\vec a)`$ for $`\vec a \in A`$.

**Property 1.** In a substructure, quantifier-free formulas about elements of $`A`$ have the same truth value, because the atomic diagrams are the same.

**Property 2 (Σ₁ goes up).** In a substructure, if $`\mathfrak A \models \exists \vec y\ \psi(\vec p, \vec y)`$ then $`\mathfrak B \models \exists \vec y\ \psi(\vec p, \vec y)`$. The witnesses $`\vec y`$ in $`\mathfrak A`$ are also in $`B`$, and by Property 1 $`\psi`$ has the same truth value.

**The converse fails.** $`(4; \lt)`$ is a substructure of $`(\omega; \lt)`$. $`\exists y\ (3 \lt y)`$ is true in $`\omega`$ and false in $`4`$.

## 5. Σ₁-elementary substructures

**Definition (Σ₁-elementary substructure).** $`\mathfrak A`$ is a **$`\Sigma_1`$-elementary substructure** of $`\mathfrak B`$ if $`\mathfrak A`$ is a substructure of $`\mathfrak B`$ and, for every $`\Sigma_1`$ formula $`\varphi`$ and all parameters $`\vec p \in A`$,

```math
\mathfrak A \models \varphi(\vec p) \iff \mathfrak B \models \varphi(\vec p)
```

We write $`\mathfrak A \preccurlyeq_{\Sigma_1} \mathfrak B`$.

**Meaning.** A statement "there are finitely many elements like this" that mentions only elements of $`A`$ is true in $`\mathfrak A`$ whenever it is true in $`\mathfrak B`$. The witnesses can be chosen again inside $`A`$.

**Example (order only).** Let $`0 \lt \alpha \lt \beta`$ be ordinals.

```math
(\alpha; \lt) \preccurlyeq_{\Sigma_1} (\beta; \lt) \iff \alpha \text{ is a limit ordinal}
```

**Proof.**

- If $`\alpha = \gamma + 1`$: $`\exists y\ (\gamma \lt y)`$ with parameter $`\gamma`$ is true in $`\beta`$ ($`y = \gamma + 1`$) and false in $`\alpha`$. So it fails.
- If $`\alpha`$ is a limit: suppose a $`\Sigma_1`$ formula $`\exists \vec y\ \psi(\vec p, \vec y)`$ is true in $`\beta`$. Move its witnesses $`\vec y`$ into $`\alpha`$, keeping their positions relative to the parameters.
  - Witnesses below the largest parameter are already in $`\alpha`$. Keep them.
  - There are finitely many witnesses above the largest parameter (when there are no parameters, count all witnesses here). Since $`\alpha`$ is a limit, there are infinitely many elements of $`\alpha`$ above the largest parameter ([01](01-ordinals.md) §2). Put the witnesses there in the same order.
  - Moving them does not change the $`\lt`$ bits, that is, the atomic diagram. So $`\psi`$ is true in $`\alpha`$.
  - The other direction is Property 2 of §4. $`\square`$

$`\alpha = 0`$ is also excluded: $`\exists y\ \neg(y \lt y)`$ is false in the empty structure $`0`$ and true in $`\beta`$.

## 6. The Tarski–Vaught test (Σ₁ version)

To prove $`\Sigma_1`$-elementarity it suffices to check the downward direction.

**Theorem (Tarski–Vaught test, Σ₁ version).** Let $`\mathfrak A`$ be a substructure of $`\mathfrak B`$. The following are equivalent.

1. $`\mathfrak A \preccurlyeq_{\Sigma_1} \mathfrak B`$.
2. For quantifier-free $`\psi`$ and $`\vec p \in A`$: if $`\mathfrak B \models \exists \vec y\ \psi(\vec p, \vec y)`$, then $`\mathfrak B \models \psi(\vec p, \vec y)`$ for some $`\vec y \in A`$.

**Proof.** 1 to 2: the formula is true in $`\mathfrak A`$, so there are witnesses in $`A`$; by Property 1 of §4, $`\psi`$ is true in $`\mathfrak B`$ too. 2 to 1: the upward direction is Property 2 of §4. For the downward direction, the witnesses from 2 lie in $`A`$, and by Property 1 we get $`\mathfrak A \models \psi(\vec p, \vec y)`$. $`\square`$

The general Tarski–Vaught test says the same for all formulas. This repository uses only $`\Sigma_1`$.

**How it is used.** Condition 2 says "$`A`$ is closed under witnesses". The theorem `lam_good` of [08 Closure and chain](08-closure-chain.md) is proved in this form: start from $`\gamma`$, keep adding witnesses of true statements, and take the supremum.

## 7. Σ₁ formulas in Lean

This repository does not define formulas as syntax. As in [notes/01-design.md](../../notes/01-design.md) §3.2 (Japanese), a formula is a 5-tuple.

| Component | Meaning |
|---|---|
| $`m`$ | bound on symbols: $`\mathrm{Rel}_j`$ and $`\mathrm{Top}_j`$ only with $`j \lt m`$ |
| $`n`$ | number of variables the atomic diagram reads |
| $`D`$ | a set of atomic diagrams (the matrix) |
| $`\mathit{bb}`$ | number of existentially quantified variables |
| $`r`$ | number of parameters |

- `Diag m n` is the type of complete atomic diagrams of $`n`$ points: the bits of $`\lt`$, of the ternary $`\mathrm{Rel}_j`$ and of the binary $`\mathrm{Top}_j`$. It is a finite type.
- `diagM rel top allow m n v` is the atomic diagram of the sequence of points $`v`$. `rel` and `top` are the interpretations of the symbols. When `allow j a` is false, the bit of $`\mathrm{Top}_j(v_a, \cdot)`$ is not read and is set to false (§8).
- The sequence of variables is the parameters $`p_0, \ldots, p_{r-1}`$ followed by the witnesses $`y_0, \ldots, y_{\mathit{bb}-1}`$. In Lean it is `cat r p y` ([Por/Tuple.lean](../../Por/Tuple.lean)).
- `Sat rel top allow M m n D bb r p` says "this $`\Sigma_1`$ formula is true at $`\vec p`$ in the structure of height $`M`$".

```math
\mathrm{Sat}(M, D, \mathit{bb}, r, \vec p) \iff \exists \vec y\ \Bigl(\forall i \lt \mathit{bb}\ \ y_i \lt M\Bigr) \land \mathrm{diag}(p_0, \ldots, p_{r-1}, y_0, \ldots, y_{\mathit{bb}-1}) \in D
```

The condition $`y_i \lt M`$ on the witnesses expresses "the domain is $`\{x \mid x \lt M\}`$".

**Example.** $`\exists y\ (p_0 \lt y)`$ has $`m = 0`$, $`n = 2`$, $`\mathit{bb} = 1`$, $`r = 1`$, and $`D`$ is the set of atomic diagrams whose $`\lt`$ bit from point 0 to point 1 is true. It is true at height $`M`$ exactly when $`p_0 + 1 \lt M`$.

## 8. Comparing two structures, and visible bits

The comparison used in this repository differs from the textbook definition in two ways.

**Difference 1: one symbol, two interpretations.** The definition of $`R`$ compares the structure of height $`a`$ with the structure of height $`b`$. The top predicate $`\mathrm{Top}_j`$ is interpreted as "the relation to $`a`$" at height $`a`$ and as "the relation to $`b`$" at height $`b`$. So as it stands, one is not a substructure of the other.

Therefore `ElemL` does not assume a substructure. It only requires that every $`\Sigma_1`$ formula with $`\vec p \lt a`$ has the same truth value on both sides. Taking $`\mathit{bb} = 0`$ (no quantifier), the atomic diagrams of points below $`a`$ agree. So when the agreement holds, the smaller structure is in fact a substructure, and a $`\Sigma_1`$-elementary one.

**Difference 2: visible bits.** Each formula comes with a rule saying which top-predicate bits it may read. Bits it may not read are read as false. The argument `allow` of `diagM` decides this.

| `allow` | Visible bits | Used for |
|---|---|---|
| `full` | all | the structure of height $`\omega_1`$ (`Good`) |
| `allowL k S` | $`\mathrm{Top}_j`$ with $`j \lt k`$, and $`\mathrm{Top}_k`$ with first argument at a position in $`S`$ | the structures of level $`(k, \eta)`$ |

In `allowL k S`, visibility depends only on the positions of the variables, not on the values of the points. So the following two lemmas hold.

- `diagM_congr`, `sat_congr`: if two interpretations agree on the visible bits, the atomic diagrams and the truth values agree.
- `maskD`, `sat_mask`: setting the invisible bits to false is a function `maskD allow` on complete atomic diagrams. So "a formula $`D`$ that reads only visible bits" has the same truth value as "the formula $`\mathrm{maskD}^{-1}(D)`$ that reads everything".

The second lemma translates a level-restricted formula into a formula of the language with all symbols. [08](08-closure-chain.md) and [09](09-obligations.md) use it to compare with the structure of height $`\omega_1`$.

## 9. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "The relation R" | $`\preccurlyeq_{\Sigma_1}`$ and the structures $`\mathfrak A^{\gamma}_{k,\eta}`$ |
| [notes/01-design.md](../../notes/01-design.md) §3.2–§3.4 (Japanese) | language, 5-tuples for $`\Sigma_1`$ formulas, `allowL` |
| [notes/01-design.md](../../notes/01-design.md) §4.7 (Japanese) | `lam_good` in Tarski–Vaught form |
| [Por/Formula.lean](../../Por/Formula.lean) | all of §7 and §8 |
| [Por/Closure.lean](../../Por/Closure.lean) | §6 (`lam_good`) |

## 10. Lean correspondence

| Concept | Lean | File |
|---|---|---|
| complete atomic diagram | `Diag m n` | [Por/Formula.lean](../../Por/Formula.lean) |
| types of interpretations | `RelF`, `TopF` | same |
| atomic diagram of a sequence of points | `diagM` | same |
| a $`\Sigma_1`$ formula is true | `Sat` | same |
| visible bits | `full`, `allowL` | same |
| $`\Sigma_1`$-elementarity at a level | `ElemL` | same |
| same bits read, same result | `diagM_congr`, `sat_congr` | same |
| setting invisible bits to false | `maskD`, `diagM_mask`, `sat_mask` | same |
| joining sequences of variables | `cat`, `cat_left`, `cat_lt`, `cat_bound` | [Por/Tuple.lean](../../Por/Tuple.lean) |

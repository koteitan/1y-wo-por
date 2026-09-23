[← Back](README.md) | [English](08-closure-chain.md) | [Japanese](../08-closure-chain.md)

# Closure below ω₁ and the chain

Prerequisites

| Note | Terms used here |
|---|---|
| [01 Ordinals and ω₁](01-ordinals.md) | $`\omega_1`$, regularity, `enumBelow`, `params` |
| [03 Structures and Σ₁-elementary substructures](03-sigma1-elementary.md) | Tarski–Vaught test, `Sat`, `full` |
| [07 The relation R](07-relation-r.md) | $`R`$, `relR`, `topR` |

This note explains how to build points below $`\omega_1`$ that are closed under $`\Sigma_1`$ witnesses. The idea is the one of the Löwenheim–Skolem theorem: add witnesses and take the supremum. The chain of these points gives the first labels in [09](09-obligations.md). The Lean files are [Por/Closure.lean](../../Por/Closure.lean) and [Por/Chain.lean](../../Por/Chain.lean).

## 1. The ambient structure and Good

**Definition (ambient structure).** Let $`\mathfrak B`$ be the structure of height $`\omega_1`$ with all symbols.

```math
\mathfrak B = \bigl(\omega_1;\ \lt,\ (\mathrm{Rel}_j)_{j \in \mathbb N},\ (\mathrm{Top}^{\omega_1}_j)_{j \in \mathbb N}\bigr), \qquad \mathrm{Top}^{\omega_1}_j(\xi, x) :\iff R(j, \xi, x, \omega_1)
```

It has the top predicates of every layer, all diagonal. Its visible bits are `full` (all).

**Definition (Good).** Let $`\mathfrak B{\restriction}\gamma`$ be $`\mathfrak B`$ with its domain restricted to $`\{x \mid x \lt \gamma\}`$. The top predicates remain those toward $`\omega_1`$.

```math
\mathrm{Good}(\gamma) :\iff \mathfrak B{\restriction}\gamma \preccurlyeq_{\Sigma_1} \mathfrak B
```

In Lean, `Good γ` says that for every $`\Sigma_1`$ formula with $`\vec p \lt \gamma`$,

```lean
Sat relR (topR Om) full γ m n D bb r p ↔ Sat relR (topR Om) full Om m n D bb r p
```

$`\mathfrak B{\restriction}\gamma`$ is a genuine substructure of $`\mathfrak B`$ (same interpretations, smaller domain). So the Tarski–Vaught test of [03](03-sigma1-elementary.md) §6 applies directly.

## 2. There are countably many formulas

**Definition (`Form`).** The type of formulas is the type of 5-tuples $`(m, n, D, \mathit{bb}, r)`$.

```lean
abbrev Form : Type := Σ m n : ℕ, Set (Diag m n) × ℕ × ℕ
```

**Why it is countable.** Once $`m, n`$ are fixed, `Diag m n` is a finite type ([03](03-sigma1-elementary.md) §3), so there are finitely many subsets $`D`$. $`m, n, \mathit{bb}, r`$ are natural numbers. So `Form` is countable. `List ℕ` is countable too, so `Form × List ℕ` is countable.

This is why a formula uses finitely many symbols (bound $`m`$). If formulas could use infinitely many symbols, the set of all formulas would not be countable ([notes/01-design.md](../../notes/01-design.md) §3.8, Japanese).

## 3. Height of witnesses

**Definition (`witHeight`).** For a formula $`\varphi = (m, n, D, \mathit{bb}, r)`$ and parameters $`\vec p`$:

- if $`\mathfrak B \models \varphi(\vec p)`$, choose one tuple of witnesses $`y_0, \ldots, y_{\mathit{bb}-1} \lt \omega_1`$ (`Classical.choose`) and let $`h(\varphi, \vec p) := \sup_{i \lt \mathit{bb}} (y_i + 1)`$;
- otherwise let $`h(\varphi, \vec p) := 0`$.

**Theorem (`witHeight_lt`).** $`h(\varphi, \vec p) \lt \omega_1`$.

**Proof.** It is the maximum of finitely many $`y_i + 1`$, each below $`\omega_1`$ (`om_succ_lt`). $`\square`$

All chosen witnesses lie below $`h(\varphi, \vec p)`$.

## 4. One closure step

**Definition (`next`).**

```math
\mathrm{next}(\gamma) := \max\Bigl(\gamma,\ \sup_{(\varphi, l)} h\bigl(\varphi, \mathrm{params}_\gamma(l)\bigr)\Bigr) + 1
```

The supremum runs over all $`\varphi \in`$ `Form` and $`l \in`$ `List ℕ`. $`\mathrm{params}_\gamma(l)`$ is the parameter tuple coded by a list of natural numbers, as in [01](01-ordinals.md) §6.

| Theorem | Statement | Reason |
|---|---|---|
| `lt_next` | $`\gamma \lt \mathrm{next}(\gamma)`$ | the $`+1`$ |
| `next_lt` | $`\gamma \lt \omega_1 \implies \mathrm{next}(\gamma) \lt \omega_1`$ | supremum of countably many ([01](01-ordinals.md) §5) |
| `wit_below` | if $`\gamma \lt \omega_1`$, $`\vec p \lt \gamma`$ and $`\mathfrak B \models \varphi(\vec p)`$, then witnesses can be taken below $`\mathrm{next}(\gamma)`$ | proof below |

**Proof of `wit_below`.** By `exists_params` there is a list $`l`$ with $`\vec p = \mathrm{params}_\gamma(l)`$. The witnesses chosen for $`(\varphi, l)`$ lie below $`h(\varphi, \mathrm{params}_\gamma(l))`$. This is one of the terms of the supremum, so they lie below $`\mathrm{next}(\gamma)`$. $`\square`$

## 5. The tower and λ

**Definition (`tower`, `lam`).**

```math
\mathrm{next}^0(\gamma) := \gamma, \quad \mathrm{next}^{t+1}(\gamma) := \mathrm{next}\bigl(\mathrm{next}^t(\gamma)\bigr), \qquad \lambda(\gamma) := \sup_{t \in \mathbb N} \mathrm{next}^t(\gamma)
```

| Theorem | Statement |
|---|---|
| `tower_lt` | $`\gamma \lt \omega_1 \implies \mathrm{next}^t(\gamma) \lt \omega_1`$ |
| `tower_mono` | $`t \le t' \implies \mathrm{next}^t(\gamma) \le \mathrm{next}^{t'}(\gamma)`$ |
| `lam_lt` | $`\gamma \lt \omega_1 \implies \lambda(\gamma) \lt \omega_1`$ (supremum of countably many) |
| `lt_lam` | $`\gamma \lt \lambda(\gamma)`$ |
| `exists_tower` | if $`p_0, \ldots, p_{k-1} \lt \lambda(\gamma)`$, then all are $`\lt \mathrm{next}^t(\gamma)`$ for some $`t`$ |

`exists_tower` is proved by induction on $`k`$. Each $`p_i`$ is below the supremum, so $`p_i \lt \mathrm{next}^{t_i}(\gamma)`$ for some $`t_i`$. Take $`t := \max_i t_i`$.

## 6. λ(γ) is Good

**Theorem (`lam_good`).** If $`\gamma \lt \omega_1`$, then $`\mathrm{Good}(\lambda(\gamma))`$.

**Proof.** In the form of the Tarski–Vaught test ([03](03-sigma1-elementary.md) §6). Let $`\vec p \lt \lambda(\gamma)`$.

- $`\Rightarrow`$: witnesses below $`\lambda(\gamma)`$ are also witnesses below $`\omega_1`$ (`lam_lt`). The matrix is evaluated in the same way.
- $`\Leftarrow`$: by `exists_tower`, $`\vec p \lt \mathrm{next}^t(\gamma)`$ for some $`t`$. Applying `wit_below` at $`\mathrm{next}^t(\gamma)`$, the witnesses can be taken below $`\mathrm{next}^{t+1}(\gamma) \le \lambda(\gamma)`$. $`\square`$

**Example (only the shape).** Let $`\gamma = 0`$. $`\lambda(0)`$ contains witnesses of every true $`\Sigma_1`$ statement of $`\mathfrak B`$ whose parameters lie below $`\lambda(0)`$. The actual value of $`\lambda(0)`$ is not known. The proof never uses the value, only $`\lambda(0) \lt \omega_1`$ and $`\mathrm{Good}(\lambda(0))`$.

**About the set of Good points.** We neither show nor use that the set of Good points is closed in $`\omega_1`$. That is why it is not called a club (closed unbounded set).

## 7. The chain

**Definition (`cC`).**

```math
c_0 := \lambda(0), \qquad c_{t+1} := \lambda(c_t)
```

| Theorem | Statement |
|---|---|
| `cC_lt` | $`c_t \lt \omega_1`$ |
| `cC_strictMono` | $`c_0 \lt c_1 \lt c_2 \lt \cdots`$ |
| `cC_good` | $`\mathrm{Good}(c_t)`$ |

All follow from §5 and §6 by induction on $`t`$.

Any two points of this chain are related by $`R`$ at every layer and every root index up to the smaller point (`chain_R`). The proof needs that at a Good point the top predicates agree with the top predicates of $`\omega_1`$ (`top_abs`). Both are explained in [09](09-obligations.md) §4.

## 8. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "Where the six hypotheses go" | "the initial labelling is built from a chain of closure points below $`\omega_1`$" |
| [notes/01-design.md](../../notes/01-design.md) §3.6, §4.7 (Japanese) | ambient structure, Good, next, λ, chain, proof of `lam_good` |
| [Por/Closure.lean](../../Por/Closure.lean) | §1–§6 |
| [Por/Chain.lean](../../Por/Chain.lean) | §7 |

## 9. Lean correspondence

| Concept | Lean | File |
|---|---|---|
| Good | `Good` | [Por/Closure.lean](../../Por/Closure.lean) |
| type of formulas | `Form` | same |
| height of witnesses | `witHeight`, `witHeight_lt` | same |
| one closure step | `next`, `lt_next`, `next_lt`, `wit_below` | same |
| tower and λ | `tower`, `lam`, `tower_lt`, `tower_mono`, `tower_le_lam`, `lam_lt`, `lt_lam`, `exists_tower` | same |
| λ is Good | `lam_good` | same |
| chain | `cC`, `cC_lt`, `cC_strictMono`, `cC_good` | [Por/Chain.lean](../../Por/Chain.lean) |

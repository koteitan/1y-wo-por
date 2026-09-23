[← Back](README.md) | [English](07-relation-r.md) | [Japanese](../07-relation-r.md)

# The relation R

Prerequisites

| Note | Terms used here |
|---|---|
| [02 Well-founded relations and recursion](02-well-founded.md) | lexicographic order, well-founded recursion, guarded recursion |
| [03 Structures and Σ₁-elementary substructures](03-sigma1-elementary.md) | 5-tuples for $`\Sigma_1`$ formulas, `Sat`, visible bits, `ElemL` |
| [04 Patterns of resemblance](04-patterns-of-resemblance.md) | the idea of making top predicates atomic symbols |
| [06 Phyrion's combinatorial layer](06-combinatorial-layer.md) | the role of $`R(k, \eta, a, b)`$, `hStrict`, `hWeak` |

This note explains the definition of the label relation $`R`$ of this repository and the properties that follow directly from it. The Lean file is [Por/Relation.lean](../../Por/Relation.lean).

## 1. Notation

- $`\mathrm{Ord}`$: all ordinals (in Lean `Ord` $`=`$ `Ordinal.{0}`).
- Lexicographic order on $`\mathbb N \times \mathrm{Ord}`$: $`(j, \xi) \prec (k, \eta) \iff j \lt k \lor (j = k \land \xi \lt \eta)`$.
- $`R(k, \eta, a, b)`$: layer $`k \in \mathbb N`$, root index $`\eta`$, lower point $`a`$, upper point $`b`$.

## 2. The language

There are three kinds of symbols.

| Symbol | Arity | Meaning (in the structure of height $`\gamma`$) |
|---|---|---|
| $`\lt`$ | 2 | order of ordinals |
| $`\mathrm{Rel}_j`$ ($`j \in \mathbb N`$) | 3 | $`\mathrm{Rel}_j(x, y, z) :\iff R(j, x, y, z)`$ |
| $`\mathrm{Top}_j`$ ($`j \in \mathbb N`$) | 2 | $`\mathrm{Top}_j(\xi, x) :\iff R(j, \xi, x, \gamma)`$ |

$`\mathrm{Rel}_j`$ relates points to points, and $`\mathrm{Top}_j`$ relates a point to the top $`\gamma`$. $`\gamma`$ itself is not in the domain.

In Lean the type of interpretations of $`\mathrm{Rel}`$ is `RelF`, and that of $`\mathrm{Top}`$ is `TopF`. The true interpretations are `relR` and `topR γ`.

## 3. The structure of level (k, η)

**Definition.** The structure of height $`\gamma`$ and level $`(k, \eta)`$ is the following. Its domain is $`\{x \mid x \lt \gamma\}`$.

```math
\mathfrak A^{\gamma}_{k,\eta} = \bigl(\gamma;\ \lt,\ (\mathrm{Rel}_j)_{j \in \mathbb N},\ (\mathrm{Top}_j)_{j \lt k},\ (\mathrm{Top}_{k,\xi})_{\xi \lt \eta}\bigr)
```

- $`\mathrm{Rel}_j`$ is present for every layer $`j`$.
- $`\mathrm{Top}_j`$ ($`j \lt k`$) is a **diagonal top predicate**. Its first argument can be an ordinary variable.
- $`\mathrm{Top}_{k,\xi}(x) :\iff R(k, \xi, x, \gamma)`$ is a **named top predicate**. There is one unary symbol for each name $`\xi \lt \eta`$.
- There are no top predicates with $`j \gt k`$.

**Representation in Lean.** A named $`\mathrm{Top}_{k,\xi}(x)`$ is represented as the binary $`\mathrm{Top}_k(p_s, x)`$ whose first argument is at a parameter position $`s`$. A formula comes with a set $`S`$ of positions, and $`s \in S`$ requires $`s \lt r`$ and $`p_s \lt \eta`$. The visible bits are `allowL k S` ([03](03-sigma1-elementary.md) §8).

```math
\mathrm{allowL}\ k\ S\ j\ a \iff j \lt k \ \lor\ (j = k \land a \in S)
```

**Example.** At level $`(2, \omega)`$, consider

```math
\exists y\ \bigl(p_0 \lt y \land \mathrm{Top}_1(y, y) \land \mathrm{Top}_{2, p_0}(y)\bigr)
```

- $`\mathrm{Top}_1(y, y)`$ is diagonal ($`1 \lt 2`$), so its first argument may be the witness $`y`$.
- $`\mathrm{Top}_{2, p_0}(y)`$ is named; position 0 goes into $`S`$. This needs $`p_0 \lt \omega`$.
- $`\mathrm{Top}_2(y, y)`$ and $`\mathrm{Top}_3(p_0, y)`$ cannot be written at this level (reading them gives false).

## 4. The definition

**Definition (R).**

```math
R(k, \eta, a, b) \iff \eta \le a \ \land\ a \lt b \ \land\ \mathfrak A^{a}_{k,\eta} \preccurlyeq_{\Sigma_1} \mathfrak A^{b}_{k,\eta}
```

Here $`\mathfrak A^{a}_{k,\eta} \preccurlyeq_{\Sigma_1} \mathfrak A^{b}_{k,\eta}`$ means that for every $`\Sigma_1`$ formula $`\varphi`$ of level $`(k, \eta)`$ and all parameters $`\vec p \lt a`$ (names $`\lt \eta`$),

```math
\mathfrak A^{a}_{k,\eta} \models \varphi(\vec p) \iff \mathfrak A^{b}_{k,\eta} \models \varphi(\vec p)
```

In Lean it is `Elem k η a b := ElemL relR (topR a) (topR b) k η a b`. The top predicates of the two structures are different ($`R`$ to $`a`$ and $`R`$ to $`b`$).

About the condition $`\eta \le a`$: edges and demands all have "root $`\le`$ parent", so in an increasing labelling it always holds.

## 5. The recursion

The right side reads $`R`$ itself. We use well-founded recursion on the lexicographic order $`\lhd`$ of keys $`(b, k, \eta)`$ ([02](02-well-founded.md) §3), defining all $`a`$ at once.

**What the right side reads.** Only three kinds, all with smaller keys.

| What is read | Key | Why smaller |
|---|---|---|
| $`\mathrm{Rel}_j(x, y, z)`$ | $`(z, j, x)`$ | the points are below the height ($`a`$ or $`b`$), so $`z \lt b`$ |
| a top predicate $`\mathrm{Top}_j(\xi, x)`$ of $`\mathfrak A^{a}`$ | $`(a, j, \xi)`$ | $`a \lt b`$ |
| a visible top predicate of $`\mathfrak A^{b}`$ | $`(b, j, \xi)`$ | $`j \lt k`$, or $`j = k`$ and $`\xi \lt \eta`$ |

**The recursion in Lean (`stepF`).** At key $`t = (b, k, \eta)`$ it returns the set of $`a`$ with $`R(k, \eta, a, b)`$. Each of the three interpretations contains, as a guard, a proof that the key is smaller ([02](02-well-founded.md) §5).

| Stage interpretation | Formula |
|---|---|
| $`\mathrm{Rel}^{\mathrm{st}}_j(x, y, z)`$ | $`z \lt b \land R(j, x, y, z)`$ |
| $`\mathrm{Top}^{\mathrm{st},a}_j(\xi, x)`$ | $`a \lt b \land R(j, \xi, x, a)`$ |
| $`\mathrm{Top}^{\mathrm{st},b}_j(\xi, x)`$ | $`(j, \xi) \prec (k, \eta) \land R(j, \xi, x, b)`$ |

Then:

```lean
noncomputable def RF : Idx → Ord → Prop := ilt_wf.fix stepF
noncomputable def R (k : ℕ) (η a b : Ord) : Prop := RF (b, k, η) a
```

`RF_eq` comes from `WellFounded.fix_eq`. It is the guarded equation `RF t = stepF t (fun t' _ => RF t')`.

## 6. Removing the guards: R_iff

**Theorem (`elem_stage`).** If $`a \lt b`$, then $`\Sigma_1`$-elementarity for the stage interpretations is equivalent to $`\Sigma_1`$-elementarity for the true interpretations (`Elem k η a b`).

**Proof.** Show that the guards are true on every bit a formula of level $`(k, \eta)`$ reads.

1. $`\mathrm{Rel}`$ bits: the points are parameters ($`\lt a`$) or witnesses ($`\lt`$ height $`\le b`$). So $`z \lt b`$ (`cat_bound`).
2. Top predicates at height $`a`$: the guard is $`a \lt b`$, which is the assumption.
3. Visible top predicates at height $`b`$: by `allowL k S`, either $`j \lt k`$, or $`j = k`$ and the position is in $`S`$, in which case the value is $`p_s \lt \eta`$. In both cases $`(j, \cdot) \prec (k, \eta)`$.

Invisible bits are false in both interpretations. So the atomic diagrams are equal (`diagM_congr`) and so are the truth values (`sat_congr`). $`\square`$

**Theorem (`R_iff`).**

```math
R(k, \eta, a, b) \iff \eta \le a \land a \lt b \land \mathrm{Elem}(k, \eta, a, b)
```

**Proof.** Unfold one step with `RF_eq` and use `elem_stage` under $`a \lt b`$. $`\square`$

## 7. Properties that follow directly

**Theorem (`R_lt`, hypothesis `hStrict`).** $`R(k, \eta, a, b)`$ implies $`a \lt b`$. This is the second conjunct of `R_iff`.

**Theorem (`R_index_le`).** $`R(k, \eta, a, b)`$ implies $`\eta \le a`$. This is the first conjunct of `R_iff`.

**Theorem (`R_weaken`, hypothesis `hWeak`).** If $`\eta' \le \eta`$ and $`R(k, \eta, p, c)`$, then $`R(k, \eta', p, c)`$.

**Proof.** $`\eta' \le \eta \le p`$ and $`p \lt c`$ are clear. A formula of level $`(k, \eta')`$ has names $`\lt \eta' \le \eta`$, so it is also a formula of level $`(k, \eta)`$. The two levels interpret the visible symbols in the same way. So agreement at $`(k, \eta)`$ gives agreement at $`(k, \eta')`$. In Lean one only turns the name condition $`p_s \lt \eta'`$ into $`p_s \lt \eta`$. $`\square`$

The core receives the strict version `fun h hR => R_weaken h.le hR`.

**Property (visible top predicates agree).** Let $`R(k, \eta, a, b)`$ and $`\xi, x \lt a`$. If $`j \lt k`$, or $`j = k`$ and $`\xi \lt \eta`$, then

```math
R(j, \xi, x, a) \iff R(j, \xi, x, b)
```

**Reason.** Use the quantifier-free formula $`\mathrm{Top}_j(p_0, p_1)`$ with parameters $`(\xi, x)`$ (if $`j = k`$, put position 0 into $`S`$). At height $`a`$ it means the left side, at height $`b`$ the right side. This property is not stated as a Lean theorem. The proof uses `top_abs`, a statement of a similar form (agreement of the top predicates between a good point and $`\omega_1`$, [09](09-obligations.md) §4).

**Property (the lower point is a limit ordinal).** $`R(k, \eta, a, b)`$ implies that $`a`$ is a nonzero limit ordinal.

**Reason.** As in the example of [03](03-sigma1-elementary.md) §5.

- If $`a = 0`$: $`\exists y\ \neg(y \lt y)`$ ($`n = 1`$, $`\mathit{bb} = 1`$, $`r = 0`$, the matrix is all atomic diagrams) is true at height $`b`$ and false at height 0.
- If $`a = \gamma + 1`$: $`\exists y\ (\gamma \lt y)`$ with parameter $`\gamma \lt a`$ is true at height $`b`$ ($`y = \gamma + 1 \lt b`$) and false at height $`a`$.

Both contradict $`\mathrm{Elem}`$. This property is not proved in Lean, and the combinatorial layer does not use it.

## 8. Properties that are not used

The following properties are expected to hold but are not proved in Lean. The combinatorial layer does not use them ([notes/01-design.md](../../notes/01-design.md) §4.11, Japanese).

- Transitivity: $`R(k, \eta, a, b) \land R(k, \eta, b, c) \implies R(k, \eta, a, c)`$.
- Monotonicity in the index: if $`(k, \eta) \preceq (k', \eta')`$, $`\eta \le a`$ and $`R(k', \eta', a, b)`$, then $`R(k, \eta, a, b)`$.
- Locality: $`R`$ with top $`\le \delta`$ is determined by the recursion below $`\delta + 1`$.

## 9. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "The relation R" | the defining equation and the three kinds of reads in the recursion |
| [README](../../README-en.md) "Where the six hypotheses go" | `hStrict` is `Por.R_lt`, `hWeak` is `Por.R_weaken` |
| [notes/01-design.md](../../notes/01-design.md) §3.3–§3.8, §4.1–§4.4 (Japanese) | definition, recursion, `R_iff`, O3, O4 |
| [Por/Relation.lean](../../Por/Relation.lean) | all of this note |

## 10. Lean correspondence

| Concept | Lean | File |
|---|---|---|
| keys and order | `Idx`, `ilt`, `ilt_wf` | [Por/Relation.lean](../../Por/Relation.lean) |
| one recursion step | `stepF` | same |
| the recursion | `RF`, `RF_eq` | same |
| the relation | `R` | same |
| true interpretations | `relR`, `topR` | same |
| elementarity for the true interpretations | `Elem` | same |
| removing the guards | `elem_stage` | same |
| defining equation | `R_iff` | same |
| O3 | `R_lt`, `R_index_le` | same |
| O4 | `R_weaken` | same |
| visible bits of a level | `allowL` | [Por/Formula.lean](../../Por/Formula.lean) |
| elementarity at a level | `ElemL` | same |

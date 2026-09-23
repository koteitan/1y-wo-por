[← Back](README.md) | [English](09-obligations.md) | [Japanese](../09-obligations.md)

# Discharging the obligations

Prerequisites

| Note | Terms used here |
|---|---|
| [06 Phyrion's combinatorial layer](06-combinatorial-layer.md) | diagram, representation, top atom, `Admissible`, `FiniteReflection`, the six hypotheses |
| [07 The relation R](07-relation-r.md) | $`R`$, `R_iff`, `allowL`, `R_lt`, `R_weaken` |
| [08 Closure below ω₁ and the chain](08-closure-chain.md) | $`\mathfrak B`$, Good, the chain $`c_t`$ |

This note explains how the relation $`R`$ satisfies the six hypotheses of the combinatorial layer. The main parts are finite reflection (§3) and the first representation (§4).

## 1. List of hypotheses

The label data are $`\alpha = \mathrm{Ord}`$, $`\lt`$, $`D = \mathrm{True}`$ and $`R`$ ([notes/01-design.md](../../notes/01-design.md) §3.5, Japanese).

| Code | Hypothesis | Lean name | Section |
|---|---|---|---|
| O1 | `hWF` | `Ordinal.lt_wf` | §2 |
| O2 | `hTrans` | `fun h₁ h₂ => h₁.trans h₂` | §2 |
| O3 | `hStrict` | `R_lt` | §2 |
| O4 | `hWeak` | `fun h hR => R_weaken h.le hR` | §2 |
| O6 | `reflection` | `finiteReflection` | §3 |
| O7 | `initial` | `initial_all` | §4 |

O5 is the definition of `Representation` and carries no obligation.

## 2. O1–O4

- O1: $`\lt`$ on ordinals is well-founded ([01](01-ordinals.md) §1).
- O2: $`\lt`$ on ordinals is transitive.
- O3: the second conjunct of `R_iff` ([07](07-relation-r.md) §7).
- O4: `R_weaken` is proved for $`\eta' \le \eta`$. The core asks for the version with $`\eta' \lt \eta`$, so it is passed with `h.le`.

## 3. O6: finite reflection

**Goal.** Under the hypotheses of [06](06-combinatorial-layer.md) §4, build $`g`$. Notation: $`n`$ is the size of $`G`$, $`f`$ the representation, the control relation is $`R(K, \theta, f(\mathrm{cut}), \beta)`$, and the demands are $`d = (k_d, r_d, p_d)`$.

**Proof.**

1. Let $`a := f(\mathrm{cut})`$. By `R_iff`, $`\theta \le a \lt \beta`$ and $`\mathrm{Elem}(K, \theta, a, \beta)`$.
2. Let the named positions be $`S := \{r_d \mid d \in \mathrm{needs},\ k_d = K\}`$. If $`k_d = K`$, the first case of `Admissible` cannot occur, so $`r_d \lt \mathrm{cut}`$ and $`f(r_d) \lt \theta`$.
3. The parameters are $`f(0), \ldots, f(\mathrm{cut} - 1)`$. Since $`f`$ is increasing, all are $`\lt a`$.
4. Build the following $`\Sigma_1`$ formula $`\Phi`$. Let $`z_i := f(i)`$ for $`i \lt \mathrm{cut}`$ and $`z_i := y_i`$ for $`\mathrm{cut} \le i \lt n`$.

```math
\Phi :\equiv \exists y_{\mathrm{cut}} \cdots \exists y_{n-1}\ \Bigl[\ \bigwedge_{i \lt j \lt n} z_i \lt z_j \ \land\ \bigwedge_{e \in G} \mathrm{Rel}_{k_e}(z_{r_e}, z_{p_e}, z_{q_e}) \ \land\ \bigwedge_{d \in \mathrm{needs}} \mathrm{Top}_{k_d}(z_{r_d}, z_{p_d})\ \Bigr]
```

5. $`\Phi`$ is a formula of level $`(K, \theta)`$. For $`k_d \lt K`$, $`\mathrm{Top}_{k_d}`$ is diagonal, so its first argument $`z_{r_d}`$ may be a witness. For $`k_d = K`$, $`r_d \in S`$ and this is the named $`\mathrm{Top}_{K, f(r_d)}`$.
6. $`\Phi`$ is true at height $`\beta`$. With witnesses $`y_i := f(i)`$ we get $`z = f`$. The order part follows from condition 2 of the representation, the $`\mathrm{Rel}`$ part from condition 3, and the $`\mathrm{Top}`$ part from the demand hypothesis ($`R(k_d, f(r_d), f(p_d), \beta)`$).
7. By the elementarity of step 1, $`\Phi`$ is true at height $`a`$. Take its witnesses $`y'_i \lt a`$.
8. Let $`g := `$ `cat cut f y'`, that is, $`g(i) = f(i)`$ for $`i \lt \mathrm{cut}`$ and $`g(i) = y'_i`$ otherwise.
   - $`g`$ is increasing (the order part).
   - $`R`$ holds on every atom of $`G`$ (the $`\mathrm{Rel}`$ part).
   - $`g(i) \lt a`$ (on the left $`f(i) \lt f(\mathrm{cut})`$; on the right the witnesses are $`\lt a`$).
   - Every demand has $`R(k_d, g(r_d), g(p_d), a)`$ (at height $`a`$, $`\mathrm{Top}_j(\xi, x)`$ means $`R(j, \xi, x, a)`$). $`\square`$

**Example.** Let $`G`$ be the diagram of $`(1, 2, 4)`$ (atoms $`(0,0,0,1)`$, $`(0,0,1,2)`$, $`(0,1,1,2)`$). Let $`\mathrm{cut} = 1`$, $`K = 0`$, and let the only demand be $`d = (0, 0, 2)`$. If $`f(0) \lt \theta`$, then $`d`$ is admissible. $`S = \{0\}`$, the parameter is $`p_0 = f(0)`$, and $`\Phi`$ is

```math
\exists y_1\ \exists y_2\ \bigl[\ p_0 \lt y_1 \land p_0 \lt y_2 \land y_1 \lt y_2 \land \mathrm{Rel}_0(p_0, p_0, y_1) \land \mathrm{Rel}_0(p_0, y_1, y_2) \land \mathrm{Rel}_0(y_1, y_1, y_2) \land \mathrm{Top}_{0, p_0}(y_2)\ \bigr]
```

At height $`\beta`$ the witnesses are $`(y_1, y_2) = (f(1), f(2))`$. Reflection gives new $`(y'_1, y'_2)`$ below $`f(1)`$.

**The form in Lean.** The bound on symbols is `sigBound G needs` (sum of the layers of the atoms + sum of the layers of the demands + 1), and the matrix is `reflMat G needs m`. `reflMat_iff` reads out the matrix, using `getLt`, `getRel`, `getTop` and their `_diagM` lemmas.

**Not used.** $`D(\beta)`$, that $`a`$ or $`\beta`$ is a limit, that they are closure points.

## 4. O7: the first representation

### 4.1 Absoluteness of the top predicates

**Theorem (`top_abs`).** Let $`\mathrm{Good}(\alpha)`$ and $`\alpha \lt \omega_1`$. For every $`j`$ and $`\zeta, x \lt \alpha`$,

```math
R(j, \zeta, x, \alpha) \iff R(j, \zeta, x, \omega_1)
```

**Proof.** Well-founded induction on $`(j, \zeta)`$ in the lexicographic order of $`\mathbb N \times \mathrm{Ord}`$ ([02](02-well-founded.md) §2).

1. Open both sides with `R_iff`. $`\zeta \le x`$ is common, and both $`x \lt \alpha`$ and $`x \lt \omega_1`$ hold. What remains is that every formula $`\psi`$ of level $`(j, \zeta)`$ (parameters $`\lt x`$) has the same truth value at height $`\alpha`$ and at height $`\omega_1`$ (`sat_abs`).
2. Every top-predicate bit $`\mathrm{Top}_i(u, v)`$ ($`u, v \lt \alpha`$) that $`\psi`$ reads satisfies $`(i, u) \prec (j, \zeta)`$. By the induction hypothesis it has the same truth value at heights $`\alpha`$ and $`\omega_1`$.
3. So on visible bits the structure of height $`\alpha`$ agrees with $`\mathfrak B{\restriction}\alpha`$. With `sat_mask`, translate the level formula into the all-symbol formula $`\psi^*`$ whose invisible bits are set to false.
4. By $`\mathrm{Good}(\alpha)`$, $`\mathfrak B{\restriction}\alpha \models \psi^* \iff \mathfrak B \models \psi^*`$.
5. Translating back with `sat_mask` gives the truth value in the level-$`(j, \zeta)`$ structure of height $`\omega_1`$. $`\square`$

Step 3 uses "visibility depends only on positions" ([03](03-sigma1-elementary.md) §8). This is the reason for named top predicates ([notes/01-design.md](../../notes/01-design.md) §3.8, item 3, Japanese).

### 4.2 Two points of the chain are related by R

**Theorem (`chain_R`).** For $`i \lt j`$, every layer $`k`$ and $`\eta \le c_i`$, $`R(k, \eta, c_i, c_j)`$.

**Proof.** $`\eta \le c_i \lt c_j`$, so the side conditions hold. For a formula $`\psi`$ of level $`(k, \eta)`$ and parameters $`\vec p \lt c_i`$, chain these equivalences.

```math
\mathfrak A^{c_i}_{k,\eta} \models \psi \iff \mathfrak B{\restriction}c_i \models \psi^* \iff \mathfrak B \models \psi^* \iff \mathfrak B{\restriction}c_j \models \psi^* \iff \mathfrak A^{c_j}_{k,\eta} \models \psi
```

The first and fourth use `top_abs` (at $`c_i`$ and at $`c_j`$) and `sat_mask`; the second and third use $`\mathrm{Good}(c_i)`$ and $`\mathrm{Good}(c_j)`$. $`\square`$

### 4.3 Representations of all diagrams

**Theorem (`initial_all`).** Every diagram $`G`$ has a representation.

**Proof.** Let $`f := c`$ (the chain).

- $`D`$ is True, so the domain condition is trivial.
- $`f`$ is strictly increasing (`cC_strictMono`).
- An atom $`(k, r, p, q)`$ has $`r \le p \lt q`$, so $`c_r \le c_p \lt c_q`$. Applying `chain_R` with $`\eta := c_r`$ gives $`R(k, c_r, c_p, c_q)`$. $`\square`$

One $`f`$ represents all diagrams at once. In particular it represents `exprDiagram s`, so O7 holds. No bound and no seed condition is needed.

## 5. Summary and the final theorems

`model_obligations` ([Por/Model.lean](../../Por/Model.lean)) lists the six hypotheses in the same form as the entry theorem.

```lean
theorem model_obligations :
    WellFounded (α := Ord) (· < ·) ∧
    (∀ {a b c : Ord}, a < b → b < c → a < c) ∧
    (∀ {k : ℕ} {index a b : Ord}, R k index a b → a < b) ∧
    (∀ {k : ℕ} {small large p c : Ord}, small < large → R k large p c → R k small p c) ∧
    FiniteReflection (α := Ord) (· < ·) (fun _ => True) R ∧
    (∀ G : Diagram, ∃ f, Representation (α := Ord) (· < ·) (fun _ => True) R G f)
```

[Por/WellOrdering.lean](../../Por/WellOrdering.lean) passes it to `OneY.RootIndexed.actual_expansion_wellFounded` and gets `expansion_wellFounded`. The other three theorems pass `expansion_wellFounded` to the corollaries in `OneY.Numeric`.

**Axioms.** All main theorems depend only on `propext`, `Classical.choice` and `Quot.sound` ([README](../../README-en.md) "Axiom audit").

**Strength.** The proof uses the axiom of choice and the regularity of $`\omega_1`$. The labels are closure points below $`\omega_1`$ whose values are not known. No ordinal bound or notation system is obtained.

## 6. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "Where the six hypotheses go" | the table of hypotheses and the summary of reflection and the initial labelling |
| [notes/01-design.md](../../notes/01-design.md) §2.3, §4.2–§4.10 (Japanese) | table of obligations and the proof of each |
| [Por/Reflection.lean](../../Por/Reflection.lean) | §3 |
| [Por/Chain.lean](../../Por/Chain.lean) | §4 |
| [Por/Model.lean](../../Por/Model.lean), [Por/WellOrdering.lean](../../Por/WellOrdering.lean) | §5 |
| [Audit.lean](../../Audit.lean) | axioms in §5 |

## 7. Lean correspondence

| Concept | Lean | File |
|---|---|---|
| reading the matrix | `getLt`, `getRel`, `getTop`, `getLt_diagM`, `getRel_diagM`, `getTop_diagM` | [Por/Reflection.lean](../../Por/Reflection.lean) |
| bound on symbols | `sigBound`, `atom_layer_lt`, `need_layer_lt` | same |
| the reflected formula | `reflMat`, `reflMat_iff` | same |
| O6 | `finiteReflection` | same |
| one step of absoluteness | `sat_abs` | [Por/Chain.lean](../../Por/Chain.lean) |
| absoluteness of the top predicates | `top_abs` | same |
| relations along the chain | `chain_R` | same |
| O7 | `initial_all` | same |
| the six together | `model_obligations` | [Por/Model.lean](../../Por/Model.lean) |
| final theorems | `expansion_wellFounded`, `generated_strictWellOrder`, `descendants_strictWellOrder`, `expansion_chain_reaches_empty` | [Por/WellOrdering.lean](../../Por/WellOrdering.lean) |

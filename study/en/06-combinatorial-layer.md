[← Back](README.md) | [English](06-combinatorial-layer.md) | [Japanese](../06-combinatorial-layer.md)

# Phyrion's combinatorial layer

Prerequisites

| Note | Terms used here |
|---|---|
| [02 Well-founded relations and recursion](02-well-founded.md) | well-founded, `Acc`, termination by labels (§6) |
| [05 The 1-Y sequence and its mountain](05-1y-mountain.md) | expression, layer, row, parent, root of a component, bad root, expansion |

This note explains the part of Phyrion's proof that does not use the meaning of the labels (the combinatorial layer). This layer takes the label type $`\alpha`$, an order $`\lt`$, a domain $`D`$ and a relation $`R`$ as arguments, and proves well-foundedness of expansion from six hypotheses about them. This repository uses this layer unchanged.

## 1. Diagrams

**Definition (atom).** An **atom** is a 4-tuple of natural numbers $`e = (k, r, p, q)`$: layer $`k`$, root $`r`$, parent $`p`$, child $`q`$ (`Atom`). It is **valid** for size $`n`$ if $`r \le p \lt q \lt n`$ (`Atom.Valid`).

**Definition (diagram).** A **diagram** is a size $`n`$ together with a finite list of valid atoms (`Diagram`). $`n`$ is the number of columns.

**The diagram of an expression.** The diagram `exprDiagram s` of an expression $`s`$ has one atom for each parent–child edge in every layer and every row (`rowAtom`, `mountainDiagram`, `sequenceDiagram`). If column $`c`$ has parent $`p`$ in layer $`k`$, row $`r`$, it contains the atom

```math
(k,\ \mathrm{root}_{k,r}(c),\ p,\ c)
```

where $`\mathrm{root}_{k,r}(c)`$ is the root of the component of $`c`$ in layer $`k`$, row $`r`$.

| Expression | Atoms $`(k, r, p, q)`$ |
|---|---|
| $`(1, 2, 2)`$ | $`(0,0,0,1)`$, $`(0,0,0,2)`$ |
| $`(1, 2, 4)`$ | $`(0,0,0,1)`$, $`(0,0,1,2)`$, $`(0,1,1,2)`$ |
| $`(1, 3)`$ | $`(0,0,0,1)`$, $`(1,0,0,1)`$ |

The third atom of $`(1, 2, 4)`$ is the edge $`2 \to 1`$ of row 1. Column 1 has no parent in row 1, so its root is column 1 itself.

## 2. Representations

Fix $`(\alpha, \lt, D, R)`$. $`R(k, \eta, a, b)`$ is a relation of four arguments, read "in layer $`k`$ with root index $`\eta`$, $`a`$ is stable into $`b`$".

**Definition (representation).** A function $`f : \mathbb N \to \alpha`$ is a **representation** of a diagram $`G`$ of size $`n`$ if the following three conditions hold (`Representation`).

1. $`D(f(i))`$ for $`i \lt n`$.
2. $`f(i) \lt f(j)`$ for $`i \lt j \lt n`$.
3. $`R(k, f(r), f(p), f(q))`$ for each atom $`(k, r, p, q)`$ of $`G`$ (`Atom.Holds`).

$`f(i)`$ is called the **label** of column $`i`$.

**Example.** A representation of the diagram of $`(1, 2, 4)`$ is an $`f`$ with

```math
f(0) \lt f(1) \lt f(2), \quad R(0, f(0), f(0), f(1)), \quad R(0, f(0), f(1), f(2)), \quad R(0, f(1), f(1), f(2))
```

## 3. Demands toward the top

**Definition (top atom).** A **top atom** is $`d = (k, r, p)`$; it is valid for size $`n`$ if $`r \le p \lt n`$ (`TopAtom`, `TopAtom.Valid`). It holds for a top $`\beta \in \alpha`$ if $`R(k, f(r), f(p), \beta)`$ (`TopAtom.Holds`).

A top atom is an edge to a point $`\beta`$ outside the diagram. In an expansion, the label of the old last column plays the role of $`\beta`$.

**Definition (bound).** $`f`$ is **bounded by** $`\beta`$ if $`f(i) \lt \beta`$ for all $`i \lt n`$ (`Bounded`).

## 4. Finite reflection

**Definition (admissible demand).** For a layer $`K`$, a cut $`\mathrm{cut}`$ and an index $`\theta`$, a top atom $`d = (k_d, r_d, p_d)`$ is **admissible** if one of the following holds (`Admissible`).

- $`k_d \lt K`$ (a lower layer).
- $`k_d = K`$ and $`r_d \lt \mathrm{cut}`$ and $`f(r_d) \lt \theta`$ (the same layer, the root before the cut, and the root's label below $`\theta`$).

**Definition (finite reflection `FiniteReflection`).** The following holds. The hypotheses are these eight.

1. $`G`$ is a diagram of size $`n`$ and $`\mathrm{cut} \lt n`$.
2. $`f`$ is a representation of $`G`$.
3. $`D(\beta)`$.
4. $`f`$ is bounded by $`\beta`$.
5. The control relation $`R(K, \theta, f(\mathrm{cut}), \beta)`$ holds.
6. Every element of the list of demands $`\mathrm{needs}`$ is valid.
7. Every element is admissible.
8. Every element holds for the top $`\beta`$.

Then there is a $`g`$ with:

1. $`g`$ is a representation of $`G`$.
2. $`g(i) = f(i)`$ for $`i \lt \mathrm{cut}`$.
3. $`g`$ is bounded by $`f(\mathrm{cut})`$.
4. Every demand holds for the top $`f(\mathrm{cut})`$.

**Meaning.** The labels left of the cut stay. The labels from the cut on are replaced so that all of them lie below $`f(\mathrm{cut})`$. The edge conditions and the demands toward the top (with the top changed from $`\beta`$ to $`f(\mathrm{cut})`$) are kept. This is exactly the shape of finite reflection in [04](04-patterns-of-resemblance.md) §3.

## 5. The six hypotheses

The entry theorem `OneY.RootIndexed.actual_expansion_wellFounded` has these six hypotheses.

| Name | Statement |
|---|---|
| `hWF` | $`\lt`$ is well-founded |
| `hTrans` | $`a \lt b`$ and $`b \lt c`$ imply $`a \lt c`$ |
| `hStrict` | $`R(k, \eta, a, b)`$ implies $`a \lt b`$ |
| `hWeak` | $`\eta' \lt \eta`$ and $`R(k, \eta, p, c)`$ imply $`R(k, \eta', p, c)`$ |
| `reflection` | `FiniteReflection lt D R` |
| `initial` | for every expression $`s`$, `exprDiagram s` has a representation |

The conclusion is `WellFounded (ZeroY.ExpansionStep expand)`.

## 6. Descent of the last label

**Definition (last representation).** If the size $`n`$ of $`G`$ is positive and $`G`$ has a representation $`f`$ with $`f(n-1) = a`$, we write `LastRepresentation G a`.

**Theorem (`expand_lastRepresentation_lower`).** Suppose `exprDiagram s` has a representation with last label $`\beta`$, and $`s[N]`$ is nonempty. Then for some $`b \lt \beta`$, `exprDiagram (s[N])` has a representation with last label $`b`$.

**Outline of the proof.** Let $`x`$ be the last column of $`s`$.

1. No bad root: $`s[N]`$ is $`s`$ without its last column. The new diagram is a prefix of the old one (`sequenceDiagram_take_isPrefix`). The same $`f`$ is a representation, and the new last label $`f(x-1)`$ is below $`f(x) = \beta`$ (`proper_prefix_lowers_last_label`).
2. Bad root $`y`$ (layer $`K`$, row $`d`$):
   - The diagram number $`b = 0`$ has size $`x`$ and is a prefix of the old diagram (it does not contain the last column $`x`$; `copyDiagram_zero_isPrefix`). $`f`$ is a representation of it, bounded by $`\beta = f(x)`$.
   - The edge at the bad root gives $`R(K, f(\rho), f(y), f(x))`$, where $`\rho`$ is the root of the component of $`x`$. This is the first control relation (`initial_control_holds`).
   - Going from diagram $`b`$ to diagram $`b + 1`$ uses finite reflection once (`exists_bounded_representation_splice`). The cut is the start of block $`b`$, $`y + b \cdot (x - y)`$.
   - With the $`g`$ from the reflection, the part from the cut on is put below $`f(\mathrm{cut})`$. In the freed space on the right, the old labels $`f(\mathrm{cut}), \ldots, f(n-1)`$ are placed as they are (`spliceLabel`). This gives a representation of the diagram that is one block longer.
   - After $`N`$ repetitions we get a representation of the diagram of $`s[N]`$ bounded by $`\beta`$ (`blockScheme_bounded_representations`, `copied_diagrams_bounded`).
   - The new last label is below $`\beta`$ (`last_label_of_bounded_representation`). $`\square`$

**Where the six hypotheses are used.**

| Hypothesis | Where |
|---|---|
| `hWF` | the induction on the last label |
| `hTrans` | order and bound of the spliced labels (`spliceLabel_ordered`, `spliceLabel_bounded`) |
| `hStrict` | $`f(\mathrm{cut}) \lt \beta`$ from the control relation |
| `hWeak` | edges whose root moves to an earlier block (`CopyCase`) and virtual demands (`virtual_demands_from_templates`) |
| `reflection` | once per block |
| `initial` | the start of the induction |

**Well-foundedness.** By well-founded induction on $`\beta`$, show "if `exprDiagram s` has a representation with last label $`\beta`$, then $`s`$ is accessible" (`expansion_accessible_of_lastRepresentation`). This is the form of [02](02-well-founded.md) §6. The empty expression has no one-step expansion and is handled separately (`expansionStep_empty_accessible`). By `initial` every expression gets a first label. Hence the expansion relation is well-founded.

## 7. What remains for the semantic layer

The combinatorial layer does not ask why finite reflection holds. Supplying $`(\alpha, \lt, D, R)`$ with the six hypotheses is the job of the **semantic layer**.

- Phyrion's semantic layer: $`D`$ is a condition corresponding to admissible ordinals (`Adequate`), and $`R`$ is $`\Sigma_1`$ preservation of a truth tower over the constructible universe $`L`$.
- The semantic layer of this repository: $`\alpha = \mathrm{Ord}`$, $`D = \mathrm{True}`$, and $`R`$ is the relation of [07 The relation R](07-relation-r.md). The proofs are in [09 Discharging the obligations](09-obligations.md).

## 8. Where this repository uses it

| Place | Use |
|---|---|
| [README](../../README-en.md) "Shape of the proof", "Where the six hypotheses go" | the two layers and the table of the six hypotheses |
| [notes/01-design.md](../../notes/01-design.md) §2 (Japanese) | entry theorem, interface, table of obligations, use in the core |
| [notes/02-port.md](../../notes/02-port.md) (Japanese) | the port of the combinatorial layer |
| [Por/Model.lean](../../Por/Model.lean), [Por/WellOrdering.lean](../../Por/WellOrdering.lean) | passing the six hypotheses to the entry theorem |

## 9. Lean correspondence

All files are in `OneY/RootIndexed/`.

| Concept | Lean | File |
|---|---|---|
| atom, diagram | `Atom`, `Atom.Valid`, `Diagram` | [Representation.lean](../../OneY/RootIndexed/Representation.lean) |
| top atom | `TopAtom`, `TopAtom.Valid`, `TopAtom.Holds` | same |
| representation, bound | `Representation`, `Bounded` | same |
| admissible demand, finite reflection | `Admissible`, `FiniteReflection` | same |
| splicing one block | `spliceLabel`, `exists_bounded_representation_splice` | same |
| repeating blocks | `BlockScheme`, `blockScheme_bounded_representations` | same |
| last representation | `LastRepresentation`, `last_label_of_bounded_representation`, `proper_prefix_lowers_last_label` | same |
| diagram of a mountain | `rowAtom`, `mountainDiagram` | [Diagram.lean](../../OneY/RootIndexed/Diagram.lean) |
| diagram of an expression | `sequenceDiagram` | [Prefix.lean](../../OneY/RootIndexed/Prefix.lean) |
| the actual block construction | `actualBlockScheme`, `copied_diagrams_bounded` | [ActualScheme.lean](../../OneY/RootIndexed/ActualScheme.lean) |
| entry theorem | `exprDiagram`, `expand_lastRepresentation_lower`, `expansion_accessible_of_lastRepresentation`, `actual_expansion_wellFounded` | [ExpansionWellFounded.lean](../../OneY/RootIndexed/ExpansionWellFounded.lean) |

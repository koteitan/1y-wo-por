[English](README-en.md) | [Japanese](README.md)

# 1y-wo-por: well-foundedness of 1-Y by patterns of resemblance

This repository proves in Lean 4 that the expansion of the 1-Y sequence system is well-founded.

The proof is based on Phyrion's proof ([Phyrion1343/1Y-Well-Ordering-Lean](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean)). Its combinatorial part is used unchanged. Only its semantic part is replaced, by a relation defined directly on ordinals in the style of patterns of resemblance. No constructible universe $`L`$ and no admissible ordinal is used.

- Lean 4.33.1, Mathlib v4.33.1.
- No `sorry` and no new axiom. The only axioms are `propext`, `Classical.choice` and `Quot.sound`.

## What is proved

### Notation

- An expression is a finite sequence of positive integers that is empty or starts with 1 (`ZeroY.Expr`). It need not be generated from a seed.
- $`s[N]`$ is the 1-Y expansion of the expression $`s`$ with copy count $`N`$ (`OneY.Numeric.expand s N`).
- $`s \to^{*} t`$ means that $`t`$ is reached from $`s`$ by zero or more expansions, with any copy count at each step.
- $`\lt_{\mathrm{lex}}`$ is the lexicographic order of expressions; a proper prefix is smaller.
- A strict well-order is a relation that is well-founded, transitive and trichotomous (`Por.StrictWellOrder`).

### The four final theorems

The final theorems are in [Por/WellOrdering.lean](Por/WellOrdering.lean), namespace `Por`.

1. `expansion_wellFounded`: the relation of one nontrivial expansion step is well-founded. That is, there is no infinite sequence of the following form.

```math
s_0,\ s_1,\ s_2,\ \ldots \qquad s_{n+1} = s_n[N_n] \ne s_n \quad (n \in \mathbb N)
```

2. `generated_strictWellOrder`: the set $`G`$ of expressions generated from the standard seeds $`(1,m)`$ is strictly well-ordered by $`\lt_{\mathrm{lex}}`$.

```math
G = \{\, s \mid \exists m \ge 1,\ (1,m) \to^{*} s \,\}
```

3. `descendants_strictWellOrder`: for every expression $`s`$, the set $`\mathrm{Desc}(s)`$ of its descendants is strictly well-ordered by $`\lt_{\mathrm{lex}}`$.

```math
\mathrm{Desc}(s) = \{\, t \mid s \to^{*} t \,\}
```

4. `expansion_chain_reaches_empty`: whatever copy counts are chosen, a chain of expansions reaches the empty sequence.

```math
\bigl(\forall n\ \exists N,\ c_{n+1} = c_n[N]\bigr) \implies \exists n,\ c_n = ()
```

The first theorem is the main one. Phyrion's combinatorial layer derives the other three from it.

## Shape of the proof

Phyrion's proof has two layers.

- The combinatorial layer (`ZeroY/`, `OneY/`). It turns the mountain of a 1-Y sequence into a finite diagram and labels each column with an ordinal. It shows that the diagram after an expansion has a labelling whose last label is smaller. This layer uses only a label type $`\alpha`$, an order $`\lt`$, a domain $`D`$, a relation $`R(k,\eta,a,b)`$ and six hypotheses about them. Its entry theorem is `OneY.RootIndexed.actual_expansion_wellFounded`.
- The semantic layer. It provides $`(\alpha, \lt, D, R)`$ satisfying the six hypotheses. In Phyrion's semantic layer, $`D`$ is a condition corresponding to admissible ordinals (`Adequate`), and $`R`$ is $`\Sigma_1`$ preservation of truth towers over the constructible universe $`L`$.

This repository replaces only the semantic layer. The labels are ordinals, the order is $`\lt`$, and $`D`$ is always true. $`R`$ is the relation of the next section.

This is the 1-Y analogue of what [bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern) did for BMS. There, the admissible-ordinal labels were replaced by Carlson's patterns of resemblance. In 1-Y the stage index is two-dimensional, ranging over $`\omega \times \omega_1`$. So every stage is $`\Sigma_1`$, and the relations toward the top are atomic symbols of the language.

## The relation R

$`R(k,\eta,a,b)`$ reads "at layer $`k`$ and root index $`\eta`$, $`a`$ is stable toward $`b`$". It is defined by one formula.

```math
R(k,\eta,a,b) \iff \eta \le a \ \land\ a \lt b \ \land\ \mathfrak A^{a}_{k,\eta} \preccurlyeq_{\Sigma_1} \mathfrak A^{b}_{k,\eta}
```

$`\mathfrak A^{\gamma}_{k,\eta}`$ is the structure of height $`\gamma`$ at stage $`(k,\eta)`$. Its domain is $`\{x \mid x \lt \gamma\}`$.

```math
\mathfrak A^{\gamma}_{k,\eta} = \bigl(\gamma;\ \lt,\ (\mathrm{Rel}_j)_{j \in \mathbb N},\ (\mathrm{Top}_j)_{j \lt k},\ (\mathrm{Top}_{k,\xi})_{\xi \lt \eta}\bigr)
```

- Inner relations: $`\mathrm{Rel}_j(x,y,z) :\iff R(j,x,y,z)`$, for every layer $`j`$.
- Diagonal top predicates: $`\mathrm{Top}_j(\xi,x) :\iff R(j,\xi,x,\gamma)`$, only for layers $`j \lt k`$.
- Named top predicates: $`\mathrm{Top}_{k,\xi}(x) :\iff R(k,\xi,x,\gamma)`$, one for each name $`\xi \lt \eta`$.
- $`\preccurlyeq_{\Sigma_1}`$ is $`\Sigma_1`$-elementary substructure: every $`\Sigma_1`$ formula of stage $`(k,\eta)`$ with parameters below $`a`$ has the same truth value in both structures.

The right-hand side reads $`R`$ itself. So $`R`$ is defined by well-founded recursion on the key $`(b,k,\eta)`$ in lexicographic order. Every $`R`$ read on the right has a smaller key.

- In $`\mathrm{Rel}_j(x,y,z)`$ we have $`z \lt b`$.
- In the top predicates of $`\mathfrak A^{a}`$ the top is $`a \lt b`$.
- In the top predicates of $`\mathfrak A^{b}`$ the pair $`(j,\xi)`$ is lexicographically below $`(k,\eta)`$.

In Lean this is `Por.R` with its defining equation `Por.R_iff` ([Por/Relation.lean](Por/Relation.lean)).

### Where the six hypotheses go

| Hypothesis | Content | Lean name |
|---|---|---|
| `hWF` | $`\lt`$ is well-founded | `Ordinal.lt_wf` |
| `hTrans` | $`\lt`$ is transitive | `h₁.trans h₂` |
| `hStrict` | $`R(k,\eta,a,b)`$ implies $`a \lt b`$ | `Por.R_lt` |
| `hWeak` | $`\eta' \lt \eta`$ and $`R(k,\eta,p,c)`$ imply $`R(k,\eta',p,c)`$ | `Por.R_weaken` |
| `reflection` | finite reflection `FiniteReflection` | `Por.finiteReflection` |
| `initial` | the diagram of every expression has a labelling | `Por.initial_all` |

`Por.model_obligations` states all six at once ([Por/Model.lean](Por/Model.lean)).

- Finite reflection: the diagram and the demands toward the top are written as one $`\Sigma_1`$ formula, which the $`\Sigma_1`$-elementarity of $`R`$ reflects downward.
- Initial labellings: they come from a chain $`c_0 \lt c_1 \lt \cdots`$ of closure points below $`\omega_1`$. Any two points of the chain are related by $`R`$ at every layer and at every root index up to the smaller point. So the chain represents every finite diagram.

The proof uses the axiom of choice and the regularity of $`\omega_1`$. The labels are ordinals below $`\omega_1`$. No ordinal bound and no notation system is obtained.

The full design and proof are in [notes/01-design.md](notes/01-design.md) (in Japanese).

## Mathematical background

[study/](study/en/README.md) has background notes for reading this repository (in English and Japanese). There are nine: ordinals and $`\omega_1`$, well-founded recursion, $`\Sigma_1`$-elementary substructures and the Tarski–Vaught test, Carlson's patterns of resemblance, the mountain of a 1-Y sequence, Phyrion's combinatorial layer, the relation $`R`$, closure below $`\omega_1`$ and the chain, and the discharge of the obligations. Every note names the Lean declarations.

## Files

| Path | Content |
|---|---|
| [Por/](Por/) | The model of the semantic layer. 9 files, about 800 lines. Uses Mathlib |
| [Por/BMS/](Por/BMS/) | The BMS layer that the combinatorial layer calls. 6 files, about 3,300 lines. Written for this repository. Lean core only |
| [ZeroY/](ZeroY/) | Phyrion's 0-Y layer, adapted. 42 modules |
| [OneY/](OneY/) | Phyrion's 1-Y layer, adapted. 118 modules |
| [notes/](notes/) | Design notes (in Japanese) |
| [study/](study/en/README.md) | Notes on the mathematical background (in English and Japanese) |
| [Audit.lean](Audit.lean) | The axiom audit. Not part of any `lean_lib` |
| [LICENSE](LICENSE), [NOTICE](NOTICE) | Apache-2.0 and the record of origins |

The files of `Por/`, in import order:

| File | Content |
|---|---|
| [Tuple.lean](Por/Tuple.lean) | the ordinal type `Ord`, concatenation `cat` |
| [Omega1.lean](Por/Omega1.lean) | $`\omega_1`$, enumeration of countable ordinals `enumBelow` |
| [Formula.lean](Por/Formula.lean) | atomic diagrams `Diag`, truth of $`\Sigma_1`$ formulas `Sat`, stage-restricted elementarity `ElemL` |
| [Relation.lean](Por/Relation.lean) | the recursion `stepF`, `RF`, the relation `R`, `R_iff`, `R_lt`, `R_weaken` |
| [Reflection.lean](Por/Reflection.lean) | finite reflection `finiteReflection` |
| [Closure.lean](Por/Closure.lean) | closure points `lam`, `lam_good` |
| [Chain.lean](Por/Chain.lean) | absoluteness of the top predicates `top_abs`, the chain `cC`, `initial_all` |
| [Model.lean](Por/Model.lean) | the six hypotheses together, `model_obligations` |
| [WellOrdering.lean](Por/WellOrdering.lean) | the four final theorems |

The files of `notes/`:

- [01-design.md](notes/01-design.md): design of the semantic layer: the list of obligations, the definition of $`R`$, the proof of each obligation, and the Lean names.
- [02-port.md](notes/02-port.md): plan and record of the port of the combinatorial layer, with the list of names rewritten in the BMS layer.

## Building

Lean 4.33.1 and Mathlib v4.33.1 (`lean-toolchain`, `lakefile.toml`).

The author checked the proof with the checking tool leanman, from the repository root:

```sh
leanman build ZeroY OneY Por
leanman check -C . Audit.lean
```

The same can be done with lake alone:

```sh
lake exe cache get
lake build ZeroY OneY Por
lake env lean Audit.lean
```

- The default target is `Por`. A bare `lake build` already builds every module the final theorems need.
- Naming `ZeroY` and `OneY` builds every module of the two libraries.
- On 2026-09-23, `leanman build ZeroY OneY Por` and `leanman check -C . Audit.lean` both exited with code 0.

## Axiom audit

[Audit.lean](Audit.lean) runs `#print axioms` on the main theorems. Its output (2026-09-23, exit code 0):

```text
'Por.expansion_wellFounded' depends on axioms: [propext, Classical.choice, Quot.sound]
'Por.generated_strictWellOrder' depends on axioms: [propext, Classical.choice, Quot.sound]
'Por.descendants_strictWellOrder' depends on axioms: [propext, Classical.choice, Quot.sound]
'Por.expansion_chain_reaches_empty' depends on axioms: [propext, Classical.choice, Quot.sound]
'Por.model_obligations' depends on axioms: [propext, Classical.choice, Quot.sound]
'Por.finiteReflection' depends on axioms: [propext, Classical.choice, Quot.sound]
'Por.initial_all' depends on axioms: [propext, Classical.choice, Quot.sound]
'Por.R_iff' depends on axioms: [propext, Classical.choice, Quot.sound]
'OneY.RootIndexed.actual_expansion_wellFounded' depends on axioms: [propext, Classical.choice, Quot.sound]
```

- Each uses only the three standard axioms of Lean. There is no `sorryAx`.
- The sources contain no `sorry` and no `axiom` declaration.

## Credits and licenses

This repository is licensed under the Apache License 2.0 ([LICENSE](LICENSE)). [NOTICE](NOTICE) records the origins and the changes.

- Combinatorial layer: adapted from `formalization/ZeroY` and `formalization/OneY` of [Phyrion1343/1Y-Well-Ordering-Lean](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean) (Apache-2.0, revision `6533b29`). The overall shape of the proof is Phyrion's. Each file starts with a header naming its original path and the changes, such as renaming the imports and namespaces of the BMS layer to `Por.BMS`. The comments are kept as they were (some are in Chinese).
- Helpers in `Por/`: the five files `Tuple`, `Omega1`, `Relation`, `Closure` and `Chain` adapt helpers and constructions of `lean/Pattern` of [koteitan/bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern). That project is licensed under CC BY-SA 4.0 and has the same author as this repository. The author releases these parts here under Apache-2.0 as well (decided 2026-09-23). Each of these files says so in its header.
- BMS layer: `Por/BMS/` is written for this repository. Phyrion's repository bundles a snapshot of BMS code (YesMetaZFC) that has no license file, and the combinatorial layer originally calls it. `Por/BMS/` takes from the calling code (Apache-2.0) only the names and the shapes of the statements that the combinatorial layer calls. The definitions and proofs are new. No line of the snapshot is copied.

## References

- Phyrion, [1Y-Well-Ordering-Lean](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean). A Lean formalization of the well-foundedness of 1-Y.
- Phyrion, [Well-Ordering of the 1-Y Sequence System](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean/blob/main/Well-Ordering%20of%20the%201-Y%20Sequence%20System.pdf). The paper in the repository above.
- T. J. Carlson, Elementary patterns of resemblance, Annals of Pure and Applied Logic 108 (2001), 19–77.
- koteitan, [bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern). Well-foundedness of BMS by patterns of resemblance.

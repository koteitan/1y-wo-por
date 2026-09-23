[← Back](README.md) | [English](en/01-ordinals.md) | [Japanese](01-ordinals.md)

# 順序数と ω₁

前提: なし

このノートは、ラベルに使う順序数と、ラベルの上限に使う $`\omega_1`$ を説明する。使う事実は §5 の正則性と §6 の数え上げである。

## 1. 整列順序と順序数

**定義（整列順序）.** 集合 $`X`$ の上の全順序 $`\lt`$ が **整列順序** であるとは、$`X`$ の空でない部分集合がどれも最小元を持つことをいう。

**定義（無限降下列）.** $`x_0 \gt x_1 \gt x_2 \gt \cdots`$ となる列 $`(x_n)_{n \in \mathbb N}`$ を **無限降下列** と呼ぶ。

全順序が整列順序であることと、無限降下列が無いことは同値である。「無限降下列が無いなら整列順序」の向きには、選択公理の弱い形（従属選択）を使う。

| 順序 | 整列か | 理由 |
|---|---|---|
| $`(\mathbb N, \lt)`$ | はい | 空でない部分集合は最小元を持つ |
| $`(\mathbb Z, \lt)`$ | いいえ | $`0 \gt -1 \gt -2 \gt \cdots`$ |
| $`(\mathbb Q_{\ge 0}, \lt)`$ | いいえ | $`1 \gt 1/2 \gt 1/4 \gt \cdots`$ |

**定義（順序数）.** **順序数** は整列順序の型である。順序数 $`\alpha`$ は、それより小さい順序数の集合 $`\{\beta \mid \beta \lt \alpha\}`$ と同一視する。

小さい順に並べると次のようになる。

```math
0,\ 1,\ 2,\ \ldots,\ \omega,\ \omega+1,\ \omega+2,\ \ldots,\ \omega \cdot 2,\ \ldots,\ \omega^2,\ \ldots
```

- $`\omega`$ は自然数全体の型である。$`\omega = \{0, 1, 2, \ldots\}`$。
- 順序数の全体は $`\lt`$ で整列する。どの順序数の集まりにも最小元がある。

Lean では、順序数の型は `Ordinal.{0}` である。このリポジトリは `Por.Ord` という別名を付ける（[Por/Tuple.lean](../Por/Tuple.lean)）。$`\{\beta \mid \beta \lt \gamma\}`$ は `Set.Iio γ` である。

## 2. 後者と極限

**定義（後者）.** $`\alpha + 1`$ は $`\alpha`$ の次の順序数である。Lean では `Order.succ α` と書く。$`\alpha + 1`$ の形の順序数を **後者順序数** と呼ぶ。

**定義（極限順序数）.** 0 でも後者順序数でもない順序数を **極限順序数** と呼ぶ。

| 順序数 | 種類 |
|---|---|
| $`0`$ | どちらでもない |
| $`5`$、$`\omega+1`$、$`\omega \cdot 2 + 3`$ | 後者 |
| $`\omega`$、$`\omega \cdot 2`$、$`\omega^2`$ | 極限 |

**性質.** $`\alpha`$ が極限順序数で $`\beta \lt \alpha`$ なら、$`\beta + 1 \lt \alpha`$ である。したがって $`\beta`$ より上に、$`\alpha`$ より下の元が無限個ある。

この性質は [03 構造と Σ₁ 初等部分構造](03-sigma1-elementary.md) の例で使う。

## 3. 上限

**定義（上限）.** 順序数の集合 $`S`$ の **上限** $`\sup S`$ は、$`S`$ のすべての元以上である最小の順序数である。

- $`S`$ が最大元を持てば、$`\sup S`$ はその最大元である。空でない有限集合ならいつもそうである。空集合の上限は $`0`$ である。
- $`S`$ が最大元を持たなければ、$`\sup S`$ は $`S`$ に入らない。

| $`S`$ | $`\sup S`$ |
|---|---|
| $`\{2, 5, 3\}`$ | $`5`$ |
| $`\{0, 1, 2, \ldots\}`$ | $`\omega`$ |
| $`\{\omega, \omega+1, \omega+2, \ldots\}`$ | $`\omega \cdot 2`$ |

「すべての元より真に大きい」数が欲しいときは、$`\sup_{i} (y_i + 1)`$ を使う。$`y_i \lt y_i + 1 \le \sup_i (y_i + 1)`$ だからである。[08 閉包と鎖](08-closure-chain.md) の `witHeight` はこの形である。

Lean では、添字つきの上限は `⨆ i, f i`（`iSup`）、有限集合の上限は `Finset.sup` である。

## 4. 可算と ω₁

**定義（可算）.** 集合 $`X`$ が **可算** であるとは、$`X`$ が空であるか、全射 $`\mathbb N \to X`$ があることをいう。Lean では `Set.Countable` である。

**定義（可算順序数）.** 順序数 $`\alpha`$ が **可算** であるとは、$`\{\beta \mid \beta \lt \alpha\}`$ が可算であることをいう。

$`0, 1, \omega, \omega+1, \omega \cdot 2, \omega^2, \omega^\omega, \varepsilon_0`$ はどれも可算である。

**定義（ω₁）.** $`\omega_1`$ は最初の非可算順序数である。つまり、$`\omega_1`$ より小さい順序数はちょうど可算順序数である。

```math
\alpha \lt \omega_1 \iff \alpha \text{ は可算}
```

Lean では `ω₁` で、このリポジトリは `Por.Om` という別名を付ける（[Por/Omega1.lean](../Por/Omega1.lean)）。次の 3 つを使う。

| 名前 | 内容 |
|---|---|
| `om_pos` | $`0 \lt \omega_1`$ |
| `om_succ_lt` | $`\alpha \lt \omega_1 \implies \alpha + 1 \lt \omega_1`$ |
| `countable_Iio` | $`\gamma \lt \omega_1 \implies \{\beta \mid \beta \lt \gamma\}`$ は可算 |

`om_succ_lt` の理由：$`\{\beta \mid \beta \lt \alpha + 1\} = \{\beta \mid \beta \lt \alpha\} \cup \{\alpha\}`$ で、可算集合に 1 点を足しても可算である。Lean の証明は「$`\omega_1`$ は極限順序数である」ことから出している。

## 5. ω₁ の正則性

**定理（ω₁ の正則性）.** 各 $`n \in \mathbb N`$ について $`\alpha_n \lt \omega_1`$ なら、次が成り立つ。

```math
\sup_{n \in \mathbb N} \alpha_n \lt \omega_1
```

添字の集合は $`\mathbb N`$ でなくても、可算ならよい。

**証明.** $`\sigma := \sup_n \alpha_n`$ と置く。$`\beta \lt \sigma`$ なら、ある $`n`$ で $`\beta \lt \alpha_n`$ である。よって

```math
\{\beta \mid \beta \lt \sigma\} = \bigcup_{n} \{\beta \mid \beta \lt \alpha_n\}
```

である。右辺は可算集合の可算個の和である。$`\alpha_n = 0`$ の項は和に何も足さないので除く。残りの各 $`n`$ で全射 $`e_n : \mathbb N \to \alpha_n`$ を 1 つずつ選ぶと、$`(n, t) \mapsto e_n(t)`$ は $`\mathbb N \times \mathbb N`$ から和の上への全射になる。$`\mathbb N \times \mathbb N`$ は可算なので、和も可算である。よって $`\sigma`$ は可算で、$`\sigma \lt \omega_1`$ である。$`\square`$

- 全射 $`e_n`$ を可算個同時に選ぶところで、選択公理（可算選択）を使う。
- 添字が非可算なら成り立たない。例えば $`\sup_{\alpha \lt \omega_1} \alpha = \omega_1`$ である。

Lean では `Ordinal.iSup_lt_omega_one` である。添字の型は `Countable` のインスタンスを持つ必要がある。このリポジトリでは 2 か所で使う。

| 使う場所 | 添字の型 | 上限を取るもの |
|---|---|---|
| `next_lt`（[Por/Closure.lean](../Por/Closure.lean)） | `Form × List ℕ` | 証人の高さ |
| `lam_lt`（同上） | `ℕ` | 閉包の塔 |

## 6. 可算順序数の数え上げ

$`0 \lt \gamma \lt \omega_1`$ なら、$`\{\beta \mid \beta \lt \gamma\}`$ は空でなく可算なので、全射 $`e_\gamma : \mathbb N \to \gamma`$ がある。Lean ではそれを 1 つ選んで `enumBelow γ` と呼ぶ（`Classical.choose` を使う）。

**定理（`enumBelow_surj`）.** $`\gamma \lt \omega_1`$ かつ $`a \lt \gamma`$ なら、ある $`t \in \mathbb N`$ で $`e_\gamma(t) = a`$ である。

これを使うと、$`\gamma`$ より下の有限個のパラメータを、自然数の有限列で表せる。

**定義（`params`）.** 自然数の列 $`l = (l_0, l_1, \ldots)`$ に対し、$`\mathrm{params}_\gamma(l)(i) := e_\gamma(l_i)`$ とする（列の外は $`l_i := 0`$ と読む）。

**定理（`exists_params`）.** $`\gamma \lt \omega_1`$ で、$`p_0, \ldots, p_{k-1} \lt \gamma`$ なら、ある自然数の列 $`l`$ で、すべての $`i \lt k`$ について $`\mathrm{params}_\gamma(l)(i) = p_i`$ である。

**例.** $`\gamma = \omega + 1`$ とし、$`e_\gamma(0) = \omega`$、$`e_\gamma(t+1) = t`$ という数え上げが選ばれたとする。パラメータ $`(3, \omega, 0)`$ は $`l = (4, 0, 1)`$ で表される。

**なぜ要るか.** [08 閉包と鎖](08-closure-chain.md) では、$`\gamma`$ より下のパラメータを持つすべての論理式について上限を取る。パラメータを順序数の組のまま走らせる代わりに、自然数の列 $`l`$ を走らせる。すると添字の型が $`\gamma`$ に依らない可算型 `Form × List ℕ` になり、§5 の定理をそのまま使える。

## 7. このリポジトリでの使われ方

| 場所 | 使い方 |
|---|---|
| [README](../README.md)「関係 R」 | ラベルは順序数、順序は $`\lt`$ |
| [README](../README.md)「6 つの仮定の行き先」 | `hWF` は `Ordinal.lt_wf`、`hTrans` は `h₁.trans h₂` |
| [notes/01-design.md](../notes/01-design.md) §3.6、§4.7 | $`\omega_1`$、`enumBelow`、閉包点が $`\omega_1`$ より下にあること |
| [Por/Omega1.lean](../Por/Omega1.lean) | このノートの §4、§6 |
| [Por/Closure.lean](../Por/Closure.lean) | §5 の正則性（`next_lt`、`lam_lt`） |

## 8. Lean での対応

| 概念 | Lean | ファイル |
|---|---|---|
| 順序数の型 | `Por.Ord`（`Ordinal.{0}`） | [Por/Tuple.lean](../Por/Tuple.lean) |
| $`\lt`$ が整礎 | `Ordinal.lt_wf`、`wellFounded_lt` | Mathlib |
| 後者 | `Order.succ` | Mathlib |
| 上限 | `iSup`、`Finset.sup` | Mathlib |
| $`\omega_1`$ | `Por.Om`（`ω₁`） | [Por/Omega1.lean](../Por/Omega1.lean) |
| $`0 \lt \omega_1`$ | `om_pos` | 同上 |
| 後者で閉じる | `om_succ_lt` | 同上 |
| 可算順序数の下は可算 | `countable_Iio` | 同上 |
| 正則性 | `Ordinal.iSup_lt_omega_one` | Mathlib |
| 数え上げ | `enumBelow`、`enumBelow_surj` | [Por/Omega1.lean](../Por/Omega1.lean) |
| パラメータの符号 | `params`、`exists_params` | 同上 |

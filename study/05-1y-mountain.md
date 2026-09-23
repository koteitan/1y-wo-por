[← Back](README.md) | [English](en/05-1y-mountain.md) | [Japanese](05-1y-mountain.md)

# 1-Y 数列と山

前提

| ノート | ここで使う言葉 |
|---|---|
| [02 整礎関係と整礎再帰](02-well-founded.md) | 整礎、辞書式順序が整礎でないこと |

このノートは、1-Y 数列とその展開が Lean でどう定義されているかを説明する。定義は Phyrion 氏の形式化（[Phyrion1343/1Y-Well-Ordering-Lean](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean)）のもので、このリポジトリの `ZeroY/` と `OneY/` に移してある。このリポジトリは展開の定義を検査し直さない（[notes/01-design.md](../notes/01-design.md) §5 の 6）。

例の値は、このリポジトリの `OneY.Numeric.expand` などを Lean 4.33.1 の `#eval` で計算したものである（2026-09-23）。

## 1. 式

**定義（式）.** **式** は正の整数の有限列 $`s = (s_0, \ldots, s_{n-1})`$ で、空か、$`s_0 = 1`$ のものである（`ZeroY.Legal`、`ZeroY.Expr`）。種の列から作れる必要は無い。

- 列の番号は 0 から数える。$`i`$ 番目の項を「列 $`i`$」と呼ぶ。
- 種は $`(1, m)`$（$`m \ge 1`$）の形の式である。Lean では `ZeroY.Expr.seed n` $`= (1, n+1)`$ である。
- 式の順序は辞書式順序 $`\lt_{\mathrm{lex}}`$ である（`ZeroY.SeqLt`、`ZeroY.ExprLt`）。真の接頭辞は小さい。[02](02-well-founded.md) §1 のとおり、この順序は式全体の上では整礎でない。

## 2. 山の行 0

**定義（行 0 の親）.** 列 $`c`$ の行 0 の親は、$`p \lt c`$ かつ $`s_p \lt s_c`$ を満たす最大の $`p`$ である。無ければ親は無い。

Lean では `ofSequence s` がこの行である。「$`c`$ より前の列すべて」を祖先とする森 `linearForest` から、`select` で親を選ぶ。列 $`n`$ 以降は値 1 で埋め、親を持たない。

## 3. 上の行

行 $`r`$ の値 $`v_r`$ と親 $`\mathrm{par}_r`$ から、行 $`r+1`$ を作る。

**定義（差）.** $`c`$ が行 $`r`$ で親 $`p`$ を持てば $`v_{r+1}(c) := v_r(c) - v_r(p)`$、持たなければ $`v_{r+1}(c) := 0`$（`Row.difference`）。

**定義（行 r+1 の親）.** $`c`$ の行 $`r+1`$ の親は、行 $`r`$ での $`c`$ の祖先（$`\mathrm{par}_r(c)`$、$`\mathrm{par}_r(\mathrm{par}_r(c))`$、…）のうち、$`0 \lt v_{r+1}(p) \lt v_{r+1}(c)`$ を満たす最大の $`p`$ である（`select`、`restrictedParent`）。

値 0 の列は「その行に無い」と読む。行 $`r`$ の全体は `rows base r` である。

**定義（高さと頂上の値）.** 列 $`c`$ の **高さ** は、$`v_r(c) \gt 0`$ となる最大の $`r`$ である（`height`）。その行の値を **頂上の値** と呼ぶ（`topValue`）。値は行ごとに真に減るので、高さは有限である。

**例.** $`s = (1, 2, 4, 3)`$。表の「$`v \leftarrow p`$」は、値 $`v`$ で親が列 $`p`$ であることを表す。

| 行 | 列 0 | 列 1 | 列 2 | 列 3 |
|---|---|---|---|---|
| 2 | 0 | 0 | 1 | 0 |
| 1 | 0 | 1 | 2 ← 1 | 1 |
| 0 | 1 | 2 ← 0 | 4 ← 1 | 3 ← 1 |

- 行 0：列 3 の値 3 より小さい値を持つ最大の列は列 1（値 2）である。
- 行 1：列 3 の値は $`3 - 2 = 1`$。行 0 での祖先は列 1、列 0 である。行 1 の値は 1 と 0 で、どちらも「$`0 \lt v \lt 1`$」を満たさない。親は無い。
- 高さは左から 0, 1, 2, 1。頂上の値はどれも 1 である。

**定義（成分の根）.** 行 $`r`$ で、列 $`c`$ から親をたどって、親の無い列に着いたとき、その列を $`c`$ の行 $`r`$ での **根** と呼ぶ（`ParentForest.root`、`RowMountain.rootAt`）。上の例の行 1 では、列 2 の根は列 1 である。

## 4. 層

1-Y の山は、ここまでの山を 1 つの **層** として、層を積み重ねる。

**定義（抜き出し）.** 層 $`k`$ から層 $`k+1`$ を作る（`extract`）。

- 値：各列の頂上の値。
- 親の候補の森（`Pseudo.forest`）：高さ $`h \gt 0`$ の列 $`c`$ について、行 $`h - 1`$ での $`c`$ の祖先のうち、高さが $`h`$ か $`h - 1`$ である最大の列。高さ 0 の列には候補の親が無い。
- この森の中から、行 0 と同じ規則（値が正で、真に小さい、最大の祖先）で親を選ぶ（`select`）。

層 $`k`$ の全体は `layers a k` である。列の値は層ごとに減るので、`sequenceBound s` $`= \max(1, \max_i s_i)`$ 個の層で十分である（`sequence_layers_all_one`）。

**例.** $`s = (1, 3)`$。

| 層 0 | 列 0 | 列 1 |
|---|---|---|
| 行 1 | 0 | 2 |
| 行 0 | 1 | 3 ← 0 |

列 1 の高さは 1、頂上の値は 2 である。行 1 で、列 1 の祖先は列 0 だが、その値は 0 なので親にならない。

| 層 1 | 列 0 | 列 1 |
|---|---|---|
| 行 1 | 0 | 1 |
| 行 0 | 1 | 2 ← 0 |

層 1 の行 0 の値は頂上の値 $`(1, 2)`$ である。列 1 の候補の親は列 0（行 0 での祖先で、高さ $`0 = 1 - 1`$）である。値は $`1 \lt 2`$ なので、親は列 0 である。層 2 の値は $`(1, 1)`$ で、親は無い。

$`(1, 2, 4, 3)`$ では頂上の値がすべて 1 なので、層 1 以降に親は無い。

## 5. 悪い根

**定義（悪い根）.** 最後の列を $`x`$ とする。ある層 $`k`$、行 $`r`$ で、$`x`$ が親 $`p`$ を持ち、$`v(x) = v(p) + 1`$ となるとき、$`p`$ を **悪い根** と呼ぶ（`BadAt a k r x p`）。

- そのような $`(k, r)`$ は高々 1 つである（`rootAddress_unique`）。
- 行 0 で $`x`$ が親を持てば、悪い根はある。行 0 で親を持たなければ、悪い根は無い（`findBadRoot_none_iff`）。
- Lean の探索は `findBadRoot` で、結果は（層、行、列）の組 `RootAddress` である。

| 式 | 悪い根の（層、行、列） | 理由 |
|---|---|---|
| $`(1, 2, 3)`$ | $`(0, 0, 1)`$ | 行 0 で $`3 = 2 + 1`$ |
| $`(1, 2, 4)`$ | $`(0, 1, 1)`$ | 行 0 で $`4 \ne 2 + 1`$、行 1 で $`2 = 1 + 1`$ |
| $`(1, 3)`$ | $`(1, 0, 0)`$ | 層 0 では差が 2。層 1 の行 0 で $`2 = 1 + 1`$ |
| $`(1, 2, 4, 3)`$ | $`(0, 0, 1)`$ | 行 0 で $`3 = 2 + 1`$ |

## 6. 展開

**定義（展開 `expand s N`）.** $`N`$ はコピーの回数である。最後の列を $`x`$ とする。

- 悪い根が無いとき：最後の列を消す。$`s[N] = (s_0, \ldots, s_{x-1})`$。
- 悪い根 $`z`$ があるとき：長さ $`x + N \cdot (x - z)`$ の式を作る。列 $`z`$ から $`x - 1`$ までの区間（長さ $`x - z`$）を $`N`$ 回コピーする。ただし値をそのまま写すのではない。各層の山（親の森）を写し、そこから値を組み立て直す（`expandedMountain`、`reconstructedValues`）。

| 式 $`s`$ | $`N`$ | $`s[N]`$ |
|---|---|---|
| $`(1)`$ | 5 | $`()`$ |
| $`(1, 2)`$ | 3 | $`(1, 1, 1, 1)`$ |
| $`(1, 2, 3)`$ | 0 | $`(1, 2)`$ |
| $`(1, 2, 3)`$ | 1 | $`(1, 2, 2)`$ |
| $`(1, 2, 3)`$ | 2 | $`(1, 2, 2, 2)`$ |
| $`(1, 2, 2)`$ | 2 | $`(1, 2, 1, 2, 1, 2)`$ |
| $`(1, 2, 4)`$ | 2 | $`(1, 2, 3, 4)`$ |
| $`(1, 2, 4)`$ | 3 | $`(1, 2, 3, 4, 5)`$ |
| $`(1, 3)`$ | 2 | $`(1, 2, 4)`$ |
| $`(1, 3)`$ | 3 | $`(1, 2, 4, 8)`$ |
| $`(1, 2, 4, 3)`$ | 2 | $`(1, 2, 4, 2, 4, 2, 4)`$ |

$`(1, 3)`$ の例では、コピーが層 1 で起きる。そのため値は単純な繰り返しにならない。

## 7. 1 段の展開と最終定理

**定義（1 段の展開）.** $`t`$ が $`s`$ の自明でない 1 段の展開であるとは、ある $`N`$ で $`s[N] = t`$ で、$`t \ne s`$ であることをいう（`ZeroY.ExpansionStep expand t s`）。

- 空の式は、展開しても空のままである（`expand_empty`）。だから空の式から 1 段の展開は無い。
- 1 段の展開は辞書式順序を下げる（`exprLt_of_step`）。しかし辞書式順序は整礎でないので、これだけでは停止は出ない。

このリポジトリの最終定理（[README](../README.md)「最終定理 4 つ」）は次のとおりである。

1. `expansion_wellFounded`：1 段の展開の関係は整礎である。
2. `generated_strictWellOrder`：種から届く式の集合は、辞書式順序で整列する。
3. `descendants_strictWellOrder`：どの式でも、そこから届く式の集合は、辞書式順序で整列する。
4. `expansion_chain_reaches_empty`：コピーの回数をどう選んでも、展開を続けると空の式に着く。

2〜4 は 1 から組合せの議論だけで出る（`OneY/Dynamics.lean`）。1 の証明が [06](06-combinatorial-layer.md) 以降の話題である。

## 8. このリポジトリでの使われ方

| 場所 | 使い方 |
|---|---|
| [README](../README.md)「記号」「最終定理 4 つ」 | 式、$`s[N]`$、$`\to^{*}`$、4 つの定理 |
| [notes/01-design.md](../notes/01-design.md) §2.1 | `expand`、`exprDiagram` |
| [notes/02-port.md](../notes/02-port.md) | 山と展開のモジュールの一覧 |
| `ZeroY/`、`OneY/` | このノートの定義のすべて |

## 9. Lean での対応

| 概念 | Lean | ファイル |
|---|---|---|
| 式 | `ZeroY.Expr`、`ZeroY.Legal` | [ZeroY/Syntax.lean](../ZeroY/Syntax.lean) |
| 種 | `ZeroY.Expr.seed` | 同上 |
| 辞書式順序 | `ZeroY.SeqLt`、`ZeroY.ExprLt` | 同上 |
| 親の森 | `OneY.ParentForest`、`root`、`Ancestor` | [OneY/Forest.lean](../OneY/Forest.lean) |
| 行、差、次の行 | `Row`、`Row.difference`、`Row.next`、`select`、`rows` | [OneY/Numeric.lean](../OneY/Numeric.lean) |
| 高さ、頂上の値 | `height`、`topValue` | 同上 |
| 行 0 | `ofSequence`、`linearForest` | [OneY/NumericGeometry.lean](../OneY/NumericGeometry.lean) |
| 1 つの層の山 | `mountain`、`RowMountain`、`rootAt` | 同上、[OneY/RootGeometry.lean](../OneY/RootGeometry.lean) |
| 候補の親の森 | `Pseudo.parent`、`Pseudo.forest` | [OneY/Pseudo.lean](../OneY/Pseudo.lean) |
| 層 | `extract`、`layers`、`sequenceBound` | [OneY/Extraction.lean](../OneY/Extraction.lean) |
| 悪い根 | `BadAt` | [OneY/BadRoot.lean](../OneY/BadRoot.lean) |
| 悪い根の探索 | `RootAddress`、`findBadRoot`、`findBadRoot_none_iff` | [OneY/RootSearch.lean](../OneY/RootSearch.lean) |
| 展開 | `expand`、`expandValues`、`expandedMountain` | [OneY/Expansion.lean](../OneY/Expansion.lean) |
| 1 段の展開 | `ZeroY.ExpansionStep` | [ZeroY/Transport.lean](../ZeroY/Transport.lean) |
| 展開と辞書式順序、最終定理 2〜4 の本体 | `exprLt_of_step`、`generated_strictWellOrder` など | [OneY/Dynamics.lean](../OneY/Dynamics.lean) |

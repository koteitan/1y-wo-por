[← Back](README.md) | [English](en/06-combinatorial-layer.md) | [Japanese](06-combinatorial-layer.md)

# Phyrion 氏の組合せの層

前提

| ノート | ここで使う言葉 |
|---|---|
| [02 整礎関係と整礎再帰](02-well-founded.md) | 整礎、`Acc`、ラベルによる停止（§6） |
| [05 1-Y 数列と山](05-1y-mountain.md) | 式、層、行、親、成分の根、悪い根、展開 |

このノートは、Phyrion 氏の証明のうち、ラベルの意味を使わない部分（組合せの層）を説明する。この層は、ラベルの型 $`\alpha`$、順序 $`\lt`$、定義域 $`D`$、関係 $`R`$ を引数に取り、それらについての 6 つの仮定から展開の整礎性を示す。このリポジトリは、この層を変えずに使う。

## 1. 図式

**定義（アトム）.** **アトム** は 4 つの自然数の組 $`e = (k, r, p, q)`$ で、層 $`k`$、根 $`r`$、親 $`p`$、子 $`q`$ を表す（`Atom`）。サイズ $`n`$ で **妥当** とは $`r \le p \lt q \lt n`$ のことである（`Atom.Valid`）。

**定義（図式）.** **図式** は、サイズ $`n`$ と、妥当なアトムの有限リストの組である（`Diagram`）。$`n`$ は列の数である。

**式の図式.** 式 $`s`$ の図式 `exprDiagram s` は、すべての層、すべての行の親子の辺を 1 つずつアトムにしたものである（`rowAtom`、`mountainDiagram`、`sequenceDiagram`）。層 $`k`$、行 $`r`$ で列 $`c`$ の親が $`p`$ なら、アトム

```math
(k,\ \mathrm{root}_{k,r}(c),\ p,\ c)
```

を入れる。$`\mathrm{root}_{k,r}(c)`$ は層 $`k`$、行 $`r`$ での $`c`$ の成分の根である。

| 式 | アトム $`(k, r, p, q)`$ |
|---|---|
| $`(1, 2, 2)`$ | $`(0,0,0,1)`$、$`(0,0,0,2)`$ |
| $`(1, 2, 4)`$ | $`(0,0,0,1)`$、$`(0,0,1,2)`$、$`(0,1,1,2)`$ |
| $`(1, 3)`$ | $`(0,0,0,1)`$、$`(1,0,0,1)`$ |

$`(1, 2, 4)`$ の 3 つめのアトムは、行 1 の辺 $`2 \to 1`$ である。行 1 で列 1 は親を持たないので、根は列 1 自身である。

## 2. 表現

$`(\alpha, \lt, D, R)`$ を固定する。$`R(k, \eta, a, b)`$ は 4 引数の関係で、「層 $`k`$、根の添字 $`\eta`$ で、$`a`$ は $`b`$ へ安定している」と読む。

**定義（表現）.** 関数 $`f : \mathbb N \to \alpha`$ が図式 $`G`$（サイズ $`n`$）の **表現** であるとは、次の 3 つが成り立つことをいう（`Representation`）。

1. $`i \lt n`$ なら $`D(f(i))`$。
2. $`i \lt j \lt n`$ なら $`f(i) \lt f(j)`$。
3. $`G`$ の各アトム $`(k, r, p, q)`$ で $`R(k, f(r), f(p), f(q))`$（`Atom.Holds`）。

$`f(i)`$ を列 $`i`$ の **ラベル** と呼ぶ。

**例.** $`(1, 2, 4)`$ の図式の表現は、次を満たす $`f`$ である。

```math
f(0) \lt f(1) \lt f(2), \quad R(0, f(0), f(0), f(1)), \quad R(0, f(0), f(1), f(2)), \quad R(0, f(1), f(1), f(2))
```

## 3. 上端への要求

**定義（上端のアトム）.** **上端のアトム** は $`d = (k, r, p)`$ で、サイズ $`n`$ で妥当とは $`r \le p \lt n`$ のことである（`TopAtom`、`TopAtom.Valid`）。上端 $`\beta \in \alpha`$ について成り立つとは、$`R(k, f(r), f(p), \beta)`$ のことである（`TopAtom.Holds`）。

上端のアトムは、図式の外にある点 $`\beta`$ への辺である。展開では、古い最後の列のラベルが $`\beta`$ になる。

**定義（上界）.** $`i \lt n`$ ならいつも $`f(i) \lt \beta`$ のとき、$`f`$ は $`\beta`$ で **上から押さえられる** という（`Bounded`）。

## 4. 有限反映

**定義（許される要求）.** 層 $`K`$、切れ目 $`\mathrm{cut}`$、添字 $`\theta`$ について、上端のアトム $`d = (k_d, r_d, p_d)`$ が **許される** とは、次のどちらかのことである（`Admissible`）。

- $`k_d \lt K`$（低い層）。
- $`k_d = K`$ かつ $`r_d \lt \mathrm{cut}`$ かつ $`f(r_d) \lt \theta`$（同じ層で、根が切れ目より前にあり、根のラベルが $`\theta`$ より小さい）。

**定義（有限反映 `FiniteReflection`）.** 次が成り立つことをいう。仮定は次の 8 つである。

1. $`G`$ は図式で、サイズを $`n`$ とし、$`\mathrm{cut} \lt n`$ である。
2. $`f`$ は $`G`$ の表現である。
3. $`D(\beta)`$ である。
4. $`f`$ は $`\beta`$ で上から押さえられる。
5. 制御関係 $`R(K, \theta, f(\mathrm{cut}), \beta)`$ が成り立つ。
6. 要求のリスト $`\mathrm{needs}`$ の各要素は妥当である。
7. 各要素は許される。
8. 各要素は上端 $`\beta`$ について成り立つ。

このとき、次を満たす $`g`$ がある。

1. $`g`$ は $`G`$ の表現である。
2. $`i \lt \mathrm{cut}`$ なら $`g(i) = f(i)`$。
3. $`g`$ は $`f(\mathrm{cut})`$ で上から押さえられる。
4. 各要求は上端 $`f(\mathrm{cut})`$ について成り立つ。

**意味.** 切れ目より左のラベルは動かさない。切れ目から右のラベルを付け替えて、全部を $`f(\mathrm{cut})`$ より下に入れる。辺の条件と、上端への要求（上端を $`\beta`$ から $`f(\mathrm{cut})`$ に替えたもの）は保つ。[04](04-patterns-of-resemblance.md) §3 の有限反映の形そのものである。

## 5. 6 つの仮定

入口の定理 `OneY.RootIndexed.actual_expansion_wellFounded` の仮定は次の 6 つである。

| 名前 | 内容 |
|---|---|
| `hWF` | $`\lt`$ は整礎 |
| `hTrans` | $`a \lt b`$ かつ $`b \lt c`$ なら $`a \lt c`$ |
| `hStrict` | $`R(k, \eta, a, b)`$ なら $`a \lt b`$ |
| `hWeak` | $`\eta' \lt \eta`$ かつ $`R(k, \eta, p, c)`$ なら $`R(k, \eta', p, c)`$ |
| `reflection` | `FiniteReflection lt D R` |
| `initial` | どの式 $`s`$ にも、`exprDiagram s` の表現がある |

結論は `WellFounded (ZeroY.ExpansionStep expand)` である。

## 6. 末尾のラベルによる降下

**定義（末尾の表現）.** $`G`$ のサイズ $`n`$ が正で、$`G`$ の表現 $`f`$ で $`f(n-1) = a`$ となるものがあるとき、`LastRepresentation G a` と書く。

**定理（`expand_lastRepresentation_lower`）.** `exprDiagram s` に末尾のラベル $`\beta`$ の表現があり、$`s[N]`$ が空でないとする。このとき、ある $`b \lt \beta`$ で、`exprDiagram (s[N])` に末尾のラベル $`b`$ の表現がある。

**証明の概略.** $`x`$ を $`s`$ の最後の列とする。

1. 悪い根が無いとき：$`s[N]`$ は $`s`$ から最後の列を消したものである。新しい図式は古い図式の接頭辞である（`sequenceDiagram_take_isPrefix`）。同じ $`f`$ が表現で、新しい末尾のラベル $`f(x-1)`$ は $`f(x) = \beta`$ より小さい（`proper_prefix_lowers_last_label`）。
2. 悪い根 $`y`$（層 $`K`$、行 $`d`$）があるとき：
   - 図式を番号 $`i = 0, 1, \ldots, N`$ で並べる（`copyDiagram`）。$`i`$ 番目の図式のサイズは $`x + i \cdot (x - y)`$ である。
   - $`i = 0`$ 番目の図式はサイズ $`x`$ で、古い図式の接頭辞である（最後の列 $`x`$ を含まない。`copyDiagram_zero_isPrefix`）。$`f`$ はその表現で、$`\beta = f(x)`$ で上から押さえられる。
   - 悪い根の辺は $`R(K, f(\rho), f(y), f(x))`$ を与える。$`\rho`$ は、層 $`K`$、行 $`d`$ での $`x`$ の成分の根である。これが最初の制御関係になる（`initial_control_holds`）。
   - $`i`$ 番目の図式から $`i + 1`$ 番目の図式を作るときに、有限反映を 1 回使う（`exists_bounded_representation_splice`）。切れ目は $`i`$ 番目のブロックの始まり $`\mathrm{cut} = y + i \cdot (x - y)`$ である（`blockCut`）。
   - $`i`$ 番目の図式のサイズを $`m`$、そのラベルを $`f_i`$ とする。反映で得た $`g`$ は、切れ目より左で $`f_i`$ と等しく、全体が $`f_i(\mathrm{cut})`$ より下にある。新しい図式の列は $`m + (m - \mathrm{cut})`$ 個である。列 $`c \lt m`$ には $`g(c)`$ を、列 $`c \ge m`$ には古いラベル $`f_i(\mathrm{cut} + c - m)`$ を付ける（`spliceLabel`）。つまり右端に $`f_i(\mathrm{cut}), \ldots, f_i(m-1)`$ がそのまま並ぶ。これで 1 ブロック長い図式の表現ができる。
   - $`N`$ 回くり返すと、$`s[N]`$ の図式の表現で $`\beta`$ で上から押さえられるものができる（`blockScheme_bounded_representations`、`copied_diagrams_bounded`）。
   - 新しい末尾のラベルは $`\beta`$ より小さい（`last_label_of_bounded_representation`）。$`\square`$

**6 つの仮定の使いどころ.**

| 仮定 | 使いどころ |
|---|---|
| `hWF` | 末尾のラベルについての帰納法 |
| `hTrans` | 継ぎ合わせたラベルの順序と上界（`spliceLabel_ordered`、`spliceLabel_bounded`） |
| `hStrict` | 制御関係から $`f(\mathrm{cut}) \lt \beta`$ を得る |
| `hWeak` | 根が前のブロックへ移る辺（`CopyCase`）と、仮想の要求（`virtual_demands_from_templates`） |
| `reflection` | ブロックごとに 1 回 |
| `initial` | 帰納法の出発点 |

**整礎性.** $`\beta`$ についての整礎帰納法で、「`exprDiagram s` に末尾のラベル $`\beta`$ の表現があれば、$`s`$ は到達可能」を示す（`expansion_accessible_of_lastRepresentation`）。これは [02](02-well-founded.md) §6 の形である。空の式は 1 段の展開を持たないので、別に扱う（`expansionStep_empty_accessible`）。`initial` から、どの式にも最初のラベルが付く。よって展開の関係は整礎である。

## 7. 意味の層に残る仕事

組合せの層は、有限反映がなぜ成り立つかを問わない。6 つの仮定を満たす $`(\alpha, \lt, D, R)`$ を与えるのが **意味の層** の仕事である。

- Phyrion 氏の意味の層：$`D`$ は許容順序数に当たる条件（`Adequate`）、$`R`$ は構成的宇宙 $`L`$ の上の真理の塔の $`\Sigma_1`$ 保存である。
- このリポジトリの意味の層：$`\alpha = \mathrm{Ord}`$、$`D = \mathrm{True}`$、$`R`$ は [07 関係 R](07-relation-r.md) の関係である。証明は [09 義務の証明](09-obligations.md) にある。

## 8. このリポジトリでの使われ方

| 場所 | 使い方 |
|---|---|
| [README](../README.md)「証明の形」「6 つの仮定の行き先」 | 二層の構成と、6 つの仮定の表 |
| [notes/01-design.md](../notes/01-design.md) §2 | 入口の定理、インターフェース、義務の表、コアでの使われ方 |
| [notes/02-port.md](../notes/02-port.md) | 組合せの層の移植 |
| [Por/Model.lean](../Por/Model.lean)、[Por/WellOrdering.lean](../Por/WellOrdering.lean) | 6 つの仮定を入口の定理に渡す |

## 9. Lean での対応

ファイルはどれも `OneY/RootIndexed/` にある。

| 概念 | Lean | ファイル |
|---|---|---|
| アトム、図式 | `Atom`、`Atom.Valid`、`Diagram` | [Representation.lean](../OneY/RootIndexed/Representation.lean) |
| 上端のアトム | `TopAtom`、`TopAtom.Valid`、`TopAtom.Holds` | 同上 |
| 表現、上界 | `Representation`、`Bounded` | 同上 |
| 許される要求、有限反映 | `Admissible`、`FiniteReflection` | 同上 |
| 1 ブロックの継ぎ合わせ | `spliceLabel`、`exists_bounded_representation_splice` | 同上 |
| ブロックのくり返し | `BlockScheme`、`blockScheme_bounded_representations` | 同上 |
| 末尾の表現 | `LastRepresentation`、`last_label_of_bounded_representation`、`proper_prefix_lowers_last_label` | 同上 |
| 山の図式 | `rowAtom`、`mountainDiagram` | [Diagram.lean](../OneY/RootIndexed/Diagram.lean) |
| 式の図式 | `sequenceDiagram` | [Prefix.lean](../OneY/RootIndexed/Prefix.lean) |
| 実際のブロックの構成 | `actualBlockScheme`、`copied_diagrams_bounded` | [ActualScheme.lean](../OneY/RootIndexed/ActualScheme.lean) |
| 入口の定理 | `exprDiagram`、`expand_lastRepresentation_lower`、`expansion_accessible_of_lastRepresentation`、`actual_expansion_wellFounded` | [ExpansionWellFounded.lean](../OneY/RootIndexed/ExpansionWellFounded.lean) |

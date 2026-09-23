[← Back](README.md) | [English](en/07-relation-r.md) | [Japanese](07-relation-r.md)

# 関係 R

前提

| ノート | ここで使う言葉 |
|---|---|
| [02 整礎関係と整礎再帰](02-well-founded.md) | 辞書式順序、整礎再帰、ガードつきの再帰 |
| [03 構造と Σ₁ 初等部分構造](03-sigma1-elementary.md) | $`\Sigma_1`$ 論理式の 5 つ組、`Sat`、見えるビット、`ElemL` |
| [04 Patterns of resemblance](04-patterns-of-resemblance.md) | 上端述語を原子記号にする考え方 |
| [06 Phyrion 氏の組合せの層](06-combinatorial-layer.md) | $`R(k, \eta, a, b)`$ の役割、`hStrict`、`hWeak` |

このノートは、このリポジトリのラベルの関係 $`R`$ の定義と、定義から直接出る性質を説明する。Lean のファイルは [Por/Relation.lean](../Por/Relation.lean) である。

## 1. 記号

- $`\mathrm{Ord}`$：順序数全体（Lean では `Ord` $`=`$ `Ordinal.{0}`）。
- $`\mathbb N \times \mathrm{Ord}`$ の辞書式順序：$`(j, \xi) \prec (k, \eta) \iff j \lt k \lor (j = k \land \xi \lt \eta)`$。
- $`R(k, \eta, a, b)`$：層 $`k \in \mathbb N`$、根の添字 $`\eta`$、下の点 $`a`$、上の点 $`b`$。

## 2. 言語

記号は 3 種類である。

| 記号 | 項数 | 意味（高さ $`\gamma`$ の構造で） |
|---|---|---|
| $`\lt`$ | 2 | 順序数の大小 |
| $`\mathrm{Rel}_j`$（$`j \in \mathbb N`$） | 3 | $`\mathrm{Rel}_j(x, y, z) :\iff R(j, x, y, z)`$ |
| $`\mathrm{Top}_j`$（$`j \in \mathbb N`$） | 2 | $`\mathrm{Top}_j(\xi, x) :\iff R(j, \xi, x, \gamma)`$ |

$`\mathrm{Rel}_j`$ は点どうしの関係、$`\mathrm{Top}_j`$ は点から上端 $`\gamma`$ への関係である。$`\gamma`$ 自身は領域に無い。

Lean では、$`\mathrm{Rel}`$ の解釈の型が `RelF`、$`\mathrm{Top}`$ の解釈の型が `TopF` である。真の解釈は `relR` と `topR γ` である。

## 3. 段 (k, η) の構造

**定義.** 高さ $`\gamma`$、段 $`(k, \eta)`$ の構造を次で定める。領域は $`\{x \mid x \lt \gamma\}`$ である。

```math
\mathfrak A^{\gamma}_{k,\eta} = \bigl(\gamma;\ \lt,\ (\mathrm{Rel}_j)_{j \in \mathbb N},\ (\mathrm{Top}_j)_{j \lt k},\ (\mathrm{Top}_{k,\xi})_{\xi \lt \eta}\bigr)
```

- $`\mathrm{Rel}_j`$ はすべての層 $`j`$ で持つ。
- $`\mathrm{Top}_j`$（$`j \lt k`$）は **対角の上端述語** である。第 1 引数は普通の変数でよい。
- $`\mathrm{Top}_{k,\xi}(x) :\iff R(k, \xi, x, \gamma)`$ は **名前付きの上端述語** である。名前 $`\xi \lt \eta`$ ごとに 1 項の記号が 1 つある。
- $`j \gt k`$ の上端述語は無い。

**Lean での表し方.** 名前付きの $`\mathrm{Top}_{k,\xi}(x)`$ は、2 項の $`\mathrm{Top}_k(p_s, x)`$ で、第 1 引数がパラメータの位置 $`s`$ にあるものとして表す。論理式と一緒に位置の集合 $`S`$ を与え、$`s \in S`$ なら $`s \lt r`$ かつ $`p_s \lt \eta`$ を要求する。見えるビットは `allowL k S` である（[03](03-sigma1-elementary.md) §8）。

```math
\mathrm{allowL}\ k\ S\ j\ a \iff j \lt k \ \lor\ (j = k \land a \in S)
```

**例.** 段 $`(2, \omega)`$ で、次の論理式を考える。

```math
\exists y\ \bigl(p_0 \lt y \land \mathrm{Top}_1(y, y) \land \mathrm{Top}_{2, p_0}(y)\bigr)
```

- $`\mathrm{Top}_1(y, y)`$ は対角（$`1 \lt 2`$）なので、第 1 引数が証人 $`y`$ でもよい。
- $`\mathrm{Top}_{2, p_0}(y)`$ は名前付きで、位置 0 が $`S`$ に入る。そのためには $`p_0 \lt \omega`$ が要る。
- $`\mathrm{Top}_2(y, y)`$ や $`\mathrm{Top}_3(p_0, y)`$ は、この段では書けない（読んでも偽になる）。

## 4. 定義

**定義（R）.**

```math
R(k, \eta, a, b) \iff \eta \le a \ \land\ a \lt b \ \land\ \mathfrak A^{a}_{k,\eta} \preccurlyeq_{\Sigma_1} \mathfrak A^{b}_{k,\eta}
```

ここで $`\mathfrak A^{a}_{k,\eta} \preccurlyeq_{\Sigma_1} \mathfrak A^{b}_{k,\eta}`$ は、段 $`(k, \eta)`$ のすべての $`\Sigma_1`$ 論理式 $`\varphi`$ と、すべてのパラメータ $`\vec p \lt a`$（名前は $`\lt \eta`$）について、次が成り立つことである。

```math
\mathfrak A^{a}_{k,\eta} \models \varphi(\vec p) \iff \mathfrak A^{b}_{k,\eta} \models \varphi(\vec p)
```

Lean では `Elem k η a b := ElemL relR (topR a) (topR b) k η a b` である。2 つの構造で、上端述語は別のもの（$`a`$ への $`R`$ と $`b`$ への $`R`$）である。

条件 $`\eta \le a`$ について。辺も要求も「根 $`\le`$ 親」なので、増加するラベル付けではいつも満たされる。

## 5. 再帰

右辺は $`R`$ 自身を読む。鍵 $`(b, k, \eta)`$ の辞書式順序 $`\lhd`$（[02](02-well-founded.md) §3）で整礎再帰をする。すべての $`a`$ について一度に定義する。

**右辺が読む R.** 3 種類だけで、どれも鍵が小さい。

| 読むもの | 鍵 | 小さい理由 |
|---|---|---|
| $`\mathrm{Rel}_j(x, y, z)`$ | $`(z, j, x)`$ | 点は高さ（$`a`$ か $`b`$）より下なので $`z \lt b`$ |
| $`\mathfrak A^{a}`$ の上端述語 $`\mathrm{Top}_j(\xi, x)`$ | $`(a, j, \xi)`$ | $`a \lt b`$ |
| $`\mathfrak A^{b}`$ の見える上端述語 | $`(b, j, \xi)`$ | $`j \lt k`$、または $`j = k`$ で $`\xi \lt \eta`$ |

**Lean の再帰（`stepF`）.** 鍵 $`t = (b, k, \eta)`$ で、$`R(k, \eta, \cdot, b)`$ を満たす $`a`$ の集合を返す。3 つの解釈には、鍵が小さいことの証明をガードとして付ける（[02](02-well-founded.md) §5）。

| 段の解釈 | 式 |
|---|---|
| $`\mathrm{Rel}^{\mathrm{st}}_j(x, y, z)`$ | $`z \lt b \land R(j, x, y, z)`$ |
| $`\mathrm{Top}^{\mathrm{st},a}_j(\xi, x)`$ | $`a \lt b \land R(j, \xi, x, a)`$ |
| $`\mathrm{Top}^{\mathrm{st},b}_j(\xi, x)`$ | $`(j, \xi) \prec (k, \eta) \land R(j, \xi, x, b)`$ |

そして次のように定義する。

```lean
noncomputable def RF : Idx → Ord → Prop := ilt_wf.fix stepF
noncomputable def R (k : ℕ) (η a b : Ord) : Prop := RF (b, k, η) a
```

`RF_eq` は `WellFounded.fix_eq` から出る。ガードつきの等式 `RF t = stepF t (fun t' _ => RF t')` である。

## 6. ガードを外す：R_iff

**定理（`elem_stage`）.** $`a \lt b`$ なら、段の解釈での $`\Sigma_1`$ 初等性と、真の解釈での $`\Sigma_1`$ 初等性（`Elem k η a b`）は同値である。

**証明.** 段 $`(k, \eta)`$ の論理式が読むビットでは、ガードがいつも真であることを示す。

1. $`\mathrm{Rel}`$ のビット：点は、パラメータ（$`\lt a`$）か証人（$`\lt`$ 高さ $`\le b`$）である。よって $`z \lt b`$（`cat_bound`）。
2. 高さ $`a`$ の上端述語：ガードは $`a \lt b`$ で、仮定そのものである。
3. 高さ $`b`$ の見える上端述語：`allowL k S` から、$`j \lt k`$ か、$`j = k`$ で位置が $`S`$ にある。後者なら値は $`p_s \lt \eta`$ である。どちらでも $`(j, \cdot) \prec (k, \eta)`$。

見えないビットは、どちらの解釈でも偽である。よって原子図式が等しく（`diagM_congr`）、真偽も等しい（`sat_congr`）。$`\square`$

**定理（`R_iff`）.**

```math
R(k, \eta, a, b) \iff \eta \le a \land a \lt b \land \mathrm{Elem}(k, \eta, a, b)
```

**証明.** `RF_eq` で 1 段展開し、$`a \lt b`$ の下で `elem_stage` を使う。$`\square`$

## 7. 定義から直接出る性質

**定理（`R_lt`、仮定 `hStrict`）.** $`R(k, \eta, a, b)`$ なら $`a \lt b`$。`R_iff` の第 2 項である。

**定理（`R_index_le`）.** $`R(k, \eta, a, b)`$ なら $`\eta \le a`$。`R_iff` の第 1 項である。

**定理（`R_weaken`、仮定 `hWeak`）.** $`\eta' \le \eta`$ かつ $`R(k, \eta, p, c)`$ なら $`R(k, \eta', p, c)`$。

**証明.** $`\eta' \le \eta \le p`$ と $`p \lt c`$ は明らか。段 $`(k, \eta')`$ の論理式では名前が $`\lt \eta' \le \eta`$ なので、段 $`(k, \eta)`$ の論理式でもある。2 つの段は見える記号を同じに解釈する。よって $`(k, \eta)`$ での一致から $`(k, \eta')`$ での一致が出る。Lean では、名前の条件 $`p_s \lt \eta'`$ から $`p_s \lt \eta`$ を作るだけである。$`\square`$

コアへは厳密版 `fun h hR => R_weaken h.le hR` を渡す。

**性質（見える上端述語の一致）.** $`R(k, \eta, a, b)`$ で、$`\xi, x \lt a`$ とする。$`j \lt k`$、または $`j = k`$ かつ $`\xi \lt \eta`$ なら、次が成り立つ。

```math
R(j, \xi, x, a) \iff R(j, \xi, x, b)
```

**理由.** 量化子の無い論理式 $`\mathrm{Top}_j(p_0, p_1)`$ を、パラメータ $`(\xi, x)`$ で使う（$`j = k`$ なら位置 0 を $`S`$ に入れる）。高さ $`a`$ では左辺、高さ $`b`$ では右辺を意味する。

**性質（下の点は極限順序数）.** $`R(k, \eta, a, b)`$ なら、$`a`$ は 0 でない極限順序数である。

**理由.** [03](03-sigma1-elementary.md) §5 の例と同じである。

- $`a = 0`$ のとき：$`\exists y\ \neg(y \lt y)`$（$`n = 1`$、$`\mathit{bb} = 1`$、$`r = 0`$、行列はすべての原子図式）は、高さ $`b`$ で真、高さ 0 で偽である。
- $`a = \gamma + 1`$ のとき：パラメータ $`\gamma \lt a`$ の $`\exists y\ (\gamma \lt y)`$ は、高さ $`b`$ で真（$`y = \gamma + 1 \lt b`$）、高さ $`a`$ で偽である。

どちらも $`\mathrm{Elem}`$ に反する。

## 8. 使わない性質

次の性質は成り立つと考えられるが、Lean では示していない。組合せの層は使わない（[notes/01-design.md](../notes/01-design.md) §4.11）。

- 推移性：$`R(k, \eta, a, b) \land R(k, \eta, b, c) \implies R(k, \eta, a, c)`$。
- 添字についての単調性：$`(k, \eta) \preceq (k', \eta')`$、$`\eta \le a`$、$`R(k', \eta', a, b)`$ なら $`R(k, \eta, a, b)`$。
- 局所性：上端が $`\le \delta`$ の $`R`$ は、$`\delta + 1`$ より下の再帰だけで決まる。

## 9. このリポジトリでの使われ方

| 場所 | 使い方 |
|---|---|
| [README](../README.md)「関係 R」 | 定義の式と、再帰の 3 つの読み方 |
| [README](../README.md)「6 つの仮定の行き先」 | `hStrict` は `Por.R_lt`、`hWeak` は `Por.R_weaken` |
| [notes/01-design.md](../notes/01-design.md) §3.3〜§3.8、§4.1〜§4.4 | 定義、再帰、`R_iff`、O3、O4 |
| [Por/Relation.lean](../Por/Relation.lean) | このノートのすべて |

## 10. Lean での対応

| 概念 | Lean | ファイル |
|---|---|---|
| 鍵と順序 | `Idx`、`ilt`、`ilt_wf` | [Por/Relation.lean](../Por/Relation.lean) |
| 再帰の 1 段 | `stepF` | 同上 |
| 再帰 | `RF`、`RF_eq` | 同上 |
| 関係 | `R` | 同上 |
| 真の解釈 | `relR`、`topR` | 同上 |
| 真の解釈での初等性 | `Elem` | 同上 |
| ガードを外す | `elem_stage` | 同上 |
| 定義の式 | `R_iff` | 同上 |
| O3 | `R_lt`、`R_index_le` | 同上 |
| O4 | `R_weaken` | 同上 |
| 段の見えるビット | `allowL` | [Por/Formula.lean](../Por/Formula.lean) |
| 段つきの初等性 | `ElemL` | 同上 |

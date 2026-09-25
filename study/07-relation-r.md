[← Back](README.md) | [English](en/07-relation-r.md) | [Japanese](07-relation-r.md)

# 関係 R

前提

| ノート | ここで使う言葉 |
|---|---|
| [02 整礎関係と整礎再帰](02-well-founded.md) | 辞書式順序、整礎再帰、ガードつきの再帰 |
| [03 構造と Σ₁ 初等部分構造](03-sigma1-elementary.md) | 高さ、点、証人、$`\Sigma_1`$ 論理式の 5 つ組と行列、上端、上端述語（§7）、位置、見えるビット $`\mathrm{allow}_{k,S}`$ と 2 つの構造の比べ方（§8） |
| [04 Patterns of resemblance](04-patterns-of-resemblance.md) | 上端述語を原子記号にする考え方 |
| [06 Phyrion 氏の組合せの層](06-combinatorial-layer.md) | 層、辺、要求、表現、$`R(k, \eta, a, b)`$ の役割、6 つの仮定のうち狭義性と弱化 |

このノートは、このリポジトリのラベルの関係 $`R`$ の定義と、定義から直接出る性質を説明する。

## 1. 記号

- $`\mathrm{Ord}`$：順序数全体。
- $`\mathbb N \times \mathrm{Ord}`$ の辞書式順序：$`(j, \xi) \prec (k, \eta) \iff j \lt k \lor (j = k \land \xi \lt \eta)`$。
- $`R(k, \eta, a, b)`$：層 $`k \in \mathbb N`$、根のラベル（[06](06-combinatorial-layer.md) §2）$`\eta \in \mathrm{Ord}`$、下の点 $`a \in \mathrm{Ord}`$、上の点 $`b \in \mathrm{Ord}`$。$`R`$ は §4 で定義する。§2、§3 では、$`R`$ を記号の解釈に使う。§5 で述べるとおり、この使い方は循環しない。

## 2. 言語

記号は 3 種類である。

| 記号 | 引数の数 | 意味（高さ $`\gamma`$ の構造で） |
|---|---|---|
| $`\lt`$ | 2 | 順序数の大小 |
| $`\mathrm{Rel}_j`$（$`j \in \mathbb N`$） | 3 | $`\mathrm{Rel}_j(x, y, z) :\iff R(j, x, y, z)`$ |
| $`\mathrm{Top}_j`$（$`j \in \mathbb N`$） | 2 | $`\mathrm{Top}_j(\xi, x) :\iff R(j, \xi, x, \gamma)`$ |

$`\mathrm{Rel}_j`$ は点どうしの関係、$`\mathrm{Top}_j`$ は点から上端 $`\gamma`$ への関係（上端述語）である（[03](03-sigma1-elementary.md) §7）。$`\gamma`$ 自身は領域に無い。

表の解釈を、§5 の段の解釈と区別して **真の解釈** と呼ぶ。上端述語の真の解釈は、高さ $`\gamma`$ ごとに違う。

## 3. 段 (k, η) の構造

**定義（段）.** 組 $`(k, \eta) \in \mathbb N \times \mathrm{Ord}`$ を **段** と呼ぶ。$`k`$ は層、$`\eta`$ は根のラベルである。段は、構造がどの上端述語を持つかを決める。段の大小は §1 の辞書式順序 $`\prec`$ で比べる。「1 段の展開」（[05](05-1y-mountain.md) §7）の「1 段」は展開 1 回のことで、この段とは関係ない。

**定義（段 (k, η) の構造）.** 順序数 $`\gamma`$ を高さとし、段 $`(k, \eta)`$ の構造を次で定める。領域は $`\{x \mid x \lt \gamma\}`$ である。

```math
\mathfrak A^{\gamma}_{k,\eta} = \bigl(\gamma;\ \lt,\ (\mathrm{Rel}_j)_{j \in \mathbb N},\ (\mathrm{Top}_j)_{j \lt k},\ (\mathrm{Top}_{k,\xi})_{\xi \lt \eta}\bigr)
```

- $`\mathrm{Rel}_j`$ はすべての層 $`j`$ で持つ。
- $`\mathrm{Top}_j`$（$`j \lt k`$）は **対角の上端述語** である。「対角」とは、根のラベル $`\xi`$ を記号の中に固定せず、第 1 引数として受け取ることをいう。そのため第 1 引数は普通の変数（パラメータでも証人でもよい）でよい。
- $`\mathrm{Top}_{k,\xi}(x) :\iff R(k, \xi, x, \gamma)`$ は **名前付きの上端述語** である。$`\xi \lt \eta`$ ごとに 1 引数の記号が 1 つある。$`\xi`$ をこの記号の **名前** と呼ぶ。
- $`j \gt k`$ の上端述語は無い。

**段 $`(k, \eta)`$ の論理式** とは、この構造の言語の $`\Sigma_1`$ 論理式である。

**位置による表し方.** 名前付きの $`\mathrm{Top}_{k,\xi}(x)`$ は、2 引数の $`\mathrm{Top}_k(p_s, x)`$ で、第 1 引数がパラメータの位置 $`s`$（[03](03-sigma1-elementary.md) §8）にあるものとして表す。論理式と一緒に位置の集合 $`S \subseteq \mathbb N`$ を与え、$`s \in S`$ なら $`s \lt r`$ かつ $`p_s \lt \eta`$ を要求する。$`r`$ はパラメータの数（[03](03-sigma1-elementary.md) §7 の 5 つ組の $`r`$）である。見えるビットは $`\mathrm{allow}_{k,S}`$ で決まる（[03](03-sigma1-elementary.md) §8）。

```math
\mathrm{allow}_{k,S}(j, s) \iff j \lt k \ \lor\ (j = k \land s \in S)
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

ここで $`\mathfrak A^{a}_{k,\eta} \preccurlyeq_{\Sigma_1} \mathfrak A^{b}_{k,\eta}`$ は、段 $`(k, \eta)`$ のすべての $`\Sigma_1`$ 論理式 $`\varphi`$ と、すべてのパラメータ $`\vec p \lt a`$（名前にする位置 $`s \in S`$（§3）では $`p_s \lt \eta`$）について、次が成り立つことである。

```math
\mathfrak A^{a}_{k,\eta} \models \varphi(\vec p) \iff \mathfrak A^{b}_{k,\eta} \models \varphi(\vec p)
```

この比較（真の解釈で比べる）を $`\mathrm{Elem}(k, \eta, a, b)`$ と書く。2 つの構造で、上端述語は別のもの（$`a`$ への $`R`$ と $`b`$ への $`R`$）である（[03](03-sigma1-elementary.md) §8 の違い 1）。

条件 $`\eta \le a`$ について。アトムも要求も「根 $`\le`$ 親」なので（[06](06-combinatorial-layer.md) §1、§3）、表現（ラベルが増加する）ではいつも満たされる。

## 5. 再帰

右辺は $`R`$ 自身を読む。鍵 $`(b, k, \eta)`$ の辞書式順序 $`\lhd`$（[02](02-well-founded.md) §3）で整礎再帰をする。すべての $`a`$ について一度に定義する。

**右辺が読む R.** 3 種類だけで、どれも鍵が小さい。表の $`\mathfrak A^{a}`$、$`\mathfrak A^{b}`$ は $`\mathfrak A^{a}_{k,\eta}`$、$`\mathfrak A^{b}_{k,\eta}`$ の略である。

| 読むもの | 鍵 | 小さい理由 |
|---|---|---|
| $`\mathrm{Rel}_j(x, y, z)`$ | $`(z, j, x)`$ | 点は高さ（$`a`$ か $`b`$）より下なので $`z \lt b`$ |
| $`\mathfrak A^{a}`$ の上端述語 $`\mathrm{Top}_j(\xi, x)`$ | $`(a, j, \xi)`$ | $`a \lt b`$ |
| $`\mathfrak A^{b}`$ の見える上端述語 | $`(b, j, \xi)`$ | $`j \lt k`$、または $`j = k`$ で $`\xi \lt \eta`$ |

**ガードつきの再帰.** 鍵 $`t = (b, k, \eta)`$ での値は、$`R(k, \eta, \cdot, b)`$ を満たす $`a`$ の集合である。これを次の **段の解釈** で定める。記号の右肩の $`\mathrm{st}`$ は、段の解釈であることを表す印である。3 つの解釈には、鍵が小さいという条件をガードとして付ける（[02](02-well-founded.md) §5）。

| 段の解釈 | 式 |
|---|---|
| $`\mathrm{Rel}^{\mathrm{st}}_j(x, y, z)`$ | $`z \lt b \land R(j, x, y, z)`$ |
| $`\mathrm{Top}^{\mathrm{st},a}_j(\xi, x)`$ | $`a \lt b \land R(j, \xi, x, a)`$ |
| $`\mathrm{Top}^{\mathrm{st},b}_j(\xi, x)`$ | $`(j, \xi) \prec (k, \eta) \land R(j, \xi, x, b)`$ |

段の解釈で比べた $`\Sigma_1`$ 初等性を $`\mathrm{Elem}^{\mathrm{st}}(k, \eta, a, b)`$ と書く。段の解釈は小さい鍵での $`R`$ だけを読むので、[02](02-well-founded.md) §4 の整礎再帰で $`R`$ が決まる。定義の等式は、次のガードつきの等式である。

```math
R(k, \eta, a, b) \iff \eta \le a \land a \lt b \land \mathrm{Elem}^{\mathrm{st}}(k, \eta, a, b)
```

## 6. ガードを外す

**補題（ガードを外す）.** $`a \lt b`$ なら、$`\mathrm{Elem}^{\mathrm{st}}(k, \eta, a, b) \iff \mathrm{Elem}(k, \eta, a, b)`$ である。つまり、段の解釈での $`\Sigma_1`$ 初等性と、真の解釈での $`\Sigma_1`$ 初等性は同値である。

**証明.** 段 $`(k, \eta)`$ の論理式が読むビットでは、ガードがいつも真であることを示す。

1. $`\mathrm{Rel}`$ のビット：点は、パラメータ（$`\lt a`$）か証人（$`\lt`$ 高さ $`\le b`$）である。よって $`z \lt b`$。
2. 高さ $`a`$ の上端述語：ガードは $`a \lt b`$ で、仮定そのものである。
3. 高さ $`b`$ の見える上端述語：$`\mathrm{allow}_{k,S}`$ から、$`j \lt k`$ か、$`j = k`$ で位置が $`S`$ にある。後者なら値は $`p_s \lt \eta`$ である。どちらでも $`(j, \cdot) \prec (k, \eta)`$。

見えないビットは、どちらの解釈でも偽である。よって [03](03-sigma1-elementary.md) §8 の補題 1 から、原子図式が等しく、真偽も等しい。$`\square`$

**定理（定義の式）.**

```math
R(k, \eta, a, b) \iff \eta \le a \land a \lt b \land \mathrm{Elem}(k, \eta, a, b)
```

**証明.** §5 のガードつきの等式に、$`a \lt b`$ の下で補題（ガードを外す）を使う。$`\square`$

## 7. 定義から直接出る性質

**定理（狭義性）.** $`R(k, \eta, a, b)`$ なら $`a \lt b`$。定義の式の右辺の 2 番目の条件である。これが [06](06-combinatorial-layer.md) §5 の狭義性である。

**定理（根のラベルの下界）.** $`R(k, \eta, a, b)`$ なら $`\eta \le a`$。定義の式の右辺の 1 番目の条件である。

**定理（弱化）.** $`\eta' \le \eta`$ かつ $`R(k, \eta, p, c)`$ なら $`R(k, \eta', p, c)`$。

**証明.** $`\eta' \le \eta \le p`$ と $`p \lt c`$ は明らか。段 $`(k, \eta')`$ の論理式では名前が $`\lt \eta' \le \eta`$ なので、段 $`(k, \eta)`$ の論理式でもある。2 つの段は見える記号を同じに解釈する。よって $`(k, \eta)`$ での一致から $`(k, \eta')`$ での一致が出る。位置による表し方（§3）では、名前の条件 $`p_s \lt \eta'`$ から $`p_s \lt \eta`$ が出る。$`\square`$

[06](06-combinatorial-layer.md) §5 の弱化は $`\eta' \lt \eta`$ の場合だけを求める。$`\eta' \lt \eta`$ なら $`\eta' \le \eta`$ なので、この定理から出る。

**性質（見える上端述語の一致）.** $`R(k, \eta, a, b)`$ で、$`\xi, x \lt a`$ とする。$`j \lt k`$、または $`j = k`$ かつ $`\xi \lt \eta`$ なら、次が成り立つ。

```math
R(j, \xi, x, a) \iff R(j, \xi, x, b)
```

**理由.** 量化子の無い論理式 $`\mathrm{Top}_j(p_0, p_1)`$ を、パラメータ $`(\xi, x)`$ で使う（$`j = k`$ なら位置 0 を $`S`$ に入れる）。高さ $`a`$ では左辺、高さ $`b`$ では右辺を意味する。証明はこの性質を使わない。使うのは、似た形の [09](09-obligations.md) §4.1 の定理（上端述語の絶対性）である。これは Good な点と $`\omega_1`$ の間での上端述語の一致である。

**性質（下の点は極限順序数）.** $`R(k, \eta, a, b)`$ なら、$`a`$ は 0 でない極限順序数である。

**理由.** [03](03-sigma1-elementary.md) §5 の例と同じである。

- $`a = 0`$ のとき：$`\exists y\ \neg(y \lt y)`$（$`m = 0`$、$`n = 1`$、$`\mathit{bb} = 1`$、$`r = 0`$、行列は「$`[v_0 \lt v_0] = 0`$」である完全な原子図式の集合）は、高さ $`b`$ で真、高さ 0 で偽である。
- $`a = \gamma + 1`$ のとき：パラメータ $`\gamma \lt a`$ の $`\exists y\ (\gamma \lt y)`$ は、高さ $`b`$ で真（$`y = \gamma + 1 \lt b`$）、高さ $`a`$ で偽である。

どちらも $`\mathrm{Elem}`$ に反する。組合せの層はこの性質を使わない。

## 8. 使わない性質

次の性質は成り立つと考えられるが、ここでは証明しない。組合せの層は使わない（[notes/01-design.md](../notes/01-design.md) §4.11）。

- 推移性：$`R(k, \eta, a, b) \land R(k, \eta, b, c) \implies R(k, \eta, a, c)`$。
- 段についての単調性：$`(k, \eta) \preceq (k', \eta')`$（$`\prec`$ または等しい）、$`\eta \le a`$、$`R(k', \eta', a, b)`$ なら $`R(k, \eta, a, b)`$。
- 局所性：上端が $`\le \delta`$ の $`R`$ は、$`\delta + 1`$ より下の再帰だけで決まる。

## 9. このリポジトリでの使われ方

| 場所 | 使い方 |
|---|---|
| [README](../README.md)「関係 R」 | 定義の式と、再帰の 3 つの読み方 |
| [README](../README.md)「6 つの仮定の行き先」 | 狭義性と弱化は §7 の 2 つの定理から出る |
| [notes/01-design.md](../notes/01-design.md) §3.3〜§3.8、§4.1〜§4.4 | 定義、再帰、定義の式、O3、O4 |

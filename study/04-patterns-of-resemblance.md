[← Back](README.md) | [English](en/04-patterns-of-resemblance.md) | [Japanese](04-patterns-of-resemblance.md)

# Patterns of resemblance

前提

| ノート | ここで使う言葉 |
|---|---|
| [01 順序数と ω₁](01-ordinals.md) | 順序数、極限順序数 |
| [02 整礎関係と整礎再帰](02-well-founded.md) | 整礎再帰、ガードつきの再帰 |
| [03 構造と Σ₁ 初等部分構造](03-sigma1-elementary.md) | 構造 $`(\gamma; \ldots)`$、$`\Sigma_1`$ 論理式、$`\preccurlyeq_{\Sigma_1}`$ |

このノートは、Carlson の patterns of resemblance の考え方を説明する。次に、[bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern) が BMS でそれをどう使ったかを述べる。最後に、1-Y でそのままでは足りない理由と、このリポジトリの変更点を述べる。

## 1. 自分自身を言語に持つ関係

**定義（Carlson の ≤₁）.** 順序数の上の関係 $`\le_1`$ を次の式で定める。

```math
\alpha \le_1 \beta \iff \alpha \le \beta \ \land\ (\alpha; \le, \le_1) \preccurlyeq_{\Sigma_1} (\beta; \le, \le_1)
```

$`\alpha \lt_1 \beta`$ は $`\alpha \lt \beta \land \alpha \le_1 \beta`$ のことである。

**読み方.** 「$`\alpha`$ より下の順序数の形は、$`\beta`$ より下まで広げても、$`\Sigma_1`$ 論理式では見分けられない」。ここで形とは、大小関係と、関係 $`\le_1`$ 自身である。

右辺は左辺の $`\le_1`$ を使う。循環に見えるが、$`\beta`$ についての整礎再帰で定義できる。

- 構造 $`(\beta; \le, \le_1)`$ の領域は $`\{x \mid x \lt \beta\}`$ である。そこで読む $`\le_1`$ は、$`x, y \lt \beta`$ の $`x \le_1 y`$ だけである。
- $`x \le_1 y`$ の真偽は、鍵 $`y \lt \beta`$ の段階で決まっている。
- 構造 $`(\alpha; \ldots)`$ も同じで、$`\alpha \le \beta`$ である。

Carlson はこれを $`\le_1, \ldots, \le_N`$（$`\Sigma_1, \ldots, \Sigma_N`$ の初等性）に広げた構造を調べた。

```math
\mathcal R_N = (\mathrm{Ord}; \le, \le_1, \ldots, \le_N)
```

文献：T. J. Carlson, Elementary patterns of resemblance, Annals of Pure and Applied Logic 108 (2001), 19–77。

## 2. 小さい例

**例 1.** 自然数 $`n \lt \beta`$ について、$`n \le_1 \beta`$ ではない。

- $`n \ge 1`$ のとき：パラメータ $`n - 1`$ の $`\exists x\ (n - 1 \lt x)`$ は、$`\beta`$ で真（$`x = n`$）、$`n`$ で偽である。
- $`n = 0`$ のとき：$`\exists x\ (x \le x)`$ は、$`\beta`$ で真、空の構造 $`0`$ で偽である。

同じ理由で、後者順序数 $`\gamma + 1`$ も、それより大きい順序数と $`\le_1`$ の関係にない。

**例 2.** $`\omega \lt_1 \omega + 1`$ である。

例 1 から、$`\omega + 1`$ より下の異なる 2 点は $`\le_1`$ の関係にない。自然数どうしは例 1 で、残りは $`\omega`$ 自身だけだからである。したがって $`(\omega; \le, \le_1)`$ と $`(\omega + 1; \le, \le_1)`$ では、$`x \le_1 y`$ は $`x = y`$ と同じである。すると比べるのは順序だけの構造 $`(\omega; \le)`$ と $`(\omega + 1; \le)`$ で、$`\omega`$ は極限なので [03](03-sigma1-elementary.md) §5 の例から成り立つ。

**例 3.** $`\omega \le_1 \omega + 2`$ ではない。$`\exists x\ \exists y\ (x \lt y \land x \le_1 y)`$ は、$`\omega + 2`$ で真（例 2 の $`x = \omega`$、$`y = \omega + 1`$）、$`\omega`$ で偽（例 1）だからである。

以上から $`\{\beta \mid \omega \le_1 \beta\} = \{\omega, \omega + 1\}`$ である。

順序だけの言語では、$`\omega`$ より大きいどの $`\beta`$ でも $`(\omega; \le) \preccurlyeq_{\Sigma_1} (\beta; \le)`$ だった。$`\le_1`$ 自身を言語に入れたので、関係が細かくなった。

## 3. 停止性の証明での使い方

展開の停止性の証明では、列ごとに順序数のラベルを付け、展開でラベルが下がることを示す（[02](02-well-founded.md) §6）。そこで要る性質は **有限反映** である。

**有限反映の形.** $`\alpha \lt_1 \beta`$ とする。$`\alpha`$ より下の点 $`\vec p`$ と、$`\beta`$ より下の点 $`\vec y`$ が、有限個の原子式の条件 $`\psi(\vec p, \vec y)`$ を満たすとする。すると、$`\alpha`$ より下の点 $`\vec y'`$ で、同じ条件 $`\psi(\vec p, \vec y')`$ を満たすものがある。

**理由.** $`\exists \vec y\ \psi(\vec p, \vec y)`$ は $`\Sigma_1`$ 論理式で、$`(\beta; \ldots)`$ で真である。$`\Sigma_1`$ 初等性から $`(\alpha; \ldots)`$ でも真である。

展開では、古い列のラベルを $`\vec y`$ として、この形を使う。$`\psi`$ に「親子の辺のラベルが関係 $`\le_1`$ などを満たす」と書いておけば、新しいラベル $`\vec y'`$ も同じ辺の条件を満たす。しかも $`\vec y'`$ は $`\alpha`$ より下にあり、古いラベルより小さい。

**bms-elem-pattern での使い方.** [bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern) は、BMS の停止性を $`\mathcal R_N`$ で示した。行 $`k`$ の親子の辺のラベルの関係を $`\lt_{k+1}`$ にする。有限反映には $`\Sigma_n`$ の段、連続性や共終性の補題を使う。$`\mathcal R_N`$ の定義と例は、同リポジトリのノート [proof/pss/03-patterns.md](https://github.com/koteitan/bms-elem-pattern/blob/main/proof/pss/03-patterns.md) にある。

## 4. 1-Y で足りないもの

1-Y の組合せの層（[06](06-combinatorial-layer.md)）が要求するラベルの関係は、4 つの引数を持つ。

```math
R(k, \eta, a, b) \quad (k \in \mathbb N,\ \eta, a, b \in \mathrm{Ord})
```

「層 $`k`$、根の添字 $`\eta`$ で、$`a`$ は $`b`$ へ安定している」と読む。$`\eta`$ は辺の成分の根のラベルで、順序数である。このため 2 つの問題が起きる。

**問題 1：段の添字が 2 次元で超限である.** 段 $`(k, \eta)`$ は $`\mathbb N \times \mathrm{Ord}`$ を辞書式に動く。ラベルが可算なら、段は $`\omega \times \omega_1`$ の形に並ぶ。$`\mathcal R_N`$ の段 $`\Sigma_1, \ldots, \Sigma_N`$ は有限個で、自然数で数える。超限の $`\eta`$ を段の番号にできない。

**問題 2：上端への要求.** 有限反映は「上端 $`\beta`$ への関係 $`R(j, v, w, \beta)`$」も運ぶ必要がある（[06](06-combinatorial-layer.md) §4 の `needs`）。$`\beta`$ は構造 $`(\beta; \ldots)`$ の元ではない。$`R`$ の定義を展開して書くと $`\Sigma_1`$ にならない。

## 5. このリポジトリの変更点

[notes/01-design.md](../notes/01-design.md) §3.8 のとおり、次のように変えた。

1. **段はすべて $`\Sigma_1`$ にする.** 段の強さは、量化子の複雑さではなく、言語にある記号で決める。
2. **上端述語を原子記号にする.** 高さ $`\gamma`$ の構造は、記号 $`\mathrm{Top}_j(\xi, x)`$ を「$`R(j, \xi, x, \gamma)`$」と解釈して持つ。上端への要求は原子式になる。
3. **段 $`(k, \eta)`$ で見える記号を決める.** 層 $`j \lt k`$ の上端述語は全部見える。層 $`k`$ の上端述語は、名前 $`\xi \lt \eta`$ のものだけ見える。$`(k, \eta)`$ が大きいほど、見える記号が増え、関係は強くなる。
4. **内部の関係はすべての層で持つ.** $`\mathrm{Rel}_j(x, y, z) :\iff R(j, x, y, z)`$ をすべての $`j`$ について持つ。
5. **再帰の鍵を $`(b, k, \eta)`$ にする.** 上端 $`b`$ を一番外に置く（[02](02-well-founded.md) §3）。

こうしてできた関係 $`R`$ は、Carlson の $`\mathcal R_N`$ そのものではない。$`\mathcal R_N`$ と同じだとは主張しない。定義は [07 関係 R](07-relation-r.md) で述べる。

| | $`\mathcal R_N`$（bms-elem-pattern） | このリポジトリの $`R`$ |
|---|---|---|
| 段 | $`j = 1, \ldots, N`$ | $`(k, \eta) \in \mathbb N \times \mathrm{Ord}`$ |
| 段の強さ | $`\Sigma_j`$ の量化子 | 見える上端述語の範囲 |
| 論理式 | $`\Sigma_1, \ldots, \Sigma_N`$ | $`\Sigma_1`$ だけ |
| 上端との関係 | 連続性・共終性の補題 | 原子記号 $`\mathrm{Top}_j`$ |
| 再帰の鍵 | 上端 $`\beta`$ | $`(b, k, \eta)`$ の辞書式順序 |

## 6. このリポジトリでの使われ方

| 場所 | 使い方 |
|---|---|
| [README](../README.md)「証明の形」 | bms-elem-pattern の 1-Y 版であること、段の添字が $`\omega \times \omega_1`$ になること |
| [notes/01-design.md](../notes/01-design.md) §1、§3.8 | 設計の理由 |
| [notes/01-design.md](../notes/01-design.md) §6.3 | bms-elem-pattern から持ってきたもの |
| [Por/Relation.lean](../Por/Relation.lean) の先頭 | 再帰の形の出どころ（bms-elem-pattern の `stage`、`RFix` など） |

## 7. Lean での対応

$`\le_1`$ そのものは、このリポジトリの Lean には無い。対応するのは次のものである。

| 概念 | Lean | ファイル |
|---|---|---|
| 関係 $`R`$ | `Por.R` | [Por/Relation.lean](../Por/Relation.lean) |
| 再帰の鍵 | `Idx`、`ilt` | 同上 |
| 段の見える記号 | `allowL` | [Por/Formula.lean](../Por/Formula.lean) |
| 上端述語の解釈 | `topR γ` | [Por/Relation.lean](../Por/Relation.lean) |
| 内部の関係の解釈 | `relR` | 同上 |

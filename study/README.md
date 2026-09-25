[← Back](../README.md) | [English](en/README.md) | [Japanese](README.md)

# study/

このリポジトリを読むための背景ノート。証明が既知として使う数学（順序数、整礎再帰、モデル論）と、証明の 2 つの層（Phyrion 氏の組合せの層と、このリポジトリの意味の層）を、定義と小さい例から書き起こす。

書き方は [rule.md](rule.md) に定める。

## 目次

| ノート | 内容 | このリポジトリでの対応箇所 |
|---|---|---|
| [01 順序数と ω₁](01-ordinals.md) | 整列順序、後者と極限、上限、可算、$`\omega_1`$ の正則性、可算順序数の数え上げ | README「関係 R」「6 つの仮定の行き先」、notes/01-design.md §3.6、§4.7 |
| [02 整礎関係と整礎再帰](02-well-founded.md) | 整礎関係、到達可能、整礎帰納法、辞書式積、整礎再帰、ガードつきの再帰、ラベルによる停止 | README「関係 R」、notes/01-design.md §3.1、§4.1 |
| [03 構造と Σ₁ 初等部分構造](03-sigma1-elementary.md) | 構造、$`\Sigma_1`$ 論理式、原子図式、$`\preccurlyeq_{\Sigma_1}`$、Tarski–Vaught 判定法、$`\Sigma_1`$ 論理式の標準形、見えるビット | README「関係 R」、notes/01-design.md §3.2〜§3.4 |
| [04 Patterns of resemblance](04-patterns-of-resemblance.md) | Carlson の $`\le_1`$、小さい例、有限反映の形、bms-elem-pattern、1-Y で足りないもの | README「証明の形」、notes/01-design.md §1、§3.8、§6.3 |
| [05 1-Y 数列と山](05-1y-mountain.md) | 式、山の行、差と親、高さ、層、悪い根、展開の例 | README「記号」「最終定理 4 つ」、notes/01-design.md §2.1 |
| [06 Phyrion 氏の組合せの層](06-combinatorial-layer.md) | 図式、表現、上端への要求、有限反映、6 つの仮定、末尾のラベルによる降下 | README「証明の形」「6 つの仮定の行き先」、notes/01-design.md §2 |
| [07 関係 R](07-relation-r.md) | 段 $`(k, \eta)`$ の構造、$`R`$ の定義、（上端、層、根のラベル）の再帰、定義の式、狭義性、弱化 | README「関係 R」、notes/01-design.md §3.3〜§3.8、§4.1〜§4.4 |
| [08 ω₁ より下の閉包と鎖](08-closure-chain.md) | Good、証人の高さ、next、λ、λ(γ) が Good であること、鎖 | README「6 つの仮定の行き先」、notes/01-design.md §3.6、§4.7 |
| [09 義務の証明](09-obligations.md) | O1〜O7、有限反映、上端述語の絶対性、鎖の 2 点の関係、すべての図式の表現、最終定理 | README「6 つの仮定の行き先」、notes/01-design.md §2.3、§4 |

## 読む順

```mermaid
flowchart TB
  N01["01 順序数と ω₁"] --> N02["02 整礎再帰"]
  N01 --> N03["03 Σ₁ 初等部分構造"]
  N02 --> N04["04 Patterns of resemblance"]
  N03 --> N04
  N02 --> N05["05 1-Y 数列と山"]
  N05 --> N06["06 組合せの層"]
  N04 --> N07["07 関係 R"]
  N06 --> N07
  N07 --> N08["08 閉包と鎖"]
  N08 --> N09["09 義務の証明"]
  N06 --> N09
```

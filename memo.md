# MEMO — 1y-wo-por

## 方針

Phyrion 氏の証明は二層に分かれる。

- 組合せの層（`OneY/`、`ZeroY/`）。抽象的なインターフェース `FiniteReflection lt D R` だけを
  仮定して、展開で末尾のラベルが下がることを示す。
- 意味の層（`Concrete/OneYTruth`）。ラベルは `Adequate` な可算順序数（許容順序数に当たる）、
  関係 `R(k, η, a, b)` は構成的宇宙 L の上の混合真理の塔の Σ₁ 保存で与える。

このリポジトリは、意味の層を patterns of resemblance に置き換える。可算順序数の上に
`ω × ω₁` の辞書式順序による再帰で関係を定義し、Σ₁ 初等性から有限反映を出す。
bms-elem-pattern が BMS でしたことの 1-Y 版である。

## 守ること

- 検証は `leanman check -C <このリポジトリ>`、`leanman build -C <このリポジトリ>`。
- 緑を確認してから commit する。push はユーザーの指示を待つ。
- `vendor/bms`（YesMetaZFC）はライセンスが無い。読んでよいが、複製も翻案もしない。
- Phyrion 氏の Apache-2.0 のコードを移植するときは、`LICENSE` を保持し、`NOTICE` に出どころと
  変更点を書く。

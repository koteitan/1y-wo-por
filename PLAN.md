# PLAN — 1y-wo-por

1-Y 数列システムの整列性（展開関係の整礎性、標準形の整列性）を、許容順序数を使わずに
patterns of resemblance で再証明する。

## 方針

Phyrion 氏の証明は二層に分かれる。

- 組合せの層（`OneY/`、`ZeroY/`）。抽象的なインターフェース `FiniteReflection lt D R` だけを
  仮定して、展開で末尾のラベルが下がることを示す。
- 意味の層（`Concrete/OneYTruth`）。ラベルは `Adequate` な可算順序数（許容順序数に当たる）、
  関係 `R(k, η, a, b)` は構成的宇宙 L の上の混合真理の塔の Σ₁ 保存で与える。

このリポジトリは、意味の層を patterns of resemblance に置き換える。可算順序数の上に
`ω × ω₁` の辞書式順序による再帰で関係を定義し、Σ₁ 初等性から有限反映を出す。
bms-elem-pattern が BMS でしたことの 1-Y 版である。

## 手順

| # | 手順 | 状態 |
|---|---|---|
| 1 | 意味の層が組合せの層に渡している義務を正確に抜き出す | 済（`notes/01-design.md` §2） |
| 2 | patterns of resemblance による設計と、全義務の証明（`notes/01-design.md`） | 済。Lean でも全義務が緑（`Por/Model.lean`） |
| 3 | 組合せの層の移植計画（`notes/02-port.md`） | 済 |
| 4 | Lean: patterns の関係と有限反映（`Por/Model.lean`。後でファイルに分ける） | 済 |
| 5 | Lean: 組合せの層の移植。ライセンスの無い BMS 部分は自前で書き直す | 未 |
| 6 | Lean: 両者をつなぎ、最終定理を得る | 未 |
| 7 | 文書、公理の監査 | 未 |

## 守ること

- 検証は `leanman check -C ~/proofs/1y-wo-por`、`leanman build -C ~/proofs/1y-wo-por`。
- 緑を確認してから commit する。push はユーザーの指示を待つ。
- `vendor/bms`（YesMetaZFC）はライセンスが無い。読んでよいが、複製も翻案もしない。
- Phyrion 氏の Apache-2.0 のコードを移植するときは、`LICENSE` を保持し、`NOTICE` に出どころと
  変更点を書く。

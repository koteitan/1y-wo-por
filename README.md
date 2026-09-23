[English](README-en.md) | [Japanese](README.md)

# 1y-wo-por：patterns of resemblance による 1-Y の整礎性

1-Y 数列システムの展開が整礎であることを、Lean 4 で証明したリポジトリである。

証明は Phyrion 氏の証明（[Phyrion1343/1Y-Well-Ordering-Lean](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean)）に基づく。その証明の組合せの部分はそのまま使う。意味の部分だけを、順序数の上に直接定義した関係に取り替えた。この関係は patterns of resemblance の考え方で作る。構成的宇宙 $`L`$ も許容順序数も使わない。

- Lean 4.33.1、Mathlib v4.33.1。
- `sorry` は無い。新しい公理も無い。公理は `propext`、`Classical.choice`、`Quot.sound` だけである。

## 何を証明したか

### 記号

- 式は、正の整数の有限列で、空か、または最初の項が 1 のものである（`ZeroY.Expr`）。種の列が生成したものである必要は無い。
- $`s[N]`$ は、式 $`s`$ をコピーの回数 $`N`$ で 1-Y 展開したものである（`OneY.Numeric.expand s N`）。
- $`s \to^{*} t`$ は、$`s`$ から 0 回以上の展開で $`t`$ に届くことである。各段の $`N`$ は自由に選べる。
- $`\lt_{\mathrm{lex}}`$ は式の辞書式順序である。真の接頭辞は小さい方に入る。
- 狭義の整列順序とは、整礎で、推移的で、三分律を満たす関係である（`Por.StrictWellOrder`）。

### 最終定理 4 つ

最終定理は [Por/WellOrdering.lean](Por/WellOrdering.lean) にある。名前空間は `Por` である。

1. `expansion_wellFounded`：自明でない 1 段の展開の関係は整礎である。つまり、次の形の無限列は無い。

```math
s_0,\ s_1,\ s_2,\ \ldots \qquad s_{n+1} = s_n[N_n] \ne s_n \quad (n \in \mathbb N)
```

2. `generated_strictWellOrder`：標準の種 $`(1,m)`$ から生成される式の集合 $`G`$ は、$`\lt_{\mathrm{lex}}`$ で狭義に整列する。

```math
G = \{\, s \mid \exists m \ge 1,\ (1,m) \to^{*} s \,\}
```

3. `descendants_strictWellOrder`：どの式 $`s`$ についても、その子孫の集合 $`\mathrm{Desc}(s)`$ は $`\lt_{\mathrm{lex}}`$ で狭義に整列する。

```math
\mathrm{Desc}(s) = \{\, t \mid s \to^{*} t \,\}
```

4. `expansion_chain_reaches_empty`：コピーの回数をどう選んでも、展開の列はいつか空の列に着く。

```math
\bigl(\forall n\ \exists N,\ c_{n+1} = c_n[N]\bigr) \implies \exists n,\ c_n = ()
```

1 番目が中心である。2〜4 番目は、Phyrion 氏の組合せの層が 1 番目から導く。

## 証明の形

Phyrion 氏の証明は二層に分かれる。

- 組合せの層（`ZeroY/`、`OneY/`）。1-Y 数列の山を有限の図式にし、各列に順序数のラベルを付ける。展開したあとの図式にも、末尾のラベルがもっと小さいラベル付けがあることを示す。この層は、ラベルの型 $`\alpha`$、順序 $`\lt`$、定義域 $`D`$、関係 $`R(k,\eta,a,b)`$ と、それらについての 6 つの仮定だけを使う。入口の定理は `OneY.RootIndexed.actual_expansion_wellFounded` である。
- 意味の層。6 つの仮定を満たす $`(\alpha, \lt, D, R)`$ を与える。Phyrion 氏の意味の層では、$`D`$ は許容順序数に当たる条件（`Adequate`）で、$`R`$ は構成的宇宙 $`L`$ の上の真理の塔の $`\Sigma_1`$ 保存である。

このリポジトリは意味の層だけを取り替える。ラベルは順序数、順序は $`\lt`$、$`D`$ は常に真である。$`R`$ は次の節の関係である。

この方法は [bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern) が BMS でしたことの 1-Y 版である。そこでは許容順序数のラベルを、Carlson の patterns of resemblance の構造に替えた。1-Y では段の添字が $`\omega \times \omega_1`$ の 2 次元になる。そこで段はすべて $`\Sigma_1`$ にし、上端への関係を原子記号として言語に入れた。

## 関係 R

$`R(k,\eta,a,b)`$ は「層 $`k`$、根の添字 $`\eta`$ で、$`a`$ は $`b`$ へ安定している」と読む。定義は次の 1 つの式である。

```math
R(k,\eta,a,b) \iff \eta \le a \ \land\ a \lt b \ \land\ \mathfrak A^{a}_{k,\eta} \preccurlyeq_{\Sigma_1} \mathfrak A^{b}_{k,\eta}
```

$`\mathfrak A^{\gamma}_{k,\eta}`$ は高さ $`\gamma`$、段 $`(k,\eta)`$ の構造である。領域は $`\{x \mid x \lt \gamma\}`$ である。

```math
\mathfrak A^{\gamma}_{k,\eta} = \bigl(\gamma;\ \lt,\ (\mathrm{Rel}_j)_{j \in \mathbb N},\ (\mathrm{Top}_j)_{j \lt k},\ (\mathrm{Top}_{k,\xi})_{\xi \lt \eta}\bigr)
```

- 内部の関係：$`\mathrm{Rel}_j(x,y,z) :\iff R(j,x,y,z)`$。すべての層 $`j`$ を持つ。
- 対角の上端述語：$`\mathrm{Top}_j(\xi,x) :\iff R(j,\xi,x,\gamma)`$。層 $`j \lt k`$ だけを持つ。
- 名前付きの上端述語：$`\mathrm{Top}_{k,\xi}(x) :\iff R(k,\xi,x,\gamma)`$。名前 $`\xi \lt \eta`$ ごとに 1 つある。
- $`\preccurlyeq_{\Sigma_1}`$ は $`\Sigma_1`$ 初等部分構造である。$`a`$ より下のパラメータを持つ段 $`(k,\eta)`$ の $`\Sigma_1`$ 論理式の真偽が、2 つの構造で一致する。

右辺は $`R`$ 自身を読む。そこで $`R`$ を、鍵 $`(b,k,\eta)`$ の辞書式順序による整礎再帰で定義する。右辺が読む $`R`$ は、どれも鍵が小さい。

- $`\mathrm{Rel}_j(x,y,z)`$ では $`z \lt b`$ である。
- $`\mathfrak A^{a}`$ の上端述語では、上端が $`a \lt b`$ である。
- $`\mathfrak A^{b}`$ の上端述語では、$`(j,\xi)`$ が $`(k,\eta)`$ より辞書式に小さい。

Lean では `Por.R` と、その定義の式 `Por.R_iff` である（[Por/Relation.lean](Por/Relation.lean)）。

### 6 つの仮定の行き先

| 仮定 | 内容 | Lean 名 |
|---|---|---|
| `hWF` | $`\lt`$ は整礎 | `Ordinal.lt_wf` |
| `hTrans` | $`\lt`$ は推移的 | `h₁.trans h₂` |
| `hStrict` | $`R(k,\eta,a,b)`$ なら $`a \lt b`$ | `Por.R_lt` |
| `hWeak` | $`\eta' \lt \eta`$ で $`R(k,\eta,p,c)`$ なら $`R(k,\eta',p,c)`$ | `Por.R_weaken` |
| `reflection` | 有限反映 `FiniteReflection` | `Por.finiteReflection` |
| `initial` | どの式の図式にもラベル付けがある | `Por.initial_all` |

6 つを 1 つにまとめた定理が `Por.model_obligations` である（[Por/Model.lean](Por/Model.lean)）。

- 有限反映は、図式と上端への要求を 1 つの $`\Sigma_1`$ 論理式に書いて、$`R`$ の $`\Sigma_1`$ 初等性で下へ写して示す。
- 初期のラベル付けは、$`\omega_1`$ より下の閉包点の鎖 $`c_0 \lt c_1 \lt \cdots`$ で作る。鎖のどの 2 点も、すべての層と、小さい方までのすべての根の添字で $`R`$ の関係にある。そのため鎖はどの有限の図式も表す。

証明は選択公理と $`\omega_1`$ の正則性を使う。ラベルは $`\omega_1`$ より下の順序数である。順序数の上界や表記系は得られない。

詳しい設計と証明は [notes/01-design.md](notes/01-design.md) にある（日本語）。

## ファイル

| 場所 | 中身 |
|---|---|
| [Por/](Por/) | 意味の層のモデル。9 ファイル、約 800 行。Mathlib を使う |
| [Por/BMS/](Por/BMS/) | 組合せの層が呼ぶ BMS の層。6 ファイル、約 3,300 行。このリポジトリで書いた。Lean のコアだけを使う |
| [ZeroY/](ZeroY/) | Phyrion 氏の 0-Y の層を移したもの。42 モジュール |
| [OneY/](OneY/) | Phyrion 氏の 1-Y の層を移したもの。118 モジュール |
| [notes/](notes/) | 設計のノート（日本語） |
| [Audit.lean](Audit.lean) | 公理の監査。どの `lean_lib` にも入っていない |
| [LICENSE](LICENSE)、[NOTICE](NOTICE) | Apache-2.0 と出どころの記録 |

`Por/` の中身。上から import の順である。

| ファイル | 中身 |
|---|---|
| [Tuple.lean](Por/Tuple.lean) | 順序数の型 `Ord`、列をつなぐ `cat` |
| [Omega1.lean](Por/Omega1.lean) | $`\omega_1`$、可算順序数の数え上げ `enumBelow` |
| [Formula.lean](Por/Formula.lean) | 原子図式 `Diag`、$`\Sigma_1`$ 論理式の真偽 `Sat`、段つきの初等性 `ElemL` |
| [Relation.lean](Por/Relation.lean) | 再帰 `stepF`、`RF`、関係 `R`、`R_iff`、`R_lt`、`R_weaken` |
| [Reflection.lean](Por/Reflection.lean) | 有限反映 `finiteReflection` |
| [Closure.lean](Por/Closure.lean) | 閉包点 `lam`、`lam_good` |
| [Chain.lean](Por/Chain.lean) | 上端述語の絶対性 `top_abs`、鎖 `cC`、`initial_all` |
| [Model.lean](Por/Model.lean) | 6 つの仮定のまとめ `model_obligations` |
| [WellOrdering.lean](Por/WellOrdering.lean) | 最終定理 4 つ |

`notes/` の中身。

- [01-design.md](notes/01-design.md)：意味の層の設計。義務の一覧、$`R`$ の定義、各義務の証明、Lean の名前との対応。
- [02-port.md](notes/02-port.md)：組合せの層の移植の計画と記録。BMS の層で書き直した名前の一覧。

## ビルド

Lean 4.33.1 と Mathlib v4.33.1 を使う（`lean-toolchain`、`lakefile.toml`）。

作者の環境では、検査ツール leanman で検査した。リポジトリの根で次のコマンドを使う。

```sh
leanman build ZeroY OneY Por
leanman check -C . Audit.lean
```

lake だけでも同じことができる。

```sh
lake exe cache get
lake build ZeroY OneY Por
lake env lean Audit.lean
```

- 既定のターゲットは `Por` である。`lake build` だけでも、最終定理に要るモジュールはすべてビルドされる。
- `ZeroY` と `OneY` を名前で並べると、2 つのライブラリの全モジュールがビルドされる。
- 2026-09-23 に `leanman build ZeroY OneY Por` と `leanman check -C . Audit.lean` を実行した。どちらも終了コードは 0 である。

## 公理の監査

[Audit.lean](Audit.lean) は主な定理の `#print axioms` を並べたファイルである。出力は次のとおりである（2026-09-23、終了コード 0）。

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

- どれも Lean の標準の 3 つの公理だけである。`sorryAx` は無い。
- ソースに `sorry` も `axiom` 宣言も無い。

## 謝辞とライセンス

このリポジトリは Apache License 2.0 である（[LICENSE](LICENSE)）。出どころと変更点は [NOTICE](NOTICE) に書いてある。

- 組合せの層：[Phyrion1343/1Y-Well-Ordering-Lean](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean)（Apache-2.0、リビジョン `6533b29`）の `formalization/ZeroY` と `formalization/OneY` を移したものである。証明の全体の形も Phyrion 氏による。各ファイルの先頭に、元のパスと変更点を書いてある。変更は、BMS の層の import と名前空間を `Por.BMS` に替えたことなどである。コメントは元のまま（中国語を含む）である。
- `Por/` の補助：`Tuple`、`Omega1`、`Relation`、`Closure`、`Chain` の 5 ファイルは、[koteitan/bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern) の `lean/Pattern` の補助と組み立てを移したものである。元は CC BY-SA 4.0 である。このリポジトリの作者と同じ著作者による。この部分を Apache-2.0 でも出すかは著作者の判断で、まだ決まっていない。それまでは、この部分は CC BY-SA 4.0 の下にある。各ファイルの先頭に、そのことを書いてある。
- BMS の層：`Por/BMS/` はこのリポジトリのために書いた。Phyrion 氏のリポジトリには、ライセンスのファイルが無い BMS のコード（YesMetaZFC）のスナップショットが同梱されている。組合せの層は元はそれを呼ぶ。`Por/BMS/` は、組合せの層が呼ぶ名前と命題の形だけを、呼び出し側（Apache-2.0）から取った。定義と証明は自前で書いた。スナップショットの行は 1 行も写していない。

## 参考文献

- Phyrion, [1Y-Well-Ordering-Lean](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean). 1-Y の整礎性の Lean の形式化。
- Phyrion, [Well-Ordering of the 1-Y Sequence System](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean/blob/main/Well-Ordering%20of%20the%201-Y%20Sequence%20System.pdf). 上のリポジトリにある論文。
- T. J. Carlson, Elementary patterns of resemblance, Annals of Pure and Applied Logic 108 (2001), 19–77.
- koteitan, [bms-elem-pattern](https://github.com/koteitan/bms-elem-pattern). patterns of resemblance による BMS の整礎性。

[← 設計](01-design.md) | [PLAN](../PLAN.md)

# 移植計画：組合せの層

PLAN の手順 3 のノートである。Phyrion 氏の組合せの層（[Phyrion1343/1Y-Well-Ordering-Lean](https://github.com/Phyrion1343/1Y-Well-Ordering-Lean) の `formalization/OneY` と `formalization/ZeroY`、Apache-2.0、リビジョン `6533b29`）をこのリポジトリに取り込む。組合せの層が依存する YesMetaZFC の BMS の部分はライセンスが無いので、写さずに自前で書き直す。

YesMetaZFC は、Phyrion 氏のリポジトリに `vendor/bms` として同梱されている。上流は [EgoFakeFantasy/BMS-Well-Ordering-Lean](https://github.com/EgoFakeFantasy/BMS-Well-Ordering-Lean)（スナップショット `bae7e3d`）で、ライセンスのファイルは無い。

## 0. 要約

- 取り込むもの：最終定理が import で依存する 161 モジュール、24,420 行。そのうち定数の水準で要るのは 142 モジュール、21,926 行である。残りの 19 モジュール、2,494 行は外す。
- 書き直すもの：コアが直接使う YesMetaZFC の名前 106 個（公開 105 個、private 1 個）。YesMetaZFC の中でのその閉包は 494 宣言、5,098 行ある。
- 使わないもの：YesMetaZFC の生成と安定性の枠組み（`Generation`、`Stability`、`RepresentationDescentSystem` など）。1-Y の整礎性は BMS の整礎性を使わない。YesMetaZFC は、BMS の配列、親、祖先、展開、コピーの補題（補題 2.5）という組合せの部品としてだけ使われている。
- 書き直しの経路は 2 つある。bms-elem-pattern の `Bm4` を経由する経路（新規約 3.0k 行と、Bm4 の 2.9k 行の版上げ）と、直接書く経路（新規約 4.0–5.0k 行）である。どちらにするかは手順 B0 の測定で決める（§4）。
- 見積もり：取り込む 21.9k 行（小さな修正だけ）と、新しい BMS の層 3–5k 行。

## 1. 測り方

- import の閉包：`OneY.Dynamics`、`OneY.RootIndexed.ExpansionWellFounded`、`OneY.RootIndexed.Representation` から、ソースの import 行をたどった。OneY と ZeroY の全 173 ファイル（25,825 行）のうち、161 モジュールが入る。
- 定数の閉包：ビルド済みの `.olean` を読むメタプログラムで、`OneY.RootIndexed.*` と `OneY.Dynamics` のすべての宣言から依存をたどった。§2 で「外す」とした 19 モジュールは import されるが、定数を 1 つも出さない。
- 最終定理 4 つだけから依存をたどっても測った。YesMetaZFC の定数は 453 個ある（`Lemma25` 140、`Decomposition` 139、`Ancestor` 54、`Parent` 40、`Reference` 31、`Expansion` 30、`Array` 16、`WellFoundedness` 2、`ExpansionOrder` 1）。そのうちコアの 38 モジュールが直接使う名前は 110 個で、自動で作られる `mk` と `match_1` の 7 個を除くと、§3 の 106 個と一致する（private の `relativeSupport` は match の等式を通して使われる）。
- コアは Lean のコアと Std だけを使う。Mathlib も sorry も無い。YesMetaZFC を直接 import するのは 10 モジュールで、`open` の行で YesMetaZFC を開くファイルは 52 ある。

## 2. モジュールの一覧

import の順（依存される方が先）に並べる。「YesMetaZFC」の列の「直接 import」は、そのモジュールが YesMetaZFC を import することを表す。「n 個」は、最終定理の定数閉包の中で、そのモジュールの定数が直接使う YesMetaZFC の名前の数（`mk` と `match_1` を除く）である。

| # | モジュール | 行数 | 扱い | YesMetaZFC |
|---:|---|---:|---|---|
| 1 | `OneY.Forest` | 197 | 取り込む |  |
| 2 | `ZeroY.Syntax` | 94 | 取り込む |  |
| 3 | `ZeroY.Mountain` | 104 | 取り込む | 直接 import、1 個 |
| 4 | `ZeroY.Mountain.Termination` | 214 | 取り込む | 直接 import |
| 5 | `ZeroY.Forest.Stack` | 253 | 取り込む | 直接 import、8 個 |
| 6 | `OneY.ForestBridge` | 49 | 取り込む |  |
| 7 | `OneY.Numeric` | 237 | 取り込む | 6 個 |
| 8 | `OneY.Geometry` | 178 | 外す |  |
| 9 | `OneY.RootGeometry` | 204 | 取り込む |  |
| 10 | `ZeroY.Decode` | 168 | 外す | 直接 import |
| 11 | `ZeroY.Mountain.SumInverse` | 91 | 外す |  |
| 12 | `ZeroY.Mountain.Roots` | 167 | 取り込む | 直接 import |
| 13 | `OneY.NumericGeometry` | 104 | 取り込む |  |
| 14 | `OneY.NumericRoots` | 105 | 取り込む | 3 個 |
| 15 | `OneY.Pseudo` | 128 | 取り込む | 4 個 |
| 16 | `OneY.ExtractionGeometry` | 82 | 取り込む |  |
| 17 | `OneY.Extraction` | 118 | 取り込む |  |
| 18 | `OneY.BadRoot` | 141 | 取り込む |  |
| 19 | `OneY.CopyCoordinates` | 167 | 取り込む |  |
| 20 | `OneY.LowerCopy` | 319 | 取り込む |  |
| 21 | `OneY.PseudoCollapse` | 89 | 取り込む |  |
| 22 | `ZeroY.Forest.Blocker` | 194 | 取り込む | 1 個 |
| 23 | `OneY.PseudoSelection` | 178 | 取り込む |  |
| 24 | `OneY.TopForestGeometry` | 104 | 取り込む |  |
| 25 | `OneY.ActiveGeometry` | 104 | 取り込む |  |
| 26 | `OneY.Build` | 73 | 外す |  |
| 27 | `ZeroY.BMS.AnyArray` | 125 | 外す | 直接 import |
| 28 | `ZeroY.MatrixOrder` | 70 | 取り込む | 2 個 |
| 29 | `ZeroY.PaddedOrder` | 103 | 取り込む |  |
| 30 | `ZeroY.Transport` | 147 | 取り込む |  |
| 31 | `ZeroY.BMS.PaddedDescent` | 315 | 取り込む | 6 個 |
| 32 | `ZeroY.Structural.Prefix` | 195 | 取り込む | 14 個 |
| 33 | `ZeroY.Structural.ExpansionParents` | 363 | 取り込む | 直接 import、41 個 |
| 34 | `ZeroY.Structural.ExpansionCoordinates` | 177 | 取り込む | 45 個 |
| 35 | `ZeroY.Structural.DepthExpansion` | 188 | 取り込む | 36 個 |
| 36 | `ZeroY.Structural.BlockerExpansion` | 267 | 取り込む | 17 個 |
| 37 | `ZeroY.Forest.Comparison` | 208 | 取り込む | 3 個 |
| 38 | `ZeroY.Forest.MatrixParents` | 103 | 取り込む | 13 個 |
| 39 | `ZeroY.Encode` | 46 | 外す | 直接 import |
| 40 | `ZeroY.Mountain.Encoding` | 105 | 外す |  |
| 41 | `ZeroY.SequenceOrder` | 90 | 取り込む |  |
| 42 | `ZeroY.OrderEmbedding` | 235 | 外す |  |
| 43 | `ZeroY.Mountain.CommonChain` | 270 | 取り込む | 1 個 |
| 44 | `ZeroY.Forest.AncestorMonotone` | 71 | 取り込む | 7 個 |
| 45 | `ZeroY.Structural.CopyOrder` | 216 | 取り込む | 12 個 |
| 46 | `ZeroY.Structural.Expansion` | 204 | 取り込む | 16 個 |
| 47 | `OneY.DecoratedColumn` | 73 | 取り込む | 10 個 |
| 48 | `OneY.DecoratedBlocker` | 195 | 取り込む | 19 個 |
| 49 | `OneY.DecoratedBlockerExpansion` | 139 | 取り込む | 20 個 |
| 50 | `OneY.ForestFrame` | 155 | 取り込む |  |
| 51 | `ZeroY.RoundTrip` | 232 | 取り込む | 8 個 |
| 52 | `ZeroY.PaddedExt` | 105 | 外す |  |
| 53 | `ZeroY.Image` | 92 | 外す |  |
| 54 | `ZeroY.Reversible` | 116 | 外す |  |
| 55 | `ZeroY.Structural.DecodeTower` | 180 | 外す |  |
| 56 | `ZeroY.Structural.Recognition` | 269 | 外す |  |
| 57 | `ZeroY.Structural.RawRecognition` | 63 | 外す |  |
| 58 | `OneY.ForestFrameMatrix` | 131 | 外す |  |
| 59 | `OneY.DepthMatrix` | 141 | 取り込む | 13 個 |
| 60 | `OneY.LowerCopyNesting` | 309 | 取り込む |  |
| 61 | `OneY.OrdinaryCopy` | 246 | 取り込む |  |
| 62 | `OneY.RootSearch` | 101 | 取り込む |  |
| 63 | `OneY.TerminalCopy` | 231 | 取り込む |  |
| 64 | `OneY.TerminalCopyNesting` | 206 | 取り込む |  |
| 65 | `OneY.TerminalCopyNumeric` | 49 | 取り込む |  |
| 66 | `OneY.Reconstruction` | 204 | 取り込む |  |
| 67 | `OneY.ReconstructionNumeric` | 74 | 取り込む |  |
| 68 | `OneY.TowerReconstruction` | 95 | 取り込む |  |
| 69 | `ZeroY.Expansion` | 167 | 取り込む |  |
| 70 | `OneY.Expansion` | 81 | 取り込む |  |
| 71 | `OneY.ExpansionProperties` | 103 | 取り込む |  |
| 72 | `OneY.RootIndexed.Representation` | 533 | 取り込む |  |
| 73 | `OneY.RootIndexed.CopyCoordinates` | 99 | 取り込む |  |
| 74 | `OneY.Prefix` | 162 | 取り込む | 3 個 |
| 75 | `OneY.RootIndexed.Diagram` | 94 | 取り込む |  |
| 76 | `OneY.RootIndexed.Prefix` | 60 | 取り込む |  |
| 77 | `OneY.RootIndexed.TerminalRoots` | 59 | 取り込む |  |
| 78 | `OneY.RootIndexed.CopyDiagram` | 195 | 取り込む |  |
| 79 | `OneY.FrameCopy` | 139 | 取り込む |  |
| 80 | `OneY.LowerCopyDominance` | 463 | 取り込む |  |
| 81 | `OneY.LowerCopyRoots` | 246 | 取り込む |  |
| 82 | `OneY.LowerCopyDepths` | 291 | 取り込む |  |
| 83 | `OneY.SparseComparison` | 119 | 取り込む | 1 個 |
| 84 | `OneY.SparseBlocker` | 182 | 取り込む |  |
| 85 | `OneY.SparseDepth` | 77 | 取り込む |  |
| 86 | `OneY.TopComparison` | 307 | 取り込む |  |
| 87 | `OneY.LowerCopyComparison` | 576 | 取り込む |  |
| 88 | `OneY.ReconstructionComparison` | 165 | 取り込む |  |
| 89 | `OneY.LowerCopyBlocker` | 359 | 取り込む |  |
| 90 | `OneY.OrdinaryCopyRoots` | 66 | 取り込む |  |
| 91 | `OneY.OrdinaryCopyReconstruction` | 70 | 取り込む |  |
| 92 | `OneY.OrdinaryCopySelection` | 114 | 取り込む |  |
| 93 | `OneY.OrdinaryCopyForest` | 122 | 取り込む |  |
| 94 | `OneY.OrdinaryCopyNumeric` | 142 | 取り込む |  |
| 95 | `OneY.OrdinaryCopyPseudo` | 73 | 取り込む |  |
| 96 | `OneY.OrdinaryCopyExtraction` | 99 | 取り込む |  |
| 97 | `OneY.ReconstructionTop` | 121 | 取り込む |  |
| 98 | `OneY.TerminalCopyReconstruction` | 222 | 取り込む |  |
| 99 | `OneY.NumericFrame` | 119 | 取り込む | 5 個 |
| 100 | `ZeroY.Structural.ExpansionParentAlignment` | 75 | 外す |  |
| 101 | `OneY.RelativeBlocker` | 590 | 取り込む | 33 個 |
| 102 | `OneY.NumericFrameBlocker` | 142 | 取り込む | 6 個 |
| 103 | `ZeroY.Expansion.Context` | 116 | 取り込む | 直接 import、4 個 |
| 104 | `OneY.TerminalFrame` | 76 | 取り込む | 9 個 |
| 105 | `OneY.TerminalFrameParents` | 126 | 取り込む | 12 個 |
| 106 | `OneY.TerminalCopyTopBound` | 234 | 取り込む |  |
| 107 | `OneY.TerminalFrameDepths` | 47 | 取り込む | 5 個 |
| 108 | `OneY.TerminalCopyComparison` | 113 | 取り込む | 10 個 |
| 109 | `OneY.NumericDecoratedFrame` | 89 | 取り込む | 9 個 |
| 110 | `OneY.TerminalCopyCanonical` | 102 | 取り込む |  |
| 111 | `OneY.TerminalDecoratedRecovery` | 129 | 取り込む | 12 個 |
| 112 | `OneY.TerminalCopyComplete` | 60 | 取り込む |  |
| 113 | `OneY.TerminalCopyRoots` | 85 | 取り込む |  |
| 114 | `OneY.TerminalCopyExtraction` | 56 | 取り込む |  |
| 115 | `OneY.TerminalCopyRebuild` | 90 | 取り込む |  |
| 116 | `OneY.TerminalCopyTransport` | 80 | 取り込む |  |
| 117 | `OneY.TerminalCopyBottom` | 98 | 取り込む |  |
| 118 | `OneY.TerminalCopyBottomRecovery` | 290 | 取り込む |  |
| 119 | `OneY.TerminalCopySeamComparison` | 110 | 取り込む | 14 個 |
| 120 | `OneY.TerminalCopyExternalSeam` | 161 | 取り込む |  |
| 121 | `OneY.TerminalCopyExternal` | 63 | 取り込む |  |
| 122 | `OneY.TerminalCopyDepths` | 127 | 取り込む |  |
| 123 | `OneY.TerminalCopyUpperOrder` | 132 | 取り込む |  |
| 124 | `OneY.TerminalCopyLinear` | 41 | 取り込む |  |
| 125 | `OneY.TowerCopyAssembly` | 75 | 取り込む |  |
| 126 | `OneY.TerminalTowerRebuild` | 111 | 取り込む |  |
| 127 | `OneY.ExpansionRebuildPrefix` | 129 | 取り込む |  |
| 128 | `OneY.LowerCopyTopForest` | 61 | 取り込む |  |
| 129 | `OneY.ReconstructionComparisonPrefix` | 155 | 取り込む |  |
| 130 | `OneY.LowerCopyBadBlocker` | 300 | 取り込む |  |
| 131 | `OneY.LowerCopyCanonical` | 199 | 取り込む |  |
| 132 | `OneY.LowerCopyBottom` | 102 | 取り込む |  |
| 133 | `OneY.LowerCopyBottomRecovery` | 299 | 取り込む |  |
| 134 | `OneY.LowerCopyTransport` | 136 | 取り込む |  |
| 135 | `OneY.LowerCopyRebuild` | 117 | 取り込む |  |
| 136 | `OneY.LowerCopyLayerTransport` | 37 | 取り込む |  |
| 137 | `OneY.FirstMatch` | 115 | 取り込む |  |
| 138 | `OneY.LowerCopyPseudoSeam` | 75 | 取り込む |  |
| 139 | `OneY.LowerCopyPseudoHigh` | 112 | 取り込む |  |
| 140 | `OneY.LowerCopyPseudoOutside` | 110 | 取り込む |  |
| 141 | `OneY.LowerCopyPseudoLow` | 166 | 取り込む |  |
| 142 | `OneY.SingleContraction` | 75 | 取り込む |  |
| 143 | `OneY.LowerCopyPseudo` | 137 | 取り込む |  |
| 144 | `OneY.LowerCopyTopBound` | 92 | 取り込む |  |
| 145 | `OneY.LowerCopyLayerTopBound` | 79 | 取り込む |  |
| 146 | `OneY.LowerTowerInputs` | 141 | 取り込む |  |
| 147 | `OneY.LowerTowerRebuild` | 180 | 取り込む |  |
| 148 | `OneY.ExpansionCanonical` | 135 | 取り込む |  |
| 149 | `OneY.ExpansionOrder` | 168 | 取り込む |  |
| 150 | `OneY.RootIndexed.LowerAtoms` | 100 | 取り込む |  |
| 151 | `OneY.RootIndexed.OrdinaryAtoms` | 60 | 取り込む |  |
| 152 | `OneY.RootIndexed.VirtualNeeds` | 83 | 取り込む |  |
| 153 | `OneY.RootIndexed.SpliceGeometry` | 127 | 取り込む |  |
| 154 | `OneY.RootIndexed.ActualScheme` | 110 | 取り込む |  |
| 155 | `OneY.RootIndexed.ExpansionWellFounded` | 156 | 取り込む |  |
| 156 | `ZeroY.Dynamics.Definitions` | 62 | 外す |  |
| 157 | `ZeroY.Expansion.CopyRows` | 317 | 外す |  |
| 158 | `ZeroY.Expansion.Prefix` | 71 | 取り込む |  |
| 159 | `ZeroY.Expansion.Conjugacy` | 63 | 外す |  |
| 160 | `ZeroY.Dynamics.Prefix` | 42 | 取り込む |  |
| 161 | `OneY.Dynamics` | 300 | 取り込む | 直接 import、1 個 |

外す 19 モジュールは、主に 0-Y と BMS の対応の部分（符号化、復号、行列の認識、順序の埋め込み、展開の共役）、BMS の整礎性の系（`ZeroY.BMS.AnyArray`）、入口に届かない 1-Y の幾何（`OneY.Geometry`、`OneY.Build`、`OneY.ForestFrameMatrix`）である。取り込むモジュールの中の、これらを import する行は消す。

## 3. コアが使う YesMetaZFC の名前と、書き直し方

### 3.1 方針

- コード（定義と証明の本文）は写さない。翻案もしない。YesMetaZFC を読むのは、名前が何を述べるかを確かめるときだけにする。証明の組み立ても写さない。
- 必要な名前と命題の形は、コアの使用箇所から取る。コアは Apache-2.0 なので、読んで直してよい。
- 定義は BM4（Bashicu Matrix System の第 4 版）の数学的な定義から書く。bms-elem-pattern の `lean/Bm4`（koteitan 氏のコード）も参考にする。
- 名前空間は `Por.BMS` にする。コアのファイルは機械的に直す。`import YesMetaZFC.BMS.X` を自前のモジュールに、`open YesMetaZFC.BMS` を `open Por.BMS` に、`YesMetaZFC.BMS.StabilityFrame.StrictWellOrder` を自前の `StrictWellOrder` に替える。
- コアが呼ぶ名前（例：`parent_some_lt`）は、同じ名前で用意する。呼び出し側を直さずに済むからである。構造体の場の名前も合わせる。コアは `ExpansionContext` を作るところで場の名前を書くからである。
- コアのファイルを直したときは、ファイルの先頭に出どころと変更点を書き、`NOTICE` に載せる（Apache-2.0 の条件）。

### 3.2 一覧

コアが直接使う 106 個を、YesMetaZFC のモジュールごとに並べる。

- 名前：YesMetaZFC での名前（`YesMetaZFC.BMS.` を省く）。
- 行：YesMetaZFC での宣言の行数。
- 使う側：その名前を直接使うコアのモジュールの数。
- 書き直し：「自作」は自前で書く。「Bm4」は、bms-elem-pattern の `lean/Bm4` のその定理から、§4 の A6 の対応の補題を通して出せることを表す。「C1」〜「C6」は `BM4.theorem_6_3` の 6 つの主張である。

#### Reference（定義、16 個）

| 名前 | 種類 | 行 | 使う側 | 内容 | 書き直し |
|---|---|---:|---:|---|---|
| `BMSArray` | 定義 | 2 | 9 | 配列の型。列のリスト `List (List Nat)` | 自作（同じ型） |
| `ancestorChain` | 定義 | 7 | 14 | 親の関数を燃料付きで繰り返した、親から始まる祖先のリスト | 自作。コアが定義を開く（5 か所）ので同じ再帰の形にする |
| `ascending` | 定義 | 3 | 4 | 上がる要素か：$`k \lt m_0`$ かつ（$`j = 0`$ または $`p`$ が $`p+j`$ の $`k`$ 行の祖先） | 自作（`Bool`）。数学的には Bm4 の `BadRoot` の上がる条件 |
| `copyBlock` | 定義 | 13 | 3 | 悪い部分の $`q`$ 番目のコピー。上がる要素に $`q`$ 倍の差 $`A(c,k) - A(p,k)`$ を足す | 自作。Bm4：`BM4.tildeCol` |
| `entry?` | 定義 | 3 | 6 | 要素 $`A(i,k)`$ を `Option Nat` で返す | 自作 |
| `expand` | 定義 | 3 | 1 | `expandRaw` のあと `trimZeroRows` をかける | 自作 |
| `expandRaw` | 定義 | 17 | 4 | BM4 の展開 $`A[N]`$：よい部分、悪い部分のコピー $`N+1`$ 個。末尾の列に親が無ければ末尾を落とす | 自作。Bm4：`BM4.expand`（要素ごとの一致を示す） |
| `greatestBelow?` | 定義 | 5 | 8 | $`m \lt n`$ で述語を満たす最大の $`m`$（`Option`） | 自作（一般的な探索） |
| `isAncestor` | 定義 | 3 | 15 | $`j`$ が $`i`$ の $`k`$ 行の真の祖先か（`Bool`、燃料 $`i`$ の `ancestorChain` で判定） | 自作。Bm4：`BM4.anc` |
| `maximalParentRow` | 定義 | 7 | 3 | 末尾の列が親を持つ最大の行 $`m_0`$ | 自作。Bm4：`BM4.m₀` |
| `parent` | 定義 | 23 | 25 | BM4 の $`k`$ 行の親。0 行では左で最も近い値の小さい列、$`k+1`$ 行では左で最も近い、$`k`$ 行の祖先で値の小さい列 | 自作。Bm4：`BM4.parent`（`parent k A i = some j` との一致を $`k`$ の帰納法で示す） |
| `rectangular` | 定義 | 4 | 4 | すべての列の長さが等しいかを `Bool` で返す | 自作 |
| `slice` | 定義 | 3 | 2 | ある列から始まる、決まった数の列を取り出す | 自作 |
| `trimHeight` | 定義 | 3 | 6 | 各列の支え（最後の 0 でない要素の位置 + 1）の最大 | 自作 |
| `trimZeroRows` | 定義 | 3 | 9 | すべての列に共通な、末尾の 0 だけの行を落とす | 自作 |
| `relativeSupport` | 定義 | — | 3 | （private）列の支えを再帰で求める関数。コアの 3 か所が simp でその match の等式を使う | 自作の支えの補題に替え、その 3 か所を直す |

#### Array（7 個）

| 名前 | 種類 | 行 | 使う側 | 内容 | 書き直し |
|---|---|---:|---:|---|---|
| `RectangularArray` | 構造 | 5 | 1 | 列の長さがそろった配列（場は `raw` と `rectangular_eq`） | 自作 |
| `RectangularArray.raw` | 定義 | 1 | 20 | `List (List Nat)` への射影 | 自作（場） |
| `RectangularArray.rectangular_eq` | 定理 | 1 | 2 | 場：`rectangular raw = true` | 自作（場） |
| `ValidArray` | 構造 | 4 | 14 | 末尾の 0 だけの行を落とした長方形の配列（場 `trimmed_eq`） | 自作 |
| `ValidArray.ext` | 定理 | 11 | 1 | `raw` が等しければ等しい | 自作 |
| `ValidArray.toRectangularArray` | 定義 | 3 | 20 | 長方形の配列への射影 | 自作（場） |
| `ValidArray.trimmed_eq` | 定理 | 1 | 1 | 場：`trimZeroRows raw = raw` | 自作（場） |

#### Parent（10 個）

| 名前 | 種類 | 行 | 使う側 | 内容 | 書き直し |
|---|---|---:|---:|---|---|
| `direct_parent_isAncestor` | 定理 | 8 | 7 | 親は祖先である | 自作。Bm4：`BM4.anc_of_parent` |
| `greatestBelow?_eq_none_iff` | 定理 | 27 | 5 | `none` になる ⟺ $`m \lt n`$ で述語を満たすものが無い | 自作 |
| `greatestBelow?_eq_some_iff` | 定理 | 23 | 4 | `some m` になる ⟺ $`m \lt n`$、$`m`$ が述語を満たし、$`m`$ と $`n`$ の間に満たすものが無い | 自作 |
| `greatestBelow?_some_lt` | 定理 | 12 | 2 | 見つかった $`m`$ は $`n`$ より小さい | 自作 |
| `greatestBelow?_some_satisfies` | 定理 | 12 | 1 | 見つかった $`m`$ は述語を満たす | 自作 |
| `isAncestor_lt` | 定理 | 6 | 4 | 祖先は左にある | 自作。Bm4：`BM4.anc_lt` |
| `parentEligible` | 定義 | 12 | 1 | 親の候補の判定。0 行は値だけ、$`k+1`$ 行は $`k`$ 行の祖先であることと値 | 自作。コア 1 か所が等式を使う |
| `parent_eq_greatestBelow?` | 定理 | 7 | 1 | `parent` は `parentEligible` についての `greatestBelow?` | 自作 |
| `parent_some_entry_lt` | 定理 | 12 | 4 | 親の値は小さい | 自作。Bm4：`BM4.parent_val_lt` |
| `parent_some_lt` | 定理 | 7 | 12 | 親は左にある | 自作。Bm4：`BM4.parent_lt` |

#### Ancestor（15 個）

| 名前 | 種類 | 行 | 使う側 | 内容 | 書き直し |
|---|---|---:|---:|---|---|
| `StrictAncestor` | 定義 | 3 | 1 | 親の辺の推移閉包 `TransGen` としての祖先（燃料なし） | 自作。Bm4：`BM4.anc` |
| `ancestorChain_congr_below` | 定理 | 21 | 2 | 2 つの減少する親の関数が $`i`$ 以下で一致すれば、祖先のリストも一致する | 自作（リストの補題） |
| `ancestorChain_mem_strictAncestor` | 定理 | 23 | 1 | 祖先のリストの元は `StrictAncestor` | 自作（リストの補題） |
| `ancestor_entries_lt` | 定理 | 8 | 1 | 祖先の値は小さい | Bm4：`BM4.anc_val_lt` |
| `ancestor_le_parent` | 定理 | 10 | 5 | 祖先は親以下にある | Bm4：`BM4.anc_last_step`、`BM4.parent_max` |
| `isAncestor_congr_below` | 定理 | 8 | 2 | 祖先の関係は、$`i`$ 以下の列の親だけで決まる | Bm4：`BM4.anc_congr_iff` |
| `isAncestor_congr_of_parent_eq` | 定理 | 34 | 1 | 親が同じ 2 つの列は、同じ真の祖先を持つ | Bm4：`BM4.anc_last_step` と `BM4.parent_unique` |
| `isAncestor_eq_false_of_parent_none` | 定理 | 16 | 2 | 親が無ければ祖先も無い | Bm4：`BM4.anc_last_step` |
| `isAncestor_iff_strictAncestor` | 定理 | 15 | 1 | `Bool` の祖先の判定は `TransGen` と一致する（燃料が足りる） | 自作。Bm4：`BM4.anc_eq_transGen` |
| `isAncestor_of_lt_row` | 定理 | 14 | 6 | 行について単調：$`k`$ 行の祖先は $`h \lt k`$ 行でも祖先 | Bm4：`BM4.anc_mono`、または自作 |
| `isAncestor_trans` | 定理 | 8 | 3 | 祖先は推移的 | Bm4：`BM4.anc_trans`、または自作 |
| `parentTransGen_comparable` | 定理 | 38 | 1 | 1 つの列の 2 つの祖先は比べられる（祖先の列は線形） | Bm4：`BM4.anc_of_anc_of_anc_of_lt` |
| `parent_eq_of_entry?_eq_below` | 定理 | 29 | 2 | 親は、$`i`$ 以下の列の値だけで決まる | Bm4：`BM4.parent_congr_iff` |
| `strictAncestor_mem_ancestorChain` | 定理 | 26 | 1 | 逆向き：`StrictAncestor` なら燃料 $`i`$ の祖先のリストに入る | 自作（リストの補題） |
| `transGen_head` | 定理 | 11 | 3 | `TransGen` を先頭の 1 歩で分ける一般的な補題 | 自作（数行） |

#### Expansion（16 個）

| 名前 | 種類 | 行 | 使う側 | 内容 | 書き直し |
|---|---|---:|---:|---|---|
| `UniformHeight` | 定義 | 3 | 3 | すべての列の長さが $`h`$ | 自作 |
| `ValidArray.expand` | 定義 | 9 | 16 | $`A[N]`$ を `ValidArray` として作る | 自作 |
| `ValidArray.raw_expand` | 定理 | 3 | 1 | `(A.expand N).raw = expand A.raw N` | 自作（`rfl` 程度） |
| `entry?_trimZeroRows_eq_none_of_le` | 定理 | 10 | 1 | `trimHeight` 以上の行は落ちる | 自作 |
| `entry?_trimZeroRows_of_lt` | 定理 | 10 | 1 | `trimHeight` より下の行は残る | 自作 |
| `exists_entry_of_uniformHeight` | 定理 | 13 | 2 | 高さ $`h`$ なら、$`h`$ より下の行に要素がある | 自作 |
| `length_trimZeroRows` | 定理 | 4 | 4 | 列の数は変わらない | 自作 |
| `parent_trimZeroRows_eq_none_of_le` | 定理 | 15 | 2 | 落ちた行には親が無い | 自作 |
| `parent_trimZeroRows_of_lt` | 定理 | 32 | 2 | 残る行の親は変わらない | 自作（Bm4 との対応を示すときにも要る。Bm4 は行を落とさないため） |
| `rectangular_iff_exists_uniformHeight` | 定理 | 17 | 3 | `rectangular` ⟺ ある $`h`$ で `UniformHeight h` | 自作 |
| `rectangular_trimZeroRows` | 定理 | 13 | 1 | 行を落としても長方形 | 自作 |
| `row_lt_trimHeight_of_entry?_eq_some_of_ne_zero` | 定理 | 19 | 4 | 0 でない要素の行は `trimHeight` より下 | 自作 |
| `row_lt_uniformHeight_of_entry?_eq_some` | 定理 | 19 | 2 | 要素がある行は $`h`$ より下 | 自作 |
| `trimZeroRows_idempotent` | 定理 | 16 | 1 | 2 回落としても同じ | 自作 |
| `uniformHeight_expandRaw` | 定理 | 18 | 1 | 展開は高さを保つ | 自作 |
| `uniformHeight_trimZeroRows` | 定理 | 8 | 1 | 落としたあとの高さは `trimHeight` | 自作 |

#### ExpansionOrder（1 個）

| 名前 | 種類 | 行 | 使う側 | 内容 | 書き直し |
|---|---|---:|---:|---|---|
| `ValidArray.raw_expand_zero` | 定理 | 6 | 1 | $`A[0]`$ の形：末尾の列を除いて行を落としたもの | 自作 |

#### Decomposition（32 個）

| 名前 | 種類 | 行 | 使う側 | 内容 | 書き直し |
|---|---|---:|---:|---|---|
| `ExpansionContext` | 構造 | 8 | 15 | 悪い根を持つ空でない配列の記録：末尾の列 $`c`$、最大の行 $`m_0`$、悪い根 $`p`$（$`m_0`$ 行での $`c`$ の親）とその証明 | 自作。場の名前はコアに合わせる。数学的には `BM4.BadRoot` |
| `ExpansionContext.InCopy` | 定義 | 5 | 1 | 列 $`x`$ がコピー $`q`$ の中にある：$`p + q s ≤ x \lt p + (q+1) s`$ | 自作（算術） |
| `ExpansionContext.array_length` | 定理 | 1 | 6 | 場：長さは $`c + 1`$ | 自作（場） |
| `ExpansionContext.ascending_eq_of_ancestor` | 定理 | 35 | 1 | 悪い部分の中で $`p+a`$ が $`p+b`$ の $`k`$ 行の祖先なら、上がるかどうかが一致する | Bm4：`CopyPaper` の L1 の補題 |
| `ExpansionContext.ascending_of_ancestor_of_ascending` | 定理 | 22 | 1 | 上がる性質は、悪い部分の中で祖先へ伝わる | Bm4：`BM4.BadRoot.asc_of_asc_of_anc` |
| `ExpansionContext.badPart` | 定義 | 2 | 1 | 悪い部分（列 $`p`$ から $`c - 1`$） | 自作 |
| `ExpansionContext.blockLength` | 定義 | 2 | 11 | $`s = c - p`$ | 自作（算術） |
| `ExpansionContext.blockLength_pos` | 定理 | 5 | 4 | $`0 \lt s`$ | 自作。Bm4：`BM4.BadRoot.s_pos` |
| `ExpansionContext.copiedValue` | 定義 | 10 | 1 | コピー $`q`$ の $`(j,k)`$ 要素：上がるなら $`A(p+j,k) + q (A(c,k) - A(p,k))`$、そうでなければ $`A(p+j,k)`$ | 自作。Bm4：`BM4.BadRoot.col_pos` の類 |
| `ExpansionContext.copyPosition` | 定義 | 3 | 11 | コピー $`q`$ の $`j`$ 番目の列の位置 $`p + q s + j`$ | 自作（算術） |
| `ExpansionContext.copyPosition_lt_length` | 定理 | 16 | 3 | $`q ≤ N`$、$`j \lt s`$ なら $`A[N]`$ の中にある | 自作。Bm4：`BM4.BadRoot.pos_lt_tA_len` |
| `ExpansionContext.copyPosition_zero` | 定理 | 5 | 5 | コピー 0 の $`j`$ 番目は $`p + j`$ | 自作（算術） |
| `ExpansionContext.copyStart` | 定義 | 3 | 3 | $`p + q s`$ | 自作（算術） |
| `ExpansionContext.entry?_badPart` | 定理 | 7 | 1 | 悪い部分の要素は $`A(p+j, k)`$ | 自作 |
| `ExpansionContext.entry?_copyBlock` | 定理 | 10 | 1 | `copyBlock` の要素は `copiedValue` | 自作 |
| `ExpansionContext.entry?_expandRaw_copy` | 定理 | 9 | 1 | `expandRaw` の位置 $`p + q s + j`$ の要素は、コピー $`q`$ の $`j`$ 番目の要素 | 自作。Bm4：`BM4.BadRoot.col_pos` |
| `ExpansionContext.entry?_expandRaw_eq_of_lt_lastIndex` | 定理 | 17 | 1 | $`c`$ より左の列は変わらない | 自作。Bm4：`BM4.BadRoot.col_prefix` |
| `ExpansionContext.entry?_expandRaw_indices_eq_of_lt_length` | 定理 | 16 | 1 | $`A[N]`$ と $`A[N']`$ は共通の列で一致する | 自作 |
| `ExpansionContext.exists_badPart_entry` | 定理 | 25 | 1 | 悪い部分の列は、高さより下のすべての行に要素を持つ | 自作 |
| `ExpansionContext.exists_copyPosition_of_not_good` | 定理 | 31 | 4 | $`A[N]`$ の $`p`$ 以上の列は $`p + q s + j`$（$`q ≤ N`$、$`j \lt s`$）と書ける | 自作。Bm4：`BM4.BadRoot.exists_pos` |
| `ExpansionContext.getD_getElem?_of_entry?_eq_some` | 定理 | 9 | 1 | 添字の帳簿：`entry?` が `some v` なら `getD` も $`v`$ | 自作 |
| `ExpansionContext.getElem?_copyBlock` | 定理 | 16 | 1 | `copyBlock` の $`j`$ 番目の列。コア 1 か所が match の等式を使う | 自作 |
| `ExpansionContext.inCopy_iff_exists_copyPosition` | 定理 | 23 | 1 | コピー $`q`$ の中 ⟺ ある $`j \lt s`$ で $`x = p + q s + j`$ | 自作。Bm4：`BM4.BadRoot.exists_pos`、`pos_inj` |
| `ExpansionContext.lastIndex` | 定義 | 1 | 12 | 場 $`c`$（長さ − 1） | 自作（場） |
| `ExpansionContext.length_expand` | 定理 | 6 | 1 | $`A[N]`$ の長さは $`p + (N+1) s`$ | 自作。Bm4：`BM4.expand_len`、`tA_len` |
| `ExpansionContext.length_expand_mono` | 定理 | 10 | 1 | 長さは $`N`$ について単調 | 自作（算術） |
| `ExpansionContext.maximalRow` | 定義 | 1 | 12 | 場 $`m_0`$ | 自作（場） |
| `ExpansionContext.parentColumn` | 定義 | 1 | 14 | 場 $`p`$（悪い根） | 自作（場） |
| `ExpansionContext.parentColumn_lt_lastIndex` | 定理 | 4 | 8 | $`p \lt c`$ | 自作。Bm4：`BM4.BadRoot.p_lt_c` |
| `ExpansionContext.parent_eq` | 定理 | 1 | 7 | 場：$`m_0`$ 行での $`c`$ の親は $`p`$ | 自作（場） |
| `ExpansionContext.parent_expandRaw_eq_of_lt_lastIndex` | 定理 | 24 | 1 | $`c`$ より左の列の親は変わらない | Bm4：`BM4.BadRoot.parent_tA_prefix`、または接頭辞の局所性から自作 |
| `exists_expansionContext_of_maximalParentRow_eq_some` | 定理 | 20 | 2 | $`m_0`$ があれば `ExpansionContext` がある | 自作 |

#### Lemma25（BMS の補題 2.5、8 個）

| 名前 | 種類 | 行 | 使う側 | 内容 | 書き直し |
|---|---|---:|---:|---|---|
| `ExpansionContext.Lemma25AtRow.good_to_copy` | 定理 | 1 | 1 | 補題 2.5(i)：$`g \lt p`$ がコピー 0 の $`j`$ 番目の祖先 ⟺ $`A[N]`$ でコピー $`N`$ の $`j`$ 番目の祖先 | Bm4：`BM4.theorem_6_3` の C2 |
| `ExpansionContext.Lemma25AtRow.inside_copy` | 定理 | 1 | 1 | 補題 2.5(ii)：コピーの中の祖先の関係は、コピー 0 とコピー $`N`$ で同じ | C1（$`q = 0`$ と $`q = N`$ で使う） |
| `ExpansionContext.Lemma25AtRow.parent_locality` | 定理 | 1 | 1 | 補題 2.5(iv)：コピー $`N`$ の先頭以外の列の親は、よい部分かコピー $`N`$ の中にある | C5 |
| `ExpansionContext.Lemma25AtRow.previous_to_next` | 定理 | 1 | 1 | 補題 2.5(iii)：$`k \lt m_0`$ で、$`A`$ で $`p+j`$ が $`c`$ の祖先 ⟺ $`A[N]`$ でコピー $`N-1`$ の $`j`$ 番目がコピー $`N`$ の先頭の祖先 | C3 |
| `ExpansionContext.first_copy_ancestor_of_lt` | 定理 | 24 | 1 | $`k \lt m_0`$、$`q \lt q' ≤ N`$ なら、コピー $`q`$ の先頭はコピー $`q'`$ の先頭の $`k`$ 行の祖先 | C3（$`j = 0`$）と C1、C6 で $`q`$ について帰納法 |
| `ExpansionContext.good_to_first_copies_all_rows` | 定理 | 38 | 1 | $`g \lt p`$ とすべての行で、コピー 0 の先頭とコピー $`N`$ の先頭への祖先の関係が同じ | C2（$`j = 0`$） |
| `ExpansionContext.lemma25_all` | 定理 | 6 | 1 | 補題 2.5 がすべての行とすべての $`N`$ で成り立つ | C1、C2、C3、C5 をまとめる |
| `ExpansionContext.parent_first_copies_eq_of_maximalRow_le` | 定理 | 55 | 1 | $`k ≥ m_0`$ なら、コピー $`N`$ の先頭の $`k`$ 行の親は、コピー 0 の先頭の親と同じ（よい部分にある） | C4 と C2 |

#### WellFoundedness（1 個）

| 名前 | 種類 | 行 | 使う側 | 内容 | 書き直し |
|---|---|---:|---:|---|---|
| `StabilityFrame.StrictWellOrder` | 構造 | 8 | 1 | 整礎・推移・三分律の 3 つの場を持つ構造。最終定理の型に現れる | 自作（約 8 行、名前は `Por.StrictWellOrder`） |

### 3.3 入口に届かない名前

次の名前は、入口の定理に届かない宣言だけが使う。書かない。

- 生成と展開の道：`ExpansionEdge`、`ExpansionPath`、`Generated`（`Generated.seed`、`Generated.expand`）、`Step`、`StrictDescent`、`validSeed`。
- 安定性の枠組み：`StabilityFrame`、`StabilityFrame.lt`、`StabilityFrame.lt_wellFounded`、`StableRepresentation` とその場、`RepresentationDescentSystem` とその補題、`GeneratedArray`、`GeneratedStep`、`GeneratedStrictDescent`。
- 種の補題：`expansionPath_endpoints_comparable_of_accessible`、`maximalParentRow_seed_succ`、`parent_seed_one_of_lt`。
- 分解の補題の一部：`copyPosition_strictMono_copy`、`entry?_copyBlock_first_of_ascending`、`entry?_copyBlock_of_not_ascending`。

これらを使うのは、外すモジュール（`ZeroY.BMS.AnyArray` など）と、取り込むモジュールの中の、入口に届かない宣言である。後者は次のとおりで、宣言ごと消すか、短い名前なら自前で書く。

| モジュール | 使う名前 | 扱い |
|---|---|---|
| `ZeroY.BMS.PaddedDescent` | 後半（約 205–315 行）が生成の道（`Step`、`StrictDescent`、`ExpansionPath`）と安定性の枠組みを使う | その宣言を消す |
| `OneY.RelativeBlocker` | `framedStep_wellFounded` が生成の枠組みを使う。別の宣言が `parent_eq_none_iff` を使う | 前者は消す。後者は自作 |
| `ZeroY.Expansion.Context` | `greatestBelow?_some_isGreatest`、場 `maximal_row_eq` | 自作 |
| `OneY.TerminalFrame` | `ExpansionContext` を作るときに場 `maximal_row_eq` を書く | 場を用意する |
| `ZeroY.RoundTrip` | `simp only` の中の `trimHeight_trimZeroRows` | 自作 |

したがって、自前で書く名前は 106 個に、`parent_eq_none_iff`、`greatestBelow?_some_isGreatest`、`trimHeight_trimZeroRows`、場 `maximal_row_eq` などの数個を足したものになる。正確な集合は、取り込んだファイルをビルドしたときの未定義の名前で確かめる。

### 3.4 定義の形への依存

コアは、YesMetaZFC の定義を開いて計算するところがある。

- 定義の等式や match の等式を使う証明項が約 10 個ある。`ancestorChain` が 5 か所、`relativeSupport` が 3 か所、`parentEligible` と `getElem?_copyBlock` が 1 か所ずつである。
- BMS の定義の名前を含む `simp`、`rw`、`unfold` の行が約 69 行ある。

自前の定義は、できるだけ同じ再帰の形にする（同じ引数についての構造的な再帰、同じ場合分けの順）。そうすると等式の補題も同じ形になり、これらの行はそのまま通る。通らない行は、コアの側を直す（Apache-2.0 なので直してよい。直したことは先頭に書く）。

## 4. 順序

### A. BMS の層（新規、`Por/BMS/`）

| # | ファイル | 中身 | 行数の目安 |
|---|---|---|---|
| A1 | `Defs.lean` | `BMSArray`、`entry?`、`rectangular`、`UniformHeight`、支え、`trimHeight`、`trimZeroRows`、`slice`、`greatestBelow?`、`ancestorChain`、`parentEligible`、`parent`、`isAncestor`、`maximalParentRow`、`ascending`、`copyBlock`、`expandRaw`、`expand`。計算できる形で書く | 250 |
| A2 | `Search.lean` | `greatestBelow?` の仕様の補題、`transGen_head` | 120 |
| A3 | `Array.lean` | `RectangularArray`、`ValidArray`（`ext` を含む）、行を落とす補題と高さの補題、`ValidArray.expand`、`raw_expand`、`raw_expand_zero`、`StrictWellOrder` | 450 |
| A4 | `ParentAncestor.lean` | `parent_some_lt`、`parent_some_entry_lt`、`direct_parent_isAncestor`、`isAncestor_lt`、`isAncestor_trans`、`isAncestor_of_lt_row`、`isAncestor_iff_strictAncestor`、`ancestor_le_parent`、局所性の補題、祖先のリストの補題、`parentTransGen_comparable`、行を落とすときの親の補題 | 直接 700–900、A6 経由 300 |
| A5 | `Context.lean` | `ExpansionContext`（場の名前はコアに合わせる）、`blockLength`、`copyStart`、`copyPosition`、`InCopy`、`badPart`、`copiedValue`、`expandRaw` の要素・長さ・親の補題（`Decomposition` の 32 個） | 900–1,200 |
| A6 | `Bm4Bridge.lean`（任意） | Bm4 を 4.33.1 に上げて `Por/Bm4` に置く。`toArr : BMSArray → BM4.Arr r`（$`r`$ は高さ）を作り、`parent`、`isAncestor`、`maximalParentRow`、悪い根、`expandRaw` の要素が Bm4 の `BM4.parent`、`BM4.anc`、`BM4.m₀`、`BM4.badRoot`、`BM4.tildeCol` と一致することを示す | 600–900（ほかに Bm4 の 2.9k 行） |
| A7 | `CopyLemma.lean` | `Lemma25AtRow` の 4 つ、`lemma25_all`、`good_to_first_copies_all_rows`、`first_copy_ancestor_of_lt`、`parent_first_copies_eq_of_maximalRow_le` | A6 経由 300–400、直接 1,500–2,000 |

Bm4 は、同じ数学を別の表し方で形式化している。配列は `Arr r`（長さと、列の関数 $`ℕ → ℕ → ℕ`$、行の数 $`r`$ は固定）で、`parent`、`anc`、`cand` は命題、`m₀`、`badRoot`、`expand` は計算できない。行を落とす操作も無い。そのため、コアが開いて計算する定義（A1）の代わりにはならない。一方で、難しい定理は、対応の補題を通して Bm4 から得られる。`BM4.theorem_6_3` の C1〜C5 は、YesMetaZFC の `Lemma25` の主張に当たる（C1 が `inside_copy`、C2 が `good_to_copy`、C3 が `previous_to_next`、C4 が `parent_first_copies_eq_of_maximalRow_le` の中心、C5 が `parent_locality`）。展開の意味も同じである（同じ $`m_0`$、同じ悪い根、同じ上がる条件、同じ増分、親が無いときの同じ扱い）。違うのは、YesMetaZFC の `expand` が最後に行を落とすことだけである。

### B. コアを取り込む

- **B0（最初に測る）.** Bm4 は Mathlib を import する。A6 の経路を取ると、コアのファイルが Mathlib の見える環境で展開される。simp の結果や名前の解決が変わって、証明が壊れるかもしれない。結合検査はコアの `.olean` を読んだだけで、展開し直していないので、この問いには答えていない。そこで最初に、作業用のパッケージで、無改変のコアと YesMetaZFC を Mathlib v4.33.1 と一緒に置き、コアの一番下のモジュールに `import Mathlib` を足してビルドする。壊れる箇所が少なければ A6 の経路を取る。多ければ、コアが import する BMS の層は Std だけで書く（直接の経路）。直接の経路では、コアは今と同じく Mathlib を見ない。
- **B1.** §2 の 161 モジュールを、そのまま全部コピーする。import の行と `open` の行を機械的に直す。先にビルドしてから外す。外すモジュールが、定数には現れない記法やインスタンスを出しているかもしれないからである。
- **B2.** 層ごとにビルドする。順は、ZeroY の基本のモジュール、ZeroY.Structural、OneY の森と数値、LowerCopy と TerminalCopy、RelativeBlocker、RootIndexed、Dynamics である。層ごとに `leanman build` で緑を確かめる。
- **B3.** 19 モジュールを外し、それを import する行を消す。§3.3 の宣言を消す。§3.4 の行を直す。
- **B4.** `#print axioms` で、`OneY.RootIndexed.actual_expansion_wellFounded` と `OneY.Numeric` の 3 つの定理が `propext`、`Classical.choice`、`Quot.sound` 以外を使わないことを確かめる。

### C. つなぐ

[01-design.md](01-design.md) の §6 の 10 番（`Por/WellOrdering.lean`）を入れる。コアとの結合検査を、このリポジトリの `leanman build` でやり直す。

### 任意の中間段階

移植の前に、Phyrion 氏のリポジトリを lake の git の依存（`subDir = "formalization"`）として参照すれば、最終定理を先にこのリポジトリで得られるかもしれない。結合検査と同じ組み合わせである。未確認で、ビルドのときに YesMetaZFC を取ってくることになる（写しはしない）。ライセンスの無いコードをビルドに使うことをよしとするかは、著作者が判断する。

## 5. 規模

| 部分 | 行数 |
|---|---:|
| 取り込むコア（外す 19 モジュールを除く） | 21,926 |
| 置き換える YesMetaZFC の閉包 | 5,098 |
| 新しい BMS の層（Bm4 経由） | 約 3,000（ほかに Bm4 の版上げ 2,923） |
| 新しい BMS の層（直接） | 約 4,000–5,000 |
| 意味の層（`Por/`、[01-design.md](01-design.md) の §6） | 約 650 |

大きいのは、`Context`（`Decomposition` の置き換え、約 1,000 行）と、コピーの補題（Bm4 経由で約 400 行、直接で約 1,800 行）である。

## 6. 移植のリスク

1. **Mathlib の見える環境.** B0 で測るまで分からない。直接の経路なら避けられる。
2. **定義の形.** §3.4 の約 80 行は、自前の定義の形によっては直す必要がある。
3. **名前の集合.** 106 個は下限である。§3.3 のとおり、取り込むファイルをそのままビルドするには、数個の名前と場が足りない。
4. **ツールチェーン.** Lean 4.33.1 に固定する。コアは Lean 4.30 では 3 か所で壊れる（`ZeroY.Mountain.SumInverse` の omega、`ZeroY.Structural.DecodeTower` の omega、`OneY.Expansion` の展開のエラー）。したがって Bm4（Lean 4.30、約 2.9k 行）を 4.33.1 に上げる。コアを下げることはしない。
5. **ライセンス.**
   - コアは Apache-2.0。ファイルごとに出どころと変更点を書き、`NOTICE` に載せる。
   - YesMetaZFC はライセンスが無い。コードは写さず、翻案もしない。名前と命題の形はコアの使用箇所に合わせる。これで足りるかは著作者の判断である。
   - Bm4 は bms-elem-pattern（CC BY-SA 4.0、koteitan 氏のコード）にある。このリポジトリ（Apache-2.0）に入れるなら、著作者が Apache-2.0 でも出すと決めるか、CC BY-SA のまま `NOTICE` に分けて書く。
6. **規模.** 取り込みは機械的でも 2 万行を超える。層ごとにビルドして、壊れたところをその層の中で直す。

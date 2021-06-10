intro.do > チェック用

data_setup.do > データのセットアップ
synth_y_setup/synth_$outcome.do > アウトカム($outcomeで指定)別のセットアップ
main_synth.do > メインのsynth分析
post_synth > post synth resultsの保存
twoway_graph.do > synthのグラフ作成
basic_placebo.do >　通常のプラシボテストの実施
LOO_Placebo.do > leave one out placeboの実施	
LOO_placebo_graph.do > leave one out placeboの結果グラフ


1.main_synth.doを回す
<内部で回されるもの＞
data_setup.do
synth_y_setup/synth_$outcome.do
post_synth.do (save post synth results)
twoway_graph.do (graph cases 1-3)

2.basic_placebo.doを回す
<内部で回されるもの＞
data_setup.do
synth_y_setup/synth_$outcome.do

＜データとして最後に保存されるもの＞
post_synth/_$donor/_$outcome/basic_plcb_$outcome
graph/_$donor/basic_plcb_$outcome
graph/_$donor/basic_plcb_$outcome.pdf

3.LOO_placebo.doを回す (LOO: leave one out)
<内部で回されるもの＞
data_setup.do
synth_y_setup/synth_$outcome.do

<データとして保存されるもの＞
post_synth/_$donor/gap_$outcome


<R&R対応>

doファイルやフォルダ（synth_y_setup)や保存データ・グラフに_RRや_RR2とつける。

1.1993年を疑似介入年とする分析

main_synth_RR.doを回す
<内部で回されるもの＞
data_setup.do
synth_y_setup_RR/synth_$outcome.do
post_synth_RR.do (save post synth results)
twoway_graph_RR.do (graph cases 1-3)

2.オーストラリア、スペイン、スウェーデン、イギリスを除いてLFPを分析

main_synth_RR2.doを回す
<内部で回されるもの＞
data_setup.do
synth_y_setup_RR2/synth_$outcome.do
post_synth_RR2.do (save post synth results)
twoway_graph_RR2.do (graph cases 1-3)
intro.do > �`�F�b�N�p

data_setup.do > �f�[�^�̃Z�b�g�A�b�v
synth_y_setup/synth_$outcome.do > �A�E�g�J��($outcome�Ŏw��)�ʂ̃Z�b�g�A�b�v
main_synth.do > ���C����synth����
post_synth > post synth results�̕ۑ�
twoway_graph.do > synth�̃O���t�쐬
basic_placebo.do >�@�ʏ�̃v���V�{�e�X�g�̎��{
LOO_Placebo.do > leave one out placebo�̎��{	
LOO_placebo_graph.do > leave one out placebo�̌��ʃO���t


1.main_synth.do����
<�����ŉ񂳂����́�
data_setup.do
synth_y_setup/synth_$outcome.do
post_synth.do (save post synth results)
twoway_graph.do (graph cases 1-3)

2.basic_placebo.do����
<�����ŉ񂳂����́�
data_setup.do
synth_y_setup/synth_$outcome.do

���f�[�^�Ƃ��čŌ�ɕۑ��������́�
post_synth/_$donor/_$outcome/basic_plcb_$outcome
graph/_$donor/basic_plcb_$outcome
graph/_$donor/basic_plcb_$outcome.pdf

3.LOO_placebo.do���� (LOO: leave one out)
<�����ŉ񂳂����́�
data_setup.do
synth_y_setup/synth_$outcome.do

<�f�[�^�Ƃ��ĕۑ��������́�
post_synth/_$donor/gap_$outcome


<R&R�Ή�>

do�t�@�C����t�H���_�isynth_y_setup)��ۑ��f�[�^�E�O���t��_RR��_RR2�Ƃ���B

1.1993�N���^������N�Ƃ��镪��

main_synth_RR.do����
<�����ŉ񂳂����́�
data_setup.do
synth_y_setup_RR/synth_$outcome.do
post_synth_RR.do (save post synth results)
twoway_graph_RR.do (graph cases 1-3)

2.�I�[�X�g�����A�A�X�y�C���A�X�E�F�[�f���A�C�M���X��������LFP�𕪐�

main_synth_RR2.do����
<�����ŉ񂳂����́�
data_setup.do
synth_y_setup_RR2/synth_$outcome.do
post_synth_RR2.do (save post synth results)
twoway_graph_RR2.do (graph cases 1-3)
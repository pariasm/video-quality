
all:
	${MAKE} -C src/utils/imscript
	${MAKE} -C src/1_preprocessing/srcmire_2
	${MAKE} -C src/1_preprocessing/ponomarenko
	${MAKE} -C src/2_stabilization/estadeo_1.1
	${MAKE} -C src/3_oflow/tvl1flow_3
	${MAKE} -C src/4_denoising/vbm3d
	${MAKE} -C src/5_deblurring/fba
	${MAKE} -C src/1_preprocessing/unband
	${MAKE} -C src/6_tonemapping


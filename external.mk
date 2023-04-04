include $(sort $(wildcard $(BR2_EXTERNAL_k1_PATH)/package/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_k1_PATH)/board/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_k1_PATH)/board/*/*/*.mk))


burn-image:
	echo "hello world, i start to burn image"

include $(sort $(wildcard $(BR2_EXTERNAL_Bianbu_PATH)/package/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_Bianbu_PATH)/board/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_Bianbu_PATH)/board/*/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_Bianbu_PATH)/fs/*/*.mk))


burn-image:
	echo "hello world, i start to burn image"

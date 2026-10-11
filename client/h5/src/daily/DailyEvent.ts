
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: AuthorName
// Date: 2020-03-30 21.18:36
////////////////////////////////////////////////////////////////////-

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class DailyEvent
export let DailyEvent = {
	DAILY_REQUEST_PROTO: "DAILY_REQUEST_PROTO",
	RES_FIND_REQUEST_PROTO: "RES_FIND_REQUEST_PROTO",
	OPEN_VIEW: "OPEN_VIEW", DAILY_CLOSE_VIEW: "DAILY_CLOSE_VIEW",
	UPDATE_DAILY_DATA: "UPDATE_DAILY_DATA", 								//更新活跃度数据
	UPDATE_LIVENESS_REWARD: "UPDATE_LIVENESS_REWARD", 					//更新活跃度奖励数据
	UPDATE_RES_FIND_DATA: "UPDATE_RES_FIND_DATA", 						//资源找回数据
	UPDATE_LIVENESS_IMAGE_DATA: "UPDATE_LIVENESS_IMAGE_DATA", 			//更新活跃度形象数据
	RES_FIND_SUCCESS: "RES_FIND_SUCCESS", 								//资源找回成功
	UPDATE_HUOYUEDU_DATA: "UPDATE_HUOYUEDU_DATA", 						//更新活跃度找回数据
	REFRESH_DILY_DOT: "REFRESH_DILY_DOT", 								//更新日常红点
	LIVENESS_UPGRDE_SUCCESS: "LIVENESS_UPGRDE_SUCCESS", 					//活跃度升级成功
	REQUEST_STRONGER_DATA: "REQUEST_STRONGER_DATA",						//请求变强数据
	STRONGER_DATA_RETURN: "STRONGER_DATA_RETURN", 						//变强数据
	UPDATE_OUTLINE_INFO: "UPDATE_OUTLINE_INFO", 							//离线挂机时间更新
	DAILY_SWTICH_VIEW: "DAILY_SWTICH_VIEW", 								//切换选项卡
	CONFIG_IS_LOAD: "CONFIG_IS_LOAD",
	RESERVATION: "RESERVATION",
	DAILY_STRONG_TAB_CLICK: "DAILY_STRONG_TAB_CLICK",					//我要变强选项卡被点击
	DAILY_ORDER_SUCCESS: "DAILY_ORDER_SUCCESS",							//预约成功
	DAILY_UPDATE_ORDER_VIEW: "DAILY_UPDATE_ORDER_VIEW"							//更新预约界面
}

window["DailyEvent"] = DailyEvent
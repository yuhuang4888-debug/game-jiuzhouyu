import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"

import { RoleManager } from "./RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CommonManager } from "../common/CommonManager"


enum attributeLevel {
	PRIMARY = 1,
	MIDDLE = 2,
	ADVANCED = 3,
	TOP = 4
}
enum ATTRIBUTEPOTION_COFIG {
	ATTR = 0,
	LEVEL = 1
}
window["attributeLevel"] = attributeLevel
window["ATTRIBUTEPOTION_COFIG"] = ATTRIBUTEPOTION_COFIG
export class attributePotionModel extends EventDispatcher {
	GetDunConfig
	InitConfig
	_timeData
	_view_Open
	canUseTab
	cleanTimeData
	getAttrConfig
	getItemConfig
	getItemList
	getTimeConfig
	getTimeData
	getTimeDataById
	itemRedDot
	setAllTimeData
	setTimeData
	tabList
	tabRedDot
	useAttribute


	public static REQUEST_USE = "attributePotionModel.REQUEST_USE";
	public static REQUEST_TIME_DATA = "attributePotionModel.REQUEST_TIME_DATA";
	public static TIME_DATA_RETURN = "attributePotionModel.TIME_DATA_RETURN";
	public static CHANGE_ITEM = "attributePotionModel.CHANGE_ITEM";
	public static CLICK_BUTTON = "attributePotionModel.CLICK_BUTTON";
	public static OPEN_ITEM = "attributePotionModel.OPEN_ITEM";
	public static CHANGE_TAB = "attributePotionModel.CHANGE_TAB";
	static Instance: attributePotionModel;
	public constructor() {
		super()


		this.tabList = [{ icon_up_source: "uirw_046_08", icon_down_source: "uirw_046_07", label: "初级", level: attributeLevel.PRIMARY },
		{ icon_up_source: "uirw_046_06", icon_down_source: "uirw_046_05", label: "中级", level: attributeLevel.MIDDLE },
		{ icon_up_source: "uirw_046_04", icon_down_source: "uirw_046_03", label: "高级", level: attributeLevel.ADVANCED },
		{ icon_up_source: "uirw_046_02", icon_down_source: "uirw_046_01", label: "顶级", level: attributeLevel.TOP }]
		this._timeData = [];
		this._view_Open = false;
		let local_Config = Config;
		let local_ATTRIBUTEPOTION_COFIG = ATTRIBUTEPOTION_COFIG
		let local_attributePotionModel = attributePotionModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let goods_model = GoodsModel.GetInstance()
		let local_Message = Message
		let config = []
		this.InitConfig = () => {
			config = []
			// [ts2lua]config下标访问可能不正确
			config[local_ATTRIBUTEPOTION_COFIG.ATTR] = local_Config.PRELOAD_SERVER_CONFIG.config_attr_medicament;
			// [ts2lua]config下标访问可能不正确
			config[local_ATTRIBUTEPOTION_COFIG.LEVEL] = local_Config.PRELOAD_SERVER_CONFIG.config_attr_medicament_use_count;
		}

		this.GetDunConfig = (dun_type?) => {
			// [ts2lua]config下标访问可能不正确
			return config[dun_type]
		}

		this.getItemList = (level?) => {
			let config = this.GetDunConfig(local_ATTRIBUTEPOTION_COFIG.ATTR)
			let list = []
			if (config && Util.TableSize(config) > 0) {
				for (let key in config) {

					if (config[key]) {
						// [ts2lua]config下标访问可能不正确
						let info = config[key]
						if (info && info.lv == level) {
							table.insert(list, info)
						}
					}
				}
				table.sort(list, (a?, b?) => {
					let aIndex = a.good_id
					if (this.itemRedDot(a.lv, a.good_id)) {
						aIndex = aIndex + 1000
					}
					let bIndex = b.good_id
					if (this.itemRedDot(b.lv, b.good_id)) {
						bIndex = bIndex + 1000
					}
					if (aIndex > bIndex) {
						return true
					}
				}
				)
			}
			return list
		}

		this.getItemConfig = (good_id?) => {
			let config = this.GetDunConfig(local_ATTRIBUTEPOTION_COFIG.ATTR)
			for (let key in config) {

				if (config[key]) {
					// [ts2lua]config下标访问可能不正确
					let info = config[key]
					if (info.good_id == good_id) {
						return info
					}
				}
			}
		}

		this.getAttrConfig = (id?) => {
			let config = this.GetDunConfig(local_ATTRIBUTEPOTION_COFIG.ATTR)
			for (let key in config) {

				if (config[key]) {
					// [ts2lua]config下标访问可能不正确
					let info = config[key]
					if (info.good_id == id) {
						return info
					}
				}
			}
			return null
		}

		this.getTimeConfig = (id?) => {
			let config = this.GetDunConfig(local_ATTRIBUTEPOTION_COFIG.LEVEL)
			let level = RoleManager.GetInstance().GetMainRoleVo().level
			for (let key in config) {

				if (config[key]) {
					// [ts2lua]config下标访问可能不正确
					let info = config[key]
					if ((info.good_id == id && level >= info.min_role_lv) && level <= info.max_role_lv) {
						return info
					}
				}
			}
			return null
		}

		this.setTimeData = (data?) => {
			if (data && data.count_list) {
				let info = data.count_list[0]
				// [ts2lua]this._timeData下标访问可能不正确
				this._timeData[info.lv] = data
				this.Fire(local_attributePotionModel.TIME_DATA_RETURN, info.lv)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
			}
		}

		this.cleanTimeData = () => {
			this._timeData = []
		}

		this.setAllTimeData = (data?) => {
			// let nowData = null
			// if (! this._timeData ) {
			// 	this._timeData = []
			// }
			// for (let key in data.count_list) {

			// 	if (data.count_list[key] ) {
			// 		let info = data.count_list[key]
			// 		nowData = null
			// 		nowData = this._timeData[info.lv] && this._timeData[info.lv]["count_list"]
			// 		if (! nowData ) {
			// 			nowData = [info]
			// 			this._timeData[info.lv] = []
			// 		}else{
			// 			table.insert(nowData, info)
			// 		}
			// 		this._timeData[info.lv]["count_list"] = nowData
			// 	}
			// }
			// this.Fire(local_attributePotionModel.TIME_DATA_RETURN, "All")
			// local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
			let nowData;
			if (!this._timeData) this._timeData = {};
			for (let key in data.count_list) {
				if (data.count_list.hasOwnProperty(key)) {
					let info = data.count_list[key];
					nowData = undefined;
					nowData = this._timeData[info.lv] && this._timeData[info.lv]["count_list"];
					if (!nowData) {
						nowData = [info]
						this._timeData[info.lv] = {};
					}
					else {
						let hasKey = false
						for (let key in nowData) {
							if (nowData[key].goods_id == info.goods_id) {
								nowData[key].current_count = info.current_count
								nowData[key].current_day_count = info.current_day_count
								hasKey = true
							}
						}
						if (!hasKey) {
							nowData.push(info);
						}
					}
					this._timeData[info.lv]["count_list"] = nowData;
				}
			}
			this.Fire(local_attributePotionModel.TIME_DATA_RETURN, "All");
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role);
		}

		this.getTimeData = (level?) => {
			// [ts2lua]this._timeData下标访问可能不正确
			let data = this._timeData[level]
			if (!data) {
				this.Fire(local_attributePotionModel.REQUEST_TIME_DATA, level)
				return null
			} else {
				return data
			}
		}

		this.getTimeDataById = (level?, id?) => {
			if (!level) {
				return
			}
			// [ts2lua]this._timeData下标访问可能不正确
			let data = this._timeData[level]
			if (data) {
				for (let key in data.count_list) {

					if (data.count_list[key]) {
						// [ts2lua]data.count_list下标访问可能不正确
						let info = data.count_list[key]
						if (info.goods_id == id) {
							return info
						}
					}
				}
			}
			return null
		}

		this.tabRedDot = (level?) => {
			let flag = false
			let itemList = this.getItemList(level)
			for (let key in itemList) {

				if (itemList[key]) {
					// [ts2lua]itemList下标访问可能不正确
					let info = itemList[key]
					if (this.itemRedDot(info.lv, info.good_id)) {
						flag = true
						break
					}
				}
			}
			return flag
		}

		this.itemRedDot = (level?, good_id?) => {
			let flag = false
			let info = this.getTimeDataById(level, good_id)
			let timeConfig = this.getTimeConfig(good_id)
			if (info && timeConfig) {
				let num = goods_model.GetTypeGoodsNum(good_id)
				if ((num > 0 && info.current_day_count < timeConfig.day_times) && info.current_count < timeConfig.all_times) {
					flag = true
				}
			}
			return flag
		}

		this.canUseTab = () => {
			let flag = false
			let index = 1
			let tabList = this.tabList
			for (let key in tabList) {

				if (tabList[key]) {
					// [ts2lua]tabList下标访问可能不正确
					let info = tabList[key]
					if (this.tabRedDot(info.level)) {
						flag = true
						index = info.level
						break
					}
				}
			}
			return { flag, index }
		}

		this.useAttribute = (good_id?) => {
			let full = false
			let canUseNum = 0
			let goods_vo = goods_model.GetGoodsBasicByTypeId(good_id)
			let num = goods_model.GetTypeGoodsNum(good_id)
			let timeConfig = this.getTimeConfig(good_id)
			let attrConfig = this.getItemConfig(good_id)
			if (!attrConfig) {
				local_Message.show("无此物品")
				return
			}
			let lv = attrConfig.lv
			let timeData = this.getTimeDataById(lv, good_id)
			if (timeConfig && timeData) {
				let lessTime = timeConfig.all_times - timeData.current_count
				full = lessTime == 0
				if (lessTime > 0) {
					canUseNum = timeConfig.day_times - timeData.current_day_count
					// [ts2lua]lua中0和空字符串也是true，此处canUseNum > lessTime需要确认
					canUseNum = canUseNum > lessTime && lessTime || canUseNum
				}
			}
			// [ts2lua]lua中0和空字符串也是true，此处num > canUseNum需要确认
			let useNum = num > canUseNum && canUseNum || num
			if (num <= 0) {
				local_Message.show("道具不足")
			} else if (useNum <= 0) {
				if (full) {
					local_Message.show("已达到使用上限")
				} else {
					local_Message.show("今天已达最大使用次数")
				}
			} else {
				this.Fire(local_attributePotionModel.REQUEST_USE, good_id, useNum, lv)
			}
		}


	}

	public static GetInstance() {

		if (!attributePotionModel.Instance) {
			attributePotionModel.Instance = new attributePotionModel()
		}
		return attributePotionModel.Instance
	}

	public Setview_Open(v?) {

		this._view_Open = v
	}

	public Getview_Open() {

		return this._view_Open
	}

	public GetattributePotionRed() {

		let flag = false
		if(CommonManager.GetInstance().CheckFuncOpenState("attributePotionView", true)){
			let size = Util.TableSize(this._timeData)
			if (size == 0) {
				return flag
			}
			let tabList = this.tabList
			for (let key in tabList) {
	
				if (tabList[key]) {
					// [ts2lua]tabList下标访问可能不正确
					let info = tabList[key]
					if (this.tabRedDot(info.level)) {
						flag = true
						break
					}
				}
			}
		}
		return flag
	}


}

window["attributePotionModel"] = attributePotionModel
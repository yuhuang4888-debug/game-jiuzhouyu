
import { Config } from "../common/Config"
import { CookieWrapper } from "../common/CookieWrapper"
import { GameSettingManager } from "../common/GameSettingManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { SceneManager } from "../scene/SceneManager"
import { ColorType } from "../util/ColorUtil"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { EquipModel } from "./EquipModel"
import { GoodsModel } from "./GoodsModel"


let local_Util = Util
export class SettingModel extends EventDispatcher {
	static Instance:SettingModel

	static SETTING_OPEN_VIEW = "SETTING_OPEN_VIEW"				// 打开设置
	static SETTING_REQUEST_PROTO = "SETTING_REQUEST_PROTO"
	static UPDATE_SETTING_INFO = "UPDATE_SETTING_INFO"
	static UPDATE_ONE_SETTING_INFO = "UPDATE_ONE_SETTING_INFO"
	static SELECT_HEAD_IMG_ITEM = "SELECT_HEAD_IMG_ITEM"
	static CHANGE_NAME_SUCCESS = "CHANGE_NAME_SUCCESS"
	static SELECT_ROLE_HEAD_ICON_SUCCESS = "SELECT_ROLE_HEAD_ICON_SUCCESS"
	static UPDATE_ROLE_HEAD_ICON = "UPDATE_ROLE_HEAD_ICON"
	static CAN_USE_THIS_NAME = "CAN_USE_THIS_NAME"
	static BLOCK_SETTING_CHANGE = "BLOCK_SETTING_CHANGE"
	static SETTING_REQUEST_PROTO_10203 = "SETTING_REQUEST_PROTO_10203"
	static SETTING_REQUEST_PROTO_11305 = "SETTING_REQUEST_PROTO_11305"
	static SETTING_REQUEST_PROTO_11306 = "SETTING_REQUEST_PROTO_11306"
	static UPLOAD_PHOTO = "UPLOAD_PHOTO"
	static UPDATE_CONTENT = "UPDATE_CONTENT"
	static UPDATE_SUBSCRIPTION = "UPDATE_SUBSCRIPTION"//微信订阅推送
	static UPDATE_SUBSCRIPTION_SWITCH = "UPDATE_SUBSCRIPTION_SWITCH"//微信订阅开关

	static BlockSubType = {
		sprite: 1,
		wing: 2,
		shengqi: 3,
		liveness: 5,
		same_screen_role_num: 6,
		effect_num: 7,
		simple_mode: 8,
		sound_open: 9,
		weapon: 10,
        guard: 11,
        sound_effect_open: 12,
        flower: 13,
        demon: 14,
        auto_blue: 17,
        auto_purple: 18,
        auto_orange: 19,
        partner: 20,
        auto_task: 21,
        shield_channel: 22,
        wx_board: 24,
        back: 25,
		shock_screen: 26,

        selfshenqi: 103,
        selfsprite: 104,
        // selfliveness: 105,
        selffeiqi: 106,
        godbefall: 201,
        auto_horse: 202,
    }

	static BlockSubType2GameBlockType = {
		[SettingModel.BlockSubType.sprite]: "sprite",
		[SettingModel.BlockSubType.wing]: "wing",
		[SettingModel.BlockSubType.shengqi]: "shengqi",
		[SettingModel.BlockSubType.liveness]: "liveness",
		[SettingModel.BlockSubType.same_screen_role_num]: "same_screen_role_num",
		[SettingModel.BlockSubType.effect_num]: "effect_num",
		[SettingModel.BlockSubType.sound_open]: "sound_open",
		[SettingModel.BlockSubType.weapon]: "weapon",
		[SettingModel.BlockSubType.guard]: "guard",
		[SettingModel.BlockSubType.sound_effect_open]: "sound_effect_open",
		[SettingModel.BlockSubType.flower]: "flower",
		[SettingModel.BlockSubType.demon]: "demon",
		[SettingModel.BlockSubType.partner]: "partner",
		[SettingModel.BlockSubType.auto_task]: "auto_task",
		[SettingModel.BlockSubType.shield_channel]: "shield_channel",
		[SettingModel.BlockSubType.wx_board]: "wx_board",
		[SettingModel.BlockSubType.back]: "back",
		[SettingModel.BlockSubType.shock_screen]: "shock_screen",
		[SettingModel.BlockSubType.auto_horse]: "auto_horse",
	}

	static SettingType = {
		/**聊天 */
		Channel: 1,
		/**语音自动播放 */
		AudioAutoPlay: 2,
		/**系统 */
		SysSetting: 3,
		/**背包 */
		AutoSmelt: 4
	}

	public static GetInstance() {
		if (!SettingModel.Instance) {
			SettingModel.Instance = new SettingModel()
		}
		return SettingModel.Instance
	}

	public static GetSelfKey(key) {
		return "this" + key
	}

	public static IsSelfKey(key) {
		return key.find("this") != -1
	}

	public static IsClientSubType(sub_type) {
		return sub_type > 100
	}

	cache_setting_list
	effect_num = 15
	other_role_number = 10
	subs_data
	wx_subs_data = {}
	wx_subs_anti_list = {}
	setting_data
	cache_sys_setting_data
	is_shock_screen = 0

	cookie_wrapper = CookieWrapper.GetInstance()
	game_settinng_model = GameSettingManager.GetInstance()

	public constructor() {
		super()

		if (SettingModel.Instance) {
			return
		}
		SettingModel.Instance = this
		
		// let BLOCK_HAS_INIT = CookieWrapper.BLOCK_HAS_INIT
	}

	/**清除数据 */
	public ClearSettingData(){
		this.setting_data = null
		this.cache_sys_setting_data = null
	}
	
	public SetSettingData(data?){
		if (data) {
			if (!this.setting_data) {
				this.setting_data = {}
			}
			if (!this.setting_data[data.type]) {
				this.setting_data[data.type] = {}
			}
			for (let _tmpi in data.setting_list) {
				var vo = data.setting_list[_tmpi]
				this.setting_data[data.type][vo.subtype] = vo
				//设置技能震屏
				if(vo.subtype == 26){
					this.is_shock_screen = vo.is_open
				}
			}
			this.Fire(SettingModel.UPDATE_SETTING_INFO)
		}
	}

	public GetShockScreenFlag(){
		return this.is_shock_screen
	}

	public InitSystemSetting(){
		let data = this.GetSettingData(SettingModel.SettingType.SysSetting)
		if (data.type == SettingModel.SettingType.SysSetting) {
			// let is_simple_mode = this.GetBlockProperty(SettingModel.SettingType.SysSetting, "simple_mode")
			let block_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig
			let value = null
			let default_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.DefaultMode
			if (default_cfg) {
				let setting_list = []
				for (let key in default_cfg) {
					value = default_cfg[key]
					let subtype = block_cfg.BlockSubType[key]
					if (this.setting_data[data.type][subtype]) {
						let is_changed = this.ChangeClientSysSettingMode(subtype, value, this.setting_data[data.type][subtype])
						if (!is_changed) {
							table.insert(setting_list, this.Package10203ItemData(subtype, value))
						}
					}
				}
				this.PackageAndSend10203(data.setting_list)
			}
			if (SceneManager.GetInstance().IsForceBlockScene()) {
				this.EnterForceBlockFunc()
			}
		}
	}

	public UpdataSettingData(scmd?){
		if (scmd && this.setting_data) {
			if (this.setting_data[scmd.type]) {
				if(this.setting_data[scmd.type][scmd.subtype]){
					this.setting_data[scmd.type][scmd.subtype].is_open = scmd.is_open
				}
				else{
					this.setting_data[scmd.type][scmd.subtype] = scmd
				}
			}
			this.Fire(SettingModel.UPDATE_ONE_SETTING_INFO, scmd)
			this.Fire(SettingModel.BLOCK_SETTING_CHANGE, scmd.subtype, scmd.is_open)
		}
	}

	public UpdataSettingDataList(setting_list?){
		if (setting_list) {
			for (let _ in setting_list) {
				var v = setting_list[_]
				this.UpdataSettingData(v)
				if(v.subtype == 26){
					this.is_shock_screen = v.is_open
				}
			}
		}
	}

	public GetSettingData(type){
		return this.setting_data && this.setting_data[type]
	}

	public GetSubSettingData(type, subtype){
		return this.setting_data && this.setting_data[type] && this.setting_data[type][subtype]
	}

	public GetBlockProperty(type?, key?){
		let is_open = 1
		if (type && key && this.setting_data) {
			if (this.setting_data[type]) {
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType
				let subtype = cfg[key]
				let value = this.setting_data[type][subtype]
				if (value) {
					is_open = value.is_open
				}
			}
		}
		return is_open
	}

	public SetBlockProperty(type, key, is_open){
		if (type && key && this.setting_data) {
			if (this.setting_data[type]) {
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType
				let subtype = cfg[key]
				if(subtype){
					if(this.setting_data[type][subtype]){
						this.setting_data[type][subtype].is_open = is_open
					}
				}
			}
		}
	}

	/*
		掉落使用
	*/
	public EquipCanPickUp(vo?){
		if (!vo) {
			return true
		}

		let [goods_Id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.drop_type, vo.type_id)
		let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_Id)

		if (!GoodsModel.GetInstance().IsEquip(goods_basic)) {
			return true
		}

		let color = goods_basic.color || 1
		// check blue
		let blue_open = this.GetBlockProperty(SettingModel.SettingType.SysSetting, "auto_blue")
		if (color <= ColorType.BLUE && blue_open == 0) {
			return false
		}

		// check purple
		let purple_open = this.GetBlockProperty(SettingModel.SettingType.SysSetting, "auto_purple")
		if (color == ColorType.PURPLE && purple_open == 0) {
			return false
		}

		// check orange
		let orange_open = this.GetBlockProperty(SettingModel.SettingType.SysSetting, "auto_orange")
		if ((color == ColorType.ORANGE || color == ColorType.RED) && orange_open == 0) {
			// 只对1星装备有效
			let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
			if (equip_attr_cfg) {
				let star = EquipModel.GetInstance().GetStarByTypeId(vo.type_id, equip_attr_cfg)
				if (star == 1) {
					return false
				}
			}
		}
		return true
	}

	public GetBlockKey(_type?, subtype?){
		let key = null
		if (_type && subtype) {
			let vo = null
			for (let k in Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType) {
				var v = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.BlockSubType[k]//Config.ClientBlockConfig.BlockSubType[k]
				//vo = Config.ClientBlockConfig.BlockSubType[k]
				if (v == subtype) {
					key = k
					break
				}
			}
		}
		return key
	}

	public EnterFullEffectFunc(){
		let is_simple_mode = this.GetBlockProperty(SettingModel.SettingType.SysSetting, "simple_mode")
		let setting_list = this.setting_data && this.setting_data[SettingModel.SettingType.SysSetting]
		if ((setting_list && !this.cache_sys_setting_data) && is_simple_mode == 0) {
			if (setting_list) {
				this.cache_sys_setting_data = []
				for (let key in setting_list) {

					let vo = setting_list[key]
					if (this.IsForceBlockSubType(vo.subtype)) {
						this.cache_sys_setting_data[vo.subtype] = { subtype: vo.subtype, is_open: vo.is_open }
					}
				}
				let effectplayerMode = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig["EffectplayerMode"]
				let blockSubType = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig["BlockSubType"]
				if (effectplayerMode) {
					let is_open = null
					let subtype = null
					let setting_list = []
					for (let key in effectplayerMode) {


						subtype = blockSubType[key]

						if (this.IsForceBlockSubType(subtype)) {

							is_open = effectplayerMode[key] 			//这里面的1是代表显示这个东西

							//这几个不是开关，是数值类型
							if (key != "effect_num" && key != "same_screen_role_num") {
								is_open = is_open == 1 && 0 || 1 	//做下转化，表示开关这个屏蔽项
							}

							let is_changed = this.ChangeClientSysSettingMode(subtype, is_open)
							if (!is_changed) {
								table.insert(setting_list, this.Package10203ItemData(subtype, is_open))
							}
						}
					}
					this.PackageAndSend10203(setting_list)
				}
			}
		}
	}

	public EnterForceBlockFunc(){
		let is_simple_mode = this.GetBlockProperty(SettingModel.SettingType.SysSetting, "simple_mode")
		let setting_list = this.setting_data && this.setting_data[SettingModel.SettingType.SysSetting]
		if ((setting_list && !this.cache_sys_setting_data) && is_simple_mode == 0) {
			if (setting_list) {
				this.cache_sys_setting_data = []
				for (let key in setting_list) {

					let vo = setting_list[key]
					if (this.IsForceBlockSubType(vo.subtype)) {
						this.cache_sys_setting_data[vo.subtype] = { ubtype: vo.subtype, is_open: vo.is_open }
					}
				}
				let multiplayerMode = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig["MultiplayerMode"] //Config.ClientBlockConfig["MultiplayerMode"]
				let blockSubType = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig["BlockSubType"]// Config.ClientBlockConfig["BlockSubType"]
				if (multiplayerMode) {
					let is_open = null
					let subtype = null
					let setting_list = []
					for (let key in multiplayerMode) {


						subtype = blockSubType[key]

						if (this.IsForceBlockSubType(subtype)) {

							is_open = multiplayerMode[key]
							//这几个不是开关，是数值类型
							if (key != "effect_num" && key != "same_screen_role_num") {
								is_open = is_open == 1 && 0 || 1 	//做下转化，表示开关这个屏蔽项
							}

							let is_changed = this.ChangeClientSysSettingMode(subtype, is_open)
							if (!is_changed) {
								table.insert(setting_list, this.Package10203ItemData(subtype, is_open))
							}
						}
					}
					this.PackageAndSend10203(setting_list)
				}
			}
		}
	}

	public ExitForceBlockFunc(){
		let is_simple_mode = this.GetBlockProperty(SettingModel.SettingType.SysSetting, "simple_mode")
		if (is_simple_mode == 0) {
			if (this.cache_sys_setting_data) {
				let cfg = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig
				let setting_list = []
				for (let key in this.cache_sys_setting_data) {

					let vo = this.cache_sys_setting_data[key]
					if (this.IsForceBlockSubType(vo.subtype)) {
						let is_changed = this.ChangeClientSysSettingMode(vo.subtype, vo.is_open)
						if (!is_changed) {
							table.insert(setting_list, this.Package10203ItemData(vo.subtype, vo.is_open))
						}
					}
				}
				this.PackageAndSend10203(setting_list)
				this.cache_sys_setting_data = null
			} else {
				let key = (Laya.Browser.onIOS) && "DefaultModeIOS" || "DefaultMode"
				let mode_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig[key]
				let blockSubType = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig["BlockSubType"]
				let is_open = null
				let subtype = null
				let setting_list = []
				for (let key in mode_cfg) {
					subtype = blockSubType[key]
					if (this.IsForceBlockSubType(subtype)) {
						is_open = mode_cfg[key]
						if (key != "effect_num" && key != "same_screen_role_num") {
							is_open = is_open == 1 && 0 || 1 	//做下转化，表示开关这个屏蔽项
						}

						let is_changed = this.ChangeClientSysSettingMode(subtype, is_open)
						if (!is_changed) {
							table.insert(setting_list, this.Package10203ItemData(subtype, is_open))
						}
					}
				}
				this.PackageAndSend10203(setting_list)
			}
		}
	}

	public Package10203ItemData(subtype?, is_open?, _type?){
		let data = {}
		data["type"] = _type || SettingModel.SettingType.SysSetting
		data["subtype"] = subtype
		data["is_open"] = is_open
		return data
	}

	public PackageAndSend10203(list?){
		if (list.length > 0) {
			this.cache_setting_list = list
			this.Fire(SettingModel.SETTING_REQUEST_PROTO_10203, list)
		}
	}

	public ChangeClientSysSettingMode(subtype?, value?, scmd?){
		if (SettingModel.IsClientSubType(subtype)) {
			// 没有收包，缓存是读不到的
			// || UserMsgAdapter.GetInstance().GetSCMD(10203, true)
			let data = scmd || {}
			data.type = SettingModel.SettingType.SysSetting
			data.subtype = subtype
			data.is_open = value
			this.UpdataSettingData(data)
			return true
		}
		return false
	}

	public IsForceBlockSubType(subtype?){
		let BlockSubType = Config.PRELOAD_CLIENT_CONFIG.ClientBlockConfig.blockSubType// Config.ClientBlockConfig.BlockSubType
		if (!BlockSubType) return false
		return subtype != BlockSubType.sound_open
			&& subtype != BlockSubType.sound_effect_open
			&& subtype != BlockSubType.auto_blue
			&& subtype != BlockSubType.auto_purple
			&& subtype != BlockSubType.auto_orange
			&& subtype != BlockSubType.godbefall
			&& subtype != BlockSubType.auto_horse
			&& subtype != BlockSubType.shield_channel
	}

	/***请求微信订阅状态 */
	public RequestWxSubsState() {

		//订阅开关
		this.Fire(SettingModel.SETTING_REQUEST_PROTO, 11307)

		//所有模板订阅状态
		let data={}
		let cfgs = Config.PRELOAD_SERVER_CONFIG.config_wx_subscribe_temp
		for (let key in cfgs) {
			let vo = cfgs[key]
			data[vo["id"]] = 1
		}

		let list = []
		for (let key in data) {
			table.insert(list, Number(key))
		}

		if (list.length > 0) {
			this.Fire(SettingModel.SETTING_REQUEST_PROTO_11306, list)
		}

	}


	/***检查模块是否是订阅  主要检查temp_id*/
	public CheckWxSubsState(id) {
		let data = this.GetSubscriptionModuleIds2(id)
		let info = this.wx_subs_data["info"]
		if(!info)return false
		for(let key in info){
			if(info[key]==0)continue
			let data2 = this.GetSubscriptionModuleIds2(Number(key))
			if(data.temp_id==data2.temp_id)return true
		}
		return false
	}

	public GetSubscriptionModuleIds2(id) {
		let cfgs = Config.PRELOAD_SERVER_CONFIG.config_wx_subscribe_temp
		let data = cfgs[id]
		return data
	}

	/**微信订阅一共有多少个模板 
	 * @param is_hide_outline 是否隐藏挂机收银配置
	 * return {pos:[cfg,....]}
	*/
	public GetWxPosData(is_hide_outline) {
		let data = {}
		let cfgs = Config.PRELOAD_SERVER_CONFIG.config_wx_subscribe_temp
		for (let key in cfgs) {
			let vo = cfgs[key]

			if (is_hide_outline && vo["desc"] == "离线挂机提醒") {
				continue
			}


			let pos = vo["pos"]
			if (!data[pos]) {
				let list = []
				table.insert(list, vo)
				data[pos] = list
			} else {
				table.insert(data[pos], vo)
			}
		}
		return data
	}

	//微信订阅 根据推送desc获取配置
	public GetWxOutLinePosCfg() {
		return this.GetSubscriptionModuleIds2("132")
	}

	//微信订阅 根据desc获取配置
	public GetWxCfgByDesc(desc) {
		let cfgs = Config.PRELOAD_SERVER_CONFIG.config_wx_subscribe_temp
		for (let key in cfgs) {
			let vo = cfgs[key]
			if (vo["desc"] == desc) {
				return vo
			}
		}
		return null
	}

	/**微信订阅开关 */
	public CheckSubsOpen(){
		let wx_board_open = this.game_settinng_model.GetBlockProperty("wx_board")
		return local_Util.IsWXGame()&&this.wx_subs_data["state"]&&this.wx_subs_data["state"]==1&&!wx_board_open
	}

	public WxSaveAntiKey(temp_id){
		this.wx_subs_anti_list[temp_id]=1
	}
	
	public WxDeleteAntiKey(temp_id){
		delete this.wx_subs_anti_list[temp_id]
	}
	
	/***return  true用户在本次登录中不再拉去权限 false继续帮用户拉取权限 */
	public WxCheckAntiKey(temp_id){
		console.warn(this.wx_subs_anti_list)
		if(this.wx_subs_anti_list[temp_id])return true
		return false
	}


	

}
window["SettingModel"] = SettingModel
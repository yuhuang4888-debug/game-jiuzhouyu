import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { RoleManager } from "./RoleManager"
import { Config } from "../common/Config"

export class FriendInviteModel extends EventDispatcher {
	CheckIconOpenState
	ClearTimeOut
	GetBoostInfo
	GetHelpInfo
	GetInfo
	GetLevelUpInfo
	GetRedDotByType
	GetRedInfo
	GetRedState
	GetRewardByType
	GetShareReward
	GoToWXShare
	InitShareCfg
	RefreshRedDot
	SetBoostInfo
	SetHelpInfo
	SetInfo
	SetLevelUpInfo
	SetRedDot
	SetRedInfo
	SetRewardByType
	ShareOpenState
	ShowWXShare
	StartTimeOut
	TryTriggerShare
	UpdateShareTimes
	IsShowAll

	red_list
	share_is_max
	wx_share_cfg
	wx_share_left_times

	public static SCMD_REQUEST = "FriendInviteModel.SCMD_REQUEST";
	public static OPEN_FRIEND_INVITE_VIEW = "FriendInviteModel.OPEN_FRIEND_INVITE_VIEW";
	public static REFRESH_TAB_DOT = "FriendInviteModel.REFRESH_TAB_DOT";
	public static OPEN_FRIEND_INVITE_SHOP_VIEW = "FriendInviteModel.OPEN_FRIEND_INVITE_SHOP_VIEW";
	public static ICON_TYPE = 340;
	public static UPDATE_WX_SHARE_TIMES = "FriendInviteModel.UPDATE_WX_SHARE_TIMES";
	public static GET_WX_SHARE_REWARD_SUCCESS = "FriendInviteModel.GET_WX_SHARE_REWARD_SUCCESS";
	public static role_count = 8;
	public static red_count = 8;
	public static help_lv_key = 10;
	public static level_lv_key = 180;
	public static boost_lv_key = 60;
	public static currency_type_one = "36255001";
	public static currency_type_two = "36255002";
	public static welfare_type = 3;
	static Instance
	info
	help_info
	level_up_info
	boost_info
	red_info
	first_login = true
	public constructor() {
		super()

		this.wx_share_left_times = 10;
		this.share_is_max = false;
		let local_FriendInviteModel = FriendInviteModel
		let plat_form_mgr = PlatformManager.GetInstance()
		let local_PlatformManager = PlatformManager
		let local_RoleManager = RoleManager.GetInstance()
		let local_Util = Util
		//let redDotBit_ = 0
		let reward_info_ = null
		let timer_out_ = null
		this.red_list = []
		this.SetInfo = (info?) => {
			this.ChangeVar("info", info)
			this.RefreshRedDot(0)
		}

		this.GetInfo = () => {
			return this.info
		}

		this.SetHelpInfo = (info?) => {
			this.ChangeVar("help_info", info)
			this.RefreshRedDot(1)
		}

		this.GetHelpInfo = () => {
			return this.help_info
		}

		this.SetLevelUpInfo = (info?) => {
			this.ChangeVar("level_up_info", info)
			this.RefreshRedDot(2)
		}

		this.GetLevelUpInfo = () => {
			return this.level_up_info
		}

		this.SetBoostInfo = (info?) => {
			this.ChangeVar("boost_info", info)
			this.RefreshRedDot(3)
		}

		this.GetBoostInfo = () => {
			return this.boost_info
		}

		this.SetRedInfo = (info?) => {
			//this:ChangeVar("red_info", info)
			//this:RefreshRedDot(4)
		}

		this.GetRedInfo = () => {
			return this.red_info
		}

		this.SetRedDot = (type?, state?) => {
			this.red_list[type] = state
			let red = false
			if (Util.TableSize(this.red_list) > 0) {
				for (let i in this.red_list) {
					let redstate = this.red_list[i]
					if (redstate) {
						red = true
						break
					}
				}
			}
			if (type != 999)
				this.Fire(local_FriendInviteModel.REFRESH_TAB_DOT, type, this.red_list[type])
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 340, red)
		}

		this.GetRedDotByType = (type?) => {
			return this.red_list[type]
		}

		this.RefreshRedDot = (type?) => {
			let bool = null
			if (type == 0) {
				let info = this.GetInfo()
				if (info) {
					if (info.get_status == 2) {
						bool = true
					}
					if (!bool) {
						for (let _tmpi in info.reward_list) {
							var v = info.reward_list[_tmpi]
							if (v.status == 2) {
								bool = true
								break
							}
						}
					}
				}
			} else if (type == 1) {
				let info1 = this.GetHelpInfo()
				if (info1) {
					for (let _tmpi in info1.reward_list) {
						var vo = info1.reward_list[_tmpi]
						if (vo.status == 2) {
							bool = true
							break
						}
					}
					for (let _tmpi in info1.pos_list) {
						var vo = info1.pos_list[_tmpi]
						if (vo.status == 2) {
							bool = true
							break
						}
					}
				}
			} else if (type == 2) {
				let info2 = this.GetLevelUpInfo()
				if (info2) {
					for (let _tmpi in info2.pos_list) {
						var vo = info2.pos_list[_tmpi]
						if (vo.status == 2) {
							bool = true
							break
						}
					}
				}
			} else if (type == 3) {
				let info3 = this.GetBoostInfo()
				if (info3) {
					if ((info3.reward && info3.reward[0]) && info3.reward[0].count) {
						bool = true
					}
				}
			} else if (type == 4) {
				let info4 = this.GetRedInfo()
				if (info4) {
					for (let _tmpi in info4.red_packet_list) {
						var vo = info4.red_packet_list[_tmpi]
						if (vo.left_gold > 0) {
							bool = true
							break
						}
					}
				}
			}
			this.SetRedDot(type, bool)
		}

		this.GetRedState = () => {
			return Util.TableSize(this.red_list) > 0
		}

		this.TryTriggerShare = () => {
			this.Fire(local_FriendInviteModel.SCMD_REQUEST, 34002)
		}

		this.CheckIconOpenState = () => {
			return !plat_form_mgr.is_alpha && this.ShareOpenState()//Util.IsDebug()// || local_PlatformManager.IsAiFengGamePlatform()) || this.ShareOpenState()) || PlatformManager.GetPlatformName() == "yy_suyou"
		}
		/*
		参数	描述值	功能控制
		cid	1	链端开分享开关注
		cid	2	链端开分享不开关注
		cid	3	链端不开分享开关注
		cid	4	链端不开分享不开关注
		cid	5	微端开分享开关注
		cid	6	微端开分享不开关注
		cid	7	微端不开分享开关注
		cid	8	微端不开分享不开关注
		 */
		//分享是否开启

		this.ShareOpenState = () => {
			let open = false
			if (local_PlatformManager.IsWXGameLink()) {
				let cid = plat_form_mgr.activity_cid
				if (cid) {
					if (((cid == 1 || cid == 2) || cid == 5) || cid == 6) {
						open = true
					}
				}
			}
			else {
				if (ClientConfig && ClientConfig.share_open) {
					open = true
				}
			}
			return open
		}

		this.IsShowAll = () => {
			let is_show = false
			if (local_PlatformManager.IsWXGameLink()) {
				let cid = plat_form_mgr.activity_cid
				if (cid) {
					if (((cid == 1 || cid == 2) || cid == 5) || cid == 6) {
						is_show = true
					}
				}
			}
			if (Util.IsWXGame() || Util.IsQQGame()) is_show = true
			return is_show
		}

		this.GetRewardByType = (type?) => {
			return reward_info_ && reward_info_[type]
		}

		this.SetRewardByType = (scmd?) => {
			if (!reward_info_) {
				reward_info_ = []
			}
			reward_info_[scmd.type] = scmd.reward_list
		}

		this.InitShareCfg = (call_fun?) => {
			if (!this.wx_share_cfg) {
				let cfgs = Config.PRELOAD_SERVER_CONFIG.config_wx_kv
				if (cfgs) {
					this.wx_share_cfg = []
					if (cfgs["1"]) {
						let list = ErlangParser.GetInstance().Parse(cfgs["1"].value)
						this.wx_share_cfg.open_plat_list = list || {}
					}
					if (cfgs["2"]) {
						this.wx_share_cfg.share_times = cfgs["2"].value || 0
					}
					if (cfgs["3"]) {
						let reward = JSON.parse(cfgs["3"].value)
						this.wx_share_cfg.share_reward = reward || {}
					}
				}
				if (call_fun) {
					call_fun()
				}
				else {
					if (call_fun) {
						call_fun()
					}
				}
			}
		}

		this.UpdateShareTimes = (times?) => {
			let call_fun = () => {
				if (this.wx_share_cfg) {
					if (this.wx_share_cfg.share_times) {
						this.wx_share_left_times = this.wx_share_cfg.share_times - times
					}
					this.Fire(local_FriendInviteModel.UPDATE_WX_SHARE_TIMES)
				}
			}
			this.InitShareCfg(call_fun)
		}

		this.ShowWXShare = (call_fun?) => {
			this.InitShareCfg(() => {
				let show = false
				if (!ClientConfig.is_wx_game_link) {
					if (this.wx_share_cfg && this.wx_share_cfg.open_plat_list) {
						let plat_name = local_PlatformManager.GetPlatformName()
						for (let _tmpi in this.wx_share_cfg.open_plat_list) {
							var vo = this.wx_share_cfg.open_plat_list[_tmpi]
							if (plat_name == vo) {
								show = true
								break
							}
						}
					}
				}
				call_fun(show)
			}
			)
		}

		this.GetShareReward = (call_fun?) => {
			this.InitShareCfg(call_fun)
		}

		this.GoToWXShare = () => {
			let sdk_name = plat_form_mgr.sdk_name
			if ((Util.IsWXGame() || Util.IsQQGame()) && window[sdk_name] && window[sdk_name].goShare) {
				let param_str = "invite_role_id=" + local_RoleManager.mainRoleInfo.role_id
				window[sdk_name].goShare(param_str)
			}
			if (this.wx_share_left_times) {
				if (!Util.IsWXGame()) {
					this.StartTimeOut(0)
				} else {
					this.StartTimeOut(3)
				}
			}
		}

		this.StartTimeOut = (time?) => {
			this.ClearTimeOut()
			timer_out_ = setTimeout(() => {
				this.Fire(local_FriendInviteModel.SCMD_REQUEST, 11302)
			}
				, time)
		}

		this.ClearTimeOut = () => {
			if (timer_out_) {
				clearTimeout(timer_out_)
				timer_out_ = null
			}
		}


	}

	public static GetInstance() {

		if (!FriendInviteModel.Instance) {
			FriendInviteModel.Instance = new FriendInviteModel()
		}
		return FriendInviteModel.Instance
	}

}
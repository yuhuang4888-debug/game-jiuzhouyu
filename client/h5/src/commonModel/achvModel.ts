import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { MainFunc } from "./MainUIModel"

export class achvModel extends EventDispatcher {
	AcCategoryCfg
	CheckReddot
	GetAchvDataList
	InitCfg
	Reset
	SetAchvDataList
	public ShowRed
	UpdateAchv
	UpdateDataList
	changeList
	clientCfg
	curAcStage
	redList
	specificList
	public rewardList
	public totalPointList

	public static U_AC_LV = "AM1";
	public static U_AC_LIST = "AM2";
	public static REQUEST_PROTO = "AM3";
	public static U_AC_D = "AM4";
	public static U_ITEM_POS = "AM5";
	public static OP_AC_V = "AM6";
	public static PLAY_ANI = "AM7";
	public static U_AC_REDDOT = "AM8";
	public static U_AC_V = "AM9";
	public static U_STAR_COUNT = "AM10";
	public static OP_V = "AM11";
	public static UPDATE_SPECIFIC = "AM12";
	public static UPDATE_TOTAL_POINT = "AM13";
	public static SHOW_ITEM = "AM14";
	static Instance: any
	public constructor() {
		super()

		if (achvModel.Instance) {
			return
		}
		achvModel.Instance = this
		this.curAcStage = 0;
		this.ShowRed = null;
		this.specificList = [];
		this.changeList = [];
		this.redList = [];
		this.rewardList = [];
		let local_achvModel = achvModel
		let com_msg = CommonManager.GetInstance()
		let local_Config = Config
		let local_role_mgr = RoleManager.GetInstance()
		let local_g_event = GlobalEventSystem
		let local_even_name = EventName
		let acDataList_ = null
		this.InitCfg = () => {
			this.AcCategoryCfg = Config.PRELOAD_SERVER_CONFIG.config_achievement_category
			this.clientCfg = Config.PRELOAD_CLIENT_CONFIG.ClientAchv
		}

		this.SetAchvDataList = (data?) => {
			acDataList_ = []
			if (data) {
				for (let _tmpi in data) {
					var achvVo = data[_tmpi]
					// [ts2lua]acDataList_下标访问可能不正确
					acDataList_[achvVo.category] = achvVo
				}
			}
			this.CheckReddot(false)
			this.Fire(local_achvModel.U_AC_LIST)
		}

		this.GetAchvDataList = () => {
			return acDataList_
		}

		this.UpdateDataList = (list?, achievement_cfg?) => {
			if (list && list.length > 0) {
				let change_flag = false
				let acList = acDataList_
				if (!acList) {
					return
				}
				for (let _tmpi in list) {
					var achvVo = list[_tmpi]
					let curCfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_achievement.name, achvVo.id, false, achievement_cfg)
					if (curCfg) {
						// [ts2lua]this.changeList下标访问可能不正确
						this.changeList[curCfg.category] = true
						// [ts2lua]acList下标访问可能不正确
						// [ts2lua]acList下标访问可能不正确
						if (acList[curCfg.category] && achvVo.id == acList[curCfg.category].id) {
							change_flag = true
							// [ts2lua]acList下标访问可能不正确
							acList[curCfg.category].status = achvVo.status
							// [ts2lua]acList下标访问可能不正确
							acList[curCfg.category].progress = achvVo.progress
							this.Fire(local_achvModel.U_AC_D, achvVo)
						}
						if (achvVo.status == 1 && com_msg.CheckFuncOpenState("AchvEnterView", true)) {
							this.Fire(local_achvModel.SHOW_ITEM, achvVo)
						}
					}
				}
				if (change_flag) {
					this.Fire(local_achvModel.U_ITEM_POS)
					this.CheckReddot(false)
				}
			}
		}

		this.CheckReddot = (not_fire?) => {
			let showRed = false
			if (!com_msg.CheckFuncOpenState("AchvEnterView", true)) {
				this.ChangeVar("ShowRed", false)
				return false
			}
			if (this.redList) {
				let rewardList = this.rewardList
				// [ts2lua]this.redList下标访问可能不正确
				this.redList[-1] = false
				for (let _tmpi in this.rewardList) {
					var rewardVo = this.rewardList[_tmpi]
					if (rewardVo.status == 1 && rewardVo.need_star) {
						showRed = true
						// [ts2lua]this.redList下标访问可能不正确
						this.redList[-1] = true
						break
					}
				}
			}
			if (acDataList_ && this.AcCategoryCfg) {
				let AcDataList = acDataList_
				let role_lv = local_role_mgr.GetMainRoleVo().level
				for (let index in AcDataList) {

					// [ts2lua]AcDataList下标访问可能不正确
					let AchvInfo = AcDataList[index]
					if (AchvInfo.status == 1) {
						// [ts2lua]this.AcCategoryCfg下标访问可能不正确
						let open_cfg = this.AcCategoryCfg[AchvInfo.category]
						let open_lv = 99999999
						if (open_cfg) {
							open_lv = open_cfg.lv
						}
						if (role_lv >= open_lv) {
							showRed = true
							// [ts2lua]this.redList下标访问可能不正确
							this.redList[AchvInfo.category] = true
						}
					} else {
						// [ts2lua]this.redList下标访问可能不正确
						this.redList[AchvInfo.category] = false
					}
				}
			}
			this.Fire(local_achvModel.U_AC_REDDOT, showRed)
			if (this.ShowRed != showRed) {
				this.ChangeVar("ShowRed", showRed)
				local_g_event.Fire(local_even_name.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "AchvEnterView", 0, showRed)
				local_g_event.Fire(local_even_name.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
			}
			return false
		}

		this.UpdateAchv = (data?) => {
			if (data) {
				// [ts2lua]this.specificList下标访问可能不正确
				this.specificList[data.category] = data
				this.Fire(local_achvModel.UPDATE_SPECIFIC, data)
			}
		}

		this.Reset = () => {
			this.curAcStage = 0;
			this.ShowRed = null;
			this.specificList = [];
			this.changeList = [];
			this.redList = [];
		}

	}

	public static GetInstance() {

		if (!achvModel.Instance) {
			achvModel.Instance = new achvModel()
		}
		return achvModel.Instance
	}

}
window["achvModel"] = achvModel
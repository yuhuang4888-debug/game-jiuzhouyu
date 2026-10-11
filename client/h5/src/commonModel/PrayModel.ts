import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { ResManager } from "../common/ResManager"
import { EventDispatcher } from "../util/EventDispatcher"
import { GlobalTimerQuest } from "../util/Util"
import { Config } from "../common/Config"

export class PrayModel extends EventDispatcher {
	InitEvent
	InitOpenLevel
	IsShowRed
	LoadConfig
	SetShowRed
	TimeFunc
	is_show_red
	open_level
	pray_info_list
	pray_reward_dic
	time
	timer
	vip_base
	vip_num
	public static GET_PRAY_INFO = "GET_PRAY_INFO";
	public static GET_PRAY_REWARD = "GET_PRAY_REWARD";
	public static UPDATE_COUNTDOWN = "UPDATE_COUNTDOWN";
	public static SHOW_RED = "SHOW_RED";
	public static PRAY_NOT_OPEN = "PRAY_NOT_OPEN";
	public static PLAY_ANIME = "PLAY_ANIME";
	public static SCMD_REQUEST = "SCMD_REQUEST";
	static Instance: any
	public constructor() {
		super()


		this.pray_info_list = [];
		this.pray_reward_dic = [];
		this.time = 0;
		this.is_show_red = false;
		this.vip_num = [];
		this.vip_base = [];
		this.open_level = 0
		let local_laya = Laya
		let local_PrayModel = PrayModel
		let config_preload_server = Config

		this.InitEvent = () => {
			let timerFunc = () => {
				this.TimeFunc()
			}
			if (!this.timer) {
				this.timer = GlobalTimerQuest.AddPeriodQuest(timerFunc, 1, -1)
			}
			//this.timer.addEventListener(local_laya.TimerEvent.TIMER, timerFunc, this)
		}

		this.TimeFunc = () => {
			this.time = this.time - 1
			if (this.time < 0) {
				this.Fire(local_PrayModel.SCMD_REQUEST, 41501)
				if (this.timer) {
					GlobalTimerQuest.CancelQuest(this.timer)
					this.timer = null
				}
			} else {
				this.Fire(local_PrayModel.UPDATE_COUNTDOWN, this.time)
			}
		}

		this.LoadConfig = () => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_pray
			this.InitOpenLevel(cfg)
		}

		this.InitOpenLevel = (cfgs?) => {
			this.open_level = cfgs[5]["value"]
		}

		this.SetShowRed = (bool?) => {
			this.is_show_red = bool
			RedDotController.ins.up(RedKey.PRAY, bool ? 1 : 0)
		}

		this.IsShowRed = () => {
			return this.is_show_red
		}

	}

	public static GetInstance(): PrayModel {
		if (!PrayModel.Instance) {
			PrayModel.Instance = new PrayModel()
		}
		return PrayModel.Instance
	}

}
window["PrayModel"] = PrayModel
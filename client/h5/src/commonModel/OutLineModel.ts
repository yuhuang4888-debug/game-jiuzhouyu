import { EventDispatcher } from "../util/EventDispatcher"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"
import { DailyModel } from "./DailyModel"
import { DailyEvent } from "../daily/DailyEvent"
import { RoleManager } from "./RoleManager"

export class OutLineModel extends EventDispatcher {
	static Instance

	GetOnhookTime
	GetOutlineFindData
	SetOutlineFindData
	add_time
	cost_goods_type
	exp_effect
	exp_goods_type
	goods_add_time
	goods_type
	instruction_time
	max_outline_time
	min_outline_time
	ol_award_dic
	onhookSetting
	onhookTime
	timer_id
	show_view = false

	public static REQUEST_PROTO = "REQUEST_PROTO";
	public static UPDATE_REDEMPTION_INFO = "UPDATE_REDEMPTION_INFO";
	public static UPDATE_OUTLINE_SETTING = "UPDATE_OUTLINE_SETTING";
	public static REFRESH_EXP_EFFECT = "REFRESH_EXP_EFFECT";
	public constructor() {
		super()
		if (OutLineModel.Instance) {
			return
		}
		this.ol_award_dic = [];
		this.onhookTime = 0;
		this.max_outline_time = 20 * 3600;
		this.min_outline_time = 2 * 3600;
		this.instruction_time = 15 * 3600;
		this.goods_add_time = 5 * 3600;
		this.cost_goods_type = 38070001;
		this.exp_goods_type = 37020001;
		this.goods_type = [38070001, 38070002];
		this.add_time = { [38070001]: 5 * 3600, [38070002]: 2 * 3600 };
		this.onhookSetting = [];
		this.exp_effect = 0
		let outlineFindData_
		this.GetOnhookTime = () => {
			return this.onhookTime || 0
		}

		this.GetOutlineFindData = () => {
			return outlineFindData_
		}

		this.SetOutlineFindData = (scmd?) => {
			if (scmd) {
				//if (scmd.redemption_exp > 0 ) {
				if (Util.IsTableEmpty(outlineFindData_)) {
					outlineFindData_ = { act_id: -1, act_sub: 132, lefttimes: 1, lefttimes_vip: 0, get_exp: 0, reward_lv: 0, config_res_act: { name: "离线经验找回" } }
				}
				this.ol_award_dic.back_count = this.ol_award_dic.back_count - scmd.count
				this.ol_award_dic.back_exp = this.ol_award_dic.back_exp - scmd.exp
				outlineFindData_.get_exp = outlineFindData_.get_exp + scmd.exp
				//if (scmd.type == 2 ) {
				//outlineFindData_.config_res_act["coin_goods"] = "[{0:5,1.0,2:" + scmd.redemption_exp + "}]"
				//outlineFindData_.config_res_act["coin_per"] = "[{0:3,1.0,2:" + scmd.redemption_gold + "}]"	
				//} else if (scmd.type == 1 ) {
				//outlineFindData_.config_res_act["gold_goods"] = "[{0:5,1.0,2:" + scmd.redemption_exp + "}]"
				//outlineFindData_.config_res_act["gold_per"] = "[{0:2,1.0,2:" + scmd.redemption_gold + "}]"
				//}
				//}else{
				//outlineFindData_ = null
				//}
				DailyModel.GetInstance().Fire(DailyEvent.UPDATE_RES_FIND_DATA)
			}
		}
	}

	public ShowExpEffect() {
		let config_afk_kv = Config.PRELOAD_SERVER_CONFIG.config_afk_kv
		let open_lv = Number(config_afk_kv[11].value)
		if (open_lv <= RoleManager.GetInstance().GetMainRoleLevel()) {
			return true
		}
		return false
	}

	public static GetInstance() {
		if (!OutLineModel.Instance) {
			OutLineModel.Instance = new OutLineModel()
		}
		return OutLineModel.Instance
	}

	public RequestItmer(next_time?) {
		if (!next_time) { return }
		let now_time = TimeUtil.getServerTime()
		let time = next_time - now_time
		let OnTimer = () => {
			this.Fire(OutLineModel.REQUEST_PROTO, 13211)
			if (this.timer_id) {
				GlobalTimerQuest.CancelQuest(this.timer_id)
				this.timer_id = null
			}
		}
		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
		this.timer_id = GlobalTimerQuest.AddDelayQuest(OnTimer, time + 1) // 加1s预防时间误差

	}
}
window["OutLineModel"] = OutLineModel
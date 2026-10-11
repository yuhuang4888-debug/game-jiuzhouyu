import { EventName } from "../common/EventName"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Mathf } from "../util/Mathf"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, Split } from "../util/Util"

export enum EnumPushGiftType {
	eYuHun = 1, // 御魂礼包
	eZhuangSheng, // 转生礼包
	eZuoJi, // 坐骑礼包
	eShiHun, // 侍魂礼包
	eTuPu, // 图谱礼包
	eQiangZhe, // 强者礼包
	eTeSe, // 特色礼包
	eDengJi, // 等级礼包
	eShenWu, // 神巫激活礼包
	eShenWuShengJi, // 神巫升阶礼包
	eGongMing, // 共鸣礼包
	eLingShi, // 灵饰礼包
	eJingJie, // 境界礼包 
	eShiYao, // 蜃妖礼包 
}


export class PushGiftModel extends EventDispatcher {
	activity_icon_mgr
	buy_tip_open
	delay_id
	exit_tip_open
	gift_data
	gift_list: any[]
	gift_red
	will_del_gift
	last_request_time
	logout_gift
	next_end_time
	timer

	public static OPEN_VIEW = "PG.OPEN_VIEW"
	public static UPDATE_VIEW = "PG.UPDATE_VIEW"
	public static BUY_SUCCESS = "PG.BUY_SUCCESS"
	public static UPDATE_TAB_RED = "PG.UPDATE_TAB_RED"
	public static SCMD_REQUEST = "PG.SCMD_REQUEST"
	public static UPDATE_MAIN_ICON = "PG.UPDATE_MAIN_ICON"
	public static UPDATE_ICON = "PG.UPDATE_ICON"

	public static readonly ICON_TYPE = 191;

	//特殊激活，需要在激活界面弹出后
	public static Special_Trigger = {
		["partner_cnt"]: true,
		["partner_id"]: true,
		["holyoran_cnt"]: true,
		["holyoran_id"]: true,
		["mate_cnt"]: true,
		["mate_id"]: true,
		["mount_cnt"]: true,
		["mount_id"]: true,
	}
	static Instance: any

	public constructor() {
		super()

		if (PushGiftModel.Instance) {
			return
		}
		PushGiftModel.Instance = this

		this.activity_icon_mgr = ActivityIconManager.GetInstance()

		this.gift_list = []	//礼包列表
		this.gift_data = []	//礼包信息
		this.gift_red = []	//礼包红点
		this.will_del_gift = [] //以及领过的礼包,1 即将从列表中删除，-1已经删除
		this.delay_id = ""	//需要延迟弹窗的礼包id
		this.next_end_time = null
		this.timer = null
		this.logout_gift = []
		this.last_request_time = []

		this.exit_tip_open = true
		this.buy_tip_open = true
	}

	public ReSetModel() {

		this.gift_list = []	//礼包列表
		this.gift_data = []	//礼包信息
		this.gift_red = []	//礼包红点
		this.delay_id = ""	//需要延迟弹窗的礼包id
		this.next_end_time = null
		this.timer = null
		this.logout_gift = []
		this.last_request_time = []

		this.exit_tip_open = true
		this.buy_tip_open = true

		this.activity_icon_mgr.deleteIcon(191)
	}

	public SetGiftList(info?) {

		if (!info) {
			return
		}

		if (!this.gift_list) {
			this.gift_list = []
		}
		for (let i in info) {
			var vo = info[i]
			let left_time = vo.end_time - TimeUtil.getServerTime()
			if (left_time > 0) {
				this.gift_list[vo.gift_id] = this.gift_list[vo.gift_id] || {}
				this.gift_list[vo.gift_id][vo.sub_id] = this.gift_list[vo.gift_id][vo.sub_id] || {}
				//空表代表是第一次添加或登录，需要加个红点
				if (Util.IsTableEmpty(this.gift_list[vo.gift_id][vo.sub_id])) {
					this.SetGiftRed(vo.gift_id, vo.sub_id, 1)
				}
				this.gift_list[vo.gift_id][vo.sub_id] = vo
			}

		}

	}

	public IsGiftListEmpty(): boolean {
		for (let key in this.gift_list) {
			let vo = this.gift_list[key]
			for (let sub in vo) {
				let subVo = vo[sub]
				if (subVo != null) {
					return false
				}
			}
		}
		return true
	}

	/**
	 * 获取该类型礼包最高时间戳
	 * @param gift_id 
	 */
	public GetGiftMaxTimeById(gift_id: number) {
		let lists = this.GetGiftList(gift_id);

		if (!Object.keys(lists).length) {
			return 0;
		}

		let maxTime: number = 0;
		for (const key in lists) {
			if (Object.prototype.hasOwnProperty.call(lists, key)) {
				const gift = lists[key];
				if (gift && gift.end_time > maxTime) {
					maxTime = gift.end_time;
				}
			}
		}

		return maxTime;

	}

	public GetGiftList(gift_id?, sub_id?) {

		//有指定的取指定的
		if (gift_id && sub_id) {
			let _list = this.gift_list[gift_id]
			if (_list) {
				return _list[sub_id]
			}
			return null
		}

		if (gift_id) {
			return this.gift_list[gift_id]
		}

		return this.gift_list
	}

	public DeleteGiftList(gift_id?, sub_id?) {

		if (gift_id && sub_id) {
			if (this.gift_list[gift_id]) {
				this.gift_list[gift_id][sub_id] = null
				if (Util.IsTableEmpty(this.gift_list[gift_id])) {
					this.gift_list[gift_id] = null
				}
			}
			if (this.gift_data[gift_id]) {
				this.gift_data[gift_id][sub_id] = null
				if (Util.IsTableEmpty(this.gift_data[gift_id])) {
					this.gift_data[gift_id] = null
				}
			}
			if (this.gift_red[gift_id]) {
				this.SetGiftRed(gift_id, sub_id, -1)
				this.gift_red[gift_id][sub_id] = null
				if (Util.IsTableEmpty(this.gift_red[gift_id])) {
					this.gift_red[gift_id] = null
				}
			}

			if (Util.IsTableEmpty(this.gift_list)) {
				this.CancelGiftTime()
				let icon = this.activity_icon_mgr.getIconInfo(191)
				if (icon) {
					this.activity_icon_mgr.deleteIcon(191)
				}
			}
		}
	}

	public SetGiftData(data?) {

		if (!data) {
			return
		}

		if (!this.gift_data) {
			this.gift_data = []
		}
		this.gift_data[data.gift_id] = this.gift_data[data.gift_id] || {}
		this.gift_data[data.gift_id][data.sub_id] = data
	}

	public GetGiftData(gift_id?, sub_id?, is_request?) {

		if (gift_id && sub_id) {
			if (this.gift_data[gift_id]) {
				return this.gift_data[gift_id][sub_id]
			}
		}

		if (gift_id && this.gift_list[gift_id]) {
			if (is_request) {
				let cur_request_time = TimeUtil.getServerTime()
				if (!this.last_request_time[gift_id]) {
					this.last_request_time[gift_id] = 0
				}
				if ((cur_request_time - this.last_request_time[gift_id]) > 15) {
					for (let s in this.gift_list[gift_id]) {
						var v = this.gift_list[gift_id][s]
						this.Fire(PushGiftModel.SCMD_REQUEST, 19102, gift_id, s)
					}
					this.last_request_time[gift_id] = cur_request_time
				}
			}

			return this.gift_data[gift_id]
		}

	}

	public SetGiftRed(gift_id?, sub_id?, value?) {

		if (!this.gift_red) {
			this.gift_red = []
		}

		this.gift_red[gift_id] = this.gift_red[gift_id] || {}
		this.gift_red[gift_id][sub_id] = this.gift_red[gift_id][sub_id] || 0
		this.gift_red[gift_id][sub_id] = this.gift_red[gift_id][sub_id] + value
		this.gift_red[gift_id][sub_id] = Mathf.Clamp(this.gift_red[gift_id][sub_id], 0, 1)


		let gift_red = this.GetGiftRed(gift_id)
		this.Fire(PushGiftModel.UPDATE_TAB_RED, gift_id, gift_red > 0)
		let have_red = this.GetGiftRed()
		GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 191, have_red > 0)
		this.Fire(PushGiftModel.UPDATE_MAIN_ICON, 191, have_red > 0)

	}

	public GetGiftRed(gift_id?, sub_id?) {

		//有指定的取指定的
		if (gift_id && sub_id) {
			let red_list = this.gift_red[gift_id]
			if (red_list) {
				return red_list[sub_id]
			}
			return 0
		}

		if (gift_id) {
			if (this.gift_red[gift_id]) {
				for (let _s in this.gift_red[gift_id]) {
					var _v = this.gift_red[gift_id][_s]
					if (_v > 0) {
						return 1
					}
				}
			}
			return 0
		}

		//没有指定的检测全部，是否有红点
		for (let i in this.gift_red) {
			var sub = this.gift_red[i]
			for (let j in sub) {
				var v = sub[j]
				if (v > 0) {
					return 1
				}
			}
		}
		return 0
	}

	public ClearFirstRed(gift_id?) {

		if (gift_id) {
			let _red = this.GetGiftRed(gift_id)
			if (_red > 0) {
				for (let sub_id in this.gift_red[gift_id]) {
					var _v = this.gift_red[gift_id][sub_id]
					this.SetGiftRed(gift_id, sub_id, -1)
				}
			}
		}
	}

	//寻找最近结束的礼包
	public FindGiftTime() {

		let last_time = this.next_end_time
		if (!Util.IsTableEmpty(this.gift_list)) {
			this.next_end_time = null
			for (let i in this.gift_list) {
				var sub = this.gift_list[i]
				for (let j in sub) {
					var v = sub[j]
					if (v != null) {
						if (this.next_end_time == null || (this.next_end_time && v.end_time < this.next_end_time)) {
							this.next_end_time = v.end_time
						}
					}
				}
			}
		}

		if (last_time != this.next_end_time) {
			//更新图标倒计时时间
			this.activity_icon_mgr.addIcon(191, this.next_end_time)
		}
	}

	//检查超时的礼包并删除
	public CheckOverGift() {

		for (let i in this.gift_list) {
			var sub = this.gift_list[i]
			for (let j in sub) {
				var v = sub[j]
				if (v != null) {
					if (v.end_time <= TimeUtil.getServerTime()) {
						this.DeleteGiftList(v.gift_id, v.sub_id)
					}
				}
			}
		}

	}

	public StartGiftTime() {

		this.FindGiftTime()
		//找不到则不开启倒计时，说明礼包列表为空
		if (!this.next_end_time) {
			return
		}
		if (!this.timer) {
			this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnGiftTime()
			}, 1, -1)
		}
		this.OnGiftTime()
	}

	public OnGiftTime() {

		if (!this.next_end_time) {
			this.CancelGiftTime()
			return
		}
		let cur_time = TimeUtil.getServerTime()
		if (this.next_end_time <= TimeUtil.getServerTime()) {
			this.CheckOverGift()
			this.next_end_time = null
			this.FindGiftTime()
		}

	}

	public CancelGiftTime() {

		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
	}

	public SetDelayTips(gift_id?, sub_id?) {

		this.delay_id = gift_id + "@" + sub_id
	}

	//检查是否有需要弹出的弹窗（一般在激活操作结束后调用
	public CheckDelayTips() {

		if (this.delay_id != "") {
			let list = Split(this.delay_id, "@")
			this.Fire(PushGiftModel.OPEN_VIEW, "PushGiftTips", list[1], list[2])
			this.delay_id = ""
		}
	}

	public static GetInstance() {

		if (!PushGiftModel.Instance) {
			PushGiftModel.Instance = new PushGiftModel()
		}
		return PushGiftModel.Instance
	}
}
window["PushGiftModel"] = PushGiftModel
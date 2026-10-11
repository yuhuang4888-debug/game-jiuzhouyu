import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DailyModel } from "../commonModel/DailyModel"
import { DepositModel } from "../commonModel/DepositModel"
import { DailyBottomView } from "../daily/DailyBottomView"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { DepositItem } from "./DepositItem"

export class DepositView extends BaseItem1 {

	_daily_bottom_view
	loop_mgr
	model
	daily_model
	public constructor(parent?) {
		super(parent)
		this.base_file = "deposit"
		this.layout_file = "DepositView"
		this.model = DepositModel.GetInstance()
		this.daily_model = DailyModel.GetInstance()
		this._daily_bottom_view = null
		this.preload_server_config = {
			"config_activity_onhook_module": false,
			"config_ac": false
		}
		this.load_callback = () => {
			this._list_item_con.vScrollBarSkin = ""
			this.txt_deposit_value.style.fontSize = 20
			this.txt_deposit_value.style.wordWrap = false
			this.txt_deposit_value.style.color = "#ffffff"
			this.InitEvents()
			if (!this._daily_bottom_view) {
				this._daily_bottom_view = new DailyBottomView(this.sub_con)
				this._daily_bottom_view.Load()
			}
			this._daily_bottom_view.HideNormalGroupVisble()
			this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19201)
			// this.InitView()
		}
	}

	public InitEvents() {
		var onClickBtnHandler = (target) => {
			let btn = target.currentTarget
			if (btn == this.img_tip) {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.Deposit)
			} else if (btn == this.img_record) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DepositRecordView")
			} else if (btn == this.img_exchange) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DepositExchangeView")
			}
		}
		Util.AddClickEvent(this.img_tip, onClickBtnHandler, this, true)
		Util.AddClickEvent(this.img_record, onClickBtnHandler, this, true)
		Util.AddClickEvent(this.img_exchange, onClickBtnHandler, this, true)

		this.BindEvent(this.model, DepositModel.UPDATE_INFO, (info?) => {
			this.UpdateView()
		})

		this.BindEvent(this.model, DepositModel.UPDATE_DEPOSIT_VALUE, (value?) => {
			this.UpdateDepositValue()
		})
	}

	public UpdateView() {

		// this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19201)
		// let list = this.daily_model.daily_data[ActivityType.Limit]
		// if (list ) {
		// _daily_task = this.daily_model.SortLimitActivityList(list.ac_list)
		// if (! _daily_task ) {
		// 	return
		// }
		let _daily_task = []
		let hook_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_activity_onhook_module", false);
		for (let k in hook_cfg) {
			var cfg = hook_cfg[k]
			let cond = ErlangParser.GetInstance().parse(cfg.condition)
			let is_show = true
			for (let _ = 0; _ < cond.length; _++) {
				var v = cond[_]
				if ("join" == v[0]) {
					for (let i = 0; i < v[1].length; i++) {
						var limit = v[1][i]
						if ("lv" == limit[0] && RoleManager.GetInstance().GetMainRoleVo().level < Number(limit[1])) {
							is_show = false
						} else if ("guild" == limit[0] && RoleManager.GetInstance().GetMainRoleVo().guild_id == 0) {
							is_show = false
						} else if ("open" == limit[0]) {
							let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
							if (openDay >= Number(limit[1][0]) && openDay <= Number(limit[1][1])) {

							} else {
								is_show = false
							}
						} else if ("merge" == limit[0]) {
							let mergeDay = ServerTimeModel.GetInstance().GetMergeServerDay()
							if (mergeDay >= Number(limit[1][0]) && mergeDay <= Number(limit[1][1])) {

							} else {
								is_show = false
							}
						}
					}
				}
			}
			if (is_show) {
				table.insert(_daily_task, cfg)
			}
		}
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this._list_item_con, DepositItem, _daily_task, LoopScrCon.Vertical)
		} else {
			this.loop_mgr.replaceAll(_daily_task)
		}
		// }
	}

	public UpdateDepositValue() {
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_key_value",false)
		let info = cfg[1920002].value
		this.txt_deposit_value.innerHTML = Util.StrToHTML(`<font color='#ffffff'>累计托管值</font>: <font color='#ffdd65'>${this.model.GetDepositValue()}</font><font color='#ffffff'>(今日已获得</font><font color='#ffdd65'>${this.model.GetNowDayDepositValue()}</font><font color='#ffffff'>)</font>`)
	}

	public DeleteMe() {

		if (this._daily_bottom_view) {
			this._daily_bottom_view.DeleteMe()
			this._daily_bottom_view = null
		}

		let data = this.model.GetInfo()
		if (data) {
			for (let i = 0; i < data.activity_list.length; i++) {
				var v = data.activity_list[i]
				if (v.select_time == 0) {
					this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19203, v.module_id, v.sub_module)
				} else {
					this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19202, v.module_id, v.sub_module)
				}
			}
		}
		super.DeleteMe()
	}

	_list_item_con: Laya.List
	sub_con: Laya.Box
	bottom_ui: Laya.Box
	img_exchange: Laya.Image
	img_record: Laya.Image
	txt_deposit_value: Laya.HTMLDivElement
	img_tip: Laya.Image
	img_tip2: Laya.Image
	txt1: Laya.Label
	public GetComponents() {
		[
			this._list_item_con,
			this.sub_con,
			this.bottom_ui,
			this.img_exchange,
			this.img_record,
			this.txt_deposit_value,
			this.img_tip,
			this.img_tip2,
			this.txt1,
		]
			= this.GetChildrenByNames([

				"_list_item_con",
				"sub_con",
				"bottom_ui",
				"img_exchange",
				"img_record",
				"txt_deposit_value",
				"img_tip",
				"img_tip2",
				"txt1",
			])
	}
}
window["DepositView"] = DepositView
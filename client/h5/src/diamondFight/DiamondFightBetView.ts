import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { DiamondFightBetItem } from "./DiamondFightBetItem"
import { DiamondFightRadioItem } from "./DiamondFightRadioItem"

export class DiamondFightBetView extends BaseView1 {

	action_id
	arr_cost

	default_index
	item_list
	now_index
	radio_item_list
	radio_list
	time_id


	diamond_fight_model: DiamondFightModel
	res_mgr: ResManager

	public constructor() {
		super()

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightBetView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.is_center = true
		this.use_background = true
		this.change_scene_close = true
		this.show_open_movie = true
		this.is_center = true


		this.diamond_fight_model = DiamondFightModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.arr_cost = null
		this.default_index = 0
		this.now_index = null
		this.item_list = null
		this.action_id = null
		this.time_id = null

		this.preload_server_config = {
			"config_career": false,
			"config_drumwar_choose": false
		}

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public Remove() {

		this.CancelCountDown()
		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list = null
		}
		if (this.radio_item_list) {
			for (let _tmpi in this.radio_item_list) {
				var obj = this.radio_item_list[_tmpi]
				obj.DeleteMe()
			}
			this.radio_item_list = null
		}

		this.now_index = null
	}

	public LoadSuccess() {

		//resource/game/diamondFight/texture/ui_content_bg2.png
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("diamondFight", "ui_content_bg2"))

		this._panel_item.vScrollBarSkin = ""

		this.InitView()
		this.InitEvent()
		this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13719)

		this._lb_title.fontSize = 32
		ResManager.GetInstance().LoadFont(this, "diamond_fight_1", this._lb_title, 32)

	
	}

	public InitEvent() {


		this.BindVar(this.diamond_fight_model, "waiting_info", () => {
			this.UpdateView()
		})

		this.BindVar(this.diamond_fight_model, "gamble_data", (event_name?, value?) => {
			this.UpdateView()
		})

		Util.AddClickEvent(this._img_close,()=>{
			this.Close()
		},this, true)
	}

	public InitView() {
		let config_drumwar_choose = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_choose", false)
		let cfg = config_drumwar_choose
		let list = []
		for (let key in cfg) {

			let value = cfg[key]
			if (value) {
				let input =JSON.parse(value.input)[0][2]
				let output =JSON.parse(value.output)[0][2]
				table.insert(list, { id: value.id, input: input, output: output })
			}
		}

		if (!this.radio_item_list) {
			this.radio_item_list = []
		}

		let item
		let call_func = (index?) => {
			this.SwitchRadioItem(index)
		}
		this.radio_list = list
		for (let index = 0; index < list.length; index++) {
			var v = list[index]
			item = this.radio_item_list[index]
			if (item == null) {
				item = new DiamondFightRadioItem(this._box_cost)
				this.radio_item_list[index] = item
				item.SetPosition(Number(index) * 150, 0)
				item.Load()
			}
			item.SetData(v, index, call_func)
		}

		this.SwitchRadioItem(this.default_index)
		this.UpdateView()
	}

	public SwitchRadioItem(index?) {

		if (this.now_index == index) {
			return
		}
		let item = this.radio_item_list[this.now_index]
		if (item) {
			item.SetSelect(false)
		}

		item = this.radio_item_list[index]
		if (item) {
			item.SetSelect(true)
		}

		this.now_index = index
		this.UpdateCost()
	}

	public UpdateCost() {

		let data = this.radio_list[this.now_index]
		if (data) {
			this._lb_get.text = data.output
		}
	}

	public UpdateView() {

		if (!this.diamond_fight_model.gamble_data) {
			return
		}
		let data = this.diamond_fight_model.gamble_data.data
		let action_id = 0
		let type = 0
		let end_time = 0
		let wait_tip_info = this.diamond_fight_model.wait_tip_info
		if (wait_tip_info) {
			action_id = wait_tip_info.action
			type = wait_tip_info.type
			end_time = wait_tip_info.end_time
		}

		// let data = this.diamond_fight_model.GetGambleData()
		// let action_id = 9
		// let type = 2
		// let end_time = TimeUtil.getServerTime() + 60*60*24

		this.action_id = action_id
		let is_stage = false
		if (type == 2) {
			is_stage = true
			this.StartCountDown(() => {
				let left_time = end_time - TimeUtil.getServerTime()
				if (left_time < 0) {
					this.CancelCountDown()
					return
				}
				this._lb_left_time.text = "（剩余" + left_time + "秒）"
			})

		} else {
			this.CancelCountDown()
			this._lb_left_time.text = "当前轮次竞猜阶段已过"
		}
		this._lb_title.text = (action_id - DiamondFightModel.HAIXUAN_ROUNDS) + "a4"

		let zone_list = data[action_id]
		let list = []
		if (!this.item_list) {
			this.item_list = []
		}
		if (zone_list) {
			for (let _tmpi in zone_list) {
				var vo = zone_list[_tmpi]
				if (vo.arid != 0 && vo.brid != 0) {
					table.insert(list, vo)
				}
			}
		}
		let i = list.length
		if (i < this.item_list.length) {
			do {
				this.item_list[i].SetVisible(false)
				i = i + 1
			} while ((i < this.item_list.length)
			)
		}
		let item = null
		let is_bet = false
		for (let _tmpi in list) {
			var value = list[_tmpi]
			if (value.suprid > 0) {//and value.suprid != 0
				is_bet = true
				break
			}
		}
		let bet_func = (role_id?) => {
			this.Bet(role_id)
		}
		for (let key in list) {

			let value = list[key]
			item = this.item_list[key]
			if (!item) {
				item = new DiamondFightBetItem(this._panel_item)
				item.Load()
				this.item_list[key] = item
				item.SetPosition(0, Number(key) * 120)
			}
			item.SetData(value, is_bet, bet_func, is_stage)
			item.SetVisible(true)
		}
	}

	public CancelCountDown() {

		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	public StartCountDown(func?) {

		this.CancelCountDown()
		this.time_id = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
		func()
	}

	public Bet(role_id?) {

		if (!role_id || role_id == 0) {
			Message.show("请先选择押注对象～")
			return
		}
		if (!this.diamond_fight_model.IsInBetState()) {
			Message.show("当前不在竞猜阶段!")
			return
		}
		let radio_data = this.radio_list && this.radio_list[this.now_index]
		if (radio_data) {
			this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13720, radio_data.id, role_id, this.action_id)
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_lb_desc: Laya.Label
	_lb_left_time: Laya.Label
	_lb_title: Laya.Label
	_lb_cost_desc: Laya.Label
	_lb_get: Laya.Label
	_box_cost: Laya.Box
	_img_icon: Laya.Image
	_img_close: Laya.Image
	_panel_item: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._lb_desc,
			this._lb_left_time,
			this._lb_title,
			this._lb_cost_desc,
			this._lb_get,
			this._box_cost,
			this._img_icon,
			this._img_close,
			this._panel_item,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_lb_desc",
				"_lb_left_time",
				"_lb_title",
				"_lb_cost_desc",
				"_lb_get",
				"_box_cost",
				"_img_icon",
				"_img_close",
				"_panel_item",
			])
	}
}
window["DiamondFightBetView"] = DiamondFightBetView
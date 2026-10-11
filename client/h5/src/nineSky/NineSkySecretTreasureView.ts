import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class NineSkySecretTreasureView extends BaseView1 {

	count_down_id
	item_list
	type


	goods_model: GoodsModel
	nine_sky_model: NineSkyModel
	public constructor() {
		super()
		this.base_file = "nineSky"
		this.layout_file = "NineSkySecretTreasureView"
		this.layer_value = Enum_UILayer.Activity

		this.destroy_imm = true
		this.change_scene_close = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true

		this.nine_sky_model = NineSkyModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()

		this.item_list = null
		this.type = null
		this.count_down_id = null

		this.preload_server_config = {
			"config_nine": false,
			"config_nine_key_value": false,
		}


		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public LoadSuccess() {


		this._html_count_down.style.color = "#663915"
		this._html_count_down.style.fontSize = 22
		this._html_count_down.style.wordWrap = false

		this._html_get.style.color = "#663915"
		this._html_get.style.fontSize = 22
		this._html_get.style.wordWrap = false

		this._panel_item.hScrollBarSkin = ""

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

		this.BindVar(this.nine_sky_model, "top_info", (event_name?, now_value?) => {
			if (this.type == 0) {
				this.UpdateTopInfo()
			}
		})

		this.BindVar(this.nine_sky_model, "notify_info", (event_name?, now_value?) => {
			if (this.type == 1) {
				this.UpdateNotifyInfo()
			}
		})
	}

	public UpdateView() {
		this.CancelTime()
		let list = []
		if (this.type == 1) {
			this._lb_title.text = "首位登顶"
			this._lb_tips.text = "首个进入第九层的玩家可以获得"
			let nine_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_nine", false)
			let cfg = nine_cfg[this.nine_sky_model.server_type + "@" + NineSkyModel.MaxFloor]
			list = JSON.parse(cfg.first_award)
			this._html_count_down.visible = false
			this._html_get.y = 105
			this.UpdateNotifyInfo()
		} else {
			this._lb_tips.text = "持有顶层秘宝归属的玩家可以获得"
			let nine_key_value_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_nine_key_value", false)
			let reward = nine_key_value_cfg[3].value
			list = JSON.parse(reward)
			this._html_count_down.visible = true
			this._html_get.y = 85
			this.UpdateTopInfo()
		}

		let len = list.length
		if (!this.item_list) {
			this.item_list = []
		}
		let i = len
		if (i < this.item_list.length) {
			do {
				this.item_list[i].SetVisible(false)
				i = i + 1
			} while ((i < this.item_list.length))
		}

		if (len > 0) {
			for (let key in list) {
				let item = this.item_list[key]
				if (!item) {
					item = new EquipmentItem(this._panel_item)
					item.SetItemSize(85, 85)
					this.item_list[key] = item
					item.Load()
				}
				let vo = list[key]
				let [type_id, lock] = this.goods_model.GetMappingTypeId(vo[0], vo[1])
				let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo[2], lock)
				}
				item.SetPosition(Number(key) * 90, 0)
				item.SetVisible(true)
			}
		}

		if (len <= 5) {
			this._panel_item.width = len * 90
		}
		else {
			this._panel_item.width = 460
		}
	}

	public UpdateTopInfo() {
		let info = this.nine_sky_model.GetTopInfo()
		if (info) {
			this._lb_title.text = `顶层秘宝${info.index}`
			let role_name
			if (info.role_id == 0) {
				role_name = "虚位以待"
			}
			else {
				if (this.nine_sky_model.server_type > 1) {
					role_name = `s${info.server_num}.${info.role_name}`
				}
				else {
					role_name = info.role_name
				}
			}
			this._html_get.innerHTML = `&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;获得者：<font color='#0a953e'>${role_name}</font>`
			if (info.left_time) {
				this.StartTime(info.left_time)
			} else {
				this._html_count_down.innerHTML = `结算倒计时：<font color='#0a953e'>--</font>`
			}
		}
		else {
			this._html_get.innerHTML = `&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;获得者：<font color='#0a953e'>虚位以待</font>`
		}
	}

	public UpdateNotifyInfo() {
		let info = this.nine_sky_model.GetNotifyInfo()
		if (info) {
			let first_player_name = info.first_player
			if (!first_player_name) {
				first_player_name = "暂无登顶"
			}
			else if (info.first_server_num && this.nine_sky_model.server_type > 1) {
				first_player_name = `s${info.first_server_num}.${first_player_name}`
			}

			this._html_get.innerHTML = `&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;获得者：<font color='#0a953e'>${first_player_name}</font>`
		}
		else {
			this._html_get.innerHTML = `&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;获得者：<font color='#0a953e'>虚位以待</font>`
		}
	}

	public Remove() {
		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list = null
		}
		this.CancelTime()
	}

	public StartTime(end_time) {
		this.CancelTime()
		let loop_func = () => {
			let left_time = end_time - TimeUtil.getServerTime()
			if (left_time < 0) {
				this.CancelTime()
				this._html_count_down.innerHTML = `结算倒计时：<font color='#0a953e'>--</font>`
				this._html_get.innerHTML = `&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;获得者：<font color='#0a953e'>虚位以待</font>`
				return
			}
			this._html_count_down.innerHTML = `结算倒计时：<font color='#0a953e'>${TimeUtil.convertTime(left_time)}</font>`
		}
		this.count_down_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
		loop_func()
	}

	public CancelTime() {
		if (this.count_down_id) {
			GlobalTimerQuest.CancelQuest(this.count_down_id)
			this.count_down_id = false
		}
	}

	public Open(...new_args) {
		let parms = new_args
		this.type = parms[0]
		super.Open()
	}
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_lb_title: Laya.Label
	_lb_tips: Laya.Label
	_img_close: Laya.Image
	_panel_item: Laya.Panel
	_html_get: Laya.HTMLDivElement
	_html_count_down: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._lb_title,
			this._lb_tips,
			this._img_close,
			this._panel_item,
			this._html_get,
			this._html_count_down,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_lb_title",
				"_lb_tips",
				"_img_close",
				"_panel_item",
				"_html_get",
				"_html_count_down",
			])
	}
}

window["NineSkySecretTreasureView"] = NineSkySecretTreasureView
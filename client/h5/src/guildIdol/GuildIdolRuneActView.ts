import { BaseView1, OpenMode } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"
import { GuildIdolRuneActItem } from "./GuildIdolRuneActItem"
import { GuildIdolRuneSmallItem } from "./GuildIdolRuneSmallItem"

export class GuildIdolRuneActView extends BaseView1 {
	Emp_btn
	Emp_gp_btn
	InitEvent
	Out_lb_btn
	Scr_Scroller1
	click_bg_toClose
	destroy_callback
	destroy_imm
	initView
	is_center
	open_callback
	open_mode
	use_background
	need_lv

	public constructor() {
		super()

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneActView"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		let _model = GuildModel.GetInstance()
		let attr_ac = null
		let item_list = []
		let god_id = null
		//let need_lv = null
		let local_GuildEvent = GuildEvent
		let isMax = false
		this.load_callback = () => {

			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._close, () => {
				this.Close()
			}
				, this, true)

			Util.AddClickEvent(this._gp_btn, () => {
				if (isMax) {
					return
				}
				_model.Fire(local_GuildEvent.REQUEST_PROTO, 40509, "ch", god_id, this.need_lv)
			}
				, this, true)

			this.BindEvent(_model, local_GuildEvent.IDOL_RUNE_RETURN, () => {
				this.initView()
			}
			)

			this.BindEvent(_model, local_GuildEvent.IDOL_RUNE_LV_ACT, () => {
				//this.AddUIEffect("UI_1102_jihuochenggong", this._gp_ef)
				Message.show("成功点亮")
			}
			)
		}

		this.open_callback = () => {
			this.initView()
		}

		this.initView = () => {
			let rune_act_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune_achievement
			god_id = _model.RunePos.god_id
			let attr_data = []
			for (let key in rune_act_cfg) {

				let info = rune_act_cfg[key]
				if (info.god_id == god_id) {
					table.insert(attr_data, info)
				}
			}
			table.sort(attr_data, (a?, b?) => {
				return a.need_lv < b.need_lv
			})
			let cfg
			[this.need_lv, cfg, isMax] = _model.runeActNeedLv(god_id, attr_data)
			if (!attr_ac) {
				attr_ac = new LoopScrowViewMgr(this.layer_value)
				attr_ac.SetData(this._attr_list, GuildIdolRuneActItem, attr_data, LoopScrCon.Vertical)
			} else {
				attr_ac.replaceAll(attr_data)
			}

			let godRuneDta = _model.getIdolRune(god_id)
			if (godRuneDta && godRuneDta.rune_list) {
				for (let i = 0; i < 6; i++) {
					let item = item_list[i]
					if (!item) {
						item = new GuildIdolRuneSmallItem(this._gp_item)
						item.Load()
						table.insert(item_list, item)
					}
					let type_id = null
					for (let key in godRuneDta.rune_list) {

						let rune = godRuneDta.rune_list[key]
						if (rune.pos == i+1) {
							type_id = rune.goods_type_id
						}
					}
					item.setData(type_id, true, this.need_lv)
				}
			}

			this._red.visible = _model.runeActCanUp(god_id, rune_act_cfg)
			Util.SetImageGray(this._img_btn, isMax)
			this._lb_btn.text = (isMax && ('已满级') || ("点亮"))
		}

		this.destroy_callback = () => {
			if (attr_ac) {
				attr_ac.DeleteMe()
				attr_ac = null
			}

			for (let key in item_list) {

				let item = item_list[key]
				item.DeleteMe()
			}
			item_list = []

			_model.RunePos = []
		}


	}

_Image1:Laya.Image
_img_title_bg:Laya.Image
_lb_title:Laya.Label
_Group2:Laya.Box
_Image5:Laya.Image
_Label1:Laya.Label
_gp_item:Laya.HBox
_Image5_bg2:Laya.Image
_attr_list:Laya.List
_gp_ef:Laya.Box
_Label1_t2:Laya.Label
_gp_btn:Laya.Box
_btn:Laya.Box
_img_btn:Laya.Image
_lb_btn:Laya.Label
_red:Laya.Image
_close:Laya.Box
_Image1111:Laya.Image
public GetComponents() {
[
this._Image1,
this._img_title_bg,
this._lb_title,
this._Group2,
this._Image5,
this._Label1,
this._gp_item,
this._Image5_bg2,
this._attr_list,
this._gp_ef,
this._Label1_t2,
this._gp_btn,
this._btn,
this._img_btn,
this._lb_btn,
this._red,
this._close,
this._Image1111,
]
 = this.GetChildrenByNames([

"_Image1",
"_img_title_bg",
"_lb_title",
"_Group2",
"_Image5",
"_Label1",
"_gp_item",
"_Image5_bg2",
"_attr_list",
"_gp_ef",
"_Label1_t2",
"_gp_btn",
"_btn",
"_img_btn",
"_lb_btn",
"_red",
"_close",
"_Image1111",
])
}
}
 window["GuildIdolRuneActView"]= GuildIdolRuneActView
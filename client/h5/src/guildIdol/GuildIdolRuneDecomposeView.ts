import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { GuildCheckBox } from "../guild/GuildCheckBox"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { Util } from "../util/Util"
import { GuildIdolRuneDecItem } from "./GuildIdolRuneDecItem"

export class GuildIdolRuneDecomposeView extends BaseView1 {
	CheckBoxHandle
	Empdecompose_gp
	InitCheckBox
	InitEvent
	LoadSuccess
	Out_Label2
	RefuseDecomposeList
	click_bg_toClose
	destroy_callback
	destroy_imm
	initItem
	is_center
	open_callback
	open_mode
	use_background

	public constructor() {
		super()

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneDecomposeView"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		let _model = GuildModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let decompose_list = []
		let CheckColor = [
			{ quality: 3, name: "紫色", key: "purple" },
			{ quality: 4, name: "橙色", key: "orange" },
			{ quality: 5, name: "红色", key: "red" }
		]
		let item_ac = null
		let local_GuildEvent = GuildEvent
		let local_GoodsModel = GoodsModel
		let show_item_list = []
		let dec_dic = []
		let box_list = []

		this.open_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.close_img, () => {
				this.Close()
			}
				, this, true)

			Util.AddClickEvent(this.decompose_gp, () => {
				if (decompose_list.length > 0) {
					goods_model.Fire(GoodsModel.RESOLVE_GOODS, decompose_list)
				} else {
					Message.show("当前没有选择可以分解的铭文")
				}
			}
				, this, true)

			this.BindEvent(_model, local_GuildEvent.IDOL_RUNE_DEC_CHANGE, () => {
				this.RefuseDecomposeList()
			})

			this.BindEvent(goods_model, local_GoodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
				_model.IdolRune_dec_goods_list = []
				_model.IdolRune_dec_color_list = []
				//this:AddUIEffect("ui_fenjiechenggong_glow", this._gp_effect)
				if (dec_dic != []) {
					for (let key in dec_dic) {

						let num = dec_dic[key]
						let goods_vo = goods_model.GetGoodsBasicByTypeId(key)
						if (goods_vo) {
							let color = ColorUtil.GetColorLight(goods_vo.color)
							Message.show("<font color=\"#ffffff\">获得</font> <font color=" + color + ">" + goods_vo.goods_name + " x" + num + "</font>")
						}
					}
				}

				let check_index=0
				let data = CheckColor[check_index]
				this.initItem()
				_model.changeRuneDecColor(data.quality)
				box_list[check_index].SetSelect(true)
			}
			)
		}

		this.LoadSuccess = () => {
			//this.RegisterMask(this._Viewport1)
			this.initItem()
			this.InitCheckBox()
		}

		this.destroy_callback = () => {
			if (item_ac) {
				item_ac.DeleteMe()
				item_ac = null
			}

			for (let key in show_item_list) {

				let item = show_item_list[key]
				item.DeleteMe()
			}
			show_item_list = []

			for (let key in box_list) {

				let item = box_list[key]
				item.DeleteMe()
			}
			box_list = []

			_model.IdolRune_dec_goods_list = []
			_model.IdolRune_dec_color_list = []

			dec_dic = []
		}

		this.initItem = () => {
			let data = goods_model.guildRuneList
			table.sort(data, (a?, b?) => {
				return b.type_id < a.type_id
			})

			if (!item_ac) {
				item_ac = new LoopScrowViewMgr(this.layer_value)
				item_ac.SetData(this._list_gp, GuildIdolRuneDecItem, data, LoopScrCon.Vertical)
			} else {
				item_ac.replaceAll(data)
			}
			this.empty_gp.visible = data.length <= 0
		}

		this.InitCheckBox = () => {
			let index = 0
			for (let _tmpi in CheckColor) {
				var data = CheckColor[_tmpi]
				let item:GuildCheckBox = box_list[index]
				if (!item) {
					item = new GuildCheckBox(this.cb_gp)
					item.Load()
					item.SetData(data)
					item.SetCallBack((evt?,boo?) => {
						this.CheckBoxHandle(evt,boo)
					})
					if (index == 0) {
						item.SetSelect(true)
						//_model:changeRuneDecColor(data.quality)
					}
					table.insert(box_list, item)
					index = index + 1
				}
			}
			this.cb_gp.x=145
		}

		this.CheckBoxHandle = (quality?,boo?) => {
			_model.changeRuneDecColor(quality, boo)
		}

		this.RefuseDecomposeList = () => {
			decompose_list = _model.getRuneDecList()
			dec_dic = _model.getRuneDecShow(decompose_list)
			let index = 0

			for (let i = 0; i < show_item_list.length; i++) {
				let item = show_item_list[i]
				item.SetVisible(false)
			}


			for (let key in dec_dic) {

				let goods_num = dec_dic[key]
				let item = show_item_list[index]
				if (!item) {
					item = new BaseAwardItem(this._show_gp)
					item.Load()
					item.SetScale(0.6)
					table.insert(show_item_list, item)
				}
				item.SetVisible(true)
				item.SetData(key, goods_num)
				index = index + 1
			}
		
		}


	}

	public DeleteMe() {
		super.DeleteMe()
	}

_bg_img:Laya.Image
_img_split1:Laya.Image
_img_split2:Laya.Image
_img_title_bg:Laya.Image
_lb_title:Laya.Label
_lb_title2:Laya.Label
_Image4:Laya.Image
_list_gp:Laya.List
empty_gp:Laya.Box
_Image5:Laya.Image
_Label1:Laya.Label
cb_gp:Laya.HBox
_Scroller2:Laya.Panel
_show_gp:Laya.HBox
decompose_gp:Laya.Box
_Image8:Laya.Image
_Label2:Laya.Label
_effect_gp:Laya.Box
close_img:Laya.Image
_gp_effect:Laya.Box
public GetComponents() {
[
this._bg_img,
this._img_split1,
this._img_split2,
this._img_title_bg,
this._lb_title,
this._lb_title2,
this._Image4,
this._list_gp,
this.empty_gp,
this._Image5,
this._Label1,
this.cb_gp,
this._Scroller2,
this._show_gp,
this.decompose_gp,
this._Image8,
this._Label2,
this._effect_gp,
this.close_img,
this._gp_effect,
]
 = this.GetChildrenByNames([

"_bg_img",
"_img_split1",
"_img_split2",
"_img_title_bg",
"_lb_title",
"_lb_title2",
"_Image4",
"_list_gp",
"empty_gp",
"_Image5",
"_Label1",
"cb_gp",
"_Scroller2",
"_show_gp",
"decompose_gp",
"_Image8",
"_Label2",
"_effect_gp",
"close_img",
"_gp_effect",
])
}
}
 window["GuildIdolRuneDecomposeView"]= GuildIdolRuneDecomposeView
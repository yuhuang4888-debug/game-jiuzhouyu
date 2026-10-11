import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { DungeonEnterViewIndex } from "../commonModel/BaseDungeonModel"
import { CompositeSelectEquipItem } from "./CompositeSelectEquipItem"
import { RuneModel } from "../commonModel/RuneModel"

export class RuneSelectMatView extends BaseView1 {
	Content
	GetTheSameTypeGoods
	InitEvent
	InitView
	LoadSuccess
	Local_Open
	SetGoodsList

	model
	type_id
	item_loop_list
	item_loop_mgr = null

	public constructor() {
		super()
		this.base_file = "composite"
		this.layout_file = "RuneSelectMatView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.show_open_movie = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true

		this.model = CompositeModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			if (this.item_loop_mgr) {
				this.item_loop_mgr.DeleteMe()
				this.item_loop_mgr = null
			}
		}

		this.Local_Open = (parms?) => {
			this.type_id = Number(parms)
			super.Open()
		}

		this.LoadSuccess = () => {
			// this.mat_scroller.scrollBar.visible = false
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.close_btn, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.ButtonTwoSkin, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Rune)
				this.Close()
			}, this, true)

			this.BindEvent(this.model, CompositeModel.SELECT_GOD_EQUIP, (item?) => {
				let info = this.item_loop_list[item.index]
				this.model.Fire(CompositeEvent.SELECT_RUNE_GOODS, info)
				this.Close()
			})
		}

		this.InitView = () => {
			if (!this.type_id) {
				return
			}
			let list = this.GetTheSameTypeGoods(this.type_id)
			if (list && list.length > 0) {
				this.ButtonTwoSkin.visible = false
				this.SetGoodsList(list)
			} else {
				this.ButtonTwoSkin.visible = true
			}
		}

		this.GetTheSameTypeGoods = (type_id?) => {
			let list = []

			let wear_info = RuneModel.GetInstance().GetWearRuneSame(type_id)
			if (wear_info) {
				table.insert(list, wear_info)
			}


			for (let _tmpi in GoodsModel.GetInstance().runebag_goods_list) {
				var obj = GoodsModel.GetInstance().runebag_goods_list[_tmpi]
				if (obj.type_id == type_id && obj.sybtype != 99) {
					table.insert(list, obj)
				}
			}
			let sort_fun = (a?, b?) => {
				let a_v = RuneModel.GetInstance().IsRuneDress(a) ? 1 : 0
				let b_v =  RuneModel.GetInstance().IsRuneDress(b) ? 1 : 0
				if (a_v != b_v) {
					return a_v > b_v
				}
				return a.level < b.level
			}
			table.sort(list, sort_fun)





			return list
		}

		this.SetGoodsList = (list?) => {
			this.item_loop_list = list
			if (!this.item_loop_mgr) {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this.mat_scroller, CompositeSelectEquipItem, this.item_loop_list, LoopScrCon.Vertical)
			} else {
				this.item_loop_mgr.replaceAll(this.item_loop_list)
			}

			/*
			if (list) {
				let item = null
				let i = 0
				if (i < list.length) {
					do {
						item = this.item_list[i]
						if (!item) {
							item = new EquipmentItem(this.Content)
							item.Load()
						}
						item.SetData(list[i].type_id, 1)
						item.SetStrengthen(list[i].level)
						let awake = false
						for (let key in list[i].awake_list) {
							let awakeInfo = list[i].awake_list[key]
							if (awakeInfo.awake_lv > 0) {
								awake = true
								break
							}
						}
						item.SetAwake(awake)
						let temp_i = i
						item.SetClickCallBack(() => {
							this.model.Fire(CompositeEvent.SELECT_RUNE_GOODS, list[temp_i + 1])
							this.Close()
						}
						)
						i = i + 1
					} while ((i < list.length))
				}
			}
			*/
		}
	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
	}


bg:Laya.Image
item_bg:Laya.Image
mat_scroller:Laya.List
close_btn:Laya.Image
ButtonTwoSkin:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
_gp_tips:Laya.Box
tips_img:Laya.Image
tips_label:Laya.Label
img_title:Laya.Image
lb_title:Laya.Label
public GetComponents() {
[
this.bg,
this.item_bg,
this.mat_scroller,
this.close_btn,
this.ButtonTwoSkin,
this._Image1,
this.labelDisplay,
this._gp_tips,
this.tips_img,
this.tips_label,
this.img_title,
this.lb_title,
]
 = this.GetChildrenByNames([

"bg",
"item_bg",
"mat_scroller",
"close_btn",
"ButtonTwoSkin",
"_Image1",
"labelDisplay",
"_gp_tips",
"tips_img",
"tips_label",
"img_title",
"lb_title",
])
}
}
 window["RuneSelectMatView"]= RuneSelectMatView
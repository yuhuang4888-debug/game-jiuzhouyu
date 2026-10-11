import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { DepositModel } from "../commonModel/DepositModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DepositSettingGuildEvening extends BaseView1 {

	model: DepositModel
	food_cost
	data
	setting = []
	public constructor() {
		super()

		this.base_file = "deposit"
		this.layout_file = "DepositSettingGuildEvening"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.preload_server_config = {
			"config_gfeast": false,
		}
		this.model = DepositModel.GetInstance()


		this.load_callback = () => {
			let Gfeast = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gfeast", false);
			this.food_cost = JSON.parse(Gfeast[62].value)
			// this.cb1 = this.cb1.GetComponent("Toggle")
			// this.cb2 = this.cb2.GetComponent("Toggle")
			// this.cb3 = this.cb3.GetComponent("Toggle")
			for (let i = 1; i <= 3; i++) {
				this["imgicon_cost" + i] = this[`icon_cost${i}`]
				this["textcost" + i] = this[`cost${i}`]
			}
			this.InitEvent()
			this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19206)

			ResManager.GetInstance().SetImageSpriteTrans(this, this.img1_1, GameResPath.GetIcon("deposit", "uirw_093"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this.img1_2, GameResPath.GetIcon("deposit", "uirw_093"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this.img1_3, GameResPath.GetIcon("deposit", "uirw_093"))

		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Clear()
		}
	}

	public Open(data?) {
		this.data = data
		super.Open()
		
	}

	public UpdateView() {


		let deposit_data = this.model.GetDepositData(this.data.module_id, this.data.sub_module)
		this.setting = [false, false, false]
		if (deposit_data) {
			for (let i = 0; i < deposit_data.behaviour_list.length; i++) {
				var v = deposit_data.behaviour_list[i]
				this.setting[v.behaviour_id - 1] = v.b_select_time > 0
			}
		}

		for (let i = 0; i < this.setting.length; i++) {
			var v = this.setting[i]
			if (this[`check_img${i + 1}`]){
				this[`check_img${i + 1}`].visible = v
			}
		}

		for (let i = 1; i <= 3; i++) {
			let cost = this.food_cost[i - 1][1][0]
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(cost[0], cost[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			ResManager.GetInstance().SetOutsideImageSprite(this, this["imgicon_cost" + i], GameResPath.GetGoodsIconPath(goods_vo.goods_icon))
			this["textcost" + i].text = cost[2]
		}
	}

	public InitEvent() {

		var onClickBtnHandler = (target) => {
			let btn = target.currentTarget
			if (btn == this.close || btn == this.cancle || btn == this.ok) {
				let is_change = false
				for (let i = 1; i <= 3; i++) {
					if (this[`check_img${i}`].visible != this.setting[i]) {
						is_change = true
						break
					}
				}
				if (is_change) {
					for (let i = 1; i <= 3; i++) {
						let value = this[`check_img${i}`].visible
						if (value) {
							this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19204, this.data.module_id, this.data.sub_module, i)
						} else {
							this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19205, this.data.module_id, this.data.sub_module, i)
						}
					}
				}
				this.Close()
			}
		}
		Util.AddClickEvent(this.close, onClickBtnHandler, this, true)
		Util.AddClickEvent(this.ok, onClickBtnHandler, this, true)
		Util.AddClickEvent(this.cancle, onClickBtnHandler, this, true)

		var CheckBoxValueChanged = (target) => {
			let btn = target.currentTarget
			let behaviour_id
			let check
			if (btn == this.cb1) {
				behaviour_id = 1
				check = this.check_img1
			} else if (btn == this.cb2) {
				behaviour_id = 2
				check = this.check_img2
			} else if (btn == this.cb3) {
				behaviour_id = 3
				check = this.check_img3
			}
			check.visible = !check.visible
			// if (value ) {
			// 	this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19204, this.data.module_id, this.data.sub_module, behaviour_id)
			// }else{
			// 	this.model.Fire(DepositModel.REQUEST_CCMD_EVENT, 19205, this.data.module_id, this.data.sub_module, behaviour_id)
			// }
		}
		Util.AddClickEvent(this.cb1, CheckBoxValueChanged, this, false)
		Util.AddClickEvent(this.cb2, CheckBoxValueChanged, this, false)
		Util.AddClickEvent(this.cb3, CheckBoxValueChanged, this, false)


		// this.cb1.onValueChanged.AddListener((value?) => {
		// 	CheckBoxValueChanged(this.cb1, value)
		// })
		// this.cb2.onValueChanged.AddListener((value?) => {
		// 	CheckBoxValueChanged(this.cb2, value)
		// })
		// this.cb3.onValueChanged.AddListener((value?) => {
		// 	CheckBoxValueChanged(this.cb3, value)
		// })

		// this.BindEvent(this.model, DepositModel.DEPOSIT_BEHAVIOUR_SELECT,(scmd19204?) => {
		// 	if (scmd19204.module_id == this.data.module_id && scmd19204.sub_module == this.data.sub_module ) {
		// 		this["cb" + scmd19204.behaviour_id].isOn = true
		// 	}
		// })

		// this.BindEvent(this.model, DepositModel.DEPOSIT_BEHAVIOUR_UNSELECT,(scmd19205?) => {
		// 	if (scmd19205.module_id == this.data.module_id && scmd19205.sub_module == this.data.sub_module ) {
		// 		this["cb" + scmd19205.behaviour_id].isOn = false
		// 	}
		// })
	}

	public Clear() {


	}




bg:Laya.Image
close:Laya.Image
_Image3:Laya.Image
title_img:Laya.Label
txt2:Laya.Label
_box_evening:Laya.Box
_Image2:Laya.Image
node1:Laya.Box
foodItem:Laya.Box
bg11:Laya.Image
img1_1:Laya.Image
name1:Laya.Label
img_food_icon1:Laya.Image
icon_cost1:Laya.Image
cost1:Laya.Label
cb1:Laya.Box
_Image111:Laya.Image
check_img1:Laya.Image
labelDisplay11:Laya.Label
node2:Laya.Box
foodItem1:Laya.Box
bg1:Laya.Image
img1_2:Laya.Image
name2:Laya.Label
img_food_icon2:Laya.Image
icon_cost2:Laya.Image
cost2:Laya.Label
cb2:Laya.Box
_Image11:Laya.Image
check_img2:Laya.Image
labelDisplay1:Laya.Label
node3:Laya.Box
foodItem11:Laya.Box
bg111:Laya.Image
img1_3:Laya.Image
name3:Laya.Label
img_food_icon3:Laya.Image
icon_cost3:Laya.Image
cost3:Laya.Label
cb3:Laya.Box
_Image1:Laya.Image
check_img3:Laya.Image
labelDisplay:Laya.Label
ok:Laya.Box
txt:Laya.Label
cancle:Laya.Box
img111:Laya.Image
txt1:Laya.Label
public GetComponents() {
[
this.bg,
this.close,
this._Image3,
this.title_img,
this.txt2,
this._box_evening,
this._Image2,
this.node1,
this.foodItem,
this.bg11,
this.img1_1,
this.name1,
this.img_food_icon1,
this.icon_cost1,
this.cost1,
this.cb1,
this._Image111,
this.check_img1,
this.labelDisplay11,
this.node2,
this.foodItem1,
this.bg1,
this.img1_2,
this.name2,
this.img_food_icon2,
this.icon_cost2,
this.cost2,
this.cb2,
this._Image11,
this.check_img2,
this.labelDisplay1,
this.node3,
this.foodItem11,
this.bg111,
this.img1_3,
this.name3,
this.img_food_icon3,
this.icon_cost3,
this.cost3,
this.cb3,
this._Image1,
this.check_img3,
this.labelDisplay,
this.ok,
this.txt,
this.cancle,
this.img111,
this.txt1,
]
 = this.GetChildrenByNames([

"bg",
"close",
"_Image3",
"title_img",
"txt2",
"_box_evening",
"_Image2",
"node1",
"foodItem",
"bg11",
"img1_1",
"name1",
"img_food_icon1",
"icon_cost1",
"cost1",
"cb1",
"_Image111",
"check_img1",
"labelDisplay11",
"node2",
"foodItem1",
"bg1",
"img1_2",
"name2",
"img_food_icon2",
"icon_cost2",
"cost2",
"cb2",
"_Image11",
"check_img2",
"labelDisplay1",
"node3",
"foodItem11",
"bg111",
"img1_3",
"name3",
"img_food_icon3",
"icon_cost3",
"cost3",
"cb3",
"_Image1",
"check_img3",
"labelDisplay",
"ok",
"txt",
"cancle",
"img111",
"txt1",
])
}
}
 window["DepositSettingGuildEvening"]= DepositSettingGuildEvening
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildActivityModel, GuildActEvent } from "../commonModel/GuildActivityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Config } from "../common/Config"

export class EveningFoodItem extends BaseItem1 {
	cost_type
	data
	extend_btn_cost
	food_buff
	food_cost
	model
	name_outline
	needRefreshData
	config_g

	public static width = 119
	public static height = 149

	name_list = {
		1: { name: "普通菜肴", color: "#0a953e", out_color: "#8da349", type_id: 32010498 },
		2: { name: "优质菜肴", color: "#2971e6", out_color: "#497aa3", type_id: 32010499 },
		3: { name: "极品菜肴", color: "#cf6d00", out_color: "#aa4215", type_id: 32010500 }
	}
	public constructor(parent?) {
		super(parent)
		let ConfigHasDefaultValue = Config.ConfigHasDefaultValue
		let local_Config = Config

		this.model = GuildActivityModel.GetInstance()
		this.base_file = "evening"
		this.layout_file = "EveningFoodItem"
		this.preload_server_config = { "config_gfeast": false }

		// this.food_cost = JSON.parse(Config.Gfeast[62].value)
		// this.food_buff = JSON.parse(Config.Gfeast[63].value)
		this.load_callback = () => {
			this.config_g = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gfeast", false)
			this.food_cost = JSON.parse(Config.GetConfigVo("config_gfeast", "62", false, this.config_g).value)
			this.food_buff = JSON.parse(Config.GetConfigVo("config_gfeast", "63", false, this.config_g).value)


			this.LoadSuccess()
			//this.name_outline = this.GetChild("name").GetComponent("Outline")

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this.tip.size = 11
			// 	this.name.size = 14
			// }


			if (this.needRefreshData) {
				this.SetData(this.data)
				this.needRefreshData = false
			}
		}
	}

	public DeleteMe() {

		super.DeleteMe()
	}

	public LoadSuccess() {

		this.InitView()
		this.InitEvent()
		this.extend_btn_cost = this.btn_cost
	}

	public SetData(data?) {
		if (!data) return
		this.data = data
		if (this.is_loaded) {
			let cost = this.food_cost[data.type-1][1][0]  //{0: 2, 1: 0, 2: 20}  物品类型/id/数量
			this.cost_type = Number(cost[0])
			let type_id, lock
			[type_id, lock]= GoodsModel.GetInstance().GetMappingTypeId(cost[0], cost[1])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.icon_cost, GameResPath.GetGoodsIconPath(goods_vo.goods_icon))
			ResManager.GetInstance().SetImageSprite(this, this.img_food_icon, "evening", "food_" + data.type, true)
			//this.cost = Number(cost[3])
			this.cost.text = cost[2] + ""
			this.buff.text = `经验+${this.food_buff[data.type-1][1]}%`   //string.format("经验+%d%%", this.food_buff[data.type][2])
			this.name.text = this.name_list[data.type].name
			this.name.color = ColorUtil.TryParseHtmlString(this.name_list[data.type].color)
			//this.name_outline.effectColor = ColorUtil.TryParseHtmlString(this.name_list[data.type].out_color)
			if (1 == data.status) {
				this.tip.visible = true
				this.icon_cost.visible = false
				this.cost.visible = false
				Util.SetImageGray(this.extend_btn_cost, true)
			} else {
				this.tip.visible = false
				this.icon_cost.visible = true
				this.cost.visible = true
				Util.SetImageGray(this.extend_btn_cost, false)
			}
		} else {
			this.needRefreshData = true
		}
	}

	public InitView() {


	}

	public InitEvent() {

		Util.AddClickEvent(this.btn_cost22, () => {
			if (this.data) {
				if (1 == this.data.status) {
					if (3 == this.data.type) {
						Message.show("每次活动中,一个结社只能购买一份极品菜肴哦~")
					}
					return
				}
				let scmd_func = () => {
					this.model.Fire(GuildActEvent.REQUEST_PROTO, 40264, "c", this.data.type)
				}
				let cost_name = 1 == this.cost_type && "勾玉" || "绑玉"
				let str = `是否花费${this.cost.text}${cost_name}购买${this.name_list[this.data.type].name}`//string.format("是否花费%s%s购买%s", this.cost.text, cost_name, name_list[this.data.type].name)
				Alert.Show(str, Alert_Type.Two, () => {
					let jin_lock = RoleManager.GetInstance().GetMainRoleVo().jinLock
					let jin = RoleManager.GetInstance().GetMainRoleVo().jin
					if (1 == this.cost_type) {
						scmd_func()
					} else {
						if (jin_lock < this.cost && jin + jin_lock >= this.cost) {
							let str = "<font color=\"#ff4f50\">当前绑玉数量不足，是否消耗勾玉代替？</font>"
							Alert.Show(str, Alert_Type.Two, scmd_func, null, "确定", "取消")
							Alert.SetIsCharge(true)
						} else {
							scmd_func()
						}
					}
				})
			}
		}, this, true)

		Util.AddClickEvent(this.img_food_icon, () => {
			UIToolTipMgr.GetInstance().AppendGoodsTips(this.name_list[this.data.type].type_id, null, null, null)
		}, this, true)
	}



Image:Laya.Image
img_1:Laya.Image
name:Laya.Label
img2:Laya.Image
img_food_icon:Laya.Image
buff:Laya.Label
btn_cost22:Laya.Box
btn_cost:Laya.Image
icon_cost:Laya.Image
cost:Laya.Label
tip:Laya.Label
public GetComponents() {
[
this.Image,
this.img_1,
this.name,
this.img2,
this.img_food_icon,
this.buff,
this.btn_cost22,
this.btn_cost,
this.icon_cost,
this.cost,
this.tip,
]
 = this.GetChildrenByNames([

"Image",
"img_1",
"name",
"img2",
"img_food_icon",
"buff",
"btn_cost22",
"btn_cost",
"icon_cost",
"cost",
"tip",
])
}
}
 window["EveningFoodItem"]= EveningFoodItem
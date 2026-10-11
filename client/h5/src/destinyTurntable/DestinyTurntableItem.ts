import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { SetAnchoredPosition } from "../util/Util"

export class DestinyTurntableItem extends BaseItem1 {
	gp_effect: Laya.Box
	gp: Laya.Box
	Image: Laya.Image
	img_select: Laya.Image
	gp_reward: Laya.Box
	img_get: Laya.Image
	exp: Laya.Image
	LoadSuccess
	InitReward
	SetPos
	SetSelect
	SetData
	data
	select

	public constructor(parent?) {
		super(parent)

		this.base_file = "destinyTurntable"
		this.layout_file = "DestinyTurntableItem"
		let reward_item = null
		this.layer_value = Enum_UILayer.UI

		this.load_callback = () => {

			//this:InitEvent()
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.InitReward()
			this.SetSelect(this.select)
		}

		this.SetData = (data?) => {
			this.data = data
			if (!this.is_loaded) {
				return
			}
			this.InitReward()
		}

		this.InitReward = () => {
			if (!this.data) {
				return
			}
			if (!reward_item) {
				reward_item = new EquipmentItem(this.gp_reward)
				reward_item.Load()
				reward_item.ExcuteCallback(() => {
					reward_item.SetItemSize(120, 120)
				})
			}
			let rewardList = ErlangParser.GetInstance().parse(this.data.reward)
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(Number(rewardList[0][0]), Number(rewardList[0][1]))
			reward_item.SetData(type_id, Number(rewardList[0][2]), null, null, null, this.data.status == 1)
			//reward_item:SetGary(this.data.status == 1)
			this.exp.visible = type_id == 26010005
			this.img_get.visible = this.data.status == 1
		}

		this.SetSelect = (bool?) => {
			this.select = bool
			if (!this.is_loaded) {
				return
			}
			this.img_select.visible = bool

			this.ClearUIEffect(this.gp_effect)
			// if (bool ) {
			// 	this.AddUIEffect("UI_2037","UI",this.gp_effect,null,1.1,true,{load_call_back =() => {
			// 				this.CoverEffect(this.gp,"UI")
			// 			}})
			// }
		}

		this.SetPos = (x?, y?) => {
			SetAnchoredPosition(this.display_obj, x, y)
		}


		this.DeleteMe = () => {
			if (reward_item) {
				reward_item.DeleteMe()
				reward_item = null
			}
			this.ClearUIEffect(this.gp_effect)
			super.DeleteMe()
		}
	}


	public GetComponents() {
		[
			this.gp_effect,
			this.gp,
			this.Image,
			this.img_select,
			this.gp_reward,
			this.img_get,
			this.exp
		]
			= this.GetChildrenByNames([

				"gp_effect",
				"gp",
				"Image",
				"img_select",
				"gp_reward",
				"img_get",
				"exp"
			])
	}
}
window["DestinyTurntableItem"] = DestinyTurntableItem
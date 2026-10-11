import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { MarketModel, MarketEvent } from "../commonModel/MarketModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { EquipModel } from "../commonModel/EquipModel"
import { RoleManager } from "../commonModel/RoleManager"
export class MarketPlzShowItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_group_item: Laya.Box
	_Image2: Laya.Image
	_lb_name: Laya.Label
	_lb_stage: Laya.Label
	_group_plz: Laya.Box
	_Label1: Laya.Label
	_lb_player: Laya.Label
	_Group1: Laya.Box
	_Image3: Laya.Image
	_lb_price: Laya.Label
	_btn_sell: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	_btn_repeal: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	ChickPlayer
	ChickRepeal
	ClickSell
	Element
	Emp_btn_repeal
	Emp_btn_sell

	item
	public WIDTH = 678
    public HEIGT = 120
	public constructor(parent) {
		super()
		this.base_file = "market"
		this.layout_file = "MarketPlzShowItem"


		this.load_callback = () => {
			this.item = new EquipmentItem(this._group_item)
			//this.item.SetMaskId(this.mask_id || 1)
			this.item.ExcuteCallback(() => {
				this.item.SetItemSize(85 ,85)
			})
			this.item.Load()
			Util.AddClickEvent(this._btn_sell, () => {
				this.ClickSell()
			}, this, true)
			Util.AddClickEvent(this._btn_repeal, () => {
				this.ChickRepeal()
			}, this, true)
			Util.AddClickEvent(this._group_plz, () => {
				this.ChickPlayer()
			}, this, true)
		}
		this.Load()
		// this.load_callback = () => {

		// 	if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 		this._Label1.size  = 20
		// 	}
		// }


		//this.Element = Array(1);
		this.ClickSell = () => {
			let own = GoodsModel.GetInstance().MarketPlzGetTypeGoodsNum(this.data.type_id)
			if (own < this.data.goods_num) {
				Message.show("拥有物品不足")
				return
			}
			MarketModel.GetInstance().Fire(MarketEvent.OPEN_VIEW, "MarketSellTipView", this.data)
		}

		this.ChickRepeal = () => {
			let data = this.data
			MarketModel.GetInstance().Fire(MarketEvent.REQUEST_PROTO, 15116, "l", data.id)
		}

		this.ChickPlayer = () => {
			//ChatModel.GetInstance().Fire(ChatModelEvent.OPEN_CHAT_MENU, this, this.data.player_id, this.data.ser_id, false, null, null, "MarketPlzShowItem")
		}



	}

	public createChildren() {
		super.createChildren()

		//this.Element[0] = [text="", style=[underline=true]]
	}

	public dataChanged() {
		if (super.dataChanged()) {

			let data = this.data
			this.item.SetData(data.type_id, data.goods_num)
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
			this._lb_name.text = basic.goods_name
			let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_equip_attr", false)
			// [ts2lua]lua中0和空字符串也是true，此处basic.type == 10需要确认
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_stage.text = (basic.type == 10 && ( "Grade " + EquipModel.GetInstance().GetStageByTypeId(data.type_id, equip_attr_cfg) ) || ( "" ) )
			// }else{
			this._lb_stage.text = (basic.type == 10 && (EquipModel.GetInstance().GetStageByTypeId(data.type_id, equip_attr_cfg) + "阶") || (""))
			//}

			this._lb_price.text = data.unit_price
			//this.Element[0].text = data.role_name
			if (data.role_name)
				this._lb_player.text = data.role_name
			this._lb_player.visible = data.role_name != undefined
			this._Label1.visible = data.role_name != undefined
			let is_own = !data.player_id || data.player_id == RoleManager.GetInstance().GetMainRoleId()
			this._btn_sell.visible = !is_own
			this._btn_repeal.visible = is_own
		}
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._group_item,
			this._Image2,
			this._lb_name,
			this._lb_stage,
			this._group_plz,
			this._Label1,
			this._lb_player,
			this._Group1,
			this._Image3,
			this._lb_price,
			this._btn_sell,
			this._Image111,
			this.labelDisplay,
			this._btn_repeal,
			this._Image11,
			this.labelDisplay1,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_group_item",
				"_Image2",
				"_lb_name",
				"_lb_stage",
				"_group_plz",
				"_Label1",
				"_lb_player",
				"_Group1",
				"_Image3",
				"_lb_price",
				"_btn_sell",
				"_Image111",
				"labelDisplay",
				"_btn_repeal",
				"_Image11",
				"labelDisplay1",
			])
	}
}

window["MarketPlzShowItem"] = MarketPlzShowItem
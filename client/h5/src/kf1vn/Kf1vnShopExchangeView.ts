import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDeltaY } from "../util/Util"
import { Kf1vnShopExchangeItem } from "./Kf1vnShopExchangeItem"

//1vn商店兑换
export class Kf1vnShopExchangeView extends BaseItem1 {
	DeleteFlyGroup
	InitEvents
	InitShopContent
	LoadSuccess
	SetData
	cost_item_
	loop_loop_mgr
	IconFly



	public constructor(parent?) {
		super(parent)

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnShopExchangeView"
		this.layer_value = Enum_UILayer.Activity
		let model = Kf1vnModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let shop_data_ = null
		let needRefresh_ = null
		let icon_fly_group_ = []
		let array_collection_ = null
		this.cost_item_ = null
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this,this._Image4,GameResPath.GetIconOtherPath("common2","com_line_1"))
			goods_model.Fire(GoodsModel.REQUEST_EXCHANGE_GOODS, Kf1vnModel.ExchangeShopType)
			shop_data_ = []
			this.cost_item_ = new BaseAwardItem(this.item_conta)
			this.cost_item_.Load()
			this.cost_item_.SetItemSize(40, 40)
			this.cost_item_.SetItembgVisible(false)
			this.cost_item_.SetData(Kf1vnModel.ZhanHunTypeId, 0)
		}

		this.InitEvents = () => {
			let update_shop_data = () => {
				this.SetData()
			}
			this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_EXCHANGE_DATA, update_shop_data)

			let update_score = (vo?) => {
				if (vo && vo.currency_id == Kf1vnModel.ZhanHunTypeId) {
					this.SetData()
				}
			}
			this.BindEvent(goods_model, GoodsModel.UPDATE_SPECIAL_SCORE, update_shop_data)

			let fly_fun = (data?, pos?) => {
				this.IconFly(data, pos)
			}
			this.BindEvent(model, Kf1vnEvent.EXCHANGE_ICON_FLY, fly_fun)

			if (needRefresh_) {
				this.SetData()
				needRefresh_ = false
			}
		}

		this.SetData = () => {
			if (this.is_loaded) {
				shop_data_ = model.GetExchangeGoodsData()
				this.none_conta.visible = !(shop_data_ && shop_data_.length > 0)
				this.InitShopContent()

				let myhave = goods_model.GetSpecialScore(Kf1vnModel.ZhanHunTypeId)
				this.my_have.text = myhave
			} else {
				needRefresh_ = true
			}
		}

		this.InitShopContent = () => {
			if (shop_data_) {
				if (!this.loop_loop_mgr) {
					this.loop_loop_mgr = new LoopScrowViewMgr()
					this.loop_loop_mgr.SetData(this.Content, Kf1vnShopExchangeItem, shop_data_,LoopScrCon.Vertical)
				} else {
					this.loop_loop_mgr.replaceAll(shop_data_)
				}
			}
		}

		this.IconFly = (type_id?, pos?) => {
			//if (type_id && pos ) {
			//let group = eui. new Group()
			//icon_fly_group_[group.hashCode] = group
			//this:addChild(group)
			//group.height = 119
			//group.width = group.height
			//group.touchEnabled = false
			//let local_star = this.globalToLocal(pos.x, pos.y)
			//group.x = local_star.x
			//group.y = local_star.y
			//let award =  new BaseAwardItem(group)
			//award:Load()
			//award:SetData(type_id, null, null, null, null, true)
			//award:SetShowTips(false)
			//award:SetItemSize(119, 119)
			//award:SetItembgVisible(false)
			//let delayFunc = () => {
			//if (award ) {
			//award:DeleteMe()
			//award = null
			//}
			//this:removeChild(group)
			//icon_fly_group_[group.hashCode] = null
			//}

			//Laya.Tween.get(group):to({alpha=0.5}):to({y=group.y - 40, alpha=1}, 300):to({x=110, y=LayerManager:GetInstance().stageHeight - 69, scaleX=0.8, scaleY=0.8, alpha=0}, 700, Laya.Ease.cubicIn).call(delayFunc)
			//}
		}

		this.DeleteFlyGroup = () => {
			//let group = null
			//let item = null
			//for (let key in icon_fly_group_) {

			//group = icon_fly_group_[key]
			//if (group ) {
			//item = group.getChildAt(0)
			//if (item ) {
			//item:DeleteMe()
			//item = null
			//}
			//this:removeChild(group)
			//Laya.Tween.removeTweens(group)
			//icon_fly_group_[key] = null
			//}
			//}
		}
	}

	public DeleteMe() {

		this.DeleteFlyGroup()
		if (this.cost_item_) {
			this.cost_item_.DeleteMe()
			this.cost_item_ = null
		}
		if (this.loop_loop_mgr) {
			this.loop_loop_mgr.DeleteMe()
			this.loop_loop_mgr = null
		}

		super.DeleteMe()
	}


sub_conta:Laya.Box
_Image1:Laya.Image
_Image4:Laya.Image
Content:Laya.List
_Group1:Laya.Box
item_conta:Laya.Box
my_have:Laya.Label
_Label1:Laya.Label
_Image3:Laya.Image
none_conta:Laya.Box
tips1:Laya.Label
tips_icon1:Laya.Image
public GetComponents() {
[
this.sub_conta,
this._Image1,
this._Image4,
this.Content,
this._Group1,
this.item_conta,
this.my_have,
this._Label1,
this._Image3,
this.none_conta,
this.tips1,
this.tips_icon1,
]
 = this.GetChildrenByNames([

"sub_conta",
"_Image1",
"_Image4",
"Content",
"_Group1",
"item_conta",
"my_have",
"_Label1",
"_Image3",
"none_conta",
"tips1",
"tips_icon1",
])
}
}
 window["Kf1vnShopExchangeView"]= Kf1vnShopExchangeView
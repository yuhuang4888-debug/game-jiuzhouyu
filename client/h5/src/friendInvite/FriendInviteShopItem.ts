import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class FriendInviteShopItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_gp_award: Laya.Box
	_lb_name: Laya.Label
	_lb_tips: Laya.Label
	_lb_count: Laya.Label
	_gp_buy: Laya.Box
	_Image2: Laya.Image
	_Group1: Laya.HBox
	_lb_desc: Laya.Label
	_img_icon: Laya.Image
	award_item
	goods_vo
	public static width = 310
	public static height = 138
	WIDTH = 282
	HEIGT = 107

	public constructor(parent) {
		super()

		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteShopItem"
		this.load_callback = () => {


			Util.AddClickEvent(this._gp_buy, () => {
				if (this.data.cfg.lim_num >= this.data.count) {
					GoodsModel.GetInstance().Fire(GoodsModel.EXCHANGE_GOODS, this.data.cfg.id, 1)
				}
			}
				, this, true)

			let success_fun = (id?) => {
				if (this.goods_vo && this.data.cfg.id == id) {
					//let pos = this._gp_award.localToGlobal()
					//let image = eui. new Image()
					//image.x = pos.x
					//image.y = pos.y
					//lua_resM:SetOutsideImageSprite(this, image, "resource/game/goodsicon/" + this.goods_vo.goods_icon + ".png")
					//LayerManager:GetInstance().stage.addChild(image)
					//let call_back = () => {
					//LayerManager:GetInstance().stage.removeChild(image)
					//}
					//Util.flyToDownUIIcon(image, MainFunc.Bag, call_back, 0.3, 0.3)
					let goodsids = [[0, this.goods_vo.type_id, 1]]
					//GlobalEventSystem.Fire(EventName.REWARD_FLY, goodsids,UILocalToCanvasPoint(this._gp_award, co.TableXY(0,1), co.TableXY(0,1)))
				}
			}

			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.BUY_SUCCESS, success_fun)
		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let item = null
			let role_lv = RoleManager.GetInstance().GetMainRoleVo().level
			let obtain_list = JSON.parse(this.data.cfg.obtain_list)
			if (obtain_list && obtain_list.length > 0) {
				let vo = obtain_list[0]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					this.goods_vo = goods_vo
					item = this.award_item
					if (!item) {
						item = new BaseAwardItem(this._gp_award)
						this.award_item = item
						item.SetItemSize(85,85)
						item.Load()
					}
					item.SetData(goods_vo.type_id, vo[2], lock)
					this._lb_name.text = goods_vo.goods_name
				}
			}
			if (role_lv >= this.data.cfg.role_lv) {
				this._lb_tips.visible = this.data.cfg.lim_type > 0
				this._lb_count.visible = this.data.cfg.lim_type > 0
				this._lb_count.text = this.data.count + "/" + this.data.cfg.lim_num
			} else {
				this._lb_count.visible = false
				this._lb_tips.text = "Lv" + this.data.cfg.role_lv + "可购买"
			}
			let cost_list = JSON.parse(this.data.cfg.cost_list)
			if (cost_list && cost_list.length > 0) {
				let vo = cost_list[0]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath( goods_vo.goods_icon))
				}
				this._lb_desc.text = vo[2]
			}
		}
		//LayoutRebuilder(this._Group1)
	}

	public DeleteMe() {

		if (this.award_item) {
			this.award_item.DeleteMe()
			this.award_item = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._gp_award,
			this._lb_name,
			this._lb_tips,
			this._lb_count,
			this._gp_buy,
			this._Image2,
			this._Group1,
			this._lb_desc,
			this._img_icon,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_gp_award",
				"_lb_name",
				"_lb_tips",
				"_lb_count",
				"_gp_buy",
				"_Image2",
				"_Group1",
				"_lb_desc",
				"_img_icon",
			])
	}
}
window["FriendInviteShopItem"] = FriendInviteShopItem
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class FriendInviteBoostView extends BaseItem1 {
	_img_bg: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_lb_exchange: Laya.Box
	_Label3: Laya.Label
	_lb_count: Laya.Label
	goods: Laya.Image
	InitEvent
	LoadSuccess
	UpdateView
	horizontalCenter
	state

	public constructor(parent?) {
		super(parent)

		this.state = 0;
		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteBoostView"
		this.horizontalCenter = 0
		let model = FriendInviteModel.GetInstance()
		let local_FriendInviteModel = FriendInviteModel
		let boost_info_ = null
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			//this._lb_exchange.text = [{text:"前往兑换道具", style:{size:24, textColor:"#639c12", underline:true}]}
			ResManager.GetInstance().SetOutsideImageSprite(this, this.goods, GameResPath.GetGoodsIconPath(FriendInviteModel.currency_type_two))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("friendInvite", "uiyqkbx_026"), true)
			this.InitEvent()
			model.Fire(local_FriendInviteModel.SCMD_REQUEST, 34008, local_FriendInviteModel.boost_lv_key)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._lb_exchange, () => {
				model.Fire(local_FriendInviteModel.OPEN_FRIEND_INVITE_SHOP_VIEW, 1)
			}
				, this, true)

			this.BindVar(model, "boost_info", (event_type?, value?) => {
				boost_info_ = value
				this.UpdateView()
			}
			)
		}

		this.UpdateView = () => {
			if (!boost_info_) {
				return
			}
			let count = (boost_info_.reward && boost_info_.reward[0]) && boost_info_.reward[0].count || 0
			this._lb_count.text = count
		}
	}



	public GetComponents() {
		[
			this._img_bg,
			this._Label1,
			this._Label2,
			this._lb_exchange,
			this._Label3,
			this._lb_count,
			this.goods
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Label1",
				"_Label2",
				"_lb_exchange",
				"_Label3",
				"_lb_count",
				"goods"
			])
	}
}
window["FriendInviteBoostView"] = FriendInviteBoostView
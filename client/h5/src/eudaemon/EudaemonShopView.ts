import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BossModel } from "../commonModel/BossModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopEvent, ShopModel, ShopType } from "../commonModel/ShopModel"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { EudaemonShopBigItem } from "./EudaemonShopBigItem"
import { EudaemonShopTaskItem } from "./EudaemonShopTaskItem"
import { EudaemonTaskTabItem } from "./EudaemonTaskTabItem"

export class EudaemonShopView extends BaseItem1 {

	shopArr
	taskArr
	tween_id
	moneyType
	model
	shop_model: ShopModel
	goods_model: GoodsModel
	task_item_list
	public constructor(parent?) {
		super(parent)

		this.base_file = "eudaemon"
		this.layout_file = "EudaemonShopView"
		this.model = BossModel.GetInstance()
		this.layer_value = Enum_UILayer.Activity

		this.moneyType = 36255041

		this.shop_model = ShopModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()

		this.load_callback = () => {
			this.InitView()
		}
	}
	

	public InitView = () => {
		this._html_time.style.color = "#4f1f5a"
		this._html_time.style.stroke = 2
		this._html_time.style.strokeColor = "#ffffff"
		this._html_time.style.fontSize = 20
		this._html_time.style.wordWrap = false


		// resource/game/eudaemon/texture/ui_kf_dgxs020.png
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg4, GameResPath.GetIconOtherPath("eudaemon", "ui_kf_dgxs020"))
		//resource/game/eudaemon/texture/ui_kf_dgxs005a.png
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconOtherPath("eudaemon", "ui_kf_dgxs005a"))
		

		this.shop_model.Fire(ShopEvent.SHOP_REQUEST_PROTO, 15301, "c", ShopType.EudaemonShop)
		let big_shop_info = this.GetShopList()
		if (!this.shopArr) {
			this.shopArr = new LoopScrowViewMgr()
			this.shopArr.SetData(this._list_shop, EudaemonShopBigItem, big_shop_info, LoopScrCon.Vertical)
		} else {
			this.shopArr.replaceAll(big_shop_info)
		}

		let task_info = [
			{ index: 1, str: "完成每日任务<br>可获得200积分", icon1: "eudaemon", icon2: "ui_kf_icon1" },
			{ index: 2, str: "每次击杀大妖<br>可获得100+积分", icon1: "eudaemon", icon2: "ui_kf_icon2" },
			{ index: 3, str: "每次采集水晶<br>可获得80积分", icon1: "eudaemon", icon2: "ui_kf_icon3" }
		]

		if (!this.task_item_list) {
			this.task_item_list = []
		}
		let item,v
		for (let i = 0; i < task_info.length; i++) {
			v = task_info[i]
			item = this.task_item_list[i]
			if (!item) {
				item = new EudaemonShopTaskItem(this._box_task)
				item.Load()
				this.task_item_list[i] = item
				item.SetPosition(Number(i) * 199, 0)
			}
			item.SetData(v)
		}


		// if (!this.taskArr) {
		// 	this.taskArr = new LoopScrowViewMgr()
		// 	this.taskArr.SetData(this.Content1, EudaemonTaskTabItem, taskInfo, this._Scroller1, 1)
		// }

		this._lb_money.text = String(this.goods_model.GetSpecialScore(this.moneyType))
		let goodsBasic = this.goods_model.GetGoodsBasicByTypeId(this.moneyType)
		if (goodsBasic) {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_money_icon, GameResPath.GetGoodsIconPath(goodsBasic.goods_icon))
		}

		Util.AddClickEvent(this._img_add, () => {
			MaterialsTool.GetInstance().materialsTips(this.moneyType)
		}, this, true)

		this.BindEvent(this.model, BossModel.UPDATE_BOSS_INFO, (boss_type?) => {

		}
		)

		this.BindEvent(this.shop_model, ShopEvent.UPDATE_SHOP_ONE_DATA, () => {
			let shopInfo = this.shop_model.GetShopDataByType(ShopType.EudaemonShop)
			let bigShopInfo = this.GetShopList()
			if (!this.shopArr) {
				this.shopArr = new LoopScrowViewMgr()
				this.shopArr.SetData(this._list_shop, EudaemonShopBigItem, bigShopInfo, LoopScrCon.Vertical)
			} else {
				this.shopArr.replaceAll(bigShopInfo)
			}
		}
		)

		this.BindEvent(this.goods_model, GoodsModel.UPDATE_SPECIAL_SCORE, ()=>{
			this._lb_money.text = String(this.goods_model.GetSpecialScore(this.moneyType))
		})

		this._html_time.innerHTML = "每日<font color='#ad210e'>4点</font>刷新"
		// this.ShowAni()
	}

	// public ShowAni = () => {
	// 	SetAnchoredPositionY(this.shopItemScroller, -404)
	// 	//this.maskScroller.viewport.scrollV = 404
	// 	this.tween_id = SYTweenLite.to(this, this.shopItemScroller, SYTweenLite.UiAnimationType.ANCHORED_POSY, 0, 0.5)
	// 	//local_laya.Tween.get(this.maskScroller.viewport).to({scrollV=0}, 500)

	// }

	public GetShopList = () => {
		let shopInfo = this.shop_model.GetShopDataByType(ShopType.EudaemonShop)
		let bigShopInfo = []
		if (shopInfo) {
			let selloutIndexd = []
			let index = 0
			let count = 0
			for (let i = 0; i < shopInfo.length; i++) {
				if (shopInfo[i].quota_type == 3 && shopInfo[i].sold_out >= shopInfo[i].quota_num) {
					table.insert(selloutIndexd, i)
				} else {
					if (count == 3) {
						count = 0
						index = index + 1
					}
					if (!bigShopInfo[index]) {
						bigShopInfo[index] = []
					}
					table.insert(bigShopInfo[index], shopInfo[i])
					count = count + 1
				}
			}
			for (let i = 0; i < selloutIndexd.length; i++) {
				if (count == 3) {
					count = 0
					index = index + 1
				}
				if (!bigShopInfo[index]) {
					bigShopInfo[index] = []
				}
				table.insert(bigShopInfo[index], shopInfo[selloutIndexd[i]])
				count = count + 1
			}
		}
		return bigShopInfo
	}

	public DeleteMe() {

		if (this.tween_id) {
			SYTweenLite.Stop(this.tween_id)
			this.tween_id = null
		}
		if (this.shopArr) {
			this.shopArr.DeleteMe()
			this.shopArr = null
		}

		if(this.task_item_list){
			for(let item of this.task_item_list){
				item.DeleteMe()
			}
			this.task_item_list = null
		}
		super.DeleteMe()
	}



	_list_shop: Laya.List
	_img_bg: Laya.Image
	_img_bg4: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg5: Laya.Image
	_lb_money: Laya.Label
	_img_money_icon: Laya.Image
	_img_add: Laya.Image
	_box_task: Laya.Box
	_html_time: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._list_shop,
			this._img_bg,
			this._img_bg4,
			this._img_bg2,
			this._img_bg3,
			this._img_bg5,
			this._lb_money,
			this._img_money_icon,
			this._img_add,
			this._box_task,
			this._html_time,
		]
			= this.GetChildrenByNames([

				"_list_shop",
				"_img_bg",
				"_img_bg4",
				"_img_bg2",
				"_img_bg3",
				"_img_bg5",
				"_lb_money",
				"_img_money_icon",
				"_img_add",
				"_box_task",
				"_html_time",
			])
	}
}
window["EudaemonShopView"] = EudaemonShopView
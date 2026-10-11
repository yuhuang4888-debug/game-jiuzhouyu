import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopModel, ShopEvent } from "../commonModel/ShopModel"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim, SetHtmlStyle, HtmlColorTxt } from "../util/Util"

export class BossDomainDoubleView extends BaseView1 {
	InitEvent
	LoadSuccess
	good_id
	goods_id
	goods_model
	reward
	use_background
	UpdateNum

	public constructor() {
		super()

		this.base_file = "bossdomain"
		this.layout_file = "BossDomainDoubleView"
		this.use_background = true
		this.click_bg_toClose = true
		this.goods_id = 0
		this.reward = null
		this.is_center = true
		this.goods_model = GoodsModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		this.preload_server_config = { "config_decoration_boss_kv": false }
		this.load_callback = () => {
			SetHtmlStyle(this.cur, { f: 20, c: "#663519", ww: false, w: 200 })
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.btn, () => {
				let num = goods_model.GetTypeGoodsNum(this.good_id)
				if (num > 0) {
					let goods_id = goods_model.GetOneGoodsByTypeId(this.good_id)
					goods_model.Fire(GoodsModel.USE_BAG_GOODS, goods_id, 1)
					this.Close()
				} else {
					ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "QuickBuyView", { type_id: this.good_id, goods_num: 1 })
				}
			}, this, true)

			this.BindEvent(this.goods_model, GoodsModel.CHANGE_BAG_LIST, (goods_list?) => {
				if (!goods_list || goods_list.length == 0) {
					return
				}
				for (let i in goods_list) {
					var vo = goods_list[i]
					if (vo.type_id == this.good_id) {
						this.UpdateNum()
						break
					}
				}
			})
		}

		this.LoadSuccess = () => {
			this.good_id = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_boss_kv", false)[23].value//Config.Decorationbosskv[23].value
			if (!this.reward) {
				this.reward = new BaseAwardItem(this.gp_reward)
				this.reward.SetItemSize(88, 88)
				this.reward.Load()
			}

			let goods_vo = goods_model.GetGoodsBasicByTypeId(this.good_id)
			if (goods_vo) {
				this.reward.SetData(goods_vo.type_id)
			}
			this.UpdateNum()
		}

		this.UpdateNum = () => {
			let goods_vo = goods_model.GetGoodsBasicByTypeId(this.good_id)
			if (goods_vo) {
				let num = goods_model.GetTypeGoodsNum(this.good_id)
				this.name.text = Trim(goods_vo.goods_name)
				//this.name.color = ColorUtil.GetReplaceChar(ColorUtil.GetColorDark(goods_vo.color))
				this.cur.innerHTML = `当前拥有：${HtmlColorTxt(num, "'#0a953e'")}`
				this.labelDisplay1.text = num > 0 && "使用" || "获取"
			}
		}

		this.destroy_callback = () => {
			if (this.reward) {
				this.reward.DeleteMe()
				this.reward = null
			}
		}
	}

	public DeleteMe() {


		super.DeleteMe()
	}



	Image: Laya.Image
	close: Laya.Image
	Image4: Laya.Image
	gp_reward: Laya.Box
	name: Laya.Label
	cur: Laya.HTMLDivElement
	state: Laya.Label
	desc: Laya.Label
	_Image2: Laya.Image
	_lb_win_name: Laya.Label
	btn: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	public GetComponents() {
		[
			this.Image,
			this.close,
			this.Image4,
			this.gp_reward,
			this.name,
			this.cur,
			this.state,
			this.desc,
			this._Image2,
			this._lb_win_name,
			this.btn,
			this._Image11,
			this.labelDisplay1,
		]
			= this.GetChildrenByNames([

				"Image",
				"close",
				"Image4",
				"gp_reward",
				"name",
				"cur",
				"state",
				"desc",
				"_Image2",
				"_lb_win_name",
				"btn",
				"_Image11",
				"labelDisplay1",
			])
	}
}
window["BossDomainDoubleView"] = BossDomainDoubleView
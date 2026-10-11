import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { Config } from "../common/Config";
import { EquipmentItem } from "../common/EquipmentItem";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LungModel } from "../commonModel/LungModel";
import { ShopEvent, ShopModel } from "../commonModel/ShopModel";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil } from "../util/ColorUtil";
import { AtlasUrl, HtmlColorTxt, Util } from "../util/Util";

export class LungShopItem extends BaseItemRenderer {
	public WIDTH = 191
	public HEIGT = 264


	static height = 264
	private item: EquipmentItem
	private model: ShopModel
	private cost_item: EquipmentItem
	private type_id
	public constructor() {
		super();
		this.base_file = "lung"
		this.layout_file = "LungShopItem"
		this.Load()
	}

	public load_callback() {
		this.model = ShopModel.GetInstance()
		this.item = new EquipmentItem(this.goods_icon)
		this.item.Load()
		this.item.SetItemSize(85, 85)

		this.cost_item = new EquipmentItem(this.cost_icon)
		this.cost_item.Load()
		this.cost_item.SetItemSize(43, 43)
		this.cost_item.SetItembgVisible(false)

		Util.AddClickEvent(this.exchangeBtn, () => {
			if (this.data && this.data.mystery_shop_good) {
				if (this.sell_out.visible) {
					Message.show("没货了")
				} else {
					if (this.data.mystery_shop_good) {
						let [enough, gap, my_have, str] = this.model.MoneyIsEnough(this.data.mystery_shop_good.price_type, this.data.price)
						if (!enough) {
							Message.show(str)
							return
						}
					}
					this.model.Fire(ShopEvent.SHOP_REQUEST_PROTO, 15307, "hhi", this.data.mystery_shop_good.type, this.data.cfg_id, this.data.price)
				}
			}
		}, this, true)

		let success_fun = (cfg_id) => {
			if (this.data && this.data.cfg_id == cfg_id) {

			}
		}
		this.BindEvent(this.model, ShopEvent.SHOP_MYSTERY_BUY_SUCCESS, success_fun)

		let change_fun = ()=>{
			this.SetBuyState()
		}
		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_LUNG_BAG_LIST, change_fun)

		// let refresh_fun = (_type, cfg_id) => {
		// 	if (this.data && this.data.cfg_id == cfg_id) {
		// 		this.data = this.model.GetMysteryDataById(this.data.type, cfg_id)
		// 		this.SetBuyState()
		// 	}
		// }
		// this.BindEvent(this.model, ShopEvent.UPDATE_MYSTERY_SHOP_ONE_DATA, refresh_fun)

		// let score_fun = (vo) => {
		// 	if (vo.currency_id == LungModel.LungStone1 || vo.currency_id == LungModel.LungStone2 || vo.currency_id == LungModel.LungStone3) {
		// 		this.SetBuyState()
		// 		this.ShowDot()
		// 	}
		// }
		// this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_SPECIAL_SCORE, score_fun)
	}

	protected dataChanged(): void {
		if (super.dataChanged()) {
			let self = this
			let reward_data = JSON.parse(this.data.mystery_shop_good.goods)
			if (Util.TableSize(reward_data) < 1) {
				return
			}
			reward_data = reward_data[0]
			let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward_data[0], reward_data[1])
			let goodsVo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
			if (goodsVo) {
				this.type_id = goodsVo.type_id
				if (this.item) {
					this.item.DeleteMe()
					this.item = null
				}
				this.item = new EquipmentItem(this.goods_icon)
				this.item.Load()
				this.item.SetItemSize(84, 84)
				this.item.SetData(goodsVo.type_id, reward_data[2], null, null, null, null, null, null, null, 1)
				let color_str = ColorUtil.GetColorLight(goodsVo.color, false)
				let name = `${(goodsVo.goods_name).trim()}`
				this.goods_name.color = color_str
				this.goods_name.text = Util.StrToHTML(name)
				let resName:string = "";
				if(this.data.type == 64){
					if(this.isCurWear(this.type_id)){
						resName = "ui_rare_53"
					}else if(this.isHigherQuality(this.type_id)){
						resName = "ui_rare_55"
					}else if(LungModel.GetInstance().getCanInsertByTypeId(this.type_id)){
						resName = "ui_rare_54"
					}
				}
				if(resName){
					this.wear_tag.skin = AtlasUrl("lung", resName)
					this.wear_tag.visible = true
				}else{
					this.wear_tag.skin = ""
					this.wear_tag.visible = false
				}
				
				// let have_wear = LungModel.GetInstance().HasWearTheSameTypeAndColorDown(this.type_id)
				// this.wear_tag.visible = have_wear
			}
			this.cost_num.text = String(this.data.price)

			let cost_type_id = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.mystery_shop_good.price_type] ? Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.mystery_shop_good.price_type].goods_id : 0
			this.cost_item.SetData(cost_type_id, 0)
			this.SetBuyState()
			let my_have = 0
			if (cost_type_id == LungModel.LungStone1) {
				my_have = GoodsModel.GetInstance().GetSpecialScore(LungModel.LungStone1)
			} else if (cost_type_id == LungModel.LungStone2) {
				my_have = GoodsModel.GetInstance().GetSpecialScore(LungModel.LungStone2)
			} else if (cost_type_id == LungModel.LungStone3) {
				my_have = GoodsModel.GetInstance().GetSpecialScore(LungModel.LungStone3)
			}
			let color_str = "#0a953e"
			if (my_have < this.data.price) {
				color_str = "#ff4f50"
			}
			this.cost_num.color = color_str
		}
	}

	public SetBuyState() {
		if (this.data) {
			let [enough, gap, my_have, alert_str] = this.model.MoneyIsEnough(this.data.mystery_shop_good.price_type, this.data.price)
			let color_str = enough ? "#0a953e" : "#ff4f50"
			this.cost_num.color = color_str

			let show_out = false
			if (this.data.mystery_shop_good.limit > 0) {
				show_out = this.data.mystery_shop_good.limit - this.data.buy_num > 0 ? false : true
			}
			this.sell_out.visible = show_out
			this.item.SetGary(show_out)
			this.ShowDot()
			let limit_color = (!show_out) && ColorUtil.GetColorDark(0) || ColorUtil.GetColorDark(5)
			let limit_text = (this.data.mystery_shop_good.limit - this.data.buy_num) + "/" + this.data.mystery_shop_good.limit
			limit_text = HtmlColorTxt(limit_text, limit_color)
			this.limit_num.style.fontSize = 20
			this.limit_num.width = 100
			this.limit_num.style.color = "#0a953e"
			this.limit_num.innerHTML = Util.StrToHTML(limit_text)
			if(this.data.type == 64){
				this.style.skin = AtlasUrl("lung", `${LungModel.GetInstance().GetLungStyleSource(this.data.sub_type)}`)
			}else{
				this.style.skin = ""
			}
		}
	}

	public ShowDot() {
		if (this.data) {
			let show = LungModel.GetInstance().ShopDot(this.data)
			this.red_dot.visible = show
		}
	}

	private isHigherQuality(typeId : number) {
		let composeId: number = LungModel.GetInstance().getCanComposeId(typeId);
		for (let i = 0; i <= 12; i++) {
			let wear = GoodsModel.GetInstance().wear_lung_list[i];
			if(wear && wear.type_id){
				if(Math.floor(composeId/10) == Math.floor(wear.type_id/10)){
					return composeId > wear.type_id
				}
			}
		}
		return false
	}

	private isCurWear(typeId : number) {
		let composeId: number = LungModel.GetInstance().getCanComposeId(typeId);
		for (let i = 0; i <= 12; i++) {
			let wear = GoodsModel.GetInstance().wear_lung_list[i];
			if(wear && wear.type_id){
				let maxLv = LungModel.GetInstance().LungIsTopLevel(wear.type_id, wear.level)
				if(!maxLv&& composeId == wear.type_id){
					return true
				}
				
			}
		}
		return false
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		if (this.cost_item) {
			this.cost_item.DeleteMe()
			this.cost_item = null
		}
		super.DeleteMe()
	}

	
	bg: Laya.Image
	wear_tag: Laya.Image
	goods_name: Laya.Label
	_Image1: Laya.Image
	goods_icon: Laya.Box
	cost_icon: Laya.Box
	cost_num: Laya.Label
	exchangeBtn: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	red_dot: Laya.Image
	sell_out: Laya.Image
	limit_conta: Laya.HBox
	limitLb: Laya.Label
	limit_num: Laya.HTMLDivElement
	cost_group: Laya.Box
	style: Laya.Image

	public GetComponents() {
		[
			this.bg,
			this.wear_tag,
			this.goods_name,
			this._Image1,
			this.goods_icon,
			this.cost_icon,
			this.cost_num,
			this.exchangeBtn,
			this._Image2,
			this._Label1,
			this.red_dot,
			this.sell_out,
			this.limit_conta,
			this.limitLb,
			this.limit_num,
			this.cost_group,
			this.style,
		]
			= this.GetChildrenByNames([

				"bg",
				"wear_tag",
				"goods_name",
				"_Image1",
				"goods_icon",
				"cost_icon",
				"cost_num",
				"exchangeBtn",
				"_Image2",
				"_Label1",
				"red_dot",
				"sell_out",
				"limit_conta",
				"limitLb",
				"limit_num",
				"cost_group",
				"style",
			])
	}
}
window["LungShopItem"] = LungShopItem
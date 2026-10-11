import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { PlatformManager } from "../PlatformManager";
import { ColorUtil } from "../util/ColorUtil";
import { ErlangParser } from "../util/ErlangParser";
import { SetHtmlCenter, SetLocalPosition, Util } from "../util/Util";


export class RuneConvertItem extends BaseItemRenderer {
	public WIDTH = 180 
	public HEIGT = 251

	//private needRefresh
	private item: BaseAwardItem
	private model: RuneModel
	private cost_item: BaseAwardItem
	private name_pos

	SetData
	InitEvents
	LoadSuccess
	public constructor(parent) {
		super();
		this.base_file = "rune";
		this.layout_file = "RuneConvertItem";
		this.model = RuneModel.GetInstance()
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.DeleteMe = () => {
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

		this.LoadSuccess = () => {
			this.name_pos = this.goods_name.y
			this.goods_name.style.fontSize = 22
			if(!PlatformManager.IsEyouPlatform()){
			this.pro.style.fontSize = 20
			}else{
				this.pro.style.fontSize = 18
			}

		}

		this.InitEvents = () => {
			Util.AddClickEvent(this.btn_conta, () => {
				this.model.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16703, "hi", this.data.id, 1)
			}, this, true)

			// if (this.needRefresh) {
			// 	this.SetData(this.data)
			// }
		}

		this.SetData = () => {
			// this.data = data
			if (this.is_loaded && this.data) {
				let goods_list = JSON.parse(this.data.goods_list)
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(goods_list[0][0], goods_list[0][1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					if (!this.item) {
						this.item = new BaseAwardItem(this.icon_conta)
						this.item.Load()
						this.item.SetItemSize(85, 85)
					}
					// this.item.SetData(type_id, goods_list[0][2], null, lock)
					this.item.SetData(type_id, goods_list[0][2], lock)
					let str = "<font color=" + ColorUtil.GetColorDark(goods_vo.color) + ">" + (goods_vo.goods_name).trim() + "</font>"
					this.goods_name.innerHTML = Util.StrToHTML(str)
					SetHtmlCenter(this.goods_name, {x:0, w:172})
					if (goods_vo.subtype != 99) {
						if (goods_vo.type_id != RuneModel.RuneCrystal) {
							this.goods_name.y = this.name_pos
							let pro_list = this.model.GetRuneProList(goods_vo.subtype, 1, goods_vo.color)
							if (pro_list) {
								this.pro.innerHTML = Util.StrToHTML(this.model.GetProStr(pro_list, ColorUtil.GetColorDark(1)))
							}
						} else {
							this.pro.innerHTML = ""
							this.goods_name.y = this.name_pos + 20
						}
					} else {
						this.goods_name.y = this.name_pos
						str = this.model.GetJingHuaExpDesc(goods_vo.type_id)
						this.pro.innerHTML = Util.StrToHTML(str)
					}
					if(PlatformManager.IsEyouPlatform()){
						this.pro.style.wordWrap = true
						this.pro.style.align= "center"
						this.pro.style.leading = 0.1
						this.pro.style.width = 172
						SetHtmlCenter(this.pro, {x:0, w:172})
					}else{
						SetHtmlCenter(this.pro, {x:0, w:172})
					}
				}
				let condition = JSON.parse(this.data.condition)
				this.condition.text = ""
				if (condition) {
					let floor = condition[0][1]
					if (this.model.rune_tower_floor >= floor) {
						this.btn_conta.visible = true
						if (!this.cost_item) {
							this.cost_item = new BaseAwardItem(this.cost_icon)
							this.cost_item.Load()
						}
						this.cost_item.SetItemSize(50, 50)
						this.cost_item.SetItembgVisible(false)
						this.cost_item.SetData(RuneModel.RuneStone, 0)
						this.cost_item.SetShowTips(false)

						let str = this.data.rune_chip_num
						this.price.text = Util.StrToHTML(str)
					} else {
						this.btn_conta.visible = false
						this.condition.text = `通关御魂塔第${floor}层`
					}
				}

				
			} 
			// else {
			// 	this.needRefresh = true
			// }

		}

		this.Load()
	}

	public dataChanged(){
		if(!super.dataChanged())return
		this.SetData()
	}
	
	bg: Laya.Image
	_Image1: Laya.Image
	icon_conta: Laya.Box
	goods_name: Laya.HTMLDivElement
	pro: Laya.HTMLDivElement
	condition: Laya.Label
	btn_conta: Laya.Box
	buyBtn: Laya.Image
	cost_icon: Laya.Box
	price: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this._Image1,
			this.icon_conta,
			this.goods_name,
			this.pro,
			this.condition,
			this.btn_conta,
			this.buyBtn,
			this.cost_icon,
			this.price,
		]
			= this.GetChildrenByNames([

				"bg",
				"_Image1",
				"icon_conta",
				"goods_name",
				"pro",
				"condition",
				"btn_conta",
				"buyBtn",
				"cost_icon",
				"price",
			])
	}
}
window["RuneConvertItem"] = RuneConvertItem
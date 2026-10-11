import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim, SetHtmlStyle, SetHtmlCenter } from "../util/Util"

export class Kf1vnShopExchangeItem extends BaseItemRenderer {
	model
	type_id
	cost_item
	item
public WIDTH = 178
public HEIGT = 236
public constructor(parent){
super() 
	
	this.base_file = "kf1vn"
	this.layout_file = "Kf1vnShopExchangeItem"
	this.model = Kf1vnModel.GetInstance()
	this.type_id = null
	this.Load()
}

public load_callback(){ 
	
	//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("kf1vn","uismfb_019"))
    SetHtmlStyle(this.goods_name,{c:"#663519",f:20,ww:false,w:170,a:"center"})
	SetHtmlStyle(this.limit_num,{c:"#663519",f:18,ww:false,w:170,a:"center"})
	this.cost_item =  new BaseAwardItem(this.cost_conta)
	this.cost_item.Load()
	this.cost_item.SetItemSize(98, 98)
	this.cost_item.SetItembgVisible(false)
	
	this.InitEvents()
}

public InitEvents(){ 
	
	let buy_fun = () => {
		if (this.data ) {
			GoodsModel.GetInstance().Fire(GoodsModel.EXCHANGE_GOODS, this.data.id, 1)
		}
	}
	Util.AddClickEvent(this.buyBtn, buy_fun, this, true)
	
	let success_fun = (id?) => {
		if ((this.data && this.data.id == id) && this.type_id ) {

			let point = this.conta.localToGlobal(new Laya.Point(0,0),true)
			//let point = UILocalToCanvasPoint(this.conta,co.TableXY(0, 1), co.TableXY(0, 1))
			if (this.data.obtain_list && this.data.obtain_list[1] ) {
				
				GlobalEventSystem.Fire(EventName.REWARD_FLY, this.data.obtain_list, point, null, null, 0, 0)
				GoodsModel.GetInstance().Fire(GoodsModel.REQUEST_EXCHANGE_GOODS, Kf1vnModel.ExchangeShopType)
			}
		}
	}
	this.BindEvent(GoodsModel.GetInstance(), GoodsModel.BUY_SUCCESS, success_fun)
}

public dataChanged(){ 
	if(!super.dataChanged())return
	if (this.data ) {
		if (! this.item ) {
			this.item =  new BaseAwardItem(this.conta)
			this.item.SetUseMask(true)
			this.item.Load()
			this.item.SetItemSize(100, 100)
		}
		if (this.data.obtain_list && this.data.obtain_list[0] ) {
			let obtain_list = this.data.obtain_list[0]
			
			if (obtain_list ) {
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(obtain_list[1])
				if (basic ) {
					this.type_id = obtain_list[1]
					this.item.SetData(obtain_list[1], obtain_list[2])
					let color_str = ColorUtil.GetColorLight(basic.color)
					let name = "<font color=" + color_str + ">" + Trim(basic.goods_name) + "</font>"
					this.goods_name.innerHTML = Util.StrToHTML(name)
					SetHtmlCenter(this.goods_name,{x:0,w:170})
				}
			}
		}
		if (this.data.cfg && this.data.cfg.lim_num > 0 ) {
			let color_str = "'#639c12'"
			if (this.data.count >= this.data.cfg.lim_num ) {
				color_str = "'#00fa64'"
			}
			let is_max = this.data.count >= this.data.cfg.lim_num
			this.sell_out.visible = is_max 
			this.sell_out_btn.visible = is_max 
			this.buyBtn.visible = ! is_max 
			this.item.SetGary(is_max)
			this.limit_num.innerHTML = Util.StrToHTML("限购：<font color=" + color_str + ">" + (this.data.cfg.lim_num - this.data.count) + "/" + this.data.cfg.lim_num + "</font>")
		}else{
			this.limit_num.innerHTML = ""
		}
		SetHtmlCenter(this.limit_num,{x:0,w:170})
		let myhave = GoodsModel.GetInstance().GetSpecialScore(Kf1vnModel.ZhanHunTypeId)
		if (this.data.cost_list && this.data.cost_list[0] ) {
			let cost_list = this.data.cost_list[0]
			if (cost_list ) {
				this.cost_num.text = String(cost_list[2])
				this.cost_item.SetData(cost_list[1], 0)
				this.cost_item.SetShowTips(false)
				this.cost_item.SetItemSize(30,30)
				let enough = myhave >= Number(cost_list[2])
				let color_str = (enough && ( "#ffffff" ) || ( "#ffffff" ) )
				this.cost_num.color = ColorUtil.TryParseHtmlString(color_str)
			}
		}
		if (this.data.cfg && this.data.cfg.role_lv >= RoleManager.GetInstance().mainRoleInfo.level ) {
			this.level_limit.visible = true 
			this.level_limit.text = this.data.cfg.role_lv + "级开启"
			this.buyBtn.visible = false 
			this.sell_out_btn.visible = false 
			this.sell_out.visible = false 
		}else{
			this.level_limit.visible = false 
		}
		if (this._Group1 ) { 
			//LayoutRebuilder(this._Group1)	
		}
	}
}

public DeleteMe(){ 
	
	if (this.cost_item ) {
		this.cost_item.DeleteMe()
		this.cost_item = null
	}
	if (this.item ) {
		this.item.DeleteMe()
		this.item = null
	}
	super.DeleteMe()
}


_Image1:Laya.Image
_Image1_1:Laya.Image
goods_name:Laya.HTMLDivElement
limit_num:Laya.HTMLDivElement
conta:Laya.Box
sell_out:Laya.Image
buyBtn:Laya.Box
btn_img:Laya.Image
_Group1:Laya.HBox
cost_conta:Laya.Box
cost_num:Laya.Label
sell_out_btn:Laya.Box
btn_img1:Laya.Image
soldout_text0:Laya.Label
level_limit:Laya.Label
public GetComponents() {
[
this._Image1,
this._Image1_1,
this.goods_name,
this.limit_num,
this.conta,
this.sell_out,
this.buyBtn,
this.btn_img,
this._Group1,
this.cost_conta,
this.cost_num,
this.sell_out_btn,
this.btn_img1,
this.soldout_text0,
this.level_limit,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image1_1",
"goods_name",
"limit_num",
"conta",
"sell_out",
"buyBtn",
"btn_img",
"_Group1",
"cost_conta",
"cost_num",
"sell_out_btn",
"btn_img1",
"soldout_text0",
"level_limit",
])
}
}
 window["Kf1vnShopExchangeItem"]= Kf1vnShopExchangeItem
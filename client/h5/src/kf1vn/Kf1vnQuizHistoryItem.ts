import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"

export class Kf1vnQuizHistoryItem extends BaseItemRenderer {

item:BaseAwardItem
model
get_item
GetQuizCostList
GetDefendNumByTurn
public WIDTH = 535
public HEIGT = 80
public constructor(parent){
super() 
	
	this.base_file = "kf1vn"
	this.layout_file = "Kf1vnQuizHistoryItem"
	this.model = Kf1vnModel.GetInstance()	
	
	this.GetDefendNumByTurn = (turn?) => {
		let num = 0
		let config_kf_1vn_match=ResManager.GetInstance().GetGameConfigFromCache(this,"config_kf_1vn_match",false)
		if (config_kf_1vn_match) {
		  num = (config_kf_1vn_match[turn] && (config_kf_1vn_match[turn].c_num) || (0))
		}
		return num
	  }

	this.GetQuizCostList = (turn?) => {
		let cost_list = null
		let config_kf_1vn_bet=ResManager.GetInstance().GetGameConfigFromCache(this,"config_kf_1vn_bet",false)
		if (config_kf_1vn_bet) {
			let cfg = config_kf_1vn_bet[turn]
			if (cfg) {
				cost_list = JSON.parse(cfg.cost_list)
			}
		}
		return cost_list
	}

	this.Load()
}

public load_callback(){ 
	
	if (! this.item ) {
		this.item =  new BaseAwardItem(this.cost_icon)
		this.item.Load()
		this.item.SetItemSize(40, 40)
		this.item.SetItembgVisible(false)
		this.item.SetData(Kf1vnModel.CoinTypeId)
	}
	if (! this.get_item ) {
		this.get_item =  new BaseAwardItem(this.get_icon)
		this.get_item.Load()
		this.get_item.SetItemSize(40, 40)
		this.get_item.SetItembgVisible(false)
		this.get_item.SetData(Kf1vnModel.ZhanHunTypeId)
	}

	this.InitEvents()
}

public InitEvents(){ 
	
	let success_fun = (key?) => {
		if (this.data && this.data.key == key ) {
			Message.show("领取成功")
			// let pos = this.get_icon.localToGlobal(new Laya.Point(0,0),true)
			// this.model.Fire(Kf1vnEvent.QUIZ_REWARD_ICON_FLY, Kf1vnModel.ZhanHunTypeId, pos)
			
			let point = this.get_icon.localToGlobal(new Laya.Point(0,0))
			let list = [{ "0": 0, "1": Kf1vnModel.ZhanHunTypeId, "2": 1 }]
			GlobalEventSystem.Fire(EventName.REWARD_FLY, list, point, null, null, 0, 0)
		}
	}
	this.BindEvent(this.model, Kf1vnEvent.KF1VN_GET_QUIZ_REWARD_SUCCESS, success_fun)
	
	let buy_fun = () => {
		this.ClickFun()
	}
	Util.AddClickEvent(this.getBtn, buy_fun, this, true)
}

public dataChanged(){ 
	if(!super.dataChanged())return
	if (this.data ) {
		let num = this.GetDefendNumByTurn(this.data.race_2_turn)
		this.stage_txt.text = "1v" + num
		this.role_name.text =this.data.name +""
		this.sever_name.text=`S${this.data.server_num }`
		ResManager.GetInstance().SetImageSprite(this, this.result, "kf1vn", this.data.bet_result == 1 && "uikf1vn_014" || "uikf1vn_013")
		this.getBtn.visible = this.data.status == 2 
		this.get_state.visible = this.data.status == 1 
		let cfg = this.GetQuizCostList(this.data.race_2_turn)


		let target_vo = null
		if (cfg ) {

			for(let i=0;i<cfg.length;i++){
				let obj=cfg[i]
				if (Number(obj[0])  == this.data.bet_cost_type ) {
					target_vo = obj
					break
				}
			}


			if ((target_vo && target_vo[1]) && target_vo[1][0] ) {
				let cost_cfg = target_vo[1][0]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(cost_cfg[0], cost_cfg[1])
				if (this.item ) {
					this.item.SetData(type_id)
					this.cost_num.text = cost_cfg[2]
				}
				this.cost_num.text = cost_cfg[2]
				let get_cfg = (this.data.bet_result == 1 && ( target_vo[3] ) || ( target_vo[2] ) )
				if (get_cfg && get_cfg[0] ) {
					this.zhanhun.text = get_cfg[0][2]
				}
			}
			this.SetRedDot()
		}else{
			console.log("测试null")
		}
	}
}

public ClickFun(){ 
	
	if (this.data ) {
		this.model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62134, "l", this.data.key)
	}
}

public SetRedDot(){ 
	
	let show = this.model.HaveQuizRewardCanGet()
	this.red_dot.visible = show 
}

public DeleteMe(){ 
	
	if (this.item ) {
		this.item.DeleteMe()
		this.item = null
	}
	if (this.get_item ) {
		this.get_item.DeleteMe()
		this.get_item = null
	}
	super.DeleteMe()
}


_Image1:Laya.Image
stage_txt:Laya.Label
cost_num:Laya.Label
zhanhun:Laya.Label
role_name:Laya.Label
sever_name:Laya.Label
result:Laya.Image
cost_icon:Laya.Box
get_icon:Laya.Box
getBtn:Laya.Box
btn_img:Laya.Image
get_label:Laya.Label
red_dot:Laya.Image
get_state:Laya.Image
public GetComponents() {
[
this._Image1,
this.stage_txt,
this.cost_num,
this.zhanhun,
this.role_name,
this.sever_name,
this.result,
this.cost_icon,
this.get_icon,
this.getBtn,
this.btn_img,
this.get_label,
this.red_dot,
this.get_state,
]
 = this.GetChildrenByNames([

"_Image1",
"stage_txt",
"cost_num",
"zhanhun",
"role_name",
"sever_name",
"result",
"cost_icon",
"get_icon",
"getBtn",
"btn_img",
"get_label",
"red_dot",
"get_state",
])
}
}
 window["Kf1vnQuizHistoryItem"]= Kf1vnQuizHistoryItem
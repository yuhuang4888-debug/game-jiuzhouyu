import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { Kf1vnModel, Kf1vnEvent } from "../commonModel/Kf1vnModel"
import { Kf1vnQuizHistoryItem } from "./Kf1vnQuizHistoryItem"

//竞猜记录
export class Kf1vnQuizHistoryView extends BaseItem1 {
DeleteFlyGroup
IconFly
InitContent
InitEvents
LoadSuccess
SetData
loop_loop_mgr
public constructor(parent?){
super(parent) 
	
	this.base_file = "kf1vn"
	this.layout_file = "Kf1vnQuizHistoryView"
	let model = Kf1vnModel.GetInstance()
	let data_ = null
	let needRefresh_ = null
	let icon_fly_group_ = []
	this.preload_server_config={"config_kf_1vn_match":false,"config_kf_1vn_bet":false}
	this.load_callback = () => {
		this.LoadSuccess()
		this.InitEvents()
	}

	this.LoadSuccess = () => {
		
		model.Fire(Kf1vnEvent.KF1VN_REQUEST_PROTO, 62133)
	}

	this.InitEvents = () => {
		this.BindVar(model, "quiz_history",(key?, value?) => {
				this.SetData()
			}
		)
		
		let fly_fun = (data?, pos?) => {
			this.IconFly(data, pos)
		}
		this.BindEvent(model, Kf1vnEvent.QUIZ_REWARD_ICON_FLY, fly_fun)
		
		if (needRefresh_ ) {
			this.SetData()
		}
	}

	this.SetData = () => {
		data_ = model.quiz_history || {}
		if (this.is_loaded && data_ ) {
			this.none_conta.visible = ! ((data_ && data_.bet_list  && data_.bet_list.length > 0))
			
			this.InitContent()
		}else{
			needRefresh_ = true
		}
	}

	this.InitContent = () => {
		if (! this.loop_loop_mgr ) {
			this.loop_loop_mgr =  new LoopScrowViewMgr()
			this.loop_loop_mgr.SetData(this.Content ,Kf1vnQuizHistoryItem, data_.bet_list, LoopScrCon.Vertical)
		}else{
			this.loop_loop_mgr.replaceAll(data_.bet_list)
		}
	}

	this.IconFly = ( type_id?, pos?) => {
		if (type_id && pos ) {
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
			//award:SetItemSize(80, 80)
			//award:SetItembgVisible(false)
			//let delayFunc = () => {
				//if (award ) {
					//award:DeleteMe()
					//award = null
				//}
				//this:removeChild(group)
				//// [ts2lua]icon_fly_group_下标访问可能不正确
				//icon_fly_group_[group.hashCode] = null
			//}

			//Laya.Tween.get(group):to({alpha=0.5}):to({y=group.y - 40, alpha=1}, 300):to({x=110, y=LayerManager:GetInstance().stageHeight - 69, scaleX=0.8, scaleY=0.8, alpha=0}, 700, Laya.Ease.cubicIn).call(delayFunc)
		}
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

public DeleteMe(){ 
	
	this.DeleteFlyGroup()
	if (this.loop_loop_mgr ) {
		this.loop_loop_mgr.DeleteMe()
		this.loop_loop_mgr = null
	}
	super.DeleteMe()
}


sub_conta:Laya.Box
_Image1:Laya.Image
_Group1:Laya.Box
_Image2:Laya.Image
_Image3:Laya.Image
_Image4:Laya.Image
_Image5:Laya.Image
_Image6:Laya.Image
_Image7:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
_Label4:Laya.Label
_Label5:Laya.Label
_Label6:Laya.Label
Content:Laya.List
none_conta:Laya.Box
tips1:Laya.Label
tips_icon1:Laya.Image
public GetComponents() {
[
this.sub_conta,
this._Image1,
this._Group1,
this._Image2,
this._Image3,
this._Image4,
this._Image5,
this._Image6,
this._Image7,
this._Label1,
this._Label2,
this._Label3,
this._Label4,
this._Label5,
this._Label6,
this.Content,
this.none_conta,
this.tips1,
this.tips_icon1,
]
 = this.GetChildrenByNames([

"sub_conta",
"_Image1",
"_Group1",
"_Image2",
"_Image3",
"_Image4",
"_Image5",
"_Image6",
"_Image7",
"_Label1",
"_Label2",
"_Label3",
"_Label4",
"_Label5",
"_Label6",
"Content",
"none_conta",
"tips1",
"tips_icon1",
])
}
}
 window["Kf1vnQuizHistoryView"]= Kf1vnQuizHistoryView
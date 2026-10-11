import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { achvModel } from "../commonModel/achvModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { TimeUtil } from "../util/TimeUtil"
import { SetSizeDelta, SetAnchoredPositionY, Util, SetSizeDeltaX } from "../util/Util"

export class achvSubItem extends BaseItemRenderer {
Content
cfg
expImg
expLb
is_batch
model
no_click_time
parent_mask_corners
receiveBtn
receivedImg
reddot
rewardGp
rewardList
titleLb
unfinishLb
vhscroll
_Image1:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_Image11:Laya.Image
labelDisplay:Laya.Label
_Scroller1:Laya.Panel

public static width = 680
public static height = 120

public WIDTH=680
public HEIGT=131

task_model = window["TaskModel"].GetInstance()


public constructor(parent){
super() 
	
	this.is_batch = true
	this.model = achvModel.GetInstance();
	this.base_file = "achv"
	this.layout_file = "achvSubItem"
	//this.layer_value = Enum_UILayer.UI
	this.no_click_time = 0
	this.Load()
}





public load_callback(){
	    // super.createChildren()
	//BaseAwardItem.StartBatchLoad()
	//this.vhscroll = this.GetChild("_Scroller1").GetComponent("VHScrollRect")
	//this.vhscroll.parentScroll = this.form.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect))

	
	this.LoadSuccess()
	// if (PlatformManager.IsEyouIdnPlatform ) {
	// 	this.unfinishLb.size  = 18
	// 	this.titleLb.size  = 17
	// 	//let csf = this.titleLb.GetComponent("ContentSizeFitter")
	// 	//csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
	// 	//csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
	// 	SetSizeDelta(this.titleLb,265,35)
	// 	this.titleLb.lineSpacing = 0.7
	// 	this.titleLb.verticalAlign = "middle"
	// 	this.titleLb.textAlign = "left"
	// 	SetAnchoredPositionY(this.titleLb,-21)
	// }
	// if (PlatformManager.IsEyouEnPlatform) {
	// 	this.titleLb.size  = 17
	// 	//let csf = this.titleLb.GetComponent("ContentSizeFitter")
	// 	//csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
	// 	//csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
	// 	SetSizeDelta(this.titleLb,265,35)
	// 	this.titleLb.lineSpacing = 0.7
	// 	this.titleLb.verticalAlign = "middle"
	// 	this.titleLb.textAlign = "left"
	// 	SetAnchoredPositionY(this.titleLb,-21)
	// }
}


public LoadSuccess(){ 
	
	Util.AddClickEvent(this.receiveBtn,() => {
			// if (this.no_click_time > TimeUtil.getClientTime() ) {
			// 	return
			// }
			if (! GoodsModel.GetInstance().CheckEquipNum(5, 5) ) {
				return
			}
			if (this.data ) {
				this.model.Fire(achvModel.REQUEST_PROTO, 40905, "i", this.data.id)
				if (this.cfg ) {
					//GlobalEventSystem.Fire(EventName.REWARD_FLY, ErlangParser.GetInstance().Parse(this.cfg.reward), this.rewardGp.localToGlobal(0, 0))
					let pos = this.receiveBtn.localToGlobal(new Laya.Point(0,0))
					GlobalEventSystem.Fire(EventName.REWARD_FLY, ErlangParser.GetInstance().Parse(this.cfg.reward),pos)
					 //(this.rewardGp, co.TableXY(0,1), co.TableXY(0,1)))
				}
			}
			// this.no_click_time = TimeUtil.getClientTime() + 0.2
		}
		, this, true)
		this.BindEvent(achvModel.GetInstance(), achvModel.U_AC_D,(achvVo?) => {
			
		}
	)

	//this.parent_mask_corners = GetWorldCorners(this.parent_wnd.GetComponentInParent(typeof(UnityEngine.UI.ScrollRect)).transform.Find("listGp"))
	//this.RegisterMask(this.rewardGp, 2)
	// this.RegisterMask(this.rewardGp)
}

public dataChanged(){ 
	
	if (super.dataChanged() ) {
		ResManager.GetInstance().LoadGameConfig(ResManager.GetInstance(), "config_achievement",false,undefined,(cfgs)=>{
			this.SetStaticData(cfgs)
			this.UpdateAchvDate()
		});
	}
}

public SetStaticData(cfgs?){ 
	
	let achievement_cfg = cfgs
	this.cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_achievement.name, this.data.id, false, achievement_cfg)
	if (! this.cfg ) {
		return
	}
	this.titleLb.text = this.cfg.desc
	let diamondReward = ErlangParser.GetInstance().Parse(this.cfg.reward)
	if (! this.rewardList ) {
		this.rewardList = []
	}
	let pointReward = [0, 40, this.cfg.star]
	if (diamondReward ) {
		// diamondReward.unshift(pointReward)
		table.unshift(diamondReward, pointReward)
	}else{
		diamondReward = pointReward
	}
	if (diamondReward ) {
		let i = 0
		do {
			// let goodsInfo = GoodsModel.GetInstance().GetMappingTypeId(diamondReward[i][0], diamondReward[i][1])
			let goods_id = GoodsModel.GetInstance().GetMappingTypeId(diamondReward[i][0], diamondReward[i][1])
			let goodsbasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id[0])
			let item = this.rewardList[i]
			if (! item ) {
				item =  new BaseAwardItem(this.Content, null, Enum_UILayer.UI, null, this.is_batch)
				//item.SetMaskId(2)
				//item.SetMaskRect(this.parent_mask_corners)
				item.Load()
				item.SetItemSize(80, 80)
				item.ExcuteCallback(() => {
					item.SetFontSize(35)
				})
				this.rewardList[i] = item
			}
			item.SetVisible(true)
			// item.includeInLayout = true
			item.SetData(goodsbasic.type_id, diamondReward[i][2])
			i=i+1
		} while ((i < diamondReward.length))

		for (let i = diamondReward.length + 1; i <= this.rewardList.length; i++){
			let item = this.rewardList[i]
			if (item ) {
				item.SetVisible(false)
				// item.includeInLayout = false
			}
		}
	}
	if ((this.task_model.IsCurrMainLineTaskTipType(TaskTipType.AchvAward) && this.model.guide_id) && this.model.guide_id == this.data.id ) {
		let setp_cfg = {direction:6, text:"<font color='#FFFF00'>领取奖励</font>~"}
		GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.receiveBtn, "UI", null, null, null, null, setp_cfg)
	}else{
		GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.receiveBtn)
	}
}

public UpdateAchvDate(){ 
	
	if (this.data ) {
		let status = this.data.status
		this.unfinishLb.visible = status == 0 
		this.receiveBtn.visible = status == 1 
		this.reddot.visible = status == 1 
		this.receivedImg.visible = status == 2 
		if (this.cfg ) {
			if (this.cfg.show_progress == 0 ) {
				if (status == 0 ) {
					this.expLb.text = "0/1"
					// this.expImg.mask.width = 0
					SetSizeDeltaX(this.expImg, 0)
				}else{
					this.expLb.text = "1/1"
					SetSizeDeltaX(this.expImg, 230)
				}
			} else if (this.cfg.show_progress == 1 ) {
				let condition = ErlangParser.GetInstance().Parse(this.cfg.condition)
				// [ts2lua]condition下标访问可能不正确
				if (condition && condition[condition.length-1] ) {
					// [ts2lua]condition下标访问可能不正确
					this.expLb.text = this.data.progress + "/" + condition[condition.length-1][1]
					// [ts2lua]condition下标访问可能不正确
					SetSizeDeltaX(this.expImg, 230 * this.data.progress / condition[condition.length-1][1])
				}
			}
		}
	}
}

public DeleteMe(){ 
	
	if (this.rewardList ) {
		for (let _tmpi in this.rewardList) {
			var vo = this.rewardList[_tmpi]
			vo.DeleteMe()
		}
		this.rewardList = null
	}
	super.DeleteMe()
	//BaseAwardItem.EndBatchLoad()
}

	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this.receivedImg,
			this._Image3,
			this.expImg,
			this.titleLb,
			this.expLb,
			this.receiveBtn,
			this._Image11,
			this.labelDisplay,
			this.unfinishLb,
			this._Scroller1,
			this.Content,
			this.reddot,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"receivedImg",
				"_Image3",
				"expImg",
				"titleLb",
				"expLb",
				"receiveBtn",
				"_Image11",
				"labelDisplay",
				"unfinishLb",
				"_Scroller1",
				"Content",
				"reddot",
			])
	}
}
window["achvSubItem"] = achvSubItem
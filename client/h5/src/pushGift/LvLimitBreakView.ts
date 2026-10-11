import { BaseView1 } from "../common/BaseView1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, SetSizeDeltaY, Util } from "../util/Util"

export class LvLimitBreakView extends BaseView1 {
Scr_Scroller1
_Image1
_Scroller1
_Text1
_Viewport1
_btn_close
_btn_go
_gp_cost
_gp_reward
_gp_time
_img_bg
_img_go
_img_zk
_lb_desc
_lb_go
_lb_have
background_alpha
base_type
change_scene_close
click_bg_toClose
data
destroy_callback
destroy_imm
end_time
info
info_cond
level_change_bind
model
open_callback
reach_lv
reward_items
role_mgr
sub_type
timer
use_background


public constructor(){
super() 
	
	this.base_file = "pushGift"
	this.layout_file = "PushGiftTips"
	this.layer_value = Enum_UILayer.Activity
	this.use_background = true
	this.background_alpha = 0.8
	this.click_bg_toClose = true
	this.destroy_imm = true
	this.change_scene_close = true

	this.base_type = null
	this.sub_type = null
	this.info = null
	this.data = null
	this.timer = null
	this.reward_items = null

	this.model = CustomActivityModel.GetInstance()
	this.role_mgr = RoleManager.GetInstance()

	this.load_callback = () => {
		
		this._gp_cost.visible = false 
		this._img_zk.visible = false 
		SetAnchoredPositionX(this._Image1, 250)
		SetSizeDeltaY(this._Text1, 65)
		this._lb_desc.lineSpacing = 1
		//if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		//this._lb_desc.size  = 16
		//this._lb_desc.lineSpacing = 0.8
		//}
		this.InitEvent()
	}

	this.open_callback = () => {
		this.InitView()
	}

	this.destroy_callback = () => {
		this.Remove()
	}
}

public InitView(){ 
	
	//背景图
	ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("pushGift","uitslb_007"), true)
	ResManager.GetInstance().SetImageSprite(this, this._Image1, "pushGift_asset", "uicjhd_001", true)

	if (! this.info ) {
		return
	}
	this.base_type = this.info.base_type
	this.sub_type = this.info.sub_type
	this.info_cond = this.model.GetActCondition(this.base_type, this.sub_type, "info")
	this.data = this.model.GetActData(this.base_type, this.sub_type)

	let llb_data = this.model.llb_data
	this.end_time = llb_data.end_time

	//礼包说明
	this._lb_desc.text = "15분 내에 100레벨 달성 시 수령가능"

	this.timer = this.model.LoadActTimer(this._gp_time, this.end_time, null, null, null, null, "선물남은시간:", 478)
	
	this.ShowBtn()
	this.ShowReward()
}

public InitEvent(){ 
	
	Util.AddClickEvent(this._btn_go,() => {
			if (this.reach_lv ) {
				this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this.base_type, this.sub_type, 1)
			}
		}, this, true)
	
	Util.AddClickEvent(this._btn_close,() => {
			this.Close()
		}, this, true)

	this.level_change_bind = this.role_mgr.GetMainRoleVo().Bind(EventName.CHANGE_LEVEL,(level?) => {
			this.ShowBtn()
		})

	this.BindEvent(this.model, CustomActivityDefine.EVENT.ANSWER_TARGET,(...new_args) => {
			let args = new_args
			if (this.base_type == args[1] && this.sub_type == args[2] ) {
				if (args[4] && args[4].reward ) {
					let reward = this.model.GetActReward(args[1], args[2], args[4].form_type, args[4].reward)
					if (reward && reward.length ) {
						let view =  new CongratulationObtainView(reward, 10)
						view.Open()
					}
				}

				this.model.DeleteSpecialIcon(this.base_type, this.info)
				this.Close()
			}
		})
}

public ShowBtn(){ 
	
	if (! this.info_cond ) {
		return
	}

	let role_lv = this.role_mgr.GetMainRoleLevel()
	this.reach_lv = role_lv >= Number(this.info_cond.max_lv)
	Util.SetImageGray(this._btn_go, ! this.reach_lv)
	this._Text1.text = this.reach_lv && "수령" || "레벨 미달성"

	if (this.reach_lv ) {
		this.role_mgr.GetMainRoleVo().UnBind(this.level_change_bind)
		this.level_change_bind = null
		
		if (this.timer ) {
			this.timer.DeleteMe()
			this.timer = null
		}
	}
}

public ShowReward(){ 
	
	if (! this.data ) {
		return
	}

	if (! this.reward_items ) {
		this.reward_items = []
	}

	let rewards = this.data.reward_list[1]
	let list = this.model.GetActReward(this.base_type, this.sub_type, rewards.form_type, rewards.reward)
	for (let i = 0; i < list.length; i++) {
		var vo = list[i]
		let item = this.reward_items[i]
		if (! item ) {
			item =  new EquipmentItem(this._gp_reward, null, "Activity")
			item.SetScale(0.9)
			item.SetMaskId(1)
			item.Load()
			table.insert(this.reward_items, item)
		}
		let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(vo[2])
		if (basic ) {
			item.SetData(vo[2], vo[3])
		}
	}

}

public SetActInfo(info?, parm?){ 
	
	this.info = info
}

public Remove(){ 
	
	if (this.timer ) {
		this.timer.DeleteMe()
		this.timer = null
	}

	if (this.reward_items && this.reward_items.length > 0 ) {
		for (let i in this.reward_items) {
			var item = this.reward_items[i]
			item.DeleteMe()
		}
		this.reward_items = null
	}

	this.role_mgr.GetMainRoleVo().UnBind(this.level_change_bind)
	this.level_change_bind = null
}


}

window["LvLimitBreakView"] = LvLimitBreakView
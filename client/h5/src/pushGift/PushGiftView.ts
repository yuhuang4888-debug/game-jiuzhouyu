import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { PushGiftModel } from "../commonModel/PushGiftModel"
import { ViewGiftPopModel } from "../commonModel/ViewGiftPopModel"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { PushGiftItem } from "./PushGiftItem"

export class PushGiftView extends BaseItem1 {
Out_lb_title
Scr_Scroller1
_Scroller1
_Viewport1
_gp_item
_gp_no
_lb_title
act_model
data
gift_id
model
parent_mask
reward_loop
timer
title_name


public constructor(parent){
super(parent) 
	
	this.base_file = "pushGift"
	this.layout_file = "PushGiftView"
	this.layer_value = Enum_UILayer.UI

	this.gift_id = null
	this.title_name = ""
	this.data = null
	this.reward_loop = null
	this.timer = null

	this.model = PushGiftModel.GetInstance()
	this.act_model = CustomActivityModel.GetInstance()
	// this.data = this.model.GetGiftData(this.gift_id, null, true)

	this.load_callback = () => {
		ViewGiftPopModel.GetInstance().ClearGifts();
		this.LoadSuccess()
		
		// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	this._lb_title.size  = 14
		// }
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	this._lb_title.size  = 14
		// 	this._lb_title.lineSpacing = 0.6
		// }



	}
}

public LoadSuccess(){ 
	
	if (! this.gift_id ) {
		return
	}

	this.data = this.model.GetGiftData(this.gift_id, null, true)

	// this.RegisterMask(this._Viewport1)
	// this.parent_mask = GetWorldCorners(this._Viewport1)

	this.InitView()
	this.InitEvent()

}

public InitView(){ 
	
	let gift_id = this.gift_id

	//消除红点（登录，首次触发
	this.model.ClearFirstRed(gift_id)

	//设置礼包描述
	// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
	// 	this._lb_title.text = "Selamat! Anda telah menjadi lebih kuat. Berikut adalah hadiah dengan harga diskon yang dipersiapkan khusus untuk Anda! Ayo beli dan tingkatkan lagi CPmu dengan cepat!"
	// }else{
	// let cfg = Config.ConfigPushGift
	// let desc = cfg[gift_id]
	// if (desc ) {
	// 	desc = desc.replace( "a", this.title_name)
	// 	desc = desc.replace("\n", "")
	// 	this._lb_title.text = desc
	// 	}
	// }
	ResManager.GetInstance().LoadGameConfig(ResManager.GetInstance(), "config_push_gift",false,undefined,(cfgs)=>{
		let cfg=cfgs
		let desc = cfg[gift_id]
		if (desc ) {
			desc = desc.replace( "a", this.title_name)
			desc = desc.replace("\n", "")
			this._lb_title.text = desc
		}
	
		this.RefGiftReward()
		this.CheckGiftEmpty()
	});
}

public InitEvent(){ 
	
	let local_PushGiftModel = PushGiftModel
	let gift_id = this.gift_id

	this.BindEvent(this.model, local_PushGiftModel.UPDATE_VIEW,(...new_args) => {
			let args = new_args
			if (args[0] == Number(gift_id)) {
				this.data = this.model.GetGiftData(gift_id)
				if (this.data ) {
					this.model.ClearFirstRed(gift_id)
					this.CheckGiftEmpty()
					this.RefGiftReward()
				}
			}
		})

	this.BindEvent(this.model, local_PushGiftModel.BUY_SUCCESS,(...new_args) => {
			let args = new_args
			if (args[0] == Number(gift_id) ) {
				this.data = this.model.GetGiftData(gift_id)
				if (this.data ) {
					this.RefGiftReward()
				}

				let rewards = args[2]
				if (typeof(args[2]) == "string" ) {
					rewards = ErlangParser.GetInstance().Parse(args[2])
				}
				if (rewards ) {
					 new CongratulationObtainView(rewards, 10).Open()
				}
			}
		})

}

public RefGiftReward(){ 
	
	if (this.data && Util.TableSize(this.data) > 0 ) {
		let gift_id = this.gift_id
		let gift_data = []
		for (let k in this.data) {
			var v = this.data[k]
			table.insert(gift_data, v)
		}
		table.sort(gift_data,(a?, b?) => {
				return a.sub_id < b.sub_id
			})

		let list = []
		for (let index in gift_data) {
			var sub_data = gift_data[index]
			let sub_id = sub_data.sub_id
			let sub_list = sub_data.reward_list
			table.sort(sub_list,(a?, b?) => {
					return a.grade_id < b.grade_id
				}
			)

			for (let key in sub_list) {
				var vo = sub_list[key]
				let limit_count=null
				let cond = vo.rewards_conditions
				////
				if (typeof (cond) == "string") {
					cond =ErlangParser.GetInstance().Parse(cond)
				}
				for (let _tmpi in cond) {
					var sub_cond = cond[_tmpi]
					if (sub_cond[0] == "buy_cnt" ) {
					 limit_count = Number(sub_cond[1])
					}
				}
				if(!limit_count){
					limit_count=1
				}
				/////
				if(this.model.will_del_gift && this.model.will_del_gift[gift_id] && this.model.will_del_gift[gift_id][sub_id]==-1)
					break
				// if(vo.buy_cnt<limit_count){
					vo.gift_id = gift_id
					vo.sub_id = sub_id
					vo.end_time = sub_data.end_time
					vo.parent_mask = this.parent_mask
					table.insert(list, vo)
				// }
			}

		}

		if (this.reward_loop ) {
			this.reward_loop.replaceAll(list)
		}else{
			this.reward_loop =  new LoopScrowViewMgr(this.layer_value)
			console.log(this.hashCode)
			console.log(this._gp_item.hashCode)
			this.reward_loop.SetData(this._gp_item, PushGiftItem, list, LoopScrCon.Vertical, 1)
		}
	}


}

public CheckGiftEmpty(){ 
	
	let list = this.model.GetGiftList(this.gift_id)
	if (! list || Util.IsTableEmpty(list) ) {
		this._gp_no.visible = true 
	}else{
		this._gp_no.visible = false 
	}
}

public CustomMehod(index?, info?){ 
	
	this.gift_id = info.id
	this.title_name = info.name
}

//清除界面
public DeleteMe(){ 
	
	if (this.reward_loop ) {
		this.reward_loop.DeleteMe()
		this.reward_loop = null
	}
	super.DeleteMe()

}

	_gp_time: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	Text: Laya.Label
	public GetComponents() {
		[
			this._lb_title,
			this._Scroller1,
			this._gp_item,
			this._gp_time,
			this._gp_no,
			this._Image1,
			this._Image2,
			this._Image3,
			this.Text,
		]
			= this.GetChildrenByNames([

				"_lb_title",
				"_Scroller1",
				"_gp_item",
				"_gp_time",
				"_gp_no",
				"_Image1",
				"_Image2",
				"_Image3",
				"Text",
			])
			// this._Scroller1.hScrollBarSkin = ""
	}
}

window["PushGiftView"]=PushGiftView
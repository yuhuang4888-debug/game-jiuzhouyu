import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { HotPointModel } from "./HotPointModel"
import { kfHotPointItem } from "./kfHotPointItem"
import { kfHotPointRewardItem } from "./kfHotPointRewardItem"
import { Config } from "../common/Config"
import { AkfHotPointItem } from "./AkfHotPointItem"

export class kfHotPointView extends BaseItem1 {
	_img0: Laya.Image
	_img1: Laya.Image
	_img2: Laya.Image
	_gp_time: Laya.Box
	_img3: Laya.Image
	_lb_point: Laya.HTMLDivElement
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Scroller1: Laya.List
	_Scroller2: Laya.List
	CustomMehod
	InitEvent
	InitItem
	InitRewardItem
	LoadSuccess
	Local_DeleteMe
	Scr_Scroller1
	Scr_Scroller2
	_Viewport2
	parent_mask

	public constructor(parent?) {
		super(parent)


		this.base_file = "kfHotPoint"
		this.layout_file = "kfHotPointView"

		let model = HotPointModel.GetInstance()
		let custom_activity_model = CustomActivityModel.GetInstance()
		let local_CustomActivityDefine = CustomActivityDefine
		// let mask_item_mat =  new Material(ShaderTools.GetShader("UI-Default_mask"))

		let info_ = null
		let data_ = null
		let reward_ = null
		let timer_ = null
		let hot_p_info_ = null
		let act_source = null
		let grade_source = null
		this.preload_client_config = {
			"ConfigCustomActivityView": false
		}
		this.load_callback = () => {

			// this.RegisterMask(this._Viewport2)
			// this.parent_mask = GetWorldCorners(this._Viewport2)
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img3, GameResPath.GetIcon("kfHotPoint", "ukfhd_014"))
			ResManager.GetInstance().SetTexture(this,this._img0,GameResPath.GetIcon("kfHotPoint","uikfhd_012"))
			if (!info_) {
				return
			}
			HotPointModel.GetInstance().Fire(HotPointModel.REQUEST_SCMD, 33302, info_.base_type, info_.sub_type)
			HotPointModel.GetInstance().hide_red_dic[`${info_.base_type}@${info_.sub_type}`]=true
			HotPointModel.GetInstance().RefRed(info_.base_type,info_.sub_type)
			CustomActivityModel.GetInstance().RefreshIconRed(info_.base_type,info_.show_id)
			let cfg = this.preload_client_config["ConfigCustomActivityView"]
			if (cfg) {
				custom_activity_model.LoadCompontRes(this, cfg, "kfHotPointView", info_.show_id)
			}
			data_ = model.GetActData(info_.base_type, info_.sub_type)
			if (!data_) {
				return
			}
			reward_ = model.GetActReward(info_.base_type, info_.sub_type)
			if (!reward_) {
				return
			}
			timer_ = custom_activity_model.LoadActTimer(this._gp_time, info_.etime, 18, "#a0ff67", null, "#ffffff", "活动剩余时间：")

			act_source = new LoopScrowViewMgr()
			act_source.SetData(this._Scroller1, AkfHotPointItem, {}, LoopScrCon.Vertical, 4)

			grade_source = new LoopScrowViewMgr()
			grade_source.SetData(this._Scroller2, kfHotPointRewardItem, {}, LoopScrCon.Vertical, 1, null, null, null)

			this.InitEvent()
			this.InitRewardItem()
			this.InitItem()
		}

		this.InitEvent = () => {
			this.BindEvent(custom_activity_model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
				let args = new_args
				if (args[0] == info_.base_type && args[1] == info_.sub_type) {
					if (args[2] == 33303) {
						reward_ = model.GetActReward(info_.base_type, info_.sub_type)
						this.InitRewardItem()
					}
				}
			}
			)
			this.BindEvent(custom_activity_model, local_CustomActivityDefine.EVENT.UPDATE_VIEW, (...new_args) => {
				let args = new_args
				let info = info_
				if (info && info.base_type == args[0] && info.sub_type == args[1]) {
					if (args[2] == 33302
						|| args[2] == 33305) {
						data_ = model.GetActData(args[0], args[1])
						this.InitItem()
					} else if (args[2] == 33303) {
						reward_ = model.GetActReward(args[0], args[1])
						this.InitRewardItem()
					}
				}
			}
			)
		}

		this.InitItem = () => {
			let data = data_
			if (!data_) {
				return
			}
			this._lb_point.innerHTML = Util.StrToHTML("<font color='#ffffff'>当前嗨点:</font><font color='#ffdb11'>" + data.sum_points + "</font>"
			)
			let list = data.mod_list
			let sortFunc=(a,b)=>{
				return a.order_id<b.order_id
			}
			table.sort(list,sortFunc)
			let list0 = []
			let list1 = []
			for (let _tmpi in list) {
				var v = list[_tmpi]
				if (v.is_com > 0) {
					table.insert(list0, v)
				} else {
					table.insert(list1, v)
				}
			}
			list = list1.concat(list0)// (list1, list0)
			let temp_list1=[]
			let temp_list2=[]
			let count=0
			for( let index = 0; index < list.length; index++){
				if(count==3){
					table.insert(temp_list2,list[index])
					table.insert(temp_list1,temp_list2)
					count=0
					temp_list2=[]
				}else{
					table.insert(temp_list2,list[index])
					count++
					if(!list[index+1]){
						table.insert(temp_list1,temp_list2)
					}
				}
			}
			if(act_source){
				act_source.replaceAll(temp_list1)
			}
		}

		this.InitRewardItem = () => {
			let reward = reward_
			if (!reward) {
				return
			}
			let rew_list = reward.reward_list
			if (!rew_list) {
				return
			}
			let list = []
			let drawed_list = []

			let sort = (a?, b?) => {
				return a.grade < b.grade
			}
			table.sort(rew_list, sort)

			for (let _tmpi in rew_list) {
				var v = rew_list[_tmpi]
				v.base_type = reward.base_type
				v.sub_type = reward.sub_type
				if (v.status < 2) {
					table.insert(list, v)
				} else {
					table.insert(drawed_list, v)
				}
			}
			for (let _tmpi in drawed_list) {
				var v = drawed_list[_tmpi]
				table.insert(list, v)
			}
			if(grade_source){
				grade_source.replaceAll(list)
			}
		}

		this.CustomMehod = (index?, info?) => {
			info_ = info
		}

		this.Local_DeleteMe = () => {
			if (timer_) {
				timer_.DeleteMe()
				timer_ = null
			}

			if (act_source) {
				act_source.DeleteMe()
				act_source = null
			}
			if (grade_source) {
				grade_source.DeleteMe()
				grade_source = null
			}

		}

	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img0,
			this._img1,
			this._img2,
			this._gp_time,
			this._img3,
			this._lb_point,
			this._Image1,
			this._Image2,
			this._Scroller1,
			this._Scroller2,
		]
			= this.GetChildrenByNames([

				"_img0",
				"_img1",
				"_img2",
				"_gp_time",
				"_img3",
				"_lb_point",
				"_Image1",
				"_Image2",
				"_Scroller1",
				"_Scroller2",
			])
		this._lb_point.style.fontSize=22
		this._lb_point.style.color="#ffffff"
		this._lb_point.style.wordWrap=false
		this._lb_point.style.bold=true
		this._Scroller1.scrollBar.visible=false
		this._Scroller2.scrollBar.visible=false
	}
}
window["kfHotPointView"] = kfHotPointView
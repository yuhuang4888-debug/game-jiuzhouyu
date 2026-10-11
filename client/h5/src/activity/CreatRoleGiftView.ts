import { BaseItem1 } from "../common/BaseItem1"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { TaskTipType } from "../commonModel/TaskModel"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { ResManager } from "../common/ResManager"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { AccumRechargeItem } from "./AccumRechargeItem"
import { table } from "../common/table"
import { LoopScrCon } from "../common/LoopScrowViewMgr"
import { GameResPath } from "../util/GameResPath"
import { Enum_UILayer } from "../common/LayerManager"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { ErlangParser } from "../util/ErlangParser"
import { GlobalTimerQuest, HtmlColorTxt, MakeListCenter, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { BossModel } from "../commonModel/BossModel"
import { KaifuActivityModel } from "../commonModel/KaifuActivityModel"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { Message } from "../sysInfo/SysInfoController"

/**创角礼包 / 首日礼包 */
export class CreatRoleGiftView extends BaseItem1 {

	CustomMehod
	InitEvent
	InitView
	LoadSuccess
	Local_DeleteMe
	SetRewardData
	UpdateItems
	_Viewport1
	_ac_item
	_act_info
	_model: CustomActivityModel
	_reward_data
	needRefresh
	parent_mask_corner
	story_obj_list
	time_title_color

	time_id
	ClearTimer
	AddEff
	public constructor(parent?) {
		super(parent)

		this._act_info = null
		this._model = CustomActivityModel.GetInstance()

		this.base_file = "activity"
		this.layout_file = "CreatRoleGiftView"
		this.layer_value = Enum_UILayer.UI
		let local_Event = CustomActivityDefine.EVENT
		this._ac_item = null
		let timer = null
		this._reward_data = null
		let is_click = false

		this.load_callback = () => {
			this._group_item.hScrollBarSkin = ""
			SetHtmlStyle(this._lb_time2,{f:28,c:"#a65626",ww:false,w:536,b:true})
			ResManager.GetInstance().SetOutsideImageSprite(this,this._img_got,GameResPath.GetIconOtherPath("activity","ui_srlb_basal_02"))
			ResManager.GetInstance().SetOutsideImageSprite(this,this._img_tips,GameResPath.GetIconOtherPath("activity","ui_srlb_basal_01"))
			if (this.needRefresh) {
				this.SetRewardData(this._act_info)
			}
			this.LoadSuccess()
		}


		this.Local_DeleteMe = () => {
			if (timer) {
				timer.DeleteMe()
			}
			if (this._ac_item) {
				this._ac_item.DeleteMe()
				this._ac_item = null
			}
			this.ClearUIEffect(this._box_eff)
		}

		this.CustomMehod = (index?, info?) => {
			this._act_info = info
			if (this.is_loaded) {
				this.SetRewardData(info)
			} else {
				this.needRefresh = true
			}
		}

		this.SetRewardData = (info?) => {
			let act_data = this._model.GetActData(info.base_type, info.sub_type)
			if (act_data) {
				for (let _tmpi in act_data.reward_list) {
					var data = act_data.reward_list[_tmpi]
					data.base_type = info.base_type
					data.sub_type = info.sub_type
				}
			}
			this._reward_data = act_data
		}

		this.InitEvent = () => {
			let RefView = (base_type?, sub_type?) => {
				if (!this._act_info) {
					return
				}
				if (!this._reward_data) {
					return
				}
				if (this._act_info.base_type == base_type && this._act_info.sub_type == sub_type) {
					this.SetRewardData(this._act_info)
					this.UpdateItems()
				}
			}
			this.BindEvent(this._model, local_Event.UPDATE_ACT_RECHANGE, RefView)

			this.BindEvent(this._model, local_Event.UPDATE_ACT_RECHANGE_DAY, () => {
				this.UpdateItems()
			})

			this.BindEvent(this._model, local_Event.ANSWER_TARGET, (base_type?, sub_type?, result_data?, reward_data?) => {
				if (!this._act_info) {
					return
				}
				if (this._act_info.base_type == base_type && this._act_info.sub_type == sub_type) {
					if (is_click) is_click = false
					this.SetRewardData(this._act_info)
					this.UpdateItems()
					let rewards = this._model.GetActReward(reward_data.base_type, reward_data.sub_type, reward_data.form_type, reward_data.reward)
					new CongratulationObtainView(rewards, 10).Open()
				}
			}
			)

			Util.AddClickEvent(this._gp_up, () => {
			

				if(is_click){
					return
				}
				//领取
				if (!this._reward_data) {
					return
				}
				let act_data = this._reward_data.reward_list[0]
				if (!act_data) return
				//是否可以领取
				if (act_data.status == 2) {
					Message.show("已领取")
					return
				}
				//可领取时间
				let end_time = Number(ErlangParser.GetInstance().parse(act_data.condition)[0][1])
				let is_can_rece = act_data.status != 2 && TimeUtil.getServerTime() >= end_time
				if (!is_can_rece) {
					Message.show("请到点再来领取哟~")
				}else{
					is_click = true
					this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, act_data.base_type, act_data.sub_type, act_data.grade)
				}
			}, this, true)
		}

		this.LoadSuccess = () => {

			this.InitView()
			this.InitEvent()
		}

		this.InitView = (item?) => {
			if (this._act_info) {
				this._model.Fire(local_Event.SCMD_REQUEST, 33104, this._act_info.base_type, this._act_info.sub_type)
			}

			if (!this._act_info) {
				return
			}
			CustomActivityModel.GetInstance().CloseACTRed( this._act_info.base_type, this._act_info.sub_type);
			this.UpdateItems()
		}

		this.UpdateItems = () => {
			if (!this._reward_data) {
				return
			}

			let act_data = this._reward_data.reward_list[0]
			if (!act_data) return

			//可领取时间
			let end_time = Number(ErlangParser.GetInstance().parse(act_data.condition)[0][1])
			//是否已经领取
			let is_got = act_data.status == 2 //==2表示已经领取
			this._img_red.visible = false
			if (!is_got) {
				this._gp_up.visible=true
				this._img_got.visible=false

				if (TimeUtil.getServerTime() >= end_time) {
					this.ClearTimer()
					this._lb_btn.text = "领取"
					this._img_red.visible = true
					this._lb_time2.innerHTML="快点击下方按钮，领取丰厚大礼包！"
					SetHtmlCenter(this._lb_time2,{x:92,w:536})
					this.AddEff()
				} else {
					let time_func = () => {
						if (this.use_delete_method) {
							this.ClearTimer()
							return
						}
						let left_time = end_time - TimeUtil.getServerTime()
						if (left_time >= 0) {
							this._lb_btn.text = "待领取"
							this._lb_time2.innerHTML=`领取倒计时:${HtmlColorTxt(TimeUtil.timeConvert(left_time, "dd-hh-mm-ss"),'"#0a953e"')}`
						} else {
							this.ClearTimer()
							this._lb_btn.text = "领取"
							this._lb_time2.innerHTML="快点击下方按钮，领取丰厚大礼包！"
							this._img_red.visible = true
							this._model.Fire(local_Event.SCMD_REQUEST, 33104, this._act_info.base_type, this._act_info.sub_type)
							this.AddEff()
						}
						SetHtmlCenter(this._lb_time2,{x:92,w:536})
					}

					//倒计时
					if (!this.time_id) {
						this.time_id = GlobalTimerQuest.AddPeriodQuest(() => {
							time_func()
						}, 1, -1)
						time_func()
						this.ClearUIEffect(this._box_eff)
					}
				}
			} else {
				this.ClearTimer()
				this._lb_btn.text = "已领取"
				this._gp_up.visible=false
				this._img_got.visible=true
				this.ClearUIEffect(this._box_eff)
			}




			//1时间前 待领取 2时间后 可领取  3领取
			//this._lb_btn.text = act_data.status!=2?"可领取"：

			let re_list = ErlangParser.GetInstance().parse(act_data.reward)
			let data = []
			for (let i = 0; i < re_list.length; i++) {
				let vo = re_list[i]
				table.insert(data, {
					size: 89,
					vo: {
						style: vo[0],
						typeId: vo[1],
						count: vo[2]
					}
				})
			}

			if (!this._ac_item) {
				this._ac_item = new LoopScrowViewMgr()
				this._ac_item.SetData(this._group_item, CommonRewardItem, data, LoopScrCon.Horizontal, 1)
			} else {
				this._ac_item.replaceAll(data)
			}

			MakeListCenter(this._group_item, 6, 104, 89)
		}

		this.AddEff=()=>{
			this._box_eff.scale(0.98,1.2)
			this.AddUIEffect("ui_anniu_6",this._box_eff,{x:-0.2,y:0.55},14,true)
		}


		this.ClearTimer = () => {
			if (this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id)
				this.time_id = null
			}
		}

	}

	public DeleteMe() {
		this.ClearTimer
		this.Local_DeleteMe()
		super.DeleteMe()
	}


_img_tips:Laya.Image
_group_item:Laya.List
_lb_time2:Laya.HTMLDivElement
_gp_up:Laya.Box
_lb_btn:Laya.Label
_img_red:Laya.Image
_box_eff:Laya.Box
_img_got:Laya.Image
public GetComponents() {
[
this._img_tips,
this._group_item,
this._lb_time2,
this._gp_up,
this._lb_btn,
this._img_red,
this._box_eff,
this._img_got,
]
 = this.GetChildrenByNames([

"_img_tips",
"_group_item",
"_lb_time2",
"_gp_up",
"_lb_btn",
"_img_red",
"_box_eff",
"_img_got",
])
}
}
 window["CreatRoleGiftView"]= CreatRoleGiftView
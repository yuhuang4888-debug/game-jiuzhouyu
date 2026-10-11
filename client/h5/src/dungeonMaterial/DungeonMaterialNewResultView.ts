import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { DungeonEnterView } from "../dungeon/DungeonEnterView"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, MakeListCenter, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"

export class DungeonMaterialNewResultView extends BaseView1 {

	need_refresh_data
	loop_mgr: LoopScrowViewMgr
	model: BaseDungeonModel
	data
	left_time
	timer_exit_id
	SetTime
	public constructor() {
		super()

		this.base_file = "dungeonMaterial"
		this.layout_file = "DungeonMaterialNewResultView"
		this.preload_server_config = {
			"config_dungeon_score": false
		}

		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		let voice
		this.model = BaseDungeonModel.GetInstance()

		this.load_callback = () => {
			SetHtmlStyle(this._html_time,{c:"#ffffff",f:20,ww:false})
			SetHtmlStyle(this._html_score,{c:"#663519",f:20,ww:false,w:720})

			this.InitEvent()

			if(this.data&&this.data["is_sd"]==1){
				//扫荡
				ResManager.GetInstance().SetImageSprite(this, this._img_bg2,"dungeonCommon", "ui_copy_115")
			}else{
				//挑战
				ResManager.GetInstance().SetImageSprite(this, this._img_bg2,"dungeonCommon", "ui_copy_64")
			}
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonCommon", "com_up_bg1"))

			this.left_time = 10

			this.timer_exit_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.UpdateExitTimer()
			}, 1)

			this.UpdateExitTimer()

			voice = CommonManager.GetInstance().PlayFightingVoice(2)

		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}
			this.Clear()
		}


		this.SetTime = () => {
			if(!this.data)return
			if(!this.data.ex_data){
				//扫荡不显示通关时间
				this._html_score.visible=false
				return
			}
			this._html_score.visible=true
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_score", false)
			let score_cfg = cfgs[this.data.dun_id]
			let grade = this.data.grade//星级

			let next_time=0

			if (score_cfg) {
				let time_score_list = JSON.parse(score_cfg.time_score_list)
				let cur_score
				let cur_stage_start_time
				let cur_stage_end_time
				if (time_score_list) {
					for (let _ in time_score_list) {
						let vo = time_score_list[_]
						cur_stage_start_time = Number(vo[0])
						cur_stage_end_time = Number(vo[1])
						cur_score = Number(vo[2])
						if(cur_score>grade){
							next_time = cur_stage_end_time
							break
						}
					}
				}
			}

			let pass_time = this.model.GetValByKey(10,this.data.ex_data)
			let cur_time=HtmlColorTxt(TimeUtil.convertTimeCN(pass_time),Enum_ColorUtil_Dark.GREEN)
			let n_time=HtmlColorTxt(TimeUtil.convertTimeCN(next_time),Enum_ColorUtil_Dark.RED)
			let space = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
			if(next_time>0){
				this._html_score.innerHTML=`本次通关：${cur_time}${space}下一评分：${n_time}`
			}else{
				this._html_score.innerHTML=`本次通关：${cur_time}${space}`
			}
			SetHtmlCenter(this._html_score,{x:0,w:720})
		}
	}

	public InitEvent() {

		let onClickBtnHandler = (e: Laya.Event) => {
			if (e.target == this._img_exit) {
				this.Close()
			}
		}
		Util.AddClickEvent(this._img_exit, onClickBtnHandler, this, true)
	}

	public UpdateExitTimer() {

		let str
		if(this.data&&this.data["is_sd"]==1){
			//扫荡
			str = `${HtmlColorTxt(this.left_time, "'#00ed2d'")}S后关闭界面`
		}else{
			//挑战
			str = `${HtmlColorTxt(this.left_time, "'#00ed2d'")}S后自动退出副本`
		}


		this._html_time.innerHTML = str
		this._html_time.callLater(() => {
			if(this.use_delete_method) return
			this._html_time.x = (this.display_obj.width - this._html_time.width) / 2
		})
		this.left_time = this.left_time - 1
		if (this.left_time < 0) {
			this.Close()
		}
	}

	public Open(...parms) {
		this.data = parms[0]
		super.Open()
	}

	public UpdateView() {

		if (!this.is_loaded) {
			this.need_refresh_data = true
			return
		}

		let data = this.data
		let len = data.reward_list.length

		this._list_reward.visible = len > 0

		if (len > 0) {
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._list_reward, CommonRewardItem, data.reward_list, LoopScrCon.Horizontal)
			} else {
				this.loop_mgr.replaceAll(data.reward_list)
			}

			MakeListCenter(this._list_reward,4,198,85)
		}

		for (let i = 1; i <= data.grade; i++) {
			ResManager.GetInstance().SetImageSprite(this, this[`_img_star${i}`], "dungeonCommon", "star2")
		}


		this.SetTime()
	}

	public Clear() {

		if(this.data&&this.data["is_sd"]==0){
		BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61002)
		}
		if (this.timer_exit_id) {
			GlobalTimerQuest.CancelQuest(this.timer_exit_id)
			this.timer_exit_id = null
		}

		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}

		//非新手引导  结算面板关闭会打开界面
		if (!this.task_model.MainTaskIsNewMaterialDunTaskType(this.data.dun_type)) {
			if(this.data&&this.data["is_sd"]==0){
				setTimeout(() => {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterView.Index.Material)
				}, 1000)
			}
		}


		BaseDungeonModel.GetInstance().SetDungeonResultInfo(null)
	}




_img_bg:Laya.Image
_img_bg2:Laya.Image
_img_bg3:Laya.Image
_img_bg4:Laya.Image
_img_star1:Laya.Image
_img_star2:Laya.Image
_img_star3:Laya.Image
_img_exit:Laya.Image
_lb_ext:Laya.Label
_html_time:Laya.HTMLDivElement
_list_reward:Laya.List
_html_score:Laya.HTMLDivElement
public GetComponents() {
[
this._img_bg,
this._img_bg2,
this._img_bg3,
this._img_bg4,
this._img_star1,
this._img_star2,
this._img_star3,
this._img_exit,
this._lb_ext,
this._html_time,
this._list_reward,
this._html_score,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_bg2",
"_img_bg3",
"_img_bg4",
"_img_star1",
"_img_star2",
"_img_star3",
"_img_exit",
"_lb_ext",
"_html_time",
"_list_reward",
"_html_score",
])
}
}
 window["DungeonMaterialNewResultView"]= DungeonMaterialNewResultView
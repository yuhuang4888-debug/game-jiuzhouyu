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
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest, HtmlColorTxt, Util } from "../util/Util"

export class DungeonPartnerResultView extends BaseView1 {

	need_refresh_data
	loop_mgr: LoopScrowViewMgr
	model: DungeonPartnerModel
	data
	left_time
	timer_exit_id

	public constructor() {
		super()

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerResultView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		let voice
		this.model = DungeonPartnerModel.GetInstance()

		this.load_callback = () => {

			this._html_time.style.color = "#ffffff"
			this._html_time.style.fontSize = 20
			this._html_time.style.wordWrap = false
			this.InitEvent()

			//resource/game/dungeonCommon/texture/com_up_bg1.png
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonCommon", "com_up_bg1"))

			this.left_time = 3
			this.timer_exit_id = GlobalTimerQuest.AddPeriodQuest(() => {
				this.UpdateExitTimer()
			}, 1)

			this.UpdateExitTimer()

			voice=CommonManager.GetInstance().PlayFightingVoice(2)
			
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
		this._html_time.innerHTML = `${HtmlColorTxt(this.left_time, "'#00ed2d'")}S后自动退出副本`
		this.CallLater(() => {
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
		this._lb_reward_tip.visible = len == 0

		if (len > 0) {
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._list_reward, CommonRewardItem, data.reward_list, LoopScrCon.Horizontal, null, null, null, 95, 85)
			} else {
				this.loop_mgr.replaceAll(data.reward_list)
			}
		}

		for (let i = 1; i <= data.grade; i++) {
			ResManager.GetInstance().SetImageSprite(this, this[`_img_star${i}`], "dungeonCommon", "star2")
		}
	}

	public Clear() {

		BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61002)
		if (this.timer_exit_id) {
			GlobalTimerQuest.CancelQuest(this.timer_exit_id)
			this.timer_exit_id = null
		}

		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}

		setTimeout(() => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterView.Index.DungeonPartner)
		}, 1000)

		BaseDungeonModel.GetInstance().SetDungeonResultInfo(null)
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_star1: Laya.Image
	_img_star2: Laya.Image
	_img_star3: Laya.Image
	_lb_reward_tip: Laya.Label
	_img_exit: Laya.Image
	_lb_ext: Laya.Label
	_html_time: Laya.HTMLDivElement
	_list_reward: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._img_star1,
			this._img_star2,
			this._img_star3,
			this._lb_reward_tip,
			this._img_exit,
			this._lb_ext,
			this._html_time,
			this._list_reward,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_img_star1",
				"_img_star2",
				"_img_star3",
				"_lb_reward_tip",
				"_img_exit",
				"_lb_ext",
				"_html_time",
				"_list_reward",
			])
	}
}
window["DungeonPartnerResultView"] = DungeonPartnerResultView
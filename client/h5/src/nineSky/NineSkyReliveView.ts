import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { DailyModel } from "../commonModel/DailyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { DailyEvent } from "../daily/DailyEvent"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, Util } from "../util/Util"
import { CommonManager } from "../common/CommonManager"
import { SoundManager } from "../common/SoundManager"

export class NineSkyReliveView extends BaseView1 {

	end_time
	left_time
	left_time_id
	relive_cost

	role_mgr: RoleManager
	scene_mgr: SceneManager
	goods_model: GoodsModel
	nine_sky_model: NineSkyModel
	public constructor() {
		super()
		this.base_file = "nineSky"
		this.layout_file = "NineSkyReliveView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.change_scene_close = true
		this.use_background = true
		this.background_alpha = 0
		this.not_close_by_android_back_key = true
		this.is_center = true

		this.nine_sky_model = NineSkyModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()

		this.left_time_id = null
		this.left_time = 10
		this.relive_cost = null
		this.end_time = null
		let voice

		this.preload_server_config = {
			"config_nine_key_value": false,
			"config_nine": false,
		}

		this.load_callback = () => {
			voice=CommonManager.GetInstance().PlayFightingVoice(1)
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.close_callback = () => {
			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}
			this.Remove()
		}
	}

	public LoadSuccess() {

		
		this._html_kill_msg.style.color = "#663915"
		this._html_kill_msg.style.fontSize = 20
		this._html_kill_msg.style.wordWrap = false
		this._html_kill_msg.style.bold = true

		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("nineSky", "uijhsd_022"), true)

		let relive_func = () => {
			GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 17)
		}

		Util.AddClickEvent(this._box_now_relive, () => {
			if (this.relive_cost) {
				let style = this.relive_cost[0]
				let cost_count = this.relive_cost[2]
				let jin_lock = this.role_mgr.GetMainRoleVo().jinLock
				let jin = this.role_mgr.GetMainRoleVo().jin
				if (jin_lock < Number(cost_count) && jin + jin_lock >= Number(cost_count)) {
					let str = "<font color='#ff4f50'>当前绑玉数量不足，是否消耗勾玉代替？</font>"
					let content = str
					Alert.Show(content, Alert_Type.Two, relive_func, null, "确定", "取消")
					Alert.SetIsCharge(true)
				} else {
					relive_func()
				}
			}
		}, this, true)

		Util.AddClickEvent(this._box_safe_relive, () => {
			GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 16)
		}, this, true)

		Util.AddClickEvent(this._img_streng, () => {
			DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, "DailyView", 3, 0)
		}, this, true)
	}

	public UpdateView() {
		let nine_key_value_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_nine_key_value", false)
		let relive_cost = nine_key_value_cfg[9].value
		let vo = JSON.parse(relive_cost)
		vo = vo && vo[0]
		if (vo) {
			this._lb_relive_cost.text = "x" + vo[2]
			this.relive_cost = vo
			let [type_id, lock] = this.goods_model.GetMappingTypeId(vo[0], vo[1])
			let goods_vo = this.goods_model.GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(goods_vo.goods_icon))
			}
		}
		this._html_kill_msg.innerHTML = `您已经被${HtmlColorTxt(this.scene_mgr.killerName, "'#e25a00'")}杀死`
		this.CallLater(()=>{
			this._html_kill_msg.x = (this.display_obj.width - this._html_kill_msg.width) / 2
		})

		if (this.scene_mgr.killerType == SceneBaseType.Role) {
			this._lb_fighting_difference.visible = this._lb_desc.visible = true
			let role_vo = this.scene_mgr.GetRoleVo(this.scene_mgr.killerId)
			let role_fight = 0
			if (role_vo) {
				role_fight = role_vo.fighting
			}

			let fight_off = this.role_mgr.GetMainRoleVo().fighting - role_fight
			this._lb_fighting_difference.text = String(Math.abs(fight_off))

			
			this._lb_fighting_difference.color = fight_off >= 0 && "#009916" || "#fe1a1a"
			//this._Group2.visible = true 
			if (fight_off >= 0) {
				this._img_down.visible = false
				this._img_up.visible = true
			} else {
				this._img_up.visible = false
				this._img_down.visible = true
			}
		}
		else{
			this._lb_fighting_difference.visible = this._lb_desc.visible = this._img_up.visible = this._img_down.visible = false
		}

		if (this.scene_mgr.killerType == SceneBaseType.Monster) {
			this._lb_fighting_difference.text = "0"
			this._lb_fighting_difference.color = ColorUtil.TryParseHtmlString("#599F2C")
			//this._Group2.visible = false 
			this._img_down.visible = false
			this._img_up.visible = false
		}
		let id = this.scene_mgr.GetSceneId()
		let floor = id - 27010
		if (floor < 0) {
			floor = id - 27000
		}
		this.StartTime()
	}

	public StartTime() {
		this.CancelTime()
		this.end_time = this.left_time + TimeUtil.getServerTime()
		let loop_func = () => {
			let left_time = this.end_time - TimeUtil.getServerTime()
			if (left_time < 0) {
				this.CancelTime()
				GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 16)
				return
			}
			this._lb_safe_relive.text = "安全复活(" + left_time + ")"
		}
		this.left_time_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
		loop_func()
	}

	public CancelTime() {
		if (this.left_time_id) {
			GlobalTimerQuest.CancelQuest(this.left_time_id)
			this.left_time_id = null
		}
	}

	public Remove() {
		this.CancelTime()
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_streng: Laya.Image
	_box_safe_relive: Laya.Box
	_img_safe_relive: Laya.Image
	_lb_safe_relive: Laya.Label
	_box_now_relive: Laya.Box
	_img_now_relive: Laya.Image
	_lb_now_relive: Laya.Label
	_html_kill_msg: Laya.HTMLDivElement
	_lb_desc: Laya.Label
	_img_up: Laya.Image
	_img_down: Laya.Image
	_lb_fighting_difference: Laya.Label
	_img_icon: Laya.Image
	_lb_relive_cost: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._img_streng,
			this._box_safe_relive,
			this._img_safe_relive,
			this._lb_safe_relive,
			this._box_now_relive,
			this._img_now_relive,
			this._lb_now_relive,
			this._html_kill_msg,
			this._lb_desc,
			this._img_up,
			this._img_down,
			this._lb_fighting_difference,
			this._img_icon,
			this._lb_relive_cost,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_img_streng",
				"_box_safe_relive",
				"_img_safe_relive",
				"_lb_safe_relive",
				"_box_now_relive",
				"_img_now_relive",
				"_lb_now_relive",
				"_html_kill_msg",
				"_lb_desc",
				"_img_up",
				"_img_down",
				"_lb_fighting_difference",
				"_img_icon",
				"_lb_relive_cost",
			])
	}
}
window["NineSkyReliveView"] = NineSkyReliveView

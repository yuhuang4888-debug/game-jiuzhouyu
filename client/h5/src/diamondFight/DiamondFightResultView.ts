import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GetSexByCareer, GlobalTimerQuest, HtmlColorTxt } from "../util/Util"

export class DiamondFightResultView extends BaseView1 {

	data
	time_id

	model: DiamondFightModel
	res_mgr: ResManager
	voice
	public constructor() {
		super()

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightResultView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true

		this.model = DiamondFightModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.data = null
		this.time_id = null

		this.preload_server_config = {
			"config_career": false,
			"config_drumwar_lv_to_zone": false,
			"config_drumwar_zone_reward": false
		}

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public Remove() {

		if (this.voice) {
			SoundManager.GetInstance().StopSoundEffect(this.voice)
			this.voice = null
		}

		this.CancelCountDown()
		if (SceneManager.GetInstance().IsDiamondFightScene()) {
			this.model.Fire(DiamondFightModel.REQUEST_SCMD, 13707, 1)
		}

		for (let i = 0; i < 2; i++) {
			if (this["_head" + i]) {
				this["_head" + i].DeleteMe()
				this["_head" + i] = false
			}
		}

		this.model.fight_enemy_info = false

	}

	public LoadSuccess() {

		//resource/game/topPk/texture/ui_sjjj_003.png
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("topPk", "ui_sjjj_003"))

		this._html_count_down.style.fontSize = 18
		this._html_count_down.style.wordWrap = false
		this._html_count_down.style.color = "#ffffff"

		this.InitEvent()
	}

	public InitEvent() {


	}

	public InitView() {

		if (!this.data) {
			this.Close()
			return
		}
		if (this.data.result == 3 || this.data.result == 6) {
			if (!this.model.fight_enemy_info || !this.model.lives_info) {
				return
			}
			// console.log("//////DiamondFightResultView1//////", this.data.result)
			this._img_bg2.y = 500
			this._box_con.y = 505

			this._box_con2.visible = true
			let list = [RoleManager.GetInstance().GetMainRoleVo(), this.model.fight_enemy_info]

			let i = 0
			do {
				this.res_mgr.SetImageSprite(this, this["_img_heart" + i], "diamondFight", i < this.model.lives_info.self_life && "uizsdz_010a" || "uizsdz_010b")
				this.res_mgr.SetImageSprite(this, this["_img_heart" + (i + 3)], "diamondFight", i < this.model.lives_info.other_life && "uizsdz_010a" || "uizsdz_010b")
				i = i + 1
			} while ((i < 3))


			// console.log("self_life: ", this.model.lives_info.self_life)
			// console.log("other_life: ", this.model.lives_info.other_life)

			for (let key in list) {

				let vo = list[key]
				let i = Number(key)
				if (vo) {

					let pt = Math.min(1, Number((Math.floor(vo.hp / vo.maxHp * 10000) / 10000).toFixed(2)))
					this["_img_hp" + i].width = 134 * Number(pt)
					console.log("hp: ", key, vo.hp, vo.maxHp, pt)
					this["_lb_hp" + i].text = pt * 100 + "%"
					this["_lb_name" + i].text = vo.name
					if (vo.is_fake_role && this.model.fake_role_info) {
						this["_lb_server" + i].text = "S" + this.model.fake_role_info.server_num + "·" + this.model.fake_role_info.server_name
					}
					else {
						this["_lb_server" + i].text = "S" + vo.server_id + "·" + vo.server_name
					}
					if (this["_box_head" + i]) {
						if (!this["_head" + i]) {
							this["_head" + i] = new CustomHeadItem(this["_box_head" + i])
							this["_head" + i].Load()
							this["_head" + i].SetActiveLevel(false)
							this["_head" + i].SetActiveFrame(false)
						}
						this["_head" + i].SetRoleVoData(vo)
					}
				}
			}
			// console.log("//////DiamondFightResultView1//////")

		}
		else {
			
			this._box_con.y = 578
			this._img_bg2.y = this._box_con.y- 5
		}
		let bool = null
		let effect_name = null

		let state=1
		switch (this.data.result) {
			case 1:
			case 3:
			case 4:
			case 5:

				//resource/game/topPk/texture/com_up_bg1.png
				//resource/game/topPk/texture/ui_copy_64.png
				this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconOtherPath("dungeonCommon", "com_up_bg1"), true)
				this.res_mgr.SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("dungeonCommon", "ui_copy_64"), true)
				bool = true
				effect_name = "UI_2104"
				state=2
				break
			case 2:
			case 6:
				this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconOtherPath("dungeonCommon", "com_up_bg2"), true)
				this.res_mgr.SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("dungeonCommon", "ui_copy_67"), true)
				bool = false
				effect_name = "UI_2105"
				state=1
				break

		}

		this.voice=CommonManager.GetInstance().PlayFightingVoice(state)

		let config_drumwar_lv_to_zone = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_lv_to_zone", false)
		let config_drumwar_zone_reward = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_zone_reward", false)
		// this.AddUIEffect(effect_name, this._gp_fly)
		let reward = this.model.GetSessionReward(this.model.zone, this.data.action_id, bool, config_drumwar_zone_reward, config_drumwar_lv_to_zone)

		this._lb_value.text = "x" + reward

		let end_time = TimeUtil.getServerTime() + 7
		this.StartCountDown(() => {
			let left_time = end_time - TimeUtil.getServerTime()
			if (left_time < 0) {
				this.CancelCountDown()
				this.Close()
				return
			}
			this._html_count_down.innerHTML = `点击任意位置继续${HtmlColorTxt(`[${left_time}s]`, "'#00ed2d'")}`
		}
		)

	}

	public CancelCountDown() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	public StartCountDown(func?) {
		this.CancelCountDown()
		this.time_id = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
		func()
	}

	public Open(...new_args) {
		let parms = new_args
		if (parms) {
			this.data = parms[0]
		}
		super.Open()
	}


	_img_bg: Laya.Image
	_img_title: Laya.Image
	_box_con: Laya.HBox
	_lb_desc: Laya.Label
	_img_icon: Laya.Image
	_lb_value: Laya.Label
	_img_bg2: Laya.Image
	_box_con2: Laya.Box
	_box_head0: Laya.Box
	_box_head1: Laya.Box
	_img_vs: Laya.Image
	_box_left: Laya.HBox
	_lb_name0: Laya.Label
	_img_heart0: Laya.Image
	_img_heart1: Laya.Image
	_img_heart2: Laya.Image
	_box_right: Laya.HBox
	_img_heart3: Laya.Image
	_img_heart4: Laya.Image
	_img_heart5: Laya.Image
	_lb_name1: Laya.Label
	_lb_server0: Laya.Label
	_lb_server1: Laya.Label
	_box_right_hp: Laya.Box
	_img_right_hp_bg: Laya.Image
	_img_hp1: Laya.Image
	_lb_hp1: Laya.Label
	_box_left_hp: Laya.Box
	_img_left_hp_bg: Laya.Image
	_img_hp0: Laya.Image
	_lb_hp0: Laya.Label
	_lb_tips: Laya.Label
	_html_count_down: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._box_con,
			this._lb_desc,
			this._img_icon,
			this._lb_value,
			this._img_bg2,
			this._box_con2,
			this._box_head0,
			this._box_head1,
			this._img_vs,
			this._box_left,
			this._lb_name0,
			this._img_heart0,
			this._img_heart1,
			this._img_heart2,
			this._box_right,
			this._img_heart3,
			this._img_heart4,
			this._img_heart5,
			this._lb_name1,
			this._lb_server0,
			this._lb_server1,
			this._box_right_hp,
			this._img_right_hp_bg,
			this._img_hp1,
			this._lb_hp1,
			this._box_left_hp,
			this._img_left_hp_bg,
			this._img_hp0,
			this._lb_hp0,
			this._lb_tips,
			this._html_count_down,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_box_con",
				"_lb_desc",
				"_img_icon",
				"_lb_value",
				"_img_bg2",
				"_box_con2",
				"_box_head0",
				"_box_head1",
				"_img_vs",
				"_box_left",
				"_lb_name0",
				"_img_heart0",
				"_img_heart1",
				"_img_heart2",
				"_box_right",
				"_img_heart3",
				"_img_heart4",
				"_img_heart5",
				"_lb_name1",
				"_lb_server0",
				"_lb_server1",
				"_box_right_hp",
				"_img_right_hp_bg",
				"_img_hp1",
				"_lb_hp1",
				"_box_left_hp",
				"_img_left_hp_bg",
				"_img_hp0",
				"_lb_hp0",
				"_lb_tips",
				"_html_count_down",
			])
	}
}
window["DiamondFightResultView"] = DiamondFightResultView
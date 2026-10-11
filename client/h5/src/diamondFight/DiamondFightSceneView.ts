import { BaseView1 } from "../common/BaseView1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPositionX, SetSizeDeltaX, Util } from "../util/Util"
import { DiamondFightSkillItem } from "./DiamondFightSkillItem"

export class DiamondFightSceneView extends BaseView1 {

	model: DiamondFightModel
	role_mgr: RoleManager
	scene_mgr: SceneManager
	res_mgr: ResManager

	skill_item_list
	time_id
	tween_id


	public constructor() {
		super()

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightSceneView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.back_login_toClose = true

		this.model = DiamondFightModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.skill_item_list = null
		this.time_id = null

		this.preload_server_config = {
			"config_drumwar_value": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.Remove()
		}

	}

	public Remove() {

		if (this.skill_item_list) {
			for (let _tmpi in this.skill_item_list) {
				var obj = this.skill_item_list[_tmpi]
				obj.DeleteMe()
			}
			this.skill_item_list = null
		}
		if (this.tween_id) {
			SYTweenLite.Stop(this.tween_id)
			this.tween_id = false
		}
		this.CancelCountTime()
		this.ClearGodBtn()

		for (let i = 0; i <= 1; i++) {
			if (this["head" + i]) {
				this["head" + i].DeleteMe()
				this["head" + i] = null
			}
		}

	}

	public LoadSuccess() {

		this.display_obj.left = this.display_obj.bottom = this.display_obj.right = 0
		this.display_obj.top = Util.GetLiuhaiHeight()

		this._lb_0_fighting.fontSize = this._lb_1_fighting.fontSize = 22

		ResManager.GetInstance().LoadFont(this, "fighting_font", this._lb_1_fighting, 22)
		ResManager.GetInstance().LoadFont(this, "fighting_font", this._lb_0_fighting, 22)

		// this.res_mgr.SetOutsideImageSprite(this, this._img_sub_bg, GameResPath.GetIcon("diamondFight", "uizsdz_012"))

		// this.AddUIEffect("UI_1126", this.layer_value, this._gp_vs_effect_con, null, null, true)

		let role_vo = this.scene_mgr.GetOneRoleVo()
		if (role_vo) {
			this.UpdateRolesVo(role_vo)
		}

		this.InitView()
		this.InitEvent()
		this.CreateGodBtn()
		this.model.Fire(DiamondFightModel.REQUEST_SCMD, 13710)
	}

	public UpdateRolesVo(vo?) {

		this.model.fight_enemy_info = vo
		this.UpdateFakeInfo()
		this.UpdateRoleInfo()
	}

	public UpdateRoleInfo() {

		let enemy_vo = this.model.fight_enemy_info
		let role_vo = this.role_mgr.GetMainRoleVo()
		let list = [role_vo]

		let is_right = role_vo.pos_x > 1200

		if (enemy_vo) {
			table.insert(list, enemy_vo)
			if (!enemy_vo.is_fake_role) {
				if(is_right){
					this["_lb_0_fighting"].text = enemy_vo.fighting
				}else{
					this["_lb_1_fighting"].text = enemy_vo.fighting
				}
				
			}
		}

		if(is_right){
			this["_lb_1_fighting"].text = role_vo.fighting
		}else{
			this["_lb_0_fighting"].text = role_vo.fighting
		}
		


		//判断主角出生在左边还是右边
		if (is_right) {
			list = list.reverse()
		}

		for (let key in list) {

			let vo = list[key]
			let i = Number(key)

			this["_lb_" + i + "_hp"].text = vo.hp + "/" + vo.maxHp
			this["_lb_" + i + "_name"].text = "S" + vo.server_id + "." + vo.name

			this.res_mgr.SetImageSprite(this, this["_img_" + i + "_vip"], "mainUI", "uivip_zjm_" + vo.vip_flag)

			if (this["_img_" + i + "_head"]) {
				if (this["head" + i] == null) {
					this["head" + i] = new CustomHeadItem(this["_img_" + i + "_head"])
					this["head" + i].SetActiveLevel(false)
					this["head" + i].Load()
					this["head" + i].SetActiveFrame(false)
				}
				this["head" + i].SetRoleVoData(vo)
			}
			//this["text_img_" + key + "_head"].setData(vo.level, vo.career, vo["picture"])


			this.BindVar(vo, "hp", (event_name?, value?) => {
				this["_lb_" + i + "_hp"].text = value + "/" + vo.maxHp
				let width = 0
				if (vo.maxHp != 0) {
					width = Math.min(value / vo.maxHp, 1)
				}
				SetSizeDeltaX(this["_img_" + i + "_hp"], 171 * width)
			})

		}
	}

	public UpdateFakeInfo() {

		let fake_role_info = this.model.fake_role_info
		let fight_enemy_info = this.model.fight_enemy_info
		if (fight_enemy_info && fight_enemy_info.is_fake_role == true && fake_role_info) {

			let role_vo = this.role_mgr.GetMainRoleVo()
			let is_right = role_vo.pos_x > 1200

			if(is_right){
				this["_lb_0_fighting"].text = fake_role_info.power
			}else{
				this["_lb_1_fighting"].text = fake_role_info.power
			}
			
		}
	}

	public InitEvent() {

		this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_ADD, (role_id?, role_vo?) => {
			if (role_vo.role_id != RoleManager.GetInstance().GetMainRoleId()) {
				this.UpdateRolesVo(role_vo)
			}
		}
		)
		this.BindVar(this.model, "fight_start_time", (event_name?, value?) => {
			this.PlayTween()
		}
		)
		this.BindVar(this.model, "fight_end_time", (event_name?, value?) => {
			this.UpdateCountDown()
		}
		)
		this.BindVar(this.model, "lives_info", (event_name?, value?) => {
			this.UpdateRoleHearts()
		}
		)
		this.BindVar(this.model, "fake_role_info", () => {
			this.UpdateFakeInfo()
		}
		)
	}

	public UpdateCountDown() {

		let end_time = this.model.fight_end_time
		if (end_time) {
			this.StartCountTime(0, () => {
				let left_time = end_time - TimeUtil.getServerTime()
				if (left_time < 0) {
					this.CancelCountTime(0)
					return
				}
				if (!this._box_count_time.visible) {
					let start_time = this.model.fight_start_time
					if (start_time && TimeUtil.getServerTime() >= start_time) {
						this._box_count_time.visible = true
					}
				}
				this._lb_count_time.text = TimeUtil.timeConvert8(left_time)
			}
			)
		}
	}

	public InitView() {

		if (!this.skill_item_list) {
			this.skill_item_list = []
		}
		let list = DiamondFightModel.SKILL_LIST
		let item = null
		for (let index in list) {

			item = this.skill_item_list[index]
			if (item == null) {
				item = new DiamondFightSkillItem(this._panel_skill_item)
				item.Load()
				item.SetPosition(0, Number(index) * 63)
				this.skill_item_list[index] = item
			}
			item.SetData(list[index])
		}
		this.UpdateCountDown()
		this.UpdateRoleHearts()
		this.PlayTween()
	}

	public StartCountTime(index?, func?) {

		if (!this.time_id) {
			this.time_id = {}
		}
		this.CancelCountTime(index)
		this.time_id[index] = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
		func()
	}

	public CancelCountTime(index?) {

		if (index == null) {
			if (!this.time_id) {
				return
			}
			for (let key in this.time_id) {
				GlobalTimerQuest.CancelQuest(this.time_id[key])
			}
			this.time_id = null
		} else {
			if (!this.time_id || !this.time_id[index]) {
				return
			}
			GlobalTimerQuest.CancelQuest(this.time_id[index])
			delete this.time_id[index]
		}
	}

	public UpdateRoleHearts() {

		let lives_info = this.model.lives_info
		if (lives_info) {
			let role_vo = this.role_mgr.GetMainRoleVo()
			if (role_vo.pos_x > 1200) {
				//右边
				this.SetRoleHeart(1, lives_info.self_life)
				this.SetRoleHeart(0, lives_info.other_life)
			} else {
				this.SetRoleHeart(0, lives_info.self_life)
				this.SetRoleHeart(1, lives_info.other_life)
			}


		}
	}

	public SetRoleHeart(index?, value?) {

		let i = 0
		do {
			this.res_mgr.SetImageSprite(this, this["_img_" + index + "_heart" + i], "diamondFight", i < value && "uizsdz_010a" || "uizsdz_010b")
			i = i + 1
		} while ((i < 3)
		)
	}

	public PlayTween() {

		let end_time = this.model.fight_start_time
		if (!end_time) {
			return
		}
		if (end_time < TimeUtil.getServerTime()) {
			SetAnchoredPositionX(this._box_skill, 0)
		} else {
			this.StartCountTime(1, () => {
				let left_time = end_time - TimeUtil.getServerTime()
				if (left_time <= 1) {
					this.tween_id = SYTweenLite.to(this, this._box_skill, SYTweenLite.UiAnimationType.ANCHORED_POSX, 0, 0.1, null, SYTweenFunc.EASE_OUT)
					this.CancelCountTime(1)
					return
				}
			}
			)
		}
	}

	public CreateGodBtn() {

		// this._god_btn =  new MainUIGodBtn(this._gp_god)
	}

	public ClearGodBtn() {

		// if (this._god_btn ) {
		// 	this._god_btn.DeleteMe()
		// 	this._god_btn = null
		// }
	}



	_box_skill: Laya.Box
	_img_sub_bg: Laya.Image
	_img_bg: Laya.Image
	_lb_title: Laya.Label
	_panel_skill_item: Laya.Panel
	_box_left: Laya.Box
	_img_left_bg: Laya.Image
	_img_0_hp: Laya.Image
	_lb_0_hp: Laya.Label
	_img_0_head: Laya.Box
	_img_0_vip: Laya.Image
	_img_left_bg2: Laya.Image
	_lb_0_fighting: Laya.Label
	_lb_0_name: Laya.Label
	_box_left_heart: Laya.HBox
	_img_1_heart0: Laya.Image
	_img_1_heart1: Laya.Image
	_img_1_heart2: Laya.Image
	_box_right: Laya.Box
	_img_right_bg: Laya.Image
	_img_1_hp: Laya.Image
	_lb_1_hp: Laya.Label
	_img_1_head: Laya.Box
	_img_1_vip: Laya.Image
	_lb_1_name: Laya.Label
	_img_right_bg2: Laya.Image
	_lb_1_fighting: Laya.Label
	_box_right_heart: Laya.HBox
	_img_0_heart0: Laya.Image
	_img_0_heart1: Laya.Image
	_img_0_heart2: Laya.Image
	_box_count_time: Laya.Box
	_Image5: Laya.Image
	_lb_count_time: Laya.Label
	_gp_god: Laya.Box
	_img_vs: Laya.Image
	public GetComponents() {
		[
			this._box_skill,
			this._img_sub_bg,
			this._img_bg,
			this._lb_title,
			this._panel_skill_item,
			this._box_left,
			this._img_left_bg,
			this._img_0_hp,
			this._lb_0_hp,
			this._img_0_head,
			this._img_0_vip,
			this._img_left_bg2,
			this._lb_0_fighting,
			this._lb_0_name,
			this._box_left_heart,
			this._img_1_heart0,
			this._img_1_heart1,
			this._img_1_heart2,
			this._box_right,
			this._img_right_bg,
			this._img_1_hp,
			this._lb_1_hp,
			this._img_1_head,
			this._img_1_vip,
			this._lb_1_name,
			this._img_right_bg2,
			this._lb_1_fighting,
			this._box_right_heart,
			this._img_0_heart0,
			this._img_0_heart1,
			this._img_0_heart2,
			this._box_count_time,
			this._Image5,
			this._lb_count_time,
			this._gp_god,
			this._img_vs,
		]
			= this.GetChildrenByNames([

				"_box_skill",
				"_img_sub_bg",
				"_img_bg",
				"_lb_title",
				"_panel_skill_item",
				"_box_left",
				"_img_left_bg",
				"_img_0_hp",
				"_lb_0_hp",
				"_img_0_head",
				"_img_0_vip",
				"_img_left_bg2",
				"_lb_0_fighting",
				"_lb_0_name",
				"_box_left_heart",
				"_img_1_heart0",
				"_img_1_heart1",
				"_img_1_heart2",
				"_box_right",
				"_img_right_bg",
				"_img_1_hp",
				"_lb_1_hp",
				"_img_1_head",
				"_img_1_vip",
				"_lb_1_name",
				"_img_right_bg2",
				"_lb_1_fighting",
				"_box_right_heart",
				"_img_0_heart0",
				"_img_0_heart1",
				"_img_0_heart2",
				"_box_count_time",
				"_Image5",
				"_lb_count_time",
				"_gp_god",
				"_img_vs",
			])
	}
}
window["DiamondFightSceneView"] = DiamondFightSceneView
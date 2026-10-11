import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName, SceneEventType } from "../common/EventName"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GetSizeDeltaX, SetAnchoredPositionX, SetAnchoredPositionY, SetLocalScale, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"

export class DiamondFightMatchSuccessView extends BaseView1 {


	anim_list
	anim_dic
	center_x
	center_y
	end_time
	timer_out

	// let Math = math
	fight_item_0:FightingShowSmallItem
	fight_item_1:FightingShowSmallItem

	layer_mgr: LayerManager
	model: DiamondFightModel
	res_mgr: ResManager
	public constructor() {
		super()

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightMatchSuccessView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.background_alpha = 0
		this.change_scene_close = true
		// this.dependent_res = ["friend"]
		// this.is_center = true

		this.model = DiamondFightModel.GetInstance()
		this.layer_mgr = LayerManager.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.timer_out = null
		this.center_x = null
		this.center_y = null
		this.end_time = null
		let voice

		this.load_callback = () => {
			voice=CommonManager.GetInstance().PlayFightingVoice(3)
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}
			this.Remove()
		}
	}

	public Remove() {

		if (this.timer_out) {
			clearTimeout(this.timer_out)
			this.timer_out = null
		}

		if (this.anim_dic && Util.TableSize(this.anim_dic) > 0) {
			let v
			for (let index in this.anim_dic) {
				v = this.anim_dic[index]
				SYTweenLite.Stop(v)
			}
			this.anim_dic = {}
		}

		if (this.anim_list && Util.TableSize(this.anim_list) > 0) {
			let v
			for (let index in this.anim_list) {
				v = this.anim_list[index]
				SYTweenLite.Stop(v)
			}
			this.anim_list = []
		}

		for (let i = 0; i <= 1; i++) {
			if (this["head" + i]) {
				this["head" + i].DeleteMe()
				this["head" + i] = null
			}
		}


		if(this.fight_item_0){
			this.fight_item_0.DeleteMe()
			this.fight_item_0 = null
		}

		if(this.fight_item_1){
			this.fight_item_1.DeleteMe()
			this.fight_item_1 = null
		}
	}

	public LoadSuccess() {

		this.display_obj.left = this.display_obj.bottom = this.display_obj.right = 0
		this.display_obj.top = Util.GetLiuhaiHeight()

		this.fight_item_0 = new FightingShowSmallItem(this._gp_fight_left)
		this.fight_item_0.Load()
		this.fight_item_0.IsCenter(true, false)

		this.fight_item_1 = new FightingShowSmallItem(this._gp_fight_right)
		this.fight_item_1.Load()
		this.fight_item_1.IsCenter(true, false)


		// this.res_mgr.SetImageSpriteTrans(this, this._img_left_bg, GameResPath.GetIcon("topPk", "uikf1vn_023"), true)
		// this.res_mgr.SetImageSpriteTrans(this, this._img_right_bg, GameResPath.GetIcon("topPk", "uikf1vn_024"), true)

		this.center_x = this._box_center.centerX
		this.center_y = this._box_center.centerY

		let role_vo = SceneManager.GetInstance().GetOneRoleVo()
		if (role_vo) {
			this.UpdateRoleVo(role_vo)
		}

		// this.UpdateRoleVo(RoleManager.GetInstance().GetMainRoleVo())

		this.anim_list = []
		this.anim_dic = {}
		this.InitEvent()
		this.UpdateView()
	}

	public UpdateRoleVo(role_vo?) {

		this.model.fight_enemy_info = role_vo

		let main_vo = RoleManager.GetInstance().GetMainRoleVo()
		let list = [main_vo, role_vo]

		for (let k in list) {

			let key = k
			let vo = list[k]
			if (this["_lb_name" + key]) {
				this["_lb_name" + key].text = "S" + vo.server_id + "." + vo.name
			}

			if (this["_box_head" + key]) {
				if (this["head" + key] == null) {
					this["head" + key] = new CustomHeadItem(this["_box_head" + key])
					//this["trans_head" + key].SetActiveLevel(false)
					this["head" + key].SetActiveFrame(false)
					this["head" + key].Load()
				}
				this["head" + key].SetRoleVoData(vo)
			}

			if (!vo.is_fake_role) {
				if (this["fight_item_" + key]) {
					this["fight_item_" + key].Updatefighting(vo.fighting)
				}
			}
		}


		this.UpdateFakeInfo()
		//this:UpdateEnemyInfo()
	}

	public InitEvent() {

		this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_ADD, (role_id?, role_vo?) => {
			if(role_vo.role_id != RoleManager.GetInstance().GetMainRoleId()){
				this.UpdateRoleVo(role_vo)
			}
		})

		this.BindVar(this.model, "fight_start_time", () => {
			this.UpdateView()
		})

		this.BindVar(this.model, "fake_role_info", () => {
			this.UpdateFakeInfo()
		})
	}

	//function DiamondFightMatchSuccessView.UpdateEnemyInfo()
	//let enemy_vo = this.model.fight_enemy_info
	//if (enemy_vo ) {
	//let frame_id = this.dress_model.GetDressByType(enemy_vo.dress_list, DressType.Photo)
	//this.head2.setData(null, enemy_vo.career, enemy_vo.picture, null, null, frame_id)
	//if (! enemy_vo.is_fake_role ) {
	//this.fight2.text = "z" + enemy_vo.fighting
	//this.role_name2.text = "S" + enemy_vo.server_id + "." + enemy_vo.name
	//}
	//}
	//}

	public UpdateFakeInfo() {

		let fake_role_info = this.model.fake_role_info
		let fight_enemy_info = this.model.fight_enemy_info
		if (fight_enemy_info && fight_enemy_info.is_fake_role && fake_role_info) {
			if (this["fight_item_" + 1]) {
				this["fight_item_" + 1].Updatefighting(fake_role_info.power)
			}
			// this["_lb_fighting" + 1].text = fake_role_info.power
			this["_lb_name" + 1].text = "S" + fake_role_info.server_num + "." + fight_enemy_info.name
		}
	}

	public UpdateView() {

		if (this.use_delete_method) {
			return
		}
		if (!this.anim_list) {
			this.anim_list = {}
		}
		let end_time = this.model.fight_start_time
		if (end_time) {
			this.end_time = end_time
			let leftTime = end_time - TimeUtil.getServerTime()
			// if (leftTime >= 4) {
			// 	leftTime = 4
			// }
			if (leftTime < 1) {
				this.Close()
				setTimeout(() => {
					if (this.use_delete_method) { return }
					GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
				}, 1000)
				return false
			}
			if (leftTime > 2) {
				this.FadeIn()
			} else if (leftTime > 1) {
				let screenWidth = this.layer_mgr.stageWidth
				this._box_left.x = 0
				this._box_right.x = screenWidth - this._box_right.width
				this._box_center.alpha = 1
				this.timer_out = setTimeout(() => {
					if (!this.use_delete_method) {
						this.FadeOut()
					}
				}, (leftTime - 1) * 1000)
			} else {
				this.FadeOut()
			}
		}
		return true
	}

	public FadeIn() {

		if (this.use_delete_method) {
			return
		}
		let screenWidth = this.layer_mgr.stageWidth

		let center_x = ( screenWidth - this._box_left.width ) /2
		this._box_left.centerX = -center_x
		this._box_right.centerX = center_x
		this._img_vs.visible = false

		this._box_center.scaleX = this._box_center.scaleY = 5

		this._box_center.centerX = this.center_x + 200
		this._box_center.centerY = this.center_y - 50

		SYTweenLite.Stop(this.anim_dic["center1"])
		SYTweenLite.Stop(this.anim_dic["center2"])
		this.anim_dic["center1"] =
			SYTweenLite.to(this,
				this._box_center,
				SYTweenLite.UiAnimationType.CENTER_POS,
				new Vector2(this.center_x, this.center_y),
				0.3,
				null,
				SYTweenFunc.EASE_IN,
				false)
		this.anim_dic["center2"] =
			SYTweenLite.to(this,
				this._box_center,
				SYTweenLite.UiAnimationType.SCALE,
				new Vector3(1, 1, 1),
				0.3,
				null,
				SYTweenFunc.EASE_IN,
				false)
		this.timer_out = setTimeout(() => {
			if (this.use_delete_method) {
				return
			}
			if (this.timer_out) {
				clearTimeout(this.timer_out)
				this.timer_out = null
			}
			SYTweenLite.Stop(this.anim_dic["left"])
			this.anim_dic["left"] =
				SYTweenLite.to(this,
					this._box_left,
					SYTweenLite.UiAnimationType.CENTER_POSX,
					-163,
					0.25, () => {
						let delayTime = this.end_time - TimeUtil.getServerTime()
						if (delayTime > 0) {
							this.timer_out = setTimeout(() => {
								if (this.timer_out) {
									clearTimeout(this.timer_out)
									this.timer_out = null
								}
								if (!this.use_delete_method) {
									this.FadeOut()
								}
							}, ((delayTime - 1) + 0.85) * 1000)
						} else {
							this.FadeOut()
						}
					},
					SYTweenFunc.EASE_IN,
					false)

			SYTweenLite.Stop(this.anim_dic["right"])
			this.anim_dic["right"] =
				SYTweenLite.to(this,
					this._box_right,
					SYTweenLite.UiAnimationType.CENTER_POSX,
					163,
					0.25,
					null,
					SYTweenFunc.EASE_IN,
					false)
			this._img_vs.visible = true
		}, 0.2 * 1000)
	}

	public FadeOut() {

		this.anim_dic["center3"] = SYTweenLite.to(this,
			this._box_center,
			SYTweenLite.UiAnimationType.ALPHA,
			0,
			0.7,
			null,
			SYTweenFunc.EASE_IN,
			false)

		this.anim_dic["vs"] = SYTweenLite.to(this,
			this._img_vs,
			SYTweenLite.UiAnimationType.ALPHA,
			0,
			0.7,
			null,
			SYTweenFunc.EASE_IN,
			false)

		let len = 100
		let angle = 60 * Math.PI / 180

		let target_x = this._box_left.centerX + len * Math.cos(angle)
		let target_y = this._box_left.centerY - len * Math.sin(angle)

		let target_x2 = this._box_right.centerX - len * Math.cos(angle)
		let target_y2 = this._box_right.centerY + len * Math.sin(angle)

		SYTweenLite.Stop(this.anim_dic["left"])
		table.insert(this.anim_list, SYTweenLite.to(this,
			this._box_left,
			SYTweenLite.UiAnimationType.CENTER_POS,
			new Vector2(target_x, target_y),
			0.7,
			null,
			SYTweenFunc.EASE_OUT,
			false))
		table.insert(this.anim_list, SYTweenLite.to(this,
			this._box_left,
			SYTweenLite.UiAnimationType.ALPHA,
			0,
			0.7, () => {
				GlobalEventSystem.Fire(EventName.STARTAUTOFIGHT)
				this.Close()
			},
			SYTweenFunc.EASE_OUT,
			false))
		SYTweenLite.Stop(this.anim_dic["right"])
		table.insert(this.anim_list, SYTweenLite.to(this,
			this._box_right,
			SYTweenLite.UiAnimationType.CENTER_POS,
			new Vector2(target_x2, target_y2),
			0.7,
			null,
			SYTweenFunc.EASE_OUT,
			false))
		table.insert(this.anim_list, SYTweenLite.to(this,
			this._box_right,
			SYTweenLite.UiAnimationType.ALPHA,
			0,
			0.7,
			null,
			SYTweenFunc.EASE_OUT,
			false))
	}


_box_left:Laya.Box
_img_left_bg:Laya.Image
_lb_left_level:Laya.Label
_box_head0:Laya.Box
_lb_name0:Laya.Label
_gp_fight_left:Laya.Box
_box_right:Laya.Box
_img_right_bg:Laya.Image
_lb_right_level:Laya.Label
_box_head1:Laya.Box
_lb_name1:Laya.Label
_gp_fight_right:Laya.Box
_box_center:Laya.Box
_img_match_success:Laya.Image
_img_vs:Laya.Image
public GetComponents() {
[
this._box_left,
this._img_left_bg,
this._lb_left_level,
this._box_head0,
this._lb_name0,
this._gp_fight_left,
this._box_right,
this._img_right_bg,
this._lb_right_level,
this._box_head1,
this._lb_name1,
this._gp_fight_right,
this._box_center,
this._img_match_success,
this._img_vs,
]
 = this.GetChildrenByNames([

"_box_left",
"_img_left_bg",
"_lb_left_level",
"_box_head0",
"_lb_name0",
"_gp_fight_left",
"_box_right",
"_img_right_bg",
"_lb_right_level",
"_box_head1",
"_lb_name1",
"_gp_fight_right",
"_box_center",
"_img_match_success",
"_img_vs",
])
}
}
 window["DiamondFightMatchSuccessView"]= DiamondFightMatchSuccessView
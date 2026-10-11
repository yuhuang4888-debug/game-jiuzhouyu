import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPositionX, GetSizeDeltaX, SetLocalScale, SetAnchoredPositionY, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"


//资格赛匹配成功界面
export class Kf1vnMatchSuccessView extends BaseView1 {
	FadeIn
	FadeOut
	InitEvent
	LoadSuccess
	Local_Open
	OpenCallback
	anim_list
	back_login_close
	background_alpha
	destroy_callback
	destroy_imm
	use_background
	load_complete_id
	head11:CustomHeadItem
	head22:CustomHeadItem
	ClearTime
	ClearTween
	public constructor() {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnMatchSuccessView"
		this.layer_value = Enum_UILayer.Activity
		this.back_login_close = true
		this.destroy_imm = true
		this.use_background = true
		this.background_alpha = 0
		let model = Kf1vnModel.GetInstance()
		let auto_fight_mgr = AutoFightManager.GetInstance()
		let layer_mgr = LayerManager.GetInstance()
		let local_Math = Math
		let data_ = null
		let list_time = []
		let center_x_ = null
		let center_y_ = null
		this.anim_list ={}
		let voice
		this.load_callback = () => {
			if (!list_time) list_time = []
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.ClearTime=()=>{
			for (let i = 0; i < list_time.length; i++) {
				clearTimeout(list_time[i])
			}
			list_time.length = 0
		}

		this.ClearTween = ()=>{
			for (let key in this.anim_list) {
				SYTweenLite.Stop(this.anim_list[key])
				delete this.anim_list[key]
			}
		}

		this.destroy_callback = () => {
			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}
			
			this.ClearTime()

			if (this.head11) {
				this.head11.DeleteMe()
				this.head11 = null
			}
			if (this.head22) {
				this.head22.DeleteMe()
				this.head22 = null
			}
			this.ClearTween()
			if (this.load_complete_id) {
				GlobalEventSystem.UnBind(this.load_complete_id)
				this.load_complete_id = null
			}
		}

		this.LoadSuccess = () => {

			ResManager.GetInstance().SetOutsideImageSprite(this, this.left_img, GameResPath.GetIcon("kf1vn", "uikf1vn_023"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.right_img, GameResPath.GetIcon("kf1vn", "uikf1vn_024"))
			
			center_x_ = this.center_conta.x
			center_y_ = this.center_conta.y

			this.head11 = new CustomHeadItem(this.head1)
			this.head11.CloseClick()
			this.head11.Load()
			this.head22 = new CustomHeadItem(this.head2)
			this.head22.CloseClick()
			this.head22.Load()

			voice=CommonManager.GetInstance().PlayFightingVoice(3)
		}

		this.InitEvent = () => {

		}

		this.Local_Open = (parms?) => {
			data_ = parms && parms[0] || null
			if (!data_) {
				let sInfo = model.stage_info
				if (sInfo) {
					if (sInfo.stage == 3) {
						data_ = model.ticket_fighting_info
					} else if (sInfo.stage == 5) {
						data_ = model.leader_fighting_info
					}
				}
			}
			super.Open()
		}

		this.OpenCallback = () => {
			if (data_) {

				let leftTime = data_.loading_time - TimeUtil.getServerTime()
				if (leftTime >= 4) {
					leftTime = 4
				}
				if (leftTime < 1) {
					this.Close()
					setTimeout(() => {
						if (this.use_delete_method) {
							return
						}
						auto_fight_mgr.SetAutoFight(true)
					}, leftTime*1000)
					return
				}
				if (data_.battle_list[0]) {
					let vo = data_.battle_list[0]
					this.role_name1.text = vo.name
					let head_data = { role_id: vo.player_id, picture: vo.picture, picture_ver: vo.picture_ver }
					this.head11.SetRoleVoData(head_data, null, null, vo.lv)
					this.fight1.text = `战力：${vo.combat_power}`
					this.server1.text = `【S${vo.server_num}】`
				}
				if (data_.battle_list[1]) {
					let vo = data_.battle_list[1]
					this.role_name2.text = vo.name
					let head_data2 = { role_id: vo.player_id, picture: vo.picture, picture_ver: vo.picture_ver }
					this.head22.SetRoleVoData(head_data2, null, null, vo.lv)
					this.fight2.text = `战力：${vo.combat_power}`
					this.server2.text = `【S${vo.server_num}】`
				}
				if (leftTime > 2) {
					this.FadeIn()
				} else if (leftTime > 1) {
					SetAnchoredPositionX(this.left_conta, 0)
					SetAnchoredPositionX(this.right_conta, 0)
					this.center_conta.alpha = 1
					let id = setTimeout(() => {
						if (!this.use_delete_method) {
							this.FadeOut()
						}
					}, (leftTime - 1)*1000)
					table.insert(list_time, id)
				} else {
					this.FadeOut()
				}
			}
		}

		this.FadeIn = () => {
			this.ClearTime()
			this.ClearTween()

			let flyWidth = 150
			SetAnchoredPositionX(this.left_conta, -flyWidth)
			SetAnchoredPositionX(this.right_conta, flyWidth)
			this.left_conta.alpha = 0
			this.right_conta.alpha = 0
			this.center_conta.alpha = 0
			this.vs.visible = false
			this.vs.alpha = 1
			SetLocalScale(this.center_conta, 5, 5)
			
			//动画时间
			let anim_time = 0.2
			this.anim_list["center2"] = SYTweenLite.to(this, this.center_conta, SYTweenLite.UiAnimationType.SCALE, { x: 1, y: 1, z: 1 }, anim_time+0.05, null, SYTweenFunc.EASE_IN, false)
			this.anim_list["center3"] = SYTweenLite.to(this, this.center_conta, SYTweenLite.UiAnimationType.ALPHA, 1, anim_time/2, null, SYTweenFunc.EASE_IN, false)

			let id = setTimeout(() => {
				if (this.use_delete_method) {
					return
				}

				this.anim_list["left_a"] = SYTweenLite.to(this, this.left_conta, SYTweenLite.UiAnimationType.ALPHA, 1, anim_time/2, null, SYTweenFunc.EASE_IN, false)
				this.anim_list["left"] = SYTweenLite.to(this, this.left_conta, SYTweenLite.UiAnimationType.ANCHORED_POSX, 0, anim_time-0.05, () => {
					let delayTime = data_.loading_time - TimeUtil.getServerTime()
					if (delayTime >= 3) {
						delayTime = 3
					}
					if (delayTime > 0) {
						let id2 = setTimeout(() => {
			
							if (!this.use_delete_method) {
								this.FadeOut()
							}
						}, delayTime*1000)
						table.insert(list_time, id2)
					} else {
						this.FadeOut()
					}
					this.vs.visible = true
				}, SYTweenFunc.EASE_IN, false)

				this.anim_list["right"] = SYTweenLite.to(this, this.right_conta, SYTweenLite.UiAnimationType.ANCHORED_POSX, 0, anim_time-0.05, null, SYTweenFunc.EASE_IN, false)
				this.anim_list["right_a"] = SYTweenLite.to(this, this.right_conta, SYTweenLite.UiAnimationType.ALPHA, 1, anim_time/2, null, SYTweenFunc.EASE_IN, false)
				
			}, 100)
			table.insert(list_time, id)
		}

		this.FadeOut = () => {
			this.ClearTime()
			this.ClearTween()

			let anim_time = 0.3
			let anim_time_alpha = 0.1
			
			this.anim_list["center_conta"]=SYTweenLite.to(this, this.center_conta, SYTweenLite.UiAnimationType.ALPHA, 0, anim_time, null, SYTweenFunc.EASE_IN, false)
			this.anim_list["vs"]=SYTweenLite.to(this, this.vs, SYTweenLite.UiAnimationType.ALPHA, 0, anim_time+anim_time_alpha, null, SYTweenFunc.EASE_IN, false)


			let len = 100
			let angle = 60 * local_Math.PI / 180
			let target_x = this.left_conta.x - len * local_Math.cos(angle)
			let target_y = this.left_conta.y - len * local_Math.sin(angle)
			let target_x2 = this.right_conta.x + len * local_Math.cos(angle)
			let target_y2 = this.right_conta.y + len * local_Math.sin(angle)

			this.anim_list["left_conta_1"] = SYTweenLite.to(this, this.left_conta, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(target_x, target_y), anim_time, null, SYTweenFunc.EASE_OUT, false)
			this.anim_list["left_conta_2"] =  SYTweenLite.to(this, this.left_conta, SYTweenLite.UiAnimationType.ALPHA, 0, anim_time+anim_time_alpha, () => {
				auto_fight_mgr.SetAutoFight(true)
				this.Close()
			},SYTweenFunc.EASE_OUT, false)

			this.anim_list["right_conta_1"] =SYTweenLite.to(this, this.right_conta, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(target_x2, target_y2), anim_time, null, SYTweenFunc.EASE_OUT, false)
			this.anim_list["right_conta_2"] = SYTweenLite.to(this, this.right_conta, SYTweenLite.UiAnimationType.ALPHA, 0, anim_time+anim_time_alpha, null, SYTweenFunc.EASE_OUT, false)
		}
	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_box_1: Laya.Box
	left_conta: Laya.Box
	left_img: Laya.Image
	role_name1: Laya.Label
	server1: Laya.Label
	fight1: Laya.Label
	head1: Laya.Box
	_box_2: Laya.Box
	right_conta: Laya.Box
	right_img: Laya.Image
	fight2: Laya.Label
	role_name2: Laya.Label
	server2: Laya.Label
	head2: Laya.Box
	_box_3: Laya.Box
	center_conta: Laya.Box
	icon: Laya.Image
	vs: Laya.Image
	public GetComponents() {
		[
			this._box_1,
			this.left_conta,
			this.left_img,
			this.role_name1,
			this.server1,
			this.fight1,
			this.head1,
			this._box_2,
			this.right_conta,
			this.right_img,
			this.fight2,
			this.role_name2,
			this.server2,
			this.head2,
			this._box_3,
			this.center_conta,
			this.icon,
			this.vs,
		]
			= this.GetChildrenByNames([

				"_box_1",
				"left_conta",
				"left_img",
				"role_name1",
				"server1",
				"fight1",
				"head1",
				"_box_2",
				"right_conta",
				"right_img",
				"fight2",
				"role_name2",
				"server2",
				"head2",
				"_box_3",
				"center_conta",
				"icon",
				"vs",
			])
	}
}
window["Kf1vnMatchSuccessView"] = Kf1vnMatchSuccessView
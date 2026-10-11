import { BaseView1 } from "../common/BaseView1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { TopPkModel } from "../commonModel/TopPkModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetSizeDeltaX } from "../util/Util"

export class TopPkFightSceneView extends BaseView1 {
	_Group3: Laya.Box
	_Image1: Laya.Image
	_img_0_hp: Laya.Image
	_lb_0_hp: Laya.Label
	_img_0_head: Laya.Box
	_Group1: Laya.HBox
	_lb_0_name: Laya.Label
	_img_0_vip: Laya.Image
	_Group2: Laya.Box
	_Image2: Laya.Image
	_lb_0_fighting: Laya.Label
	_Group6: Laya.Box
	_Image3: Laya.Image
	_img_1_hp: Laya.Image
	_lb_1_hp: Laya.Label
	_img_1_head: Laya.Box
	_Group4: Laya.Box
	_lb_1_name: Laya.Label
	_img_1_vip: Laya.Image
	_Group5: Laya.Box
	_Image4: Laya.Image
	_lb_1_fighting: Laya.Label
	_gp_vs_effect_con: Laya.Box
	_gp_count_time: Laya.Box
	_Image5: Laya.Image
	_lb_count_time: Laya.Label
	_gp_god: Laya.Box
	CancelCountTime
	ClearGodBtn
	CreateGodBtn
	InitEvent
	InitView
	LoadSuccess
	Remove
	StartCountTime
	UpdateCountDown
	UpdateMatchData
	UpdateRolesVo
	_god_btn
	is_set_order_sorting
	percentWidth

	public static HP_WIDTH = 171;
	public constructor() {
		super()


		this.base_file = "topPk"
		this.layout_file = "TopPkFightSceneView"
		this.layer_value = Enum_UILayer.Main
		this.destroy_imm = true
		this.is_set_order_sorting = false
		let model = TopPkModel.GetInstance()
		let local_WordManager = WordManager
		let local_TimeUtil = TimeUtil
		let enemy_pos_ = null
		let time_id_ = null
		let time_func_ = null
		this.percentWidth = 100
		this.back_login_toClose = true
		this.change_scene_close = true
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.Remove = () => {
			this.CancelCountTime()
			// [ts2lua]this下标访问可能不正确
			// if (this["_head0"]) {
			// 	// [ts2lua]this下标访问可能不正确
			// 	this["_head0"].DeleteMe()
			// 	// [ts2lua]this下标访问可能不正确
			// 	this["_head1"].DeleteMe()
			// }
			this.ClearGodBtn()
			enemy_pos_ = null
			for (let i = 0; i <= 1; i++) {
				if (this["head" + i]) {
					this["head" + i].DeleteMe()
					this["head" + i] = null
				}
			}

		}

		this.LoadSuccess = () => {
			//this:AddUIEffect("ui_fight_vs", this._gp_vs_effect_con, null, null, true)
			this.InitView()
			this.InitEvent()
			//this:CreateGodBtn()
		}

		this.UpdateRolesVo = (role_vo?) => {
			if (!this.isPop) return
			if (role_vo) {
				let main_vo = RoleManager.GetInstance().GetMainRoleVo()
				let bool = main_vo.pos_x > role_vo.pos_x
				// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
				enemy_pos_ = !bool && 1 || 0
				// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
				let list = bool && [role_vo, main_vo] || [main_vo, role_vo]
				for (let k in list) {

					let key = Number(k)
					let vo = list[k]
					// [ts2lua]this下标访问可能不正确
					this["_lb_" + key + "_hp"].text = local_WordManager.ConvertNum(vo.hp, true) + "/" + local_WordManager.ConvertNum(vo.maxHp, true)
					// [ts2lua]this下标访问可能不正确
					this["_lb_" + key + "_name"].text = vo.name
					if (this["head" + key] == null) {
						this["head" + key] = new CustomHeadItem(this["_img_" + key + "_head"])
						this["head" + key].Load()
					}
					this["head" + key].SetRoleVoData(vo)
					if (key == 1) {
						this["head" + key].ExcuteCallback(() => {
							this["head1"].bg.visible = false
							this["head1"]._level_gp.x = 55
							this["head1"]._level_gp.y = -5
						})
					}
					let source
					if (vo.vip_flag && vo.vip_flag > 0) {
						if (vo.is_fake_role) {
							if(vo.is_hide_vip > 0){
								source = "VIP-x"
								if (vo.supreme_vip == 1) {
									source = "SVIP-x"
								}
							}
							else{
								source = "uivip_zjm_" + vo.vip_flag
								if (vo.supreme_vip == 1) {
									source = "VIP_" + vo.vip_flag
								}
							}
							// ResManager.GetInstance().SetImageSprite(this, this["_img_" + key + "_vip"], "mainUI_asset", source)
						} else {
							// [ts2lua]this下标访问可能不正确
							if(vo.is_hide_vip > 0){
								source = "VIP-x"
								if (vo.supreme_vip == 1) {
									source = "SVIP-x"
								}
							}
							else{
								source = "uivip_zjm_" + vo.vip_flag
								if (vo.supreme_vip == 1) {
									source = "VIP_" + vo.vip_flag
								}
							}
						}
						ResManager.GetInstance().SetImageSprite(this, this["_img_" + key + "_vip"], "mainUI", source)

						this["_img_" + key + "_vip"].visible = true
					} else {
						this["_img_" + key + "_vip"].visible = false
					}

					if (!vo.is_fake_role) {
						// [ts2lua]this下标访问可能不正确
						this["_lb_" + key + "_fighting"].text = vo.fighting
					}
					this.BindVar(vo, "hp", (event_name?, value?) => {
						// [ts2lua]this下标访问可能不正确
						this["_lb_" + key + "_hp"].text = local_WordManager.ConvertNum(value, true) + "/" + local_WordManager.ConvertNum(vo.maxHp, true)
						// [ts2lua]this下标访问可能不正确
						let width = TopPkFightSceneView.HP_WIDTH * value / vo.maxHp

						SetSizeDeltaX(this["_img_" + key + "_hp"], width)
					}
					)
				}
			}
			this.UpdateMatchData()
		}

		this.InitEvent = () => {
			this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_ADD, (role_id?, role_vo?) => {
				this.UpdateRolesVo(role_vo)
			}
			)
			this.BindVar(model, "fight_end_time", (event_name?, value?) => {
				this.UpdateCountDown()
			}
			)
			this.BindVar(model, "quit_scene_time", (event_name?, value?) => {
				this.UpdateCountDown()
			}
			)
			this.BindVar(model, "match_data", () => {
				this.UpdateMatchData()
			}
			)
		}

		this.UpdateMatchData = () => {
			let match_data = model.match_data
			if (match_data) {
				if (enemy_pos_ != null && match_data.fake_man_power && match_data.fake_man_power != 0) {
					// [ts2lua]this下标访问可能不正确
					this["_lb_" + enemy_pos_ + "_fighting"].text = match_data.fake_man_power
				}
			}
		}

		this.UpdateCountDown = () => {
			let end_time = model.quit_scene_time
			if (!end_time) {
				end_time = model.fight_end_time
			}
			if (end_time) {
				this.StartCountTime(() => {
					let left_time = end_time - local_TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelCountTime()
						return
					}
					if (!this._gp_count_time.visible) {
						let start_time = model.fight_start_time
						if (start_time && local_TimeUtil.getServerTime() >= start_time) {
							this._gp_count_time.visible = true
						}
					}
					this._lb_count_time.text = local_TimeUtil.timeConvert8(left_time)
				}
				)
			}
		}

		this.InitView = () => {
			let role_vo = SceneManager.GetInstance().GetOneRoleVo()

			if (role_vo) {
				this.UpdateRolesVo(role_vo)
			}
			this.UpdateCountDown()
		}

		this.StartCountTime = (func?) => {
			this.CancelCountTime()


			let OnTime = () => { }

			time_id_ = GlobalTimerQuest.AddPeriodQuest(func, 1)

			func()
		}

		this.CancelCountTime = () => {
			if (time_id_) {
				if (time_id_) {
					GlobalTimerQuest.CancelQuest(time_id_)
				}
				time_id_ = null
				time_func_ = null
			}
		}

		this.CreateGodBtn = () => {
			//this._god_btn =  new MainUIGodBtn(this._gp_god)
		}

		this.ClearGodBtn = () => {
			if (this._god_btn) {
				this._god_btn.DeleteMe()
				this._god_btn = null
			}
		}


	}



	public GetComponents() {
		[
			this._Group3,
			this._Image1,
			this._img_0_hp,
			this._lb_0_hp,
			this._img_0_head,
			this._Group1,
			this._lb_0_name,
			this._img_0_vip,
			this._Group2,
			this._Image2,
			this._lb_0_fighting,
			this._Group6,
			this._Image3,
			this._img_1_hp,
			this._lb_1_hp,
			this._img_1_head,
			this._Group4,
			this._lb_1_name,
			this._img_1_vip,
			this._Group5,
			this._Image4,
			this._lb_1_fighting,
			this._gp_vs_effect_con,
			this._gp_count_time,
			this._Image5,
			this._lb_count_time,
			this._gp_god,
		]
			= this.GetChildrenByNames([

				"_Group3",
				"_Image1",
				"_img_0_hp",
				"_lb_0_hp",
				"_img_0_head",
				"_Group1",
				"_lb_0_name",
				"_img_0_vip",
				"_Group2",
				"_Image2",
				"_lb_0_fighting",
				"_Group6",
				"_Image3",
				"_img_1_hp",
				"_lb_1_hp",
				"_img_1_head",
				"_Group4",
				"_lb_1_name",
				"_img_1_vip",
				"_Group5",
				"_Image4",
				"_lb_1_fighting",
				"_gp_vs_effect_con",
				"_gp_count_time",
				"_Image5",
				"_lb_count_time",
				"_gp_god",
			])
		ResManager.GetInstance().LoadFont(this, "fighting_font", this._lb_1_fighting, null, false)
		ResManager.GetInstance().LoadFont(this, "fighting_font", this._lb_0_fighting, null, false)
	}
}
window["TopPkFightSceneView"] = TopPkFightSceneView
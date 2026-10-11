import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { FirstBloodEvent, FirstBloodModel } from "../commonModel/FirstBloodModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PartnerModel } from "../commonModel/PartnerModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { Config } from "../common/Config"
import { SceneManager } from "../scene/SceneManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"

export class DungeonPartnerItem extends BaseItem1 {

	index
	lock_state
	need_refresh_data
	first_blood_data
	page
	click_pos: Laya.Point
	cur_page
	data
	vs_state_index

	goodsmodel: GoodsModel
	first_blood_model
	partner_model: PartnerModel
	res_mgr: ResManager
	model: DungeonPartnerModel

	public constructor(parent) {
		super(parent)

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerItem"

		this.model = DungeonPartnerModel.GetInstance()
		this.partner_model = PartnerModel.GetInstance()
		this.goodsmodel = GoodsModel.GetInstance()
		this.first_blood_model = FirstBloodModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		this.InitEvent()
		if (this.need_refresh_data) {
			this.UpdateItem()
			this.need_refresh_data = null
		}

	}

	public InitEvent() {

		let onClickBtnHandler = (e: Laya.Event) => {
			if (e.target == this._box_model || e.target == this._box_vs) {
				// if( e.target == this._box_vs){
				// 	if (SceneManager.GetInstance().IsSuitBossScene()) {
                //         Message.show("当前场景不能进入")
                //         return
                //     }
				// }
				if (3 == this.data.score) {
					Message.show("已通关关卡，无法再次挑战")
				} else if (this.lock_state) {
					if (this.IsFitLevel()) {
						Message.show("请先通关上一层")
					} else {
						Message.show("等级不够")
					}
				} else {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonPartnerVsView", this.data)
				}
			} else if (e.target == this._img_first_kill) {
				if (this.first_blood_data && 0 == this.first_blood_data.reward_state) { //可领取奖励
					FirstBloodModel.GetInstance().Fire(FirstBloodEvent.REQUEST_PROTO, 18802, "cci", 97, 1, this.first_blood_data.boss_id)
				} else {
					if (!this.click_pos) {
						this.click_pos = new Laya.Point()
					}
					this.click_pos.setTo(Laya.stage.mouseX, Laya.stage.mouseY)
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonPartnerFirstKillView", this.data, this.click_pos)
				}
			}
		}
		Util.AddClickEvent(this._box_model, onClickBtnHandler, this)
		Util.AddClickEvent(this._box_vs, onClickBtnHandler, this, true)
		Util.AddClickEvent(this._img_first_kill, onClickBtnHandler, this, true)

		this.BindEvent(this.first_blood_model, FirstBloodEvent.GET_FIRST_KILL_REWARD, (scmd18802?) => {
			if (scmd18802.boss_id == this.data.dun_id && this.is_loaded) {
				// this._img_first_kill_red.visible = false
				// if (this.first_blood_data) {
				// 	this.first_blood_data.reward_state = 1
				// }\
				this.UpdateFirstKillInfo()
			}
		})
	}

	//data {dun_id, score}
	public SetData(index?, data?, vs_state_index?, page?) {

		this.index = index
		this.data = data
		this.page = page
		this.vs_state_index = vs_state_index

		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateItem() {

		for (let i = 1; i <= 3; i++) {
			if (i <= this.data.score) {
				ResManager.GetInstance().SetImageSprite(this, this[`_img_star${i}`], "dungeonPartner", "star2")
			} else {
				ResManager.GetInstance().SetImageSprite(this, this[`_img_star${i}`], "dungeonPartner", "star_empty")
			}
		}

		this.cur_page = this.page || this.model.GetPage()

		if (this.IsBoss()) {
			this._img_bg4.visible = false

			
			this.UpdatePartnerInfo()
			this._box_partner_info.visible = true

			this._img_bg.width = 440
			this._img_bg.height = 440
			this._img_bg.x = -165
			this._img_bg.y = -293
			this._img_bg.skin = undefined

			//this.res_mgr.SetImageSprite(this, this._img_bg, this.base_file, "ui_copy_40")
			this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonPartner", "ui_copy_40"))

			this._img_star1.x = 0
			this._img_star1.y = 14
			this._img_star2.x = 43
			this._img_star2.y = 27
			this._img_star3.x = 86
			this._img_star3.y = 14
			this._img_star1.width = this._img_star2.width = this._img_star3.width = 35
			this._img_star1.height = this._img_star2.height = this._img_star3.height = 35

			this._box_first_kill.y = 42

			this._box_model.x = -94 
			this._box_model.y = -281
			this._box_model.width = 300
			this._box_model.height = 350

			this.CreateModel()

		} else if (this.IsJingYing()) {

			this._img_bg.width = 110
			this._img_bg.height = 58
			this._img_bg.x = 0
			this._img_bg.y = 0
			this.res_mgr.SetImageSprite(this, this._img_bg,this.base_file, "ui_copy_41")

			this._box_partner_info.visible = false

			this.res_mgr.SetImageSprite(this, this._img_bg4,this.base_file, "ui_copy_48")
			this._img_bg4.visible = true
			this._img_bg4.width = 119
			this._img_bg4.height = 112
			this._img_bg4.x = -5
			this._img_bg4.y = -89

			this._img_star1.x = 13
			this._img_star1.y = 14
			this._img_star2.x = 43
			this._img_star2.y = 27
			this._img_star3.x = 73
			this._img_star3.y = 14
			this._img_star1.width = this._img_star2.width = this._img_star3.width = 24
			this._img_star1.height = this._img_star2.height = this._img_star3.height = 24

			this._box_first_kill.y = 36

			this._img_lock.y = -45

			this._box_model.x = 0
			this._box_model.y = -86
			this._box_model.width = 110
			this._box_model.height = 147

			this._img_finish.centerY = -60

		} else { //小关卡
			this._img_bg.width = 110
			this._img_bg.height = 58
			this._img_bg.x = 0
			this._img_bg.y = 0
			this.res_mgr.SetImageSprite(this, this._img_bg, this.base_file, "ui_copy_41")
			
			this._box_partner_info.visible = false

			this.res_mgr.SetImageSprite(this, this._img_bg4, this.base_file, "ui_copy_47")
			this._img_bg4.visible = true
			this._img_bg4.width = 86
			this._img_bg4.height = 94
			this._img_bg4.x = 12
			this._img_bg4.y = -66


			this._img_star1.x = 13
			this._img_star1.y = 14
			this._img_star2.x = 43
			this._img_star2.y = 27
			this._img_star3.x = 73
			this._img_star3.y = 14
			this._img_star1.width = this._img_star2.width = this._img_star3.width = 24
			this._img_star1.height = this._img_star2.height = this._img_star3.height = 24

			this._img_lock.y = -39

			this._box_model.x = 0
			this._box_model.y = -66
			this._box_model.width = 110
			this._box_model.height = 124

			this._img_finish.centerY = -52
		}

		this._img_finish.visible = 3 == this.data.score
		let unlock_lv = this.model.GetStageUnlockLv(this.data.dun_id)

		//锁定状态
		let is_lock = false
		//是否第一次打
		let is_vs = false
		//打过
		let is_normal = false

		//可挑战的副本
		if (this.model.IsFinishPreDungeon(this.data.dun_id)) {
			//未到等级要求
			if (!this.IsFitLevel()) {
				is_lock = true
			} else {
				if (0 != this.data.score) {
					is_normal = true
				} else {
					is_vs = true
				}
			}
		} else {
			is_lock = true
		}

		let lock = this.SetLockState(is_lock)
		this.SetVsState(is_vs, lock)
		this.SetNormalState(is_normal)
		this.UpdateFirstKillInfo()
	}

	public UpdateFirstKillInfo() {
		//首杀数据
		if (!this.IsSmall()) {
			this._box_first_kill.visible = true
			this._lb_killer_name.text = "敬请期待"
			let kill_info = FirstBloodModel.GetInstance().GetKillInfo(97, 1)
			this._img_first_kill_red.visible = false
			if (kill_info) {
				let first_blood_data = this.model.GetDunFirstBloodData(this.data.dun_id)
				if(first_blood_data){
					this._lb_killer_name.text = first_blood_data.first_blood_role_name
					this._img_first_kill_red.visible = this.model.CheckDunFirstBloodRedPoint(this.data.dun_id)
				}
				this.first_blood_data = first_blood_data
			}
		}
	}

	public IsFitLevel() {
		let unlock_lv = this.model.GetStageUnlockLv(this.data.dun_id)
		return RoleManager.GetInstance().GetMainRoleVo().level >= unlock_lv
	}

	public SetVsState(bool?, is_lock?) {
		this._box_vs.visible = bool
		this._img_vs.visible = bool && !this.IsBoss()
		this._img_red.visible = bool && this.model.IsDungeonChallengeRedPoint(this.data.dun_id)
		this._img_star1.visible = this._img_star2.visible = this._img_star3.visible = (!bool && (is_lock != 1))
	}

	public SetNormalState(bool?) {
		this._img_monster_icon.visible = bool
		this._img_red2.visible = bool && this.model.IsDungeonChallengeRedPoint(this.data.dun_id)
	}

	//锁定状态有两个，一个是不满足等级，一个是未完成前置副本
	public SetLockState(bool?) {
		this._img_lock.visible = bool && !this.IsBoss()
		this.lock_state = bool
		if (bool) {
			let unlock_lv = this.model.GetStageUnlockLv(this.data.dun_id)
			//不满足等级
			if (unlock_lv > RoleManager.GetInstance().GetMainRoleVo().level) {
				this._lb_tips.visible = true
				let is_sc = unlock_lv > 370
				this._lb_tips.text = `达到${is_sc ? `神创${unlock_lv - 370}` : unlock_lv}级解锁`
				this._img_star1.visible = this._img_star2.visible = this._img_star3.visible = false
				return 1
			} else {
				this._lb_tips.visible = false
				this._img_star1.visible = this._img_star2.visible = this._img_star3.visible = true
				return 2
			}
		} else {
			this._lb_tips.visible = false
			this._img_star1.visible = this._img_star2.visible = this._img_star3.visible = true
			return 0
		}
	}

	public IsBoss() {
		return this.index == 9
	}

	//是否精英关卡
	public IsJingYing() {
		return this.index != 9 && 0 == this.index % 3
	}

	//是否小关卡
	public IsSmall() {
		return !this.IsBoss() && !this.IsJingYing()
	}

	public CreateModel() {
		let config_partner_dun_chapter = Config.PRELOAD_SERVER_CONFIG.config_partner_dun_chapter
		let partner_id = config_partner_dun_chapter[this.cur_page].role_id

		let config_companion = Config.PRELOAD_SERVER_CONFIG.config_companion
		let figure_id = config_companion[partner_id].figure_id
		let action_name_list = ["attack", "idle"]

		let data = {
			clothe_res_id: figure_id,
			type: UI_MODEL_TYPE.PARTNER,
			action_name_list: action_name_list,
			layout_file: "DungeonPartnerItem"
		}
		ResManager.GetInstance().SetRoleModel(this, this._box_model, data)
	}

	public UpdatePartnerInfo() {
		let config_partner_dun_chapter = Config.PRELOAD_SERVER_CONFIG.config_partner_dun_chapter
		let partner_id = config_partner_dun_chapter[this.cur_page].role_id
		let config_companion = Config.PRELOAD_SERVER_CONFIG.config_companion
		let cfg = config_companion[partner_id]
		this._lb_partner_name.text = config_companion[partner_id].name.trim()
		this._lb_pieces.text = ""
		let info = this.partner_model.GetInfoByID(partner_id)
		if (info) {
			if (1 == info.is_active) {
				this._lb_pieces.text = "已激活"
			} else {
				this._lb_pieces.text = this.goodsmodel.GetTypeGoodsNum(cfg.goods_id) + "/" + cfg.goods_num
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_box_partner_info: Laya.Box
	_img_bg2: Laya.Image
	_lb_partner_name: Laya.Label
	_lb_pieces: Laya.Label
	_box_model: Laya.Box
	_img_bg4: Laya.Image
	_img_monster_icon: Laya.Image
	_img_vs: Laya.Image
	_img_lock: Laya.Image
	_img_star1: Laya.Image
	_img_star2: Laya.Image
	_img_star3: Laya.Image
	_box_vs: Laya.Box
	_img_bg3: Laya.Image
	_lb_vs: Laya.Label
	_img_red: Laya.Image
	_lb_tips: Laya.Label
	_img_finish: Laya.Image
	_box_first_kill: Laya.Box
	_img_first_kill_bg: Laya.Image
	_img_first_kill: Laya.Image
	_lb_killer_name: Laya.Label
	_img_first_kill_red: Laya.Image
	_img_red2: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._box_partner_info,
			this._img_bg2,
			this._lb_partner_name,
			this._lb_pieces,
			this._box_model,
			this._img_bg4,
			this._img_monster_icon,
			this._img_vs,
			this._img_lock,
			this._img_star1,
			this._img_star2,
			this._img_star3,
			this._box_vs,
			this._img_bg3,
			this._lb_vs,
			this._img_red,
			this._lb_tips,
			this._img_finish,
			this._box_first_kill,
			this._img_first_kill_bg,
			this._img_first_kill,
			this._lb_killer_name,
			this._img_first_kill_red,
			this._img_red2
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_box_partner_info",
				"_img_bg2",
				"_lb_partner_name",
				"_lb_pieces",
				"_box_model",
				"_img_bg4",
				"_img_monster_icon",
				"_img_vs",
				"_img_lock",
				"_img_star1",
				"_img_star2",
				"_img_star3",
				"_box_vs",
				"_img_bg3",
				"_lb_vs",
				"_img_red",
				"_lb_tips",
				"_img_finish",
				"_box_first_kill",
				"_img_first_kill_bg",
				"_img_first_kill",
				"_lb_killer_name",
				"_img_first_kill_red",
				"_img_red2"
			])
	}
}
window["DungeonPartnerItem"] = DungeonPartnerItem
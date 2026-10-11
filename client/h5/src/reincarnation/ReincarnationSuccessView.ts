import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskModel } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"
import { RebirthSuccessAttrItem } from "./RebirthSuccessAttrItem"
import { RebirthSuccessEquieItem } from "./RebirthSuccessEquieItem"
import { RebirthSuccessSkillItem } from "./RebirthSuccessSkillItem"
import { DressEvent, DressModel } from "../commonModel/DressModel"

export class ReincarnationSuccessView extends BaseView1 {

	DeleteTween
	InitEvents
	LoadSuccess
	PlayAni
	SetMessage
	SetPropText
	SetSkillData
	SetWXShare

	canskill_gp
	cancombat_gp
	canrole_img
	public constructor() {
		super()
		this.base_file = "reincarnation"
		this.layout_file = "ReincarnationSuccessView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.click_bg_can_close_time = 6
		this.show_open_movie = true
		this.is_center = true
		let local_laya = Laya
		// let res_mgr = lua_resM
		let local_mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
		//let lcoal_friendModel = FriendInviteModel
		let PropTextList_ = null
		let skillItemList_ = null
		let attr_item_list_ = null
		let role_model_ = null
		let effect1_ = null
		let effect2_ = null
		let fashionList = null
		let timeout_list_ = []
		let wx_share_tips_ = null
		let res_mgr = ResManager.GetInstance()
		this.open_callback = () => {
			TaskModel.GetInstance().PauseAutoDoTask(true)
			this.InitEvents()
			this.SetWXShare()
			this.PlayAni()
		}
		this.preload_client_config = {
			"ClientReincarnationPos": false,
			"ClientRebirthEffect": false
		}

		this.load_callback = () => {
			this.canskill_gp = this.skill_gp
			this.cancombat_gp = this.combat_gp
			this.canrole_img = this.role_img
			this.turn_img.alpha = 0
			this.SetMessage()
			this.LoadSuccess()
			TaskModel.GetInstance().not_dotask = true
		}

		this.close_callback = () => {
			TaskModel.GetInstance().not_dotask = false
			TaskModel.GetInstance().PauseAutoDoTask(false)
			if (timeout_list_ && timeout_list_.length > 0) {
				let i = 0
				do {
					clearTimeout(timeout_list_[i])
					i = i + 1
				} while ((i < timeout_list_.length))
				timeout_list_ = []
			}
			this.DeleteTween()
			if (attr_item_list_) {
				for (let _tmpi in attr_item_list_) {
					var item = attr_item_list_[_tmpi]
					if (attr_item_list_) {
						item.DeleteMe()
					}
				}
				attr_item_list_ = null
			}
			GlobalEventSystem.Fire(EventName.DELAY_SHOW_FIGHTUP, false)
			DressModel.GetInstance().Fire(DressEvent.REINCARNATION_SUCCESS_VIEW_CLOSE)
		}

		this.destroy_callback = () => {
			this.canskill_gp = null
			this.cancombat_gp = null
			this.canrole_img = null
			// this.ClearUIEffect(this.effect_group)
			PropTextList_ = null
			if (skillItemList_) {
				for (let _tmpi in skillItemList_) {
					var skillItem = skillItemList_[_tmpi]
					if (skillItem) {
						skillItem.DeleteMe()
					}
				}
				skillItemList_ = null
			}
			if (wx_share_tips_) {
				wx_share_tips_.DeleteMe()
				wx_share_tips_ = null
			}
			if (fashionList) {
				for (let k in fashionList) {
					var vo = fashionList[k]
					vo.DeleteMe()
				}
				fashionList = null
			}
			this.ClearUIEffect(this.rebirth_effect_gp)
			this.ClearUIEffect(this.rebirth_effect_gp1)
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().LoadFont(this,"fighting_font",this.fight_lb,undefined,false)
			this.canskill_gp.alpha = 0
			this.cancombat_gp.alpha = 0
			this.skill_bg_img.scaleY = 0
			this._Scroller1.vScrollBarSkin = ""
			this._Scroller2.hScrollBarSkin = ""
			res_mgr.SetOutsideImageSprite(this, this.light_img, GameResPath.GetIcon("reincarnation", "uizscg_012"), true)
			res_mgr.SetOutsideImageSprite(this, this.skill_bg_img, GameResPath.GetIcon("reincarnation", "uizscg_008"))
			res_mgr.SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("reincarnation", "uizscg_001"), true)


			//let sex = local_mainRoleVo.sex
			let career = local_mainRoleVo.career
			let res = ""
			if (career == 1) {
				res = GameResPath.GetIcon("reincarnation", "uizscg_010c")
			} else if (career == 2) {
				res = GameResPath.GetIcon("reincarnation", "uizscg_011b")
			} else if (career == 3) {
				res = GameResPath.GetIcon("reincarnation", "uizscg_010")
			} else if (career == 4) {
				res = GameResPath.GetIcon("reincarnation", "uizscg_011")
			}
			res_mgr.SetOutsideImageSprite(this, this.role_img, res, true)

		}

		this.InitEvents = () => {
			//this:BindEvent(lcoal_friendModel.GetInstance(), lcoal_friendModel.GET_WX_SHARE_REWARD_SUCCESS,() => {
			//this:Close()
			//}
			//)
			Util.AddClickEvent(this.click_bg, () => {
				this.Close()
			}, this, false)
		}

		this.SetMessage = () => {
			// local_mainRoleVo.turn = 6
			let cfg = res_mgr.GetGameConfigFromCache(this, "ClientRebirthEffect", true)
			let rebirth_cfg = cfg[local_mainRoleVo.turn + "@" + local_mainRoleVo.career]
			if (!rebirth_cfg) {
				Message.show("没有转职配置")
				return
			}
			this.fight_lb.text = rebirth_cfg.combot
			let reinCfg = Config.PRELOAD_SERVER_CONFIG.config_reincarnation_cfg
			effect1_ = rebirth_cfg.rebirth1
			effect2_ = rebirth_cfg.rebirth2
			if (reinCfg) {
				let curCfg = reinCfg[local_mainRoleVo.career + "@" + local_mainRoleVo.sex + "@" + local_mainRoleVo.turn]
				let after_cfg = reinCfg[local_mainRoleVo.career + "@" + local_mainRoleVo.sex + "@" + (local_mainRoleVo.turn - 1)]
				//this.turn_img.skin = GameResPath.GetIcon("reincarnation", `turn__success_${local_mainRoleVo.turn}`)
				res_mgr.SetOutsideImageSprite(this, this.turn_img, GameResPath.GetIcon("reincarnation", `turn__success_${local_mainRoleVo.turn}`), true)
				if (curCfg) {
					if (after_cfg.attr) {
						this.SetPropText(JSON.parse(after_cfg.attr), JSON.parse(curCfg.attr))
					} else {
						this.SetPropText(0, JSON.parse(curCfg.attr))
					}
					if (!skillItemList_) {
						skillItemList_ = []
					}
					let skill_info = JSON.parse(curCfg.turn_skill)
					if (skill_info && skill_info.length > 0) {
						let i = 0
						if (i < skill_info.length) {
							do {
								let skill_res = cfg[local_mainRoleVo.turn + "@" + local_mainRoleVo.career].skill_res
								if ((skill_res && skill_res[Number(skill_info[i][0])])) {
									let skillItem = skillItemList_[i]
									if (!skillItem) {
										skillItem = new RebirthSuccessSkillItem(this.skillCon)
										skillItem.Load()
										skillItemList_[i] = skillItem
									}
									skillItem.SetData(true, skill_info[i])
								}
								i = i + 1
							} while ((i < skill_info.length))
						}
						this.skillCon.visible = true
					}
					if (skillItemList_.length <= 0) {
						this.skillCon.removeSelf()
						this.Content1.refresh()
					}
					let _picture_resource = DressModel.GetInstance().getHeadICon(Number(curCfg.icon))
					if (_picture_resource) {
						this.headCon.visible = true
						// this.headImg.skin = GameResPath.GetHeadPath(picture_cfg.resource)
						res_mgr.SetImageSpriteTrans(this, this.headImg, GameResPath.GetIcon("head", _picture_resource))
					}
					let rein_pos_cfg = res_mgr.GetGameConfigFromCache(this, "ClientReincarnationPos", true)
					let pos_cfg = rein_pos_cfg[local_mainRoleVo.turn]
					if (pos_cfg) {
						if (!fashionList) {
							fashionList = []
						}
						this.fashionCon.visible = true
						let fashionUnlock = pos_cfg.fashionUnlock
						if (fashionUnlock && fashionUnlock.length > 0) {
							for (let k in fashionUnlock) {
								var vo = fashionUnlock[k]
								let item = new RebirthSuccessEquieItem(this.fashionCon)
								item.Load()
								item.SetData(vo)
								//item:SetScale(0.8)
								//item:SetMaskId(1)
								table.insert(fashionList, item)
							}
						}
						let equipUnlock = pos_cfg.equipUnlock
						if (equipUnlock && equipUnlock.length > 0) {
							for (let k in equipUnlock) {
								var vo = equipUnlock[k]
								let equipData = GoodsModel.GetInstance().GetGoodsBasicByTypeId(vo)
								if (!equipData || (equipData.career_id != 0 && equipData.career_id != local_mainRoleVo.career) || (equipData.sex != 0 && equipData.sex != local_mainRoleVo.sex)) {
								} else {
									let item = new RebirthSuccessEquieItem(this.fashionCon)
									item.Load()
									item.SetData(vo)
									//item:SetScale(0.8)
									//item:SetMaskId(1)
									table.insert(fashionList, item)
								}
							}
						}
						this.fashionCon.refresh()
						this.Content1.refresh()
					}
				}
			}
		}

		this.PlayAni = () => {
			this.DeleteTween()
			//local_laya.Tween.get(this.role_img).to({horizontalCenter=0, y=82, alpha=1}, 300)
			SYTweenLite.to(this, this.role_img, SYTweenLite.UiAnimationType.CENTER_POSX, 50, 0.3)
			SYTweenLite.to(this, this.role_img, SYTweenLite.UiAnimationType.ANCHORED_POSY, 129, 0.3)
			SYTweenLite.to(this, this.canrole_img, SYTweenLite.UiAnimationType.ALPHA, 1, 0.3)
			SYTweenLite.to(this, this.light_img, SYTweenLite.UiAnimationType.ANCHORED_POSX, 0, 0)
			SYTweenLite.to(this, this.light_img, SYTweenLite.UiAnimationType.ANCHORED_POSY, 140, 0.3, () => {
				// this.AddUIEffect("uizs_012", this.light_effect_gp, null, { "x": 1, "y": 2 }, true)
				SYTweenLite.to(this, this.skill_bg_img, SYTweenLite.UiAnimationType.SCALE, { "x": 1, "y": 1 }, 0.3, () => {
				let i = 0
				let tmp_index = 0
				if (i < attr_item_list_.length) {
					do {
						let index = i
						timeout_list_[i] = setTimeout(() => {
							if (!attr_item_list_ || !attr_item_list_[tmp_index]) {
								return
							}
							if (this, attr_item_list_[tmp_index] && this, attr_item_list_[tmp_index].display_obj){
								SYTweenLite.to(this, attr_item_list_[tmp_index].display_obj, SYTweenLite.UiAnimationType.ALPHA, 1, 0.25, () => {
									if (tmp_index == attr_item_list_.length) {
										SYTweenLite.to(this, this.canskill_gp, SYTweenLite.UiAnimationType.ALPHA, 1, 0.8, () => {
											if (this.close_gp) {
												this.close_gp.visible = true
											}
											if (!this.combat_gp) {
												return
											}
											SYTweenLite.to(this, this.combat_gp, SYTweenLite.UiAnimationType.ANCHORED_POSX, 315, 0.5)
											SYTweenLite.to(this, this.turn_img, SYTweenLite.UiAnimationType.ANCHORED_POSX, 200, 0.5)
											SYTweenLite.to(this, this.turn_img, SYTweenLite.UiAnimationType.ALPHA, 1, 0.3)
											SYTweenLite.to(this, this.cancombat_gp, SYTweenLite.UiAnimationType.ALPHA, 1, 0.5, () => {
												if (!this.rebirth_effect_gp || !this.rebirth_effect_gp1) {
													return
												}
												this.AddUIEffect(effect1_, this.rebirth_effect_gp, null, 1, null)
											})
										})
									}
	
								})
							}
							tmp_index++
						}, 500 * i)
						i = i + 1
					} while ((i < attr_item_list_.length))
				}
				})
			})
		}

		this.DeleteTween = () => {
			//local_laya.Tween.removeTweens(this.role_img)
			//local_laya.Tween.removeTweens(this.light_img)
			//local_laya.Tween.removeTweens(this.skill_bg_img)
			//let i = 0
			//do {
			//if (! attr_item_list_[i] ) {
			//break
			//}
			//local_laya.Tween.removeTweens(attr_item_list_[i])
			//i=i+1
			//} while ((i < attr_item_list_.length))
			//local_laya.Tween.removeTweens(this.skillGroup)
			//local_laya.Tween.removeTweens(this.combat_gp)
			//local_laya.Tween.removeTweens(this.rebirth_effect_gp)
		}

		this.SetPropText = (after_attr?, propVo?) => {
			if (propVo) {
				if (!attr_item_list_) {
					attr_item_list_ = []
				}
				let i = 0
				do {
					let attr_item = attr_item_list_[i]
					if (!attr_item) {
						attr_item = new RebirthSuccessAttrItem(this.Content)
						attr_item.Load()
						//attr_item.scaleY = 0.75
						//attr_item.scaleX = attr_item.scaleY
						// attr_item.SetScale(0.75)
						attr_item_list_[i] = attr_item
					}
					if (after_attr.length == 0) {
						attr_item.SetData({ "attr_id": 0, "attr_val": 0 }, { "attr_id": propVo[i][0], "attr_val": propVo[i][1] })
					} else {
						attr_item.SetData({ "attr_id": after_attr[i][0], attr_val: after_attr[i][1] }, { attr_id: propVo[i][0], attr_val: propVo[i][1] })
					}
					i = i + 1
				} while ((i < propVo.length))
			}
		}

		this.SetSkillData = (skillVo?) => {//, is_skill, skillVo

		}

		this.SetWXShare = () => {
			//let call_back = (show?) => {
			//this.wx_share_con.visible = show
			//if (this.wx_share_con.visible ) {
			//if (! wx_share_tips_ ) {
			//wx_share_tips_ =  new WXShareTips(this.wx_share_con)
			//wx_share_tips_:Load()
			//}
			//}
			//}

			//lcoal_friendModel:GetInstance():ShowWXShare(call_back)
		}
	}

	click_bg: Laya.Box
	wx_share_con: Laya.Box
	light_img: Laya.Image
	light_effect_gp: Laya.Box
	role_img: Laya.Image
	skill_bg_img: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	combat_gp: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	fight_lb: Laya.Label
	close_gp: Laya.Box
	_Image4: Laya.Image
	tipstext: Laya.Label
	_Image5: Laya.Image
	skill_gp: Laya.Box
	Text11: Laya.Label
	skill_title_img: Laya.Image
	_Scroller2: Laya.Panel
	Content1: Laya.HBox
	skillCon: Laya.HBox
	headCon: Laya.Box
	headImg: Laya.Image
	fashionCon: Laya.HBox
	rebirth_effect_gp: Laya.Box
	rebirth_effect_gp1: Laya.Box
	turn_img: Laya.Image
	public GetComponents() {
		[
			this.click_bg,
			this.wx_share_con,
			this.light_img,
			this.light_effect_gp,
			this.role_img,
			this.skill_bg_img,
			this._Scroller1,
			this.Content,
			this.combat_gp,
			this._Image1,
			this._Image2,
			this._Image3,
			this.fight_lb,
			this.close_gp,
			this._Image4,
			this.tipstext,
			this._Image5,
			this.skill_gp,
			this.Text11,
			this.skill_title_img,
			this._Scroller2,
			this.Content1,
			this.skillCon,
			this.headCon,
			this.headImg,
			this.fashionCon,
			this.rebirth_effect_gp,
			this.rebirth_effect_gp1,
			this.turn_img,
		]
			= this.GetChildrenByNames([

				"click_bg",
				"wx_share_con",
				"light_img",
				"light_effect_gp",
				"role_img",
				"skill_bg_img",
				"_Scroller1",
				"Content",
				"combat_gp",
				"_Image1",
				"_Image2",
				"_Image3",
				"fight_lb",
				"close_gp",
				"_Image4",
				"tipstext",
				"_Image5",
				"skill_gp",
				"Text11",
				"skill_title_img",
				"_Scroller2",
				"Content1",
				"skillCon",
				"headCon",
				"headImg",
				"fashionCon",
				"rebirth_effect_gp",
				"rebirth_effect_gp1",
				"turn_img",
			])
	}
}
window["ReincarnationSuccessView"] = ReincarnationSuccessView
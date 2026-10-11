import { BaseItem1 } from "../common/BaseItem1"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { ArenaModel } from "../commonModel/ArenaModel"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import { RankModelEvent, RankModel, RANK_CONFIG } from "../commonModel/RankModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { ModelPartPos } from "../sharedata/RoleVo"
import { GameResPath } from "../util/GameResPath"
import { Util, SetSizeDelta, SetSizeDeltaX, SetLocalScaleX, SetLocalScaleY, RefBoxChildsLayout } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { RankItem } from "./RankItem"
import { RankTabButton } from "./RankTabButton"
import { Config } from "../common/Config"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { WordManager } from "../common/WordManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { MedalModel } from "../commonModel/MedalModel"

export class RankView extends BaseItem1 {


	CreateModel
	CustomMehod
	InitEvent
	LoadSuccess
	ReOpen_callback
	ShowModel
	Viewport
	checkMenu
	initItem
	initTab
	item_loop_mgr
	lastIndex
	init_select_tab = -1
	selectTab
	setTitle
	tabTouchHandler
	tab_loop_mgr
	touchHandler
	vo
	my_head_item
	cur_touxian_id

	public constructor(parent?) {
		super(parent)

		this.base_file = "rank"
		this.layout_file = "RankView"
		this.selectTab = 1
		let _item_line = null
		let role_model = null
		let firstInfo = null
		let local_RankModelEvent = RankModelEvent
		let local_ResManager = ResManager.GetInstance()
		let local_RankModel = RankModel
		let local_FriendEvent = FriendEvent
		let arena_model = ArenaModel.GetInstance()
		let _model = RankModel.GetInstance()
		this.preload_server_config = { "config_title_cfg": false }
		let select_First = true

		this.ReOpen_callback = () => {
			this.CreateModel(this.vo)
		}

		this.load_callback = () => {
			this.cur_touxian_id = 0
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			this.BindEvent(_model, local_RankModelEvent.RANK_DATA_UPDATE, () => {
				this.initItem()
			}
			)
			//_model:requestRankData(this.selectTab, 1)

			Util.AddClickEvent(this._info_group, (target?, x?, y?) => {
				let point = new Laya.Point(this.display_obj.mouseX, this.display_obj.mouseY)
				this.display_obj.localToGlobal(point)
				this.touchHandler(point.x, point.y)
			}, this)

			let return_callBack = (id?) => {
				this.checkMenu(id)
			}
			this.BindEvent(FriendModel.GetInstance(), local_FriendEvent.MENU_DATA_UPDTE, return_callBack)
			_model.requestRankData(this.selectTab)
		}



		this.LoadSuccess = () => {
			// this.RegisterMask(this.Viewport)
			local_ResManager.SetOutsideImageSprite(this, this._bottom_bg, GameResPath.GetIcon("rank", "bg_07"))
			local_ResManager.SetTexture(this, this.mainrole_bg, GameResPath.GetIcon("rank", "ui_kdb_11"))
			// local_ResManager.SetOutsideImageSprite(this, this._stage, GameResPath.GetIcon("rank", "uikf1vn_002"))
			local_ResManager.SetOutsideImageSprite(this, this._bottom_left_bg, GameResPath.GetIcon("rank", "bg_54"))
			// local_ResManager.SetOutsideImageSprite(this, this._img_right_bg, GameResPath.GetIcon("rank", "uiphb_003"))
			// local_ResManager.SetOutsideImageSprite(this, this._item_line, GameResPath.GetIcon("rank", "rank_line"))
			this.initTab()
		}

		this.initTab = () => {
			let tabdata = _model.spiritTabDataList()
			this.tab_loop_mgr = new LoopScrowViewMgr()
			this.tab_loop_mgr.SetData(this.tabScroller, RankTabButton, tabdata, LoopScrCon.Vertical, 1, () => {
				this.tabTouchHandler()
			})//, { not_first_call: true })
			this.tab_loop_mgr.FirstOnChild(this.selectTab)
			this.tab_loop_mgr.SetSelectIndex(this.selectTab)
			this.setTitle()
			this.init_select_tab = 0
		}

		this.initItem = () => {
			let data = _model.getRankDate(this.rankType())
			if (!data) {
				return
			}

			//初始化
			for (let i = 0; i < this._Group3.numChildren; i++) {
				let cell: any = this._Group3.getChildAt(i)
				if (cell) cell.visible = false
			}


			let type = data.rank_type
			_model.rank_type = type
			let rankList = _model.getRankList(data.rank_list, this.selectTab)

			//this._info_group.visible = data.rank_list[0].player_id != 0
			let is_show_data = data.rank_list[0].player_id != 0
			this._fight_bg.visible = this._Group5.visible = is_show_data
			this._null_label.visible = !is_show_data
			this._rank_Icon.visible = true

			//是否清理特效

			let config_medal = RankModel.GetInstance().config[RANK_CONFIG.MEDAL]//local_ResManager.GetGameConfigFromCache(this, "Medal", false)
			if (is_show_data) {
				firstInfo = data.rank_list[0]
				let is_show_title = (config_medal && firstInfo.medal_id > 1 || firstInfo.title_id > 0)

				if (firstInfo.title_id > 0 && firstInfo.title_id != this.cur_touxian_id) {
					this.ClearUIEffect(this.title_effect_gp)
				}



				if (is_show_title) {
					if (firstInfo.title_id > 0) {
						this._img_medal.visible = false
						if (firstInfo.title_id != this.cur_touxian_id) {
							let title_id = firstInfo.title_id
							let title_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientTitleNameBordWidth[title_id]
							let config_title_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_title_cfg", false)
							let cfg = config_title_cfg && config_title_cfg[title_id + "@0"]
							if (cfg && title_cfg) {

								let eff_id = title_id - 1000
								let pos
								let scale = 8
								let w = title_cfg.width
								if (title_cfg) {
									if (eff_id <= 5) {
										pos = { x: -2, y: 0 }
									} else {
										pos = { x: 0, y: 0 }
									}
									scale = title_cfg.scale
								}
								SetSizeDelta(this.title_effect_gp, eff_id <= 5 ? w - 8 : w, title_cfg.height)
								let eff_url = MedalModel.GetInstance().GetTitleEffetName(eff_id)
								this.title_effect_gp.visible = true
								this.cur_touxian_id = firstInfo.title_id
								this.AddUIEffect(eff_url, this.title_effect_gp, pos, scale, true)
							}
						} else {
							this.title_effect_gp.visible = true
						}


					} else {
						this.title_effect_gp.visible = false
						let cfg = config_medal[firstInfo.medal_id]
						if (cfg) {
							this._img_medal.visible = true
							ResManager.GetInstance().SetImageSprite(this, this._img_medal, "mainUI_asset", "tx_" + cfg.title + "", true)
						}
					}
				}
				let lv = firstInfo.level > 370 && firstInfo.level - 370 || firstInfo.level
				this._name_label.visible = true
				this._name_label.text = firstInfo.name

				this._turn_label.visible = true
				this._turn_label.text = firstInfo.turn > 0 && "【" + firstInfo.turn + "转】" || ""


				//等级
				this._lv_label.text = lv + "级"
				this.destiny_img.visible = firstInfo.level > 370
				this._lv_label.x = firstInfo.level > 370 ? 24 : 0;
				this._box_lv.visible = true
				if (firstInfo.level > 370) {
					this._box_lv.width = this._lv_label.textField.textWidth + this.destiny_img.width
				} else {
					this._box_lv.width = this._lv_label.textField.textWidth
				}


				let fight = ""
				if (type == local_RankModel.RANK_TYPE.FIGHT) {
					// this._Group4.visible=true
					// this._Group41.visible=false
					this._fight_label.text = firstInfo.first_value
					// }else{
					// 	this._Group41.visible=true
					// 	this._Group4.visible=false
				}
				if (type == local_RankModel.RANK_TYPE.NOBILITY) {
					fight = firstInfo.achv_lv
				} else if (type == local_RankModel.RANK_TYPE.ONHOOK) {
					fight = WordManager.ConvertNum(firstInfo.first_value, true) + "/分"
				} else if (type == local_RankModel.RANK_TYPE.LEVEL) {
					this.first_destiny_img.visible = firstInfo.first_value > 370 ? true : false
					let lv = firstInfo.first_value > 370 && firstInfo.first_value - 370 || firstInfo.first_value
					fight = type == RankModel.RANK_TYPE.LEVEL && lv + "级" || firstInfo.first_value
					// fight = firstInfo.first_value
				} else {
					fight = firstInfo.first_value
				}
				let fightTitle = _model.getNameByType(type)
				this._fight_name.text = fightTitle + ":"
				this._fight_label.text = fight
				let vip_Lv = firstInfo.vip_flag
				let is_hide_vip = firstInfo.is_hide_vip
				this._vip_icon.visible = vip_Lv > 0
				if (this._vip_icon.visible) {
					if(is_hide_vip > 0){
						if (firstInfo.supreme_vip > 0) {
							ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", "SVIP-x", true)
						} else {
							ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", "VIP-x", true)
						}
					}
					else{
						if (firstInfo.supreme_vip > 0) {
							ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", "VIP_" + vip_Lv + "", true)
						} else {
							ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", "uivip_zjm_" + vip_Lv + "", true)
						}
					}
				
				}
				this.ShowModel(true)
				this.vo = firstInfo
				this.CreateModel(firstInfo)
			} else {
				this.cur_touxian_id = 0
				this.ShowModel(false)
			}
			this._rank_title_label.text = type == local_RankModel.RANK_TYPE.GUILD && "我的结社排名:" || "我的排名:"
			this._rank_label.text = _model.getRank(data, this.selectTab)
			// if (PlatformMgr.GetInstance().IsEyouThPlatform() ) {
			// 	this._value_title_label.text = _model.getNameByType(type) + "ของฉัน" + ":"
			// }else{
			this._value_title_label.text = "我的" + _model.getNameByType(type) + ":"
			// }
			let str = ""
			if (type == local_RankModel.RANK_TYPE.FIGHT) {
				// this._Group7.visible=true
				// this._Group71.visible=false
				str = data.sel_val
				// }else{
				// 	this._Group7.visible=false
				// 	this._Group71.visible=true
			} else if (type == local_RankModel.RANK_TYPE.GUILD) {
				str = _model.guildValue(data.role_rank)
			} else if (type == local_RankModel.RANK_TYPE.NOBILITY) {
				str = data.sel_val
			} else if (type == local_RankModel.RANK_TYPE.ONHOOK) {
				str = WordManager.ConvertNum(data.sel_val, true) + "/分"
			} else if (type == local_RankModel.RANK_TYPE.LEVEL) {
				let lv = data.sel_val > 370 && data.sel_val - 370 || data.sel_val
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
				// 	str = "Lv." + lv
				// }else{
				str = lv + "级"
				// }
			} else {
				str = data.sel_val == 0 && "未上榜" || data.sel_val
			}
			SetSizeDeltaX(this.my_destiny_img, (type == local_RankModel.RANK_TYPE.LEVEL && data.sel_val > 370) && 23 || 0)
			this._my_fight_label.text = str
			let flag = this._info_group.visible && _model.likeTime() > 0

			if (!this.item_loop_mgr) {
				this.item_loop_mgr = new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this.itemScroller, RankItem, rankList, LoopScrCon.Vertical, 1,)
			} else {
				this.item_loop_mgr.replaceAll(rankList)
			}

			if (select_First) {
				select_First = false
				this.item_loop_mgr.FirstOnChild(0)
			}
			if (!this.my_head_item) {
				this.my_head_item = new CustomHeadItem(this.my_head)
				this.my_head_item.SetActiveLevel(false)
				this.my_head_item.SetActiveBg(false)
				this.my_head_item.Load()
				this.my_head_item.ExcuteCallback(() => {
					this.my_head_item.SetScale(0.8)
					let role_info = RoleManager.GetInstance().GetMainRoleVo()
					this.my_head_item.SetRoleVoData(role_info)
				})
			}

			RefBoxChildsLayout(this._Group3, 8, null, true, "center")
		}

		this.CreateModel = (vo?) => {
			if (this.lastIndex == this.selectTab) {
				return
			}
			this.lastIndex = this.selectTab
			let mainvo = RoleManager.GetInstance().GetMainRoleVo()
			let [head_id, head_texture_id] = Util.GetRoleHeadId(vo)
			let [role_res, role_color] = Util.GetRoleClotheId(vo)
			let weapon_res = Util.GetWeaponClotheId(vo)
			let wing_res = Util.GetWingClotheId(vo)//mainvo.GetFigureId(vo.figure_list, FigureProtoVo.FigureType.Wing)
			let horse_res = ArenaModel.GetInstance().GetFigureId(vo.figure_list, FigureProtoVo.FigureType.Horse)
			let back_ornament_res = Util.GetBackOrnamentId(vo)
			let liveness_id = Util.GetLivenessId(vo)
			let data = null
			if (horse_res && horse_res > 0 && _model.rank_type == local_RankModel.RANK_TYPE.HORSE) {
				data = {
					clothe_res_id: horse_res,
					res_id: horse_res,
					texture_id: horse_res,
					type: UI_MODEL_TYPE.HORSE,
					can_rotate: true,
					layer_value: Enum_UILayer.UI,
					// texture_size: new Vector2(400, 350),
					rotate: 225,
					position: new Vector3(0, 0.8, 0),
					action_name_list: ["show"],
					scale: 0.5,
					back_ornament_id: back_ornament_res,
				}
			} else {
				data = {
					career: vo.career,
					sex: vo.sex,
					type: UI_MODEL_TYPE.ROLE,//SceneBaseType.Role,
					layer_value: Enum_UILayer.UI,
					clothe_res_id: role_res,
					fashion_model_id: role_res,
					texture_id: role_color,
					head_wear_id: head_id,
					head_clothe_id: head_texture_id,
					weapon_res_id: weapon_res,
					// weapon_clothe_id: weapon_clothe_id,
					wing_id: wing_res,
					horse_id: horse_res,
					position: new Vector3(0, 0.8, 0),
					scale: 0.9,
					back_ornament_id: back_ornament_res,
					liveness_id: liveness_id
				}
			}

			if (data) {
				ResManager.GetInstance().SetRoleModel(this, this._model_group, data)
			}
		}

		this.setTitle = () => {
			if (this.selectTab) return
			this.ClearUIEffect(this._gp_title)
			let spiritTabDataList = _model.spiritTabDataList()
			let info = spiritTabDataList[this.selectTab]
			let dsgt_info_list = ResManager.GetInstance().GetGameConfigFromCache(this, "Dsgt", false)
			this._gp_title.visible = info.title_id > 0
			this._title_img.visible = false
			if (this._gp_title.visible) {
				let dsgt = dsgt_info_list[info.title_id]
				if (dsgt.type == 1) {
					// this.AddUIEffect(dsgt.resource_id, Enum_UILayer.Activity , this._gp_title, null, null, true)
				} else {
					this._title_img.visible = true
					let url = "client/assets/icon/dsgtIcon/" + dsgt.resource_id + ".png"
					local_ResManager.SetOutsideImageSprite(this, this._title_img, url, true)
				}
			}
		}

		this.tabTouchHandler = () => {
			if (this.init_select_tab == -1) {
				return
			}
			if (this.selectTab == this.tabScroller.selectedIndex) {
				return
			}
			select_First = true
			this.selectTab = this.tabScroller.selectedIndex
			_model.requestRankData(this.selectTab)
			this.setTitle()
		}

		this.touchHandler = (x?, y?) => {
			if (firstInfo) {
				let type = _model.rank_type
				let role_id = type == local_RankModel.RANK_TYPE.GUILD && firstInfo.chairman_id || firstInfo.player_id
				FriendModel.GetInstance().Fire(local_FriendEvent.REQUEST_MENU_DATA, role_id, x, y)
			}
		}

		this.checkMenu = (id?) => {
			let type = _model.rank_type
			if (firstInfo) {
				let role_id = type == local_RankModel.RANK_TYPE.GUILD && firstInfo.chairman_id || firstInfo.player_id
				if (id != role_id || id == RoleManager.GetInstance().GetMainRoleId()) {
					return
				}
				let data = FriendModel.GetInstance().getMenuData(role_id)
				let isPicture = Number(firstInfo.picture) == role_id
				_model.Fire(local_RankModelEvent.OPEN_MENU_VIEW, data.point, role_id, null, null, isPicture)
			}
		}

		this.ShowModel = (bool?) => {
			if (this._model_group.visible != bool) {
				this._model_group.visible = bool
			}
		}



		this.CustomMehod = (index?, args?) => {
			this.selectTab = args && args[0]
			_model.requestRankData(this.selectTab)
		}
	}

	public DeleteMe() {
		this.ClearUIEffect(this.title_effect_gp)
		if (this.tab_loop_mgr) {
			this.tab_loop_mgr.DeleteMe()
			this.tab_loop_mgr = null
		}
		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = null
		}
		if (this.my_head_item) {
			this.my_head_item.DeleteMe()
			this.my_head_item = null
		}
		super.DeleteMe()
	}

	public rankType() {

		let spiritTabDataList = RankModel.GetInstance().spiritTabDataList()
		return spiritTabDataList[this.selectTab].type
	}


	_stage: Laya.Image
	_model_group: Laya.Box
	_title_img: Laya.Image
	_gp_title: Laya.Box
	_Group1: Laya.Box
	_img_left_bg: Laya.Image
	_img_right_bg: Laya.Image
	_bottom_bg: Laya.Image
	_bottom_left_bg: Laya.Image
	itemScroller: Laya.List
	_info_group: Laya.Box
	img_name_bg: Laya.Image
	_fight_bg: Laya.Image
	_Group3: Laya.Box
	_rank_Icon: Laya.Image
	_vip_icon: Laya.Image
	title_effect_gp: Laya.Box
	_img_medal: Laya.Image
	_turn_label: Laya.Label
	_box_lv: Laya.Box
	destiny_img: Laya.Image
	_lv_label: Laya.Label
	_name_label: Laya.Label
	_null_label: Laya.Label
	_Group5: Laya.Box
	_Group41: Laya.HBox
	_fight_name: Laya.Label
	first_destiny_img: Laya.Image
	_fight_label: Laya.Label
	mainrole_bg: Laya.Image
	_Group6: Laya.HBox
	_rank_title_label: Laya.Label
	_rank_label: Laya.Label
	_Group8: Laya.Box
	_Group71: Laya.HBox
	_value_title_label: Laya.Label
	my_destiny_img: Laya.Image
	_my_fight_label: Laya.Label
	my_head: Laya.Box
	tabScroller: Laya.List
	_item_line: Laya.Image
	_Image1: Laya.Image
	public GetComponents() {
		[
			this._stage,
			this._model_group,
			this._title_img,
			this._gp_title,
			this._Group1,
			this._img_left_bg,
			this._img_right_bg,
			this._bottom_bg,
			this._bottom_left_bg,
			this.itemScroller,
			this._info_group,
			this.img_name_bg,
			this._fight_bg,
			this._Group3,
			this._rank_Icon,
			this._vip_icon,
			this.title_effect_gp,
			this._img_medal,
			this._turn_label,
			this._box_lv,
			this.destiny_img,
			this._lv_label,
			this._name_label,
			this._null_label,
			this._Group5,
			this._Group41,
			this._fight_name,
			this.first_destiny_img,
			this._fight_label,
			this.mainrole_bg,
			this._Group6,
			this._rank_title_label,
			this._rank_label,
			this._Group8,
			this._Group71,
			this._value_title_label,
			this.my_destiny_img,
			this._my_fight_label,
			this.my_head,
			this.tabScroller,
			this._item_line,
			this._Image1,
		]
			= this.GetChildrenByNames([

				"_stage",
				"_model_group",
				"_title_img",
				"_gp_title",
				"_Group1",
				"_img_left_bg",
				"_img_right_bg",
				"_bottom_bg",
				"_bottom_left_bg",
				"itemScroller",
				"_info_group",
				"img_name_bg",
				"_fight_bg",
				"_Group3",
				"_rank_Icon",
				"_vip_icon",
				"title_effect_gp",
				"_img_medal",
				"_turn_label",
				"_box_lv",
				"destiny_img",
				"_lv_label",
				"_name_label",
				"_null_label",
				"_Group5",
				"_Group41",
				"_fight_name",
				"first_destiny_img",
				"_fight_label",
				"mainrole_bg",
				"_Group6",
				"_rank_title_label",
				"_rank_label",
				"_Group8",
				"_Group71",
				"_value_title_label",
				"my_destiny_img",
				"_my_fight_label",
				"my_head",
				"tabScroller",
				"_item_line",
				"_Image1",
			])
	}
}
window["RankView"] = RankView
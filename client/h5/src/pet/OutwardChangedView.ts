import { BaseView1 } from "../common/BaseView1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { DragonBallModel } from "../commonModel/DragonBallModel"
import { DressModel } from "../commonModel/DressModel"
import { DsgtModel } from "../commonModel/DsgtModel"
import { FunctionOpenEvent, FunctionOpenModel } from "../commonModel/FunctionOpenModel"
import { MainFunc, MainUIModel } from "../commonModel/MainUIModel"
import { MarriageModel } from "../commonModel/MarriageModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { RevelationEvent, RevelationModel } from "../commonModel/RevelationModel"
import { RoleManager } from "../commonModel/RoleManager"
import { TaskTipType } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util, Trim, GlobalTimerQuest, RefBoxChildsLayout } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"

export class OutwardChangedView extends BaseView1 {
	InitCfg
	InitEvents
	InitView
	SetModel
	Local_Open
	private tween_id_: number = 0;
	private UseModel: Function;
	private SetBabyModel: Function;
	private StartTimer: Function;
	private StopTimer: Function;
	private SetBtnText: Function;
	private SetSuit: Function;
	DragonBall
	private MarriageRing: Function;
	private Revelation: Function;
	private timeId: number = 0;
	private curTime: number = 0;

	public constructor() {
		super()

		this.base_file = "pet"
		this.layout_file = "OutwardChangedView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.background_alpha = 1
		this.append_to_ctl_queue = true;
		this.back_login_toClose = true;
		this.click_bg_toClose = true
		// this.hide_main_ui_finger = true
		let local_mainRoleVo = RoleManager.GetInstance().GetMainRoleVo()
		let local_resMgr = ResManager.GetInstance()
		//let local_friendInvModelIns = FriendInviteModel.GetInstance()
		let local_outwardModelIns = OutWardBaseModel.GetInstance()
		let local_UI_MODEL_TYPE = UI_MODEL_TYPE
		let data_
		let outward_action_cfg_
		let client_pos_cfg_
		//0表示培养的 1 表示幻化的
		let type_
		let roleModel_
		let wx_share_tips_
		let list = [TaskTipType.TrainPartner, TaskTipType.TrainMount]

		let has_hide_return = false //是否有隐藏主界面的返回指引

		this.preload_client_config = {
			"ClientOutWardModel": false,
			"ClientOutWardPos": false,
			"ClientMagicArray": false,
			"ClientFashionActivePos": false,
			"ClientGuBaoPos": false,
			"ClientBaby": false
		}

		this.preload_server_config = {
			"config_temple_awaken_suit": false,
			"config_temple_awaken": false,
			"config_temple_awaken_kv": false,
			"config_baby_figure": false,
			"config_ring_stage": false
		}

		this.load_callback = () => {
			this.InitCfg()
			this.InitEvents()

			GlobalEventSystem.Fire(EventName.STORY_SHOW_ALL_FINGER, false)


			for (let i = 0; i < list.length; i++) {
				let step = this.story_model.GetTaskStep(list[i])
				if (step == 1) {
					has_hide_return = true
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
					let step1 = { "direction": 8, "text": "点击这里可以快捷设置<font color='#0a9f42'>新形象</font>", "effect_scaleX": 0.9, "effect_scaleY": 0.9 }
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.btnUse, "UI", null, null, null, null, step1, true,null,true)
					break;
				}
			}


		}

		this.open_callback = () => {
			SoundManager.GetInstance().PlaySoundEffect("double_box")
			this.task_model.PauseAutoDoTask(true)
			this.InitView()
		}

		this.close_callback = () => {
			GlobalEventSystem.Fire(EventName.STORY_SHOW_ALL_FINGER, true)
			if (has_hide_return) {
				has_hide_return = false
				this.story_model.curr_view_story_step = 2
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return, undefined, null, null, undefined, undefined, null, true)
			}
			



			let target_pos

			if (type_ == 286) {
				RevelationModel.GetInstance().Fire(RevelationEvent.OPEN_VIEW, "RevelationActiveView", { star: data_.id - 1, num: 10 })
			}

			if (type_ == 0 && data_.stage == 1 && (data_.type_id == enum_OutWardType.Artifact || data_.type_id == enum_OutWardType.Wings || data_.type_id == enum_OutWardType.HolyDevice || data_.type_id == enum_OutWardType.Horse || data_.type_id == enum_OutWardType.BackOrnament)) {
				let icon = 1002
				let target = MainFunc.Role
				switch (data_.type_id) {
					case enum_OutWardType.Horse:
						target = MainFunc.Pet
						icon = 1005
						break;
					case enum_OutWardType.Wings:
						icon = 1003
						break;
					case enum_OutWardType.HolyDevice:
						icon = 1004
						break;
					case enum_OutWardType.BackOrnament:
						icon = 1006
						break;
				}
				target_pos = MainUIModel.GetInstance().GetIconPosInMainUIView(2, target, { x: 20, y: 0 }, { x: 20, y: 1 })
				let pos = this.outward_img.localToGlobal(new Laya.Point(0, 0))
				FunctionOpenModel.GetInstance().Fire(FunctionOpenEvent.FUNCTIONOPEN_ICON_FLY, icon, 1, pos, target_pos, () => {
					this.task_model.PauseAutoDoTask(false)
				}, false)
			}
			else {
				this.task_model.PauseAutoDoTask(false)
			}
			// if (mainUI_model.show_type == 1) return//没显示出来图标，先回滚

			if (this.tween_id_) {
				SYTweenLite.Stop(this.tween_id_)
				this.tween_id_ = null
			}

			this.ClearUIEffect(this._gp_effect_icon);
			this.ClearModel();
			this.StopTimer();


			for (let i = 0; i < list.length; i++) {
				this.story_model.UpdateTaskStep(list[i], 0)
			}
		}

		this.destroy_callback = () => {
			local_outwardModelIns.Fire(OutWardBaseModel.OUTWARD_CHANGE_VIEW_CLOSE, data_.id, data_._type)
			data_ = outward_action_cfg_ = client_pos_cfg_ = null
			if (wx_share_tips_) {
				wx_share_tips_.DeleteMe()
				wx_share_tips_ = null
			}
			/* PushGiftModel.GetInstance().CheckDelayTips()缺失礼包推送模块*/
		}

		this.Local_Open = (data?, type?) => {
			data_ = data
			type_ = type
			super.Open()
		}

		this.InitCfg = () => {
			outward_action_cfg_ = local_resMgr.GetGameConfigFromCache(this, "ClientOutWardModel", true)
			client_pos_cfg_ = local_resMgr.GetGameConfigFromCache(this, "ClientOutWardPos", true)
		}

		// this.OnTimer = () => {
		// 	if (this.use_delete_method) {
		// 		return
		// 	}
		// 	let left_time = this.time_down - this.cur_time
		// 	if (left_time <= 0) {
		// 		this.Close()
		// 		return
		// 	}
		// 	this.tipstext.text = left_time + "秒后自动关闭"
		// 	this.cur_time = this.cur_time + 1
		// }

		this.InitEvents = () => {

			// Util.AddClickEvent(this.click_group, () => {
			// 	this.Close();
			// }, this, false);

			// Util.AddClickEvent(this.click, () => {
			// 	this.Close();
			// }, this, false);

			Util.AddClickEvent(this.btnUse, () => {
				this.UseModel();
				this.Close();

				for (let i = 0; i < list.length; i++) {
					this.story_model.UpdateTaskStep(list[i], 0)
				}
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.btnUse)
			}, this, true);

			Util.AddClickEvent(this.btnClose, () => {
				if(!this.btnUse.visible){
					this.UseModel();
				}
				this.Close();
			}, this, true);

		}

		this.InitView = () => {
			if (!data_ || !outward_action_cfg_) {
				return
			}

			local_resMgr.SetOutsideImageSprite(this, this.table_img, GameResPath.GetIcon("pet", "uixxxjs_001"), true);

			let role_id = RoleManager.GetInstance().GetMainRoleId();
			this.titleImg.visible = false;
			if (data_?.type_id == role_id) { // 为角色自己
				this.CreateModel();
				this.titleImg.visible = true;
				local_resMgr.SetImageSprite(this, this.image_text, "medal", "ui_role_wz6");
				local_resMgr.SetImageSprite(this, this.titleImg, "mainUI", "tx_" + data_.id);
				this.name_label.text = RoleManager.GetInstance().GetMainRoleVo().name;
				this.btnClose.x = 259;
				this.curTime = 5;
				this.CallLater(() => {
					RefBoxChildsLayout(this.nameBox, 3, null, true);
				});
				this.StartTimer();
				return;
			}

			if (data_?.type_id == enum_OutWardType.MagicArr) {
				this.btnUse.visible = !(data_?.isFirst);
				let res
				let key = `${data_.type_id}@${data_.id}@${local_mainRoleVo.career}`
				let cfg = local_outwardModelIns.outward_illusion_cfg[key]
				if (cfg) {
					res = local_resMgr.GetGameConfigFromCache(this, "ClientMagicArray", true)[cfg.ride_figure]
					if (!roleModel_) {
						let role_res = local_mainRoleVo.GetRoleClotheId()
						let weapon_res = local_mainRoleVo.GetWeaponClotheId()
						let list = [{ type: local_UI_MODEL_TYPE.ROLE, id: role_res }, { type: local_UI_MODEL_TYPE.WEAPON, id: weapon_res }]
						let wing_res = Util.GetWingClotheId(RoleManager.GetInstance().GetMainRoleVo())
						if (wing_res) {
							list.push({ type: local_UI_MODEL_TYPE.WING, id: wing_res })
						}
					}
					if (res) {
						// this.image_particle_group.y = this.image_arrary_group.y = this.effect_group.y
					}
					this.name_label.text = cfg.name
				}
			} else if (data_._type == 112) { // 气泡和相框
				this.btnUse.visible = !(data_?.isFirst);
				let conf = data_.conf;
				this.img_con.visible = this.model_img.visible = true;
				if (data_.type_id == 1) {
					ResManager.GetInstance().SetImageSpriteTrans(this, this.model_img, GameResPath.GetIcon("chat", '1_' + conf.id + '_0'), true);
					this.model_img.scale(1, 1, true);
				} else if (data_.type_id == 2) {
					ResManager.GetInstance().SetImageSpriteTrans(this, this.model_img, GameResPath.GetIcon("head", '2_' + conf.id), true);
					this.model_img.scale(1.5, 1.5, true);
				} else if (data_.type_id == 5) {
					let headStr: string = DressModel.GetInstance().getHeadICon(conf.id)
					ResManager.GetInstance().SetImageSpriteTrans(this, this.model_img, GameResPath.GetIcon("head", headStr), true);
					this.model_img.scale(1, 1, true);
				}
				this.name_label.text = conf.name;
				if (!this.tween_id_) {
					let end_value = this.img_con.y + 50
					this.tween_id_ = SYTweenLite.to(this, this.img_con, SYTweenLite.UiAnimationType.POSY, end_value, 3, null, SYTweenFunc.PINGPONG, true)
				}
			} else if (data_._type == 411) { // 称号
				this.btnUse.visible = !(data_?.isFirst);
				let conf = DsgtModel.GetInstance().getDsgtCfgByID(data_.id);
				if (conf) {
					this.name_label.text = conf.name;
					if (conf.type == 1) { // 特效
						ResManager.GetInstance().LoadGameConfig(this, "ClientEffDsgtShow", true, null, (ClientEffDsgtShow) => {
							this._gp_effect_icon.visible = true;
							if (ClientEffDsgtShow) {
								this.ClearUIEffect(this._gp_effect_icon)
								this._gp_effect_icon.width = 237;
								this._gp_effect_icon.height = 120;
								let cfg = ClientEffDsgtShow["DsgtDetailsItem"][conf.id]
								if (!cfg) {
									cfg = ClientEffDsgtShow["DsgtDetailsItem"]["def"]
								}
								this.AddUIEffect(Trim(conf.resource_id), this._gp_effect_icon, { x: cfg.x, y: cfg.y }, cfg.scale, true, null, null, null, null, null, null, null, false);
							}
						})

					} else {
						this.dsgt_icon_image.visible = true;
						ResManager.GetInstance().SetOutsideImageSprite(this, this.dsgt_icon_image, "resource/game/dsgtIcon/" + conf.resource_id + ".png", false, () => {
							this.dsgt_icon_image.centerX = 0;
						})
					}
				}
			} else if (data_._type == 182) { // 宝宝
				this.btnUse.visible = (!(data_?.isFirst)) && data_.isUse;
				this.SetBabyModel()
			} else if (data_._type == 152) { // 创世名凯
				this.btnUse.visible = (!(data_?.isFirst)) && data_.isUse;
				this.SetSuit()
			} else if (data_._type == 172) {
				this.MarriageRing()
			} else if (data_._type == 286) {
				this.Revelation()
			} else if (data_._type == DragonBallModel.ModuleId) {// 龙珠
				this.DragonBall()
			} else {
				this.btnUse.visible = !(data_?.isFirst);
				this.SetModel()
			}

			/*暂无特效
			this.AddUIEffect("UI_1402", this.image_bigglow_group, undefined, undefined, true)
			this.AddUIEffect("UI_1128", this.image_text_group, undefined, undefined, true, undefined, () => {
				Util.AddClickEvent(this.click_group, () => {
					this.Close()
				}, this, false)
			}, undefined, true)
			*/

			this.CallLater(() => {
				RefBoxChildsLayout(this.nameBox, 3, null, true);
			});

			this.btnClose.visible = true;
			if (data_?.isFirst) {
				this.btnClose.x = 259;
				this.curTime = 10;
			} else {
				this.btnClose.x = 437;
				this.curTime = 30;
			}

			if (!this.btnUse.visible) {
				this.btnClose.x = 259;
				this.curTime = 5;
			}

			this.StartTimer();
		}




		this.SetModel = () => {
			this.model_group.visible = true
			if (!this.is_loaded || !outward_action_cfg_) {
				return
			}
			let model_res = null
			let action_list = null


			if (type_ == 0) { // 外形升阶
				let key = `${data_.type_id}@${data_.stage}@${local_mainRoleVo.career}`
				let cfg = local_outwardModelIns.outward_stage_cfg[key]
				if (cfg) {
					this.name_label.text = Trim(cfg.name)
					model_res = Number(cfg.ride_figure)
					if (outward_action_cfg_ && outward_action_cfg_[data_.type_id + "@0"]) {
						action_list = outward_action_cfg_[data_.type_id + "@0"].action_list
					}

				}
			} else if (type_ == -1) {
				let cfg = local_resMgr.GetGameConfigFromCache(this, "config_temple_awaken_suit", false)
				model_res = local_mainRoleVo.GetRoleClotheId()
				ResManager.GetInstance().LoadGameConfig(this, "ClientTransfer", true, null, (c) => {
					let name = c['TransferCareerMsg'].find(item => item?.career == local_mainRoleVo.career).name
					this.name_label.text = Trim(name)
				})
			} else if (data_._type == UI_MODEL_TYPE.GUBAO) { // 古宝
				model_res = data_.id;
				this.name_label.text = data_.name;
			} else if (type_) { // 幻化激活
				let key = `${data_.type_id}@${data_.id}@${local_mainRoleVo.career}`
				let cfg = local_outwardModelIns.outward_illusion_cfg[key]
				if (cfg) {
					this.name_label.text = Trim(cfg.name)
					model_res = Number(cfg.ride_figure)
					if (outward_action_cfg_ && outward_action_cfg_[data_.type_id + "@1"]) {
						action_list = outward_action_cfg_[data_.type_id + "@1"].action_list
					}
				}
			} else {	

				// 其余特殊处理
				if (data_._type == 142) { //伙伴
					let cfg = Config.PRELOAD_SERVER_CONFIG.config_companion[data_.id]
					if (cfg) {
						this.name_label.text = Trim(cfg.name)
						model_res = cfg.figure_id
						if (outward_action_cfg_ && outward_action_cfg_[model_res]) {
							action_list = outward_action_cfg_[model_res].action_list
						}
					}
				} else if (data_._type == 413) { //时装
					let cfg = local_resMgr.GetGameConfigFromCache(this, "ClientFashionActivePos", true)[data_.id]
					if (cfg) {
						let sex = RoleManager.GetInstance().GetMainRoleSex()
						model_res = cfg.model_res && cfg.model_res[sex - 1]
						model_res = Number(model_res)
						this.name_label.text = cfg.name
					}
				} else if (data_._type == 1001 || data_._type == 1002 || data_._type == 1003 || data_._type == 1004 || data_._type == 1005) { //觉醒时装
					let cfg = local_resMgr.GetGameConfigFromCache(this, "config_temple_awaken_suit", false)
					let cfg_chapter = local_resMgr.GetGameConfigFromCache(this, "config_temple_awaken", false)
					model_res = cfg[data_._type + "@" + local_mainRoleVo.career].figure_id
					this.name_label.text = Trim(cfg_chapter[data_._type].chapter_name)
					if(data_._type == 1004){
						action_list = ["show"]
					}

				}
			}
			if (model_res) {
				let pos_cfg = null
				if (client_pos_cfg_ && client_pos_cfg_[model_res]) {
					pos_cfg = client_pos_cfg_[model_res]
				} else if (data_._type == 413) { //时装
					let cfg = local_resMgr.GetGameConfigFromCache(this, "ClientFashionActivePos", true)[data_.id]
					if (cfg) {
						let role_vo = RoleManager.GetInstance().GetMainRoleVo()
						let sex = role_vo.sex
						let career = role_vo.career
						let [head_wear_id, head_clothe_id] = role_vo.GetRoleHeadId()
						let fashion_id = model_res
						let texture_id = data_.color_id
						if (data_.sub_type == 3) { //发饰
							head_wear_id = model_res
							head_clothe_id = data_.color_id

							
							let [_res_id, _texture_id] = role_vo.GetRoleClotheTextureId()
							fashion_id = _res_id
							model_res = _res_id
							texture_id = _texture_id
							if (!model_res) {
								model_res = role_vo.GetRoleClotheId()
							}
						}
						pos_cfg = {
							change_scale: cfg.scale && cfg.scale[sex - 1],
							change_rotate: cfg.rotate && cfg.rotate[sex - 1],
							change_position: cfg.pos && cfg.pos[sex - 1],
							head_wear_id: head_wear_id,
							head_clothe_id: head_clothe_id,
							sex: sex,
							career: career,
							fashion_id: fashion_id,
							texture_id: texture_id
						}
						let act = cfg.action_list && cfg.action_list[sex]
						action_list = act
					}
				} else if (data_._type == UI_MODEL_TYPE.GUBAO) { // 古宝
					let cfg = local_resMgr.GetGameConfigFromCache(this, "ClientGuBaoPos", true)[data_.id];
					let act = cfg.action_list && cfg.action_list;
					action_list = act
				}
				else if (data_._type == 1001) { //时装=
					let role_vo = RoleManager.GetInstance().GetMainRoleVo()
					let sex = role_vo.sex
					let career = role_vo.career
					let cfg_kv = local_resMgr.GetGameConfigFromCache(this, "config_temple_awaken_kv", false)
					let head_wear_id = ErlangParser.GetInstance().parse(cfg_kv[7].value)[career - 1][1]
					pos_cfg = {
						change_scale: 0.7,
						head_wear_id: head_wear_id,
						sex: sex,
						career: career,
						change_position: {
							y: 1.5,
							x: 0
						},
					}
				} else if (data_._type == -1) {
					let role_vo = RoleManager.GetInstance().GetMainRoleVo()
					let sex = role_vo.sex
					let career = role_vo.career
					let head_wear_id = role_vo.GetRoleHeadId()
					pos_cfg = {
						change_scale: 0.7,
						head_wear_id: head_wear_id[0],
						sex: sex,
						career: career,
						change_position: {
							y: 1.5,
							x: 0
						},
					}
				}
				let pre_x = ""
				let default_str = ""
				let is_outward = false//培养物
				let type = 1
				if (data_.type_id == enum_OutWardType.Horse || data_._type == 1005) {//坐骑
					type = UI_MODEL_TYPE.HORSE
					pre_x = "h"
					default_str = "ill_horse"
					is_outward = true
				} else if (data_.type_id == enum_OutWardType.Wings || data_._type == 1003) {//翅膀
					type = UI_MODEL_TYPE.WING
					pre_x = "w"
					default_str = "ill_wing"
					is_outward = true
				} else if (data_.type_id == enum_OutWardType.Partner) {//精灵
					type = UI_MODEL_TYPE.SPRITE
					pre_x = "s"
					default_str = "ill_sprite"
					is_outward = true
				} else if (data_.type_id == enum_OutWardType.HolyDevice || data_._type == 1004) {//神兵
					type = UI_MODEL_TYPE.WEAPON
					pre_x = "d"
					default_str = "ill_weapon"
					is_outward = true
					//觉醒神兵
					if (data_._type == 1004) {

						let role_vo = RoleManager.GetInstance().GetMainRoleVo()
						let career = role_vo.career
						let pos_y = career <= 2 ? 2 : 1
						let pos_x = 0//career <= 2 ? -1 : 0
						pos_cfg = {
							change_position: {
								y: pos_y,
								x: pos_x
							},
							change_scale: 0.6,
							//change_rotate: 90// new Vector3(65, 90, 270)
						}
						is_outward = false
					}
				} else if (data_.type_id == enum_OutWardType.Artifact || data_._type == 1002) {//圣器
					type = UI_MODEL_TYPE.ARTIFACT
					pre_x = "a"
					default_str = "ill_artifact"
					is_outward = true
				} else if (data_.type_id == enum_OutWardType.BackOrnament) {//背饰
					type = UI_MODEL_TYPE.BACKORNAMENT
					pre_x = "b"
					default_str = "ill_backornament"
					is_outward = true
					// pos_cfg = {
					// 	change_scale: 0.6,
					// 	change_position: {
					// 		y: 2,
					// 		x: 0
					// 	},
					// }
				}
				if (is_outward) {
					pos_cfg = client_pos_cfg_[`${pre_x}_${model_res}`]
					if (!pos_cfg) {
						pos_cfg = client_pos_cfg_[default_str]
					}
				}

				if (data_._type == 142) {//契灵
					type = UI_MODEL_TYPE.PARTNER
					pos_cfg = client_pos_cfg_[`p_${model_res}`]
					if (!pos_cfg) {
						pos_cfg = client_pos_cfg_["default_partner"]
					}
				}

				if (data_._type == UI_MODEL_TYPE.GUBAO) { // 古宝
					type = UI_MODEL_TYPE.GUBAO
					let cfg = local_resMgr.GetGameConfigFromCache(this, "ClientGuBaoPos", true)[data_.id];
					if (!cfg) {
						pos_cfg = client_pos_cfg_["default_gubao"]
					} else {
						pos_cfg = cfg
					}

				}

				this.CallLater(() => {
					RefBoxChildsLayout(this.nameBox, 3, null, true);
				});

				let data = {
					clothe_res_id: model_res,
					type: type,
					can_rotate: true,
					layer_value: this.layer_value,
					scale: pos_cfg ? pos_cfg.change_scale : 0.7,
					rotate: pos_cfg && pos_cfg.change_rotate,
					position: pos_cfg && pos_cfg.change_position,
					head_wear_id: pos_cfg && pos_cfg.head_wear_id,
					head_clothe_id: pos_cfg && pos_cfg.head_clothe_id,
					fashion_model_id: pos_cfg && pos_cfg.fashion_id,
					texture_id: pos_cfg && pos_cfg.texture_id,
					sex: pos_cfg && pos_cfg.sex,
					career: pos_cfg && pos_cfg.career,
					action_name_list: action_list,
					action_delta: true
				}
				ResManager.GetInstance().SetRoleModel(this, this.model_group, data)
			}
		}

		/**
		 * 使用模型
		 */
		this.UseModel = () => {
			if (data_?.cb) {
				data_.cb();
			}
		}
		this.SetBabyModel = () => {
			this.model_group.visible = true;
			let config_baby_figure = local_resMgr.GetGameConfigFromCache(this, "config_baby_figure", false);
			let cfg = local_resMgr.GetGameConfigFromCache(this, "ClientBaby", true);
			if (!config_baby_figure || !cfg) return;
			let resCfg = config_baby_figure[data_.id]
			let model_res = resCfg ? resCfg.resource_id : (cfg.DefaultRes || 1001)
			let modelCfg = cfg[model_res]
			let scale = (modelCfg && modelCfg.scale) ? modelCfg.scale.x : 0.8
			let data = {
				clothe_res_id: model_res,
				type: UI_MODEL_TYPE.BABY,
				scale: scale,
				position: { x: 0, y: 1.5 },
				action_name_list: ["show"] //action_name_list: ["idle"]
			}
			ResManager.GetInstance().SetRoleModel(this, this.model_group, data)
			this.name_label.text = resCfg ? resCfg.baby_name_con : `宝宝`
		}

		this.StartTimer = () => {
			this.StopTimer();
			let loop_func = () => {
				if (this.curTime < 0) {
					this.StopTimer();
					if (data_?.isFirst) {
						this.UseModel();
					}
					this.Close();
					return;
				} else {
					this.SetBtnText();
					this.curTime -= 1;
				}
			}

			this.timeId = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1);
			loop_func();
		}

		this.StopTimer = () => {
			if (this.timeId) {
				GlobalTimerQuest.CancelQuest(this.timeId)
				this.timeId = null
			}
		}

		this.SetBtnText = () => {
			/* 	if (data_?.isFirst) {
					this.useLab.text = `使用新形象(${this.curTime})`;
				} else {
				} */
			this.closeLab.text = `确定(${this.curTime})`;
		}

		this.SetSuit = () => {
			let suitCfg = Config.PRELOAD_SERVER_CONFIG.config_suit_clt
			local_resMgr.SetOutsideImageSprite(this, this.table_img, GameResPath.GetIcon("pet", "uixxxjs_001"), true)
			let res = null
			let cfg = suitCfg[data_.id + "@" + RoleManager.GetInstance().GetMainRoleCareer()]
			if (cfg) {
				let role_vo = RoleManager.GetInstance().GetMainRoleVo()
				let pos_x = role_vo.sex == 1 ? 0.2 : -0.2
				//let res ,
				//locla texture_id = cfg.fashion_id ,cfg.fashion_color //RevelationModel.GetClothesRes(data_,role_vo.sex)
				//let hairs , hairs_text_id = RevelationModel.GetHairRes(data_,role_vo.sex)
				//let weapon_model_id, weapon_texture_id = role_vo.GetWeaponClotheId()
				let data = {
					clothe_res_id: cfg.fashion_id,
					texture_id: cfg.fashion_color,
					type: UI_MODEL_TYPE.ROLE,
					can_rotate: true,
					layer_value: this.layer_value,
					scale: 0.65,
					//rotate = pos_cfg && pos_cfg.change_rotate,
					//position = pos_cfg && pos_cfg.change_position,
					position: new Vector3(pos_x, 1, 0),
					head_wear_id: cfg.hair_id,
					head_clothe_id: cfg.hair_color,
					fashion_model_id: cfg.fashion_id,
					sex: role_vo.sex,
					career: role_vo.career,
					weapon_res_id: cfg.equip_id,
					weapon_clothe_id: cfg.equip_color,
					//action_name_list : action_list
				}
				ResManager.GetInstance().SetRoleModel(this, this.model_group, data)
				this.name_label.text = cfg.name
			}
		}

		this.DragonBall = () => {
			let config_dragon_ball_figure = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_figure
			if (!config_dragon_ball_figure){
				return
			}
			this.btnUse.visible = false
			let cfg = config_dragon_ball_figure[`${data_.id}@${data_.lv}`]
			if(!cfg) return

			this.name_label.text = cfg.name
			
			let role_vo = RoleManager.GetInstance().GetMainRoleVo()
			let [model_id, model_texture_id] = Util.GetRoleClotheId(role_vo)
			// let weapon_id = Util.GetWeaponClotheId(role_vo)
			let weapon_id = null
			let back_ornament_id = Util.GetBackOrnamentId(role_vo)
			let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
			// let liveness_id = Util.GetLivenessId(role_vo)


			let data = {
				career: role_vo.career,
				sex: role_vo.sex,
				layer_value: this.layer_value,
				scale: 0.4,
				position: new Vector3(0, 1.5),
				type: UI_MODEL_TYPE.ROLE,
				action_name_list: ["meditation"],
				enableHDR: true,
				can_rotate: false,
				can_click: false,

				//衣服
				clothe_res_id: model_id,
				fashion_model_id: model_id,
				texture_id: model_texture_id,

				//头
				head_wear_id: head_id,
				head_clothe_id: head_texture_id,

				//武器
				weapon_res_id: weapon_id,
				weapon_clothe_id: 0,

				//翅膀
				wing_id: Util.GetWingClotheId(role_vo),

				//背饰
				back_ornament_id: back_ornament_id,

				//活跃度
				liveness_id: cfg.id,
			}
			ResManager.GetInstance().SetRoleModel(this, this.model_group, data)
		}

		this.MarriageRing = () => {
			this.image_name.visible = false
			local_resMgr.SetTexture(this, this.table_img, "resource/game/pet/texture/uixxxjs_001.png")
			SoundManager.GetInstance().PlaySoundEffect("3_huode")
			this.model_group.visible = false
			this.outward_img.visible = true
			let config = local_resMgr.GetGameConfigFromCache(this, "config_ring_stage", false)
			let stage_data = MarriageModel.GetInstance().GetRingStageData(data_.id, config)
			if (!stage_data) return
			this.outward_img.size(325, 325)
			this.outward_img.scale(0.7, 0.7)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.outward_img, GameResPath.GetIcon("marriage", stage_data.resource_id))

		}

		this.Revelation = () => {
			let suitCfg = Config.PRELOAD_SERVER_CONFIG.config_revelation_equip_figuire
			local_resMgr.SetOutsideImageSprite(this, this.table_img, GameResPath.GetIcon("pet", "uixxxjs_001"), true)
			// let res = null
			let cfg = suitCfg[data_.id]
			if (cfg) {
				let role_vo = RoleManager.GetInstance().GetMainRoleVo()
				let [res, texture_id] = Util.GetRevelationClothesRes(data_.id, role_vo.sex)
				let [hairs, hairs_text_id] = Util.GetRevelationHairRes(data_.id, role_vo.sex)
				let weapon_model_id = role_vo.GetWeaponClotheId()

				let data = {
					clothe_res_id: res,
					texture_id: texture_id,
					type: UI_MODEL_TYPE.ROLE,
					can_rotate: true,
					layer_value: this.layer_value,
					scale: 0.7,
					// rotate = pos_cfg && pos_cfg.change_rotate,
					position: new Vector2(0.3, 1),
					head_wear_id: hairs,
					head_clothe_id: hairs_text_id,
					fashion_model_id: res,
					sex: role_vo.sex,
					career: role_vo.career,
					weapon_res_id: weapon_model_id,
				}
				ResManager.GetInstance().SetRoleModel(this, this.model_group, data)

				this.name_label.text = cfg.suit_name
			}
		}
	}



	public CreateModel() {
		let role_vo = RoleManager.GetInstance().GetMainRoleVo()
		let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
		let weapon_model_id = Util.GetWeaponClotheId(role_vo)
		let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
		let data = {
			career: role_vo.career,
			sex: role_vo.sex,
			clothe_res_id: model_id,
			fashion_model_id: model_id,
			type: UI_MODEL_TYPE.MAINROLE,
			can_rotate: true,
			weapon_res_id: weapon_model_id,
			weapon_clothe_id: 0,//weapon_texture_id,
			layer_value: this.layer_value,
			scale: 0.7,
			position: new Vector3(0, 0.7, 0),
			texture_id: texture_id,
			wing_id: Util.GetWingClotheId(role_vo),//role_vo.GetFigureId(role_vo, FigureProtoVo.FigureType.Wing),
			// liveness_id: role_vo.liveness_id,
			head_wear_id: head_id,
			head_clothe_id: head_texture_id,//head_clothe_id,
		}
		ResManager.GetInstance().SetRoleModel(this, this.model_group, data)
	}


	public ClearModel() {
		ResManager.GetInstance().ClearRoleMode(this.$hashCode)

		// if (!this.role_model) {
		// 	return
		// }
		// this.role_model.DeleteMe()
		// this.role_model = null
	}


	public Open(data?, type?) {
		this.Local_Open(data, type)
	}

	image_text_group: Laya.Box
	tipstext: Laya.Label
	table_img: Laya.Image
	image_bigglow_group: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	success_image: Laya.Image
	model_group: Laya.Box
	image_text: Laya.Image
	outward_img: Laya.Image
	image_name: Laya.Image
	nameBox: Laya.Box
	titleImg: Laya.Image
	name_label: Laya.Label
	click_group: Laya.Box
	wx_share_con: Laya.Box
	_gp_effect_icon: Laya.Box
	dsgt_icon_image: Laya.Image
	img_con: Laya.Box
	model_img: Laya.Image
	click: Laya.Image
	btnUse: Laya.Image
	useLab: Laya.Label
	btnClose: Laya.Image
	closeLab: Laya.Label
	public GetComponents() {
		[
			this.image_text_group,
			this.tipstext,
			this.table_img,
			this.image_bigglow_group,
			this._Image1,
			this._Image2,
			this.success_image,
			this.model_group,
			this.image_text,
			this.outward_img,
			this.image_name,
			this.nameBox,
			this.titleImg,
			this.name_label,
			this.click_group,
			this.wx_share_con,
			this._gp_effect_icon,
			this.dsgt_icon_image,
			this.img_con,
			this.model_img,
			this.click,
			this.btnUse,
			this.useLab,
			this.btnClose,
			this.closeLab,
		]
			= this.GetChildrenByNames([

				"image_text_group",
				"tipstext",
				"table_img",
				"image_bigglow_group",
				"_Image1",
				"_Image2",
				"success_image",
				"model_group",
				"image_text",
				"outward_img",
				"image_name",
				"nameBox",
				"titleImg",
				"name_label",
				"click_group",
				"wx_share_con",
				"_gp_effect_icon",
				"dsgt_icon_image",
				"img_con",
				"model_img",
				"click",
				"btnUse",
				"useLab",
				"btnClose",
				"closeLab",
			])
		this.click_group.mouseEnabled = false
		this.click.on(Laya.Event.CLICK, this, () => {
			this.Close()
		})
	}
}
window["OutwardChangedView"] = OutwardChangedView
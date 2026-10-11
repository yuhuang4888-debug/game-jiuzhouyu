import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { EquipDefine, EquipEvent, EquipModel } from "../commonModel/EquipModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { BagModel } from "../commonModel/BagModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { SetAnchoredPosition, Util } from "../util/Util"
import { Config } from "../common/Config"
import { Alert, Alert_Type } from "../alert/Alert"
import { OpenFun } from "../common/OpenFun"
import { RoleVo } from "../sharedata/RoleVo"
import { Vector3 } from "../util/Vector3"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsBagItemRenderer } from "./GoodsBagItemRenderer"
import { EquipmentIcon } from "./EquipmentIcon"
import { EquipToolTipItem } from "./EquipToolTipItem"
import { DragonBallModel } from "../commonModel/DragonBallModel"
import { GuardModel } from "../commonModel/GuardModel"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { SceneBaseType } from "../scene/SceneConfig"
import { MainRoleVo } from "../sharedata/MainRoleVo"
import { GameResPath } from "../util/GameResPath"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { CompositeModel, CompositeEvent } from "../commonModel/CompositeModel"
import { CommonManager } from "../common/CommonManager"
import { SuitModel, SuitModelEvent } from "../commonModel/SuitModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { PlatformManager } from "../PlatformManager"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"

export class BagComponentView extends BaseItem1 {
	public _Image11: Laya.Image;
	public roleBG: Laya.Image;
	public _Image2: Laya.Image;
	public carreImg: Laya.Image;
	public modelGp: Laya.Box;
	public nameLb: Laya.Label;
	public leftGp: Laya.VBox;
	public rightGp: Laya.VBox;
	public onekeyBtn: Laya.Box;
	public _Image1: Laya.Image;
	public labelDisplay: Laya.Label;
	public smeltBtn: Laya.Image;
	public redequipBtn: Laya.Image;
	public suitRed: Laya.Image;
	public expandBtn: Laya.Image;
	public useBtn: Laya.Image;
	public bag_con: Laya.List;
	public _gp_guard1: Laya.Box;
	public _btn_guard1: Laya.Image;
	public guard1_red: Laya.Image;
	public _gp_guard2: Laya.Box;
	public _btn_guard2: Laya.Image;
	public guard2_red: Laya.Image;
	public _gp_dragonball: Laya.Box;
	public _btn_dragonball: Laya.Image;
	public dragonball_red: Laya.Image;
	public red_quick: Laya.Image;
	public useRed: Laya.Image;
	public smeltRed: Laya.Image;

	UpdateEquipItems
	CreateModel
	changeCareerEff
	story_obj_list
	InitEvent
	DeleteEquipItems
	guard_type_1
	has_set_cover
	fight_num
	InitView
	limit_cfg
	mainVo: MainRoleVo
	role_model
	equip_item_list: EquipmentIcon[]
	equipTool1
	is_first
	guard_type_2
	ClearModel
	equipTool2
	_Scroller1
	max_expand_count
	is_delay_callback
	ShowOneKeyDot
	ReOpen_callback
	dataChanged
	ShowGuardImage
	ShowDragonBall
	bag_loop_mgr: LoopScrowViewMgr
	public constructor(parent?) {
		super(parent)
		this.equip_item_list = [];
		this.is_first = true;
		this.max_expand_count = 300;
		this.base_file = "bag"
		this.layout_file = "BagComponentView"
		this.layer_value = "UI"
		this.is_delay_callback = true
		let res_mgr = ResManager.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_EquipDefine = EquipDefine
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let local_FigureProtoVo = FigureProtoVo
		let guard_model = GuardModel.GetInstance()
		let local_GuardModel = GuardModel

		let dragonBall_model = DragonBallModel.GetInstance()
		let bag_model = BagModel.GetInstance()
		let local_BagModel = BagModel
		let equip_model = EquipModel.GetInstance()
		// let local_UI_MODEL_TYPE = UIModelClass.UI_MODEL_TYPE
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		this.load_callback = () => {

			if(PlatformManager.IsEyouThPlatform()){
				this.smeltBtn.width = 108
				this.smeltBtn.height = 88
				this.smeltBtn.anchorX = 0.5
				this.smeltBtn.x = 662
				this.redequipBtn.anchorX = 0.5
				this.redequipBtn.x = 662
				this.useBtn.anchorX = 0.5
				this.useBtn.x = 662
				this.expandBtn.anchorX = 0.5
				this.expandBtn.x = 662
			}
			this.fight_num = new FightingShowSmallItem(this.display_obj)
			this.fight_num.Load()

			this.fight_num.ExcuteCallback(() => {
				this.fight_num.display_obj.centerX = 0
				this.fight_num.display_obj.y = 59
			})

			this.InitView()
			this.InitEvent()
			ResManager.GetInstance().SetTexture(this, this.roleBG, GameResPath.GetIcon("bag", "ui_bg_2"), null, null, true);
			//resource/game/common2/texture/com_line_1.png
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11, GameResPath.GetIconOtherPath("common2", "com_line_1"));
			this.suitRed.visible = SuitModel.GetInstance().GetSuitTotlaRed();
		}

		this.InitView = () => {
			this.limit_cfg = Config.PRELOAD_SERVER_CONFIG.config_equip_strengthen_max
			bag_model.CreateBagFullList()

			this.bag_loop_mgr = new LoopScrowViewMgr()
			this.bag_loop_mgr.SetData(this.bag_con, GoodsBagItemRenderer, bag_model.bag_full_list, LoopScrCon.Vertical)

			// this.bag_con.vScrollBarSkin = "";
			// this.bag_con.itemRender = GoodsBagItemRenderer
			// this.bag_con.renderHandler = new Laya.Handler(this, this.dataChanged);
			// this.bag_con.array = bag_model.bag_full_list


			let roleVo = role_mgr.GetMainRoleVo()
			this.fight_num.Updatefighting(String(roleVo.fighting))
			let group_con = null
			let i = 1
			do {
				group_con = (i % 2 == 0 && this.rightGp || this.leftGp)
				let item: EquipmentIcon = this.equip_item_list[i]
				if (!item) {
					item = new EquipmentIcon(group_con)
				}
				item.SetEquipPos(i)
				item.Load()
				this.equip_item_list[i] = item
				i = i + 1
			} while (i < local_EquipDefine.EQUIP_COUNT + 1)
			this.UpdateEquipItems()
			this.nameLb.text = roleVo.name
			this.ShowGuardImage()
			this.ShowDragonBall()
			this.CreateModel()
			this.ShowOneKeyDot()
			this.useRed.visible = bag_model.onekeyUseRed
			this.smeltRed.visible = bag_model.smeltRed
		}

		// this.dataChanged = (cell, index: number) => {
		// 	cell.dataChanged(cell.dataSource, index);
		// }

		this.InitEvent = () => {
			let update_fighting = () => {
				this.fight_num.Updatefighting(String(role_mgr.GetMainRoleVo().fighting))
			}
			this.BindVar(role_mgr.GetMainRoleVo(), "fighting", update_fighting)

			let OnQuickBtnClick = () => {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_goods
				let [list, empty, showAlert] = equip_model.GetStrongestEquips(cfg, null, true)
				if (list.length < 1) {
					
					if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.DressOrangeEquip)) {		
						this.story_model.task_supplement_list["AlertTypeOne"]=1		
						this.story_model.curr_view_story_step = 3
					}
					Alert.Show("当前没有更好装备可替换。\n击杀各种大妖可获得极品装备，是否立刻前往？", Alert_Type.One, () => {
						OpenFun.OpenFunHandler(26)
					}
						, null, "前往")
				} else {
					goods_model.CheckEquipNum(empty && 0 || 1, 0, () => {
						let func = () => {
							for (let _tmpi in list) {
								var info = list[_tmpi]
								equip_model.Fire(EquipEvent.REQUEST_PROTO, 15201, "l", info.goods_id)
							}
						}
						if (showAlert) {
							// Alert.Show("当前装备无法继承共鸣，是否拆解共鸣是并继续穿戴？", Alert_Type.Two, func)
							func();
						} else {
							func()
						}

					}
					)


					if(this.story_model.task_supplement_list["AlertTypeOne"]){
						delete this.story_model.task_supplement_list["AlertTypeOne"]
					}
	
				}
				goods_model.Fire(local_GoodsModel.CHANGE_EQUIPLIST)
			}
			Util.AddClickEvent(this.onekeyBtn, OnQuickBtnClick, this, true)

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_EQUIPLIST, () => {
				this.ShowOneKeyDot()
				this.UpdateEquipItems()
			}
			)

			this.BindEvent(goods_model, local_GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				let keyBreak = false
				for (let _tmpi in goods_list) {
					var v = goods_list[_tmpi]
					let basic = goods_model.GetGoodsBasicByTypeId(v.type_id)
					if ((basic && basic.type == 10) && !keyBreak) {
						this.ShowOneKeyDot()
						break
					}
				}
				bag_model.CreateBagFullList()
				this.bag_loop_mgr.replaceAll(bag_model.bag_full_list)
			}
			)
			this.BindVar(role_mgr.GetMainRoleVo(), "fashion_model_list", () => {
				this.ClearModel()
				this.CreateModel()
			}
			)
			this.BindVar(role_mgr.GetMainRoleVo(), "liveness_id", () => {
				this.ClearModel()
				this.CreateModel()
			}
			)
			this.BindVar(role_mgr.GetMainRoleVo(), "figure_list", () => {
				this.ClearModel()
				this.CreateModel()
			}
			)
			this.BindVar(role_mgr.GetMainRoleVo(), RoleVo.FIGURE_CHANGE, (figure_type?, figure_id?) => {
				if (figure_type == local_FigureProtoVo.FigureType.Wing || figure_type == local_FigureProtoVo.FigureType.Weapon) {
					this.ClearModel()
					this.CreateModel()
				}
			}
			)
			this.BindEvent(local_GlobalEventSystem, local_GoodsModel.CHANGE_GOODS_DYNAMIC, (goods_id?) => {
				let equip = goods_model.GetEquipById(goods_id)
				if (!equip) {
					return
				}
				this.UpdateEquipItems()
			}
			)

			this.BindEvent(BagModel.GetInstance(), BagModel.UPDATE_ONE_KEY_RED, () => {
				this.ShowOneKeyDot()
			})

			this.BindEvent(FirstRechargeModel.GetInstance(), FirstRechargeModel.UPDATE_FIRST_RECHARGE_VIEW, () => {
				this.ShowDragonBall()
			})

			Util.AddClickEvent(this._btn_dragonball, () => {
				if(!FirstRechargeModel.GetInstance().IsDoneFirstRecharge()){
					OpenFun.OpenFunHandler(70)
					return
				}
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DragonBallView") 
			}, this, true)

			Util.AddClickEvent(this._btn_guard1, () => {
				guard_model.Fire(local_GuardModel.OPEN_VIEW, this.guard_type_1)
			}, this, true)

			Util.AddClickEvent(this._btn_guard2, () => {
				guard_model.Fire(local_GuardModel.OPEN_VIEW, this.guard_type_2)
			}, this, true)

			Util.AddClickEvent(this.expandBtn, () => {
				bag_model.Fire(local_BagModel.OPEN_VIEW, "ExpandBagView", local_GoodsModel.GOODS_POS_TYPE.bag)
			}
				, this, true)
			Util.AddClickEvent(this.smeltBtn, () => {
				let open = CommonManager.GetInstance().CheckFuncOpenState("BagSmeltView")
				if (open) {
					bag_model.Fire(local_BagModel.OPEN_VIEW, "BagSmeltView")
				}
			}
				, this, true)
			Util.AddClickEvent(this.useBtn, () => {
				bag_model.Fire(local_BagModel.OPEN_VIEW, "OneKeyUseView")
			}
				, this, true)

			this.BindEvent(bag_model, local_BagModel.CONTRAST_EQUIP, (data?) => {
				let wear_equip_info = equip_model.GetWearEquipInfo(data.equip_type)
				let liuhai = Util.GetLiuhaiHeight() || 0
				let gap = 0//ScreenWidth > 720 && (ScreenWidth - 720) / 2 || 0
				if (wear_equip_info) {
					let callback = (dynamic?) => {
						if (!this.equipTool1) {
							this.equipTool1 = new EquipToolTipItem()
							// this.equipTool1.display_obj.y = 0
							// this.equipTool1.display_obj.x = 0
						}
						this.equipTool1.SetData(wear_equip_info.type_id, -125, 80 + liuhai, dynamic, 1, [1])
						this.equipTool1.ExcuteCallback(() => {
							this.equipTool1.display_obj.centerX = -125
							this.equipTool1.display_obj.centerY = -80 + liuhai
						})
						this.equipTool1.Open()
						this.equipTool1.closeflag = false


						if (!this.equipTool2) {
							this.equipTool2 = new EquipToolTipItem()
							this.equipTool2.use_background = false
						}

						let btnId: number[] = [0];
						if (data.trade) {
							btnId.push(6) // 上架
						}
						this.equipTool2.SetData(data.type_id, 150, -105 + liuhai, data, 1, btnId)
						this.equipTool2.ExcuteCallback(() => {
							this.equipTool2.display_obj.centerX = 150
							this.equipTool2.display_obj.centerY = 105 + liuhai
						})
						this.equipTool2.Open()
						this.equipTool2.closeflag = false
					}
					goods_model.GetDynamic(wear_equip_info.goods_id, callback)
				}
			}
			)
			this.BindVar(bag_model, "onekeyUseRed", () => {
				this.useRed.visible = bag_model.onekeyUseRed
			}
			)
			this.BindVar(bag_model, "smeltRed", () => {
				this.smeltRed.visible = bag_model.smeltRed
			}
			)
			let expandFunc = (vo?) => {
				bag_model.CreateBagFullList()
				this.bag_loop_mgr.replaceAll(bag_model.bag_full_list)
			}

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_BAG_MAX_CELL, expandFunc)
			Util.AddClickEvent(this.redequipBtn, () => {
				// CompositeModel.GetInstance().Fire(CompositeEvent.OPEN_RED_VIEW, 0, 105)
				OpenFun.OpenFunHandler(24);
			}
				, this, true)
			this.BindEvent(guard_model, local_GuardModel.UPDATA_VIEW, () => {
				this.ShowGuardImage()
			}
			)
			this.BindEvent(local_GlobalEventSystem, local_EventName.CHANGE_MAINROLE_CAREER, () => {
				this.changeCareerEff()
			}
			)

			// 龙珠icon红点
			this.BindEvent(dragonBall_model, DragonBallModel.REFRESH_RED_FLAG, () => {
				this.dragonball_red.visible = dragonBall_model.GetRedState()
			})

			// 共鸣icon红点
			this.BindEvent(SuitModel.GetInstance(), SuitModelEvent.UP_SUIT_RED, () => {
				this.suitRed.visible = SuitModel.GetInstance().GetSuitTotlaRed();
			})
		}

		this.UpdateEquipItems = () => {
			let info = null
			let item: EquipmentIcon = null
			let attr_cfg = null
			let limit_cfg = null
			let equipInfos = equip_model.GetWearEquipDynamics()
			let findList = []

			let cfgs = Config.PRELOAD_SERVER_CONFIG.config_equip_attr
			for (let _tmpi in equipInfos) {
				var vo = equipInfos[_tmpi]
				item = this.equip_item_list[vo.equip_type]

				attr_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, vo.type_id, false, cfgs)
				if (attr_cfg) {
					limit_cfg = this.limit_cfg[attr_cfg.stage + "@" + vo.color + "@" + vo.equip_type]
					item.SetCfgs(limit_cfg, attr_cfg)
					item.SetData(vo)
					findList[vo.equip_type] = true
				}
			}
			let i = 0
			do {
				if (!findList[local_EquipDefine.EQUIP_POS[i]]) {
					this.equip_item_list[local_EquipDefine.EQUIP_POS[i]].SetData(null)
				}
				i = i + 1
			} while (i < local_EquipDefine.EQUIP_COUNT)
		}


		this.ShowOneKeyDot = () => {
			if (RoleManager.Instance.mainRoleInfo.level < local_EquipDefine.NOT_SHOW_OND_KEY_WEAR_DOT_LV) {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_goods
				let [list] = equip_model.GetStrongestEquips(cfg)
				this.red_quick.visible = list && list.length > 0
			} else {
				this.red_quick.visible = false
			}
		}

		// 龙珠功能
		this.ShowDragonBall = () => {
			let state = dragonBall_model.GetOpenState()
			if (!state) {
				this._gp_dragonball.visible = false
				return
			}
			this._gp_dragonball.visible = true
			if(FirstRechargeModel.GetInstance().IsDoneFirstRecharge()){
				this._btn_dragonball.gray = false
				this.dragonball_red.visible = dragonBall_model.GetRedState()
			}
			else{
				this._btn_dragonball.gray = true
			}

			ResManager.GetInstance().SetImageSprite(this, this._btn_dragonball, "bag_asset", "dragon_ball", true)
		}

		// 守护功能
		this.ShowGuardImage = () => {
			this._gp_guard2.visible = guard_model.OpenStatus()
			this._gp_guard1.visible = this._gp_guard2.visible
			if (!this._gp_guard1.visible) {
				return
			}
			let config = Config.PRELOAD_SERVER_CONFIG.config_magic_circle
			if (!config) {
				return
			}
			let info = guard_model.info
			let type1 = 1
			let type2 = 2
			let type1_active = false
			let type2_active = false
			if (info) {
				for (let i in info) {
					let v = info[i]
					if (v.status == 1) {
						let lv = v.lv
						if (1 == lv) {
							type1 = (type1 == 3 && (3) || (lv))
							type1_active = true
						} else if (3 == lv) {
							type1 = (type1 == 3 && (3) || (lv))
							type1_active = true
						} else if (2 == lv) {
							type2 = (type2 == 4 && (4) || (lv))
							type2_active = true
						} else if (4 == lv) {
							type2 = (type2 == 4 && (4) || (lv))
							type2_active = true
						}
					}
				}
			}
			let func = (type?) => {
				let red = null
				let btn: Laya.Image = null
				let is_active = null
				if (1 == type) {
					let goods_id = guard_model.typeTogoods[3]
					let num = goods_model.GetTypeGoodsNum(goods_id)
					red = this.guard1_red
					btn = this._btn_guard1
					is_active = (num > 0 && (false) || (type1_active))
					type1 = (num > 0 && (3) || (type1))
					type = type1
				} else if (2 == type) {
					let goods_id = guard_model.typeTogoods[4]
					let num = goods_model.GetTypeGoodsNum(goods_id)
					red = this.guard2_red
					btn = this._btn_guard2
					is_active = (num > 0 && (false) || (type2_active))
					type2 = (num > 0 && (4) || (type2))
					type = type2
				} else if (3 == type) {
					red = this.guard1_red
					btn = this._btn_guard1
					is_active = type1_active
				} else if (4 == type) {
					red = this.guard2_red
					btn = this._btn_guard2
					is_active = type2_active
				}
				if (red) {
					red.visible = guard_model.GetGuardRed(type)
				}
				if (btn) {
					ResManager.GetInstance().SetImageSprite(this, btn, "bag", "guard" + type, true)
					btn.gray = !is_active
				}
				this.guard_type_1 = type1
				this.guard_type_2 = type2
			}

			func(type1)
			func(type2)
		}

		this.CreateModel = () => {
			this.ClearModel()
			let role_vo = RoleManager.GetInstance().GetMainRoleVo()
			let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
			let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
			let weapon_model_id = Util.GetWeaponClotheId(role_vo)
			let wing_id = Util.GetWingClotheId(role_vo)
			let back_ornament_id = Util.GetBackOrnamentId(role_vo)
			let liveness_id = Util.GetLivenessId(role_vo)

			let data = {
				career: role_vo.career,
				sex: role_vo.sex,
				type: UI_MODEL_TYPE.MAINROLE,
				layer_value: this.layer_value,
				scale: 0.78,
				position: new Vector3(0, 2.7, 0),
				enableHDR: true,

				clothe_res_id: model_id,
				fashion_model_id: model_id,
				texture_id: texture_id,

				head_wear_id: head_id,
				head_clothe_id: head_texture_id,

				weapon_res_id: weapon_model_id,
				weapon_clothe_id: 0,
				
				wing_id: wing_id,
				back_ornament_id: back_ornament_id,
				liveness_id: liveness_id
				
			}
			ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)
		}

		this.ClearModel = () => {
			if (!this.role_model) {
				return
			}
			this.role_model.DeleteMe()
			this.role_model = null
		}

		this.DeleteEquipItems = () => {
			for (let _tmpi in this.equip_item_list) {
				var item = this.equip_item_list[_tmpi]
				if (!item) {
					break
				}
				item.DeleteMe()
			}
			this.equip_item_list = []
		}

		this.changeCareerEff = () => {
			for (let key in this.equip_item_list) {
				let item = this.equip_item_list[key]
				let data = item.item_data()
				if (data) {
					item.UpdateEffect()
				}
			}
		}

		this.ReOpen_callback = () => {
			this.CreateModel()
		}

	}


	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}
		this.story_obj_list[TaskTipType.DressOrangeEquip] = [this.onekeyBtn,BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return]

		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.FusionEquip)) {
			this.story_model.curr_view_story_step = 1
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2)
		}

		this.story_obj_list[TaskTipType.FusionEquip] = [null,this.smeltBtn]
		super.createChildren()
	}

	public DeleteMe() {
		if (this.bag_loop_mgr) {
			this.bag_loop_mgr.DeleteMe()
			this.bag_loop_mgr = null
		}
		this.limit_cfg = null
		if (this.fight_num) {
			this.fight_num.DeleteMe()
			this.fight_num = null
		}
		this.ClearModel()
		this.DeleteEquipItems()
		this.has_set_cover = false
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Image11,
			this.roleBG,
			this._Image2,
			this.carreImg,
			this.modelGp,
			this.nameLb,
			this.leftGp,
			this.rightGp,
			this.onekeyBtn,
			this._Image1,
			this.labelDisplay,
			this.smeltBtn,
			this.redequipBtn,
			this.suitRed,
			this.expandBtn,
			this.useBtn,
			this.bag_con,
			this._gp_guard1,
			this._btn_guard1,
			this.guard1_red,
			this._gp_guard2,
			this._btn_guard2,
			this.guard2_red,
			this._gp_dragonball,
			this._btn_dragonball,
			this.dragonball_red,
			this.red_quick,
			this.useRed,
			this.smeltRed
		] = this.GetChildrenByNames([
			"_Image11",
			"roleBG",
			"_Image2",
			"carreImg",
			"modelGp",
			"nameLb",
			"leftGp",
			"rightGp",
			"onekeyBtn",
			"_Image1",
			"labelDisplay",
			"smeltBtn",
			"redequipBtn",
			"suitRed",
			"expandBtn",
			"useBtn",
			"bag_con",
			"_gp_guard1",
			"_btn_guard1",
			"guard1_red",
			"_gp_guard2",
			"_btn_guard2",
			"guard2_red",
			"_gp_dragonball",
			"_btn_dragonball",
			"dragonball_red",
			"red_quick",
			"useRed",
			"smeltRed"
		])
	}
}
window["BagComponentView"] = BagComponentView
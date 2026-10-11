import { attributePotionModel } from "../commonModel/attributePotionModel"
import { BaseItem1 } from "../common/BaseItem1"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { EquipModel, EquipEvent, EquipmentViewSecond_Menu_Type, EquipmentViewSecond_Open_Id } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { FlyShoeMinDistance, SceneBaseType } from "../scene/SceneConfig"
import { RoleVo } from "../sharedata/RoleVo"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { SetSizeDelta, SetAnchoredPositionX, GlobalTimerQuest, Util, SetSizeDeltaX } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { RoleManager } from "../commonModel/RoleManager"
import { RolePropertyItemRenderer } from "./RolePropertyItemRenderer"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { DsgtModel } from "../commonModel/DsgtModel"
// import { DsgtWindowView } from "../dsgt/DsgtWindowView"
import { MedalModel } from "../commonModel/MedalModel"
// import { FashionConcroller } from "../commonController/FashionConcroller"
import { FashionModel } from "../commonModel/FashionModel"
import { achvModel } from "../commonModel/achvModel"
import { DressModel, DressEvent } from "../commonModel/DressModel"
import { SoundManager } from "../common/SoundManager"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { MainRoleVo } from "../sharedata/MainRoleVo"
import { EquipSuitBaseView } from "../suit/EquipSuitBaseView"
import { SuitModel, SuitModelEvent } from "../commonModel/SuitModel"
import { PlatformManager } from "../PlatformManager"



export class EquipmentView extends BaseItem1 {
	Image_middle: Laya.Image
	Image_right: Laya.Image
	_img_bg_info: Laya.Image
	model_bg: Laya.Image
	name_bg: Laya.Image
	main_role: Laya.Box
	top_levelLb: Laya.Label
	_lb_name: Laya.Label
	model_gp: Laya.Box
	_gp_fight: Laya.VBox
	_gp_attribute: Laya.Box
	_btn_attribute: Laya.Image
	attribute_red: Laya.Image
	_Image1: Laya.Image
	secondary_menu: Laya.Box
	icon_gp: Laya.Box
	_Group1: Laya.Image
	skill_red: Laya.Image
	fashion_gp: Laya.Image
	fashion_red: Laya.Image
	_Group2: Laya.Image
	achv_red: Laya.Image
	_Group3: Laya.Image
	medal_red: Laya.Image
	_Group4: Laya.Image
	dsgt_red: Laya.Image
	_Group5: Laya.Image
	suit_red: Laya.Image
	_Group6: Laya.Image
	unreal_red: Laya.Image
	// _Image2: Laya.Image
	_gp_fame: Laya.Box
	_btn_fame: Laya.Image
	_red_fame: Laya.Image
	// _Image3: Laya.Image
	// _Image4: Laya.Image
	// _Image5: Laya.Image
	_Image6: Laya.Image
	// Img1: Laya.Image
	expImg: Laya.Image
	nomalShow: Laya.Image
	nomalHide: Laya.Image
	bestShow: Laya.Image
	bestHide: Laya.Image
	worldBtn: Laya.Image
	nomalLb: Laya.Label
	bestLb: Laya.Label
	Image: Laya.Image
	_Group7: Laya.HBox
	destiny_img: Laya.Image
	levelLb: Laya.Label
	expLb: Laya.Label
	_Scroller1: Laya.List
	worldGp: Laya.Box
	worldBg: Laya.Image
	worldTips: Laya.Label
	worldLb: Laya.HTMLDivElement
	tipsImg: Laya.Image


	Imafashion_gp
	model
	ord_show_index
	Ima_Group2
	second_tab_btn_list
	bestLb_line
	ReOpen_callback
	second_tab_img_list
	spe_data
	ord_data
	Ima_Group3
	prop_loop_mgr
	modelGp
	Scr_Scroller1
	Ima_Group1
	propGp
	Ima_Group4
	Ima_Group5
	role_model
	spe_arr
	goods_model
	curr_sorting_order
	story_obj_list
	EmpworldGp
	nomalLb_line
	fight_num
	spe_show_index
	attr_cfg
	propType
	second_view_list
	Ima_Group6
	limit_cfg
	mainVo: MainRoleVo
	Content

	channel
	public constructor(parent) {
		super(parent)

		this.fight_num = null
		this.second_view_list = []
		this.second_tab_btn_list = [] // 二级菜单obj
		this.second_tab_img_list = [] // 二级菜单img组件
		this.role_model = null // 人物模型
		this.attr_cfg = null
		this.limit_cfg = null
		this.model = EquipModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.spe_arr = null
		this.ord_data = []
		this.spe_data = []
		this.ord_show_index = [1, 2, 3, 4, 5, 6, 7, 8, 15, 16, 46, 47, 18]
		this.spe_show_index = [9, 10, 27, 28, 84, 85, 11, 12, 13, 14, 17, 45, , 53, 54, 19, 20, 21, 22, 23, 24, 25, 26, 37, 38, 43, 44, 55, 56, 39, 42]
		this.propType = 1
		this.layer_value = "UI"
		this.base_file = "role"
		this.layout_file = "EquipmentView"
		this.dependent_res = ["mainUI", "role"]
		this.is_delay_callback = true
		this.load_callback = () => {
			if(PlatformManager.IsEyouPlatform()){
				this.bestLb.x = 365
				this.bestLb.width = 186
				this.nomalLb.x = 170
				this.nomalLb.width = 186
			}
			this.InitEvent()
			this.InitView()
			this.CreateModel()
			this.AddVolce()
		}
		this.ReOpen_callback = () => {
			this.CreateModel()
		}

	}


	public InitEvent() {

		this.attr_cfg = ResManager.GetInstance().LoadGameConfig(this, "config_equip_attr")
		this.limit_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "Equipstrengthenmax", false)

		this.BindEvent(this.goods_model, GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			if (this.use_delete_method) {
				return
			}
			let keyBreak = false
			let AttributBreak = false
			for (let _tmpi in goods_list) {
				var v = goods_list[_tmpi]
				let basic = this.goods_model.GetGoodsBasicByTypeId(v.type_id)
				if ((basic && basic.type == 56) && !keyBreak) {
					this.showAttributRedDot()
					AttributBreak = true
				}
				if (keyBreak && AttributBreak) {
					break
				}
			}
		}
		)

		//时装刷新
		this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "fashion_model_list", () => {
			this.CreateModel()
		}
		)

		//套装刷新
		this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "suit_fashion_id", () => {
			this.CreateModel()
		}
		)

		//天启刷新
		this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "revelation_suit", () => {
			this.CreateModel()
		}
		)

		//时装刷新
		this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), RoleVo.FIGURE_CHANGE, (figure_type?, figure_id?) => {
			if (figure_type == FigureProtoVo.FigureType.Wing || figure_type == FigureProtoVo.FigureType.Weapon || figure_type == 11 || figure_type == FigureProtoVo.FigureType.NewBackOrnament) {
				this.CreateModel()
			}
		}
		)


		this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "figure_list", () => {
			this.CreateModel()
		}
		)


		//时装
		let update_fashion_red = () => {
			this.ShowFahionDot()
		}
		this.BindEvent(FashionModel.GetInstance(), FashionModel.UPDATEVIEW, update_fashion_red)
		this.BindEvent(DressModel.GetInstance(), DressEvent.DRESS_UPDATE_RED_DOT, update_fashion_red)
		this.BindEvent(FashionModel.GetInstance(), FashionModel.SUIT_REFRESH_RED_FLAG, update_fashion_red)

		Util.AddClickEvent(this.fashion_gp, () => {
			GlobalEventSystem.Fire(EventName.SWITCH_ROLE_SECOND_BUTTON, EquipmentViewSecond_Menu_Type.Fashion)
		}, this, true)

		// 查看说明
		Util.AddClickEvent(this.tipsImg, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 453);
		}, this, true)

		//套装
		let update_suit_fun = () => {
			this.ShowSuitDot()
		}
		this.BindEvent(SuitModel.GetInstance(), SuitModelEvent.UP_SUIT_RED, update_suit_fun)

		//套装界面
		Util.AddClickEvent(this._Group5, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, EquipSuitBaseView._layout_file);
		}, this, true)

		let update_fighting = () => {
			this.fight_num.Updatefighting(String(RoleManager.GetInstance().GetMainRoleVo().fighting))
			// GlobalTimerQuest.AddDelayQuest(() => {
			// 	if (!this.use_delete_method) {
			// 		// LayoutRebuilder(this._gp_fight)
			// 	}
			// }, 0.1)
		}
		this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "fighting", update_fighting)

		//星座
		//this:BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT,(mType?, key?) => {
		//if (mType == ModuleType.CONSTELLATION ) {
		//this:ShowConstellationRedDot()
		//}
		//}
		//)

		//药水
		Util.AddClickEvent(this._btn_attribute, () => {
			let attModel = attributePotionModel.GetInstance()
			let index = 1
			let tabList = attModel.tabList
			for (let key in tabList) {

				if (tabList[key] != null) {
					let info = tabList[key]
					if (attModel.tabRedDot(info.level)) {
						index = info.level
						break
					}
				}
			}
			GlobalEventSystem.Fire(EventName.OPEN_ATTRIBUTEPOTION_VIEW, index)
		}
			, this, true)


		//药水
		this.BindEvent(attributePotionModel.GetInstance(), attributePotionModel.TIME_DATA_RETURN, () => {
			this.showAttributRedDot()
		}
		)

		//魅力
		Util.AddClickEvent(this._btn_fame, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageHonourView")
		}
			, this, true)

		//剧情
		//this:BindEvent(TaskModel.GetInstance(), TaskModel.UPDATE_NEWEST_TASK_ID, func?tion(func?){
		//if (this.use_delete_method ) {
		//return
		//}
		//this:UpdateSecondMenuState()
		//}
		//)

		//等级
		this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, () => {
			let lv = RoleManager.GetInstance().mainRoleInfo.level
			let is_show_destiny
			if (lv > 370) {
				is_show_destiny = true
				this.destiny_img.visible = true
			} else {
				is_show_destiny = false
				this.destiny_img.visible = false
			}
			// if(lv > 370){
			// 	this._lb_name.text = "神创Lv." + (lv-370) + " " + RoleManager.GetInstance().GetMainRoleVo().name
			// }else{
			this._lb_name.text = RoleManager.GetInstance().GetMainRoleVo().name
			// }
			let level = lv > 370 && lv - 370 || lv
			// SetSizeDeltaX(this.destiny_img, lv > 370 && 26 || 0)
			this.levelLb.text = level + "级"
			if (is_show_destiny) {
				this.destiny_img.width = 24
			} else {
				this.destiny_img.width = 0
			}
		}
		)

		//属性列表
		this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.UPDATE_MAIN_ROLE_INFO_VIEW, () => {
			this.UpdataProperty(this.propType)
		}
		)

		Util.AddClickEvent(this.bestHide, () => {
			// this.prop_loop_mgr.DeleteMe()
			// this.prop_loop_mgr = null
			this.InitAttr(2)
		}
			, this, true)
		Util.AddClickEvent(this.nomalHide, () => {
			// this.prop_loop_mgr.DeleteMe()
			// this.prop_loop_mgr = null
			this.InitAttr(1)
		}
			, this, true)

		Util.AddClickEvent(this.worldGp, () => {
			this.worldGp.visible = false
		}
			, this, false)

		let main_vo = RoleManager.GetInstance().GetMainRoleVo()
		let onExpChange = () => {
			this.SetExp()
		}
		Util.AddClickEvent(this.bestLb, () => {
			this.InitAttr(2)
		}, this, false)
		Util.AddClickEvent(this.nomalLb, () => {
			this.InitAttr(1)
		}, this, false)

		this.BindVar(main_vo, "exp", onExpChange)

		let OnLevelChange = () => {
			this.InitRoleInfo()
		}
		this.BindVar(main_vo, "level", OnLevelChange)

		let worldExp = () => {
			let roleVo = RoleManager.GetInstance().GetMainRoleVo()
			let lv = roleVo.worldLv > 370 && "神创" + (roleVo.worldLv - 370) || roleVo.worldLv
			this.worldLb.width = 276
			this.worldLb.innerHTML = Util.StrToHTML("世界等级:<font color='#96ff25'>" + lv + "</font>级<br/>经验加成:<font color='#96ff25'>" + roleVo.worldLvExp + "%</font>")
		}
		this.BindVar(main_vo, "worldLv", worldExp)
		this.BindVar(main_vo, "worldExp", worldExp)
		Util.AddClickEvent(this.worldBtn, () => {
			this.worldGp.visible = true
			worldExp()
		}, this, true)

		//称号
		this.BindEvent(DsgtModel.GetInstance(), DsgtModel.DSGT_RED, () => {
			this.ShowDsgtRed()
		}
		)

		//成就
		this.BindVar(achvModel.GetInstance(), "ShowRed", () => {
			this.achv_red.visible = achvModel.GetInstance().ShowRed
		}
		)

		Util.AddClickEvent(this._Group2, () => {
			achvModel.GetInstance().Fire(achvModel.OP_V, "AchvEnterView")
		}
			, this, true)

		//勋章
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (mType?, key?) => {
			if (mType == ModuleType.MEDAL || mType == ModuleType.MEDAL_STRENGTHEN) {
				this.ShowMedalRed()
			}
		}
		)

		// 技能
		this.BindEvent(SkillUIModel.GetInstance(), SkillUIModel.UPDATE_RED_DOT, () => {
			this.ShowSkillRed()
		}
		)


		Util.AddClickEvent(this._Group3, () => {
			GlobalEventSystem.Fire(EventName.OPEN_MEDAL_ENTER_VIEW);
		}
			, this, true)

		//技能
		// this.BindEvent(SkillUIModel.GetInstance(), SkillUIModel.UPDATE_RED_DOT,() => {
		// 		this.ShowSkillRed()
		// 	}
		// )

		//技能强化
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (mType?, key?) => {
			if (mType != ModuleType.SKILL_STREN) {
				return
			}
			this.ShowSkillRed()
		}
		)

		//主动技能红点
		this.BindEvent(SkillUIModel.GetInstance(), SkillUIModel.UPDATE_SKILL_VIEW_RED, (viewClass?) => {
			if (viewClass == "InnateSkillView") {
				this.ShowSkillRed()
			}
		}
		)

		//远古奥术技能红点
		//this:BindEvent(SkillUIModel.GetInstance(), SkillUIModel.FORBIDDEN_SKILL_UPDATE_RED_DOT,() => {
		//this:ShowSkillRed()
		//}
		//)
		//技能界面
		Util.AddClickEvent(this._Group1, () => {
			GlobalEventSystem.Fire(EventName.SWITCH_ROLE_SECOND_BUTTON, EquipmentViewSecond_Menu_Type.Skill, 0)
		}, this, true)
		//称号界面
		Util.AddClickEvent(this._Group4, () => {
			DsgtModel.GetInstance().Fire(DsgtModel.DSGT_OPEN_VIEW, "DsgtWindowView")
		}, this, true)

		this.BindEvent(GlobalEventSystem, EventName.CHANGE_CUR_VIEW_COUNT, () => {
			if (Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)) {
				if (this.channel) {
					SoundManager.GetInstance().StopSoundEffect(this.channel)
					this.channel = null
				}
			}
		});

	}

	public InitView() {

		this.fight_num = new FightingShowSmallItem(this._gp_fight)
		this.fight_num.Load()
		this.fight_num.Updatefighting(String(RoleManager.GetInstance().GetMainRoleVo().fighting))
		this.fight_num.IsCenter(true, false)
		for (let key in EquipmentViewSecond_Menu_Type) {

			let i = EquipmentViewSecond_Menu_Type[key]

			let second_sub_btn = this.second_tab_btn_list[i]
			let switch_second_tab = () => {
				OpenFun.OpenFunHandler(EquipmentViewSecond_Open_Id[i])
			}
			Util.AddClickEvent(second_sub_btn, switch_second_tab, this, true)

		}

		this.ShowFahionDot()
		this.ShowAchvRed()
		this.ShowMedalRed()
		this.ShowDsgtRed()
		//this:ShowConstellationRedDot()
		this.ShowSuitDot()
		this.showAttributRedDot()
		this.ShowSkillRed()
		this.UpdateSecondMenuState()
		this.InitAttr(1)
		this.SetExp()
		this.InitRoleInfo()

		ResManager.GetInstance().SetOutsideImageSprite(this, this.Image_middle, "resource/game/role/texture/ui_role_01.png")
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.Image_right, "resource/game/role/uirwv4_003b.png")
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.model_bg, "resource/game/role/texture/ui_bg_2.png", true)
		ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, "resource/game/role/texture/ui_rw_basal_05.png", true)
		// ResManager.GetInstance().SetImageSpriteTrans(this, this._Image2, "resource/game/role/texture/ui_role_02.png")
		ResManager.GetInstance().SetImageSpriteTrans(this, this.name_bg, "resource/game/role/texture/role_namebg.png")
		//lua_resM:SetOutsideImageSprite(this, this.Img1, "client/assets/icon/role/uirwv4_024.png")
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.Image_middle, "client/assets/icon/role/uirwv4_003b.png")
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.Image_right, "client/assets/icon/role/uirwv4_003b.png")
	}

	public ShowFahionDot() {

		let bool = FashionModel.GetInstance().IsShowRed() 
			|| DressModel.GetInstance().DressCanShowRedDot()
			|| FashionModel.GetInstance().GetSuitRedState()
		this.fashion_red.visible = bool
	}

	public ShowMedalRed() {

		let bool = MedalModel.GetInstance().CheckRedStatus(ModuleType.MEDAL, 1)
			|| MedalModel.GetInstance().CheckRedStatus(ModuleType.MEDAL_STRENGTHEN, 1)
			|| MedalModel.GetInstance().CheckTitleRedDot()
		this.medal_red.visible = bool
	}

	public ShowDsgtRed() {
		let bool = DsgtModel.GetInstance().ShowRedIcon()
		this.dsgt_red.visible = bool
	}

	public ShowAchvRed() {
		let bool = achvModel.GetInstance().ShowRed
		this.achv_red.visible = bool
	}

	public ShowSuitDot() {
		// let bool = EquipModel.GetInstance().GetAllRedStatusPower()
		let bool = SuitModel.GetInstance().GetSuitTotlaRed();
		this.suit_red.visible = bool
	}

	public showAttributRedDot() {
		let bool = attributePotionModel.GetInstance().GetattributePotionRed()
		this.attribute_red.visible = bool
	}

	public ShowSkillRed() {
		let bool = SkillUIModel.GetInstance().GetSkillRedDot()
			|| RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.SKILL_STREN)
			|| SkillUIModel.GetInstance().GetInnateRed()
			|| SkillUIModel.GetInstance().GetForbiddenSkillRedDot()
		this.skill_red.visible = bool
	}

	public SetExp() {

		let main_vo = RoleManager.GetInstance().GetMainRoleVo()
		let persent = main_vo.exp / main_vo.exp_lim
		this.expLb.text = WordManager.ConvertNum(main_vo.exp, true) + "/" + WordManager.ConvertNum(main_vo.exp_lim, true)
		if (persent >= 1) {
			this.expImg.width = 360
		} else {
			this.expImg.width = 360 * persent
		}

		// this.expImg.fillAmount = Mathf.Min(persent, 1)
	}

	public DeleteMe() {

		this.ClearModel()
		if (this.prop_loop_mgr) {
			this.prop_loop_mgr.DeleteMe()
		}
		if (this.fight_num) {
			this.fight_num.DeleteMe()
			this.fight_num = null
		}
		this.prop_loop_mgr = null
		this.limit_cfg = null
		this.attr_cfg = null
		super.DeleteMe()
	}

	public SelectProp(type?) {

		if (type == null) {
			type = 1
		}
		//let a = this.Scr_Scroller1.verticalNormalizedPosition
		//this.Scr_Scroller1.verticalNormalizedPosition = 1
		if (type == 1) {
			// this.nomalLb_line.visible = true
			// this.bestLb_line.visible = false
			this.bestHide.visible = true
			this.nomalShow.visible = true
			this.bestShow.visible = false
			this.nomalHide.visible = false
			// this.nomalLb.strokeColor = ColorUtil.TryParseHtmlString("#A57F61")
			this.nomalLb.color = ColorUtil.TryParseHtmlString("#9B572F")
			this.bestLb.color = ColorUtil.TryParseHtmlString("#fff5f1")
			// this.bestLb.strokeColor= ColorUtil.TryParseHtmlString("#FFFFFF")
			//this.bestLb_line.effectColor = ColorUtilValue.UNSELECT_LINE
		} else {
			// this.nomalLb_line.enabled = false
			// this.bestLb_line.enabled = true
			this.bestShow.visible = true
			this.nomalHide.visible = true
			this.bestHide.visible = false
			this.nomalShow.visible = false
			//this.nomalLb_line.effectColor = ColorUtilValue.UNSELECT_LINE
			// this.bestLb.strokeColor = ColorUtil.TryParseHtmlString("#A57F61")
			this.nomalLb.color = ColorUtil.TryParseHtmlString("#fff5f1")
			this.bestLb.color = ColorUtil.TryParseHtmlString("#9B572F")
			// this.nomalLb.strokeColor = ColorUtil.TryParseHtmlString("#FFFFFF")
			Laya.Label
		}
		this.UpdataProperty(type)
	}

	public UpdateSecondMenuState() {

		for (let key in EquipmentViewSecond_Menu_Type) {

			let i = EquipmentViewSecond_Menu_Type[key]
			let second_btn_img = this.second_tab_img_list[i]
			if (second_btn_img) {
				Laya.UIUtils.gray(second_btn_img, !this.GetSecondMenuOpenCond[i])// Util.SetImageGray(second_btn_img, !this.GetSecondMenuOpenCond(i))
			}

		}
	}

	public GetSecondMenuOpenCond(func?) {

		let bool = false
		if (EquipmentViewSecond_Menu_Type.Skill == func) {
			bool = true
		} else if (EquipmentViewSecond_Menu_Type.Achv == func) {
			bool = CommonManager.GetInstance().CheckFuncOpenState("AchvEnterView", true)
		} else if (EquipmentViewSecond_Menu_Type.Medal == func) {
			bool = CommonManager.GetInstance().CheckFuncOpenState("MedalView", true)
		} else if (EquipmentViewSecond_Menu_Type.Dsgt == func) {
			bool = CommonManager.GetInstance().CheckFuncOpenState("DsgtView", true)
		} else if (EquipmentViewSecond_Menu_Type.Fashion == func) {
			bool = CommonManager.GetInstance().CheckFuncOpenState("FashionBaseView", true)
		} else if (EquipmentViewSecond_Menu_Type.Suit == func) {
			bool = CommonManager.GetInstance().CheckFuncOpenState("EquipSuitBaseView", true)
		}
		else if (EquipmentViewSecond_Menu_Type.Unreal == func) {
			bool = CommonManager.GetInstance().CheckFuncOpenState("UnrealEnterView", true)
		}
		return bool
	}

	//属性列表初始化
	public InitAttr(type?) {
		if (!this.prop_loop_mgr) {
			this.prop_loop_mgr = new LoopScrowViewMgr()
			this.prop_loop_mgr.SetData(this._Scroller1, RolePropertyItemRenderer, this.ord_data, LoopScrCon.Vertical, 2)
			// this._Scroller1.elasticEnabled=true
		}

		this.SelectProp(type)
	}

	// 1 普通属性 2 极品属性
	public UpdataProperty(type?) {

		this.propType = type || 1
		this.ord_data = []
		this.spe_data = []
		let role_vo = RoleManager.GetInstance().GetMainRoleVo()
		let attr_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
		let propList = this.ord_show_index
		if (type == 2) {
			propList = this.spe_show_index
		}
		for (let _tmpi in propList) {
			var vo = propList[_tmpi]
			let cfg = attr_cfg[vo]
			if (cfg && cfg.mainvo_str) {
				if (cfg.kind == 2) {
					table.insert(this.ord_data,
						{
							attr: WordManager.GetProperties(vo),
							value: (Number(role_vo[cfg.mainvo_str]) == 0 ? 0 : Number(Math.floor(role_vo[cfg.mainvo_str] + 0.5) / 100)) + "%"// Number(role_vo[cfg.mainvo_str] + 0.5).toFixed(2)) + "%"//
						})
				} else {
					table.insert(this.ord_data,
						{
							attr: WordManager.GetProperties(vo),
							value: WordManager.ConvertToPercentValue(vo, role_vo[cfg.mainvo_str])
						})
				}
			}
		}
		// this.Content.scrollV = 0
		// this._Scroller1.repeatY=this.ord_data.length/2
		//刷新数据源
		this.prop_loop_mgr.replaceAll(this.ord_data)
	}


	public InitRoleInfo() {

		let info = RoleManager.GetInstance().mainRoleInfo
		let is_show_destiny
		if (info.level > 370) {
			is_show_destiny = true
			this.destiny_img.visible = true
		} else {
			is_show_destiny = false
			this.destiny_img.visible = false
		}
		let level = info.level > 370 && info.level - 370 || info.level
		this._lb_name.text = RoleManager.GetInstance().GetMainRoleVo().name
		this.levelLb.text = level + "级"
		if (is_show_destiny) {
			this.destiny_img.width = 24
		} else {
			this.destiny_img.width = 0
		}
	}

	public CreateModel() {
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
			scale: 0.73,
			position: new Vector3(0, 2, 0),
			enableHDR:true,

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
		ResManager.GetInstance().SetRoleModel(this, this.model_gp, data)
	}

	public ClearModel() {

		if (!this.role_model) {
			return
		}
		this.role_model.DeleteMe()
		this.role_model = null
	}
	public AddVolce() {
		let vo = RoleManager.GetInstance().GetMainRoleVo()
		let career = vo.career
		let volume
		switch (career) {
			case 1:
				volume = "boy_show1"
				break;
			case 2:
				volume = "girl_show1"
				break;
			case 3:
				volume = "boy_show2"
				break;
			case 4:
				volume = "girl_show2"
				break;
		}
		this.channel = SoundManager.GetInstance().PlaySoundEffect(volume, true, null, "role")
	}


	// this.second_tab_btn_list = [
	// 	 this._Group1,
	// 	 this.fashion_gp,
	// 	 this._Group2,
	// 	 this._Group3,
	// 	 this._Group4,
	// 	 this._Group5,
	// 	 this._Group6
	// ] // 二级菜单obj
	// this.second_tab_img_list = [
	// 	 this.Ima_Group1,
	// 	 this.Imafashion_gp,
	// 	 this.Ima_Group2,
	// 	 this.Ima_Group3,
	// 	 this.Ima_Group4,
	// 	 this.Ima_Group5,
	// 	 this.Ima_Group6,
	// ] // 二级菜单img组件


	public GetComponents() {
		[
			this.Image_middle,
			this.Image_right,
			this._img_bg_info,
			this.model_bg,
			this.name_bg,
			this.main_role,
			this.top_levelLb,
			this._lb_name,
			this.model_gp,
			this._gp_fight,
			this._gp_attribute,
			this._btn_attribute,
			this.attribute_red,
			this._Image1,
			this.secondary_menu,
			this.icon_gp,
			this._Group1,
			this.skill_red,
			this.fashion_gp,
			this.fashion_red,
			this._Group2,
			this.achv_red,
			this._Group3,
			this.medal_red,
			this._Group4,
			this.dsgt_red,
			this._Group5,
			this.suit_red,
			this._Group6,
			this.unreal_red,
			// this._Image2,
			this._gp_fame,
			this._btn_fame,
			this._red_fame,
			// this._Image3,
			// this._Image4,
			// this._Image5,
			this._Image6,
			// this.Img1,
			this.expImg,
			this.nomalShow,
			this.nomalHide,
			this.bestShow,
			this.bestHide,
			this.worldBtn,
			this.nomalLb,
			this.bestLb,
			this.Image,
			this._Group7,
			this.destiny_img,
			this.levelLb,
			this.expLb,
			this._Scroller1,
			this.worldGp,
			this.worldBg,
			this.worldTips,
			this.worldLb,
			this.tipsImg,
		]
			= this.GetChildrenByNames([

				"Image_middle",
				"Image_right",
				"_img_bg_info",
				"model_bg",
				"name_bg",
				"main_role",
				"top_levelLb",
				"_lb_name",
				"model_gp",
				"_gp_fight",
				"_gp_attribute",
				"_btn_attribute",
				"attribute_red",
				"_Image1",
				"secondary_menu",
				"icon_gp",
				"_Group1",
				"skill_red",
				"fashion_gp",
				"fashion_red",
				"_Group2",
				"achv_red",
				"_Group3",
				"medal_red",
				"_Group4",
				"dsgt_red",
				"_Group5",
				"suit_red",
				"_Group6",
				"unreal_red",
				// "_Image2",
				"_gp_fame",
				"_btn_fame",
				"_red_fame",
				// "_Image3",
				// "_Image4",
				// "_Image5",
				"_Image6",
				// "Img1",
				"expImg",
				"nomalShow",
				"nomalHide",
				"bestShow",
				"bestHide",
				"worldBtn",
				"nomalLb",
				"bestLb",
				"Image",
				"_Group7",
				"destiny_img",
				"levelLb",
				"expLb",
				"_Scroller1",
				"worldGp",
				"worldBg",
				"worldTips",
				"worldLb",
				"tipsImg",
			])
		this._Scroller1.scrollBar.visible = false
		this.worldLb.style.fontSize = 20
		this.worldLb.style.color = "#f5deac"
	}
}
window["EquipmentView"] = EquipmentView
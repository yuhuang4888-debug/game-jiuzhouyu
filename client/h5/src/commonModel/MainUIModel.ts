// console.warn("MainUIModel@CommonManager")
import { attributePotionModel } from "./attributePotionModel"
import { CommonManager } from "../common/CommonManager"
// console.warn("MainUIModel@Config")
import { Config } from "../common/Config"
// console.warn("MainUIModel@EventName")
import { EventName } from "../common/EventName"
// console.warn("MainUIModel@OpenFun")
import { OpenFun } from "../common/OpenFun"
// console.warn("MainUIModel@RedDotManager")
import { RedDotManager, ModuleType } from "../common/RedDotManager"
// console.warn("MainUIModel@ViewManager")
import { ViewManager } from "../common/ViewManager"
// console.warn("MainUIModel@RoleManager")
import { RoleManager } from "./RoleManager"
// console.warn("MainUIModel@SceneManager")
import { SceneManager } from "../scene/SceneManager"
// console.warn("MainUIModel@DeclareGlobalVar")
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
// console.warn("MainUIModel@EventDispatcher")
import { EventDispatcher } from "../util/EventDispatcher"
// console.warn("MainUIModel@TimeUtil")
import { TimeUtil } from "../util/TimeUtil"
// console.warn("MainUIModel@BagModel")
import { BagModel } from "./BagModel"
// console.warn("MainUIModel@EquipModel")
import { EquipModel, EquipEvent } from "./EquipModel"
// console.warn("MainUIModel@GoodsModel")
import { GoodsModel } from "./GoodsModel"
// console.warn("MainUIModel@GuardModel")
import { GuardModel } from "./GuardModel"
import { HolySealModel } from "./HolySealModel"
import { OutWardBaseModel } from "./OutWardBaseModel"
// console.warn("MainUIModel@RevelationModel")
import { RevelationModel } from "./RevelationModel"
// console.warn("MainUIModel@RoleModel")
import { RoleModel } from "./RoleModel"
import { RuneModel } from "./RuneModel"
import { SkillUIModel } from "./SkillUIModel"
// console.warn("MainUIModel@StoryModel")
import { StoryModel } from "./StoryModel"
import { MedalModel } from "./MedalModel"
import { PetEquipModel } from "./PetEquipModel"
import { MonBookModel } from "./MonBookModel"
import { DsgtModel } from "./DsgtModel"
import { PartnerModel } from "./PartnerModel"
import { FashionModel } from "./FashionModel"
import { PartnerAwakeModel } from "./PartnerAwakeModel"
import { achvModel } from "./achvModel"
import { GodBeastModel } from "./GodBeastModel"
import { DressModel } from "./DressModel"
import { UnrealModel } from "./UnrealModel"
import { DemonModel } from "./DemonModel"
import { GodBefallModel } from "./GodBefallModel"
import { GuildModel } from "./GuildModel"
import { RedPacketModel } from "./RedPacketModel"
import { MarriageRedList } from "./MarriageModel"
import { CompositeModel, CompositeEvent } from "./CompositeModel"
import { ArmorModel } from "./ArmorModel"
import { BabyModel } from "./BabyModel"
import { StarEquipModel } from "./StarEquipModel"
import { EternityModel } from "./EternityModel"
import { GodCourtModel } from "./GodCourtModel"
import { MaskModel } from "./MaskModel"
import { table } from "../common/table"
import { FuncBoardView } from "../mainUI/FuncBoardView"
import { CookieWrapper } from "../common/CookieWrapper"
import { TempleAwakenModel } from "./TempleAwakenModel"
import { BossModel } from "./BossModel"
import { ErlangParser } from "../util/ErlangParser"
import { GuildFightModel } from "./GuildFightModel"
import { WordManager } from "../common/WordManager"
import { VipModel } from "./VipModel"
import { Trim, Util } from "../util/Util"
import { ReliveModel } from "./ReliveModel"
import { SkillManager } from "../skill/SkillManager"
import { WeekCardModel } from "./WeekCardModel"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"
import { SuitModel } from "./SuitModel"
import { LayerManager, Enum_UILayer } from "../common/LayerManager"
import { EyouThAdultItem } from "../mainUI/EyouThAdultItem"
import { PlatformManager } from "../PlatformManager"
// console.warn("MainUIModel")
export enum MainFunc {
	Role = 1,
	Bag = 2,
	Pet = 3,
	Equip = 4,
	Treasure = 5,
	Red = 6,
	Love = 7,
	Guild = 8,
	Composite = 9,
	Help = 10
}
window["MainFunc"] = MainFunc

export class MainUIModel extends EventDispatcher {
	public static Shield_Buff_list = { "21000001": true }
	public static Main_Func_Icons = [
		[
			{
				func: MainFunc.Role,
				res: "role",
				story_arr: [StoryModel.StoryTargetName.RoleIcon]
			},
			{
				func: MainFunc.Bag,
				res: "bag",
				story_arr: [StoryModel.StoryTargetName.BagIcon]
			},
			{
				func: MainFunc.Pet,
				res: "pet",
				story_arr: [StoryModel.StoryTargetName.PetIcon]
			},
			{
				func: MainFunc.Equip,
				res: "equip",
				story_arr: [StoryModel.StoryTargetName.ForgingIcon]
			},
			{
				func: MainFunc.Treasure,
				res: "treasure",
				story_arr: [StoryModel.StoryTargetName.MallIcon]
			}
		],
		[
			{
				func: MainFunc.Red,
				res: "red",
				story_arr: [StoryModel.StoryTargetName.RedIcon]
			},
			{
				func: MainFunc.Love,
				res: "love",
				story_arr: []
			},
			{
				func: MainFunc.Guild,
				res: "guild",
				story_arr: [StoryModel.StoryTargetName.GuildIcon]
			},
			{
				func: MainFunc.Composite,
				res: "composite",
				story_arr: []
			},
			{
				func: MainFunc.Help,
				res: "232",
				story_arr: [StoryModel.StoryTargetName.FriendIcon]
			}
		]
	]

	public static UPDATE_ACTIVITY_STATE = "MainUIModel.ACTIVITY_ICON_STATE"
	public static CHANGE_ACTIVITY_STATE = "MainUIModel.CHANGE_ACTIVITY_STATE"
	public static REFRESH_FRIEND_AND_MAIL_RED = "REFRESH_FRIEND_AND_MAIL_RED"
	public static RESET_TEAM_POS = "RESET_TEAM_POS"
	public static ACTIVE_SKILL = "ACTIVE_SKILL"
	public static SHOW_FUNC_BOARD_VIEW = "SHOW_FUNC_BOARD_VIEW" //功能性提示小弹窗（目前只做了觉醒神殿）
	public static UPDATE_MAINUI_CHAT_VIEW = "UPDATE_MAINUI_CHAT_VIEW"
	public static UPDATE_SECONDARY_ICON = "UPDATE_SECONDARY_ICON"
	public static UPDATE_TASK_VIEW_CACHE_AS_STATE = "UPDATE_TASK_VIEW_CACHE_AS_STATE"

	public static DefaultOpenRedViewLv = 160
	public static Move_Time_Interval = 0.2
	public static Turn_Open_lv = 65
	static Instance: any

	role_mgr: RoleManager = RoleManager.GetInstance()
	common_mgr: CommonManager = CommonManager.GetInstance()
	goods_model: GoodsModel = GoodsModel.GetInstance()
	guild_fight_model: GuildFightModel = GuildFightModel.GetInstance()
	vip_model: VipModel = VipModel.GetInstance()
	mask_model: MaskModel = MaskModel.GetInstance()
	boss_model: BossModel = BossModel.GetInstance()
	guard_model: GuardModel = GuardModel.GetInstance()

	buff_list
	skill_buff = {}
	show_type = 0
	turn_red_dot = false
	friend_red = false
	has_loaded_mainui_callback = false
	activity_icon_in_show = true
	big_blood_in_show = false
	loaded_mainui_callback
	refresh_buff_id
	refresh_buff_time_id
	hale_red_show

	mainui_loaded_flag = {
		MainUITopViewSkin: false,
		MainUIActivityViewSkin: false,
		MainUISecondaryViewSkin: false,
		MainUIChatViewExml: false,
		MainUIDownViewSkin: false
	}
	main_ui_view_ref_dic = []

	SetLoadedMainUICallback
	FindIconInLineNo
	GetTurnState
	SwitchView
	SetMainuiLoadedFlag
	GetIconPosInMainUIView
	RefreshTurnRed
	GetMainFuncOpenCond
	GetBuffDesc
	RefreshBuff
	CheckShowPkStatus
	GetMainFuncRedState
	GetSkillIconPosInMainUIView
	TryRefreshBuff
	SetSkillBuff
	DelSkillBuff
	DelAllSkillBuff
	GetSkillBuffDesc

	//越南18+
	_time_vn
	_box_vn:Laya.Box
	AddAdultFlag
	public constructor() {
		super()

		this.SetMainuiLoadedFlag = (layout_name?, value?, ref_tar?) => {
			this.main_ui_view_ref_dic[layout_name] = ref_tar
			for (let name in this.mainui_loaded_flag) {

				if (this.mainui_loaded_flag[name] == false) {
					return
				}
			}
			if (this.loaded_mainui_callback) {
				this.loaded_mainui_callback()
				this.has_loaded_mainui_callback = true
				this.loaded_mainui_callback = null
			}
		}

		//////////////////-SetLoadedMainUICallback//////////////////-
		this.SetLoadedMainUICallback = (func?) => {
			if (this.loaded_mainui_callback) {
				return
			}
			GlobalEventSystem.Fire(EventName.INIT_MAINUI_EVENT)
			this.loaded_mainui_callback = func
			this.SetMainuiLoadedFlag(null, true)
			setTimeout(() => {
				if (this.loaded_mainui_callback) {
					this.loaded_mainui_callback()
					this.has_loaded_mainui_callback = true
					this.loaded_mainui_callback = null
				}
			},
				5
			)
		}

		this.GetMainFuncOpenCond = (main_func?) => {
			let bool = false
			if (main_func == MainFunc.Role) {
				bool = true
			} else if (main_func == MainFunc.Bag) {
				bool = true
			} else if (main_func == MainFunc.Pet) {
				bool = this.common_mgr.CheckFuncOpenState("MountPetView", true)
			} else if (main_func == MainFunc.Equip) {
				bool = this.common_mgr.CheckFuncOpenState("EquipView", true)
			} else if (main_func == MainFunc.Treasure) {
				bool = this.common_mgr.CheckFuncOpenState("SecretTreasureMainView", true)
			} else if (main_func == MainFunc.Red) {
				bool = this.common_mgr.CheckFuncOpenState("RedEnterView", true)
			} else if (main_func == MainFunc.Love) {
				bool = this.common_mgr.CheckFuncOpenState("MarriageBaseView", true)
			} else if (main_func == MainFunc.Guild) {
				bool = this.common_mgr.CheckFuncOpenState("GuildJoinBaseView", true)
			} else if (main_func == MainFunc.Composite) {
				bool = this.common_mgr.CheckFuncOpenState("CompositeView", true)
			} else if (main_func == MainFunc.Help) {
				bool = this.common_mgr.CheckFuncOpenState("GodBefallMainView", true)
			}
			return bool
		}

		this.SwitchView = (func?, index?, back_id?) => {
			if (func == MainFunc.Role) {
				GlobalEventSystem.Fire(RoleModel.OPEN_CHOSE_ROLE_VIEW, index, back_id)
			} else if (func == MainFunc.Bag) {
				OpenFun.OpenFunHandler(105)
			} else if (func == MainFunc.Pet) {
				GlobalEventSystem.Fire(EventName.SWITCH_MOUNT_PET_VIEW, index)
			} else if (func == MainFunc.Equip) {
				EquipModel.GetInstance().Fire(EquipEvent.OPEN_VIEW, "EquipView", index)
			} else if (func == MainFunc.Red) {
				CompositeModel.GetInstance().Fire(CompositeEvent.OPEN_RED_VIEW, index)
			} else if (func == MainFunc.Treasure) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SecretTreasureMainView", index)
			} else if (func == MainFunc.Love) {
				if (CommonManager.GetInstance().CheckFuncOpenState("BabyMainView", true)) {
					let open_state = ViewManager.GetInstance().GetViewOpenState("MainUIIconBoxView")
					if (open_state) {
						GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "MainUIIconBoxView")
					} else {
						let position = this.GetIconPosInMainUIView(2, MainFunc.Love, { x: 0, y: 0 }, { x: 0, y: 1 })
						if (position) {
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MainUIIconBoxView", "172", position, { x: -45, y: -182 }, 2)
						}
					}
				} else {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "MarriageBaseView")
				}
			} else if (func == MainFunc.Guild) {
				GuildModel.GetInstance().OpenGuildView(0)
			} else if (func == MainFunc.Composite) {
				CompositeModel.GetInstance().Fire(CompositeModel.OPEN_COMPOSITE_VIEW, index)
			} else if (func == MainFunc.Help) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "StarEquipMainView")
				// StarEquipModel.GetInstance().Fire(StarEquipModel.OPEN_VIEW, "StarEquipMainView")
			}
		}


		this.GetMainFuncRedState = (func?) => {
			let red_state = false
			if (func == MainFunc.Role) {
				red_state =
					DsgtModel.GetInstance().ShowRedIcon()
					|| FashionModel.GetInstance().IsShowRed()
					|| FashionModel.GetInstance().GetSuitRedState()
					// || EquipModel.GetInstance().GetAllRedStatusPower()
					|| SuitModel.GetInstance().GetSuitTotlaRed()
					|| SkillUIModel.GetInstance().GetSkillRedDot()
					|| OutWardBaseModel.GetInstance().ShowOutWardIconRed()
					// 	|| RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.SKILL_STREN)
					// 	//or RedDotManager.GetInstance().CheckRedStatus(ModuleType.CONSTELLATION) 
					// 	//or UnrealModel.GetInstance().GetIconRedDot() 
					|| attributePotionModel.GetInstance().GetattributePotionRed()
					// 	//or LightRulingModel.GetInstance().CheckRedStatus() 
					|| SkillUIModel.GetInstance().GetInnateRed()
					|| DressModel.GetInstance().DressCanShowRedDot()
					|| achvModel.GetInstance().ShowRed
					|| MedalModel.GetInstance().CheckRedStatus(ModuleType.MEDAL, 1)
					|| MedalModel.GetInstance().CheckRedStatus(ModuleType.MEDAL_STRENGTHEN, 1)
					// 	//or BackOrnamentModel.GetInstance().CheckBackDecorationRedDot() 
					|| MedalModel.GetInstance().CheckTitleRedDot()
					|| SkillUIModel.GetInstance().GetForbiddenSkillRedDot()
				// //or starEquipModel.GetInstance().GetRedDot() 
				// //or chcModel.GetInstance().GetReddotAll()
			} else if (func == MainFunc.Equip) {
				red_state =
					RedDotManager.GetInstance().CheckRedStatus(ModuleType.EQUIP_STREN)
					|| RedDotManager.GetInstance().CheckRedStatus(ModuleType.EQUIP_SMELT)
					|| RedDotManager.GetInstance().CheckRedStatus(ModuleType.EQUIP_JEWEL)
					|| EquipModel.GetInstance().GetEquipWashAllRed()
					|| RedDotManager.GetInstance().CheckRedStatus(ModuleType.JEWEL_CRAVE_RED)
					|| RedDotManager.GetInstance().CheckRedStatus(ModuleType.REFINEMENT_RED)
					|| ArmorModel.GetInstance().GetRedDot()
					|| EquipModel.GetInstance().CheckMasterRed(1)
					|| EquipModel.GetInstance().CheckMasterRed(3)
			} else if (func == MainFunc.Composite) {
				red_state = CompositeModel.GetInstance().isShowRed()
			} else if (func == MainFunc.Treasure) {
				red_state = RuneModel.GetInstance().ShowRuneRedDot() ||
					MonBookModel.GetInstance().IsShowIconDot() ||
					RedDotManager.GetInstance().CheckRedStatus(ModuleType.LUNG_DOT) ||
					RedDotManager.GetInstance().CheckRedStatusMultModule(GodBeastModel.RED_TYPES) ||
					RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.BEAST_REPLACE) ||
					GodBeastModel.GetInstance().beastComRed ||
					RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.BEAST_STREN) ||
					UnrealModel.GetInstance().GetIconRedDot()||
					RedDotController.ins.get(RedKey.GOD_BEAST_MIJUAN)
					||CompositeModel.GetInstance().GetUnrealRedDot()
				// 	// RedDotManager.GetInstance().CheckRedStatusMultModule(SoulModel.RedTypes) ||


			} else if (func == MainFunc.Help) {
				red_state = GodBefallModel.GetInstance().GetAllRedStatus() ||
					StarEquipModel.GetInstance().GetRedDot() ||
					GodCourtModel.GetInstance().ShowRed()
				// // FriendModel.GetInstance().emailRedDot || FriendModel.GetInstance().friendRedDot
			} else if (func == MainFunc.Guild) {
				red_state = RedDotController.ins.get(RedKey.GUILD);
			} else if (func == MainFunc.Bag) {
				red_state = BagModel.GetInstance().isShowRed()
					|| HolySealModel.GetInstance().GetRedState()
					|| RevelationModel.GetInstance().GetRedDot()
					|| (RedDotManager.GetInstance().GetRedStatus(ModuleType.LONGLANG) && RedDotManager.GetInstance().GetRedStatus(ModuleType.LONGLANG) != 0)
					|| CompositeModel.GetInstance().GetRevelationRedDot()

			} else if (func == MainFunc.Pet) {
				red_state = OutWardBaseModel.GetInstance().ShowHoresIconRed()
					|| PetEquipModel.GetInstance().GetAllRedStatus()
					|| DemonModel.GetInstance().GetRedState()
					|| PartnerModel.GetInstance().GetRed()
					|| PartnerAwakeModel.GetInstance().RedDotFun()
					|| PartnerModel.GetInstance().CheckAllCompanionRed()
			} else if (func == MainFunc.Love) {
				red_state = RedDotManager.GetInstance().CheckRedStatusMultModule(MarriageRedList)
					|| BabyModel.GetInstance().GetIconRed()
			} else if (func == MainFunc.Red) {
				red_state = CompositeModel.GetInstance().isRedShowRed()
			}
			return red_state
		}

		this.GetSkillIconPosInMainUIView = (skill_id?) => {
			let view = this.main_ui_view_ref_dic["MainUISkillView"]
			if (view) {
				return view.GetSkillPosById(skill_id)
			}
		}

		this.GetIconPosInMainUIView = (part?, icon_type?, centor_offset?, pivot_offset?) => {

			let pos = null
			if (part == 1 || part == 3) {
				let view = this.main_ui_view_ref_dic["MainUISecondaryView"]
				if (view) {
					pos = view.GetIconPos(String(icon_type), centor_offset, pivot_offset)
				}
			} else if (part == 2) {
				let view = this.main_ui_view_ref_dic["MainUIDownView"]
				if (view) {
					pos = view.GetIconPos(Number(icon_type), centor_offset, pivot_offset)
				}
			}

			return pos

		}

		this.RefreshTurnRed = () => {
			let index = this.show_type == 0 && 1 || 0
			let bool = false
			let data = MainUIModel.Main_Func_Icons[index]
			if (data) {
				for (let _tmpi in data) {
					var obj = data[_tmpi]
					if (this.GetMainFuncRedState(obj.func)) {
						bool = true
						break
					}
				}
			}
			this.ChangeVar("turn_red_dot", bool)
		}

		this.CheckShowPkStatus = () => {
			let scene_mgr = SceneManager.GetInstance()
			return scene_mgr.IsSuitBossScene() || scene_mgr.IsHolyBossScene() || scene_mgr.IsFieldBossScene() ||
				scene_mgr.IsAbyssBossScene() ||
				scene_mgr.IsHolyTerritory()
		}

		this.GetTurnState = () => {
			return RoleManager.GetInstance().GetMainRoleVo().level >= MainUIModel.Turn_Open_lv
		}

		this.FindIconInLineNo = (story_name?) => {
			let line_no = null
			if (story_name) {
				let icon_list = null
				for (let key in MainUIModel.Main_Func_Icons) {

					icon_list = MainUIModel.Main_Func_Icons[key]
					for (let _tmpi in icon_list) {
						var vo = icon_list[_tmpi]
						if (vo.story_arr) {
							for (let _tmpi in vo.story_arr) {
								var story = vo.story_arr[_tmpi]
								if (story == story_name) {
									line_no = key
									break
								}
							}
						}
					}
				}
			}
			return line_no
		}

		this.SetSkillBuff = (data) => {
			if (!data || Util.IsTableEmpty(data)) {
				return
			}

			let buff_cfgs = Config.PRELOAD_CLIENT_CONFIG.ClientBuffShow
			let change = false
			for (let i in data) {
				let vo = data[i]
				for (let j in vo) {
					let vo2 = vo[j]
					let cfg = buff_cfgs[vo2.iconType]
					let key = vo2.id + "_" + vo2.iconType
					if (cfg) {
						let skill_list = JSON.parse(cfg.skill_list)
						let have = false
						for (let k in skill_list) {
							if (skill_list[k] == vo2.id) {
								have = true
								break
							}
						}
						if (!this.skill_buff[key] && have) {
							let time = Math.floor(vo2.period / 1000) - TimeUtil.getServerTime()
							// console.warn("*********Buff Time:" + vo2.period)
							if (time > 0) {
								change = true
								this.skill_buff[key] = {
									id: vo2.iconType,
									skill: vo2.id,
									level: vo2.level,
									end_time: Math.floor(vo2.period / 1000)
								}
							}
						}
					}
				}
			}
			if (change) {
				this.RefreshBuff()
			}
		}

		this.DelSkillBuff = (key) => {
			if (this.skill_buff[key]) {
				delete this.skill_buff[key]
			}
			this.RefreshBuff()
		}
		this.DelAllSkillBuff = () => {
			for(let key in  this.skill_buff){
				delete  this.skill_buff[key]
			}
		}

		this.GetSkillBuffDesc = (val1, val2, cfg) => {
			let desc: string = cfg.desc
			let get_func = (val, cfg) => {
				let str
				if (cfg.spec && cfg.spec == 1) {
					val = val * 100
					str = val + "%"
				} else if (cfg.spec && cfg.spec == 2) {
					val = val / 100
					str = val + "%"
				} else {
					str = val.toString()
				}
				return str
			}
			let num1, num2
			if (val1 != 0 && val2 == 0) {
				num1 = get_func(val1, cfg)
				desc = desc.replace("{0}", num1)
			} else if (val1 == 0 && val2 != 0) {
				num1 = (val2 * 100) + "%"
				desc = desc.replace("{0}", num1)
			} else if (val1 != 0 && val2 != 0) {
				let desc1 = desc
				let desc2 = desc
				num1 = get_func(val1, cfg)
				num2 = (val2 * 100) + "%"
				desc = desc1.replace("{0}", num1) + "<br>" + desc2.replace("{0}", num2)
			}
			return desc
		}

		this.TryRefreshBuff = () => {
			if (this.refresh_buff_id) {
				return
			}
			// this.refresh_buff_id = setTimeout(() => {
			this.refresh_buff_id = undefined
			this.RefreshBuff()
			// }, 1000);
		}

		this.RefreshBuff = () => {
			let data_list = []
			let buff_cfgs = Config.PRELOAD_CLIENT_CONFIG.ClientBuffShow
			let next_refresh_time

			//世界等级
			if (this.role_mgr.GetMainRoleVo().worldLvExp && this.role_mgr.GetMainRoleVo().worldLvExp != 0) {
				let cfg = buff_cfgs["world"]
				if (cfg) {
					let str = cfg.desc
					let level = (this.role_mgr.GetMainRoleVo().worldLv > 370 && ("神创" + (this.role_mgr.GetMainRoleVo().worldLv - 370)) || (this.role_mgr.GetMainRoleVo().worldLv))
					str = cfg.desc.replace("worldlv", level)
					let data = {
						desc: str.replace("worldexp", this.role_mgr.GetMainRoleVo().worldLvExp),
						cfg: cfg
					}
					data_list.push(data)
				}
			}

			//物品buff
			let goods_buff_list = this.goods_model.goods_buff_list
			if (goods_buff_list && goods_buff_list.length > 0) {
				for (let i = 0; i < goods_buff_list.length; i++) {
					let buff_data = goods_buff_list[i]
					if (!MainUIModel.Shield_Buff_list[buff_data.goods_id]) {
						let data = {
							cfg: {
								name: "",
								icon: 0,
							}
						}
						let effect_cfgs = Config.PRELOAD_SERVER_CONFIG.config_goods_effect
						if (buff_data && buff_data.buff_type >= 0) {
							if (buff_data.buff_type == 0) {
								let goods_basic = this.goods_model.GetGoodsBasicByTypeId(buff_data.goods_id)
								if (goods_basic) {
									data.cfg.name = GoodsModel.GetGoodsName(goods_basic.type_id)
									data.cfg.icon = buff_data.goods_id
								}

								data["time"] = buff_data.time
								next_refresh_time = buff_data.time
								let str = null
								let effect_cfg = effect_cfgs && effect_cfgs[buff_data.goods_id]
								if (effect_cfg) {
									str = effect_cfg.desc
									data["desc"] = this.GetBuffDesc(str, ErlangParser.GetInstance().Parse(effect_cfg.effect_list))
								}
							} else if (buff_data.buff_type == 255) {
								if (buff_data.goods_id == 351100101) {
									let cfg = buff_cfgs["guildguard1"]
									if (cfg) {
										data.cfg.name = cfg.name
										data.cfg.icon = cfg.icon
										data["desc"] = cfg.desc
									}
								} else if (buff_data.goods_id == 351100102) {

									let cfg = buff_cfgs["guildguard2"]
									if (cfg) {

										data.cfg.name = cfg.name
										data.cfg.icon = cfg.icon
										data["desc"] = cfg.desc
									}
								}
							} else {
								let goods_basic = this.goods_model.GetGoodsBasicByTypeId(buff_data.goods_id)
								if (goods_basic) {
									data.cfg.name = GoodsModel.GetGoodsName(goods_basic.type_id)
									data.cfg.icon = GoodsModel.GetGoodsIcon(buff_data.goods_id)
								}
								data["time"] = buff_data.time
								next_refresh_time = buff_data.time
								let str = null
								let effect_cfg = effect_cfgs && effect_cfgs[buff_data.goods_id]
								if (effect_cfg) {
									str = effect_cfg.desc
									data["desc"] = this.GetBuffDesc(str, JSON.parse(effect_cfg.effect_list))
								}
							}
							data["end_time"] = TimeUtil.getServerTime() + data["time"]
							// 判断是否有暂停的Buff
							let effect_list = ErlangParser.GetInstance().Parse(buff_data.effect_list)
							for (let i in effect_list) {
								let vo = effect_list[i]
								if (vo[0] == "remain") {
									for (let j in vo[1]) {
										let remain_buff = vo[1][j]
										if (remain_buff) {
											let re_data = {
												cfg: {
													name: "",
													icon: 0,
												},
												remain: true
											}
											let basic = this.goods_model.GetGoodsBasicByTypeId(remain_buff[1])
											if (basic) {
												re_data.cfg.name = GoodsModel.GetGoodsName(basic.type_id)
												re_data.cfg.icon = GoodsModel.GetGoodsIcon(remain_buff[1])
											}

											let effect_cfg = effect_cfgs && effect_cfgs[remain_buff[1]]
											let str = null
											if (effect_cfg) {
												str = effect_cfg.desc
												re_data["desc"] = this.GetBuffDesc(str, JSON.parse(effect_cfg.effect_list))
											}
											data_list.push(re_data)
										}
									}
									break
								}
							}

							data_list.push(data)
						}
					}
				}
			}

			//公会战
			let config_guild_battle_buff = Config.PRELOAD_SERVER_CONFIG.config_guild_battle_buff
			if (((config_guild_battle_buff && SceneManager.GetInstance().IsGuildFightScene()) && this.guild_fight_model.GetWinData()) && this.guild_fight_model.GetWinData().winner != this.role_mgr.GetMainRoleVo().guild_id) {

				let cfg = buff_cfgs["guildfight"]
				if (cfg) {
					let win_time = this.guild_fight_model.GetWinData().win_num
					if (config_guild_battle_buff) {
						for (let key in config_guild_battle_buff) {
							if (config_guild_battle_buff[key].win_num1 <= win_time && win_time <= config_guild_battle_buff[key].win_num2) {

								let buff_attr = ErlangParser.GetInstance().Parse(config_guild_battle_buff[key].buff)
								if (buff_attr && buff_attr.length > 0) {
									let i = 0
									let str = ""
									do {
										if (i == buff_attr.length - 1) {
											str = str + WordManager.GetProperties(buff_attr[i][0]) + (" + ") + WordManager.ConvertToPercentValue(buff_attr[i][0], buff_attr[i][1])
										} else {
											str = str + WordManager.GetProperties(buff_attr[i][0]) + (" + ") + WordManager.ConvertToPercentValue(buff_attr[i][0], buff_attr[i][1]) + ","
										}
										i = i + 1
									} while ((i < buff_attr.length)
									)

									let data = {
										desc: cfg.desc.replace("<attr>", str),
										cfg: cfg
									}
									data_list.push(data)
									break
								}
							}
						}
					}
				}
			}

			//vip
			let config_num_by_vip = Config.PRELOAD_SERVER_CONFIG.config_num_by_vip,
				config_num_by_vip_info = Config.PRELOAD_SERVER_CONFIG.config_num_by_vip_info

			if (config_num_by_vip && config_num_by_vip_info) {
				let exp_key = "102@1@" + this.vip_model.GetNobleCardState() + "@" + this.role_mgr.GetMainRoleVo().vip_flag
				let vip_exp_cfg = config_num_by_vip[exp_key]
				let money_key = "102@2@" + this.vip_model.GetNobleCardState() + "@" + this.role_mgr.GetMainRoleVo().vip_flag
				let vip_money_cfg = config_num_by_vip[money_key]
				if (!vip_exp_cfg || vip_exp_cfg.num <= 0) {
					vip_exp_cfg = config_num_by_vip_info["102@1"]
				}
				if (!vip_money_cfg || vip_money_cfg.num <= 0) {
					vip_money_cfg = config_num_by_vip_info["102@2"]
				}
				if (vip_exp_cfg && vip_exp_cfg.num > 0 || vip_money_cfg && vip_money_cfg.num > 0) {
					let cfg = buff_cfgs["vip"]
					if (cfg) {
						let data = {
							desc: "",
							cfg: cfg
						}
						let str = null
						if (vip_exp_cfg && vip_exp_cfg.num > 0) {
							str = cfg.desc.replace("vipexp", vip_exp_cfg.num)
						} else {
							str = cfg.desc.replace("获得经验<font color='#00b11d'>+vipexp%</font>", "")
						}
						if (vip_money_cfg && vip_money_cfg.num > 0) {
							str = str.replace("vipgold", vip_money_cfg.num)
						} else {
							str = str.replace("，获得金币<font color='#00b11d'>+vipgold%</font>", "")
						}
						data.desc = str
						data_list.push(data)
					}
				}
			}

			//守护
			let guard_info = this.guard_model.info
			if (guard_info) {
				let [guard_type1, guard_type2] = this.guard_model.GetGuardActiveType()
				let func = (lv?, vo?) => {
					let guard_cfg = buff_cfgs["guard" + lv]
					if (guard_cfg) {
						let time = vo.end_time - TimeUtil.getServerTime()
						next_refresh_time = time
						let D = Math.floor(time / 60 / 60 / 24)
						let show_time
						if (D > 365 * 2) {
							show_time = "永久"
						} else {
							show_time = time
						}

						let data = {
							time: show_time,
							cfg: guard_cfg
						}
						data_list.push(data)
					}
				}
				for (let _tmpi in guard_info) {
					var vo = guard_info[_tmpi]
					if (vo.lv == guard_type1 || vo.lv == guard_type2) {
						func(vo.lv, vo)
					}
				}
			}
			let relive_data = ReliveModel.GetInstance().GetReliveTimeData(ReliveModel.BossSpecialReliveType.WorldBoss)
			//世界boss
			if (relive_data && relive_data.die_times > 0) {
				let cfg = buff_cfgs["bossTired"]
				let left_time = relive_data.debuff_time - TimeUtil.getServerTime()
				next_refresh_time = left_time
				if (cfg && left_time > 0) {
					let data = {
						name: "复活疲劳(" + relive_data.die_times + "层)",
						time: left_time,
						cfg: cfg
					}
					data_list.push(data)
				}
			}
			//
			relive_data = ReliveModel.GetInstance().GetReliveTimeData(ReliveModel.BossSpecialReliveType.HolyTerr)
			if (relive_data && relive_data.die_times > 0) {
				let cfg = buff_cfgs["holyTerrTired"]
				let left_time = relive_data.debuff_time - TimeUtil.getServerTime()
				next_refresh_time = left_time
				if (cfg && left_time > 0) {
					let data = {
						name: "复活疲劳(" + relive_data.die_times + "层)",
						time: left_time,
						cfg: cfg
					}
					data_list.push(data)
				}
			}
			//
			relive_data = ReliveModel.GetInstance().GetReliveTimeData(ReliveModel.BossSpecialReliveType.KfHolyArea)
			if (relive_data && relive_data.die_times > 0) {
				let cfg = buff_cfgs["kfHolyAreaTired"]
				let left_time = relive_data.debuff_time - TimeUtil.getServerTime()
				next_refresh_time = left_time
				if (cfg && left_time > 0) {
					let data = {
						name: "复活疲劳(" + relive_data.die_times + "层)",
						time: left_time,
						cfg: cfg
					}
					data_list.push(data)
				}
			}
			//圣首领
			relive_data = ReliveModel.GetInstance().GetReliveTimeData(ReliveModel.BossSpecialReliveType.HolyBoss)
			if (relive_data && relive_data.die_times > 0) {
				let cfg = buff_cfgs["holyBossTired"]
				let left_time = relive_data.debuff_time - TimeUtil.getServerTime()
				next_refresh_time = left_time
				if (cfg && left_time > 0) {
					let data = {
						name: "复活疲劳(" + relive_data.die_times + "层)",
						time: left_time,
						cfg: cfg
					}
					data_list.push(data)
				}
			}
			//永恒圣殿
			let eter_relive_data = EternityModel.GetInstance().GetReliveData()
			if (eter_relive_data && eter_relive_data.die_times > 0) {
				let cfg = buff_cfgs["eternityTired"]
				let left_time = eter_relive_data.die_time - TimeUtil.getServerTime()
				next_refresh_time = left_time
				if (cfg && left_time > 0) {
					let data = {
						name: "复活疲劳(" + eter_relive_data.die_times + "层)",
						time: left_time,
						cfg: cfg
					}
					data_list.push(data)
				}
			}

			let mask_data = this.mask_model.GetMaskInfo()
			if (mask_data && mask_data.end_time > 0) {
				let mask_cfg = buff_cfgs["mengmr"]
				let left_time = mask_data.end_time - TimeUtil.getServerTime()
				next_refresh_time = left_time
				if (mask_cfg && left_time > 0) {
					let data = {
						name: mask_cfg.name,
						time: left_time,
						cfg: mask_cfg
					}
					data_list.push(data)
				}
			}
			//周卡
			let weekcard_data = WeekCardModel.GetInstance().GetWeekCardData()
			if (weekcard_data && weekcard_data.expired_time > 0) {
				let weekly_card_cfg = buff_cfgs["weeklyCard"]
				let left_time = weekcard_data.expired_time - TimeUtil.getServerTime()
				next_refresh_time = left_time
				if (weekly_card_cfg && left_time > 0) {
					let data = {
						name: weekly_card_cfg.name,
						time: left_time,
						cfg: weekly_card_cfg
					}
					data_list.push(data)
				}
			}

			let career_skill_buff_list = SkillUIModel.GetInstance().career_skill_buff_list
			if (career_skill_buff_list) {
				let cfg
				for (let _ in career_skill_buff_list) {
					cfg = buff_cfgs[career_skill_buff_list[_][0]]
					if (cfg) {
						let data = {
							cfg: cfg
						}
						data_list.push(data)
					}
				}
			}

			let skill_top = []
			let skill_bot = []
			if (this.skill_buff && !Util.IsTableEmpty(this.skill_buff)) {
				for (let i in this.skill_buff) {
					let vo = this.skill_buff[i]
					let cfg = buff_cfgs[vo.id]
					let time = vo.end_time - TimeUtil.getServerTime()
					if (cfg && time && time > 0) {
						let data = {
							time: time,
							end_time: vo.end_time,
							cfg: cfg,
							skill: vo.skill,
							skill_key: vo.skill + "_" + vo.id
						}
						let skill_cfg = SkillManager.GetInstance().getSkillFromConfig(vo.skill)
						let desc_list = []
						if (skill_cfg && skill_cfg.lv_data) {
							let list = JSON.parse(skill_cfg.lv_data)
							let totle_time = 0
							if (list && list[vo.level - 1]) {
								if (typeof (list[vo.level - 1].attr) == "string") {
									let attr = ErlangParser.GetInstance().Parse(list[vo.level - 1].attr)
									for (let j in attr) {
										let vo2 = attr[j]
										if (vo2[0] == vo.id && vo2[3] == 1) {
											totle_time = Number(vo2[6]) / 1000
											desc_list.push(this.GetSkillBuffDesc(Number(vo2[4]), Number(vo2[5]), cfg))
										}
									}
								}
								if (typeof (list[vo.level - 1].effect) == "string") {
									let effect = ErlangParser.GetInstance().Parse(list[vo.level - 1].effect)
									for (let j in effect) {
										let vo2 = effect[j]
										if (vo2[0] == vo.id && vo2[3] == 1) {
											totle_time = Number(vo2[7]) / 1000
											desc_list.push(this.GetSkillBuffDesc(Number(vo2[4]), Number(vo2[5]), cfg))
										}
									}
								}
							}
							data.cfg.time = totle_time
							let desc = ""
							for (let j in desc_list) {
								desc = desc + desc_list[j]
								if (Number(j) < (desc_list.length - 1)) {
									desc = desc + "<br>"
								}
							}
							data.cfg.desc = desc
						}
						if (data.cfg.is_pinned && data.cfg.is_pinned == "top") {
							skill_top.push(data)
						} else if (data.cfg.is_pinned && data.cfg.is_pinned == "bottom") {
							skill_bot.push(data)
						} else {
							data_list.push(data)
						}
					}
				}
			}

			let top_list = []
			let nor_list = []
			let bot_list = []
			for (let i in data_list) {
				let vo = data_list[i]
				if (vo.cfg && vo.cfg.is_pinned && vo.cfg.is_pinned == "top") {
					top_list.push(vo)
				} else if (vo.cfg && vo.cfg.is_pinned && vo.cfg.is_pinned == "bottom") {
					bot_list.push(vo)
				} else {
					nor_list.push(vo)
				}
			}
			table.sort(top_list, (a, b) => {
				return Number(a.cfg.pin_id) < Number(b.cfg.pin_id)
			})
			table.sort(bot_list, (a, b) => {
				return Number(a.cfg.pin_id) < Number(b.cfg.pin_id)
			})
			table.sort(skill_top, (a, b) => {
				return Number(a.cfg.pin_id) < Number(b.cfg.pin_id)
			})
			table.sort(skill_bot, (a, b) => {
				return Number(a.cfg.pin_id) < Number(b.cfg.pin_id)
			})
			table.sort(nor_list, (a, b) => {
				if (!a.time && b.time) {
					return false
				} else if (a.time && !b.time) {
					return true
				} else if (!a.time && !b.time) {
					return true
				}
				return a.time < b.time
			})
			this.buff_list = top_list.concat(skill_top.concat(nor_list.concat(skill_bot.concat(bot_list))))
			GlobalEventSystem.Fire(EventName.UPDATE_BUFF_DATA)

			if (this.refresh_buff_time_id) {
				clearTimeout(this.refresh_buff_time_id)
			}
			if (next_refresh_time && next_refresh_time > 0) {
				let delay_time = (next_refresh_time + 1) * 1000

				// 2的31次方
				if(delay_time >= 2147483648){
					delay_time = 2147483647
				}
				this.refresh_buff_time_id = setTimeout(() => {
					this.TryRefreshBuff()
				}, delay_time);
			}
		}

		this.GetBuffDesc = (str, effect_list) => {
			if (effect_list) {
				for (let _tmpi in effect_list) {
					var vo = effect_list[_tmpi]
					if ("attr" == vo[0]) {
						let re_str: string = ""
						let desc_lis = vo[1]
						for (let i = 0; i < desc_lis.length; i++) {
							if (i == desc_lis.length - 1) {
								re_str = re_str + "<font color='#00b11d'>" + WordManager.GetProperties(desc_lis[i][0]) + (" + ") + WordManager.ConvertToPercentValue(desc_lis[i][0], desc_lis[i][1]) + "</font>"
							} else {
								re_str = re_str + "<font color='#00b11d'>" + WordManager.GetProperties(desc_lis[i][0]) + (" + ") + WordManager.ConvertToPercentValue(desc_lis[i][0], desc_lis[i][1]) + "</font>,"
							}
						}
						//将re_str里的%替换成%%
						re_str = re_str.replace("%%", "%%%%")
						str = str.replace("attr", re_str)
					} else if ("coin" == vo[0]) {
						str = str.replace("coin", Util.HtmlColorTxt(`铜钱`, "'#00b11d'"))
					} else if ("exp_mon" == vo[0]) {
						str = str.replace("exp_mon", Util.HtmlColorTxt(`${vo[1] * 100}%`, "'#00b11d'"))
					}
				}
			}
			return Trim(str)
		}

		//游戏稳定后给服务端发送信息
		this.LoginCheckPop = () => {
			if (!this.is_popped) {
				this.is_popped = true

				//等待N秒，界面稳定后执行
				setTimeout(() => {
					TempleAwakenModel.GetInstance().SendPopMsg()
				}, 4000);

			}
		}


		this.AddAdultFlag=()=>{
			if(PlatformManager.IsEyouVnPlatform()&&PlatformManager.GetInstance().is_wx_alpha){
				if (this._time_vn) {
					clearTimeout(this._time_vn)
				}
				if(this._box_vn){
					this._box_vn.removeSelf()
					this._box_vn.destroy()
					this._box_vn = null
				}
				setTimeout(() => {
					this._box_vn = new Laya.Box()
					this._box_vn.name = "Box_EyouVnAdultItem"
					this._box_vn.width = 80
					this._box_vn.height = 70
					this._box_vn.centerX = 150
					this._box_vn.y = 40
					LayerManager.GetInstance().GetUILayer(Enum_UILayer.Top).addChild(this._box_vn);
					let view = new EyouThAdultItem(this._box_vn)
					view.Load()
				}, 4000);
			}
		}
	}

	LoginCheckPop //登录后是否弹出过弹窗
	is_popped = false

	public static NotJumpRedSubView(_name) {
		return _name == "SecretTreasureMainView" || _name == "BagView" || _name == "FriendEnterView"
	}

	public static GetInstance(): MainUIModel {

		if (MainUIModel.Instance == null) {
			MainUIModel.Instance = new MainUIModel()
		}
		return MainUIModel.Instance
	}
}
window["MainUIModel"] = MainUIModel
import { BaseController } from "../common/BaseController";
import { CommonManager } from "../common/CommonManager";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MainFunc } from "../commonModel/MainUIModel";
import { RoleViewIndex } from "../commonModel/RoleModel";
import { Scene } from "../scene/Scene";
import { SceneManager } from "../scene/SceneManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { PlayBigEffect, Util } from "../util/Util";
import { enum_OutWardType, OutWardBaseModel } from "../commonModel/OutWardBaseModel";

import "../pet/MountPetView"
import "../pet/PetSkillView"
import "../pet/OutwardChangedView"
import "../pet/OutwardStarView"
import "../pet/OutWardIllusionView"
import { TaskModel } from "../commonModel/TaskModel";
import { PartnerModel } from "../commonModel/PartnerModel";
import { Config } from "../common/Config";
import { SettingModel } from "../commonModel/SettingModel";
import { InnateTypeItemRenderer } from "../innateSkill/InnateTypeItemRenderer";
import "../pet/PetLvSystemSkillView"
import { CycleimpActlistEvent, CycleimpActlistModel } from "../commonModel/CycleimpActlistModel";


export class OutWardController extends BaseController {
	public mount_pet_view
	private view_dic = {}

	public static HorseType = 16;
	public static PartnerType = 17;
	public static WingsType = 18;
	public static ArtifactType = 19;
	public static HolyDeviceType = 20;
	public static SpriteType = 9999;
	public static PetType = 9999;
	public static MagicArr = 9999;
	public static BackOrnamentType = 25;

	/**幻型界面对应的顺序*/
	public static View2Index = {
		Wings: 0,
		Artifact: 1,
		HolyDevice: 2,
		BackOrnament: 3,
		MagicArr: 4
	}

	InitInfo
	horse_setting_data
	public constructor() {
		super()

		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_OutWardBaseModel = OutWardBaseModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_enum_OutWardType = enum_OutWardType
		let res_mgr = ResManager.GetInstance()

		let local_Number = Number
		let goods_model = GoodsModel.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let local_OutWardController = OutWardController
		this.InitInfo = () => {
			let outwardModel = local_OutWardBaseModel.GetInstance()
			let On16000 = () => {
				let vo = user_msg_adapter.GetSCMD(16000)
				if (vo.errcode == 1600023) {
					outwardModel.Fire(local_OutWardBaseModel.PET_ACTIVE_LIMIT, vo.errcode)
				} else {
					Util.ErrorCodeShow(vo.errcode)
				}
			}

			let On16001 = () => {
				let vo = user_msg_adapter.GetSCMD(16001)
				let role_vo = SceneManager.GetInstance().GetRoleVo(vo.role_id)
				if (role_vo) {
					role_vo.SetFigureId(vo.type_id, vo.figure_id, true)
					// console.warn("@@@@------On16001------", role_vo.name,vo.figure_id, vo.is_ride)
					role_vo.SetFigureRideState(vo.type_id, vo.is_ride)
					if (!SceneManager.GetInstance().IsSeaAsserScene()) {// && role_vo.CheckIsWorker()) ) {
						role_vo.ChangeVar("move_speed", vo.speed)
					}
				}
			}

			let On16002 = () => {
				let vo = user_msg_adapter.GetSCMD(16002)
				outwardModel.SetOutWardData(vo)
			}

			let On16003 = () => {
				let vo = user_msg_adapter.GetSCMD(16003)
				if (vo.errcode == 1) {
					Message.show("幻化成功")
					outwardModel.UpdateOutWardFigure(vo)
				} else {
					Util.ErrorCodeShow(vo.errcode)
				}
			}

			let On16004 = () => {
				let vo = user_msg_adapter.GetSCMD(16004)
				if (vo.errcode == 1) {
					if (vo.type_id == enum_OutWardType.Horse) {
						Scene.GetInstance().main_role.HorseChange()
					}
				} else {
					Util.ErrorCodeShow(vo.errcode)
				}
			}

			let On16005 = () => {
				let vo = user_msg_adapter.GetSCMD(16005)
				if (vo.errcode == 1) {
					outwardModel.UpdateOutWardEvolutionData(vo)
				} else {
					Util.ErrorCodeShow(vo.errcode)
				}
			}

			let On16006 = () => {
				let vo = user_msg_adapter.GetSCMD(16006)
				outwardModel.UpdataOutWardIllusionData(vo)
				outwardModel.CheckIlluStarRed(vo.type_id)
				let red = outwardModel.ShowIlluRed(vo.type_id)
				outwardModel.Fire(local_OutWardBaseModel.UPDATE_ILLUSION_RED, vo.type_id, red)
				if (vo.type_id != local_enum_OutWardType.Pet) {
					outwardModel.UpdateOutWardStrongerRed(vo.type_id)
				}
				if (vo.type_id == 1 || vo.type_id == 2 || vo.type_id == 6 || vo.type_id == 7) {
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Pet)
				}
			}

			let On16007 = () => {
				let vo = user_msg_adapter.GetSCMD(16007)
				if (vo.errcode == 1) {
					outwardModel.UpdateOutWardFigureData(vo)
				} else {
					Util.ErrorCodeShow(vo.errcode)
				}
			}

			let On16008 = () => {
				let scmd = user_msg_adapter.GetSCMD(16008)
				if (scmd.errcode == 1) {
					if (scmd.type_id == local_enum_OutWardType.Pet) {
						outwardModel.Fire(local_OutWardBaseModel.REQUEST_PROTO, 16002, "c", local_enum_OutWardType.Partner)
					}
					let list = outwardModel.outward_illu_data_list[scmd.type_id];
					scmd['isFirst'] = !(list?.figure_list?.length);
					scmd['cb'] = () => {
						outwardModel.Fire(OutWardBaseModel.ILLUSION_OUTWARD, scmd.type_id, 2, scmd.id, 0)
					}

					outwardModel.Fire(local_OutWardBaseModel.REQUEST_PROTO, 16006, "c", scmd.type_id)
					outwardModel.Fire(local_OutWardBaseModel.ATIVATE_OUTWARD_FIGURE_SUCCESS, scmd)

					// if (vo.type_id == local_enum_OutWardType.HolyDevice) {
					// 	GlobalEventSystem.Fire(EventName.OPEN_VIEW, "ShowOffView", vo)
					// } else {
					//PlayBigEffect("ui_ZiTi_Jihuo")//翅膀激活成功
					outwardModel.Fire(local_OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", scmd, 1)
					// }

				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let On16009 = () => {
				let vo = user_msg_adapter.GetSCMD(16009)
				if (vo.errcode == 1) {
					outwardModel.UpdateOutWardFigureEvolutionData(vo)
					if (vo.type_id == local_enum_OutWardType.Pet) {
						outwardModel.Fire(local_OutWardBaseModel.REQUEST_PROTO, 16002, "c", local_enum_OutWardType.Partner)
					}
					if (vo.type_id == local_enum_OutWardType.Wings) {
						PlayBigEffect("ui_shengxingchengong")
					}

					this.SendFmtToGameImme(16006, "c", vo.type_id)

				} else {
					Util.ErrorCodeShow(vo.errcode)
				}
			}

			let On16010 = () => {
				let vo = user_msg_adapter.GetSCMD(16010)
				if (vo.errcode == 1) {
					Message.show("使用成功")
					this.SendFmtToGameImme(16011, "c", vo.type_id)
					this.SendFmtToGameImme(16002, "c", vo.type_id)
					outwardModel.Fire(local_OutWardBaseModel.USE_CRYSTAL_SUCCESS, vo)
				} else {
					Util.ErrorCodeShow(vo.errcode)
				}
			}

			let On16011 = () => {
				let vo = user_msg_adapter.GetSCMD(16011)
				outwardModel.UpdateOutWardCrystalUseData(vo)
			}

			let On16012 = () => {
				let vo = user_msg_adapter.GetSCMD(16012)
				if (outwardModel.outward_figure_list[vo.type_id] && outwardModel.outward_figure_list[vo.type_id][vo.id]) {
					delete outwardModel.outward_figure_list[vo.type_id][vo.id]
				}
				if (outwardModel.active_illu_list[vo.type_id] && outwardModel.active_illu_list[vo.type_id][vo.id]) {
					delete outwardModel.active_illu_list[vo.type_id][vo.id]
				}
				outwardModel.Fire(local_OutWardBaseModel.REQUEST_PROTO, 16006, "c", vo.type_id)
				outwardModel.Fire(local_OutWardBaseModel.CANCEL_ACTIVE, vo)
			}

			let On16013 = () => {
				let vo = user_msg_adapter.GetSCMD(16013)
				outwardModel.Fire(local_OutWardBaseModel.UPDATE_SKILL_POWER, vo)
			}

			let On16020 = () => {
				let scmd = user_msg_adapter.GetSCMD(16020)
				if (scmd.errcode == 1) {
					let list = outwardModel.outward_illu_data_list[scmd.type_id]
					if (list) {
						for (let vo of list.figure_list) {
							if (vo.id == scmd.id) {
								vo.star = scmd.star
								break
							}
						}
					}
					outwardModel.CheckIlluStarRed(scmd.type_id)
					outwardModel.CheckTypeIconRed(scmd.type_id)
					this.SendFmtToGameImme(16006, "c", scmd.type_id)
					this.SendFmtToGameImme(16007, "ci", scmd.type_id, scmd.id)
					outwardModel.Fire(local_OutWardBaseModel.UPSTAR_SUCCESS, scmd)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let On16021 = () => {
				let vo = user_msg_adapter.GetSCMD(16021)
				let role = Scene.GetInstance().GetRole(vo.role_id)
				if (role) {
					role.CreateMagicArrEffect()
				}
			}

			let On16022 = () => {
				let scmd = user_msg_adapter.GetSCMD(16022)
				outwardModel.Fire(local_OutWardBaseModel.REAL_FIGHT, scmd)
			}

			let On16023 = () => {
				let scmd = user_msg_adapter.GetSCMD(16023)
				if (scmd.errcode == 1) {
					outwardModel.UpdateOutWardEvolutionData(scmd)
				} else {
					outwardModel.Fire(local_OutWardBaseModel.UPLV_FAILD, scmd)
					if (scmd.errcode != 1600035) {
						Util.ErrorCodeShow(scmd.errcode)
					}
				}
			}

			let On16024 = () => {
				let scmd = user_msg_adapter.GetSCMD(16024)
				let data = outwardModel.outward_data_list[scmd.type_id]
				if (data) {
					data.auto_buy = scmd.auto_buy
				}
				outwardModel.Fire(local_OutWardBaseModel.UPDATE_AUTO_STATE, scmd)
			}

			let On16027 = () => {
				let scmd = user_msg_adapter.GetSCMD(16027)
				outwardModel.Fire(local_OutWardBaseModel.UPDATE_STAR_FIGHT, scmd)
			}

			let On16028 = () => {
				let scmd = user_msg_adapter.GetSCMD(16028)
				ResManager.GetInstance().LoadGameConfig(this, "config_skill_lv_data", false, null, (cfg?) => {
					outwardModel.SetLvSystemInfo(scmd)
					outwardModel.Fire(local_OutWardBaseModel.UPDATE_LV_VIEW, scmd)
					outwardModel.Fire(local_OutWardBaseModel.REQUEST_PROTO, 16002, "c", scmd.type_id)
					let red = outwardModel.LvsystemCanLvUp(scmd.type_id) || outwardModel.LvsystemSkillCanLvUp(scmd.type_id)
					outwardModel.Fire(local_OutWardBaseModel.UPDATE_CULTURE_RED, scmd.type_id, red)
				})
			}

			let On16029 = () => {
				let scmd = user_msg_adapter.GetSCMD(16029)
				if (scmd.errcode == 1) {
					let changelv = false
					let LvSystemInof = outwardModel.GetLvSystemInfo(scmd.type_id)
					if (LvSystemInof.level < scmd.level) {
						changelv = true
					}
					outwardModel.UpdaLvSysteInfo(scmd)
					outwardModel.Fire(local_OutWardBaseModel.UPDATE_LV_UP_SYSTEM_VIEW, scmd, changelv)
					outwardModel.Fire(local_OutWardBaseModel.REQUEST_PROTO, 16002, "c", scmd.type_id)
				}

			}

			let On16030 = () => {
				let scmd = user_msg_adapter.GetSCMD(16030)
				if (scmd.errcode == 1) {
					let outward_lvsystem_info = outwardModel.GetLvSystemInfo(scmd.type_id)
					for (let key in outward_lvsystem_info.skill_list) {
						if (outward_lvsystem_info.skill_list[key].skill_id == scmd.skill_id) {
							outward_lvsystem_info.skill_list[key].skill_level = scmd.level
							break
						}
					}
					outwardModel.Fire(local_OutWardBaseModel.UPDATE_LVSYSTEM_SKILL_VIEW, scmd.skill_id, scmd.type_id, scmd.level)
					outwardModel.Fire(local_OutWardBaseModel.REQUEST_PROTO, 16002, "c", scmd.type_id)
				}
			}

			this.RegisterProtocal(16000, On16000)
			this.RegisterProtocal(16001, On16001)
			this.RegisterProtocal(16002, On16002)
			this.RegisterProtocal(16003, On16003)
			this.RegisterProtocal(16004, On16004)
			this.RegisterProtocal(16005, On16005)
			this.RegisterProtocal(16006, On16006)
			this.RegisterProtocal(16007, On16007)
			this.RegisterProtocal(16008, On16008)
			this.RegisterProtocal(16009, On16009)
			this.RegisterProtocal(16010, On16010)
			this.RegisterProtocal(16011, On16011)
			this.RegisterProtocal(16012, On16012)
			this.RegisterProtocal(16013, On16013)
			this.RegisterProtocal(16020, On16020)
			this.RegisterProtocal(16021, On16021)
			this.RegisterProtocal(16022, On16022)
			this.RegisterProtocal(16023, On16023)
			this.RegisterProtocal(16024, On16024)
			this.RegisterProtocal(16027, On16027)
			this.RegisterProtocal(16028, On16028)
			this.RegisterProtocal(16029, On16029)
			this.RegisterProtocal(16030, On16030)

			outwardModel.Bind(local_OutWardBaseModel.REQUEST_PROTO, (id, fmt, ...parms) => {
				this.SendFmtToGameImme(id, fmt, ...parms)
			})

			outwardModel.Bind(local_OutWardBaseModel.OPEN_VIEW, async (view_name: string, ...parms) => {
				// let callback = () => {
				let view = this.view_dic[view_name]
				if (!view) {
					this.view_dic[view_name] = true
					// if (!window[view_name]) {
					// 	if (!res_mgr.IsJsLoad("pet")) {
					// 		await res_mgr.LoadJs("pet")
					// 	}
					// }
					if (this.view_dic[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						this.view_dic[view_name] = view
					}
				}
				if (view && view != true) {
					if (view.HasOpen()) {
						view.Close()
					} else {
						view.Open(...parms)
					}
				}
				// }
				// LoadLuaClassAB(view_name, callback)
			})

			let OnGameStart = () => {
				let delay_fun = () => {
					for (let i in local_enum_OutWardType) {
						let k = local_Number(i)
						if (!isNaN(k)) {
							if (k == local_enum_OutWardType.Pet) {
								this.SendFmtToGameImme(16006, "c", k)
							} else if (k != local_enum_OutWardType.Sprite) {
								this.SendFmtToGameImme(16002, "c", k)
								this.SendFmtToGameImme(16006, "c", k)
								this.SendFmtToGameImme(16011, "c", k)
								this.SendFmtToGameImme(16028, "c", k)
								if (k == local_enum_OutWardType.Horse || k == local_enum_OutWardType.Partner) {

								}
							}
						}
					}
				}
				setTimeout(delay_fun, 2000)
				if(!this.horse_setting_data){
					this.horse_setting_data = SettingModel.GetInstance().GetSubSettingData(SettingModel.SettingType.SysSetting, SettingModel.BlockSubType.auto_horse)
				}
				outwardModel.auto_horse = this.horse_setting_data.is_open == 1
			}
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, OnGameStart)

			this.Bind(local_EventName.INIT_CONFIG, () => {

			})

			let Request_Info_Func = (type_id?) => {
				this.SendFmtToGameImme(16002, "c", type_id)
				this.SendFmtToGameImme(16006, "c", type_id)
				this.SendFmtToGameImme(16011, "c", type_id)
				this.SendFmtToGameImme(16028, "c", type_id)
			}
			outwardModel.Bind(local_OutWardBaseModel.OPEN_MOUNTPET_VIEW, Request_Info_Func)

			let Request_Func = (type_id?) => {
				this.SendFmtToGameImme(16002, "c", type_id)
			}
			outwardModel.Bind(local_OutWardBaseModel.REQUEST_OUTWARD_INFO, Request_Func)

			let Illusion_OutWard = (type_id?, type?, args?, color?) => {
				this.SendFmtToGameImme(16003, "ccii", type_id, type, args, color)
			}
			outwardModel.Bind(local_OutWardBaseModel.ILLUSION_OUTWARD, Illusion_OutWard)

			let Evolution_Func = (type_id?, autoBuy?, useDia?) => {
				if (type_id == local_enum_OutWardType.Horse || type_id == local_enum_OutWardType.Partner) {
					this.SendFmtToGameImme(16023, "ccc", type_id, autoBuy, useDia)
				} else {
					this.SendFmtToGameImme(16005, "c", type_id)
				}
			}
			outwardModel.Bind(local_OutWardBaseModel.OUTWARD_EVOLUTION, Evolution_Func)

			let Request_Illusion = (type_id?) => {
				this.SendFmtToGameImme(16006, "c", type_id)
			}
			outwardModel.Bind(local_OutWardBaseModel.REQUEST_ILLUSION_INFO, Request_Illusion)

			let Request_Illusion_Data = (type_id?, id?) => {
				this.SendFmtToGameImme(16007, "ci", type_id, id)
			}
			outwardModel.Bind(local_OutWardBaseModel.REQUEST_OUTWARD_DATA, Request_Illusion_Data)

			let Active_OutWard_Figure = (type_id?, id?) => {
				this.SendFmtToGameImme(16008, "ci", type_id, id)
			}
			outwardModel.Bind(local_OutWardBaseModel.ACTIVE_OUTWARD_FIGURE, Active_OutWard_Figure)

			let Evolution_OutWard_Figure = (type_id?, id?, goods_id?) => {
				this.SendFmtToGameImme(16009, "cii", type_id, id, goods_id)
			}
			outwardModel.Bind(local_OutWardBaseModel.EVOLUTION_OUTWARD_FIGURE, Evolution_OutWard_Figure)

			let Use_Item_Func = (type_id?, goods_id?) => {
				this.SendFmtToGameImme(16010, "ci", type_id, goods_id)
			}
			outwardModel.Bind(local_OutWardBaseModel.USE_OUTWARD_ITEM, Use_Item_Func)

			let Request_Lv_Info = (type_id) => {
				this.SendFmtToGameImme(16028, "c", type_id)
			}
			outwardModel.Bind(local_OutWardBaseModel.REQUEST_LV_INFO, Request_Lv_Info)

			let Request_lv_up = (type_id?) => {
				this.SendFmtToGameImme(16029, "c", type_id)
			}
			outwardModel.Bind(local_OutWardBaseModel.REQUEST_LV_UP, Request_lv_up)

			let Requset_lv_up_skill = (type_id?, skill_id?) => {
				this.SendFmtToGameImme(16030, "ci", type_id, skill_id)
			}
			outwardModel.Bind(local_OutWardBaseModel.REQUEST_LV_UP_SKILL, Requset_lv_up_skill)

			let task_fashion = (task_id?) => {
				let data = null
				let type_id
				if (task_id == 100320) {
					type_id = 1
					data = {
						type_id: 1,
						id: 1,
						stage: 1
					}
				} else if (task_id == 100180) {
					type_id = 2
					data = {
						type_id: 2,
						id: 1,
						stage: 1
					}
				} else if (task_id == 100660) {
					type_id = 3
					data = {
						type_id: 3,
						id: 1,
						stage: 1
					}
				} else if (task_id == 101040) {
					type_id = 4
					data = {
						type_id: 4,
						id: 1,
						stage: 1
					}
				} else if (task_id == 101340) {
					type_id = 4
					data = {
						type_id: 5,
						id: 1,
						stage: 1
					}
				} else if (task_id == 200010) {
					type_id = 12
					data = {
						type_id: 12,
						id: 1,
						stage: 1
					}
				}


				if (data != null) {
					this.SendFmtToGameImme(16028, "c", type_id)
					data.isFirst = true;
					// data.cb = () => {
					// 	outwardModel.Fire(OutWardBaseModel.ILLUSION_OUTWARD, type_id, 1, data.stage, 0)
					// }
					OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data, 0)
				}
			}
			TaskModel.GetInstance().Bind(TaskModel.FINISH_TASK, task_fashion)

			let viewflag = null
			let OpenMountPetView1 = async (index?, petId?, backId?, backShowId?) => {

				if (!window["MountPetView"] && !viewflag) {
					viewflag = true
					if (!res_mgr.IsJsLoad("pet")) {
						await res_mgr.LoadJs("pet")
					}
				}

				let cfg = Config.PRELOAD_CLIENT_CONFIG["ConfigPartnerAwake"]
				/*伙伴激活*/
				// res_mgr.GetGameConfigWithAutoDestory("ConfigPartnerAwake", (cfg) => {
				if (cfg.Partner.partner_id) {
					let partner_id = cfg.Partner.partner_id
					if (!PartnerModel.GetInstance().PartnerIsActiveById(partner_id)) {
						if (this.mount_pet_view && !this.mount_pet_view.HasOpen()) {
							this.mount_pet_view.DeleteMe()
							this.mount_pet_view = null
						}
					}
				}
				// }, true)


				let view = window["MountPetView"]
				if (!this.mount_pet_view) {
					this.mount_pet_view = new view()
				}
				if (this.mount_pet_view.HasOpen() && index != null) {
					this.mount_pet_view.SetIndexParameter(index, petId)
					this.mount_pet_view.SetSelectIndex(index)
				} else {
					if (index != undefined) {
						this.mount_pet_view.SetDefaultIndex(index)
					}
					if (backId) {
						this.mount_pet_view.SetBackId(backId, backShowId)
					}
					if (petId && index == 3) {
						this.mount_pet_view.Open(index, petId)
					} else {
						this.mount_pet_view.Open()
					}
				}
			}
			local_GlobalEventSystem.Bind(local_EventName.SWITCH_MOUNT_PET_VIEW, OpenMountPetView1)

			local_GlobalEventSystem.Bind(local_EventName.CLOSE_MOUNTPET_VIEW, () => {
				if (this.mount_pet_view) {
					this.mount_pet_view.Close()
					this.mount_pet_view = null
				}
			})

			goods_model.Bind(GoodsModel.CHANGE_BAG_LIST, (list?) => {
				if (!list) {
					return
				}
				let checkOutList = {}
				let ref_type = [] //0:骑宠图标，1:任务图标
				for (let vo of list) {
					let goods_basic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
					if (goods_basic && !checkOutList[goods_basic.type]) {
						checkOutList[goods_basic.type] = true
						switch (goods_basic.type) {
							case local_OutWardController.HorseType:
								//坐骑
								if (common_mgr.CheckFuncOpenState("HorseComponentView", true)) {
									outwardModel.CheckIlluStarRed(local_enum_OutWardType.Horse)
									let illusion_red = outwardModel.ShowIlluRed(local_enum_OutWardType.Horse)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_ILLUSION_RED, local_enum_OutWardType.Horse, illusion_red)
									local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetIllusionView", 0, illusion_red)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_CULTURE_RED, local_enum_OutWardType.Horse)
									ref_type[0] = MainFunc.Pet
								}
								break
							case local_OutWardController.PartnerType:
								//精灵（原伙伴
								if (common_mgr.CheckFuncOpenState("PartnerComponentView", true)) {
									outwardModel.CheckIlluStarRed(local_enum_OutWardType.Partner)
									let illusion_red = outwardModel.ShowIlluRed(local_enum_OutWardType.Partner)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_ILLUSION_RED, local_enum_OutWardType.Partner, illusion_red)
									local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetIllusionView", 1, illusion_red)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_CULTURE_RED, local_enum_OutWardType.Partner)
									ref_type[0] = MainFunc.Pet
								}
								break
							case local_OutWardController.PetType:
								//飞骑
								if (common_mgr.CheckFuncOpenState("PetIllusionView", true)) {
									//outwardModel:CheckIlluStarRed(local_enum_OutWardType.Pet)
									//let illusion_red = outwardModel.ShowIlluRed(local_enum_OutWardType.Pet)
									//outwardModel:Fire(local_OutWardBaseModel.UPDATE_ILLUSION_RED, local_enum_OutWardType.Pet, illusion_red)
									//local_GlobalEventSystem:Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 2, illusion_red)
								}
								break
							case local_OutWardController.WingsType:
								//翅膀
								if (common_mgr.CheckFuncOpenState("OutWardView", true)) {
									let illusion_red = outwardModel.ShowIlluRed(local_enum_OutWardType.Wings)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_ILLUSION_RED, local_enum_OutWardType.Wings, illusion_red)
									local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", OutWardController.View2Index.Wings, illusion_red)
									let red = illusion_red || outwardModel.ShowCultureRed(local_enum_OutWardType.Wings)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_CULTURE_RED, local_enum_OutWardType.Wings, red)
									local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.Wings, red)
									ref_type[1] = MainFunc.Role
								}
								break
							case local_OutWardController.ArtifactType:
								//圣器
								if (common_mgr.CheckFuncOpenState("ArtifactComponentView", true)) {
									let illusion_red = outwardModel.ShowIlluRed(local_enum_OutWardType.Artifact)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_ILLUSION_RED, local_enum_OutWardType.Artifact, illusion_red)
									local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", OutWardController.View2Index.Artifact, illusion_red)
									let red = illusion_red || outwardModel.ShowCultureRed(local_enum_OutWardType.Artifact)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_CULTURE_RED, local_enum_OutWardType.Artifact, red)
									local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.Artifact, red)
									ref_type[1] = MainFunc.Role
								}
								break
							case local_OutWardController.HolyDeviceType:
								//神器
								if (common_mgr.CheckFuncOpenState("HolyDeviceComponentView", true)) {
									let illusion_red = outwardModel.ShowIlluRed(local_enum_OutWardType.HolyDevice)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_ILLUSION_RED, local_enum_OutWardType.HolyDevice, illusion_red)
									local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", OutWardController.View2Index.HolyDevice, illusion_red)
									let red = illusion_red || outwardModel.ShowCultureRed(local_enum_OutWardType.HolyDevice)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_CULTURE_RED, local_enum_OutWardType.HolyDevice, red)
									local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.HolyDevice, red)
									ref_type[1] = MainFunc.Role
								}
								break
							case local_OutWardController.BackOrnamentType:
								//背饰
								if (common_mgr.CheckFuncOpenState("BackOrnamentComponentView", true)) {
									let illusion_red = outwardModel.ShowIlluRed(local_enum_OutWardType.BackOrnament)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_ILLUSION_RED, local_enum_OutWardType.BackOrnament, illusion_red)
									local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", OutWardController.View2Index.BackOrnament, illusion_red)
									let red = illusion_red || outwardModel.ShowCultureRed(local_enum_OutWardType.BackOrnament)
									outwardModel.Fire(local_OutWardBaseModel.UPDATE_CULTURE_RED, local_enum_OutWardType.BackOrnament, red)
									local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.BackOrnament, red)
									ref_type[1] = MainFunc.Role
								}
								break
							case local_OutWardController.MagicArr:
								//法阵
								if (common_mgr.CheckFuncOpenState("MagicArrComponentView", true)) {
									//let illusion_red = outwardModel.ShowIlluRed(local_enum_OutWardType.MagicArr)
									//outwardModel:Fire(local_OutWardBaseModel.UPDATE_ILLUSION_RED, local_enum_OutWardType.MagicArr, illusion_red)
									//local_GlobalEventSystem:Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", OutWardController.View2Index.MagicArr, illusion_red)
									//let red = illusion_red || outwardModel.ShowCultureRed(local_enum_OutWardType.MagicArr)
									//outwardModel:Fire(local_OutWardBaseModel.UPDATE_CULTURE_RED, local_enum_OutWardType.MagicArr, red)
									//local_GlobalEventSystem:Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.MagicArr, red)
								}
								break
						}
						CycleimpActlistModel.GetInstance().Fire(CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIT_RED)
					}
					if (!Util.IsTableEmpty(ref_type)) {
						for (let v of ref_type) {
							local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, v)
						}
					}
				}
			})

			let SmeltGoods = (type_id?) => {
				let smeltList = outwardModel.selectSmelt
				this.WriteBegin(16018)
				this.WriteFMT("c", type_id)
				this.WriteFMT("h", Util.TableSize(smeltList))
				for (let key in smeltList) {
					let m = local_Number(key)
					let n = smeltList[key]
					this.WriteFMT("l", local_Number(key))
					this.WriteFMT("i", smeltList[key])
				}
				this.SendToGame()
			}
			outwardModel.Bind(local_OutWardBaseModel.SMELT_GOODS, SmeltGoods)

			let ChangeHorse = (type_id?, ride?) => {
				//1:坐骑 2：精灵 3: 翅膀 4.藏品 5：神兵 6：伙伴 7：飞骑, 12：背饰
				//0: 下坐骑 1: 上坐骑
				this.SendFmtToGameImme(16004, "cc", type_id, ride)
			}
			outwardModel.Bind(local_OutWardBaseModel.CHANGE_HORSE_STATE, ChangeHorse)

			SettingModel.GetInstance().Bind(SettingModel.BLOCK_SETTING_CHANGE, (subtype?, is_open?) => {
				if (subtype == 202) {
					outwardModel.auto_horse = is_open == 1
				}
			})

		}

		this.InitInfo()
	}

}
window["OutWardController"] = OutWardController
import { BaseController } from "../common/BaseController"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { DemonDefine } from "../commonModel/DemonDefine"
import { DemonEvent } from "../commonModel/DemonEvent"
import { DemonModel } from "../commonModel/DemonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TaskModel } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { PlayBigEffect, Util } from "../util/Util"

import "../demon/DemonActivatingView"

export class DemonController extends BaseController {
	demon_model: DemonModel
	goods_model
	user_msg_adapter
	open_fun_cfg
	res_mgr: ResManager

	public constructor() {
		super()

		this.goods_model = GoodsModel.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.demon_model = DemonModel.GetInstance()
		this.open_fun_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
		this.res_mgr = ResManager.GetInstance()

		this.InitEvent()
		this.RegisterAllProtocals()
	}

	public InitEvent() {

		let reset_data = () => {
			if (CommonManager.GetInstance().CheckFuncOpenState("DemonMainView", true)) {
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18301)
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18303)
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18307)
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 50901)
			}
		}

		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.demon_model.InitData()
			this.demon_model.ResetData()
			reset_data()
		})

		RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (level?) => {
			if (this.open_fun_cfg["DemonMainView"] && this.open_fun_cfg["DemonMainView"].open_lv == level) {
				reset_data()
			}
		})

		GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, (value?) => {
			let newest_finish_task_id = TaskModel.GetInstance().newest_finish_task_id

			if (this.open_fun_cfg["DemonMainView"] && this.open_fun_cfg["DemonMainView"].open_task == newest_finish_task_id) {
				reset_data()
			}
		})

		let level_time_id = null
		let star_time_id = null
		let skill_time_id = null
		let talent_time_id = null
		let rotary_time_id = null

		let TryRefreshLevelUpRed = () => {
			if (!level_time_id) {
				level_time_id = setTimeout(() => {
					this.res_mgr.GetGameConfigWithAutoDestory("config_demons_level", (cfgs) => {
						this.demon_model.RefreshLevelRed(cfgs)
						level_time_id = null
					}, false)
				}, 200)
			}
		}

		let TryRefreshStarUpRed = () => {
			if (!star_time_id) {
				star_time_id = setTimeout(() => {
					this.res_mgr.GetGameConfigWithAutoDestory("config_demons_star", (star_cfgs) => {
						this.res_mgr.GetGameConfigWithAutoDestory("config_demons", (cfgs) => {
							this.demon_model.RefreshStarRed(cfgs, star_cfgs)
							star_time_id = null
						}, false)
					}, false)
				}, 200)
			}
		}

		let TryRefreshSkillUpRed = () => {
			if (!skill_time_id) {
				skill_time_id = setTimeout(() => {
					// this.demon_model.RefreshSkillUpRed()
					skill_time_id = null
				}, 400)
			}
		}

		let TryRefreshTalentRed = () => {
			if (!talent_time_id) {
				talent_time_id = setTimeout(() => {
					this.demon_model.RefreshTalentRed()
					talent_time_id = null
				}, 400)
			}
		}

		let TryRefreshRotaryUpRed = () => {
			if (!rotary_time_id) {
				rotary_time_id = setTimeout(() => {
					this.demon_model.RefreshRotaryRed()
					rotary_time_id = null
				}, 400)
			}
		}

		this.goods_model.Bind(GoodsModel.UPDATE_GOODS_NUM, (list?) => {
			let goods_basic
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				goods_basic = this.goods_model.GetGoodsBasicByTypeId(vo.type_id)
				if (goods_basic && goods_basic.type == DemonDefine.GoodsType) {
					if (goods_basic.subtype == DemonDefine.MaterialSubType) {
						TryRefreshLevelUpRed()
					} else if (goods_basic.subtype == DemonDefine.FragmentSubType) {
						TryRefreshStarUpRed()
					} else if (goods_basic.subtype == DemonDefine.SkillSubType) {
						TryRefreshSkillUpRed()
					} else if (goods_basic.subtype == DemonDefine.RotarySubType) {
						TryRefreshRotaryUpRed()
					}
				}
			}
			//TryRefreshRotaryUpRed()
		})

		this.goods_model.Bind(GoodsModel.CREATE_BAG_LIST_FINISH, () => {
			TryRefreshRotaryUpRed()
		})

		this.goods_model.Bind(GoodsModel.CHANGE_DEMON_TALENT_LIST, () => {
			TryRefreshTalentRed()
		})

		this.demon_model.Bind(DemonEvent.REQUEST_PROTO, (cmd, ...parms) => {
			switch (cmd) {
				case 18308:
					this.SendFmtToGame(cmd, "c", parms[0])
					break
				case 18302:
				case 18304:
				case 18305:
				case 18306:
				case 18312:
				case 18316:
					this.SendFmtToGame(cmd, "i", parms[0])
					break
				case 50902:
					this.SendFmtToGame(cmd, "cc", parms[0], parms[1])
					break
				case 18309:
					this.SendFmtToGame(cmd, "ii", parms[0], parms[1])
					break
				case 18310:
					this.SendFmtToGame(cmd, "ici", parms[0], parms[1], parms[2])
					break
				case 18314:
					this.SendFmtToGame(cmd, "icih", parms[0], parms[1], parms[2], parms[3])
					break
				default:
					this.SendFmtToGame(cmd)
			}

		})

	}

	public RegisterAllProtocals() {
		let On18300 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18300)
			Util.ErrorCodeShow(scmd.error_code, scmd.args)
		}

		let On18301 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18301)
			this.demon_model.SetDemonsList(scmd.demons_list)
			this.demon_model.talent_shop_first_open_tips = scmd.open_state == 1
			this.demon_model.RefreshDemonShopRedDot()
		}

		let On18302 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18302)
			this.demon_model.SetDemonPower(scmd.demons_id, scmd.power)
		}

		let On18303 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18303)
			this.demon_model.SetFettersData(scmd)
		}

		let On18304 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18304)
			if (scmd.code == 1) {

				if(scmd.star==0){
					//激活成功
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonActivatingView", scmd)
					// this.demon_model.Fire(DemonEvent.ACTIVE_DEMON,scmd.demons_id)
					// setTimeout(() => {
					// 	GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonActivatingView", scmd)
					// }, 1500);
				}else{
					//升星成功
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonActivatingView", scmd)
				}
				
			
				this.demon_model.SetDemonPower(scmd.demons_id, scmd.power)
				let demon_data = this.demon_model.GetDemonData(scmd.demons_id)
				if (demon_data) {
					this.res_mgr.GetGameConfigWithAutoDestory("config_demons", (demons_cfg) => {
						this.res_mgr.GetGameConfigWithAutoDestory("config_demons_star", (demons_star_cfg) => {
							let demon_data = this.demon_model.GetDemonData(scmd.demons_id)
							if (demon_data) {
								demon_data.star = scmd.star
								demon_data.RefreshSkillData(scmd.skill_list)
								demon_data.power = scmd.power
								demon_data.RefreshStarAttr(demons_star_cfg)
								demon_data.slot_num = scmd.slot_num
								this.demon_model.Fire(DemonEvent.UPDATE_DEMON_DATA, scmd.demons_id)
							}
							this.demon_model.RefreshStarRed(demons_cfg, demons_star_cfg)
							this.demon_model.RefreshTalentRed()
							this.res_mgr.GetGameConfigWithAutoDestory("config_demons_painting", (cfg) => {
								this.demon_model.RefreshPaintingReward(cfg)
							}, false)

						}, false)
					}, false)
				} else {
					let demons_cfg, demons_level_cfg, demons_star_cfg
					let call_back = () => {
						if (demons_cfg && demons_level_cfg && demons_star_cfg) {
							this.demon_model.SetDemonData({
								demons_id: scmd.demons_id,
								level: 0,
								exp: 0,
								star: scmd.star,
								skill_list: scmd.skill_list,
								slot_num: scmd.slot_num
							}, demons_cfg, demons_level_cfg, demons_star_cfg)
							this.demon_model.Fire(DemonEvent.UPDATE_DEMONS_LIST)
							this.demon_model.RefreshLevelRed(demons_level_cfg)
							this.demon_model.RefreshStarRed(demons_cfg, demons_star_cfg)
							// this.demon_model.RefreshSkillUpRed()
							this.demon_model.RefreshTalentRed()
						}
					}

					this.res_mgr.GetGameConfigWithAutoDestory("config_demons", (cfg1) => {
						demons_cfg = cfg1
						this.res_mgr.GetGameConfigWithAutoDestory("config_demons_level", (cfg2) => {
							demons_level_cfg = cfg2
							this.res_mgr.GetGameConfigWithAutoDestory("config_demons_star", (cfg3) => {
								demons_star_cfg = cfg3
								call_back()
							}, false)
						}, false)
					}, false)

				}
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On18305 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18305)
			if (scmd.code == 1) {
				this.demon_model.SetDemonPower(scmd.demons_id, scmd.power)
				this.demon_model.Fire(DemonEvent.LEVEL_UP_SUCCESS)
				this.res_mgr.GetGameConfigWithAutoDestory("config_demons_level", (demons_level_cfg) => {
					let demon_data = this.demon_model.GetDemonData(scmd.demons_id)
					if (demon_data) {
						demon_data.level = scmd.level
						demon_data.exp = scmd.exp
						demon_data.power = scmd.power
						demon_data.RefreshLevelAttr(demons_level_cfg)
						this.demon_model.Fire(DemonEvent.UPDATE_DEMON_DATA, scmd.demons_id)
					}
					this.demon_model.RefreshLevelRed(demons_level_cfg)
				}, false)

			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On18306 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18306)
			if (scmd.code == 1) {
				Message.show("跟随成功")
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On18307 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18307)
			this.demon_model.SetPaintingData(scmd)
			this.res_mgr.GetGameConfigWithAutoDestory("config_demons_painting", (cfg) => {
				this.demon_model.RefreshPaintingReward(cfg)
			}, false)
		}

		let On18308 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18308)
			if (scmd.code == 1) {
				Message.show("领取成功")
				let scmd18307 = this.demon_model.GetPaintingData()
				if (!scmd18307) {
					scmd18307 = this.user_msg_adapter.GetSCMD(18307, true)
				}
				scmd18307.painting_get.push({ painting_id: scmd.painting_id })
				this.demon_model.SetPaintingData(scmd18307)
				this.res_mgr.GetGameConfigWithAutoDestory("config_demons_painting", (cfg) => {
					this.demon_model.RefreshPaintingReward(cfg)
				}, false)
				Util.ShowCongratulationView(scmd.rewards)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On18309 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18309)
			if (scmd.code == 1) {
				Message.show("升级成功")
				let demons_data = this.demon_model.GetDemonData(scmd.demons_id)
				if (demons_data) {
					let skill_dic = demons_data.skill_dic
					if (skill_dic && skill_dic[scmd.skill_id]) {
						skill_dic[scmd.skill_id].skill_lv = scmd.new_level
						this.demon_model.Fire(DemonEvent.UPDATE_SKILL_DATA, scmd.demons_id, scmd.skill_id)
					}
				}
				// this.demon_model.RefreshSkillUpRed()
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On18310 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18310)
			if (scmd.code == 1) {
				this.demon_model.UpTalent(scmd)
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18302, scmd.demons_id)
				PlayBigEffect("ui_ZiTi_Jihuo")
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On18311 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18311)
			this.demon_model.SetTalenShopData(scmd)
		}

		let On18312 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18312)
			if (scmd.code == 1) {
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18311)
				this.demon_model.Fire(DemonEvent.TALENT_SHOP_BUY_RETURN, scmd.id)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On18313 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18313)
			if (scmd.code == 1) {
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18311)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On18314 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18314)
			if (scmd.code == 1) {
				this.demon_model.SetTalentFight(scmd)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On18315 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18315)
			this.demon_model.talent_shop_first_open_tips = scmd.open_state == 1
			this.demon_model.RefreshDemonShopRedDot()
		}

		let On18316 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18316)
			if (scmd.code == 1) {
				let demon_data = this.demon_model.GetDemonData(scmd.demons_id)
				if (demon_data) {
					this.res_mgr.GetGameConfigWithAutoDestory("config_demons_skill", (demons_skill_cfgs) => {
						let skill_data = demon_data.GetLifeSkillData(demons_skill_cfgs)
						if (skill_data) {
							skill_data.is_active = 1
							this.demon_model.Fire(DemonEvent.UPDATE_SKILL_DATA, scmd.demons_id, skill_data.skill_id)
							this.demon_model.RefreshLifeSkillRed(demons_skill_cfgs)
							this.demon_model.Fire(DemonEvent.ACTIVE_DEMON_SKILL, scmd.demons_id, skill_data.skill_id)

							PlayBigEffect("ui_ZiTi_Jihuo")
							//Message.show("激活成功")
						}
					}, false)
				}
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On18317 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(18317)
			let demon_data = this.demon_model.GetDemonData(scmd.demons_id)
			if (demon_data) {
				this.res_mgr.GetGameConfigWithAutoDestory("config_demons_skill", (demons_skill_cfgs) => {
					let skill_data = demon_data.GetLifeSkillData(demons_skill_cfgs)
					if (skill_data) {
						skill_data.process = scmd.process
					}
					this.demon_model.Fire(DemonEvent.UPDATE_SKILL_DATA, scmd.demons_id, scmd.skill_id)
					this.demon_model.RefreshLifeSkillRed(demons_skill_cfgs)
				}, false)
			}
		}


		let On50901 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(50901)
			this.demon_model.ChangeVar("bless_value", scmd.bless_value)
		}

		let On50902 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(50902)
			if (scmd.code == 1) {
				this.demon_model.Fire(DemonEvent.GETREWARD, scmd)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		this.RegisterProtocal(18300, On18300)//错误码信息
		this.RegisterProtocal(18301, On18301)//激活的使魔列表(基础信息)
		this.RegisterProtocal(18302, On18302)//使魔战力
		this.RegisterProtocal(18303, On18303)//羁绊列表
		this.RegisterProtocal(18304, On18304)//激活/升星
		this.RegisterProtocal(18305, On18305)//升级
		this.RegisterProtocal(18306, On18306)//使魔跟随
		this.RegisterProtocal(18307, On18307)//上卷信息
		this.RegisterProtocal(18308, On18308)//领取上卷奖励
		// this.RegisterProtocal(18309, On18309)//升级使魔技能
		this.RegisterProtocal(18310, On18310)//使魔镶嵌/升级/替换天赋技能
		this.RegisterProtocal(18311, On18311)//商城信息
		this.RegisterProtocal(18312, On18312)//商城购买
		this.RegisterProtocal(18313, On18313)//商城刷新
		this.RegisterProtocal(18314, On18314)//查看技能真实战力
		this.RegisterProtocal(18315, On18315)//当天第一次打开黑市时返回
		this.RegisterProtocal(18316, On18316)//激活生活技能
		this.RegisterProtocal(18317, On18317)//激活生活技能进度变化
		this.RegisterProtocal(50901, On50901)//获取祝福值
		this.RegisterProtocal(50902, On50902)//转盘
	}

}
window["DemonController"] = DemonController
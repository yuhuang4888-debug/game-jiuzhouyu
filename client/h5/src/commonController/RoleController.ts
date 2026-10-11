import { GoodsModel } from "./../commonModel/GoodsModel"
import { OutWardBaseModel } from "./../commonModel/OutWardBaseModel"
import { BaseController } from "../common/BaseController";
import { RoleManager } from "../commonModel/RoleManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName, LoginStateEvent } from "../common/EventName";
import { SceneManager } from "../scene/SceneManager";
import { PlatformManager } from "../PlatformManager";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { Message, SysInfoType } from "../sysInfo/SysInfoController";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalTimerQuest, LoadLuaClassAB, Util } from "../util/Util";
import { SkillManager } from "../skill/SkillManager";
import { Scene } from "../scene/Scene";
import { ParticleManager } from "../particalEffect/ParticleManager";
import { LoginManager } from "../login/LoginManager";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { ResManager } from "../common/ResManager";
import { LoginModel } from "../login/LoginModel";
import { Config } from "../common/Config";
import { ModulesController } from "../common/ModulesController";
import { CookieWrapper } from "../common/CookieWrapper";
import { MapManager } from "../scene/MapManager";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { RoleModel } from "../commonModel/RoleModel";
import { EquipmentViewSecond_Menu_Type } from "../commonModel/EquipModel";
import { SettingModel } from "../commonModel/SettingModel";
import { RoleView } from "../role/RoleView";
import { SkillSubView } from "../role/SkillSubView";
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel";
import { LayerManager } from "../common/LayerManager";
import { FuncFirstOpenManager } from "../commonModel/FuncFirstOpenManager";

export class RoleController extends BaseController {
	static Instance: RoleController;



	first_receive_13001 = true;
	InitEvents;
	InitInfo;
	role_view
	skill_view

	load_subpackage_promise: Promise<any>
	// func_first_open_mgr:FuncFirstOpenManager
	public constructor() {
		super();

		//处理锁分包加载逻辑 进场景前必须加载完分包
		let load_subpackage_complete
		this.load_subpackage_promise = new Promise<any>((resolve, reject) => {
			load_subpackage_complete = resolve
		})
		if (window["subPackage_loaded"] == false) {
			let time_id = GlobalTimerQuest.AddPeriodQuest(() => {
				if (window["subPackage_loaded"] == false) {

				} else {
					GlobalTimerQuest.CancelQuest(time_id)
					load_subpackage_complete()
				}
			}, 0.2)
		} else {
			load_subpackage_complete()
		}

		let role_mgr = RoleManager.GetInstance(),
			local_GlobalEventSystem = GlobalEventSystem,
			local_EventName = EventName,
			scene_mgr = SceneManager.GetInstance(),
			platform_mgr = PlatformManager.GetInstance(),
			user_msg_adapter = UserMsgAdapter.GetInstance(), 
			local_Message = Message, 
			local_ColorUtil = ColorUtil, 
			local_Util = Util, 
			exp_effect_id_, 
			exp_delay_id_, 
			new_exp_, 
			different_role_login_ = true, 
			change_career = false, 
			skill_mgr = SkillManager.GetInstance();
		this.InitEvents = () => {

			GlobalEventSystem.Bind(RoleModel.OPEN_CHOSE_ROLE_VIEW, (index?, backId?, backShowId?) => {
				var callback = () => {
					if (!this.role_view) {
						this.role_view = new RoleView()
					}
					this.role_view.SetDefaultIndex(index)
					if (backId) {
						this.role_view.SetBackId(backId, backShowId)
					}
					this.role_view.Open()
				}
				LoadLuaClassAB("RoleView", callback)
			}
			)

			GlobalEventSystem.Bind(EventName.SWITCH_ROLE_SECOND_BUTTON, (type?, index?, args?) => {
				var callback = () => {
					if (type == EquipmentViewSecond_Menu_Type.Skill) {
						if (!this.skill_view) {
							this.skill_view = new SkillSubView()
						}
						if (index != null) {
							this.skill_view.SetIndex(index)
							this.skill_view.SetDefaultIndex(index)
							this.skill_view.SetIndexParameter(index, args)
						}
						this.skill_view.Open()
					}
				}
				LoadLuaClassAB("SkillSubView", callback)
			}
			)

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				this.SendFmtToGame(13017);
				this.SendFmtToGame(13011);
				this.SendFmtToGame(13046);
				local_GlobalEventSystem.Fire(local_EventName.REQUEST_ROLE_PROTO, 13080);
				this.SendFmtToGame(13086);
				
			});
			local_GlobalEventSystem.Bind(local_EventName.REQUEST_ROLE_PROTO, (id: number, fmt?: string, ...parms) => {
				this.SendFmtToGame(id, fmt, ...parms);
			});
			// local_GlobalEventSystem.Bind(local_EventName.SET_ROLE_HEAD_ICON, (img_id)=>{
			//     this.SendFmtToGame(13083, "i", img_id)
			// })
			// local_GlobalEventSystem.Bind(local_EventName.GET_ALL_MY_HEAD_ICON, ()=>{
			//     this.SendFmtToGame(13080)
			// })
			RoleManager.GetInstance().GetMainRoleVo().BindOne(
				"exp", () => {
					GlobalEventSystem.Fire(EventName.EXP_CHANGE_WITHOUT_ANIMATION)
				}
			)
			let scene = Scene.GetInstance();
			let particle_mgr = ParticleManager.GetInstance();
			// let onRefreshServerTime = () => {
			//     if (this.first_receive_13001) {
			//         this.first_receive_13001 = false;
			//         LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginLoadingView");
			//     }
			// };
			// this.Bind(ServerTimeModel.REFRESH_SERVER_TIME, onRefreshServerTime);

			let request_13088_func = (module_id, sub_module, key_dic) =>{
				this.WriteBegin(13088)
				this.WriteFMT("h", module_id)
				this.WriteFMT("h", sub_module)
				let len = Util.TableSize(key_dic)
				this.WriteFMT("h", len)
				for(let key in key_dic){
					this.WriteFMT("h", key_dic[key])
				}
				this.SendToGame()
			}
			GlobalEventSystem.Bind(EventName.REQUEST_13088, request_13088_func)


			let first_loading = true
			let onPreloadLoadingCompleted = async () => {
				let res_mgr = ResManager.GetInstance();
				if (first_loading) {
					first_loading = false
					let t1 = Laya.timer.currTimer;
					let t2;
					// local_Message.show("111111111onPreloadLoadingCompleted")
					await res_mgr.LoadConfigZip();
					res_mgr.PreLoadConfigFormZip();
					res_mgr.InitShader()
					await res_mgr.LoadUIConfigZip();
					// t2 = Laya.timer.currTimer;
					// console.warn("LoadConfigZip time = ", t2 - t1)
					// local_Message.show("22222LoadConfigZip" + (t2 - t1).toString())
					// t1 = t2;
					// await res_mgr.PreloadModuleRes();
					// await StoryAnimationModel.GetInstance().PreLoadAnimationRes();
					// await Promise.all([p1, p2]);
					// t2 = Laya.timer.currTimer;
					// console.warn("PreLoadAnimationRes time = ", t2 - t1)
					// local_Message.show("333PreLoadAnimationRes" + (t2 - t1).toString())
					// t1 = t2;
					// await LoginModel.GetInstance().PreLoadGameRes();
					// t2 = Laya.timer.currTimer;
					// console.warn("444PreLoadGameRes = ", t2 - t1)
					// local_Message.show("444PreLoadGameRes" + (t2 - t1).toString())
					// t1 = t2;
					// await LoginModel.GetInstance().first_enter_game_promise
					// if (!local_Util.IsDebug()) {
					// await Config.load_config_promise;
					// }
					if (Util.IsDebug()) {
						await res_mgr.PreloadCommonView()
					}
					await res_mgr.PreloadAtlas()
					await res_mgr.initShaderPromise
					await this.load_subpackage_promise
					res_mgr.InitSprite3dPool()
					MapManager.GetInstance().InitData();
					local_GlobalEventSystem.Fire(local_EventName.LOAD_LOADING_OTHER_RES);
					// await Promise.all([p1, p2, p3, Config.load_config_promise]);
					ModulesController.GetInstance();
					scene_mgr.InitSceneManeger();
					// if (different_role_login_) {
					// 	res_mgr.PreloadMainRoleRes();
					// }
					// if(!res_mgr.mainui_has_loaded)
					// {
					// }
					// res_mgr.mainui_has_loaded = true

					res_mgr.preload_complete = true
					// local_GlobalEventSystem.Fire(local_EventName.INIT_CONFIG);
					res_mgr.TriggerGameStart();
					user_msg_adapter.ReceiveAllCacheMessage()
				}
				else {
					res_mgr.TriggerGameStart();
				}
				// MainUIModel.GetInstance().SetLoadedMainUICallback(()=>{
				//     res_mgr.TriggerGameStart();
				// })

				// res_mgr.TriggerGameStart();
			};
			this.Bind(local_EventName.PRELOAD_LOADING_COMPLETED, onPreloadLoadingCompleted);
		};
		this.InitInfo = () => {
			let On13001 = () => {
				platform_mgr.DataPlacement(90300);
				this.first_receive_13001 = true;
				let old_mainrole_id = role_mgr.GetMainRoleId();
				role_mgr.GetMainRoleVo().ReadFrom13001();
				let role_id = role_mgr.GetMainRoleId()
				CookieWrapper.GetInstance().InitInfo(role_id);
				platform_mgr.DataPost(1);
				platform_mgr.EyouDataPlacement("game_completed");
				if (old_mainrole_id != role_id) {
					different_role_login_ = true;
				}
				else {
					different_role_login_ = false;
				}
				if(window['thinkingdata'])
				{
					window['thinkingdata'].login(role_id);
				}
				platform_mgr.DataPlacement(90400);
				LoginManager.GetInstance().SetGameStartReceiveFlag("13001", true)
				LoginModel.GetInstance().SaveInsideNoticeRed()
			};
			let On13002 = () => {
				new_exp_ = user_msg_adapter.ReadFmt("l");
				// if (!exp_delay_id_) {
				//     exp_delay_id_ = egret.setTimeout(() => {
				//         exp_delay_id_ = null
				role_mgr.GetMainRoleVo().ChangeVar("exp", new_exp_);
				// }, this, 1000)
				// }
			};
			let On13003 = () => {
				role_mgr.GetMainRoleVo().ReadFrom13003();
			};
			let On13006 = () => {
				let [tong, jin, jinLock, guild_coin] = user_msg_adapter.ReadFmt("liii");
				Laya.timer.callLater(this, () => {
					role_mgr.mainRoleInfo.ChangeVar("tong", tong);
					role_mgr.mainRoleInfo.ChangeVar("jinLock", jinLock);
					role_mgr.mainRoleInfo.ChangeVar("jin", jin);
					role_mgr.mainRoleInfo.ChangeVar("guild_coin", guild_coin);
				});
			};
			let On13013 = () => {
				let scmd13013;
				scmd13013 = {};
				scmd13013.server_id = user_msg_adapter.ReadFmt("h");
				scmd13013.player_num = user_msg_adapter.ReadFmt("h");
				scmd13013.player_id = user_msg_adapter.ReadFmt("l");
				scmd13013.module_id = user_msg_adapter.ReadFmt("h");
				scmd13013.fighting = user_msg_adapter.ReadFmt("l");
				new FigureProtoVo().ReadFmt(scmd13013);
				scmd13013.platform = user_msg_adapter.ReadFmt("s");
				local_GlobalEventSystem.Fire(local_EventName.GET_ROLE_FIGURE_INFO_RETURN, scmd13013);
			};
			let On13017 = () => {
				role_mgr.GetMainRoleVo().ReadFrom13017();
			}
			let On13020 = () => {
				let len = this.ReadFmt("h")
				for (let i = 0; i < len; i++) {
					let skill_id = this.ReadFmt("i")
					let cfg = SkillManager.Instance.getSkillFromConfig(skill_id)
					if (cfg && cfg.type == 2) {
						SkillManager.Instance.AddSkillToSkillList(skill_id)
					}
				}
			}
			let On13033 = () => {
				role_mgr.GetMainRoleVo().ReadFrom13033();
			};
			let On13036 = () => {
				//0:无类型 1:GM 2:任务 3:个人杀怪 4:副本 5:队伍杀怪 6:物品使用加经验 7:离线经验找回 8:帮派宴会 9:挂机经验物品找回
				let [expType, exp, percent] = user_msg_adapter.ReadFmt("clh")
				if (expType == 3) {
					if (scene_mgr.IsExpDungeon()) {
						BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.UPDATE_EXP, exp)
					}
				} else if (expType == 6) {
					Message.showExp("e " + (exp))
					return
				} else if (expType == 0) {
					Message.showExp("e " + (exp))
					return
				} else if (expType == 14) {
					percent = percent - 100
					if (percent > 0) {
						Message.showExp("e " + exp + "l + " + percent + "%r")
					} else {
						Message.showExp("e " + (exp))
					}
					return
				} else if (expType == 8) {
					percent = percent - 100
					if (percent > 0) {
						Message.showExp("e " + exp + "l + " + percent + "%r")
					} else {
						Message.showExp("e " + (exp))
					}
					return
				} else if (expType == 6 || expType == 8 || expType == 2) {
					if (PlatformManager.IsEyouThPlatform()) {
						local_Message.show(`<font color='#ffffff'>ได้รับ</font> <font color=${local_ColorUtil.GetColorLight(1)}>Exp x${exp}</font>`, false, SysInfoType.MINI);
					}else{
						local_Message.show(`<font color='#ffffff'>获得</font> <font color=${local_ColorUtil.GetColorLight(1)}>经验 x${exp}</font>`, false, SysInfoType.MINI);
					}
				
					return;
				}

				//经验统一飘字
				if ((scene_mgr.curr_dun_id || scene_mgr.IsNoonPartyScene()) && !scene_mgr.IsFieldScene()) //野外挂机场景不需要
				{
					let str = "";
					if (expType != 0) {
						percent = percent - 100;
						if (percent > 0) {
							Message.showExp("e " + exp + "l + " + percent + "%r")
						}
						else {
							if (PlatformManager.IsEyouThPlatform()) {
								str = `<font color='#ffffff'>ได้รับ</font> <font color='#00fa64'>Exp x${exp}</font>`;
							}else{
								str = `<font color='#ffffff'>获得</font> <font color='#00fa64'>经验 x${exp}</font>`;

							}
							Message.showExp("e " + exp)
						}
					}
					else {
						Message.showExp("e " + exp)
					}
				}
			};
			//世界等级
			let On13011 = () => {
				role_mgr.GetMainRoleVo().ReadFrom13011();
			};
			//转职
			let On13045 = () => {
				let scmd13045;
				scmd13045 = {};
				scmd13045.error_code = user_msg_adapter.ReadFmt("i");
				scmd13045.args = user_msg_adapter.ReadFmt("s");
				scmd13045.career = user_msg_adapter.ReadFmt("c");
				scmd13045.sex = user_msg_adapter.ReadFmt("c");
				if (scmd13045.error_code != 1)
					Util.ErrorCodeShow(scmd13045.error_code, scmd13045.args);
				else {
					local_GlobalEventSystem.Fire(local_EventName.CHANGE_MAINROLE_CAREER);
					let data = {
						_type: -1,
						color_id: 0,
						type_id: 0
					}
					GoodsModel.GetInstance().Fire(GoodsModel.FIGURE_ASK_EQUIPGOODS);
					OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data, -1)
				}
			};
			let On13046 = () => {
				let scmd13046;
				scmd13046 = {};
				scmd13046.change_career_time = user_msg_adapter.ReadFmt("i");
				role_mgr.change_career_time = scmd13046.change_career_time;
			};
			//激活的头像列表
			let On13080 = () => {
				let len = this.ReadFmt("h");
				let head_list = [];
				for (let i = 0; i < len; i++) {
					let head_id = this.ReadFmt("i");
					head_list.push(head_id);
				}
				role_mgr.SetHeadImgList(head_list);
			};
			//激活头像
			let On13081 = () => {
				let code = this.ReadFmt("c");
				let head_id = this.ReadFmt("i");
				if (code == 1) {
					role_mgr.UpdateHeadImgList(head_id);
				}
				else if (code == 2) {
					local_Message.show("没有此头像");
				}
				else if (code == 3) {
					local_Message.show("已经激活过");
				}
				else if (code == 4) {
					local_Message.show("物品不足");
				}
				else if (code == 5) {
					local_Message.show("性别不符");
				}
				else {
					local_Util.ErrorCodeShow(code);
				}
			};
			//设置玩家头像
			let On13083 = () => {
				let code = this.ReadFmt("i");
				let head_ver = this.ReadFmt("i");
				let head_id_str = this.ReadFmt("s");
				if (code == 1) {
					role_mgr.mainRoleInfo.ChangeVar("picture", head_id_str); //刷新头像
					local_GlobalEventSystem.Fire(local_EventName.SELECT_ROLE_HEAD_ICON_SUCCESS);
				}
				else if (code == 2) {
					local_Message.show("你已被管理员禁止设置头像");
				}
				else if (code == 4) {
					local_Message.show("你没有该头像");
				}
				else {
					local_Util.ErrorCodeShow(code);
				}
			};
			//查看玩家指定数据
			let On13086 = () => {
				let len = this.ReadFmt("h");
				let times;
				let style;
				for (let i = 0; i < len; i++) {
					style = this.ReadFmt("c");
					times = this.ReadFmt("i");
					role_mgr.role_platform_times_data[style] = times;
				}
				console.warn("role_mgr.role_platform_times_data-------------：", role_mgr.role_platform_times_data[1]);
				console.warn("role_mgr.role_platform_times_data-------------：", role_mgr.role_platform_times_data[2]);
				console.warn("role_mgr.role_platform_times_data-------------：", role_mgr.role_platform_times_data[3]);
			};
			//角色终身次数信息
			let On13088 = () => {
				let module_id = this.ReadFmt("h");
				let sub_module = this.ReadFmt("h")
				let len = this.ReadFmt("h")

				for (let i = 0; i < len; i++) {
					var type = this.ReadFmt("h")
					var count = this.ReadFmt("h")
					role_mgr.SetLivelongCount(module_id, sub_module, type, count)
				}
				GlobalEventSystem.Fire(EventName.UPDATE_LIVELONG_COUNT, module_id, sub_module)
				if(module_id == FuncFirstOpenManager.MoudleId && sub_module == FuncFirstOpenManager.SubModuleId){
					LoginManager.GetInstance().SetGameStartReceiveFlag("13088@300@1", true)
				}
			}

			//角色终身次数信息+1
			let On13089 = () => {
				let module_id = this.ReadFmt("h");
				let sub_module = this.ReadFmt("h")
				let type = this.ReadFmt("h")
				let count = this.ReadFmt("h")
				role_mgr.SetLivelongCount(module_id, sub_module, type, count)
				GlobalEventSystem.Fire(EventName.UPDATE_LIVELONG_COUNT, module_id, sub_module, type)
			}

			//改角色名
			let On42601 = () => {
				let scmd = user_msg_adapter.GetSCMD(42601);
				if (scmd.result == 1) {
					local_Message.show("改名成功");
					role_mgr.mainRoleInfo.ChangeVar("name", scmd.name);
					local_GlobalEventSystem.Fire(local_EventName.CHANGE_NAME_SUCCESS);
				}
				else if (scmd.result == 2) {
					local_Message.show("为角色名已经被使用");
				}
				else if (scmd.result == 3) {
					local_Message.show("包含非法字符");
				}
				else if (scmd.result == 4) {
					local_Message.show("角色名称长度为2~6个汉字");
				}
				else if (scmd.result == 5) {
					local_Message.show("包含敏感词");
				}
				else if (scmd.result == 6) {
					local_Message.show("修改失败");
				}
				else {
					local_Util.ErrorCodeShow(scmd.result);
				}
			};
			//是否免费
			let On42602 = () => {
				let scmd = user_msg_adapter.GetSCMD(42602);
				SettingModel.GetInstance().Fire(SettingModel.SETTING_OPEN_VIEW, "SettingChangeNameView", scmd.result)
			};
			//是否能改名字
			let On42604 = () => {
				let scmd = user_msg_adapter.GetSCMD(42604);
				if (scmd.result == 1) {
					local_GlobalEventSystem.Fire(local_EventName.CAN_USE_THIS_NAME, scmd);
				}
				else {
					local_Util.ErrorCodeShow(scmd.result);
				}
			};
			this.RegisterProtocal(13001, On13001);
			this.RegisterProtocal(13002, On13002);
			this.RegisterProtocal(13003, On13003);
			this.RegisterProtocal(13006, On13006);
			this.RegisterProtocal(13013, On13013); //请求玩家figure
			this.RegisterProtocal(13017, On13017); //玩家托管状态
			this.RegisterProtocal(13020, On13020);
			this.RegisterProtocal(13033, On13033);
			this.RegisterProtocal(13036, On13036);
			this.RegisterProtocal(13011, On13011);
			this.RegisterProtocal(13045, On13045);
			this.RegisterProtocal(13046, On13046);
			this.RegisterProtocal(13080, On13080); //激活的头像列表
			this.RegisterProtocal(13081, On13081); //激活头像
			this.RegisterProtocal(13083, On13083); //设置玩家头像
			this.RegisterProtocal(13086, On13086); //查看玩家指定数据#渠道需求 
			this.RegisterProtocal(13088, On13088); //角色终身次数信息
			this.RegisterProtocal(13089, On13089); //角色终身次数信息+1
			this.RegisterProtocal(42601, On42601); //改角色名
			this.RegisterProtocal(42602, On42602); //是否免费
			this.RegisterProtocal(42604, On42604); //是否能改名字
		};
		this.InitEvents();
		this.InitInfo();
	}
	public static GetInstance() {
		if (!RoleController.Instance) {
			RoleController.Instance = new RoleController();
		}
		return RoleController.Instance;
	}
}

window["RoleController"] = RoleController
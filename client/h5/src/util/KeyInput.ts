import { ClientConfig, GlobalEventSystem } from "./DeclareGlobalVar";
import { EventName, SceneEventType } from "../common/EventName";
import { AutoFightManager } from "../autofight/AutoFightManager";
import { ResManager } from "../common/ResManager";
import { Scene } from "../scene/Scene";
import { Vector2 } from "./Vector2";
import { RoleManager } from "../commonModel/RoleManager";
import { MainRoleVo } from "../sharedata/MainRoleVo";
import { FigureProtoVo } from "../common/FigureProtoVo";
// import { TaskModel } from "../commonModel/TaskModel";
// import { TaskView } from "../task/TaskView";
import { DialogueModel } from "../commonModel/DialogueModel";
import { SkillUIModel } from "../commonModel/SkillUIModel";
import { FightEvent } from "../scene/fight/FightEvent";
import { SkillManager } from "../skill/SkillManager";
import { TaskModel } from "../commonModel/TaskModel";
import { TaskView } from "../task/TaskView";
import { GuardModel } from "../commonModel/GuardModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { Message } from "../sysInfo/SysInfoController";
import { Util } from "./Util";
import { GameResPath } from "./GameResPath";
import { Enum_UILayer, LayerManager } from "../common/LayerManager";
import { ParticleManager } from "../particalEffect/ParticleManager";
import { EffectResType } from "../scene/SceneConfig";

import { OutLineTipsView } from "../outline/OutLineTipsView";
import { Alert_Type } from "../alert/Alert";
import { OpenFun } from "../common/OpenFun";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { LoginModel } from "../login/LoginModel";

//https://www.cnblogs.com/hsapphire/archive/2009/12/16/1625642.html
export class KeyInput {
	static ctrl_is_down = false
	Init;
	UpdateKeyMove;
	key_w_down = false;
	key_s_down = false;
	key_a_down = false;
	key_d_down = false;
	enable = false
	last__tempCache = {};
	static CheatViewHasOpen: boolean;
	test_fight_add = 0
	public constructor() {
		this.Init = () => {
			document.addEventListener("keydown", (evt: any) => {
				if (Laya.Input.isInputting) return
				if (!LoginModel.GetInstance().plat_name) {
					switch (evt.keyCode) {
						case 17: //ctrl		
							// KeyInput.ctrl_is_down = true;
							// Laya.MouseManager.enabled = false
							break;
						// case 81: //Q		//隐藏或显示绿色背景
						// 	GlobalEventSystem.Fire(EventName.SHOW_GREEN_BG);
						// 	break;
						case 81: //Q		//隐藏或显示所有ui层
						    GlobalEventSystem.Fire(EventName.HIDE_OR_SHOW_ALL_UI_CANVAS_LAYER);
							break;
					case 69: //E
							//GlobalEventSystem.Fire(EventName.SHOW_GREEN_BG);
							break;
						case 90: //Z
							if ((ClientConfig.TestYouWant && ClientConfig.TestYouWant == 1) || false == ClientConfig.account_server || !LoginModel.GetInstance().plat_name) {
								GlobalEventSystem.Fire(EventName.OPEN_CHEAT_CLIENT_VIEW)
							}
							break;
						case 66: //B
							// ResManager.GetInstance().RecordCurrResInfo();
							break;
						case 67: //C
							// ResManager.GetInstance().PrintAddResInfo();
							let fighting = RoleManager.GetInstance().GetMainRoleVo().fighting
							this.test_fight_add += 1000
							GlobalEventSystem.Fire(EventName.DELAY_SHOW_FIGHTUP, null, fighting + this.test_fight_add, fighting)
							break;
							// case 68: //D
							//     // RES.profile()
							//     let __tempCache = RES["host"].state;
							//     console.warn("-------------------资源使用情况---------------- ");
							//     if (__tempCache) {
							//         let curr_cache = {};
							//         for (var key in __tempCache) {
							//             if (!this.last__tempCache[key] && key.indexOf(".jxr") == -1 && key.indexOf(".exml") == -1 && key.indexOf(".res.json") == -1) {
							//                 console.warn("-------------------新增资源 ", key);
							//             }
							//             curr_cache[key] = true;
							//         }
							//         for (var key in this.last__tempCache) {
							//             if (!__tempCache[key] && key.indexOf(".jxr") == -1 && key.indexOf(".exml") == -1 && key.indexOf(".res.json") == -1) {
							//                 console.warn("-------------------减少资源 ", key);
							//             }
							//         }
							//         this.last__tempCache = curr_cache;
							//     }
							//     break;
							// case 83: //S 不能提交外服
							//     ResManager.GetInstance().start_save_silent_res = true;
							break;
						case 80: //P 不能提交外服
							// ResManager.GetInstance().PrintSilentResLoadQueue();
							// OpenFun.OpenFunHandler(102)
							break;
						case 76: //L
							GlobalEventSystem.Fire(EventName.OPEN_BAG_VIEW)
							break;
						case 112: //+F1
							break;
						case 114: //F2
							if (Laya.Shader3D.debugMode) {
								Laya.Shader3D.debugMode = false
								Message.show("关闭调试模式")
							}
							else {
								Laya.Shader3D.debugMode = true
								Message.show("开启调试模式")
							}
							break;
						case 115: //F4
							let arr, shaderObj = {}
							for (let i = 0; i < Laya.Shader3D.debugShaderVariantCollection.variantCount; i++) {
								let shadervariant: Laya.ShaderVariant = Laya.Shader3D.debugShaderVariantCollection.getByIndex(i);
								let shaderName: string = shadervariant.shader.name;
								if (!shaderObj[shaderName])
									shaderObj[shaderName] = [];
								arr = shaderObj[shaderName];
								let obj: any = {};
								obj.defineNames = shadervariant.defineNames;
								obj.passIndex = shadervariant.passIndex;
								obj.subShaderIndex = shadervariant.subShaderIndex;
								obj.defineMask = []
								if (obj.defineNames) {
									for (var j = 0; j < obj.defineNames.length; j++) {
										let define: Laya.ShaderDefine = Laya.Shader3D.getDefineByName(obj.defineNames[j])
										var index: number = define["_index"];
										obj.defineMask[index] = define["_value"];
									}
								}
								arr.push(obj);
							}
							this.Download("ConfigShaderObj", JSON.stringify(shaderObj), "json")
							break;
						case 84:
							let cfg = SkillManager.GetInstance().GetFightSkillMovie(901050)

							if (cfg) {
								cfg = cfg.particles[0]
								let main_role = Scene.Instance.main_role

								let pos = new Vector2(main_role.real_pos.x, main_role.real_pos.y)
								let atr = main_role.GetDirection()
								let attacker_dir = new Vector2(atr.x, atr.y)
								let effect_res_type = EffectResType.Monster
								ParticleManager.GetInstance().AddPosEffect(cfg.res, pos, false, 0, attacker_dir, null, null, null, null, 1, cfg.max_depth, null, null, null, null, effect_res_type)
							}
							break;
						case 89: //Y
							// LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginAlertView")
							//ViewPopLevelModel.GetInstance().SetView('DailyActTipView');
							// Laya.timer.scale = 1
							//GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonFightSceneMaskView")
							//FirstRechargeModel.GetInstance().Fire(FirstRechargeModel.OPEN_FIRST_RECHARGE_TIPS_VIEW)
							// let list:[] = window["package_obj"]
							// if(list)
							// {
							// 	let str = "["
							// 	list.forEach((item) =>{
							// 		str = 
							// 	}, this)
							// }
							console.log(window["package_obj"])
							this.Download("package_obj", JSON.stringify(window["package_obj"]), "json")
							break;
						case 77: //M
							if (Util.IsDebug()) {
								window["CheatModel"] && window["CheatModel"].GetInstance().RefreshClientConfig()
							}
							break
						case 78: //N
							// if ((ClientConfig.TestYouWant && ClientConfig.TestYouWant == 1) || false == ClientConfig.account_server || !LoginModel.GetInstance().plat_name) {
							// 	GlobalEventSystem.Fire(EventName.OPEN_TEST_VIEW)
							// }
							break;
						case 88: //X
							if (!window["test_index"]) {
								window["test_index"] = 0
							}
							let type = window["test_index"] % 3 + 1
							let stage_width = window["LayerManager"].GetInstance().stageWidth,
								stage_height = window["LayerManager"].GetInstance().stageHeight
							window["MainUIController"].GetInstance().ShowDiamond(type, 100, { x: window["Util"].RandomRange(0, stage_width), y: window["Util"].RandomRange(0, stage_height) })
							window["test_index"]++
							break;
						case 18:
							// if (!CheatModel.GetInstance().is_ctrl) {
							// 	CheatModel.GetInstance().is_ctrl = true
							// }
							break;
					}
				}

				let bool = false;

				if (evt.keyCode == 87)//w
				{
					this.key_w_down = true;
					bool = true;
				}

				if (evt.keyCode == 65)//a
				{
					this.key_a_down = true;
					bool = true;
				}

				if (evt.keyCode == 83)//s
				{
					this.key_s_down = true;
					bool = true;
				}

				if (evt.keyCode == 68)//d
				{
					this.key_d_down = true;
					bool = true;
				}

				if (bool) {
					this.UpdateKeyMove();
				}
			});

			// "keyup": KeyboardEvent;
			document.addEventListener("keyup", (evt: any) => {
				if (Laya.Input.isInputting) return
				if (!LoginModel.GetInstance().plat_name) {
					switch (evt.keyCode) {
						case 17: //ctrl
							// KeyInput.ctrl_is_down = false;
							// Laya.MouseManager.enabled = true;


							// Laya.MouseManager.instance['check'] = source_check
							break;
						case 79: //O
							if (window["Scene"]) {
								if (window["Scene"].TestMode) {
									window["Scene"].TestMode = false
									Message.show("关闭场景测试")
								}
								else {
									window["Scene"].TestMode = true
									Message.show("开启场景测试")
								}
							}
							break
						case 49://1
							let career1 = RoleManager.GetInstance().GetMainRoleCareer()
							let short_skill_id1 = SkillUIModel.GetInstance().GetCommonSkill(career1)
							if (short_skill_id1) {
								GlobalEventSystem.Fire(FightEvent.SKILL_SHORTCUT_CLICK, short_skill_id1)
							}
							break;
						case 50://2
							let skill_list1 = SkillManager.GetInstance().GetShortCutList()
							if (skill_list1 && skill_list1[0]) {
								let skill_vo = skill_list1[0]
								if (skill_vo && skill_vo.level != 0 && skill_vo.CoolDown())
									GlobalEventSystem.Fire(FightEvent.SKILL_SHORTCUT_CLICK, skill_vo.id)
							}
							break;
						case 51://3
							let skill_list2 = SkillManager.GetInstance().GetShortCutList()
							if (skill_list2 && skill_list2[1]) {
								let skill_vo = skill_list2[1]
								if (skill_vo && skill_vo.level != 0 && skill_vo.CoolDown())
									GlobalEventSystem.Fire(FightEvent.SKILL_SHORTCUT_CLICK, skill_vo.id)
							}
							break;
						case 52://4
							let skill_list3 = SkillManager.GetInstance().GetShortCutList()
							if (skill_list3 && skill_list3[2]) {
								let skill_vo = skill_list3[2]
								if (skill_vo && skill_vo.level != 0 && skill_vo.CoolDown())
									GlobalEventSystem.Fire(FightEvent.SKILL_SHORTCUT_CLICK, skill_vo.id)
							}
							break;
						case 53://5
							let skill_list4 = SkillManager.GetInstance().GetShortCutList()
							if (skill_list4 && skill_list4[3]) {
								let skill_vo = skill_list4[3]
								if (skill_vo && skill_vo.level != 0 && skill_vo.CoolDown())
									GlobalEventSystem.Fire(FightEvent.SKILL_SHORTCUT_CLICK, skill_vo.id)
							}
							break;
						case 18://alt
							// if (CheatModel.GetInstance().is_ctrl) {
							// 	CheatModel.GetInstance().is_ctrl = false
							// }
							break

					}
				}

				let bool = false;

				if (evt.keyCode == 87)//w
				{
					this.key_w_down = false;
					bool = true;
				}

				if (evt.keyCode == 65)//a
				{
					this.key_a_down = false;
					bool = true;
				}

				if (evt.keyCode == 83)//s
				{
					this.key_s_down = false;
					bool = true;
				}

				if (evt.keyCode == 68)//d
				{
					this.key_d_down = false;
					bool = true;
				}

				if (bool) {
					this.UpdateKeyMove();
				}

			});
		}

		// "keypress": KeyboardEvent;
		// document.addEventListener("keypress", (evt: any) => {
		// });

		this.UpdateKeyMove = () => {
			let x = 0, y = 0;
			if (this.key_a_down && !this.key_d_down) {
				x = -1;
			}
			else if (!this.key_a_down && this.key_d_down) {
				x = 1;
			}

			if (this.key_w_down && !this.key_s_down) {
				y = -1;
			}
			else if (!this.key_w_down && this.key_s_down) {
				y = 1;
			}

			let main_role = Scene.GetInstance().GetMainRole()
			if (main_role) {
				if (x == 0 && y == 0) {
					main_role.DoStand()
				} else {
					// console.log("KeyInput@UpdateKeyMove@",x,y)
					main_role.DoDirectionMove(new Vector2(x, y))
				}
			}

		}

		this.Init();
	}


	Download(filename, text, ext = "text") {
		let element = document.createElement('a');
		element.setAttribute('href', `data:${ext}/plain;charset=utf-8,` + encodeURIComponent(text));
		element.setAttribute('download', filename);
		element.style.display = 'none';
		document.body.appendChild(element);
		element.click();
		document.body.removeChild(element);
	}

}

window["KeyInput"] = KeyInput

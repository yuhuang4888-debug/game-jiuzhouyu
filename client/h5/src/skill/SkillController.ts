import { BaseController } from "../common/BaseController";
import { SkillManager } from "./SkillManager";
import { EventName } from "../common/EventName";
import { RoleManager } from "../commonModel/RoleManager";
import { GlobalTimerQuest, Util } from "../util/Util";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { SkillUIModel } from "../commonModel/SkillUIModel";
import { MainUIModel } from "../commonModel/MainUIModel";
import { CompositeModel } from "../commonModel/CompositeModel";
import { OutLineModel } from "../commonModel/OutLineModel";
import { ErlangParser } from "../util/ErlangParser";
// TypeScript file
export class SkillController extends BaseController {
    static Instance: SkillController;
    public view_dic = {};
    InitEvents;
    InitInfo;
    public constructor() {
        super();
        let model = SkillManager.GetInstance(), local_EventName = EventName, local_SkillManager = SkillManager, REQUEST_CCMD_EVENT = SkillManager.REQUEST_CCMD_EVENT, role_mgr = RoleManager.GetInstance(), local_Util = Util, user_msg_adapter = UserMsgAdapter.GetInstance(), local_Message = Message;
        this.InitEvents = () => {
            let game_start_func = () => {
            };
            this.Bind(local_EventName.INIT_CONFIG, game_start_func);
            GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
                GlobalTimerQuest.AddDelayQuest(() => {
                    model.Fire(REQUEST_CCMD_EVENT, 21002);
                    model.Fire(REQUEST_CCMD_EVENT, 21101);
                    model.Fire(REQUEST_CCMD_EVENT, 13007);
                    // model.Fire(REQUEST_CCMD_EVENT, 21003)
                    // if (SkillUIModel.Instance().GetInnateOpenStatus() ) {
						model.Fire(REQUEST_CCMD_EVENT, 21010)
					// }
                    model.Fire(REQUEST_CCMD_EVENT, 18401)
                }, 2);
            });
            let onRequestHandler = (...args) => {
                if (args[0] == 21001 || args[0] == 21011 || args[0] == 21004 || args[0] == 21102 || args[0] == 21103)
                    this.SendFmtToGame(args[0], "i", args[1]);
                else if (args[0] == 21104)
                    this.SendFmtToGame(args[0], "c", args[1]);
                else if (args[0] == 13008)
                    this.SendFmtToGame(args[0], "ccic", args[1], args[2], args[3], args[4]);
                else if (args[0] == 13010)
                    this.SendFmtToGame(args[0], "cc", args[1], args[2]);
                else
                    this.SendFmtToGame(args[0]);
            };
            model.Bind(REQUEST_CCMD_EVENT, onRequestHandler);
            // role_mgr.GetMainRoleVo().BindOne("tong", (name, value, old_value, parm) => {
            //     if (value > old_value) {
            //         let red = RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.SKILL_STREN)
            //         if (red) return
            //     }
            //     uiModel.CheckSkillStrenReddotAll(value > old_value)
            //     // uiModel.CheckSkillStrenReddotAllFireEvent(value > old_value)
            // })
            let delay_timer_id;
            role_mgr.GetMainRoleVo().BindOne(local_EventName.CHANGE_LEVEL, (level) => {
                if (delay_timer_id) {
                    GlobalTimerQuest.CancelQuest(delay_timer_id);
                    delay_timer_id = null;
                }
            });
            role_mgr.GetMainRoleVo().BindOne("god_id", () => {
                //暂时不清空技能使用时间戳
                model.auto_fight_index = 0;
            });
           
            role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, () => {
                SkillManager.GetInstance().Fire(SkillManager.REQUEST_CCMD_EVENT, 21010)
            })

            role_mgr.GetMainRoleVo().BindOne("turn", () => {
				if(role_mgr.GetMainRoleVo().turn == SkillUIModel.GetInstance().innate_open_turn_cond){
                    SkillManager.GetInstance().Fire(SkillManager.REQUEST_CCMD_EVENT, 21010)
                }
			})
        };
        this.InitInfo = () => {
            let On21001 = () => {
                let [errcode, skill_id] = this.ReadFmt("ii");
                if (errcode != 1) {
                    local_Util.ErrorCodeShow(errcode);
                }
                else {
                    model.Fire(local_SkillManager.LEVEL_UP_SUCCESS, skill_id);
                }
            };
            let On21002 = () => {
                model.CreateSkillList();
                model.SetUnlockSkillListForce(); //刷新技能快捷栏
            };
            let On21010 = () => {
                let scmd = user_msg_adapter.GetSCMD(21010); //new SCMD21010
                SkillUIModel.GetInstance().SetInnateInfo(scmd)
                SkillUIModel.GetInstance().Fire(SkillUIModel.UPDATE_INNATE_VIEW)
                SkillUIModel.GetInstance().UpdateInnateRed()
            };
            let On21011 = () => {
                let scmd = user_msg_adapter.GetSCMD(21011); //new SCMD21011
                if (scmd.errcode != 1) {
                    local_Util.ErrorCodeShow(scmd.errcode);
                    return;
                }
                model.Fire(REQUEST_CCMD_EVENT, 21010);
                // SkillUIModel.GetInstance().UpdateInnateInfo(scmd)
                SkillUIModel.GetInstance().Fire(SkillUIModel.UPDATE_INNATE_VIEW, true)
                // SkillUIModel.GetInstance().UpdateInnateRed()
            };
            let On21012 = () => {
                let scmd = user_msg_adapter.GetSCMD(21012); //new SCMD21012
                if (scmd.errcode == 1) {
                    local_Message.show(`天赋重置成功`);
                    model.Fire(REQUEST_CCMD_EVENT, 21010);
                }
                else {
                    local_Util.ErrorCodeShow(scmd.errcode);
                }
            };
            let on21003 = () => {
                let scmd = user_msg_adapter.GetSCMD(21003); //UserMsgAdapter.GetInstance().GetSCMD(21003)
            };
            let on21004 = () => {
                let scmd = user_msg_adapter.GetSCMD(21004); //UserMsgAdapter.GetInstance().GetSCMD(21004)
                if (scmd.errcode == 1) {
                    model.Fire(REQUEST_CCMD_EVENT, 21003);
                }
                else {
                    local_Util.ErrorCodeShow(scmd.errcode);
                    //金币获取途径
                }
            };
            let on21005 = () => {
                let scmd = user_msg_adapter.GetSCMD(21005); // UserMsgAdapter.GetInstance().GetSCMD(21005)
                if (scmd.errcode == 1) {
                    model.Fire(REQUEST_CCMD_EVENT, 21003);
                }
                else {
                    local_Util.ErrorCodeShow(scmd.errcode);
                    //金币获取途径
                }
            };
            let on21101 = () => {
                let scmd = user_msg_adapter.GetSCMD(21101);
            };
            let on21102 = () => {
                let scmd = user_msg_adapter.GetSCMD(21102);
                if (scmd.error_code == 1) {
                    local_Message.show("操作成功");
                    model.Fire(REQUEST_CCMD_EVENT, 21002); //刷新技能总表
                }
                else {
                    local_Util.ErrorCodeShow(scmd.error_code);
                }
            };
            let on21103 = () => {
                let scmd = user_msg_adapter.GetSCMD(21103);
                if (scmd.error_code == 1) {
                    local_Message.show("突破成功");
                    model.Fire(REQUEST_CCMD_EVENT, 21002); //刷新技能总表
                }
                else {
                    local_Util.ErrorCodeShow(scmd.error_code);
                }
            };
            let on21104 = () => {
                let scmd = user_msg_adapter.GetSCMD(21104);
                if (scmd.error_code == 1) {
                    local_Message.show("选择核心成功");
                    model.Fire(REQUEST_CCMD_EVENT, 21101);
                }
                else {
                    local_Util.ErrorCodeShow(scmd.error_code);
                }
            };
            let on13007 = () => {
                let skill_bar_info = [];
                let len = user_msg_adapter.ReadFmt("h");
                for (let i = 0; i < len; i++) {
                    let obj;
                    obj = {};
                    obj.pos = user_msg_adapter.ReadFmt("c");
                    obj.type = user_msg_adapter.ReadFmt("c");
                    obj.skill_id = user_msg_adapter.ReadFmt("i");
                    obj.is_auto = user_msg_adapter.ReadFmt("c");
                    skill_bar_info.push(obj);
                }
                let sort_fun = (a, b) => {
                    return a.pos - b.pos;
                };
                skill_bar_info.sort(sort_fun);
                model.skill_bar_info = skill_bar_info;
                model.SetUnlockSkillListForce();
                Laya.timer.callLater(this, () => {
                    model.Fire(local_SkillManager.UPDATE_SKILL_BAR_INFO);
                });
            };
            let on13008 = () => {
                let code = user_msg_adapter.ReadFmt("c");
                if (code == 1) {
                    local_Message.show("保存成功");
                    model.Fire(REQUEST_CCMD_EVENT, 13007);
                }
                else {
                    local_Util.ErrorCodeShow(code);
                }
            };
            let on13010 = () => {
                let code = user_msg_adapter.ReadFmt("c");
                if (code == 1) {
                    local_Message.show("替换成功");
                    model.Fire(REQUEST_CCMD_EVENT, 13007);
                }
                else {
                    local_Util.ErrorCodeShow(code);
                }
            };
            let on12093 = () =>{
                let len = user_msg_adapter.ReadFmt("h")
                let career_skill_buff_list = []
                for(let i = 0; i < len; i++){
                    career_skill_buff_list[i] = [
                        user_msg_adapter.ReadFmt("i"),
                        user_msg_adapter.ReadFmt("h") 
                    ]
                }
                SkillUIModel.GetInstance().career_skill_buff_list = career_skill_buff_list
                SkillUIModel.GetInstance().Fire(SkillUIModel.UPDATE_CAREER_SKILL_BUFF)
            }


            let on18401 = () => {
                let scmd = user_msg_adapter.GetSCMD(18401)
                for (let _ in scmd.buff_list) {
                    var vo = scmd.buff_list[_]
                    if (vo.key == 2 ) {
                        let list = ErlangParser.GetInstance().Parse(vo.values)
                        let onhook_time
                        for (let _ = 0; _ < list.length; _++) {
                            var data = list[_]
                            if (data[0] == "onhook_time" ) {
                                onhook_time = data[1]
                                break
                            }
                        }
    
                        if (onhook_time ) {
                            OutLineModel.GetInstance().max_outline_time = (20 * 3600 + Number(onhook_time))
                        }
    
                    } else if (vo.key == 6 ) {
                        CompositeModel.GetInstance().lifeSkillAdd = Number(vo.values)
                    }
                }
            }
    


            this.RegisterProtocal(21001, On21001);
            this.RegisterProtocal(21002, On21002);
            this.RegisterProtocal(21010, On21010);
            this.RegisterProtocal(21011, On21011);
            this.RegisterProtocal(21012, On21012);
            this.RegisterProtocal(21003, on21003); //技能强化信息
            this.RegisterProtocal(21004, on21004); //技能强化
            this.RegisterProtocal(21005, on21005); //技能一键强化
            this.RegisterProtocal(21101, on21101); //远古奥术信息
            this.RegisterProtocal(21102, on21102); //远古奥术升级
            this.RegisterProtocal(21103, on21103); //远古奥术突破
            this.RegisterProtocal(21104, on21104); //远古奥术突破
            this.RegisterProtocal(13007, on13007); //获取快捷栏
            this.RegisterProtocal(13008, on13008); //保存快捷栏
            this.RegisterProtocal(13010, on13010); //替换快捷栏
            this.RegisterProtocal(12093, on12093); //职业技能给予的buff
            this.RegisterProtocal(18401, on18401); //模块加成效果
        };
        console.log("skillcontroller ===================", model.$test);
        this.InitInfo();
        this.InitEvents();
    }
    public static GetInstance() {
        if (!SkillController.Instance) {
            SkillController.Instance = new SkillController();
        }
        return SkillController.Instance;
    }
}

window["SkillController"] = SkillController
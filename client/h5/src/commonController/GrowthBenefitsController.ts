import { BaseController } from "../common/BaseController";
import { EventName } from "../common/EventName";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { GrowthForceEvent, GrowthForceModelEvent } from "../commonModel/GrowthForceModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GrowthForceModel } from './../commonModel/GrowthForceModel';
import { GrowthBenefitsModel, GrowthBenefitsModelEvent, IGrowWelfareTaskParam } from "../commonModel/GrowthBenefitsModel";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { Util } from "../util/Util";
import { RoleManager } from "../commonModel/RoleManager";
import "../growthForce/GrowthFightWelfareView"
import { Message } from './../sysInfo/SysInfoController';

export enum EnumGrowthBenefitsProtocol {
    eProtocol41720 = 41720,
    eProtocol41721,
    eProtocol41722,
}
window["EnumGrowthBenefitsProtocol"] = EnumGrowthBenefitsProtocol
export class GrowthBenefitsController extends BaseController {
    private InitInfo: Function;
    private InitEvents: Function;
    private _viewDic = [];
    private _model: GrowthForceModel;

    private get GrowthBenefitsModel() {
        return GrowthBenefitsModel.GetInstance();
    }

    private get GrowthForceModel() {
        return GrowthForceModel.GetInstance();
    }

    public constructor() {
        super();

        let UMSG = UserMsgAdapter.GetInstance();
        let user_msg_adapter = UserMsgAdapter.GetInstance()
        this._model = GrowthForceModel.GetInstance()
        this.InitEvents = () => {
            // 协议发送
            this.GrowthBenefitsModel.Bind(
                GrowthBenefitsModelEvent.REQUEST_PROTO,
                (id: number, fmt: string, ...new_args) => {
                    this.SendFmtToGame(id, fmt, ...new_args);
                }
            );

            this.GrowthForceModel.Bind(
                GrowthForceModelEvent.OPEN_VIEW,
                (view_name: string, ...newAgrs) => {
                    if (this.GrowthBenefitsModel.GetEntranceOpenState()) {
                        let view = this._viewDic[view_name];
                        if (!view) {
                            this._viewDic[view_name] = true;
                            if (this._viewDic[view_name] == true) {
                                let viewClass = window[view_name];
                                view = new viewClass();
                                this._viewDic[view_name] = view;
                            }
                        }
                        if (view && view != true) {
                            view.Open(...newAgrs);
                        }
                    } else {
                        Message.show('未开启');
                    }
                }
            );
            this.GrowthForceModel.Bind(
                GrowthForceModelEvent.CLOSE_VIEW,
                (viewName?) => {
                    let view = this._viewDic[viewName];
                    if (view && view != true && view.HasOpen()) {
                        view.Close();
                        this._viewDic[viewName] = null;
                    }
                }
            );

            GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
                this.SendFmtToGame(EnumGrowthBenefitsProtocol.eProtocol41720);
            });

            GlobalEventSystem.Bind(EventName.GAME_START, async () => {
                // 成长福利
                this.GrowthBenefitsModel.GetTaskMapClear();
                this.GrowthBenefitsModel.GetTaskStateMapClear();
                await this.GrowthBenefitsModel.InitConfig();
                await this.SendFmtToGame(EnumGrowthBenefitsProtocol.eProtocol41720);

                //战力福利
                this._model.fight_welfare_login_red = false;
                this._model.is_login_changed = false;
                this._model.CheckMaxRound();
                if (this._model.CheckFightWelfareOpen()) {
                    this._model.is_login_changed = true;
                    this._model.FightWelfareSend();
                }
                this.GrowthBenefitsModel.refreshIcon();
            });


            RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (level?) => {
                //战力福利
                if (this._model.CheckFightWelfareOpen() && !this._model.is_login_changed) {
                    this._model.is_login_changed = true;
                    this._model.FightWelfareSend()
                }

                // 成长福利
                this.GrowthBenefitsModel.refreshIcon();
            });

            GlobalEventSystem.Bind(EventName.CHANGE_ACCOUNT, () => {
                this._model.is_login_changed = false
            });

            GlobalEventSystem.Bind(EventName.CHANGE_ROLE, () => {
                this._model.is_login_changed = false
            });



        };

        this.InitInfo = () => {

            // 获取成长福利任务进度
            let On41720 = () => {
                let scmd = UMSG.GetSCMD(EnumGrowthBenefitsProtocol.eProtocol41720)
                for (const iterator of scmd.task_list) {
                    this.GrowthBenefitsModel.SetTaskStateMap(iterator.task_id, iterator);
                }
                this.GrowthBenefitsModel.Fire(GrowthBenefitsModelEvent.UPDATE_TASK);
                GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, EnumGrowthBenefitsProtocol.eProtocol41720, this.GrowthBenefitsModel.GetDayRedDotStateAll())

                // 全部领取完刷新按钮
                if (this.GrowthBenefitsModel.GetTaskIsAllReceive()) {
                    this.GrowthBenefitsModel.refreshIcon();
                }
            }

            // 成长福利任务进度更新
            let On41721 = () => {
                let scmd = UMSG.GetSCMD(EnumGrowthBenefitsProtocol.eProtocol41721)
                for (const iterator of scmd.task_list) {
                    this.GrowthBenefitsModel.SetTaskStateMap(iterator.task_id, iterator);
                }
                GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, EnumGrowthBenefitsProtocol.eProtocol41720, this.GrowthBenefitsModel.GetDayRedDotStateAll())
                this.GrowthBenefitsModel.Fire(GrowthBenefitsModelEvent.UPDATE_TASK);

                // 全部领取完刷新按钮
                if (this.GrowthBenefitsModel.GetTaskIsAllReceive()) {
                    this.GrowthBenefitsModel.refreshIcon();
                }

            }

            // 成长福利任务领取
            let On41722 = () => {
                let scmd = UMSG.GetSCMD(EnumGrowthBenefitsProtocol.eProtocol41722)
                if (scmd.errcode == 1) {
                    let task: IGrowWelfareTaskParam = this.GrowthBenefitsModel.GetTaskStateMap(scmd.task_id)
                    if(!task) return
                    task.status = scmd.status;
                    this.GrowthBenefitsModel.SetTaskStateMap(task.task_id, task);
                    this.GrowthBenefitsModel.Fire(GrowthBenefitsModelEvent.UPDATE_TASK);
                } else {
                    Util.ErrorCodeShow(scmd.errcode)
                }
                GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, EnumGrowthBenefitsProtocol.eProtocol41720, this.GrowthBenefitsModel.GetDayRedDotStateAll())

                // 全部领取完刷新按钮
                if (this.GrowthBenefitsModel.GetTaskIsAllReceive()) {
                    this.GrowthBenefitsModel.refreshIcon();
                }
            }


            //战力福利
            let Handler41723 = () => {
                let scmd = user_msg_adapter.GetSCMD(41723)
                if (scmd) {
                    this._model.fight_welfare_round = scmd.round
                    this._model.fight_welfare_time = scmd.times
                    this._model.fight_welfare_combat = scmd.combat
                    this._model.fight_welfare_next_combat = scmd.next_combat

                    this._model.fight_welfare_list = {}
                    let list = scmd.list
                    for (let i = 0; i < list.length; i++) {
                        this._model.fight_welfare_list[list[i].reward_id] = 1
                    }

                    this._model.Fire(GrowthForceEvent.UPDATE_FIGHT_WELFARE, false, 0)

                    this.GrowthBenefitsModel.refreshIcon();
                    this.GrowthBenefitsModel.RefreshIconRed()
                }

            }


            let Handler41724 = () => {
                let scmd = user_msg_adapter.GetSCMD(41724)
                console.warn(scmd)
                if (scmd.code == 1) {
                    let is_new = scmd.round != this._model.fight_welfare_round ? true : false
                    this._model.fight_welfare_time = scmd.times
                    this._model.fight_welfare_next_combat = scmd.next_combat
                    if (is_new) {
                        this._model.fight_welfare_list = {}
                        this._model.fight_welfare_round = scmd.round
                    } else {
                        this._model.fight_welfare_list[scmd.reward_id] = 1
                    }

                    this._model.Fire(GrowthForceEvent.UPDATE_FIGHT_WELFARE, is_new, scmd.reward_id)

                    this.GrowthBenefitsModel.refreshIcon();
                    this.GrowthBenefitsModel.RefreshIconRed()
                } else {
                    Util.ErrorCodeShow(scmd.code)
                }
            }



            this.RegisterProtocal(EnumGrowthBenefitsProtocol.eProtocol41720, On41720);
            this.RegisterProtocal(EnumGrowthBenefitsProtocol.eProtocol41721, On41721);
            this.RegisterProtocal(EnumGrowthBenefitsProtocol.eProtocol41722, On41722);
            //战力福利
            this.RegisterProtocal(41723, Handler41723)      //基本数据
            this.RegisterProtocal(41724, Handler41724)		//摇奖返回
        };

        this.InitInfo();
        this.InitEvents();
    }
}
window['GrowthBenefitsController'] = GrowthBenefitsController;

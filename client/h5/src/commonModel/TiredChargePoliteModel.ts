import { EventDispatcher } from '../util/EventDispatcher';
import { ErlangParser } from './../util/ErlangParser';
import { CustomActivityModel } from './CustomActivityModel';

export interface IS2CTiredChargePoliteParam {
    base_type: number          // 活动主类型
    sub_type: number          // 活动子类型
    recharge_num: number          // 当前全服的充值人数
    is_recharge: number          // 玩家是否完成充值 0 - 未完成充值， 其他 - 对应的充值金额
    list: IS2CTiredChargePoliteTasksParam[],
}

export interface IS2CTiredChargePoliteTasksParam {
    grade: number,        // 奖励档次
    condition: string,      // 领取条件
    name: string,        // 奖励名字
    desc: string,
    reward_list: IS2CTiredChargePoliteTaskInfoParam[],
}

export interface IS2CTiredChargePoliteTaskInfoParam {
    form_type: number,       // 奖励稀有类型 见后台备注
    status: number,    // 领取状态 0:未达到 1:可以领取 2:已经领取
    reward: string,       // 奖励
}



export enum TiredChargePoliteTaskState {
    /**未达到 */
    eNot,
    /**可以领取 */
    eGet,
    /**已经领取 */
    eHaveGet,
    /**充值再领(跳转) */
    eJump
}


/**
 * 红包返利事件
 */
export class TiredChargePoliteModelEvent {
    static _cname = 'TiredChargePoliteModelEvent';
    /**更新活动数据 */
    public static UP_VIEW: string =
        TiredChargePoliteModelEvent._cname + '.' + 'UP_VIEW';

}

export class TiredChargePoliteModel extends EventDispatcher {
    private static _instance: TiredChargePoliteModel;
    public static readonly ACT_TYPE: number = 121; // 主类型
    public static readonly ICON_TYPE: string = '331@121'; // 主类型
    public static GetInstance() {
        if (!TiredChargePoliteModel._instance) {
            TiredChargePoliteModel._instance = new TiredChargePoliteModel();
        }
        return TiredChargePoliteModel._instance;
    }

    private _actData: IS2CTiredChargePoliteParam;

    constructor() {
        super();
    }


    SetTiredChargePoliteData(data: IS2CTiredChargePoliteParam) {
        this._actData = data;
        CustomActivityModel.GetInstance().SetActData(data)
    }

    GetTiredChargePoliteData() {
        return this._actData;
    }

    /**
     * 获取所有任务档位
     */
    GetTasks() {
        return this._actData?.list || [];
    }


    /**
     * 根据档位获取档位状态
     * @param grade 
     */
    GetGearStateByGrade(grade: number) {
        if (this._actData?.list.length > 0) {
            let list: IS2CTiredChargePoliteTasksParam[] = this._actData.list;
            let task: IS2CTiredChargePoliteTasksParam = list.find((info: IS2CTiredChargePoliteTasksParam) => {
                return info.grade == grade;
            });
            if (task) {
                // 先判断是否为领取状态
                for (const iterator of task.reward_list) {
                    if (iterator.status == TiredChargePoliteTaskState.eGet) {
                        return TiredChargePoliteTaskState.eGet;
                    }
                }

                // 判断是否为已领取状态
                let isHaveAll: boolean = task.reward_list.every((info: IS2CTiredChargePoliteTaskInfoParam) => {
                    return info.status == TiredChargePoliteTaskState.eHaveGet;
                });

                if (isHaveAll) {
                    return TiredChargePoliteTaskState.eHaveGet;
                } else {
                    // 判断是否为未达成转态
                    let isNotAll: boolean = task.reward_list.every((info: IS2CTiredChargePoliteTaskInfoParam) => {
                        return info.status == TiredChargePoliteTaskState.eNot;
                    });
                    if (isNotAll) {
                        return TiredChargePoliteTaskState.eNot;
                    } else {
                        // 则为跳转状态
                        return TiredChargePoliteTaskState.eJump;
                    }
                }
            }
        }

        return TiredChargePoliteTaskState.eNot;
    }


    /**
     * 获取累充有礼总红点
     */
    GetTiredChargePoliteTotalRed() {
        if (this._actData?.list.length > 0) {
            let list: IS2CTiredChargePoliteTasksParam[] = this._actData.list;
            let bool: boolean = list.some((task: IS2CTiredChargePoliteTasksParam) => {
                return this.GetGearRedStateByGrade(task.grade);
            });

            return bool;

        }
        return false;
    }


    /**
     * 获取该档位红点状态
     * @param grade 
     */
    GetGearRedStateByGrade(grade: number) {
        return this.GetGearStateByGrade(grade) == TiredChargePoliteTaskState.eGet;;
    }

    /**
     * 获取满足条件的珍稀奖励
     */
    GetRareRewards() {
        let awards: string[] = [];
        if (this._actData?.list.length > 0) {
            for (const task of this._actData.list) {
                for (const info of task.reward_list) {
                    if (this.GetConditionsStateByGrade(task.grade) && info.form_type == 2 && info.status == TiredChargePoliteTaskState.eNot) { // 为珍稀奖励
                        awards = awards.concat(ErlangParser.GetInstance().parse(info.reward));
                    }
                }
            }

            return awards;

        }
        return [];
    }

    /**
     * 获取该档位未可领取的奖励
     */
    GetReasdsByGrade(grade: number) {
        let awards: any[] = [];
        if (this._actData?.list.length > 0) {
            for (const task of this._actData.list) {
                for (const info of task.reward_list) {
                    if (task.grade == grade && info.status == TiredChargePoliteTaskState.eHaveGet) {
                        awards = awards.concat(ErlangParser.GetInstance().parse(info.reward));
                    }
                }
            }

            return awards;

        }
        return awards;
    }

    /**
     * 该档位是否满足条件
     * @param grade 
     * @returns 
     */
    GetConditionsStateByGrade(grade: number) {
        if (!this._actData) {
            return false;
        }
        let actInfo = CustomActivityModel.GetInstance().GetActInfo(this._actData.base_type, this._actData.sub_type);

        if (!actInfo) {
            return false;
        }

        let task: IS2CTiredChargePoliteTasksParam = this._actData.list.find((info: IS2CTiredChargePoliteTasksParam) => {
            return info.grade == grade;
        });

        let curRechargeNum: number = this._actData.recharge_num;
        let conditon = ErlangParser.GetInstance().parse(task.condition);
        let rechargeNum: number = conditon[0][1];

        return curRechargeNum >= rechargeNum;
    }


}

window['TiredChargePoliteModel'] = TiredChargePoliteModel;

import { EventDispatcher } from '../util/EventDispatcher';
import { CustomActivityModel } from './CustomActivityModel';
import { ErlangParser } from './../util/ErlangParser';
import { TimeUtil } from '../util/TimeUtil';

export interface IS2CRedEvnelopeRebateParam {
    type: number             // 主类型
    subtype: number          // 次类型
    is_quality: number       // 是否有资格参加
    start_time: number       // 开启时间
    end_time: number         // 结束时间
    login_money: number      // 登录红包可提现金额(分)
    recharge_money: number   // 充值返利可提现金额(分)
    login_status: number     // 提现状态，默认是0,；1的时候是提现中（可能需要时间）
    recharge_status: number  // 提现状态，默认是0,；1的时候是提现中（可能需要时间）
    login_withdrawal: number  // 充值红包是否提现过 0 无 1 有
    recharge_withdrawal: number    // 返利红包是否提现过 0 无 1 有
    login_global_times: number    // 全服登录红包提现次数
    recharge_global_times: number // 全服充值红包提现次数
}

export enum EnumRedEvnelopeRebateViewType {
    /**登陆红包 */
    eLoginRedEnvelope = 1,
    /**七天返利 */
    eSevenDayRebate
}

/**
 * 红包返利事件
 */
export class RedEnvelopeRebateModelEvent {
    static _cname = 'RedEnvelopeRebateModelEvent';
    /**选中页签 */
    public static TAB_SELECT: string =
        RedEnvelopeRebateModelEvent._cname + '.' + 'TAB_SELECT';
    /**更新体现状态 */
    public static UPDATE_WITHDRAW_STATE: string =
        RedEnvelopeRebateModelEvent._cname + '.' + 'UPDATE_WITHDRAW_STATE';
    /**关闭界面 */
    public static CLOSE_VIEW: string =
        RedEnvelopeRebateModelEvent._cname + '.' + 'CLOSE_VIEW';
}

export class RedEnvelopeRebateModel extends EventDispatcher {
    private static _instance: RedEnvelopeRebateModel;
    public static ACT_TYPE: number = 117; // 主类型
    public static ICON_TYPE: string = '331@117@0'; // 图标类型
    public static GetInstance() {
        if (!RedEnvelopeRebateModel._instance) {
            RedEnvelopeRebateModel._instance = new RedEnvelopeRebateModel();
        }
        return RedEnvelopeRebateModel._instance;
    }

    /**红包返利活动信息 */
    private _actData: IS2CRedEvnelopeRebateParam;

    public set actData(data: IS2CRedEvnelopeRebateParam) {
        this._actData = data;
    }

    public get actData() {
        return this._actData;
    }

    public clearActData() {
        this._actData = undefined;;
    }

    /**
     * 获取页签数据
     */
    GetTypes(base_type: number, sub_type: number) {
        let actData = CustomActivityModel.GetInstance().GetActData(base_type, sub_type);
        let types: number[] = [];
        if (actData) {
            for (const iterator of actData.reward_list) {
                let condition = ErlangParser.GetInstance().parse(iterator.condition);
                if (types.indexOf(+condition[4][1]) == -1) {
                    types.push(+condition[4][1]);
                }
            }
        }

        types.sort((a: number, b: number) => {
            return a - b;
        })

        return types;
    }

    /**
     * 通过页签过去奖励列表
     */
    GetRewardsByType(type: number) {
        let actData = CustomActivityModel.GetInstance().GetActData(this._actData.type, this._actData.subtype);
        let awards: any[] = [];
        if (actData) {
            for (const iterator of actData.reward_list) {
                let condition = ErlangParser.GetInstance().parse(iterator.condition);
                if (condition[4][1] == type) {
                    awards.push(iterator);
                }
            }
        }

        // 按照天数排序
        awards.sort((a: any, b: any) => {
            let dayA: number = +ErlangParser.GetInstance().parse(a.condition)[2][1];
            let dayB: number = +ErlangParser.GetInstance().parse(b.condition)[2][1];
            return dayA - dayB;
        });

        return awards;
    }

    /**
     * 获取页签红点
     */
    GetTypeRedDot(type: number) {
        let awards: any[] = this.GetRewardsByType(type);

        // 可提现红点
        if (this.GetTypeWithdrawRedDot(type)) {
            return true;
        }

        if (awards?.length > 0) {
            // 判断是否有可以领取的奖励
            let bool: boolean = awards.some((data: any) => {
                return data.status == 1;
            });

            return bool;
        }

        return false;
    }

    /**
     * 获取红包返利总红点
     */
    GetTypesRedDot() {
        if(this._actData)
        {
            let types: number[] = this.GetTypes(this._actData.type, this._actData.subtype);
            let bool: boolean = types.some((type: number) => {
                return this.GetTypeRedDot(type);
            });
    
            return bool;
        }
    }


    /**
     * 提现状态
     */
    GetTypeWithdrawRedDot(type: number) {
        let actInfo = CustomActivityModel.GetInstance().GetActInfo(this._actData.type, this._actData.subtype);
        if (!actInfo || !this._actData) {
            return false;
        }
        let condition = ErlangParser.GetInstance().parse(actInfo.condition);

        let withdrawaNum: number = +(type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? condition[5][1] : condition[6][1]);
        let curWithdrawaNum: number = type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? this._actData.login_global_times : this._actData.recharge_global_times;
        let selfIsWithdrawa: boolean = Boolean((type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? this._actData.login_withdrawal : this._actData.recharge_withdrawal));
        if (curWithdrawaNum >= withdrawaNum && !selfIsWithdrawa) { // 本服是否还有提现次数
            return false;
        }

        let curDay: number = TimeUtil.naturalDaysBetween(this._actData.start_time * 1000, TimeUtil.getServerTime() * 1000) + 1;
        let state: boolean = Boolean(type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? this._actData.login_status : this._actData.recharge_status);
        let money: number = type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? this._actData.login_money : this._actData.recharge_money;
        let withdrawalDays: string[] = type == EnumRedEvnelopeRebateViewType.eLoginRedEnvelope ? condition[3][1] : condition[4][1];

        return money > 0 && withdrawalDays.indexOf(curDay.toString()) != -1 && !state;

    }





}

window['RedEnvelopeRebateModel'] = RedEnvelopeRebateModel;

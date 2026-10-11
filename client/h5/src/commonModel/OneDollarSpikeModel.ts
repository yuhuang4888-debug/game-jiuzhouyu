import { EventDispatcher } from '../util/EventDispatcher';
import { CustomActivityModel } from './CustomActivityModel';

/**
 * 每日直购事件类型类
 */
export class OneDollarSpikeModelEvent {
    static _cname = 'OneDollarSpikeModelEvent';
    /**一元秒杀选中 */
    public static TAB_SELECT: string =
        OneDollarSpikeModelEvent._cname + '.' + 'TAB_SELECT';
}

export class OneDollarSpikeModel extends EventDispatcher {
    private static _instance: OneDollarSpikeModel;

    public static GetInstance() {
        if (!OneDollarSpikeModel._instance) {
            OneDollarSpikeModel._instance = new OneDollarSpikeModel();
        }
        return OneDollarSpikeModel._instance;
    }

    /**
     * 获取每日直购礼包红点状态
     */
    GetDollarSpikeRedDotState(base_type: number, sub_type: number) {
        let actData = CustomActivityModel.GetInstance().GetActData(base_type, sub_type);
        if (actData) {
            for (const iterator of actData?.reward_list) {
                if (iterator.form_type) {
                    if (iterator.status == 0) {
                        return true;
                    }
                }
            }
        }
        return false;

    }

    /**
     * 是否都已经购买
     * @param base_type 
     * @param sub_type 
     * @returns 
     */
    GetDollarSpikeAllBuy(base_type: number, sub_type: number) {
        let actData = CustomActivityModel.GetInstance().GetActData(base_type, sub_type);
        if (actData) {
            for (const iterator of actData?.reward_list) {
                if (iterator.status != 2) {
                    return false;
                }
            }
        }
        return true;
    }

}

window['OneDollarSpikeModel'] = OneDollarSpikeModel;

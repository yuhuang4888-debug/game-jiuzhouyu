import { EventDispatcher } from '../util/EventDispatcher';
import { TMap } from '../util/TMap';

/**
 * 特惠礼包事件类型类
 */
export class SpecialPackageModelEvent {
    static _cname = 'SpecialPackageModelEvent';
    /**界面更新 */
    public static UPDATE_VIEW: string =
        SpecialPackageModelEvent._cname + '.' + 'UPDATE_VIEW';
}

export class SpecialPackageModel extends EventDispatcher {
    private static _instance: SpecialPackageModel;
    public static ICON_TYPE: number = 112;

    private _sepcialPackageViewData: TMap<string, any>;
    private _openAlert: boolean = true;

    public static GetInstance() {
        if (!SpecialPackageModel._instance) {
            SpecialPackageModel._instance = new SpecialPackageModel();
        }
        return SpecialPackageModel._instance;
    }

    public constructor() {
        super();
        this._sepcialPackageViewData = new TMap<string, any>();
    }

    public SetSepcialPackageViewData(data: any) {
        this._sepcialPackageViewData.set(data.base_type + '_' + data.sub_type, data);
    }

    public GetSepcialPackageViewData(type: string) {
        return this._sepcialPackageViewData.get(type);
    }

    public SetSepcialPackageTimes(type: string, times: number) {
        let info = this._sepcialPackageViewData.get(type);
        if (!info) {
            return;
        }
        info.times = times;
        this._sepcialPackageViewData.set(info.base_type + '_' + info.sub_type, info);
    }

    public get openAlert(): boolean {
        return this._openAlert;
    }

    public set openAlert(bool: boolean) {
        this._openAlert = bool;
    }



    /**
     * 获取当前vip等级对应可购买的最大次数
     */
    public GetCurLvBuyTimes(list: any[], lv: number): number {
        let tims: number = list[list.length - 1][1];
        for (const iterator of list) {
            if (iterator[0] == lv) {
                tims = iterator[1];
                break;
            }
        }
        return tims;
    }

    /**
     * 获取下级可多购买的次数
     */
    public GetNextLvBuyTimes(list: any[], lv: number) {
        let num: number = 0;
        let vip: number = 0;
        for (const iterator of list) {
            if (iterator[0] > lv) {
                num = iterator[1];
                vip = iterator[0]
                break;
            }
        }

        if (num > 0) {
            let data = list.find((data: any, index: number) => {
                return data[0] == lv;
            });
            num = num - data[1]
        }

        return { times: num, lv: vip };
    }

    /**
     * 获取当前购买次数最近的优惠折扣
     */
    public GetCurTimesByDiscount(list: any[], times: number) {
        for (const iterator of list) {
            if (times < iterator[0]) {
                return { dis: iterator[1], num: iterator[0] - times }
            }
        }
        return null;
    }

    /**
     * 获取当前折扣价
     */
    public GetCurTimesByDiscount1(list: any[], times: number) {
        let dis: number = 10; // 默认不打折
        for (const iterator of list) {
            if (times >= iterator[0]) {
                dis = iterator[1];
            }
        }
        return dis;
    }



}

window['SpecialPackageModel'] = SpecialPackageModel;

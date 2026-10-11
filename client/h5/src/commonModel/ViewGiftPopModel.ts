import { Config } from '../common/Config';
import { EventDispatcher } from '../util/EventDispatcher';
import { CustomActivityDefine } from './CustomActivityDefine';
import { CustomActivityModel } from './CustomActivityModel';
import { ErlangParser } from './../util/ErlangParser';
import { HtmlColorTxt } from '../util/Util';
import { GoodsModel } from './GoodsModel';
import { ColorType, ColorUtil } from '../util/ColorUtil';

export interface ISGiftParam {
    gift_id: number,
    sub_id: number,
    title_name: string,
    gift_name: string,
    end_time: number,    // 礼包结束时间
    infos: string
}

export class ViewGiftPopModelEvent {
    static className: string = "ViewGiftPopModelEvent";

    static NEXT_OPEN_TIPS: string = ViewGiftPopModelEvent.className + 'NEXT_OPEN_TIPS'
}

/**
 * 处理礼包推送气泡
 */
export class ViewGiftPopModel extends EventDispatcher {
    private static _instance: ViewGiftPopModel;
    public static GetInstance() {
        if (!ViewGiftPopModel._instance) {
            ViewGiftPopModel._instance = new ViewGiftPopModel();
        }
        return ViewGiftPopModel._instance;
    }

    private _gifts: ISGiftParam[];
    //  是否有气泡正在提示
    private _isPopIng: boolean = false;


    public constructor() {
        super();
        this._gifts = [];
    }

    public get isPopIng(): boolean {
        return this._isPopIng;
    }

    public set isPopIng(bool: boolean) {
        this._isPopIng = bool;
    }



    public SetGifts(list: ISGiftParam[]) {
        this._gifts = this._gifts.concat(list);
        this._gifts.sort((a: ISGiftParam, b: ISGiftParam) => {
            if (a.gift_id == b.gift_id) {
                return b.sub_id - a.sub_id;
            } else {
                return a.gift_id - b.gift_id;
            }
        });
        this.NextPop();
    }


    public ClearGifts() {
        this._gifts.length = 0;
    }


    public NextPop() {
        if (this._isPopIng || this._gifts.length <= 0) {
            return;

        }
        let conf = Config.PRELOAD_SERVER_CONFIG.config_push_gift_reward;
        let param: ISGiftParam = this._gifts.shift();
        let confChild = conf[`${param.gift_id}@${param.sub_id}@1`];
        let condition = ErlangParser.GetInstance().parse(confChild.condition);
        let rewards = ErlangParser.GetInstance().parse(confChild.rewards);

        let discount: number = condition[1][1];
        let goods = GoodsModel.GetInstance().GetGoodsBasicByTypeId(rewards[0][1]);
        let name: string = goods.goods_name;
        let des: string = `特惠触发${HtmlColorTxt(name, ColorUtil.GetColorDark(goods.color))},${HtmlColorTxt(discount + '折', ColorUtil.GetColorDark(ColorType.GREEN))}限时购!`;

        CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.ADD_GIFT_TIP, des);
    }




}

window['ViewPopLevel'] = ViewGiftPopModel;

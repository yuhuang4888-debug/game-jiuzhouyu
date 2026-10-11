import { BaseItem1 } from '../common/BaseItem1';
import { CommonManager } from '../common/CommonManager';
import { ResManager } from '../common/ResManager';
import { ActivityIconManager } from '../commonModel/ActivityIconManager';
import { PushGiftModel } from '../commonModel/PushGiftModel';
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from '../util/ColorUtil';
import { GameResPath } from '../util/GameResPath';
import { TimeUtil } from '../util/TimeUtil';
import { GlobalTimerQuest, Util } from '../util/Util';

export class GiftPushIcon extends BaseItem1 {
    private cfg: any;
    private icon_info: any;
    private icon_type: string | number;
    private update_timer_id: number;
    private curTime: number = 0;
    private giftId: number;
    private colorType: number;
    constructor(parent?) {
        super(parent);

        this.base_file = 'mainUI';
        this.layout_file = 'GiftPushIcon';

        this.load_callback = () => {
            this.LoadSuccess();
            this.InitEvent();
        }
    }


    private LoadSuccess() {
        // this.Render();
    }

    private InitEvent() {
        Util.AddClickEvent(
            this._img_icon,
            () => {
                PushGiftModel.GetInstance().Fire(
                    PushGiftModel.OPEN_VIEW,
                    'PushGiftEntView', this.giftId
                );
            },
            this,
            true
        );
    }

    /**
     * @param iconType 图标类型
     * @param giftId 礼包id/礼包类型
     * @param colorType 颜色类型 1亮色 0暗色
     */
    public SetDate(iconType: string | number, giftId: number, colorType: number = 1) {
        let cfg = CommonManager.GetInstance().GetFunctionIconCfg(iconType);
        this.cfg = cfg;
        this.giftId = giftId;
        this.colorType = colorType;
        this.icon_info = ActivityIconManager.GetInstance().getIconInfo(
            this.icon_type
        );
        this.curTime = PushGiftModel.GetInstance().GetGiftMaxTimeById(giftId);

        if (this.is_loaded) {
            this.Render();
        }

    }


    private Render() {
        ResManager.GetInstance().SetImageSpriteTrans(
            this,
            this._img_icon,
            GameResPath.GetIcon('icon', this.cfg.icon_name)
        );
        this._lb_desc.color = ColorUtil.GetReplaceChar((this.colorType ? Enum_ColorUtil_Light.GREEN : Enum_ColorUtil_Dark.GREEN));
        this.StartTimer();
    }


    /**
    * 倒计时
    */
    public StartTimer() {
        this.StopTimer();
        let loop_func = () => {
            let left_time = this.curTime - TimeUtil.getServerTime()
            if (left_time <= 0) {
                this.StopTimer();
                PushGiftModel.GetInstance().CheckOverGift();
                PushGiftModel.GetInstance().Fire(PushGiftModel.UPDATE_ICON, this.giftId);
                return;
            } else {
                let time: string = TimeUtil.convertTimeColor(left_time, 'hh-mm-ss')
                this._lb_desc.text = time;
            }
        }

        this.update_timer_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1);
        loop_func();
    }

    public StopTimer() {
        if (this.update_timer_id) {
            GlobalTimerQuest.CancelQuest(this.update_timer_id)
            this.update_timer_id = null
        }
    }


    public DeleteMe() {
        this.StopTimer();
        super.DeleteMe();
    }

    _gp_effect: Laya.Box
    _img_icon: Laya.Image
    _img_desc_bg: Laya.Image
    _lb_desc: Laya.Text
    public GetComponents() {
        [
            this._gp_effect,
            this._img_icon,
            this._img_desc_bg,
            this._lb_desc,
        ]
            = this.GetChildrenByNames([

                "_gp_effect",
                "_img_icon",
                "_img_desc_bg",
                "_lb_desc",
            ])
    }
}
window["GiftPushIcon"] = GiftPushIcon
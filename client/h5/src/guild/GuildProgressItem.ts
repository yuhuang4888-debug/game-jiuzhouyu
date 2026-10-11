import { BaseItem1 } from '../common/BaseItem1';
import { ResManager } from '../common/ResManager';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { Enum_ColorUtil_Dark } from '../util/ColorUtil';
import { ErlangParser } from '../util/ErlangParser';
import { Util } from '../util/Util';

export class GuildProgressItem extends BaseItem1 {
    _Group1;
    _img_icon;
    _lb_tips;
    can_get;
    data;
    info;
    model;

    public constructor(parent?) {
        super(parent);

        this.model = GuildModel.GetInstance();
        this.can_get = false;
        this.base_file = 'guild';
        this.layout_file = 'GuildProgressItem';
        this.preload_server_config = { config_guild_activity_gift: false };
        this.load_callback = () => {
            this.InitEvent();
        };
    }

    public DeleteMe() {
        this.data = null;
        this.info = null;
        this.StopAction();
        super.DeleteMe();
    }

    public InitEvent() {
        Util.AddClickEvent(
            this._img_icon,
            () => {
                if (!this.data) {
                    return;
                }
                if (!this.can_get) {
                    this.OpenBox();
                    return;
                }
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40025, 'h', this.data.gift_id);
            },
            this,
            true
        );
        this.BindVar(this.model, 'donate_info', () => {
            if (!this.info || !this.data) {
                return;
            }
            let info = this.model.GetDonateInfo();
            let can_get = this.model.GetActivity() >= this.info.activity && this.data.gift_status == 0;
            this.can_get = can_get;
            this.ChangeTips(can_get);
        });
    }

    public SetInfo(info?) {
        this.info = info;
        this._img_icon.source = 'guildCommon_asset.' + info.icon + '';
    }

    public SetData(data?) {
        this.data = data;
        let activity = this.model.GetActivity();
        let can_get = this.info && activity >= this.info.activity && data.gift_status == 0;
        this.can_get = can_get;
        this.ChangeTips(can_get);
    }

    public ChangeTips(can_get?) {
        if (can_get) {
            this.StartAction();
            this._lb_tips.text = Util.HtmlColorTxt('可领取', Enum_ColorUtil_Dark.GREEN);
        } else {
            this.StopAction();
            let not_get = this.data.gift_status == 0;
            // [ts2lua]lua中0和空字符串也是true，此处not_get需要确认
            this._lb_tips.text = (not_get && Util.StrToHTML(this.info.activity.toString())) || Util.StrToHTML('已领取');
            // [ts2lua]lua中0和空字符串也是true，此处not_get需要确认
            this._img_icon.source = (not_get && 'guildCommon_asset.' + this.info.icon + '') || 'guildCommon_asset.' + this.info.icon + 'b';
            // [ts2lua]lua中0和空字符串也是true，此处not_get需要确认
            this._img_icon.y = (not_get && 49) || 40;
        }
    }

    public StartAction() {
        this.StopAction();
        Laya.Tween.to(this._img_icon, { rotation: 20 }, 150, Laya.Ease.circIn).to(this._img_icon, { rotation: -20 }, 300, Laya.Ease.circOut, Laya.Handler.create(this, this.StartAction));
        //Laya.Tween.get(this._img_icon, { loop: true }).to({ rotation: 20 }, 150, Laya.Ease.circIn).to({ rotation: -20 }, 300, Laya.Ease.circOut)
    }

    public StopAction() {
        Laya.Tween.clearTween(this._img_icon);
        this._img_icon.rotation = 0;
    }

    public OpenBox() {
        if (!this.data) {
            return;
        }
        let config_guild_activity_gift = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_guild_activity_gift', false);
        // [ts2lua]config_guild_activity_gift下标访问可能不正确
        let cfg = config_guild_activity_gift[this.data.gift_id];
        let goods_list = ErlangParser.GetInstance().parse(cfg.reward);
        // [ts2lua]lua中0和空字符串也是true，此处this.data.gift_status == 0需要确认
        let tips = (this.data.gift_status == 0 && '结社今天总积分达到' + cfg.activity + '分可领取') || '已领取';
        this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildBoxView', goods_list, tips);
    }
}

window['GuildProgressItem'] = GuildProgressItem;

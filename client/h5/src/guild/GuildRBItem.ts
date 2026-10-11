import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseItem1 } from '../common/BaseItem1';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { ResManager } from '../common/ResManager';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { ColorUtil, Enum_ColorUtil_Dark, ColorType, Enum_ColorUtil_Light } from '../util/ColorUtil';
import { GameResPath } from '../util/GameResPath';
import { TimeUtil } from '../util/TimeUtil';
import { GlobalTimerQuest, Util, HtmlColorTxt, SetHtmlStyle } from '../util/Util';

export class GuildRBItem extends BaseItemRenderer {
    _model: GuildModel;
    _reward;
    end_time;
    onTimer;
    cur_timer;
    type_id;
    is_set;
    public WIDTH = 680;
    public HEIGT = 118;
    public constructor(parent) {
        super();

        this.is_set = false;
        this.base_file = 'guild';
        this.layout_file = 'GuildRBItem';
        //this.skinName="resource/game/guild/exml/GuildRBItemExml.exml"
        this.type_id = 32010447;

        this.Load();
    }

    public load_callback() {
        SetHtmlStyle(this._lb_role, { f: 20, c: '#663915', ww: false, w: 400 });

        this._model = GuildModel.GetInstance();

        this.onTimer = () => {
            if (this.end_time && this.end_time >= TimeUtil.getServerTime()) {
                let time = this.end_time - TimeUtil.getServerTime();
                this._lb_time.text = TimeUtil.convertTime(time);
            } else {
                this._lb_time.text = '已过期';
                this._lb_time.color = ColorUtil.GetColorDark(4);
                GlobalTimerQuest.CancelQuest(this.cur_timer);
                this.cur_timer = null;
            }
        };

        //ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("guild", "uirw_003"))

        Util.AddClickEvent(
            this._btn,
            () => {
                this._model.Fire(GuildEvent.REQUEST_PROTO, 40302, 'l', this.data.auto_id);
            },
            this,
            true
        );

        if (!this.is_set) {
            this.is_set = true;
            this.SetData();
        }
    }

    public DeleteMe() {
        if (this.cur_timer) {
            GlobalTimerQuest.CancelQuest(this.cur_timer);
            this.cur_timer = null;
        }
        if (this._reward) {
            this._reward.DeleteMe();
            this._reward = null;
        }
        super.DeleteMe();
    }

    public dataChanged() {
        if (!super.dataChanged()) return;
        if (this.is_loaded) {
            this.is_set = true;
            this.SetData();
        } else {
            this.is_set = false;
        }
    }

    SetData() {
        if (!this.data) return;
        this.end_time = 0;
        let guild_daily_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, 'config_guild_daily', false);
        // [ts2lua]guild_daily_cfg下标访问可能不正确
        let cfg = guild_daily_cfg[this.data.task_id];
        if (cfg) {
            this._lb_title.text = cfg.task;
            this._lb_type.text = cfg.name + '任务';
            this.end_time = this.data.time + cfg.persist * 60 * 60;
        }
        Util.SetImageGray(this._Image1, this.data.status == 1);
        let is_gain = this.data.status != 1;
        this.labelDisplay.text = (is_gain && '领取') || '已领取';
        let now = this._model._rewardBoxViewData.num;
        let max = this._model._rewardBoxViewData.max_num;
        this._red.visible = this.data.status != 1 && now < max;
        if (!this._reward) {
            this._reward = new BaseAwardItem(this._gp_reward, null, 'UI');
            this._reward.SetUseMask(true);
            this._reward.Load();
        }

        if (this.data.reward && this.data.reward.length > 0) {
            let vo = this.data.reward[0];
            let type_id, lock;
            [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.style, vo.typeId);
            let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id);
            if (goods_vo) {
                this._reward.SetData(goods_vo.type_id, vo.count, lock);
            }
        } else {
            this._reward.SetData(this.type_id);
        }
        this._lb_role.innerHTML = Util.StrToHTML('发放者：' + HtmlColorTxt(this.data.role_name, Enum_ColorUtil_Dark.ORANGE));

        this._lb_time.visible = is_gain;
        this.labelDisplay.strokeColor = !is_gain ? ColorUtil.GetReplaceChar(Enum_ColorUtil_Light.GRAY) : '#dc4a36';
        if (!is_gain) {
            if (this.cur_timer) {
                GlobalTimerQuest.CancelQuest(this.cur_timer);
                this.cur_timer = null;
            }
        } else {
            if (this.end_time > TimeUtil.getServerTime()) {
                let time = this.end_time - TimeUtil.getServerTime();
                this._lb_time.text = TimeUtil.convertTime(time);
                this._lb_time.color = ColorUtil.GetColorDark(ColorType.GREEN); //Enum_ColorUtil_Dark.GREEN

                this.cur_timer = GlobalTimerQuest.AddPeriodQuest(this.onTimer, 1, -1);
            } else {
                this._lb_time.text = '已过期';
                //this._lb_time.textColor = Enum_ColorUtil_Dark.ORANGE
                this._lb_time.color = ColorUtil.GetColorDark(ColorType.ORANGE);
                if (this.cur_timer) {
                    GlobalTimerQuest.CancelQuest(this.cur_timer);
                    this.cur_timer = null;
                }
            }
        }
    }

    _bg: Laya.Image;
    _gp_reward: Laya.Box;
    _Image11: Laya.Image;
    _lb_title: Laya.Label;
    _lb_role: Laya.HTMLDivElement;
    _lb_type: Laya.Label;
    _btn: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay: Laya.Label;
    _lb_time: Laya.Label;
    _red: Laya.Image;
    public GetComponents() {
        [this._bg, this._gp_reward, this._Image11, this._lb_title, this._lb_role, this._lb_type, this._btn, this._Image1, this.labelDisplay, this._lb_time, this._red] = this.GetChildrenByNames(['_bg', '_gp_reward', '_Image11', '_lb_title', '_lb_role', '_lb_type', '_btn', '_Image1', 'labelDisplay', '_lb_time', '_red']);
    }
}
window['GuildRBItem'] = GuildRBItem;

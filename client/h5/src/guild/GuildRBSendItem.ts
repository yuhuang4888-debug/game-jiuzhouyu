import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseItem1 } from '../common/BaseItem1';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { EventName } from '../common/EventName';
import { OpenFun } from '../common/OpenFun';
import { ResManager } from '../common/ResManager';
import { GuildModel } from '../commonModel/GuildModel';
import { Enum_ColorUtil_Dark } from '../util/ColorUtil';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { GameResPath } from '../util/GameResPath';
import { Util, HtmlColorTxt } from '../util/Util';

export class GuildRBSendItem extends BaseItemRenderer {
    _model: GuildModel;
    _reward: BaseAwardItem;
    type_id = 32010447;
    is_set = false;

    public WIDTH = 553;
    public HEIGT = 120;
    public constructor(parent) {
        super();
        this.base_file = 'guild';
        this.layout_file = 'GuildRBSendItem';
        //this.skinName="resource/game/guild/exml/GuildRBSendItemExml.exml"

        this.Load();
    }

    public load_callback() {
        this._model = GuildModel.GetInstance();

        //ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("guild", "uirw_003"))
        Util.AddClickEvent(
            this._btn,
            () => {
                OpenFun.OpenFunHandler(this.data.jump);
                GlobalEventSystem.Fire(EventName.CLOSE_VIEW, 'GuildRBSendView');
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
        if (this._reward) {
            this._reward.DeleteMe();
        }
        super.DeleteMe();
    }

    public dataChanged() {
        if (this.is_loaded) {
            this.is_set = true;
            this.SetData();
        } else {
            this.is_set = false;
        }
    }

    SetData() {
        if (!this.data) return;
        this.PerSetHtml();

        this._lb_title.text = this.data.task;
        let now = this._model.getBoxTaskNum(this.data.task_id);

        this._lb_desc.innerHTML = Util.StrToHTML('已发放宝箱:' + HtmlColorTxt(now + '/' + this.data.max_num, Enum_ColorUtil_Dark.ORANGE));
        let full = now >= this.data.max_num;
        // [ts2lua]lua中0和空字符串也是true，此处full需要确认
        this.labelDisplay.text = (full && '发放完毕') || '前往';
        this.labelDisplay.stroke = full ? 0 : 3;
        this._btn.mouseEnabled = !full;

        Util.SetImageGray(this._Image11, full);
        if (!this._reward) {
            this._reward = new BaseAwardItem(this._gp_reward);
            this._reward.Load();
            this._reward.SetScale(0.7);
            this._reward.SetData(this.type_id);
        }
    }

    PerSetHtml() {
        this._lb_desc.style.fontSize = 20;
        this._lb_desc.style.color = '#7d4a35';
        this._lb_desc.width = 300;
    }

    _bg: Laya.Image;
    _Image1: Laya.Image;
    _lb_title: Laya.Label;
    _lb_desc: Laya.HTMLDivElement;
    _btn: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay: Laya.Label;
    _gp_reward: Laya.Box;
    public GetComponents() {
        [this._bg, this._Image1, this._lb_title, this._lb_desc, this._btn, this._Image11, this.labelDisplay, this._gp_reward] = this.GetChildrenByNames(['_bg', '_Image1', '_lb_title', '_lb_desc', '_btn', '_Image11', 'labelDisplay', '_gp_reward']);
    }
}
window['GuildRBSendItem'] = GuildRBSendItem;

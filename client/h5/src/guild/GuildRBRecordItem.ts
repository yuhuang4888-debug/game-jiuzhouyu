import { BaseItem1 } from '../common/BaseItem1';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { ResManager } from '../common/ResManager';
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_NEW } from '../util/ColorUtil';
import { TimeUtil } from '../util/TimeUtil';
import { HtmlColorTxt, Util } from '../util/Util';

export class GuildRBRecordItem extends BaseItemRenderer {
    public WIDTH = 560;
    public HEIGT = 25;
    is_set;
    public constructor(parent) {
        super();
        this.is_set = false;
        this.base_file = 'guild';
        this.layout_file = 'GuildRBRecordItem';

        this.load_callback = () => {
            if (!this.is_set) {
                this.is_set = true;
                this.SetData();
            }
        };

        this.Load();
    }

    public DeleteMe() {
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
        this.PerSetHtml();
        let guild_daily_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, 'config_guild_daily', false);
        // [ts2lua]guild_daily_cfg下标访问可能不正确
        let cfg = guild_daily_cfg[this.data.task_id];
        let title = null;
        if (cfg) {
            title = cfg.name;
        }
        let con = `【${TimeUtil.timeFormat(this.data.time)}】${HtmlColorTxt(this.data.role_name, "'#0a953e'")}激活了${HtmlColorTxt(title + '宝箱', "'#d15e00'")}`;

        this._lb_desc.innerHTML = Util.StrToHTML(con);
    }

    PerSetHtml() {
        this._lb_desc.style.fontSize = 20;
        this._lb_desc.style.color = '#663915';
        this._lb_desc.width = this.WIDTH - 10;
    }

    _lb_desc: Laya.HTMLDivElement;
    public GetComponents() {
        [this._lb_desc] = this.GetChildrenByNames(['_lb_desc']);
    }
}
window['GuildRBRecordItem'] = GuildRBRecordItem;

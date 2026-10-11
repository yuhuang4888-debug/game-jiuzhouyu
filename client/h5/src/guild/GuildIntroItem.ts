import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { GuildModel } from '../commonModel/GuildModel';
import { SetHtmlStyle, Util } from '../util/Util';

export class GuildIntroItem extends BaseItemRenderer {
    _model: GuildModel;

    public WIDTH = 235;
    public HEIGT = 50;
    is_set = false;
    public constructor(parent) {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildIntroItem';
        this._model = GuildModel.GetInstance();
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
        if (!super.dataChanged()) {
            return;
        }

        if (this.is_loaded) {
            this.is_set = true;
            this.SetData();
        } else {
            this.is_set = false;
        }
    }

    SetData() {
        this.PreHtml();
        this._lb_content.innerHTML = Util.StrToHTML(this.data);
    }

    PreHtml() {
        SetHtmlStyle(this._lb_content, { c: '#ffffff', f: 20, w: 193, lh: 25 });
    }

    _Image1: Laya.Image;
    _lb_content: Laya.HTMLDivElement;
    public GetComponents() {
        [this._Image1, this._lb_content] = this.GetChildrenByNames(['_Image1', '_lb_content']);
    }
}
window['GuildIntroItem'] = GuildIntroItem;

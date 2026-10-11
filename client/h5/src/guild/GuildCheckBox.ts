import { BaseItem1 } from '../common/BaseItem1';
import { ResManager } from '../common/ResManager';
import { ColorUtil } from '../util/ColorUtil';
import { Util } from '../util/Util';

export class GuildCheckBox extends BaseItem1 {
    callback;
    data: {
        quality: number;
        name: string;
        key: string;
    };
    key: string;
    need_refresh_data: boolean;
    quality: number;
    select: boolean;

    public constructor(parent) {
        super(parent);

        this.base_file = 'guild';
        this.layout_file = 'GuildCheckBox';
        this.load_callback = () => {
            if (this.need_refresh_data) {
                this.UpdateView();
                this.need_refresh_data = false;
            }

            if (this.select != null) {
                this.SetSelect(this.select);
            }

            Util.AddClickEvent(
                this._Image1,
                () => {
                    this.SetSelect(!this.select);
                },
                this,
                true
            );
        };
    }

    public SetData(data?) {
        this.data = data;
        if (this.is_loaded) {
            this.UpdateView();
        } else {
            this.need_refresh_data = true;
        }
    }

    public UpdateView() {
        this.quality = this.data.quality;
        this.key = this.data.key;

        let color = ColorUtil.GetColorDark(this.quality);
        this.labelDisplay.color = ColorUtil.GetReplaceChar(color);
        this.labelDisplay.text = this.data.name; //HtmlColorTxt(this.data.name, color)
        this.display_obj.width = 60 + this.labelDisplay.textField.textWidth;
    }

    public SetCallBack(callback?) {
        this.callback = callback;
    }

    public SetSelect(bool?) {
        this.select = bool;
        if (this.is_loaded) {
            let res = (bool && 'com_ui_gx1') || 'com_ui_gx';
            ResManager.GetInstance().SetImageSprite(this, this._Image1, 'common_asset', res);
            if (this.callback) {
                this.callback(this.quality, bool);
            }
        }
    }

    public DeleteMe() {
        if (this.callback) {
            this.callback = null;
        }
        super.DeleteMe();
    }

    _Image1: Laya.Image;
    labelDisplay: Laya.Label;
    public GetComponents() {
        [this._Image1, this.labelDisplay] = this.GetChildrenByNames(['_Image1', 'labelDisplay']);
    }
}
window['GuildCheckBox'] = GuildCheckBox;

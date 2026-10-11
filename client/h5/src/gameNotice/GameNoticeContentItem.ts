import { BaseItem1 } from "../common/BaseItem1";
import { ResManager } from "../common/ResManager";
import { GameResPath } from "../util/GameResPath";
import { SetHtmlStyle, Util } from "../util/Util";

export class GameNoticeContentItem extends BaseItem1 {

    FormatStr
    title_width = 500
    public constructor(parent) {
        super(parent);
        this.base_file = "gameNotice";
        this.layout_file = "GameNoticeContentItem";

        this.load_callback = () => {
            SetHtmlStyle(this._lb_title, { c: "#663915", f: 24, w: this.title_width, lh: 36 })
            ResManager.GetInstance().SetTexture(this, this._img_lb, GameResPath.GetIcon("gameNotice", "ui_notice_05"))
        }


        this.FormatStr = (content) => {

            if (content && content.length > 0 && content.indexOf("0x") != -1) {
                let strs = content.split('0x')
                let str = ""
                for (let i = 0; i < strs.length; i++) {
                    if (i == 0) {
                        str += `${strs[i]}'#`
                    } else {
                        let temp = strs[i].slice(0, 6)
                        let re_str = strs[i].replace(temp, temp + "'")
                        if (i != strs.length - 1) {
                            str += `${re_str}'#`
                        } else {
                            str += `${re_str}`
                        }

                    }
                }
                return str
            } else {
                return content
            }
        }
    }
    public SetData(data, small_line?) {
        if (!data)
            return;
        let setWxEwm = () => {
            let group = new Laya.Box();
            group.width = 500;
            this._gp_details.addChild(group);
            let img = new Laya.Image();
            group.addChild(img);
            img.centerX = 0;
            img.width = img.height = 215;
        };
        if (small_line) {
            this._gp_details.space = 20;
        }
        data = data.split("\n@@");
        let desc = data[0];
        if (desc.indexOf("show_wx_img") != -1) {
            setWxEwm();
        } else {
            this._lb_title.innerHTML = Util.StrToHTML(this.FormatStr(data[0]));
            this._lb_title.style.width = this.title_width
        }

        if (data.length == 1) {
            this._lb_title.width = this.title_width;
            this._lb_title.x = -25;
            this._img_lb.visible = false;
            return;
        }

        let line_word = "&nbsp;&nbsp;&nbsp;&nbsp;"
        for (let i = 1; i < data.length; i++) {
            desc = data[i];
            if (desc.indexOf("show_wx_img") != -1) {
                setWxEwm();
            }
            else {
                let label = new Laya.HTMLDivElement()
                SetHtmlStyle(label, { w: this.title_width, f: 24, c: "#663915", lh: 36 })
                label.innerHTML = line_word + Util.StrToHTML(this.FormatStr(data[i]));
                label.style.width = this.title_width
                label.height = label.contextHeight
                this._gp_details.addChild(label);
            }
        }
    }
    _img_lb: Laya.Image
    _Group1: Laya.Box
    _lb_title: Laya.HTMLDivElement
    _gp_details: Laya.VBox
    public GetComponents() {
        [
            this._img_lb,
            this._Group1,
            this._lb_title,
            this._gp_details,
        ]
            = this.GetChildrenByNames([

                "_img_lb",
                "_Group1",
                "_lb_title",
                "_gp_details",
            ])
    }
}
window["GameNoticeContentItem"] = GameNoticeContentItem
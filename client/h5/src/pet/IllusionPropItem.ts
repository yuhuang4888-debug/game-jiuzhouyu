import { BaseItem1 } from "../common/BaseItem1";
import { Util } from "../util/Util";

export class IllusionPropItem extends BaseItem1 {
    prop_text: Laya.HTMLDivElement
    up_arrow: Laya.Image
    next_text: Laya.HTMLDivElement
    SetData

    public constructor(parent?) {
        super(parent)

        let prop_,
            cur_value_,
            next_value_,
            need_refresh_

        this.base_file = "pet"
        this.layout_file = "IllusionPropItem"
        this.load_callback = () => {
            if (need_refresh_) {
                this.SetData(prop_, cur_value_, next_value_)
            }
        }

        this.SetData = (prop?, cur_value?, next_value?) => {
            prop_ = prop
            cur_value_ = cur_value
            next_value_ = next_value
            if (this.is_loaded) {
                this.prop_text.width=173
                this.prop_text.height=30
                this.next_text.width=67
                this.next_text.height=30
                need_refresh_ = false
                this.prop_text.innerHTML = Util.StrToHTML(prop_ + ":&nbsp;<font color='#d15e00'>" + cur_value + "</font>" )
                if (next_value && next_value != 0 && next_value != "0%") {
                    this.up_arrow.visible = true
                    this.next_text.innerHTML = Util.StrToHTML("<font color='#0a953e'>" + next_value_ + "</font>")
                } else {
                    this.up_arrow.visible = false
                    this.next_text.innerHTML = ""
                }
            } else {
                need_refresh_ = true
            }
        }

    }


    public GetComponents() {
        [
            this.prop_text,
            this.up_arrow,
            this.next_text,
        ]
            = this.GetChildrenByNames([
                "prop_text",
                "up_arrow",
                "next_text",
            ])
        this.prop_text.style.fontSize=20
        this.prop_text.style.color="#663915"
        this.next_text.style.fontSize=20
        this.next_text.style.color="#a953e"
    }
}
window["IllusionPropItem"] = IllusionPropItem
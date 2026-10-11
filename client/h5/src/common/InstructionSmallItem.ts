import { Util } from "../util/Util";
import { BaseItem1 } from "./BaseItem1";

export class InstructionSmallItem extends BaseItem1 {

    content: string

    need_refresh_data = false

    constructor(parent) {
        super(parent);
        this.base_file = "common"
        this.layout_file = "InstructionSmallItem"
        this.is_load_res = false

        this.load_callback = () => {
            this.LoadSuccess()
        }
    }

    public LoadSuccess() {

        this._lb_desc.style.fontSize = 18
        this._lb_desc.style.color = "#663915"
        this._lb_desc.style.valign = "top"
        this._lb_desc.style.width = 560
        this._lb_desc.style.lineHeight = 26
       // this._lb_desc.style.bold = true

        if (this.need_refresh_data) {
            this.need_refresh_data = false
            this.UpdateItem()
        }
    }

    public SetData(content): void {
        this.content = content
        if (this.is_loaded) {
            this.UpdateItem()
        }
        else {
            this.need_refresh_data = true
        }
    }

    private UpdateItem(): void {
        if (!this._lb_desc) {
            return
        }
        this._lb_desc.innerHTML = this.content
        this._lb_desc.style.width = 552
        this._lb_desc.callLater(() => {
            if(this.use_delete_method) return
            this.display_obj.height = this._lb_desc.height
        })
    }

    public DeleteMe() {
        super.DeleteMe()
    }

    _lb_desc: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._lb_desc,
        ]
            = this.GetChildrenByNames([

                "_lb_desc",
            ])
    }
}
window["InstructionSmallItem"] = InstructionSmallItem
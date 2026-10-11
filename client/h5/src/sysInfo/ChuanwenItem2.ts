import { ChuanwenItem } from "./ChuanwenItem";
export class ChuanwenItem2 extends ChuanwenItem {

    public constructor(parent) {
        super(parent);
        this.base_file = "sysInfo";
        this.layout_file = "ChuanwenItem";
        this.is_delay_callback = false;
        this.load_callback = function () {
            this.display_obj.visible = false;
            this.display_obj.y = 160;
            this.display_obj.centerX = 0
            if (this.need_refresh) {
                this.AppendMessage(this.msg)
            }
        };
    }
}
window["ChuanwenItem2"] = ChuanwenItem2
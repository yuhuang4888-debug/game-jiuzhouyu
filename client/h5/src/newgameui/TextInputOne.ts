import { BaseItem1 } from "../common/BaseItem1";

export class TextInputOne extends BaseItem1 {
    public _img_bg: Laya.Image;
    public textDisplay:Laya.TextInput
    public promptDisplay:Laya.Label
    public constructor(parent?) {
        super(parent);
        this.base_file = "newgameui"
        this.layout_file = "TextInputOne"
        this.load_callback=()=>{
            this.display_obj.x=500
            this.display_obj.y=500
        }
    }

    public GetComponents() {
        [
            this.textDisplay,
            this.promptDisplay,
            this._img_bg
        ]
            = this.GetChildrenByNames([

                "textDisplay",
                "promptDisplay",
                "_img_bg"
            ])
    }
}

window["TextInputOne"] = TextInputOne
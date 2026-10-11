import { BaseItem1 } from "../common/BaseItem1"

export class CheckBox extends BaseItem1 {
    checkImg:Laya.Image
    checkLabel 
    selected
    click_call_back
    check_text
    text_x
    click_cond_call
    load_call_back
	public constructor(parent, click_call_back?, check_text?, click_cond_call?, load_call_back?) {
		super(parent)
		this.base_file = "alert"
		this.layout_file = "TheCheckBox"
        this.selected = false
        this.click_call_back = click_call_back
        this.check_text = check_text
        this.click_cond_call = click_cond_call
        this.load_call_back = load_call_back
        this.load_callback=()=>{
            this.LoadSuccess()
            this.InitEvent()
        }
	}

	public LoadSuccess() {
        this.checkLabel.text= this.check_text ? this.check_text : "本次登录不再提示"
        if(this.load_call_back){
            this.load_call_back()
        }
        this.UpdateCheckImg()
	}

    public InitEvent(){
        this.checkImg.on(Laya.Event.CLICK, this, ()=>{
            if(this.click_cond_call && !this.click_cond_call()) return
            this.selected = !this.selected
            this.UpdateCheckImg()
            if (this.click_call_back) {
                this.click_call_back(this.selected)
            }
        })
    }

    public UpdateCheckImg(){
        if(this.selected){
            this.checkImg.skin="resource/game/alert/texture/com_ui_gx1.png"
        }
        else{
            this.checkImg.skin="resource/game/alert/texture/com_ui_gx.png"
        }
    }

    public GetComponents(){
        [this.checkImg,
            this.checkLabel,] =
            this.GetChildrenByNames(
                ["checkImg"
                , "checkLabel",])
    }
}
window["CheckBox"] = CheckBox
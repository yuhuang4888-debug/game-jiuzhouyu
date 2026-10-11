import { BaseItem1 } from "../common/BaseItem1"

export class attributePotionProgressBar extends BaseItem1 {
	//public
    public _Image1: Laya.Image
    public thumb: Laya.Image
    public labelDisplay: Laya.Label

    maximum
    width
    value

	public constructor(parent) {
		super(parent)
		this.base_file = "attributePotion"
		this.layout_file = "attributePotionProgressBar"
        this.load_callback=()=>{
            this.LoadSuccess()
            this.InitEvent()
        }
	}


	public LoadSuccess() {

	}

    public InitEvent(){

    }

    public setValue(value?){
        this.value=value
        this.width=value/this.maximum*300
        if(this.thumb){
            this.thumb.width=this.width
        }
        if(this.labelDisplay){
            this.labelDisplay.text=this.value.toString()+"/"+this.maximum.toString()
        }
    }

    public setMax(value?){
        this.maximum=value
    }

    public setWidth(width?){
        this.width=width
        if(this.thumb){
            this.thumb.width=this.width
        }
    }

    public GetComponents() {
        [
            this._Image1,
            this.thumb,
            this.labelDisplay,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "thumb",
                "labelDisplay",
            ])
        if(this.value!=undefined){
            this.thumb.width=this.width
            this.labelDisplay.text=this.value.toString()+"/"+this.maximum.toString()
        }else{
            if(this.width!=undefined){
                this.thumb.width=this.width
            }
        }  
    }
}


window["attributePotionProgressBar"] = attributePotionProgressBar
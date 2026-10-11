import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Util, Trim, SetHtmlStyle, HtmlColorTxt } from "../util/Util"

export class PrivilegeItem extends BaseItemRenderer {
public WIDTH: number = 611
public HEIGT: number = 97

public constructor(parent){
super() 
	
    this.base_file = "country"
    this.layout_file = "PrivilegeItem"
    this.load_callback = () => {
        SetHtmlStyle(this.disLb,{c:"#774239",f:20,lh:25,w:188,ww:true})
        this.InitEvent()
    }
    this.Load()
}

public InitEvent(){ 
	
    Util.AddClickEvent(
        this.useBtn,() => {
            if (this.data)
            {
                SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.REQUEST_PROTO, 18652, "hc", this.data.data.priv_id, this.data.type)
            }
        },
        this,
        true
    )
}

public dataChanged(){ 
	if(!super.dataChanged())return
    let data = this.data.data
    let cfg = data.cfg
    if (cfg)
    {
        if (this.data.type == 1)
        {
            this.nameLb.text = cfg.privilege_name
            this.labelDisplay.text = this.nameLb.text
            // [ts2lua]lua中0和空字符串也是true，此处data.residue_num == 0需要确认
            let color = (data.residue_num == 0 && ( "'#ff4f50'" ) || ( "'#359700'" ) )
            let str1=`(${HtmlColorTxt( data.residue_num,color)}/${HtmlColorTxt( cfg.day_times,"'#639c12'")})`
            let str=`${cfg.privilege_desc},持续${cfg.duration / 60}分钟${str1}`
            this.disLb.innerHTML = str
        }else{
            this.nameLb.text = cfg.un_privilege_name
            this.labelDisplay.text = this.nameLb.text
            this.disLb.innerHTML = Trim(cfg.un_privilege_desc)
        }

        this.disLb.style.width=188
        this.disLb.y=(this.display_obj.height-this.disLb.contextHeight)/2
       

        let str = ""
        let needList = data.need_job
        let i = 0
        do {
            let vo = needList[i]
            str = str + SeaHegemonyModel.GetInstance().GetPositionName(vo.job_id)
            if (i != needList.length - 1)
            {
                str = str + "\n"
            }
            i = i + 1
        } while ((i < needList.length))
        this.needLb.text = Trim(str)
    }
}

public DeleteMe(): void {
    super.DeleteMe()
}


_Image1:Laya.Image
nameLb:Laya.Label
disLb:Laya.HTMLDivElement
needLb:Laya.Label
useBtn:Laya.Box
_Image11:Laya.Image
labelDisplay:Laya.Label
public GetComponents() {
[
this._Image1,
this.nameLb,
this.disLb,
this.needLb,
this.useBtn,
this._Image11,
this.labelDisplay,
]
 = this.GetChildrenByNames([

"_Image1",
"nameLb",
"disLb",
"needLb",
"useBtn",
"_Image11",
"labelDisplay",
])
}
}
 window["PrivilegeItem"]= PrivilegeItem
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class SeaPayItem extends BaseItemRenderer {

public WIDTH: number = 615
public HEIGT: number = 190
rewardList
public constructor(parent){
super() 
	
    this.base_file = "seaHegemony"
    this.layout_file = "SeaPayItem"

    this.load_callback = () => {
        
        this.InitEvent()
    }

    this.Load()
}

public InitEvent(){ 
	
    ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("seaHegemony","uitc_028"))
}

public dataChanged(){ 
	if(!super.dataChanged())return
    let reward = this.SetLbGetReward()
    if (! this.rewardList)
    {
        this.rewardList = []
    }

    for (let i = 0; i < this.rewardList.length; i++){
        this.rewardList[i].SetVisible(false)
    }

    for (let i = 1; i <= reward.length; i++){
        let item = this.rewardList[i]
        if (! item)
        {
            item =  new BaseAwardItem(this.Content)
            item.Load()
            item.SetItemSize(115, 115)
            this.rewardList[i] = item
        }else{
            item.visible = true
        }
        let vo = reward[i]
        let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
        item.SetData(type_id, vo[2])
        item.SetVisible(true)
    }
}

public SetLbGetReward(){ 
	
    let str = null
    let reward = null
    let cfg = this.data.cfg
    str = "<font color=0x639c12>【" + cfg.name + "】</font>每日可获得"
    reward = ErlangParser.GetInstance().Parse(cfg.normal)
    this.rewardLb.text = Util.StrToHTML(str)
    return reward
}

public DeleteMe(){ 
	
    if (this.rewardList)
    {
        for (let _tmpi in this.rewardList) {
	var vo = this.rewardList[_tmpi]
            vo.DeleteMe()
        }
        this.rewardList = null
    }
    super.DeleteMe()
}

bg:Laya.Image
rewardLb:Laya.Label
_Scroller1:Laya.Panel
Content:Laya.HBox
public GetComponents() {
[
this.bg,
this.rewardLb,
this._Scroller1,
this.Content,
]
 = this.GetChildrenByNames([

"bg",
"rewardLb",
"_Scroller1",
"Content",
])
}
}
 window["SeaPayItem"]= SeaPayItem
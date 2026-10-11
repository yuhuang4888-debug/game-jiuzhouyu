import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SetHtmlStyle, Util } from "../util/Util"

export class SeaRewardRankItem extends BaseItemRenderer {

public WIDTH: number = 585
public HEIGT: number = 136
rewardList
public constructor(parent){
super() 
	
    this.base_file = "seaHegemony"
    this.layout_file = "SeaRewardRankItem"

    this.load_callback = () => {
        SetHtmlStyle(this.rewardLb,{c:"#663915",f:18,ww:false,w:450})
        //this._Scroller1.hScrollBarSkin=""
    }
    this.Load()
}

public SetLbGetReward(){ 
	
    let rank = (this.data.min == this.data.max && ( this.data.min ) || ( this.data.min + "~" + this.data.max ) )
    let str = (this.data.act_type == 1 && ( "结社" ) || ( "海域势力" ) ) + "积分榜第<font color='#639c12'>" + rank + "</font>名可获得以下奖励"
    this.rewardLb.innerHTML = Util.StrToHTML(str)
    return JSON.parse(this.data.reward)
}

public dataChanged(){ 
	if(!super.dataChanged())return
    if (! this.data)
    {
        return
    }
    let reward = this.SetLbGetReward()
    if (! this.rewardList)
    {
        this.rewardList = []
    }
    for (let i = 0; i < this.rewardList.length; i++){
        this.rewardList[i].SetVisible(false)
    }

    for (let i = 0; i < reward.length; i++){
        let item:BaseAwardItem = this.rewardList[i]
        if (! item)
        {
            item =  new BaseAwardItem(this.Content)
            item.SetUseMask(true)
            item.Load()
            item.SetItemSize(92, 92)
            this.rewardList[i] = item
        }else{
            item.SetVisible(true)
        }
        let vo = reward[i]
        let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
        item.SetData(type_id, vo[2])
    }
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
bg2:Laya.Image
rewardLb:Laya.HTMLDivElement
_Scroller1:Laya.Panel
Content:Laya.HBox
public GetComponents() {
[
this.bg,
this.bg2,
this.rewardLb,
this._Scroller1,
this.Content,
]
 = this.GetChildrenByNames([

"bg",
"bg2",
"rewardLb",
"_Scroller1",
"Content",
])
}
}
 window["SeaRewardRankItem"]= SeaRewardRankItem
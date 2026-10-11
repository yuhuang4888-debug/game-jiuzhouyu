import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopItem } from "../shop/ShopItem"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util, Color } from "../util/Util"
import { HotPointModel } from "./HotPointModel"
import { kfHotPointItem } from "./kfHotPointItem"

export class AkfHotPointItem extends BaseItemRenderer {
    _img_1: Laya.Image
    _scorller: Laya.List
    item_list
    public static width = 696
    public static height = 164
    public constructor(parent) {
        super()
        this.base_file = "kfHotPoint"
        this.layout_file = "AkfHotPointItem"
        this.WIDTH = 702
        this.HEIGT = 190
        this.Load()
    }

    public load_callback() {
        ResManager.GetInstance().SetTexture(this.base_item,this._img_1,GameResPath.GetIcon("kfHotPoint","ukfhd_015a1"))
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        this.InitView()
    }

    public InitEvent() {

    }

    public InitView() {
        if(!super.dataChanged())return 
        if(this.data){
            if(!this.item_list){
                this.item_list=new LoopScrowViewMgr()
                this.item_list.SetData(this._scorller,kfHotPointItem,this.data,LoopScrCon.Horizontal)
            }else{
                this.item_list.replaceAll(this.data)
            }
        }
    }

    public DeleteMe() {
       if(this.item_list){
           this.item_list.DeleteMe()
           this.item_list=null
       }
       super.DeleteMe()
    }
    public GetComponents() {
        [
            this._img_1,
            this._scorller,
        ]
            = this.GetChildrenByNames([

                "_img_1",
                "_scorller",
            ])
        this._scorller.scrollBar.visible=false
    }
}
window["AkfHotPointItem"]=AkfHotPointItem
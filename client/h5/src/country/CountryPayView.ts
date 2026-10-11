import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { CountryPayItem } from "./CountryPayItem"

export class CountryPayView extends BaseView1 {

    InitView
    itemArr
    SetReward
    public constructor() {
        super()

        this.base_file = "country"
        this.layout_file = "CountryPayView"
        this.layer_value = Enum_UILayer.Activity
        this.preload_server_config={"config_seacraft_daily_reward":false}
        this.use_background = true
        this.click_bg_toClose = true
        this.destroy_imm=true
        this.is_center = true
        this.load_callback = () => {

            this.InitView()
        }

        this.destroy_callback=()=>{
            if (this.itemArr) {
                this.itemArr.DeleteMe()
                this.itemArr = null
            }
        }

        this.InitView = () => {
            this.BindEvent(SeaHegemonyModel.GetInstance(), SeaHegemonyModel.UPDATE_SEA_INFO, ()=>{
                this.SetReward()
            })

            this.SetReward()
            Util.AddClickEvent(this.closeBtn, () => {
                    this.Close()
            },this,true)
        }

        this.SetReward=()=>{
            let rewardList = []
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_seacraft_daily_reward",false)
            if (cfg) {
                for(let key in cfg){
                    table.insert(rewardList, cfg[key])
                }
            }

            if(!this.itemArr){
                this.itemArr = new LoopScrowViewMgr()
                this.itemArr.SetData(this.Content, CountryPayItem, rewardList,LoopScrCon.Vertical)
            }else{
                this.itemArr.replaceAll(rewardList)
            }
        }
    }

    public DeleteMe() {

 
        super.DeleteMe()
    }


bg:Laya.Image
closeBtn:Laya.Image
_Image2:Laya.Image
_Image4:Laya.Image
Content:Laya.List
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
_Image2_title:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this.bg,
this.closeBtn,
this._Image2,
this._Image4,
this.Content,
this._Label1,
this._Label2,
this._Label3,
this._Image2_title,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"bg",
"closeBtn",
"_Image2",
"_Image4",
"Content",
"_Label1",
"_Label2",
"_Label3",
"_Image2_title",
"_lb_win_name",
])
}
}
 window["CountryPayView"]= CountryPayView
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { Util, SetAnchoredPositionX } from "../util/Util"
import { GuildFightDistributionItem } from "./GuildFightDistributionItem"

export class GuildFightDistributionView extends BaseView1 {
    InitEvent
    LoadSuccess
    click_bg_toClose
    defaultIndex
    is_center
    item_list_loop_mgr:LoopScrowViewMgr
    item_loop_list
    open_callback
    show_open_movie
    use_background

    public constructor() {
        super()

        this.defaultIndex = 0
        this.base_file = "guildFight"
        this.layout_file = "GuildFightDistributionView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        let model = GuildModel.GetInstance()
        this.item_loop_list = []
        this.item_list_loop_mgr = null
        this.load_callback = () => {

            this.InitEvent()
            this.LoadSuccess()
            model.Fire(GuildEvent.REQUEST_PROTO, 40006)
        }

        this.open_callback = () => {
           
        }

        this.LoadSuccess = () => {
            this.item_loop_list = []
            this.item_list_loop_mgr = new LoopScrowViewMgr()
            this.item_list_loop_mgr.SetData(this._list_items, GuildFightDistributionItem, this.item_loop_list, LoopScrCon.Vertical, 1, (item?) => {

            })

            let guild_data = model.GetMemberInfo()
            if (guild_data) {
                table.sort(guild_data.member_list, (a?, b?) => {
                    if (b.historical_donate != a.historical_donate) {
                        return b.historical_donate > a.historical_donate
                    }
                    return false
                })
                this.item_loop_list = guild_data.member_list
                this.item_list_loop_mgr.replaceAll(this.item_loop_list)
            }

            if(this.item_loop_list.length>0){
                this.item_list_loop_mgr.SetSelectIndex(this.defaultIndex)
            }
           
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this.returnBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.distributionBtn, () => {
                    let item_data=this.item_loop_list[this._list_items.selectedIndex]
                    let role_id = (item_data&&item_data.role_id)?item_data.role_id:0
                    if (role_id) {
                        model.Fire(GuildEvent.REQUEST_PROTO, 50618, "l", role_id)
                    }
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            this.BindVar(
                model,
                "member_info", () => {
                    let guild_data = model.GetMemberInfo()
                    if (guild_data) {
                        table.sort(guild_data.member_list, (a?, b?) => {
                            if (b.historical_donate != a.historical_donate) {
                                return b.historical_donate > a.historical_donate
                            }
                            return false
                        })

                        this.item_loop_list = guild_data.member_list
                        this.item_list_loop_mgr.replaceAll(this.item_loop_list)
                    }
                }
            )
        }

        
    }

   
_Image11:Laya.Image
_Group1:Laya.HBox
_Image2:Laya.Image
_Label1:Laya.Label
_Image3:Laya.Image
_Image4:Laya.Image
_Image5:Laya.Image
_list_items:Laya.List
distributionBtn:Laya.Box
_Image1:Laya.Image
labelDisplay1:Laya.Label
returnBtn:Laya.Box
_Image111:Laya.Image
labelDisplay:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
_Label4:Laya.Label
_Label5:Laya.Label
_Label6:Laya.Label
_Image6:Laya.Image
_Image7:Laya.Image
_Image8:Laya.Image
_Image9:Laya.Image
closeBtn:Laya.Image
public GetComponents() {
[
this._Image11,
this._Group1,
this._Image2,
this._Label1,
this._Image3,
this._Image4,
this._Image5,
this._list_items,
this.distributionBtn,
this._Image1,
this.labelDisplay1,
this.returnBtn,
this._Image111,
this.labelDisplay,
this._Label2,
this._Label3,
this._Label4,
this._Label5,
this._Label6,
this._Image6,
this._Image7,
this._Image8,
this._Image9,
this.closeBtn,
]
 = this.GetChildrenByNames([

"_Image11",
"_Group1",
"_Image2",
"_Label1",
"_Image3",
"_Image4",
"_Image5",
"_list_items",
"distributionBtn",
"_Image1",
"labelDisplay1",
"returnBtn",
"_Image111",
"labelDisplay",
"_Label2",
"_Label3",
"_Label4",
"_Label5",
"_Label6",
"_Image6",
"_Image7",
"_Image8",
"_Image9",
"closeBtn",
])
}
}
 window["GuildFightDistributionView"]= GuildFightDistributionView
import { findConfigFile, forEachTrailingCommentRange } from "../../node_modules/typescript/lib/typescript"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { longlangModel } from "../commonModel/longlangModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { longlangEquipItem } from "../longlanguage/longlangEquipItem"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { RefGridLayout, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class PlayerMessageLongLanguageView extends BaseItem1 {



    DesFunc
    InitView
    attr_box
    InitEvent
    UpdateView
    SetData
    need_refreshData
    select
    equip_list
    InitEquipitem
    data
    role_data

    public constructor(parent?) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageLongLanguageView"
        this.layer_value = Enum_UILayer.Activity
        let common_mgr = CommonManager.GetInstance()
        let local_roleVo = RoleManager.GetInstance().GetMainRoleVo()
        let local_resMgr = ResManager.GetInstance()
        this.equip_list = []
        let typeId_,
            illuItemList_ = {},
            propItemList_ = [],
            costItem_

        this.preload_client_config = {

        }

        this.load_callback = () => {
            this.InitEvent()
            this.InitView()
            this.InitEquipitem()
        }

        // this.SetData = (select?) => {
        //     this.select = select
        //     if (this.is_loaded) {

        //     } else {
        //         this.need_refreshData = true
        //     }
        // }

        this.SetData = (data?) => {
            this.role_data = data
            if (this.is_loaded) {

            } else {
                this.need_refreshData = true
            }
        }

        this.InitEvent = () => {
            this.BindEvent(FriendModel.GetInstance(),FriendEvent.UPDATE_PLAYERMESSAGE_LONGLANGUAGE,(scmd?) => {
                this.UpdateView(scmd)
            })

            Util.AddClickEvent(this._gp_btn, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "PlayerMessageLongLanguageAttrView",this.data)
            }, this, true)
        }

        this.InitView = () => {
            local_resMgr.SetTexture(this, this.bg, GameResPath.GetIcon("playerMessage", "ui_rwxx_bg_03"))
            local_resMgr.SetTexture(this,this.none_1,GameResPath.GetIcon("playerMessage","none_1"))
            local_resMgr.SetOutsideImageSprite(this, this.image_bg, GameResPath.GetIcon("playerMessage", "ui_none_bg"), true)
        }

        this.InitEquipitem = () => {
            let item = null
            let i = 0
            do {
                item = new longlangEquipItem(this["_gp_" + i])
                item.Load()
                this.equip_list[i] = item
                i = i + 1
            } while ((i < longlangModel.EQUIP_COUNT))
        }

        this.UpdateView = (scmd?) => {
            let view_name = "longlanguageView"
            if(common_mgr.CheckOtherPlayerFuncOpenState(view_name, this.role_data)){
                this.show_Info.visible = true
                this.none.visible = false
                this.data = scmd
                let list = scmd.pos_list
                let i = 1
                let equip
                let sub_type
                let info_list = []
                do {
                    equip = list[i-1]
                    if(equip){
                        sub_type = equip.pos
                        equip = Object.assign({}, GoodsModel.GetInstance().GetGoodsBasicByTypeId(equip.type_id)); 
                        equip["rating"] = list[i-1].rating
                        equip["strong"] = list[i-1].strong
                    }
                    if(!info_list[sub_type] ){
                        info_list[sub_type] = equip
                    }
                    i++
                } while ((i <= longlangModel.EQUIP_COUNT))
                i = 1 
                do {
                    equip = { equip_type: i, type_id: 0 }
                    if(!info_list[i]){
                        info_list[i] = equip
                    }
                    i++
                } while ((i <= longlangModel.EQUIP_COUNT))
                i = 0
                do {
                    let info = info_list[i+1]
                    // if(info.equip_type == undefined && info.equip != 0){
                    //     info.equip_type =i+1
                    // }
                    if(!info){
                        info = {}
                    }
                    info["other"] = true
                    info["suit"] = scmd.suit_list
                    this.equip_list[i].SetData(info)
                    i++
                } while ((i < longlangModel.EQUIP_COUNT))
                this.lb_fight.text = scmd.sum_power
            }else{
                this.show_Info.visible = false
                this.none.visible = true
            }
        }

        this.DesFunc = () => {
            if (costItem_) {
                costItem_.DeleteMe()
                costItem_ = null
            }
            if (propItemList_) {
                for (let vo of propItemList_) {
                    vo.DeleteMe()
                    vo = null
                }
                propItemList_ = []
            }
            if (illuItemList_) {
                for (let key in illuItemList_) {
                    illuItemList_[key].DeleteMe()
                    delete illuItemList_[key]
                }
                illuItemList_ = {}
            }
            if(this.equip_list){
                for(let key in this.equip_list){
                    this.equip_list[key].DeleteMe()
                }
                this.equip_list = null
            }
        }
    }

    public DeleteMe(){
        this.DesFunc()
        super.DeleteMe()
    }



    bg: Laya.Image
    lb_fight: Laya.Label
    _gp_btn: Laya.Box
    img_btn: Laya.Image
    equipGp: Laya.Box
    _gp_0: Laya.Box
    _gp_1: Laya.Box
    _gp_2: Laya.Box
    _gp_3: Laya.Box
    _gp_4: Laya.Box
    _gp_5: Laya.Box
    _gp_6: Laya.Box
    _gp_7: Laya.Box
    _gp_8: Laya.Box
    _gp_9: Laya.Box
    _gp_10: Laya.Box
    none:Laya.Box
    none_1: Laya.Image
    show_Info: Laya.Box
    image_bg

    public GetComponents() {
        [
            this.bg,
            this.lb_fight,
            this._gp_btn,
            this.img_btn,
            this.equipGp,
            this._gp_0,
            this._gp_1,
            this._gp_2,
            this._gp_3,
            this._gp_4,
            this._gp_5,
            this._gp_6,
            this._gp_7,
            this._gp_8,
            this._gp_9,
            this._gp_10,
            this.none,
            this.none_1,
            this.show_Info,
            this.image_bg,
        ]
            = this.GetChildrenByNames([

                "bg",
                "lb_fight",
                "_gp_btn",
                "img_btn",
                "equipGp",
                "_gp_0",
                "_gp_1",
                "_gp_2",
                "_gp_3",
                "_gp_4",
                "_gp_5",
                "_gp_6",
                "_gp_7",
                "_gp_8",
                "_gp_9",
                "_gp_10",
                "none",
                "none_1",
                "show_Info",
                "image_bg",
            ])
        ResManager.GetInstance().LoadFont(this, "fighting_font", this.lb_fight, null, false)
    }
}
window["PlayerMessageLongLanguageView"] = PlayerMessageLongLanguageView
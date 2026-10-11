import { BaseItem1 } from "../common/BaseItem1"
import { CommonManager } from "../common/CommonManager"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import { GameResPath } from "../util/GameResPath"
import { PlayerMessageGodbeastItem } from "./PlayerMessageGodbeastItem"

export class PlayerMessageGodbeast extends BaseItem1 {
    BG: Laya.Image
    lb_fight: Laya.Label
    lb_bg: Laya.Image
    lb_number: Laya.Label
    itemGp: Laya.List
    line: Laya.Image
    show_Info: Laya.Box
    none:Laya.Box
    none_1: Laya.Image
    bg: Laya.Image

    DesFunc
    InitView
    attr_box
    InitEvent
    UpdateView
    SetData
    need_refreshData
    select
    data
    role_data
    item_loop_mgr
    demon_loop_mgr
    public constructor(parent?) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageGodBeast"
        this.layer_value = Enum_UILayer.Activity
        let local_resMgr = ResManager.GetInstance()
        let _model = FriendModel.GetInstance()
        let common_mgr = CommonManager.GetInstance()
        let cfg = null
        this.preload_server_config = {
            "config_eudemons_item": false
        }

        this.preload_client_config = {

        }

        this.load_callback = () => {
            local_resMgr.SetTexture(this,this.none_1,GameResPath.GetIcon("playerMessage","none_1"))
            local_resMgr.SetTexture(this,this.line,GameResPath.GetIcon("playerMessage","ui_rwxx_cy02"))
            cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_eudemons_item",false)
            local_resMgr.SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("playerMessage", "ui_none_bg"))
            this.InitEvent()
            this.InitView()
            if (this.need_refreshData) {
                _model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this.role_data.server_id, this.role_data.role_id, 10)
                this.need_refreshData = false
            }
        }

        this.SetData = (data) => {
            this.role_data = data
            if (this.is_loaded) {
                _model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this.role_data.server_id, this.role_data.role_id, 10)
            } else {
                this.need_refreshData = true
            }
        }
        this.InitEvent = () => {
            this.BindEvent(FriendModel.GetInstance(), FriendEvent.UPDATE_PLAYERMESSAGE_GODBEAST, (scmd?) => {
                this.UpdateView(scmd)
            })
        }

        this.InitView = () => {
            local_resMgr.SetTexture(this, this.BG, GameResPath.GetIcon("playerMessage", "ui_rwxx_ssbg"))

        }

        this.UpdateView = (scmd?) => {
            let view_name = "GodBeastView"
            if(common_mgr.CheckOtherPlayerFuncOpenState(view_name, this.role_data) && scmd.eudemons_list.length > 0){
                this.show_Info.visible = true
                this.lb_fight.text = scmd.all_score
                this.lb_number.text ="助战数量：" + scmd.battle_num
                if(!cfg){
                    cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_eudemons_item",false)
                }
                for(let key in scmd.eudemons_list){
                    if(cfg[scmd.eudemons_list[key].id]){
                        scmd.eudemons_list[key]["info"] = cfg[scmd.eudemons_list[key].id]
                    }
                }
                if (!this.item_loop_mgr) {
                    this.item_loop_mgr = new LoopScrowViewMgr()
                    this.item_loop_mgr.SetData(this.itemGp, PlayerMessageGodbeastItem,scmd.eudemons_list,LoopScrCon.Vertical)
    
                }else{
                    this.item_loop_mgr.replaceAll(scmd.eudemons_list)
                }
            }else{
                this.show_Info.visible = false
                this.none.visible = true
            }
        }

        this.DesFunc = () => {

        }
    }

    public DeleteMe() {
        if(this.item_loop_mgr){
            this.item_loop_mgr.DeleteMe()
            this.item_loop_mgr = null
        }

        super.DeleteMe()
    }


    public GetComponents() {
        [
            this.BG,
            this.lb_fight,
            this.lb_bg,
            this.lb_number,
            this.itemGp,
            this.line,
            this.show_Info,
            this.none,
            this.none_1,
            this.bg
        ]
            = this.GetChildrenByNames([

                "BG",
                "lb_fight",
                "lb_bg",
                "lb_number",
                "itemGp",
                "line",
                "show_Info",
                "none",
                "none_1",
                "bg"
            ])
    }
}
window["PlayerMessageGodbeast"] = PlayerMessageGodbeast
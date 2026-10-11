import { BaseItem1 } from "../common/BaseItem1";
import { CommonManager } from "../common/CommonManager";
import { ResManager } from "../common/ResManager";
import { FriendEvent, FriendModel } from "../commonModel/FriendModel";
import { LungModel } from "../commonModel/LungModel";
import { GameResPath } from "../util/GameResPath";
import { PlayerMessageLungGridList } from "./PlayerMessageLungGridList";

export class PlayerMessageLungView extends BaseItem1 {

    LoadSuccess
    InitEvents
    SetData
    UpdateView
    role_data
    data
    public constructor(parent) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageLungView"
        let local_resMgr = ResManager.GetInstance()
        let common_mgr = CommonManager.GetInstance()
        let model = LungModel.GetInstance(),
            _friendmodel = FriendModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            style_item_list_

        this.load_callback = function () {
            this.InitEvents()
            this.LoadSuccess()
        }
        this.preload_server_config = {
            "config_dragon_pos": false
        }

        this.DeleteMe = () => {
            if (style_item_list_) {
                for (let item of style_item_list_) {
                    item.DeleteMe()
                }
                style_item_list_ = null
            }
            super.DeleteMe()
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetTexture(this,this.bg,GameResPath.GetIcon("playerMessage","ui_rwxx_bg"))
            local_resMgr.SetTexture(this,this.none_1,GameResPath.GetIcon("playerMessage","none_1"))
            local_resMgr.SetOutsideImageSprite(this, this.image_bg, GameResPath.GetIcon("playerMessage", "ui_none_bg"), true)
            _friendmodel.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT,this.role_data.server_id, this.role_data.role_id, 9)
        }

        this.InitEvents = () => {
            this.BindEvent(_friendmodel,FriendEvent.UPDATE_PLAYERMESSAGE_LUNG,(scmd?) => {
                this.UpdateView(scmd)
            })
        }

        this.SetData = (data) => {
            this.role_data = data
        }

        this.UpdateView = (scmd) => {
            let view_name = "LungStoveMainView"
            if(common_mgr.CheckOtherPlayerFuncOpenState(view_name, this.role_data)){
                this.show_Info.visible = true
                this.none.visible = false
                this.lb_fight.text = scmd.all_power
                this.lv.text = scmd.all_level
                let dragon_pos_cfg = res_mgr.GetGameConfigFromCache(this, "config_dragon_pos", false)
                let all_grid_list = model.GetAllGridList(dragon_pos_cfg)
                if (all_grid_list && all_grid_list.length > 0) {
                    if (!style_item_list_) {
                        style_item_list_ = []
                    }
                    let item: PlayerMessageLungGridList
                    for (let i = 0, length = all_grid_list.length; i < length; i++) {
                        item = style_item_list_[i]
                        if (!item) {
                            item = new PlayerMessageLungGridList(this.grid_con)
                            item.Load()
                            style_item_list_[i] = item
                        }
                        item.SetData(all_grid_list[i], i,scmd)
                    }
                }
            }else{
                this.show_Info.visible = false
                this.none.visible = true
            }
        }
    }
    grid_con: Laya.HBox
    lb_fight: Laya.Label
    lv: Laya.Label
    bg: Laya.Image
    none:Laya.Box
    none_1: Laya.Image
    show_Info: Laya.Box
    image_bg: Laya.Image

    public GetComponents() {
        [
            this.grid_con,
            this.lb_fight,
            this.lv,
            this.bg,
            this.none,
            this.none_1,
            this.show_Info,
            this.image_bg
        ]
            = this.GetChildrenByNames([

                "grid_con",
                "lb_fight",
                "lv",
                "bg",
                "none",
                "none_1",
                "show_Info",
                "image_bg"
            ])
    }
}
window["PlayerMessageLungView"] = PlayerMessageLungView
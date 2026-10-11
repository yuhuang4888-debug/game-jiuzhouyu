import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonManager } from "../common/CommonManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { DailyModel } from "../commonModel/DailyModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"

export class AutoBrushRankItem extends BaseItemRenderer {
    public WIDTH = 552
    public HEIGT = 46

    auto_brush_model:AutoBrushModel
    public constructor() {
        super()
        this.base_file = "autoBrush"
        this.layout_file = "AutoBrushRankItem"
        this.auto_brush_model = AutoBrushModel.GetInstance()
        this.load_callback = function () {
            this.LoadSuccess()
        }
        this.Load()
    }

    public LoadSuccess() {

    }

    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data
            if(data.rank < 4){
                this._img_rank.visible = true
                this._lb_rank.visible = false

                if(data.rank == 1){
                    this._img_bg.skin = GameResPath.GetIcon("autoBrush", "ui_activity_08")
                    this._img_rank.skin = GameResPath.GetIcon("autoBrush", "rank_icon_1")
                }else if(data.rank == 2){
                    this._img_bg.skin = GameResPath.GetIcon("autoBrush", "ui_activity_09")
                    this._img_rank.skin = GameResPath.GetIcon("autoBrush", "rank_icon_2")
                }else if(data.rank == 3){
                    this._img_bg.skin = GameResPath.GetIcon("autoBrush", "ui_activity_10")
                    this._img_rank.skin = GameResPath.GetIcon("autoBrush", "rank_icon_3")
                }
            }
            else{
                this._img_bg.skin = GameResPath.GetIcon("autoBrush", "ui_activity_11")
                this._img_rank.visible = false
                this._lb_rank.visible = true
                this._lb_rank.text = data.rank
            }
            let rank_type = this.auto_brush_model.GetRankType()
            let role_name 
            //榜单类型：0 本服 ； 1 跨服
            if(rank_type == 1){
                role_name = `S${data.server_num}.${data.role_name}`
            }
            else{
                role_name = data.role_name
            }
            this._lb_name.text = role_name
            this._lb_level.text = data.level
            this._lb_combat.text = data.combat
        }
    }

    public DeleteMe() {
        super.DeleteMe()
    }
    _img_bg: Laya.Image
    _img_rank: Laya.Image
    _lb_rank: Laya.Label
    _lb_name: Laya.Label
    _lb_combat: Laya.Label
    _lb_level: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._img_rank,
            this._lb_rank,
            this._lb_name,
            this._lb_combat,
            this._lb_level,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_rank",
                "_lb_rank",
                "_lb_name",
                "_lb_combat",
                "_lb_level",
            ])
    }
}
window["AutoBrushRankItem"] = AutoBrushRankItem
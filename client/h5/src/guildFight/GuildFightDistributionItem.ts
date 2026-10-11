import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"

export class GuildFightDistributionItem extends BaseItemRenderer {
    public WIDTH = 602
    public HEIGT = 83
    is_set
    public constructor(parent) {
        super()
        this.is_set=false
        this.base_file = "guildFight"
        this.layout_file = "GuildFightDistributionItem"
        this.load_callback = () => {

            // if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
            //     SetSizeDeltaX(this.pos_name, 100)
            // }


            if(!this.is_set){
                this.is_set=true
                this.SetData()
            }
        }
        this.Load()
    }

    public dataChanged() {
        if(!super.dataChanged())return

        if(this.is_loaded){
            this.is_set=true
            this.SetData()
        }else{
            this.is_set=false
        }

        
    }

    public SetData(){
        if(!this.data)return
        if (this.data && this.role_name) {
            this.role_name.text = this.data.name
            this.distribution.text = this.data.historical_donate
            this.pos_name.text = this.data.position_name
            this.fighting.text = this.data.combat_power
            let sp_name = this.selected == true && "com_ui_gx1" || "com_ui_gx"
            ResManager.GetInstance().SetImageSprite(this, this.toggleBtn, "common_asset", sp_name)
        }
    }

    _Image1: Laya.Image
    role_name: Laya.Label
    pos_name: Laya.Label
    fighting: Laya.Label
    distribution: Laya.Label
    _Group1: Laya.Box
    toggleBtn: Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this.role_name,
            this.pos_name,
            this.fighting,
            this.distribution,
            this._Group1,
            this.toggleBtn,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "role_name",
                "pos_name",
                "fighting",
                "distribution",
                "_Group1",
                "toggleBtn",
            ])
    }
}
window["GuildFightDistributionItem"] = GuildFightDistributionItem
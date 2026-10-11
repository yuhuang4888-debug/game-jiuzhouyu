import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { EyouAttentionItem } from "./EyouAttentionItem"

export class EyouAttentionView extends BaseItem1 {

    loop_mgr:LoopScrowViewMgr
    public constructor(parent?) {
        super(parent)
        this.base_file = "eyou"
        this.layout_file = "EyouAttentionView"
        this.load_callback = () => {
            this.LoadSuccess()
        }
    }

    public LoadSuccess(){
        //resource/game/eyou/texture/ui_img_ptgz_003.png
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("eyou", "ui_img_ptgz_003"))

        let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigEyouAttention
        if (cfg) {
            this.loop_mgr = new LoopScrowViewMgr()
            this.loop_mgr.SetData(this._list_item, EyouAttentionItem, cfg.follow, LoopScrCon.Vertical, 1)
        }
}

    public DeleteMe() {
        if(this.loop_mgr){
            this.loop_mgr.DeleteMe()
            this.loop_mgr = null
        }
        super.DeleteMe()
    }
    _img_bg: Laya.Image
    _list_item: Laya.List
    public GetComponents() {
        [
            this._img_bg,
            this._list_item,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_list_item",
            ])
    }
}
window["EyouAttentionView"] = EyouAttentionView
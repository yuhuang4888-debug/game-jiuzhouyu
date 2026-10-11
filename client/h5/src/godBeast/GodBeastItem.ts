import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EventName } from "../common/EventName";
import { ModuleType, RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { AtlasUrl, Util } from "../util/Util";

export class GodBeastItem extends BaseItemRenderer {
    public WIDTH = 182
    public HEIGT = 330

    private change = false;
    private _model: GodBeastModel;
    private _event_id;
    public constructor() {
        super()
        this.base_file = "godBeast"
        this.layout_file = "GodBeastItem"
        this._model = GodBeastModel.GetInstance()
        this.Load()
    }

    public load_callback() {
        this.InitEvent()
    }

    public createChildren() {
        super.createChildren()
    }

    protected Clear() {
        if (this._event_id) {
            this._model.UnBind(this._event_id)
            this._event_id = undefined
        }
        // ResManager.GetInstance().DestroyAllReferenceRes(this.hashCode)
    }

    protected InitEvent() {
        this._event_id = this._model.Bind(GodBeastEvent.SELECT_SBEAST_ITEM, (data) => {
            // if (this.data == data) {
            //     this.SetScale(1.2)
            // } else {
            //     this.SetScale(1)
            // }
            this.SetSelect()
        })

        this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (mType, rType) => {
            //替换和装备是一起判断的，只添加装备就行
            if (this.data){
                if ((ModuleType.BEAST_EQUIP == mType || ModuleType.BEAST_FIGHT == mType
                    || ModuleType.BEAST_STREN == mType) && rType == this.data.id) {
                    this.CheckRedStatus(this.data.id)
                }
            }
        })
    }

    protected SetScale(scale) {
        if (this.is_loaded){
            
        }
    }

    protected dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data
        let eudemons_item_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_eudemons_item", false)
        let cfg = this._model.GetBeastData(data.id, eudemons_item_cfg)
        if (!cfg) return
        this._lb_name.text = cfg.name
        this._lb_score.text = `评分:${data.score}`
        this._img_fight.visible = data.state == 2
        // let path = `resource/game/godBeast/icon/${cfg.icon_id}.png`
        // ResManager.GetInstance().SetTexture(this.base_item, this._img_icon, path)
        //this._img_icon.skin = AtlasUrl("godBeast", `icon_${cfg.icon_id}`)
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, `resource/game/godBeast/other/icon_${cfg.icon_id}.png`)
        Util.SetImageGray(this._img_icon, data.state == 0)
        this.SetSelect()
        // this.SetScale()
        this.CheckRedStatus(data.id)
        // this._reddot.visible = RedDotManager.GetInstance().CheckRedStatusMultModule(GodBeastModel.RED_BEAST)
    }
    public  SetSelect() {
        if (this.is_loaded && this.data){
            let select = this.data.id == this._model._select_beast_id
            this._img_select.visible = select
            let scale = select ? 1.1 : 1
            this.con.scaleX = this.con.scaleY = scale
        }
    }

    private CheckRedStatus(id) {
        let red1 = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BEAST_EQUIP, id)
        let red2 = RedDotManager.GetInstance().CheckRedStatus(ModuleType.BEAST_FIGHT, id)
        let red3 = RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.BEAST_STREN, id)
        let red4 = this._model.GetReplaceRedStatus(id)
        this._reddot.visible = red1 || red2 || red3 || red4
    }

    con: Laya.Box
    _img_icon: Laya.Image
    _img_select: Laya.Image
    _img_fight: Laya.Image
    _reddot: Laya.Image
    _lb_name: Laya.Label
    _lb_score: Laya.Label
    public GetComponents() {
        [
            this.con,
            this._img_icon,
            this._img_select,
            this._img_fight,
            this._reddot,
            this._lb_name,
            this._lb_score,
        ]
            = this.GetChildrenByNames([

                "con",
                "_img_icon",
                "_img_select",
                "_img_fight",
                "_reddot",
                "_lb_name",
                "_lb_score",
            ])
    }
}
window["GodBeastItem"] = GodBeastItem
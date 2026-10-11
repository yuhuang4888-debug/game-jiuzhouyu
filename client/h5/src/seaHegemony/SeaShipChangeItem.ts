import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class SeaShipChangeItem extends BaseItem1 {
    Dispose
    SetCur
    SetData
    SetSelect
    UiModel
    model_res
    need_fresh = false
    data
    public constructor(parent?) {
        super(parent)

        this.base_file = "seaHegemony"
        this.layout_file = "SeaShipChangeItem"
        let type = null
        let resMgr = ResManager.GetInstance()
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()

        this.load_callback = () => {

            this.BindEvent(local_modelIns, local_model.SELECT_SHIP, (shipType?) => {
                this.SetSelect(shipType == type)
            }
            )

            Util.AddClickEvent(this._box_click, () => {
                local_modelIns.Fire(local_model.SELECT_SHIP, type)
            }, this, true)


            if (this.need_fresh) {
                this.need_fresh = false
                this.SetData(this.data)
            }
        }

        this.SetData = (data?) => {
            this.data = data

            if (!this.is_loaded) {
                this.need_fresh = true
                return
            }

            type = data.id
            this.nameLb.text = data.name
            let cfg = resMgr.GetGameConfigFromCache(this, "ClientSeaHegemony", true)
            if (cfg) {
                this.disLb.text = cfg["shipDis"][type]
            }
            // let roleVo = RoleManager.GetInstance().GetMainRoleVo()
            this.SetCur()
            this.SetSelect(local_modelIns.shipType == type)

            let main_vo = RoleManager.GetInstance().GetMainRoleVo()
            let power_id = SeaHegemonyModel.GetInstance().actType == 1 ? main_vo.guild_id : main_vo.camp
            let [model_res, temp] = local_modelIns.GetShipModel(type,power_id,true)
            this.LoadModel(model_res,temp)
        }

        this.SetCur = () => {
            this._cur_tag.visible = local_modelIns.shipType == type
        }

        this.SetSelect = (boolean?) => {
            this.selectImg.visible = boolean
        }

        this.Dispose = () => {
            ResManager.GetInstance().ClearRoleMode(this.hashCode)
        }
    }


    public LoadModel(model_res?,tex_id?) {

        if (!this.model_res && this.model_res == model_res) {
            return
        }


        let data = {

            type: UI_MODEL_TYPE.MONSTER,
			clothe_res_id: model_res,
			layer_value: null,
			scale: 1.2,
			texture_id:tex_id,
			fashion_model_id: model_res,
			rotate: 125,
			skin_renderQueue: 2000,
			can_rotate: false,

        }
        ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)

        this.model_res = model_res
    }

    public DeleteMe() {

        this.Dispose()
        super.DeleteMe()
    }


    bg: Laya.Image
    bg2: Laya.Image
    _Image1: Laya.Image
    selectImg: Laya.Image
    nameLb: Laya.Label
    disLb: Laya.Label
    modelGp: Laya.Box
    _cur_tag: Laya.Box
    _cur_img: Laya.Image
    _cur_lb: Laya.Label
    _box_click: Laya.Box
    public GetComponents() {
        [
            this.bg,
            this.bg2,
            this._Image1,
            this.selectImg,
            this.nameLb,
            this.disLb,
            this.modelGp,
            this._cur_tag,
            this._cur_img,
            this._cur_lb,
            this._box_click,
        ]
            = this.GetChildrenByNames([

                "bg",
                "bg2",
                "_Image1",
                "selectImg",
                "nameLb",
                "disLb",
                "modelGp",
                "_cur_tag",
                "_cur_img",
                "_cur_lb",
                "_box_click",
            ])
    }
}
window["SeaShipChangeItem"] = SeaShipChangeItem
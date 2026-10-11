import { straightThroughStringTask } from "../../node_modules/simple-git/dist/src/lib/tasks/task";
import { BaseItem1 } from "../common/BaseItem1";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { UIToolTipMgr } from "../common/UIToolTipMgr";
import { FuncOpenId } from "../commonModel/FunctionOpenModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ColorUtil } from "../util/ColorUtil";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { Vector3 } from "../util/Vector3";

export class ActivityOverItem extends BaseItem1 {
    _show_box: Laya.Box
    _img_bg: Laya.Image
    _img_title: Laya.Image
    _gp_model: Laya.Box
    _lab_name: Laya.Label
    _btn_gain: Laya.Box

    _data
    res_mgr
    ill_cfg
    filter_cfg
    good_model
    need_refresh_data
    public constructor(parent) {
        super(parent);
        this.base_file = 'activityOverView';
        this.layout_file = 'ActivityOverItem';
        this.need_refresh_data = false
        this.res_mgr = ResManager.GetInstance()
        this.good_model = GoodsModel.GetInstance()
        this.load_callback = () => {
            this.ill_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigIllusionModel", true)
            this.filter_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigOverView", true)
            this.LoadSuccess()
            this.InitEvent()
        }
        this.DeleteMe = () => {
            super.DeleteMe()
        }
    }
    private InitEvent = () => {
        Util.AddClickEvent(this._btn_gain, () => {
            OpenFun.OpenFunHandler(`158_${this._data.b}_${this._data.show_id}`)
        }, this, true)

        Util.AddClickEvent(this._gp_model, () => {
            UIToolTipMgr.GetInstance().DefaultAppendTips(this._data.id, 0)
        }, this, true)
    }
    private LoadSuccess = () => {
        if (this.need_refresh_data) {
            this.UpdateInfo()
            this.need_refresh_data = false
        }
    }
    public SetData = (data) => {
        this._data = data
        if (this.is_loaded) {
            this.UpdateInfo()
        }
        else
            this.need_refresh_data = true
    }

    private UpdateInfo = () => {
        if (!this._data) {
            this._show_box.visible = false
            return
        }
        this._show_box.visible = true
        let good = this.good_model.GetGoodsBasicByTypeId(this._data.id)
        let bg_url = `ui_hdzl_00${good.color}`
        let title_url = `ui_hdzl_00${good.color}a`
        this.res_mgr.SetImageSprite(this, this._img_bg, "activityOverView", bg_url)
        this.res_mgr.SetImageSprite(this, this._img_title, "activityOverView", title_url)
        this._lab_name.text = this.filter_cfg[this._data.id] ? this.filter_cfg[this._data.id].name : good.goods_name
        // this._lab_name.color = ColorUtil.GetColorDark(good.color, false)
        this.SetModelInfo()
    }

    private SetModelInfo = () => {
        if (!this.ill_cfg) return
        let model_cfg = this.ill_cfg[this._data.id]
        let filter = this.filter_cfg[this._data.id]
        if (model_cfg) {
            this._gp_model.mouseEnabled = true
            let role_vo = RoleManager.GetInstance().mainRoleInfo
            let sex = role_vo.sex
            let model_res = 0
            let action_list = null
            let pos = null
            let scale = null
            let rotate = null
            let weapon_res
            let head_model_id, head_clothe_id
            let fashion_model_id, fashion_texture
            model_res = Number(model_cfg.model_res[sex])
            if (model_cfg.action_list) {
                action_list = model_cfg.action_list[sex]
            }
            if (model_cfg.pos) {
                pos = model_cfg.pos[sex]
            }
            if(filter.scale){
                scale = typeof (filter.scale) == "number" && filter.scale || filter.scale[sex]
            }else if (model_cfg.scale) {
                scale = typeof (model_cfg.scale) == "number" && model_cfg.scale || model_cfg.scale[sex]
            }

            if (model_cfg.rotate) {
                rotate = model_cfg.rotate
            }
            if (model_cfg.model_type == UI_MODEL_TYPE.ROLE) {
                if (model_cfg.type_id == 3) {
                    head_model_id = model_res
                    head_clothe_id = 0
                    model_res = role_vo.GetRoleClotheId()
                    fashion_model_id = model_res
                    fashion_texture = 0
                } else {
                    [head_model_id, head_clothe_id] = role_vo.GetRoleHeadId()
                }

                let head_data = role_vo.GetRoleHeadId()
                let data = {
                    career: role_vo.career,
                    sex: role_vo.sex,
                    clothe_res_id: model_res,
                    type: UI_MODEL_TYPE.MAINROLE,
                    layer_value: this.layer_value,
                    scale: scale || 0.75,
                    position: (pos && new Vector3(pos.x, pos.y, 0) || new Vector3(0, 1, 0)),
                    texture_id: fashion_texture,
                    fashion_model_id: fashion_model_id,
                    head_wear_id: head_model_id,
                    head_clothe_id: head_clothe_id,
                    hair_id: head_data[0],
                    layout_file: this.layout_file,
                    rotate: rotate,
                    action_name_list: action_list
                }
                ResManager.GetInstance().SetRoleModel(this, this._gp_model, data)
            } else {
                let type = model_cfg.model_type
                let wing_id
                if (model_cfg.model_type == UI_MODEL_TYPE.WEAPON) {
                    weapon_res = model_cfg.model_res[RoleManager.GetInstance().GetMainRoleVo().career]
                    model_res = weapon_res
                    pos = model_cfg.pos[RoleManager.GetInstance().GetMainRoleVo().career]
                } else if (model_cfg.model_type == UI_MODEL_TYPE.GOD) {
                    weapon_res = model_res
                }
                let data = {
                    type: type,
                    layer_value: this.layer_value,
                    scale: scale || 0.75,
                    position: pos && new Vector3(pos.x, pos.y, 0) || new Vector3(0, 1, 0),
                    clothe_res_id: model_res,
                    weapon_res_id: weapon_res,
                    wing_id: wing_id,
                    rotate: rotate,
                    action_name_list: action_list
                }
                ResManager.GetInstance().SetRoleModel(this, this._gp_model, data)
            }
        }
    }
    public DeleteMe() {
        this.ClearUIEffect(this._gp_model)
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this._show_box,
            this._img_bg,
            this._img_title,
            this._gp_model,
            this._lab_name,
            this._btn_gain,
        ]
            = this.GetChildrenByNames([

                "_show_box",
                "_img_bg",
                "_img_title",
                "_gp_model",
                "_lab_name",
                "_btn_gain",
            ])
    }
}
window["ActivityOverItem"] = ActivityOverItem
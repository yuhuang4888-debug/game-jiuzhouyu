import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { KfHolyAreaDefine } from "./KfHolyAreaDefine"

export class KfHolyAreaJumpView extends BaseView1 {
    scene_id
    model

    public constructor() {
        super()
        this.base_file = "kfHolyArea"
        this.layout_file = "KfHolyAreaJumpView"
        this.model = KfHolyAreaModel.GetInstance()
        this.layer_value = Enum_UILayer.Activity
        this.show_open_movie = true
        this.is_center = true
        this.destroy_imm = true
        this.change_scene_close = true
        this.use_background = true
        this.click_bg_toClose = true

        this.load_callback = () => {
            this.LoadSuccess()
        }

        this.destroy_callback = () => {
            this.Remove()
        }
    }

    public Open(...new_args) {
        if (new_args) {
            this.scene_id = new_args[0]
        }
        super.Open()
    }

    public LoadSuccess() {
        ResManager.GetInstance().SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIcon("kfHolyArea", "ui_holyland_73"));
        this.InitEvent()
        this.UpdateView()
    }

    public InitEvent() {
        Util.AddClickEvent(this._img_close, () => {
            this.Close()
        }, this, true)

        Util.AddClickEvent(this._gp_cenel, () => {
            this.Close()
        }, this, true)

        Util.AddClickEvent(this._gp_enter, () => {
            if (!this.model.IsCanAttackScene(this.scene_id)) {
				return
			}

			let enter_func = () => {
                this.model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28407, this.scene_id)
				this.model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28404, this.scene_id)
			}

			if (SceneManager.GetInstance().IsKfHolyAreaScene()) {
				let curr_scene_id = SceneManager.GetInstance().curr_scene_id
				if (curr_scene_id != this.scene_id) {
					Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
						enter_func()
					}, null, "离开", "取消")
				} 
			} else {
				if (SceneManager.GetInstance().IsNotChangeScene()) {
					Message.show("当前场景不能进入")
					return
				}
				if (!SceneManager.GetInstance().IsFieldScene()) {
					Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
						enter_func()
					}, null, "离开", "取消")
				} else {
					enter_func()
				}
			}

        }, this, true)
    }

    public UpdateView() {
        let scene_type = this.model.scene_id_type_map[this.scene_id];
        let sceneInfo = SceneManager.GetInstance().GetSceneInfo(this.scene_id)
        this.desc_lb.text = `当前场景已占领，${sceneInfo.name}通道已解锁，是否前往下一场景？`
        ResManager.GetInstance().SetImageSprite(this, this._img_scene, "kfHolyArea_asset", KfHolyAreaDefine.BuildRes[scene_type - 1], true)
        this._lb_scene_name.style.fontSize = 18
		this._lb_scene_name.style.valign = "center"
		this._lb_scene_name.style.color = "#661c1c"
		this._lb_scene_name.style.bold = true
		this._lb_scene_name.style.wordWrap = false
		this._lb_scene_name.style.leading = 1
        this._lb_scene_name.innerHTML = sceneInfo.name
    }

    private Remove(){

    }

    img_bg: Laya.Image
    desc_lb: Laya.Label
    _img_close: Laya.Image
    _gp_enter: Laya.Box
    _gp_cenel: Laya.Box
    desc_gp: Laya.Box
    _img_scene: Laya.Image
    _lb_scene_name: Laya.HTMLDivElement
    public GetComponents() {
        [
            this.img_bg,
            this.desc_lb,
            this._img_close,
            this._gp_enter,
            this._gp_cenel,
            this.desc_gp,
            this._img_scene,
            this._lb_scene_name,
        ]
            = this.GetChildrenByNames([

                "img_bg",
                "desc_lb",
                "_img_close",
                "_gp_enter",
                "_gp_cenel",
                "desc_gp",
                "_img_scene",
                "_lb_scene_name",
            ])
    }
}
window["KfHolyAreaJumpView"] = KfHolyAreaJumpView
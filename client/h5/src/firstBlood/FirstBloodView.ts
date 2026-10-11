import { BaseItem1 } from "../common/BaseItem1"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { Config } from "../common/Config"

export class FirstBloodView extends BaseItem1 {
  ClearModel
  CreateModel
  DeleteMe
  Emp_btn
  InitEvent
  LoadSuccess
  _Group1
  _Group2
  _Image1
  _Image10
  _Image11
  _Image111
  _Image2
  _Image3
  _Image4
  _Image5
  _Image6
  _Image7
  _Image8
  _Image9
  _Label1
  _Label2
  _btn
  _gp_effect
  _gp_model
  _gp_time
  _img
  _lb_desc
  _lb_name
  _lb_qq
  _lb_wx
  _model
  _sub_type
  _type
  labelDisplay
  modelY
  preload_client_config
  show_id
  show_model
  timer
  updateView


  public constructor(parent?) {
    super(parent)


    this.base_file = "firstBlood"
    this.layout_file = "FirstBloodView"
    this._model = CustomActivityModel.GetInstance()
    this.load_callback = () => {
      this.InitEvent()
      this.LoadSuccess()
    }

    this.preload_client_config = { "ClientFirstBloodShow": false }
    this.InitEvent = () => {
      Util.AddClickEvent(this._btn, () => {
        let act = this._model.GetActInfo(this._type, this._sub_type)
        if (act) {
          let list = ErlangParser.GetInstance().Parse(act.condition)[0]
          OpenFun.OpenFunHandler(28, list[2])
        }
      }
        , this, true)
      this.BindEvent(this._model, CustomActivityDefine.EVENT.ACT_TFIRST_BLOOD_RETURN, (act_data?) => {
        this.updateView(act_data)
      }
      )
    }

    this.DeleteMe = () => {
      if (this.timer) {
        this.timer.DeleteMe()
      }
      this.ClearModel()
      super.DeleteMe()
    }

    this.updateView = (act_data?) => {
      if (act_data) {
        let kill = act_data.status == 1
        // [ts2lua]lua中0和空字符串也是true，此处kill需要确认
        this._lb_name.text = (kill && (act_data.role_name) || ('首位击杀待定'))
      }
    }

    this.CreateModel = (mon_res?, ui_scale?) => {
      // if (this.show_model)
      // {
      //   this.show_model.DeleteMe()
      //   this.show_model = null
      // }
      // let pos = {x=0, y=50}
      // let scale = {x=ui_scale, y=ui_scale}
      // let list = [{type:UI_MODEL_TYPE.ROLE, id:mon_res}]
      // this.show_model =  new UIModelClass3D(this._gp_model, list, pos, scale, {"idle_3_0"}, 5)
    }

    this.ClearModel = () => {
      if (!this.show_model) {
        return
      }
      this.show_model.DeleteMe()
      this.show_model = null
    }

    this.LoadSuccess = () => {
      let act = this._model.GetActInfo(this._type, this._sub_type)
      if (act) {
        this.timer = this._model.LoadActTimer(this._gp_time, act.etime, 20, null, null, Enum_ColorUtil_Light.GREEN)
        this._lb_desc.fontSize=20
        this._lb_desc.color="#FFFFFF"
        this._lb_desc.innerHTML = Util.StrToHTML(act.desc)
        this._lb_desc.width=500
        let list = ErlangParser.GetInstance().Parse(act.condition)[0]
        let reward = list[3][0]
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img, "resource/game/goodsicon/" + reward[1] + ".png")
        this.modelY = this._gp_model.y
        // this.AddUIEffect("ui_huouye_frame", this._gp_effect, null, null, true)
        let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, list[2], false)
        if (bossVo) {
          this.CreateModel(bossVo.icon, 1.5)
        }
      }
      this._model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33223, this._type, this._sub_type)
    }


  }

  public CustomMehod(index?, args?) {


    if (this._type == null) {
      this._type = args.base_type
      this._sub_type = args.sub_type
      this.show_id = args.show_id
    }
  }

  public GetComponents() {
    [
      this._Image111,
      this._Image2,
      this._Image3,
      this._gp_model,
      this._Image4,
      this._lb_name,
      this._gp_time,
      this._Group1,
      this._Image5,
      this._Image6,
      this._Image7,
      this._lb_desc,
      this._Group2,
      this._Image8,
      this._Image9,
      this._Image10,
      this._Label1,
      this._lb_qq,
      this._Label2,
      this._lb_wx,
      this._btn,
      this._Image1,
      this.labelDisplay,
      this._img,
      this._gp_effect,
      this._Image11,
    ]
      = this.GetChildrenByNames([

        "_Image111",
        "_Image2",
        "_Image3",
        "_gp_model",
        "_Image4",
        "_lb_name",
        "_gp_time",
        "_Group1",
        "_Image5",
        "_Image6",
        "_Image7",
        "_lb_desc",
        "_Group2",
        "_Image8",
        "_Image9",
        "_Image10",
        "_Label1",
        "_lb_qq",
        "_Label2",
        "_lb_wx",
        "_btn",
        "_Image1",
        "labelDisplay",
        "_img",
        "_gp_effect",
        "_Image11",
      ])
  }
}
window["FirstBloodView"] = FirstBloodView
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { Scene } from "../scene/Scene"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Config } from "../common/Config";

export class SeaAssertTaskView extends BaseView1 {
    InitEvent
    initView

    _scmd

    public constructor() {
        super()

        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertTaskView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        let _model = SeaHegemonyModel.GetInstance()

        let goods_list = []
        let scene = Scene.GetInstance()
        let goods_model = GoodsModel.GetInstance()
        this.load_callback = () => {

            this.InitEvent()
        }

        this.preload_server_config = {
            config_sea_craft_daily_brick: false,
            config_sea_craft_daily_exp: false
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this._btn_con, () => {
                    let LogicRealRatio_X = SceneObj.GetLogicRealRatio().x
                    let LogicRealRatio_Y = SceneObj.GetLogicRealRatio().y
                    let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv;
                    // [ts2lua]kv_cfg下标访问可能不正确
                    let pos_cfg = kv_cfg["task_start_pos"].value
                    let pos_list = JSON.parse(pos_cfg)
                    scene.MainRoleMove(
                        new Vector2(pos_list[0] / LogicRealRatio_X, pos_list[1] / LogicRealRatio_Y),
                        3, () => {
                            _model.OpenTaskView()
                        }
                    )
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._btn_ok, () => {
                    this.Close()
                },
                this,
                true
            )
        }

        this.open_callback = () => {
            ResManager.GetInstance().SetTexture(this, this._bg2, GameResPath.GetIconOtherPath("topPk", "com_up_bg1"))
            this.initView()
        }

        this.close_callback = () => {
            _model.assertTaskViewOpen = false
            for (let key in goods_list) {

                // [ts2lua]goods_list下标访问可能不正确
                let item = goods_list[key]
                item.DeleteMe()
            }
            goods_list = []
        }

        this.initView = () => {
            this._lb_time.style.fontSize = 22;
            this._lb_time.style.color = '#FFFFFF';
            this._lb_time.style.width = 408;

            let kv_cfg = Config.PRELOAD_SERVER_CONFIG.config_sea_craft_daily_kv;
            // [ts2lua]kv_cfg下标访问可能不正确
            let max = kv_cfg["defend_count"].value
            let data = _model.assertSceneData
            // [ts2lua]lua中0和空字符串也是true，此处data.carry_count >= max需要确认
            let color = (data.carry_count >= max && (Enum_ColorUtil_Light.RED) || ("'#0A953E'"))
            this._lb_time.innerHTML = Util.StrToHTML("当前搬运次数：" + HtmlColorTxt(((max - data.carry_count) + "/" + max), color))
            let brick_config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_craft_daily_brick", false)
            let exp_config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_craft_daily_exp", false)
            let baseExp = _model.assertTaskExp(exp_config)
            let view_data = _model.getAssertViewData(_model.assertSceneData.sea_id);
            let index = 0;
            let reward_list = (this._scmd && this._scmd[0]) && this._scmd[0].reward;
            for (let key in reward_list) {
                // [ts2lua]reward_list下标访问可能不正确
                let reward = reward_list[key]
                // [ts2lua]goods_list下标访问可能不正确
                let item = goods_list[index]
                if (!item) {
                    item = new BaseAwardItem(this._gp_reward)
                    item.Load()
                    item.SetScale(0.7)
                    table.insert(goods_list, item)
                }
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward.style, reward.typeId)
                let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
                if (goods_vo) {
                    item.SetData(goods_vo.type_id, reward.count)
                }
                index = index + 1
            }
        }
    }

    public Open(...new_args) {

        let parms = new_args
        SeaHegemonyModel.GetInstance().assertTaskViewOpen = true
        this._scmd = parms
        super.Open();
    }

    _bg2: Laya.Image
    _Image11: Laya.Image
    _gp_reward: Laya.HBox
    _lb_time: Laya.HTMLDivElement
    _btn_con: Laya.Box
    _Image1: Laya.Image
    labelDisplay1: Laya.Label
    _btn_ok: Laya.Box
    _Image111: Laya.Image
    labelDisplay: Laya.Label
    public GetComponents() {
        [
            this._bg2,
            this._Image11,
            this._gp_reward,
            this._lb_time,
            this._btn_con,
            this._Image1,
            this.labelDisplay1,
            this._btn_ok,
            this._Image111,
            this.labelDisplay,
        ]
            = this.GetChildrenByNames([

                "_bg2",
                "_Image11",
                "_gp_reward",
                "_lb_time",
                "_btn_con",
                "_Image1",
                "labelDisplay1",
                "_btn_ok",
                "_Image111",
                "labelDisplay",
            ])
    }
}
window["SeaAssertTaskView"] = SeaAssertTaskView